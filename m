Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00A064958
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGJPHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:07:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54238 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfGJPHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:07:51 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0D9D3A4007C;
        Wed, 10 Jul 2019 15:07:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 10 Jul
 2019 08:07:45 -0700
Subject: Re: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
To:     Sabrina Dubroca <sd@queasysnail.net>, <netdev@vger.kernel.org>
CC:     Andreas Steinmetz <ast@domdv.de>
References: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
Date:   Wed, 10 Jul 2019 16:07:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24750.005
X-TM-AS-Result: No-9.745300-4.000000-10
X-TMASE-MatchedRID: +f/wAVSGjuhq0U6EhO9EE/ZvT2zYoYOwC/ExpXrHizxpsnGGIgWMmbNt
        CD9U3Mz4xx7AWwLSAoGwXW/a8rM+qsWKJ8at6hW2KpEngz2rs6/2hUAowGKipx3RY4pGTCyHAST
        qAU9J9Jnt+gsCkf54Hh9RiBf6acKH9I/u2MpVvhovLP1C8DIeOgX/tYZf6r/wpDUvbsJbUUSZ1G
        XCSPIS5cIyVDXZqBPSYMIDOhn95YhoX2dAudCP2xouoVvF2i0ZS/9ltW9tJRsJDBxBtHbc45XBz
        AslgCOzlpKpNiL4LlowG3R/Nk2IUjtJvcCyUX0k/HTKStsDGMJ9LQinZ4QefNQdB5NUNSsi4Hwn
        1pZzW/9XKaQsz6vtVMprJP8FBOIa+R+RQpLXfx43lzsfLQ+x2SVtsEoDMkZT9mWN8hBIuNgmsM6
        lC53iBcC+ksT6a9fy
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.745300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24750.005
X-MDID: 1562771270-rDPR1z5JqQqy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 14:52, Sabrina Dubroca wrote:
> When __netif_receive_skb_core handles a shared skb, it can be
> reallocated in a few different places:
>  - the device's rx_handler
>  - vlan_do_receive
>  - skb_vlan_untag
>
> To deal with that, rx_handlers and vlan_do_receive get passed a
> reference to the skb, and skb_vlan_untag just returns the new
> skb. This was not a problem until commit 88eb1944e18c ("net: core:
> propagate SKB lists through packet_type lookup"), which moved the
> final handling of the skb via pt_prev out of
> __netif_receive_skb_core. After this commit, when the skb is
> reallocated by __netif_receive_skb_core, KASAN reports a
> use-after-free on the old skb:
>
> BUG: KASAN: use-after-free in __netif_receive_skb_one_core+0x15c/0x180
> Call Trace:
>  <IRQ>
>  __netif_receive_skb_one_core+0x15c/0x180
>  process_backlog+0x1b5/0x630
>  ? net_rx_action+0x247/0xd00
>  net_rx_action+0x3fa/0xd00
>  ? napi_complete_done+0x360/0x360
>  __do_softirq+0x257/0xa0b
>  do_softirq_own_stack+0x2a/0x40
>  </IRQ>
>  ? __dev_queue_xmit+0x12ba/0x3120
>  do_softirq+0x5d/0x60
>  [...]
>
> Allocated by task 505:
>  __kasan_kmalloc.constprop.0+0xd6/0x140
>  kmem_cache_alloc+0xd4/0x2e0
>  skb_clone+0x106/0x300
>  deliver_clone+0x3f/0xa0
>  maybe_deliver+0x1c0/0x2b0
>  br_flood+0xd4/0x320
>  br_dev_xmit+0xbc0/0x1080
>  dev_hard_start_xmit+0x139/0x750
>  __dev_queue_xmit+0x24eb/0x3120
>  packet_sendmsg+0x1bfa/0x50e0
>  [...]
>
> Freed by task 505:
>  __kasan_slab_free+0x138/0x1e0
>  kmem_cache_free+0xa2/0x2e0
>  macsec_handle_frame+0xa24/0x2e60
>  __netif_receive_skb_core+0xe2a/0x2c90
>  __netif_receive_skb_one_core+0x96/0x180
>  process_backlog+0x1b5/0x630
>  net_rx_action+0x3fa/0xd00
>  __do_softirq+0x257/0xa0b
>
> The solution is to pass a reference to the skb to
> __netif_receive_skb_core, as we already do with the rx_handlers, so
> that its callers use the new skb.
>
> Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
> Reported-by: Andreas Steinmetz <ast@domdv.de>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  net/core/dev.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d6edd218babd..0bbf6d2a9c32 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4809,11 +4809,12 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
>  	return 0;
>  }
>  
> -static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> +static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>  				    struct packet_type **ppt_prev)
>  {
>  	struct packet_type *ptype, *pt_prev;
>  	rx_handler_func_t *rx_handler;
> +	struct sk_buff *skb = *pskb;
Would it not be simpler just to change all users of skb to *pskb?
Then you avoid having to keep doing "*pskb = skb;" whenever skb changes
 (with concomitant risk of bugs if one gets missed).

-Ed
