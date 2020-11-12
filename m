Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0F2B0B4F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKLRc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgKLRc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 12:32:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D647820791;
        Thu, 12 Nov 2020 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605202347;
        bh=J2bgi81GLQv3+pD/nfDTuvhpePjPZ3xp43tfxSmCvOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VehaO6ktP4Ft3FB046yLlzplHkeqL6vihxnMYJQ8EJVau8lK5P2dDAl1FJwIeWAku
         sdkgXGOpYS78XxZF8ufGvU7dv31P+vP4z8zlkHTvvWC4NP5K3G/KaYENzpIGO5vsGZ
         6an7BO6QrAklcfeywjZ8PnNIbooUvd22RSWagpM4=
Date:   Thu, 12 Nov 2020 09:32:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Dike <jdike@akamai.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net V3] Exempt multicast addresses from five-second
 neighbor lifetime
Message-ID: <20201112093225.447edf7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110172305.28056-1-jdike@akamai.com>
References: <20201110172305.28056-1-jdike@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 12:23:05 -0500 Jeff Dike wrote:
> Commit 58956317c8de ("neighbor: Improve garbage collection")
> guarantees neighbour table entries a five-second lifetime.  Processes
> which make heavy use of multicast can fill the neighour table with
> multicast addresses in five seconds.  At that point, neighbour entries
> can't be GC-ed because they aren't five seconds old yet, the kernel
> log starts to fill up with "neighbor table overflow!" messages, and
> sends start to fail.
> 
> This patch allows multicast addresses to be thrown out before they've
> lived out their five seconds.  This makes room for non-multicast
> addresses and makes messages to all addresses more reliable in these
> circumstances.

We should add 

Fixes: 58956317c8de ("neighbor: Improve garbage collection")

right?

> Signed-off-by: Jeff Dike <jdike@akamai.com>

> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 687971d83b4e..097aa8bf07ee 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -125,6 +125,7 @@ static int arp_constructor(struct neighbour *neigh);
>  static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
>  static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
>  static void parp_redo(struct sk_buff *skb);
> +static int arp_is_multicast(const void *pkey);
>  
>  static const struct neigh_ops arp_generic_ops = {
>  	.family =		AF_INET,
> @@ -156,6 +157,7 @@ struct neigh_table arp_tbl = {
>  	.key_eq		= arp_key_eq,
>  	.constructor	= arp_constructor,
>  	.proxy_redo	= parp_redo,
> +	.is_multicast   = arp_is_multicast,

extreme nit pick - please align the = sign using tabs like the
surrounding code does.

>  	.id		= "arp_cache",
>  	.parms		= {
>  		.tbl			= &arp_tbl,
> @@ -928,6 +930,10 @@ static void parp_redo(struct sk_buff *skb)
>  	arp_process(dev_net(skb->dev), NULL, skb);
>  }
>  
> +static int arp_is_multicast(const void *pkey)
> +{
> +	return ipv4_is_multicast(*((__be32 *)pkey));
> +}
>  
>  /*
>   *	Receive an arp request from the device layer.
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 27f29b957ee7..67457cfadcd2 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -81,6 +81,7 @@ static void ndisc_error_report(struct neighbour *neigh, struct sk_buff *skb);
>  static int pndisc_constructor(struct pneigh_entry *n);
>  static void pndisc_destructor(struct pneigh_entry *n);
>  static void pndisc_redo(struct sk_buff *skb);
> +static int ndisc_is_multicast(const void *pkey);
>  
>  static const struct neigh_ops ndisc_generic_ops = {
>  	.family =		AF_INET6,
> @@ -115,6 +116,7 @@ struct neigh_table nd_tbl = {
>  	.pconstructor =	pndisc_constructor,
>  	.pdestructor =	pndisc_destructor,
>  	.proxy_redo =	pndisc_redo,
> +	.is_multicast = ndisc_is_multicast,

looks like the character after = is expected to be a tab, for better or
worse

>  	.allow_add  =   ndisc_allow_add,
>  	.id =		"ndisc_cache",
>  	.parms = {
> @@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
>  	kfree_skb(skb);
>  }
>  
> +static int ndisc_is_multicast(const void *pkey)
> +{
> +	return ipv6_addr_is_multicast((struct in6_addr *)pkey);
> +}
> +
>  static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
>  {
>  	struct inet6_dev *idev = __in6_dev_get(skb->dev);

