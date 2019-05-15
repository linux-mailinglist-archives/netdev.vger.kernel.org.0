Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20D41E9E4
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfEOIMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfEOIMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 04:12:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE9F73001C60;
        Wed, 15 May 2019 08:12:51 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77C6460166;
        Wed, 15 May 2019 08:12:49 +0000 (UTC)
Subject: Re: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
To:     Stephen Hemminger <stephen@networkplumber.org>, kys@microsoft.com,
        haiyangz@microsoft.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
 <20190515080319.15514-2-sthemmin@microsoft.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <096b0f82-707c-fd35-e3ce-3c266a606af5@redhat.com>
Date:   Wed, 15 May 2019 16:12:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515080319.15514-2-sthemmin@microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 15 May 2019 08:12:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/15 下午4:03, Stephen Hemminger wrote:
> XDP generic does not work correctly with the Hyper-V/Azure netvsc
> device because of packet processing order. Only packets on the
> synthetic path get seen by the XDP program. The VF device packets
> are not seen.
>
> By the time the packets that arrive on the VF are handled by
> netvsc after the first pass of XDP generic (on the VF) has already
> been done.
>
> A fix for the netvsc device is to do this in the VF packet handler.
> by directly calling do_xdp_generic() if XDP program is present
> on the parent device.
>
> A riskier but maybe better alternative would be to do this netdev core
> code after the receive handler is invoked (if RX_HANDLER_ANOTHER
> is returned).


Something like what I propose at 
https://lore.kernel.org/patchwork/patch/973819/ ?

It belongs to a series that try to make XDP (both native and generic) 
work for stacked device. But for some reason (probably performance), the 
maintainer seems not like the idea.

Maybe it's time to reconsider that?

Thanks


>
> Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>   drivers/net/hyperv/netvsc_drv.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 06393b215102..bb0fc1869bde 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1999,9 +1999,15 @@ static rx_handler_result_t netvsc_vf_handle_frame(struct sk_buff **pskb)
>   	struct net_device_context *ndev_ctx = netdev_priv(ndev);
>   	struct netvsc_vf_pcpu_stats *pcpu_stats
>   		 = this_cpu_ptr(ndev_ctx->vf_stats);
> +	struct bpf_prog *xdp_prog;
>   
>   	skb->dev = ndev;
>   
> +	xdp_prog = rcu_dereference(ndev->xdp_prog);
> +	if (xdp_prog &&
> +	    do_xdp_generic(xdp_prog, skb) != XDP_PASS)
> +		return RX_HANDLER_CONSUMED;
> +
>   	u64_stats_update_begin(&pcpu_stats->syncp);
>   	pcpu_stats->rx_packets++;
>   	pcpu_stats->rx_bytes += skb->len;
