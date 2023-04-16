Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99A76E3765
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjDPKYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjDPKY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4C9ED8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 03:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685F5612DD
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 10:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F9FC433EF;
        Sun, 16 Apr 2023 10:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681640462;
        bh=d8TIQoIcn8/MxqFJ5KrP+x9b8xOC/JyBzSVEYYjhfN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VziPoqes+Nbg6n/ZxeZTN15cBoo9mzkSD3vl6lTOMDRhpMs75pCDtVMqyOXiNk9lh
         rsme3GUqKBb6RVadYUkB+B4Lm7YJoMFot5hgzRoHbgch4dAozzoxcF2AnXElXUJvu/
         9tkz2AK1CvT2D/Hu5WEfLd3trL5fhkkKy5NPEiMQq/fQvaREbDzGR/5eMo0Q5QinUN
         KKtIkzynKLaE5peEW2UYx5fflvRx/PNZTlCHVotWSMMBYtT3jbLopxMJ0scpfKOXhl
         RLUbubAfjBjVtejdr74HV8fFki3ISg9aOvHyCusf+xgWODSR9g54j5Xng+L7/6YG/h
         rpgdiZTUCZl7Q==
Date:   Sun, 16 Apr 2023 13:20:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Message-ID: <20230416102058.GC15386@unreal>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
 <69c2eec2-d82c-290a-d6ce-fba64afb32c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c2eec2-d82c-290a-d6ce-fba64afb32c6@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 09:22:11AM +0200, Heiner Kallweit wrote:
> Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
> to simplify the code. Whilst at it, set the tx queue start threshold to
> twice the stop threshold. Before values were the same, resulting in
> stopping/starting the queue more often than needed.
> 
> v2:
> - ring doorbell if queue was stopped

Please put changelog under "---" markup, below tags section.

Thanks

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 39 +++++++----------------
>  1 file changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 9f8357bbc..fff44d46b 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -30,6 +30,7 @@
>  #include <linux/ipv6.h>
>  #include <asm/unaligned.h>
>  #include <net/ip6_checksum.h>
> +#include <net/netdev_queues.h>
>  
>  #include "r8169.h"
>  #include "r8169_firmware.h"
> @@ -68,6 +69,8 @@
>  #define NUM_RX_DESC	256	/* Number of Rx descriptor registers */
>  #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
>  #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
> +#define R8169_TX_STOP_THRS	(MAX_SKB_FRAGS + 1)
> +#define R8169_TX_START_THRS	(2 * R8169_TX_STOP_THRS)
>  
>  #define OCP_STD_PHY_BASE	0xa400
>  
> @@ -4162,13 +4165,9 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  	return true;
>  }
>  
> -static bool rtl_tx_slots_avail(struct rtl8169_private *tp)
> +static unsigned int rtl_tx_slots_avail(struct rtl8169_private *tp)
>  {
> -	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
> -					- READ_ONCE(tp->cur_tx);
> -
> -	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
> -	return slots_avail > MAX_SKB_FRAGS;
> +	return READ_ONCE(tp->dirty_tx) + NUM_TX_DESC - READ_ONCE(tp->cur_tx);
>  }
>  
>  /* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
> @@ -4245,27 +4244,10 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>  
>  	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
>  
> -	stop_queue = !rtl_tx_slots_avail(tp);
> -	if (unlikely(stop_queue)) {
> -		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
> -		 * not miss a ring update when it notices a stopped queue.
> -		 */
> -		smp_wmb();
> -		netif_stop_queue(dev);
> -		/* Sync with rtl_tx:
> -		 * - publish queue status and cur_tx ring index (write barrier)
> -		 * - refresh dirty_tx ring index (read barrier).
> -		 * May the current thread have a pessimistic view of the ring
> -		 * status and forget to wake up queue, a racing rtl_tx thread
> -		 * can't.
> -		 */
> -		smp_mb__after_atomic();
> -		if (rtl_tx_slots_avail(tp))
> -			netif_start_queue(dev);
> -		door_bell = true;
> -	}
> -
> -	if (door_bell)
> +	stop_queue = !netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
> +						R8169_TX_STOP_THRS,
> +						R8169_TX_START_THRS);
> +	if (door_bell || stop_queue)
>  		rtl8169_doorbell(tp);
>  
>  	return NETDEV_TX_OK;
> @@ -4400,7 +4382,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  		 * ring status.
>  		 */
>  		smp_store_mb(tp->dirty_tx, dirty_tx);
> -		if (netif_queue_stopped(dev) && rtl_tx_slots_avail(tp))
> +		if (netif_queue_stopped(dev) &&
> +		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
>  			netif_wake_queue(dev);
>  		/*
>  		 * 8168 hack: TxPoll requests are lost when the Tx packets are
> -- 
> 2.40.0
> 
> 
