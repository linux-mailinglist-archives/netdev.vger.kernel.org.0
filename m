Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB789E4E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfHLM2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:28:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:53528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfHLM2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:28:54 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hx9RQ-0004R0-Ju; Mon, 12 Aug 2019 14:28:48 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hx9RQ-000UDO-D1; Mon, 12 Aug 2019 14:28:48 +0200
Subject: Re: [PATCH bpf-next v4 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
 <20190802081154.30962-2-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ad56a5e-a189-3f56-c85c-24b6c300efd9@iogearbox.net>
Date:   Mon, 12 Aug 2019 14:28:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190802081154.30962-2-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25539/Mon Aug 12 10:15:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 10:11 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> When an AF_XDP socket is released/closed the XSKMAP still holds a
> reference to the socket in a "released" state. The socket will still
> use the netdev queue resource, and block newly created sockets from
> attaching to that queue, but no user application can access the
> fill/complete/rx/tx queues. This results in that all applications need
> to explicitly clear the map entry from the old "zombie state"
> socket. This should be done automatically.
> 
> In this patch, the sockets tracks, and have a reference to, which maps
> it resides in. When the socket is released, it will remove itself from
> all maps.
> 
> Suggested-by: Bruce Richardson <bruce.richardson@intel.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

[ Sorry for the review delay, was on PTO and catching up with things. ]

Overall looks good to me, I think better than previous versions. One question /
clarification for below:

> ---
>   include/net/xdp_sock.h |  18 +++++++
>   kernel/bpf/xskmap.c    | 113 ++++++++++++++++++++++++++++++++++-------
>   net/xdp/xsk.c          |  48 +++++++++++++++++
>   3 files changed, 160 insertions(+), 19 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 69796d264f06..066e3ae446a8 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -50,6 +50,16 @@ struct xdp_umem {
>   	struct list_head xsk_list;
>   };
>   
> +/* Nodes are linked in the struct xdp_sock map_list field, and used to
> + * track which maps a certain socket reside in.
> + */
> +struct xsk_map;
> +struct xsk_map_node {
> +	struct list_head node;
> +	struct xsk_map *map;
> +	struct xdp_sock **map_entry;
> +};
> +
>   struct xdp_sock {
>   	/* struct sock must be the first member of struct xdp_sock */
>   	struct sock sk;
> @@ -75,6 +85,9 @@ struct xdp_sock {
>   	/* Protects generic receive. */
>   	spinlock_t rx_lock;
>   	u64 rx_dropped;
> +	struct list_head map_list;
> +	/* Protects map_list */
> +	spinlock_t map_list_lock;
>   };
>   
>   struct xdp_buff;
> @@ -96,6 +109,11 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
>   void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
>   struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
>   
> +void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> +			     struct xdp_sock **map_entry);
> +int xsk_map_inc(struct xsk_map *map);
> +void xsk_map_put(struct xsk_map *map);
> +
>   static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
>   {
>   	return umem->pages[addr >> PAGE_SHIFT].addr + (addr & (PAGE_SIZE - 1));
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 9bb96ace9fa1..780639309f6b 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -13,8 +13,71 @@ struct xsk_map {
>   	struct bpf_map map;
>   	struct xdp_sock **xsk_map;
>   	struct list_head __percpu *flush_list;
> +	spinlock_t lock; /* Synchronize map updates */
>   };
>   
> +int xsk_map_inc(struct xsk_map *map)
> +{
> +	struct bpf_map *m = &map->map;
> +
> +	m = bpf_map_inc(m, false);
> +	return IS_ERR(m) ? PTR_ERR(m) : 0;
> +}
> +
> +void xsk_map_put(struct xsk_map *map)
> +{
> +	bpf_map_put(&map->map);
> +}
> +
> +static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
> +					       struct xdp_sock **map_entry)
> +{
> +	struct xsk_map_node *node;
> +	int err;
> +
> +	node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
> +	if (!node)
> +		return NULL;
> +
> +	err = xsk_map_inc(map);
> +	if (err) {
> +		kfree(node);
> +		return ERR_PTR(err);
> +	}
> +
> +	node->map = map;
> +	node->map_entry = map_entry;
> +	return node;
> +}
> +
> +static void xsk_map_node_free(struct xsk_map_node *node)
> +{
> +	xsk_map_put(node->map);
> +	kfree(node);
> +}
> +
> +static void xsk_map_sock_add(struct xdp_sock *xs, struct xsk_map_node *node)
> +{
> +	spin_lock_bh(&xs->map_list_lock);
> +	list_add_tail(&node->node, &xs->map_list);
> +	spin_unlock_bh(&xs->map_list_lock);
> +}
> +
> +static void xsk_map_sock_delete(struct xdp_sock *xs,
> +				struct xdp_sock **map_entry)
> +{
> +	struct xsk_map_node *n, *tmp;
> +
> +	spin_lock_bh(&xs->map_list_lock);
> +	list_for_each_entry_safe(n, tmp, &xs->map_list, node) {
> +		if (map_entry == n->map_entry) {
> +			list_del(&n->node);
> +			xsk_map_node_free(n);
> +		}
> +	}
> +	spin_unlock_bh(&xs->map_list_lock);
> +}
> +
>   static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>   {
>   	struct xsk_map *m;
> @@ -34,6 +97,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>   		return ERR_PTR(-ENOMEM);
>   
>   	bpf_map_init_from_attr(&m->map, attr);
> +	spin_lock_init(&m->lock);
>   
>   	cost = (u64)m->map.max_entries * sizeof(struct xdp_sock *);
>   	cost += sizeof(struct list_head) * num_possible_cpus();
> @@ -71,21 +135,9 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>   static void xsk_map_free(struct bpf_map *map)
>   {
>   	struct xsk_map *m = container_of(map, struct xsk_map, map);
> -	int i;
>   
>   	bpf_clear_redirect_map(map);
>   	synchronize_net();
> -
> -	for (i = 0; i < map->max_entries; i++) {
> -		struct xdp_sock *xs;
> -
> -		xs = m->xsk_map[i];
> -		if (!xs)
> -			continue;
> -
> -		sock_put((struct sock *)xs);
> -	}
> -
>   	free_percpu(m->flush_list);
>   	bpf_map_area_free(m->xsk_map);
>   	kfree(m);
> @@ -165,7 +217,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>   {
>   	struct xsk_map *m = container_of(map, struct xsk_map, map);
>   	u32 i = *(u32 *)key, fd = *(u32 *)value;
> -	struct xdp_sock *xs, *old_xs;
> +	struct xdp_sock *xs, *old_xs, **entry;
> +	struct xsk_map_node *node;
>   	struct socket *sock;
>   	int err;
>   
> @@ -192,11 +245,19 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>   		return -EOPNOTSUPP;
>   	}
>   
> -	sock_hold(sock->sk);
> +	entry = &m->xsk_map[i];
> +	node = xsk_map_node_alloc(m, entry);
> +	if (IS_ERR(node)) {
> +		sockfd_put(sock);
> +		return PTR_ERR(node);
> +	}
>   
> -	old_xs = xchg(&m->xsk_map[i], xs);
> +	spin_lock_bh(&m->lock);
> +	xsk_map_sock_add(xs, node);
> +	old_xs = xchg(entry, xs);
>   	if (old_xs)
> -		sock_put((struct sock *)old_xs);
> +		xsk_map_sock_delete(old_xs, entry);
> +	spin_unlock_bh(&m->lock);
>   
>   	sockfd_put(sock);
>   	return 0;
> @@ -205,19 +266,33 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>   static int xsk_map_delete_elem(struct bpf_map *map, void *key)
>   {
>   	struct xsk_map *m = container_of(map, struct xsk_map, map);
> -	struct xdp_sock *old_xs;
> +	struct xdp_sock *old_xs, **map_entry;
>   	int k = *(u32 *)key;
>   
>   	if (k >= map->max_entries)
>   		return -EINVAL;
>   
> -	old_xs = xchg(&m->xsk_map[k], NULL);
> +	spin_lock_bh(&m->lock);
> +	map_entry = &m->xsk_map[k];
> +	old_xs = xchg(map_entry, NULL);
>   	if (old_xs)
> -		sock_put((struct sock *)old_xs);
> +		xsk_map_sock_delete(old_xs, map_entry);
> +	spin_unlock_bh(&m->lock);
>   
>   	return 0;
>   }
>   
> +void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> +			     struct xdp_sock **map_entry)
> +{
> +	spin_lock_bh(&map->lock);
> +	if (READ_ONCE(*map_entry) == xs) {
> +		WRITE_ONCE(*map_entry, NULL);
> +		xsk_map_sock_delete(xs, map_entry);
> +	}
> +	spin_unlock_bh(&map->lock);
> +}
> +
>   const struct bpf_map_ops xsk_map_ops = {
>   	.map_alloc = xsk_map_alloc,
>   	.map_free = xsk_map_free,
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 59b57d708697..c3447bad608a 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -362,6 +362,50 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>   	dev_put(dev);
>   }
>   
> +static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> +					      struct xdp_sock ***map_entry)
> +{
> +	struct xsk_map *map = NULL;
> +	struct xsk_map_node *node;
> +
> +	*map_entry = NULL;
> +
> +	spin_lock_bh(&xs->map_list_lock);
> +	node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> +					node);
> +	if (node) {
> +		WARN_ON(xsk_map_inc(node->map));

Can you elaborate on the refcount usage here and against what scenario it is protecting?

Do we pretend it never fails on the bpf_map_inc() wrt the WARN_ON(), why that (what
makes it different from the xsk_map_node_alloc() inc above where we do error out)?

> +		map = node->map;
> +		*map_entry = node->map_entry;
> +	}
> +	spin_unlock_bh(&xs->map_list_lock);
> +	return map;
> +}
> +
> +static void xsk_delete_from_maps(struct xdp_sock *xs)
> +{
> +	/* This function removes the current XDP socket from all the
> +	 * maps it resides in. We need to take extra care here, due to
> +	 * the two locks involved. Each map has a lock synchronizing
> +	 * updates to the entries, and each socket has a lock that
> +	 * synchronizes access to the list of maps (map_list). For
> +	 * deadlock avoidance the locks need to be taken in the order
> +	 * "map lock"->"socket map list lock". We start off by
> +	 * accessing the socket map list, and take a reference to the
> +	 * map to guarantee existence. Then we ask the map to remove
> +	 * the socket, which tries to remove the socket from the
> +	 * map. Note that there might be updates to the map between
> +	 * xsk_get_map_list_entry() and xsk_map_try_sock_delete().
> +	 */
> +	struct xdp_sock **map_entry = NULL;
> +	struct xsk_map *map;
> +
> +	while ((map = xsk_get_map_list_entry(xs, &map_entry))) {
> +		xsk_map_try_sock_delete(map, xs, map_entry);
> +		xsk_map_put(map);
> +	}
> +}
> +
>   static int xsk_release(struct socket *sock)
>   {
>   	struct sock *sk = sock->sk;
> @@ -381,6 +425,7 @@ static int xsk_release(struct socket *sock)
>   	sock_prot_inuse_add(net, sk->sk_prot, -1);
>   	local_bh_enable();
>   
> +	xsk_delete_from_maps(xs);
>   	xsk_unbind_dev(xs);
>   
>   	xskq_destroy(xs->rx);
> @@ -855,6 +900,9 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>   	spin_lock_init(&xs->rx_lock);
>   	spin_lock_init(&xs->tx_completion_lock);
>   
> +	INIT_LIST_HEAD(&xs->map_list);
> +	spin_lock_init(&xs->map_list_lock);
> +
>   	mutex_lock(&net->xdp.lock);
>   	sk_add_node_rcu(sk, &net->xdp.list);
>   	mutex_unlock(&net->xdp.lock);
> 

Thanks,
Daniel
