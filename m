Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D87A290D89
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgJPV75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:59:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:63287 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732394AbgJPV75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:59:57 -0400
IronPort-SDR: m1pwkOJOqVvY8q/lRFm9IH3iSkClw5fa5Q9Y7aPe2C+nBsQuxW8QJtmBPJW633vZ55TRw1PkIn
 zY+2V/n0tdMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="165930888"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="165930888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:59:54 -0700
IronPort-SDR: Xg3ucZs/bREfMmgXKqEvCrKV0Ht6pX/nlSLtG68wMDzRtes2+406uOvC16uK6eAR1VIj9wpvBF
 8qH/RjEi22Og==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="531886968"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:59:53 -0700
Date:   Fri, 16 Oct 2020 14:59:52 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jeff Dike <jdike@akamai.com>, netdev@vger.kernel.org
Subject: Re: [RFC] Exempt multicast address from five-second neighbor
 lifetime
Message-ID: <20201016145952.000054ad@intel.com>
In-Reply-To: <0d7a29d2-499f-70ab-ee6f-ced4c9305181@akamai.com>
References: <0d7a29d2-499f-70ab-ee6f-ced4c9305181@akamai.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff, 

Jeff Dike wrote:


Your subject should indicate net or net-next as the tree, please see:
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

> Commit 58956317c8de guarantees arp table entries a five-second lifetime.  We have some apps which make heavy use of multicast, and these can cause the table to overflow by filling it with multicast addresses which can't be GC-ed until their five seconds are up.
> This patch allows multicast addresses to be thrown out before they've lived out their five seconds.

Not sure how many patches you've submitted, but your commit message
should be wrapped at 68 or 72 characters or so.

> 
> Signed-off-by: Jeff Dike <jdike@akamai.com>

your triple-dash and a diffstat should be right here, did you hand edit
this mail instead of using git format-patch to generate it?

> 
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 81ee17594c32..22ced1381ede 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -204,6 +204,7 @@ struct neigh_table {
>  	int			(*pconstructor)(struct pneigh_entry *);
>  	void			(*pdestructor)(struct pneigh_entry *);
>  	void			(*proxy_redo)(struct sk_buff *skb);
> +	int			(*is_multicast)(const void *pkey);
>  	bool			(*allow_add)(const struct net_device *dev,
>  					     struct netlink_ext_ack *extack);
>  	char			*id;
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8e39e28b0a8d..9500d28a43b0 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -235,6 +235,8 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>  
>  			write_lock(&n->lock);
>  			if ((n->nud_state == NUD_FAILED) ||
> +			    (tbl->is_multicast &&
> +			     tbl->is_multicast(n->primary_key)) ||
>  			    time_after(tref, n->updated))
>  				remove = true;
>  			write_unlock(&n->lock);
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 687971d83b4e..110d6d408edc 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -79,6 +79,7 @@
>  #include <linux/socket.h>
>  #include <linux/sockios.h>
>  #include <linux/errno.h>
> +#define __UAPI_DEF_IN_CLASS 1

Why is this added in the middle of the includes?

>  #include <linux/in.h>
>  #include <linux/mm.h>
>  #include <linux/inet.h>
> @@ -125,6 +126,7 @@ static int arp_constructor(struct neighbour *neigh);
>  static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
>  static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
>  static void parp_redo(struct sk_buff *skb);
> +static int arp_is_multicast(const void *pkey);
>  
>  static const struct neigh_ops arp_generic_ops = {
>  	.family =		AF_INET,
> @@ -156,6 +158,7 @@ struct neigh_table arp_tbl = {
>  	.key_eq		= arp_key_eq,
>  	.constructor	= arp_constructor,
>  	.proxy_redo	= parp_redo,
> +	.is_multicast   = arp_is_multicast,
>  	.id		= "arp_cache",
>  	.parms		= {
>  		.tbl			= &arp_tbl,
> @@ -928,6 +931,10 @@ static void parp_redo(struct sk_buff *skb)
>  	arp_process(dev_net(skb->dev), NULL, skb);
>  }
>  
> +static int arp_is_multicast(const void *pkey)
> +{
> +	return IN_MULTICAST(htonl(*((u32 *) pkey)));
> +}

Why not just move this function up and skip the declaration above?

>  
>  /*
>   *	Receive an arp request from the device layer.
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 27f29b957ee7..b42c9314cc4e 100644
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
>  	.allow_add  =   ndisc_allow_add,
>  	.id =		"ndisc_cache",
>  	.parms = {
> @@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
>  	kfree_skb(skb);
>  }
>  
> +static int ndisc_is_multicast(const void *pkey)
> +{
> +	return (((struct in6_addr *) pkey)->in6_u.u6_addr8[0] & 0xf0) == 0xf0;
> +}
> +

Again, just move this up above the first usage?

Does the above work on big and little endian, just seems suspicious
even though you're using a byte offset? Also I suspect this will
trigger a warning with sparse or with W=2 about pointer alignment.

