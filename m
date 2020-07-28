Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3D2303AC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgG1HQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:16:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:1255 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgG1HQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:16:01 -0400
IronPort-SDR: /NOYvio80/6RfPDkHCM4kPFB5BpRiPq5kzFEWNEmKEjT0un4mQS92TTWatFiflPrzskf5lwMKA
 iAwYTIdwY7Sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="148628156"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="148628156"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 00:16:01 -0700
IronPort-SDR: GaTo22bFZpUx5zGcpHhCI1yF93CCaQsSIrhpbSqa32Oziud8zuw8c26oeqan2x6aQ2u05JjSFG
 twrAm9n6Uyng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="322092600"
Received: from nheyde-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.223])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jul 2020 00:15:43 -0700
Subject: Re: [PATCH bpf-next v4 11/14] xsk: add shared umem support between
 devices
To:     Magnus Karlsson <magnus.karlsson@intel.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-12-git-send-email-magnus.karlsson@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1806b8f0-8205-1e1a-f897-3b09cbf92c4c@intel.com>
Date:   Tue, 28 Jul 2020 09:15:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595307848-20719-12-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-21 07:04, Magnus Karlsson wrote:
> Add support to share a umem between different devices. This mode
> can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
> sharing was only supported within the same device. Note that when
> sharing a umem between devices, just as in the case of sharing a
> umem between queue ids, you need to create a fill ring and a
> completion ring and tie them to the socket (with two setsockopts,
> one for each ring) before you do the bind with the
> XDP_SHARED_UMEM flag. This so that the single-producer
> single-consumer semantics of the rings can be upheld.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Björn Töpel <bjorn.topel@intel.com>


> ---
>   net/xdp/xsk.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index e897755..ec2a2df 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -701,14 +701,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			sockfd_put(sock);
>   			goto out_unlock;
>   		}
> -		if (umem_xs->dev != dev) {
> -			err = -EINVAL;
> -			sockfd_put(sock);
> -			goto out_unlock;
> -		}
>   
> -		if (umem_xs->queue_id != qid) {
> -			/* Share the umem with another socket on another qid */
> +		if (umem_xs->queue_id != qid || umem_xs->dev != dev) {
> +			/* Share the umem with another socket on another qid
> +			 * and/or device.
> +			 */
>   			xs->pool = xp_create_and_assign_umem(xs,
>   							     umem_xs->umem);
>   			if (!xs->pool) {
> 
