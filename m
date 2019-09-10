Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0202DAEE10
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392145AbfIJPDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbfIJPDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 11:03:48 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8EC0F83F4C
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 15:03:47 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f10so1468760wmh.8
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 08:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qCwewHaMmc38EVrNjRk76O0070069OuiqOT8Str/oAw=;
        b=eh+AN8lsYdg9HSv60Izp0EoXJKg7it6p3GJoZgzVhL4MhYno3kwqW3sXcYFAQhjj6I
         Hu0uXCkajtA23J8zebEnPz+kVl/Z4+/KIV84n3OPhfjOl1c/GsQdITiBqXTQnDRjggPa
         2OZzTDV8Yc1jbEW7LaZ179jlR/NdsqY8Qio3Nkp2DQS9jRzeX4Lgpq3wbAi4NPHh9Q3N
         8BA6t9PhgvW0KZ914zb6h/JMSS0altlUh2XWKbXvpB6eK2TB+sB4yihb/5J/jgFTnOZM
         Vvmx6BJYDBoM0MxP3AuL+lNTVcQQgbyafb/lyvE783hIrtkCgZU8AKRRzqBN0Y5b4tDD
         rYzw==
X-Gm-Message-State: APjAAAWxP5U/Ur0WKh36zZhHJvOFgNrBTa47KCTDM4oHmwKLCuFG3CLD
        tm+k2NFBu1DtHGCxdugomZyWy1qtlR8i6bC5QJvCe149XAQKNIJQq3T0u568rGoANELhA58Hjb5
        ej6D7QoR9xpRdMkSu
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr14560415wrq.328.1568127826363;
        Tue, 10 Sep 2019 08:03:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqympUHA32VsMnMK6Ca3MLUHnLmNFCdeNI1+1pDF2+GQLSLtbpAHr5Yp0GhGPVACHlubsFB70Q==
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr14560399wrq.328.1568127826192;
        Tue, 10 Sep 2019 08:03:46 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id a15sm3084792wmj.25.2019.09.10.08.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 08:03:45 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:03:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Julian Anastasov <ja@ssi.bg>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6: Don't use dst gateway directly in
 ip6_confirm_neigh()
Message-ID: <20190910150343.GC21550@linux.home>
References: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 10:44:06PM +0200, Stefano Brivio wrote:
> This is the equivalent of commit 2c6b55f45d53 ("ipv6: fix neighbour
> resolution with raw socket") for ip6_confirm_neigh(): we can send a
> packet with MSG_CONFIRM on a raw socket for a connected route, so the
> gateway would be :: here, and we should pick the next hop using
> rt6_nexthop() instead.
> 
> This was found by code review and, to the best of my knowledge, doesn't
> actually fix a practical issue: the destination address from the packet
> is not considered while confirming a neighbour, as ip6_confirm_neigh()
> calls choose_neigh_daddr() without passing the packet, so there are no
> similar issues as the one fixed by said commit.
> 
> A possible source of issues with the existing implementation might come
> from the fact that, if we have a cached dst, we won't consider it,
> while rt6_nexthop() takes care of that. I might just not be creative
> enough to find a practical problem here: the only way to affect this
> with cached routes is to have one coming from an ICMPv6 redirect, but
> if the next hop is a directly connected host, there should be no
> topology for which a redirect applies here, and tests with redirected
> routes show no differences for MSG_CONFIRM (and MSG_PROBE) packets on
> raw sockets destined to a directly connected host.
> 
> However, directly using the dst gateway here is not consistent anymore
> with neighbour resolution, and, in general, as we want the next hop,
> using rt6_nexthop() looks like the only sane way to fetch it.
> 
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 7a5d331cdefa..874641d4d2a1 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -227,7 +227,7 @@ static void ip6_confirm_neigh(const struct dst_entry *dst, const void *daddr)
>  	struct net_device *dev = dst->dev;
>  	struct rt6_info *rt = (struct rt6_info *)dst;
>  
> -	daddr = choose_neigh_daddr(&rt->rt6i_gateway, NULL, daddr);
> +	daddr = choose_neigh_daddr(rt6_nexthop(rt, &in6addr_any), NULL, daddr);
>  	if (!daddr)
>  		return;
>  	if (dev->flags & (IFF_NOARP | IFF_LOOPBACK))
> 
Acked-by: Guillaume Nault <gnault@redhat.com>
