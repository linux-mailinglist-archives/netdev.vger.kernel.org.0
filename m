Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C818958F07
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfF1Adw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 20:33:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:43368 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfF1Adw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 20:33:52 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgepl-0000CZ-SX; Fri, 28 Jun 2019 02:33:45 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgepl-0000qg-MI; Fri, 28 Jun 2019 02:33:45 +0200
Subject: Re: [PATCH bpf-next v3 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
References: <20190620100652.31283-1-bjorn.topel@gmail.com>
 <20190620100652.31283-2-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2417e1ab-16fa-d3ed-564e-1a50c4cb6717@iogearbox.net>
Date:   Fri, 28 Jun 2019 02:33:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620100652.31283-2-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20/2019 12:06 PM, Björn Töpel wrote:
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
> After this patch, when a socket is released, it will remove itself
> from all the XSKMAPs it resides in, allowing the socket application to
> remove the code that cleans the XSKMAP entry.
> 
> This behavior is also closer to that of SOCKMAP, making the two socket
> maps more consistent.
> 
> Suggested-by: Bruce Richardson <bruce.richardson@intel.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Sorry for the bit of delay in reviewing, few comments inline:

> ---
>  include/net/xdp_sock.h |   3 ++
>  kernel/bpf/xskmap.c    | 101 +++++++++++++++++++++++++++++++++++------
>  net/xdp/xsk.c          |  25 ++++++++++
>  3 files changed, 116 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index ae0f368a62bb..011a1b08d7c9 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -68,6 +68,8 @@ struct xdp_sock {
>  	 */
>  	spinlock_t tx_completion_lock;
>  	u64 rx_dropped;
> +	struct list_head map_list;
> +	spinlock_t map_list_lock;
>  };
>  
>  struct xdp_buff;
> @@ -87,6 +89,7 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
>  					  struct xdp_umem_fq_reuse *newq);
>  void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
>  struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
> +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *node);
>  
>  static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
>  {
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index ef7338cebd18..af802c89ebab 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -13,8 +13,58 @@ struct xsk_map {
>  	struct bpf_map map;
>  	struct xdp_sock **xsk_map;
>  	struct list_head __percpu *flush_list;
> +	spinlock_t lock;
>  };
>  
> +/* Nodes are linked in the struct xdp_sock map_list field, and used to
> + * track which maps a certain socket reside in.
> + */
> +struct xsk_map_node {
> +	struct list_head node;
> +	struct xsk_map *map;
> +	struct xdp_sock **map_entry;
> +};
> +
> +static struct xsk_map_node *xsk_map_node_alloc(void)
> +{
> +	return kzalloc(sizeof(struct xsk_map_node), GFP_ATOMIC | __GFP_NOWARN);
> +}
> +
> +static void xsk_map_node_free(struct xsk_map_node *node)
> +{
> +	kfree(node);
> +}
> +
> +static void xsk_map_node_init(struct xsk_map_node *node,
> +			      struct xsk_map *map,
> +			      struct xdp_sock **map_entry)
> +{
> +	node->map = map;
> +	node->map_entry = map_entry;
> +}
> +
> +static void xsk_map_add_node(struct xdp_sock *xs, struct xsk_map_node *node)
> +{
> +	spin_lock_bh(&xs->map_list_lock);
> +	list_add_tail(&node->node, &xs->map_list);
> +	spin_unlock_bh(&xs->map_list_lock);
> +}
> +
> +static void xsk_map_del_node(struct xdp_sock *xs, struct xdp_sock **map_entry)
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
> +
> +}
> +
>  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>  {
>  	struct xsk_map *m;
> @@ -34,6 +84,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>  		return ERR_PTR(-ENOMEM);
>  
>  	bpf_map_init_from_attr(&m->map, attr);
> +	spin_lock_init(&m->lock);
>  
>  	cost = (u64)m->map.max_entries * sizeof(struct xdp_sock *);
>  	cost += sizeof(struct list_head) * num_possible_cpus();
> @@ -76,15 +127,16 @@ static void xsk_map_free(struct bpf_map *map)
>  	bpf_clear_redirect_map(map);
>  	synchronize_net();
>  
> +	spin_lock_bh(&m->lock);
>  	for (i = 0; i < map->max_entries; i++) {
> -		struct xdp_sock *xs;
> -
> -		xs = m->xsk_map[i];
> -		if (!xs)
> -			continue;
> +		struct xdp_sock **map_entry = &m->xsk_map[i];
> +		struct xdp_sock *old_xs;
>  
> -		sock_put((struct sock *)xs);
> +		old_xs = xchg(map_entry, NULL);
> +		if (old_xs)
> +			xsk_map_del_node(old_xs, map_entry);
>  	}
> +	spin_unlock_bh(&m->lock);
>  
>  	free_percpu(m->flush_list);
>  	bpf_map_area_free(m->xsk_map);
> @@ -166,7 +218,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>  {
>  	struct xsk_map *m = container_of(map, struct xsk_map, map);
>  	u32 i = *(u32 *)key, fd = *(u32 *)value;
> -	struct xdp_sock *xs, *old_xs;
> +	struct xdp_sock *xs, *old_xs, **entry;
> +	struct xsk_map_node *node;
>  	struct socket *sock;
>  	int err;
>  
> @@ -193,11 +246,20 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	sock_hold(sock->sk);
> +	node = xsk_map_node_alloc();
> +	if (!node) {
> +		sockfd_put(sock);
> +		return -ENOMEM;
> +	}
>  
> -	old_xs = xchg(&m->xsk_map[i], xs);
> +	spin_lock_bh(&m->lock);
> +	entry = &m->xsk_map[i];
> +	xsk_map_node_init(node, m, entry);
> +	xsk_map_add_node(xs, node);
> +	old_xs = xchg(entry, xs);
>  	if (old_xs)
> -		sock_put((struct sock *)old_xs);
> +		xsk_map_del_node(old_xs, entry);
> +	spin_unlock_bh(&m->lock);
>  
>  	sockfd_put(sock);
>  	return 0;
> @@ -206,19 +268,32 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>  static int xsk_map_delete_elem(struct bpf_map *map, void *key)
>  {
>  	struct xsk_map *m = container_of(map, struct xsk_map, map);
> -	struct xdp_sock *old_xs;
> +	struct xdp_sock *old_xs, **map_entry;
>  	int k = *(u32 *)key;
>  
>  	if (k >= map->max_entries)
>  		return -EINVAL;
>  
> -	old_xs = xchg(&m->xsk_map[k], NULL);
> +	spin_lock_bh(&m->lock);
> +	map_entry = &m->xsk_map[k];
> +	old_xs = xchg(map_entry, NULL);
>  	if (old_xs)
> -		sock_put((struct sock *)old_xs);
> +		xsk_map_del_node(old_xs, map_entry);
> +	spin_unlock_bh(&m->lock);
>  
>  	return 0;
>  }
>  
> +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *node)
> +{
> +	struct xsk_map_node *n = list_entry(node, struct xsk_map_node, node);
> +
> +	spin_lock_bh(&n->map->lock);
> +	*n->map_entry = NULL;
> +	spin_unlock_bh(&n->map->lock);
> +	xsk_map_node_free(n);
> +}
> +
>  const struct bpf_map_ops xsk_map_ops = {
>  	.map_alloc = xsk_map_alloc,
>  	.map_free = xsk_map_free,
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..1931d98a7754 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -335,6 +335,27 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
>  	return 0;
>  }
>  
> +static struct list_head *xsk_map_list_pop(struct xdp_sock *xs)
> +{
> +	struct list_head *node = NULL;
> +
> +	spin_lock_bh(&xs->map_list_lock);
> +	if (!list_empty(&xs->map_list)) {
> +		node = xs->map_list.next;
> +		list_del(node);
> +	}
> +	spin_unlock_bh(&xs->map_list_lock);
> +	return node;
> +}
> +
> +static void xsk_delete_from_maps(struct xdp_sock *xs)
> +{
> +	struct list_head *node;
> +
> +	while ((node = xsk_map_list_pop(xs)))
> +		xsk_map_delete_from_node(xs, node);
> +}
> +

I stared at this set for a while and I think there are still two
issues in the design unless I'm missing something obvious.

1) xs teardown and parallel map update:

- CPU0 is in xsk_release(), calls xsk_delete_from_maps().
- CPU1 is in xsk_map_update_elem(), both access the same map slot.
- CPU0 does the xsk_map_list_pop() for that given slot, gets
  interrupted before calling into xsk_map_delete_from_node().
- CPU1 takes m->lock in updates, *entry = xs to the new sock,
  does xsk_map_del_node() to check on the xs (which CPU0 tears
  down). Given this was popped off the list, it doesn't do
  anything here, all good. It unlocks m->lock and succeeds.
- CPU0 now continues in xsk_map_delete_from_node(), takes
  m->lock, zeroes *n->map_entry, releases m->lock, and frees
  n. However, at this point *n->map_entry contains the xs that
  we've just updated on CPU1. So zero'ing it will 1) remove
  the wrong entry, and ii) leak it since it goes out of reach.

2) Inconsistent use of xchg() and friends:

- AF_XDP fast-path is doing READ_ONCE(m->xsk_map[key]) without
  taking m->lock. This is also why you have xchg() for example
  inside m->lock region since both protect different things (should
  probably be commented). However, this is not consistently used.
  E.g. xsk_map_delete_from_node() or xsk_map_update_elem() have
  plain assignment, so compiler could in theory happily perform
  store tearing and the READ_ONCE() would see garbage. This needs
  to be consistently paired.

>  static int xsk_release(struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
> @@ -354,6 +375,7 @@ static int xsk_release(struct socket *sock)
>  	sock_prot_inuse_add(net, sk->sk_prot, -1);
>  	local_bh_enable();
>  
> +	xsk_delete_from_maps(xs);
>  	if (xs->dev) {
>  		struct net_device *dev = xs->dev;
>  
> @@ -767,6 +789,9 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>  	mutex_init(&xs->mutex);
>  	spin_lock_init(&xs->tx_completion_lock);
>  
> +	INIT_LIST_HEAD(&xs->map_list);
> +	spin_lock_init(&xs->map_list_lock);
> +
>  	mutex_lock(&net->xdp.lock);
>  	sk_add_node_rcu(sk, &net->xdp.list);
>  	mutex_unlock(&net->xdp.lock);
> 

