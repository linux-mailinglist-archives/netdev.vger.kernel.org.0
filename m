Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB94F62AF12
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiKOXFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiKOXE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:04:57 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4182C64A;
        Tue, 15 Nov 2022 15:04:52 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AFN4UHC879484;
        Wed, 16 Nov 2022 00:04:30 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AFN4UHC879484
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668553470;
        bh=wWl6IGieabcHk5tcHcU/MsR2mb9RDon3aUzEJtVqeq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PmzrWsEvyzAh4WoATgWwdGGDZfr+zybW4A2FJHXK00jFiE60njJi5OSYWnsQIbIcY
         UMeGxWPsVO11YwO3fqnP+PQh61G+v7AVgCfRjpiqHUGkvrP7eb+s6Ov8ittZxRUdB4
         fPL8ajTQCxr8KNIqkEJKt1nGG/C1EL1dXPfyt12E=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AFN4TBr879483;
        Wed, 16 Nov 2022 00:04:29 +0100
Date:   Wed, 16 Nov 2022 00:04:29 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mdf@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] net: nixge: fix tx queue handling
Message-ID: <Y3Qa/fjjMhctsE5w@electric-eye.fr.zoreil.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
 <1668525024-38409-4-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668525024-38409-4-git-send-email-zhangchangzhong@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> :
> Currently the driver check for available space at the beginning of
> nixge_start_xmit(), and when there is not enough space for this packet,
> it returns NETDEV_TX_OK, which casues packet loss and memory leak.
> 
> Instead the queue should be stopped after the packet is added to the BD
> when there may not be enough space for next packet. In addition, the
> queue should be wakeup only if there is enough space for a packet with
> max frags.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/ni/nixge.c | 54 +++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
> index 91b7ebc..3776a03 100644
> --- a/drivers/net/ethernet/ni/nixge.c
> +++ b/drivers/net/ethernet/ni/nixge.c
[...]
>  static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
> @@ -518,10 +523,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>  	cur_p = &priv->tx_bd_v[priv->tx_bd_tail];
>  	tx_skb = &priv->tx_skb[priv->tx_bd_tail];
>  
> -	if (nixge_check_tx_bd_space(priv, num_frag + 1)) {
> -		if (!netif_queue_stopped(ndev))
> -			netif_stop_queue(ndev);
> -		return NETDEV_TX_OK;
> +	if (unlikely(nixge_check_tx_bd_space(priv, num_frag + 1))) {
> +		/* Should not happen as last start_xmit call should have
> +		 * checked for sufficient space and queue should only be
> +		 * woken when sufficient space is available.
> +		 */

Almost. IRQ triggering after nixge_start_xmit::netif_stop_queue and
before nixge_start_xmit::smp_mb may wrongly wake queue.

Call me timorous but I would feel more confortable if this code could
be tested on real hardware before being fed into -net.

-- 
Ueimor
