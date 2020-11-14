Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2E2B298E
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKNAOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNAOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:14:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9ABE221EB;
        Sat, 14 Nov 2020 00:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312840;
        bh=83yleY4Fd8PpZQ7zbL/5GVdiiuK37MmZOTJcPlyJ9Ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kBAtviQzqdAkXH0Si4W+SBt1VUllym14AIWxwBpEnNMBmQ5kDm9UG8uACFqWq90g5
         JCi5qXQyR0v3ZD3CJWfJ392eA4kIqLLzPwPvJHHqhvfx2bQu1kvVkKWi0abD9zNAy7
         QSvqgczcg9/5CQo4NK3QJGEZqddsBqA87MvDsyD0=
Date:   Fri, 13 Nov 2020 16:13:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yi-Hung Wei <yihung.wei@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        pieter.jansenvanvuuren@netronome.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ip_tunnels: Set tunnel option flag when tunnel metadata
 is present
Message-ID: <20201113161359.77559aa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
References: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 16:16:40 -0800 Yi-Hung Wei wrote:
> Currently, we may set the tunnel option flag when the size of metadata
> is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
> no matter the geneve option is present or not.  As this may result in
> issues on the tunnel flags consumers, this patch fixes the issue.
> 
> Related discussion:
> * https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u
> 
> Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>

Seems fine to me, however BPF (and maybe Netfilter?) can set options
passed by user without checking if they are 0 length.

Daniel, Pablo, are you okay with this change or should we limit it to
just fixing the GENEVE oddness?

> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index d07008a818df..1426bfc009bc 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -224,8 +224,7 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
>  	if (ip_tunnel_collect_metadata() || gs->collect_md) {
>  		__be16 flags;
>  
> -		flags = TUNNEL_KEY | TUNNEL_GENEVE_OPT |
> -			(gnvh->oam ? TUNNEL_OAM : 0) |
> +		flags = TUNNEL_KEY | (gnvh->oam ? TUNNEL_OAM : 0) |
>  			(gnvh->critical ? TUNNEL_CRIT_OPT : 0);
>  
>  		tun_dst = udp_tun_rx_dst(skb, geneve_get_sk_family(gs), flags,

For the minimal fix we'd just need the change above, plus:

-               ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
-                                       gnvh->options, gnvh->opt_len * 4,
-                                       TUNNEL_GENEVE_OPT);
+               if (gnvh->opt_len)
+                       ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
+                                               gnvh->options,
+                                               gnvh->opt_len * 4,
+                                               TUNNEL_GENEVE_OPT);

Right?

> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 02ccd32542d0..61620677b034 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -478,9 +478,11 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
>  					   const void *from, int len,
>  					   __be16 flags)
>  {
> -	memcpy(ip_tunnel_info_opts(info), from, len);
>  	info->options_len = len;
> -	info->key.tun_flags |= flags;
> +	if (len > 0) {
> +		memcpy(ip_tunnel_info_opts(info), from, len);
> +		info->key.tun_flags |= flags;
> +	}
>  }
>  
>  static inline struct ip_tunnel_info *lwt_tun_info(struct lwtunnel_state *lwtstate)
> @@ -526,7 +528,6 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
>  					   __be16 flags)
>  {
>  	info->options_len = 0;
> -	info->key.tun_flags |= flags;
>  }
>  
>  #endif /* CONFIG_INET */

