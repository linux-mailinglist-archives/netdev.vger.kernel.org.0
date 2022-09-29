Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1D5EF9DB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiI2QLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiI2QLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:11:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C1A1D2D22
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664467861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJaSAWw/xNJ7OYh/HNWkwx/0TWq1zWCdspTTIEaFs4I=;
        b=S1a9A0FW8NY36RP5aTTghyHNUd+gGOWCSyJsmK3fihL2ot/Ulfou6r9zKEK03KtbEiE4kn
        daOWdoeEsx2audGKHokZxEPvna3napu8qMVyBeqcGaK2FLzASamHEM/wuXJMibAnf16AEj
        XhOnaTEkRpkFETh1/mOek/xCmnUwUqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-OLkAXqDOP-20MkLNAxRYkg-1; Thu, 29 Sep 2022 12:10:56 -0400
X-MC-Unique: OLkAXqDOP-20MkLNAxRYkg-1
Received: by mail-wr1-f71.google.com with SMTP id m3-20020adfc583000000b0022cd60175bbso708697wrg.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dJaSAWw/xNJ7OYh/HNWkwx/0TWq1zWCdspTTIEaFs4I=;
        b=Hvzck0gn4Yx202d1nncObvkOGkf0dqVJ8qdJgJs+l2dalLufMvA0Snzo8Il805zQz0
         RZia1PErqTuxwVB743eNA6XbUvfWr9jyXVL0ZezlEAmbIuklnBd/nrORa+altesmwemE
         n8XE6HAw3AukzUcUtVAd6gHUd7CKpCmn3zGYtpB1ukmWMyVp3coPvqdR7ysY2V1oOh5e
         KyFEkEINwr9m8xw34MoTR1oK3qhrEGyQD0O96E6oVTMoR2i1NbWq5P1PXntQ1g/6NQyS
         IRRuMOi0NsbykmAe3o5TJA4R+5szjgsVu5JxkyW9mXwSAeIeRgokTkIxhwv5HsvC17FG
         83cA==
X-Gm-Message-State: ACrzQf0HXYEzh/XBWHXQa6OLJrJBkQ2W4PPCiiBf1/PGgtKMqAV4WV03
        5OKPc+OJ2vTOBwIVJ/41mcrl9XONUW7xWzzMoxivTbvs4WqFatOc1afvTTJu2rghBO5MHcpZK+r
        13vswGfMDuO+R5el1
X-Received: by 2002:a5d:6dc1:0:b0:22b:1256:c3e5 with SMTP id d1-20020a5d6dc1000000b0022b1256c3e5mr3187062wrz.336.1664467838525;
        Thu, 29 Sep 2022 09:10:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46ehuCq4J2FU1B5vBBiYatH69Q1Fs+pef4X4qcT9Q3/rgpFi7IoYFkM43rs3XrautRi820lw==
X-Received: by 2002:a5d:6dc1:0:b0:22b:1256:c3e5 with SMTP id d1-20020a5d6dc1000000b0022b1256c3e5mr3187045wrz.336.1664467838356;
        Thu, 29 Sep 2022 09:10:38 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id q16-20020a7bce90000000b003b492b30822sm4700721wmj.2.2022.09.29.09.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 09:10:37 -0700 (PDT)
Date:   Thu, 29 Sep 2022 18:10:35 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220929161035.GE6761@localhost.localdomain>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928113908.4525-2-fw@strlen.de>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> dropping vrf packets by mistake") but for nftables fib expression:
> Add special treatment of VRF devices so that typical reverse path
> filtering via 'fib saddr . iif oif' expression works as expected.
> 
> Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
>  net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index b75cac69bd7e..7ade04ff972d 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else
>  		oif = NULL;
>  
> +	if (priv->flags & NFTA_FIB_F_IIF)
> +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
> +

Shouldn't we set .flowi4_l3mdev instead of .flowi4_oif?

>  	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
>  	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
>  		nft_fib_store_result(dest, priv, nft_in(pkt));
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 8970d0b4faeb..1d7e520d9966 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> +		fl6->flowi6_oif = dev->ifindex;
>  	}
>  
>  	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
> @@ -197,7 +200,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
>  		goto put_rt_err;
>  
> -	if (oif && oif != rt->rt6i_idev->dev)
> +	if (oif && oif != rt->rt6i_idev->dev &&
> +	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
>  		goto put_rt_err;
>  
>  	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
> -- 
> 2.35.1
> 

