Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B354C6FA4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbiB1Ohu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiB1Oht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:37:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37367EDA0;
        Mon, 28 Feb 2022 06:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8gK1MLeSoPmiKMeGhKrlABpUTydohzP3HzJO0Sk5SLs=; b=Vbh/4hNPnPdabQ6gj2ACyOSSzn
        smwnYm9+HOetCiY5KBm+eI6Y3vsIr/YlUtQBgF8KYWnKTZGoHSqfBhzYOrG1e2nlq57jFZuXrSSzA
        9ruB2YvPHM6WeCB9ZRcXrgGnZW77emFdr7q1Zz0L3wSem79OX8WZG4pG5++0gORtFpJbHiWK2NS/+
        +F5iftJX8+BLZiOFkkov+DDAaZdadI4oLdVTlXpFBceyBBL/lRg6J+tB3ZRh/wv77WYIjSTy91BJ8
        aVxHVDHnUZEcIVyZxA0xRpgLk3uRkXjunFN6IN307jnVLuebCA9wtgOc+1rj0a9Ec+l4we2B7ab4C
        u6aBmBFg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOh90-00Cwne-Bt; Mon, 28 Feb 2022 14:36:58 +0000
Date:   Mon, 28 Feb 2022 06:36:58 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vlastimil Babka <vbabka@suse.cz>, NeilBrown <neilb@suse.de>,
        Michal Hocko <mhocko@suse.com>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
Message-ID: <YhzeCkXEvga7+o/A@bombadil.infradead.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
> Following one-liner running inside memcg-limited container consumes
> huge number of host memory and can trigger global OOM.
> 
> for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
> 
> Patch accounts most part of these allocations and can protect host.
> ---[cut]---
> It is not polished, and perhaps should be splitted.
> obviously it affects other kind of netdevices too.
> Unfortunately I'm not sure that I will have enough time to handle it properly
> and decided to publish current patch version as is.
> OpenVz workaround it by using per-container limit for number of
> available netdevices, but upstream does not have any kind of
> per-container configuration.
> ------

Should this just be a new ucount limit on kernel/ucount.c and have veth
use something like inc_ucount(current_user_ns(), current_euid(), UCOUNT_VETH)?

This might be abusing ucounts though, not sure, Eric?

  Luis
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  drivers/net/veth.c    | 2 +-
>  fs/kernfs/mount.c     | 2 +-
>  fs/proc/proc_sysctl.c | 3 ++-
>  net/core/neighbour.c  | 4 ++--
>  net/ipv4/devinet.c    | 2 +-
>  net/ipv6/addrconf.c   | 6 +++---
>  6 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 354a963075c5..6e0b4a9d0843 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1307,7 +1307,7 @@ static int veth_alloc_queues(struct net_device *dev)
>  	struct veth_priv *priv = netdev_priv(dev);
>  	int i;
> -	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL);
> +	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
>  	if (!priv->rq)
>  		return -ENOMEM;
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index cfa79715fc1a..2881aeeaa880 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -391,7 +391,7 @@ void __init kernfs_init(void)
>  {
>  	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
>  					      sizeof(struct kernfs_node),
> -					      0, SLAB_PANIC, NULL);
> +					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>  	/* Creates slab cache for kernfs inode attributes */
>  	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7d9cfc730bd4..e20ce8198a44 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -1333,7 +1333,8 @@ struct ctl_table_header *__register_sysctl_table(
>  		nr_entries++;
>  	header = kzalloc(sizeof(struct ctl_table_header) +
> -			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);
> +			 sizeof(struct ctl_node)*nr_entries,
> +			 GFP_KERNEL_ACCOUNT);
>  	if (!header)
>  		return NULL;
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index ec0bf737b076..66a4445421f1 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1665,7 +1665,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
>  	struct net *net = dev_net(dev);
>  	const struct net_device_ops *ops = dev->netdev_ops;
> -	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL);
> +	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL_ACCOUNT);
>  	if (p) {
>  		p->tbl		  = tbl;
>  		refcount_set(&p->refcnt, 1);
> @@ -3728,7 +3728,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
>  	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
>  	char *p_name;
> -	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
> +	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL_ACCOUNT);
>  	if (!t)
>  		goto err;
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index fba2bffd65f7..47523fe5b891 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -2566,7 +2566,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
>  	struct devinet_sysctl_table *t;
>  	char path[sizeof("net/ipv4/conf/") + IFNAMSIZ];
> -	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL);
> +	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL_ACCOUNT);
>  	if (!t)
>  		goto out;
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f927c199a93c..9d903342bc41 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -358,7 +358,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
>  	if (!idev->stats.icmpv6dev)
>  		goto err_icmp;
>  	idev->stats.icmpv6msgdev = kzalloc(sizeof(struct icmpv6msg_mib_device),
> -					   GFP_KERNEL);
> +					   GFP_KERNEL_ACCOUNT);
>  	if (!idev->stats.icmpv6msgdev)
>  		goto err_icmpmsg;
> @@ -382,7 +382,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
>  	if (dev->mtu < IPV6_MIN_MTU)
>  		return ERR_PTR(-EINVAL);
> -	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
> +	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL_ACCOUNT);
>  	if (!ndev)
>  		return ERR_PTR(err);
> @@ -7023,7 +7023,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
>  	struct ctl_table *table;
>  	char path[sizeof("net/ipv6/conf/") + IFNAMSIZ];
> -	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL);
> +	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL_ACCOUNT);
>  	if (!table)
>  		goto out;
> -- 
> 2.25.1
> 
