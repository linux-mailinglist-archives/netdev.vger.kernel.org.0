Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE152AEF8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiERAKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiERAKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B7BB87A;
        Tue, 17 May 2022 17:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F375F614DB;
        Wed, 18 May 2022 00:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED76BC385B8;
        Wed, 18 May 2022 00:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652832628;
        bh=Ue7YRn1pnT6cPWJsx8+E9Wz/2DumSmXjinJYonhfLkg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=si/EYZG+K3tbQ8lmVy7S2Zyd4nXL4P6cooEzhT6qK1FYms8wT9gWNHxGvTvssvwIV
         IdJqjhxByBCE8TJwa9+SqktIIF2fyZiEMEEHuieULsqZOAHpZyKDS7Tfc23P5eFPpL
         Gpo8r6GNNQnJD7OOhhhECH9XlIT6UJ3bCtAxaMOvQLKIlUNL19W9nEPuxY0+epSKWf
         z9a2ZnAK6jYYDgB7y5FadgQiPCyudzz0R3PmKoHMcjB0HGhhMqafJQXqW97bARs4O/
         nIgzwJ7laSle8tzVUo+hiQM1iO9OxJSvMHvthcTaDQGWoaEpbBHBfJK5h1zP/uz9x5
         8KUCmaSHtMD2g==
Date:   Tue, 17 May 2022 17:10:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Saranya Panjarathina <plsaranya@gmail.com>, netdev@vger.kernel.org,
        Saranya_Panjarathina@dell.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, g_balaji1@dell.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] net: PIM register decapsulation and
 Forwarding.
Message-ID: <20220517171026.1230e034@kernel.org>
In-Reply-To: <20220516112906.2095-1-plsaranya@gmail.com>
References: <20220512070138.19170-1-plsaranya@gmail.com>
        <20220516112906.2095-1-plsaranya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 04:29:06 -0700 Saranya Panjarathina wrote:
> PIM register packet is decapsulated but not forwarded in RP
> 
> __pim_rcv decapsulates the PIM register packet and reinjects for forwarding
> after replacing the skb->dev to reg_dev (vif with VIFF_Register)
> 
> Ideally the incoming device should be same as skb->dev where the
> original PIM register packet is received. mcache would not have
> reg_vif as IIF. Decapsulated packet forwarding is failing
> because of IIF mismatch. In RP for this S,G RPF interface would be
> skb->dev vif only, so that would be IIF for the cache entry.
> 
> Signed-off-by: Saranya Panjarathina <plsaranya@gmail.com>

Not sure if this can cause any trouble. And why it had become 
a problem now, seems like the code has been this way forever.
David? Ido?

> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 13e6329784fb..7b9586335fb7 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -598,7 +598,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
>  	skb->protocol = htons(ETH_P_IP);
>  	skb->ip_summed = CHECKSUM_NONE;
>  
> -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> +	skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
>  
>  	netif_rx(skb);
>  
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index 4e74bc61a3db..147e29a818ca 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -566,7 +566,7 @@ static int pim6_rcv(struct sk_buff *skb)
>  	skb->protocol = htons(ETH_P_IPV6);
>  	skb->ip_summed = CHECKSUM_NONE;
>  
> -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> +	skb_tunnel_rx(skb, skb->dev, net);
>  
>  	netif_rx(skb);
>  

