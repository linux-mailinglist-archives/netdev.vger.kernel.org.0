Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F564CE597
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiCEPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 10:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiCEPmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 10:42:06 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B9B23BEF;
        Sat,  5 Mar 2022 07:41:15 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:105:465:1:3:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4K9ppt318Cz9sqb;
        Sat,  5 Mar 2022 16:41:10 +0100 (CET)
Message-ID: <3f3957dd-5aae-ca0d-d487-fe062d989980@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1646494868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4p4r1LsqVbNtuaN4+UAKCcBfS2bVk6T+s/lsV//2jnY=;
        b=jskBSbhBeHHTqsPz5DQ9MKbWrOEdKZ3J+YdfOc3Sj60U/2/Yi9Ay9t3kVCAr9/944aOT41
        2OMo9xKrCejSK2kES1NAVzJBvGR2yy97HHXSRmR9gVbfS5nS7m5Vc8LNebdefDQHXTpkEJ
        ivzogByp9ODBStm3y9J4315uX7dM2Xt7qlUyAGMqQgYpzOKuTygA0HBpsPLtzE/iKhcOaH
        0vZ98dgFCh8jN/zicOU95GAyuuAcbh278bnnpxsL8cz6XByVXUjsttglibq0+yFFExcKJ9
        DMGny5/+gss8Sir9FRSq8TO7TudU0GXMG3iMm8e6mADcZr/y7r6I01SaOx43AA==
Date:   Sat, 5 Mar 2022 16:41:00 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net] net: lantiq_xrx200: fix use after free bug
Content-Language: en-US
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <20220305112039.3989-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <20220305112039.3989-1-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/22 12:20, Aleksander Jan Bajkowski wrote:
> The skb->len field is read after the packet is sent to the network
> stack. In the meantime, skb can be freed. This patch fixes this bug.
> 
> Fixes: c3e6b2c35b34 ("net: lantiq_xrx200: add ingress SG DMA support")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/ethernet/lantiq_xrx200.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 41d11137cde0..5712c3e94be8 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -260,9 +260,9 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>   
>   	if (ctl & LTQ_DMA_EOP) {
>   		ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
> -		netif_receive_skb(ch->skb_head);
>   		net_dev->stats.rx_packets++;
>   		net_dev->stats.rx_bytes += ch->skb_head->len;
> +		netif_receive_skb(ch->skb_head);
>   		ch->skb_head = NULL;
>   		ch->skb_tail = NULL;
>   		ret = XRX200_DMA_PACKET_COMPLETE;

