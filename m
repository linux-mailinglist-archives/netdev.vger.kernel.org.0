Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9458AFA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF0Tfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0Tfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 15:35:44 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E86523082B1E;
        Thu, 27 Jun 2019 19:35:34 +0000 (UTC)
Received: from ovpn-112-48.rdu2.redhat.com (ovpn-112-48.rdu2.redhat.com [10.10.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 440B41001B14;
        Thu, 27 Jun 2019 19:35:28 +0000 (UTC)
Message-ID: <e3188fc08a13ddff9ea5a200a69aa6adbd9278ed.camel@redhat.com>
Subject: Re: [RFC] longer netdev names proposal
From:   Dan Williams <dcbw@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Date:   Thu, 27 Jun 2019 14:35:27 -0500
In-Reply-To: <20190627122041.18c46daf@hermes.lan>
References: <20190627094327.GF2424@nanopsycho>
         <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
         <20190627180803.GJ27240@unicorn.suse.cz>
         <20190627112305.7e05e210@hermes.lan> <20190627183538.GI31189@lunn.ch>
         <20190627183948.GK27240@unicorn.suse.cz>
         <20190627122041.18c46daf@hermes.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 27 Jun 2019 19:35:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-27 at 12:20 -0700, Stephen Hemminger wrote:
> On Thu, 27 Jun 2019 20:39:48 +0200
> Michal Kubecek <mkubecek@suse.cz> wrote:
> 
> > > $ ip li set dev enp3s0 alias "Onboard Ethernet"
> > > # ip link show "Onboard Ethernet"
> > > Device "Onboard Ethernet" does not exist.
> > > 
> > > So it does not really appear to be an alias, it is a label. To be
> > > truly useful, it needs to be more than a label, it needs to be a
> > > real
> > > alias which you can use.  
> > 
> > That's exactly what I meant: to be really useful, one should be
> > able to
> > use the alias(es) for setting device options, for adding routes, in
> > netfilter rules etc.
> > 
> > Michal
> 
> The kernel doesn't enforce uniqueness of alias.

Can we even enforce unique aliases/labels? Given that the kernel hasn't
enforced that in the past there's a good possibility of breaking stuff
if it started. (unfortunately)

Dan

> Also current kernel RTM_GETLINK doesn't do filter by alias (easily
> fixed).
> 
> If it did, then handling it in iproute would be something like:
> 
> diff --git a/lib/ll_map.c b/lib/ll_map.c
> index e0ed54bf77c9..c798ba542224 100644
> --- a/lib/ll_map.c
> +++ b/lib/ll_map.c
> @@ -26,15 +26,18 @@
>  struct ll_cache {
>  	struct hlist_node idx_hash;
>  	struct hlist_node name_hash;
> +	struct hlist_node alias_hash;
>  	unsigned	flags;
>  	unsigned 	index;
>  	unsigned short	type;
> -	char		name[];
> +	char		*alias;
> +	char		name[IFNAMSIZ];
>  };
>  
>  #define IDXMAP_SIZE	1024
>  static struct hlist_head idx_head[IDXMAP_SIZE];
>  static struct hlist_head name_head[IDXMAP_SIZE];
> +static struct hlist_head alias_head[IDXMAP_SIZE];
>  
>  static struct ll_cache *ll_get_by_index(unsigned index)
>  {
> @@ -77,10 +80,26 @@ static struct ll_cache *ll_get_by_name(const char
> *name)
>  	return NULL;
>  }
>  
> +static struct ll_cache *ll_get_by_alias(const char *alias)
> +{
> +	struct hlist_node *n;
> +	unsigned h = namehash(alias) & (IDXMAP_SIZE - 1);
> +
> +	hlist_for_each(n, &alias_head[h]) {
> +		struct ll_cache *im
> +			= container_of(n, struct ll_cache, alias_hash);
> +
> +		if (strcmp(im->alias, alias) == 0)
> +			return im;
> +	}
> +
> +	return NULL;
> +}
> +
>  int ll_remember_index(struct nlmsghdr *n, void *arg)
>  {
>  	unsigned int h;
> -	const char *ifname;
> +	const char *ifname, *ifalias;
>  	struct ifinfomsg *ifi = NLMSG_DATA(n);
>  	struct ll_cache *im;
>  	struct rtattr *tb[IFLA_MAX+1];
> @@ -96,6 +115,10 @@ int ll_remember_index(struct nlmsghdr *n, void
> *arg)
>  		if (im) {
>  			hlist_del(&im->name_hash);
>  			hlist_del(&im->idx_hash);
> +			if (im->alias) {
> +				hlist_del(&im->alias_hash);
> +				free(im->alias);
> +			}
>  			free(im);
>  		}
>  		return 0;
> @@ -106,6 +129,8 @@ int ll_remember_index(struct nlmsghdr *n, void
> *arg)
>  	if (ifname == NULL)
>  		return 0;
>  
> +	ifalias = tb[IFLA_IFALIAS] ? rta_getattr_str(tb[IFLA_IFALIAS])
> : NULL;
> +
>  	if (im) {
>  		/* change to existing entry */
>  		if (strcmp(im->name, ifname) != 0) {
> @@ -114,6 +139,14 @@ int ll_remember_index(struct nlmsghdr *n, void
> *arg)
>  			hlist_add_head(&im->name_hash, &name_head[h]);
>  		}
>  
> +		if (im->alias) {
> +			hlist_del(&im->alias_hash);
> +			if (ifalias) {
> +				h = namehash(ifalias) & (IDXMAP_SIZE -
> 1);
> +				hlist_add_head(&im->alias_hash,
> &alias_head[h]);
> +			}
> +		}
> +
>  		im->flags = ifi->ifi_flags;
>  		return 0;
>  	}
> @@ -132,6 +165,12 @@ int ll_remember_index(struct nlmsghdr *n, void
> *arg)
>  	h = namehash(ifname) & (IDXMAP_SIZE - 1);
>  	hlist_add_head(&im->name_hash, &name_head[h]);
>  
> +	if (ifalias) {
> +		im->alias = strdup(ifalias);
> +		h = namehash(ifalias) & (IDXMAP_SIZE - 1);
> +		hlist_add_head(&im->alias_hash, &alias_head[h]);
> +	}		
> +	
>  	return 0;
>  }
>  
> @@ -152,7 +191,7 @@ static unsigned int ll_idx_a2n(const char *name)
>  	return idx;
>  }
>  
> -static int ll_link_get(const char *name, int index)
> +static int ll_link_get(const char *name, const char *alias, int
> index)
>  {
>  	struct {
>  		struct nlmsghdr		n;
> @@ -176,6 +215,9 @@ static int ll_link_get(const char *name, int
> index)
>  	if (name)
>  		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
>  			  strlen(name) + 1);
> +	if (alias)
> +		addattr_l(&req.n, sizeof(req), IFLA_IFALIAS, alias,
> +			  strlen(alias) + 1);
>  
>  	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
>  		goto out;
> @@ -206,7 +248,7 @@ const char *ll_index_to_name(unsigned int idx)
>  	if (im)
>  		return im->name;
>  
> -	if (ll_link_get(NULL, idx) == idx) {
> +	if (ll_link_get(NULL, NULL, idx) == idx) {
>  		im = ll_get_by_index(idx);
>  		if (im)
>  			return im->name;
> @@ -252,7 +294,13 @@ unsigned ll_name_to_index(const char *name)
>  	if (im)
>  		return im->index;
>  
> -	idx = ll_link_get(name, 0);
> +	im = ll_get_by_alias(name);
> +	if (im)
> +		return im->index;
> +
> +	idx = ll_link_get(name, NULL, 0);
> +	if (idx == 0)
> +		idx = ll_link_get(NULL, name, 0);
>  	if (idx == 0)
>  		idx = if_nametoindex(name);
>  	if (idx == 0)
> @@ -270,7 +318,10 @@ void ll_drop_by_index(unsigned index)
>  
>  	hlist_del(&im->idx_hash);
>  	hlist_del(&im->name_hash);
> -
> +	if (im->alias) {
> +		hlist_del(&im->alias_hash);
> +		free(im->alias);
> +	}
>  	free(im);
>  }
>  
> 

