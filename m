Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBBB34122
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfFDIGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:06:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:6995 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfFDIGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 04:06:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 01:06:41 -0700
X-ExtLoop1: 1
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 01:06:37 -0700
Subject: Re: [RFC PATCH bpf-next 1/4] libbpf: fill the AF_XDP fill queue
 before bind() call
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-2-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <76bc124c-46ed-f0a6-315e-1600c837aea0@intel.com>
Date:   Tue, 4 Jun 2019 10:06:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603131907.13395-2-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> Let's get into the driver via ndo_bpf with command set to XDP_SETUP_UMEM
> with fill queue that already contains some available entries that can be
> used by Rx driver rings. Things worked in such way on old version of
> xdpsock (that lacked libbpf support) and there's no particular reason
> for having this preparation done after bind().
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
> ---
>   samples/bpf/xdpsock_user.c | 15 ---------------
>   tools/lib/bpf/xsk.c        | 19 ++++++++++++++++++-
>   2 files changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index d08ee1ab7bb4..e9dceb09b6d1 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -296,8 +296,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
>   	struct xsk_socket_config cfg;
>   	struct xsk_socket_info *xsk;
>   	int ret;
> -	u32 idx;
> -	int i;
>   
>   	xsk = calloc(1, sizeof(*xsk));
>   	if (!xsk)
> @@ -318,19 +316,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
>   	if (ret)
>   		exit_with_error(-ret);
>   
> -	ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> -				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
> -				     &idx);
> -	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> -		exit_with_error(-ret);
> -	for (i = 0;
> -	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> -		     XSK_UMEM__DEFAULT_FRAME_SIZE;
> -	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
> -		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
> -	xsk_ring_prod__submit(&xsk->umem->fq,
> -			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
> -
>   	return xsk;
>   }
>   
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 38667b62f1fe..57dda1389870 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -529,7 +529,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>   	struct xdp_mmap_offsets off;
>   	struct xsk_socket *xsk;
>   	socklen_t optlen;
> -	int err;
> +	int err, i;
> +	u32 idx;
>   
>   	if (!umem || !xsk_ptr || !rx || !tx)
>   		return -EFAULT;
> @@ -632,6 +633,22 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>   	}
>   	xsk->tx = tx;
>   
> +	err = xsk_ring_prod__reserve(umem->fill,
> +				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
> +				     &idx);
> +	if (err != XSK_RING_PROD__DEFAULT_NUM_DESCS) {
> +		err = -errno;
> +		goto out_mmap_tx;
> +	}
> +
> +	for (i = 0;
> +	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> +		     XSK_UMEM__DEFAULT_FRAME_SIZE;
> +	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
> +		*xsk_ring_prod__fill_addr(umem->fill, idx++) = i;
> +	xsk_ring_prod__submit(umem->fill,
> +			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
> +

Here, entries are added to the umem fill ring regardless if Rx is being
used or not. For a Tx only setup, this is not what we want, right?

Thinking out loud here; Now libbpf is making the decision which umem
entries that are added to the fill ring. The sample application has this
(naive) scheme. I'm not sure that all applications would like that
policy. What do you think?

>   	sxdp.sxdp_family = PF_XDP;
>   	sxdp.sxdp_ifindex = xsk->ifindex;
>   	sxdp.sxdp_queue_id = xsk->queue_id;
> 
