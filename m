Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64862B8BC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiKPKer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiKPKcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:32:41 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234B6550;
        Wed, 16 Nov 2022 02:28:28 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AGARw6D892604;
        Wed, 16 Nov 2022 11:27:58 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AGARw6D892604
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668594479;
        bh=4EJYbote49QLZzbD6v8Bx/T1+B6bUVPK/0OQXhufnCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eL6p3lCVw2j4oqUlhIGY8quZMF3jef02Xb3qL92MylAFpQV1tg3FfXLMVRiSIanrh
         WIOEY4ihjo80RbGE4yc5kXHL2FtFmTc1WLVkigbenxdMUXXNa/8bweUTODaO5c6iRd
         tJPbHbzNIoYwfCgUM3sS7brzqHT3heRZDPSoRMQ8=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AGARwbP892603;
        Wed, 16 Nov 2022 11:27:58 +0100
Date:   Wed, 16 Nov 2022 11:27:58 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mdf@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] net: nixge: fix tx queue handling
Message-ID: <Y3S7LpbVaTRdKmLl@electric-eye.fr.zoreil.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
 <1668525024-38409-4-git-send-email-zhangchangzhong@huawei.com>
 <Y3Qa/fjjMhctsE5w@electric-eye.fr.zoreil.com>
 <c476086a-14ce-6e47-8183-def31d569ec6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c476086a-14ce-6e47-8183-def31d569ec6@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> :
> On 2022/11/16 7:04, Francois Romieu wrote:
> > Zhang Changzhong <zhangchangzhong@huawei.com> :
[...]
> >> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
> >> index 91b7ebc..3776a03 100644
> >> --- a/drivers/net/ethernet/ni/nixge.c
> >> +++ b/drivers/net/ethernet/ni/nixge.c
> > [...]
> >>  static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
> >> @@ -518,10 +523,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
> >>  	cur_p = &priv->tx_bd_v[priv->tx_bd_tail];
> >>  	tx_skb = &priv->tx_skb[priv->tx_bd_tail];
> >>  
> >> -	if (nixge_check_tx_bd_space(priv, num_frag + 1)) {
> >> -		if (!netif_queue_stopped(ndev))
> >> -			netif_stop_queue(ndev);
> >> -		return NETDEV_TX_OK;
> >> +	if (unlikely(nixge_check_tx_bd_space(priv, num_frag + 1))) {
> >> +		/* Should not happen as last start_xmit call should have
> >> +		 * checked for sufficient space and queue should only be
> >> +		 * woken when sufficient space is available.
> >> +		 */
> > 
> > Almost. IRQ triggering after nixge_start_xmit::netif_stop_queue and
> > before nixge_start_xmit::smp_mb may wrongly wake queue.
> > 
> 
> I don't know what you mean by "wronly wake queue". The queue is woken
> only when there is sufficient for next packet.

Between nixge_start_xmit::netif_stop_queue and nixge_start_xmit::smp_mb,
"next" packet is current packet in hard_start_xmit. However said current
packet may not be accounted for in the IRQ context transmit completion
handler.

[nixge_start_xmit]

        ++priv->tx_bd_tail;
        priv->tx_bd_tail %= TX_BD_NUM;

	/* Stop queue if next transmit may not have space */
	if (nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1)) {
                netif_stop_queue(ndev);

Which value does [nixge_start_xmit_done] read as priv->tx_bd_tail at
this point ? The value set a few lines above or some older value ?

		/* Matches barrier in nixge_start_xmit_done */
		smp_mb();

		/* Space might have just been freed - check again */
		if (!nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1))
			netif_wake_queue(ndev);
	}

-- 
Ueimor
