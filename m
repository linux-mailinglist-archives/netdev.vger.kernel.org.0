Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877DA34124
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFDIHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:07:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:16425 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfFDIHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 04:07:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 01:07:02 -0700
X-ExtLoop1: 1
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 01:06:58 -0700
Subject: Re: [RFC PATCH bpf-next 2/4] libbpf: check for channels.max_{t,r}x in
 xsk_get_max_queues
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-3-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <87505132-2f1b-dc4d-5c1f-d52fc8dca647@intel.com>
Date:   Tue, 4 Jun 2019 10:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603131907.13395-3-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> When it comes down to ethtool's get channels API, various drivers are
> reporting the queue count in two ways - they are setting max_combined or
> max_tx/max_rx fields. When creating the eBPF maps for xsk socket, this
> API is used so that we have an entries in maps per each queue.
> In case where driver (mlx4, ice) reports queues in max_tx/max_rx, we end
> up with eBPF maps with single entries, so it's not possible to attach an
> AF_XDP socket onto queue other than 0 - xsk_set_bpf_maps() would try to
> call bpf_map_update_elem() with key set to xsk->queue_id.
> 
> To fix this, let's look for channels.max_{t,r}x as well in
> xsk_get_max_queues.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   tools/lib/bpf/xsk.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 57dda1389870..514ab3fb06f4 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -339,21 +339,23 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>   	ifr.ifr_data = (void *)&channels;
>   	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
>   	err = ioctl(fd, SIOCETHTOOL, &ifr);
> -	if (err && errno != EOPNOTSUPP) {
> -		ret = -errno;
> -		goto out;
> -	}
> +	close(fd);
> +
> +	if (err && errno != EOPNOTSUPP)
> +		return -errno;
>   
> -	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
> +	if (channels.max_combined)
> +		ret = channels.max_combined;
> +	else if (channels.max_rx && channels.max_tx)
> +		ret = min(channels.max_rx, channels.max_tx);

Hmm, do we really need to look at max_tx? For each Rx, there's (usually)
an XDP ring.

OTOH, when AF_XDP ZC is not implemented, it uses the skb path...

> +	else if (channels.max_combined == 0 || errno == EOPNOTSUPP)
>   		/* If the device says it has no channels, then all traffic
>   		 * is sent to a single stream, so max queues = 1.
>   		 */
>   		ret = 1;
>   	else
> -		ret = channels.max_combined;
> +		ret = -1;
>   
> -out:
> -	close(fd);
>   	return ret;
>   }
>   
> 
