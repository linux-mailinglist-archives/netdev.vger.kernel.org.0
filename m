Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD49CF485
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbfJHIFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:05:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:8902 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbfJHIFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 04:05:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 01:05:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="199747090"
Received: from iannetti-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.81])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 01:05:40 -0700
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets
 directly from a queue
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0c8a45d6-3bd1-6771-3859-7990660f74a3@intel.com>
Date:   Tue, 8 Oct 2019 10:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-08 08:16, Sridhar Samudrala wrote:
> Introduce a flag that can be specified during the bind() call
> of an AF_XDP socket to receive packets directly from a queue when there is
> no XDP program attached to the device.
> 
> This is enabled by introducing a special BPF prog pointer called
> BPF_PROG_DIRECT_XSK and a new bind flag XDP_DIRECT that can be specified
> when binding an AF_XDP socket to a queue. At the time of bind(), an AF_XDP
> socket in XDP_DIRECT mode, will attach BPF_PROG_DIRECT_XSK as a bpf program
> if there is no other XDP program attached to the device. The device receive
> queue is also associated with the AF_XDP socket.
> 
> In the XDP receive path, if the bpf program is a DIRECT_XSK program, the
> XDP buffer is passed to the AF_XDP socket that is associated with the
> receive queue on which the packet is received.
> 
> To avoid any overhead for nomal XDP programs, a static key is used to keep
> a count of AF_XDP direct xsk sockets and static_branch_unlikely() is used
> to handle receives for direct XDP sockets.
> 
> Any attach of a normal XDP program will take precedence and the direct xsk
> program will be removed. The direct XSK program will be attached
> automatically when the normal XDP program is removed when there are any
> AF_XDP direct sockets associated with that device.
> 
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>   include/linux/filter.h            | 18 ++++++++++++
>   include/linux/netdevice.h         | 10 +++++++
>   include/net/xdp_sock.h            |  5 ++++
>   include/uapi/linux/if_xdp.h       |  5 ++++
>   kernel/bpf/syscall.c              |  7 +++--
>   net/core/dev.c                    | 50 +++++++++++++++++++++++++++++++++
>   net/core/filter.c                 | 58 +++++++++++++++++++++++++++++++++++++++
>   net/xdp/xsk.c                     | 51 ++++++++++++++++++++++++++++++++--
>   tools/include/uapi/linux/if_xdp.h |  5 ++++
>   9 files changed, 204 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 2ce57645f3cd..db4ad85d8321 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -585,6 +585,9 @@ struct bpf_redirect_info {
>   	struct bpf_map *map;
>   	struct bpf_map *map_to_flush;
>   	u32 kern_flags;
> +#ifdef CONFIG_XDP_SOCKETS
> +	struct xdp_sock *xsk;
> +#endif
>   };
>   
>   DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
> @@ -693,6 +696,16 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
>   	return res;
>   }
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +#define BPF_PROG_DIRECT_XSK	0x1
> +#define bpf_is_direct_xsk_prog(prog) \
> +	((unsigned long)prog == BPF_PROG_DIRECT_XSK)
> +DECLARE_STATIC_KEY_FALSE(xdp_direct_xsk_needed);
> +u32 bpf_direct_xsk(const struct bpf_prog *prog, struct xdp_buff *xdp);
> +#else
> +#define bpf_is_direct_xsk_prog(prog) (false)
> +#endif
> +
>   static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>   					    struct xdp_buff *xdp)
>   {
> @@ -702,6 +715,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>   	 * already takes rcu_read_lock() when fetching the program, so
>   	 * it's not necessary here anymore.
>   	 */
> +#ifdef CONFIG_XDP_SOCKETS
> +	if (static_branch_unlikely(&xdp_direct_xsk_needed) &&
> +	    bpf_is_direct_xsk_prog(prog))
> +		return bpf_direct_xsk(prog, xdp);
> +#endif
>   	return BPF_PROG_RUN(prog, xdp);
>   }
>   
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 48cc71aae466..f4d0f70aa718 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -743,6 +743,7 @@ struct netdev_rx_queue {
>   	struct xdp_rxq_info		xdp_rxq;
>   #ifdef CONFIG_XDP_SOCKETS
>   	struct xdp_umem                 *umem;
> +	struct xdp_sock			*xsk;
>   #endif
>   } ____cacheline_aligned_in_smp;
>   
> @@ -1836,6 +1837,10 @@ struct net_device {
>   	atomic_t		carrier_up_count;
>   	atomic_t		carrier_down_count;
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +	u16			direct_xsk_count;

Why u16? num_rx/tx_queues are unsigned ints.

> +#endif
> +
>   #ifdef CONFIG_WIRELESS_EXT
>   	const struct iw_handler_def *wireless_handlers;
>   	struct iw_public_data	*wireless_data;
> @@ -3712,6 +3717,11 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
>   bool is_skb_forwardable(const struct net_device *dev,
>   			const struct sk_buff *skb);
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +int dev_set_direct_xsk_prog(struct net_device *dev);
> +int dev_clear_direct_xsk_prog(struct net_device *dev);
> +#endif
> +
>   static __always_inline int ____dev_forward_skb(struct net_device *dev,
>   					       struct sk_buff *skb)
>   {
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index c9398ce7960f..9158233d34e1 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -76,6 +76,9 @@ struct xsk_map_node {
>   	struct xdp_sock **map_entry;
>   };
>   
> +/* Flags for the xdp_sock flags field. */
> +#define XDP_SOCK_DIRECT (1 << 0)
> +
>   struct xdp_sock {
>   	/* struct sock must be the first member of struct xdp_sock */
>   	struct sock sk;
> @@ -104,6 +107,7 @@ struct xdp_sock {
>   	struct list_head map_list;
>   	/* Protects map_list */
>   	spinlock_t map_list_lock;
> +	u16 flags;

Right now only the XDP_DIRECT is tracked here. Maybe track all flags, 
and show them in xsk_diag.

>   };
>   
>   struct xdp_buff;
> @@ -129,6 +133,7 @@ void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
>   void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
>   void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
>   bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
> +struct xdp_sock *xdp_get_xsk_from_qid(struct net_device *dev, u16 queue_id);
>   
>   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>   			     struct xdp_sock **map_entry);
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index be328c59389d..d202b5d40859 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -25,6 +25,11 @@
>    * application.
>    */
>   #define XDP_USE_NEED_WAKEUP (1 << 3)
> +/* This option allows an AF_XDP socket bound to a queue to receive all
> + * the packets directly from that queue when there is no XDP program
> + * attached to the device.
> + */
> +#define XDP_DIRECT	(1 << 4)
>   
>   /* Flags for xsk_umem_config flags */
>   #define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << 0)
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 205f95af67d2..871d738a78d2 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1349,13 +1349,14 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
>   
>   void bpf_prog_put(struct bpf_prog *prog)
>   {
> -	__bpf_prog_put(prog, true);
> +	if (!bpf_is_direct_xsk_prog(prog))
> +		__bpf_prog_put(prog, true);
>   }
>   EXPORT_SYMBOL_GPL(bpf_prog_put);
>   
>   u32 bpf_get_prog_id(const struct bpf_prog *prog)
>   {
> -	if (prog)
> +	if (prog && !bpf_is_direct_xsk_prog(prog))
>   		return prog->aux->id;
>   
>   	return 0;
> @@ -1364,7 +1365,7 @@ EXPORT_SYMBOL(bpf_get_prog_id);
>   
>   void bpf_set_prog_id(struct bpf_prog *prog, u32 id)
>   {
> -	if (prog)
> +	if (prog && !bpf_is_direct_xsk_prog(prog))
>   		prog->aux->id = id;
>   }
>   EXPORT_SYMBOL(bpf_set_prog_id);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 866d0ad936a5..eb3cd718e580 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8269,6 +8269,10 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>   	} else {
>   		if (!__dev_xdp_query(dev, bpf_op, query))
>   			return 0;
> +#ifdef CONFIG_XDP_SOCKETS
> +		if (dev->direct_xsk_count)
> +			prog = (void *)BPF_PROG_DIRECT_XSK;
> +#endif

Nit, but maybe hide this weirdness in a function?

>   	}
>   
>   	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
> @@ -8278,6 +8282,52 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>   	return err;
>   }
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +int dev_set_direct_xsk_prog(struct net_device *dev)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct bpf_prog *prog;
> +	bpf_op_t bpf_op;
> +
> +	ASSERT_RTNL();
> +
> +	dev->direct_xsk_count++;
> +
> +	bpf_op = ops->ndo_bpf;
> +	if (!bpf_op)
> +		return -EOPNOTSUPP;
> +
> +	if (__dev_xdp_query(dev, bpf_op, XDP_QUERY_PROG))
> +		return 0;
> +
> +	prog = (void *)BPF_PROG_DIRECT_XSK;
> +
> +	return dev_xdp_install(dev, bpf_op, NULL, XDP_FLAGS_DRV_MODE, prog);
> +}
> +
> +int dev_clear_direct_xsk_prog(struct net_device *dev)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	bpf_op_t bpf_op;
> +
> +	ASSERT_RTNL();
> +
> +	dev->direct_xsk_count--;
> +
> +	if (dev->direct_xsk_count)
> +		return 0;
> +
> +	bpf_op = ops->ndo_bpf;
> +	if (!bpf_op)
> +		return -EOPNOTSUPP;
> +
> +	if (__dev_xdp_query(dev, bpf_op, XDP_QUERY_PROG))
> +		return 0;
> +
> +	return dev_xdp_install(dev, bpf_op, NULL, XDP_FLAGS_DRV_MODE, NULL);
> +}
> +#endif
> +
>   /**
>    *	dev_new_index	-	allocate an ifindex
>    *	@net: the applicable net namespace
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ed6563622ce3..391d7d600284 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -73,6 +73,7 @@
>   #include <net/lwtunnel.h>
>   #include <net/ipv6_stubs.h>
>   #include <net/bpf_sk_storage.h>
> +#include <linux/static_key.h>
>   
>   /**
>    *	sk_filter_trim_cap - run a packet through a socket filter
> @@ -3546,6 +3547,22 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
>   	return 0;
>   }
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +static void xdp_do_flush_xsk(struct bpf_redirect_info *ri)
> +{
> +	struct xdp_sock *xsk = READ_ONCE(ri->xsk);

Why READ_ONCE here?

> +
> +	if (xsk) {
> +		ri->xsk = NULL;
> +		xsk_flush(xsk);
> +	}
> +}
> +#else
> +static inline void xdp_do_flush_xsk(struct bpf_redirect_info *ri)
> +{
> +}
> +#endif
> +

Move CONFIG_XDP_SOCKETS into the function, and remove the empty/bottom one.

>   void xdp_do_flush_map(void)
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> @@ -3568,6 +3585,8 @@ void xdp_do_flush_map(void)
>   			break;
>   		}
>   	}
> +
> +	xdp_do_flush_xsk(ri);
>   }
>   EXPORT_SYMBOL_GPL(xdp_do_flush_map);
>   
> @@ -3631,11 +3650,28 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>   	return err;
>   }
>   
> +#ifdef CONFIG_XDP_SOCKETS
> +static inline struct xdp_sock *xdp_get_direct_xsk(struct bpf_redirect_info *ri)
> +{
> +	return READ_ONCE(ri->xsk);

Again, why READ_ONCE? Please leave the inlining to the compiler in .c files.

> +}
> +#else
> +static inline struct xdp_sock *xdp_get_direct_xsk(struct bpf_redirect_info *ri)
> +{
> +	return NULL;
> +}
> +#endif
> +
>   int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>   		    struct bpf_prog *xdp_prog)
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>   	struct bpf_map *map = READ_ONCE(ri->map);
> +	struct xdp_sock *xsk;
> +
> +	xsk = xdp_get_direct_xsk(ri);
> +	if (xsk)
> +		return xsk_rcv(xsk, xdp);

Hmm, maybe you need a xsk_to_flush as well. Say that a user swaps in a
regular XDP program, then xsk_rcv() will be called until the flush
occurs, right? IOW, all packets processed (napi budget) in the napi_poll
will end up in the socket.

>   
>   	if (likely(map))
>   		return xdp_do_redirect_map(dev, xdp, xdp_prog, map, ri);
> @@ -8934,4 +8970,26 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
>   
>   const struct bpf_prog_ops sk_reuseport_prog_ops = {
>   };
> +
> +#ifdef CONFIG_XDP_SOCKETS
> +DEFINE_STATIC_KEY_FALSE(xdp_direct_xsk_needed);
> +EXPORT_SYMBOL_GPL(xdp_direct_xsk_needed);
> +
> +u32 bpf_direct_xsk(const struct bpf_prog *prog, struct xdp_buff *xdp)
> +{
> +	struct xdp_sock *xsk;
> +
> +	xsk = xdp_get_xsk_from_qid(xdp->rxq->dev, xdp->rxq->queue_index);
> +	if (xsk) {
> +		struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +
> +		ri->xsk = xsk;
> +		return XDP_REDIRECT;

 From the comment above. I *think* you need to ri->xsk_to_flush. Can the
direct socket (swap socket) change before flush?

> +	}
> +
> +	return XDP_PASS;
> +}
> +EXPORT_SYMBOL(bpf_direct_xsk);
> +#endif
> +
>   #endif /* CONFIG_INET */
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index fa8fbb8fa3c8..8a29939bac7e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -24,6 +24,7 @@
>   #include <linux/rculist.h>
>   #include <net/xdp_sock.h>
>   #include <net/xdp.h>
> +#include <linux/if_link.h>
>   
>   #include "xsk_queue.h"
>   #include "xdp_umem.h"
> @@ -264,6 +265,45 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   	return err;
>   }
>   
> +static void xdp_clear_direct_xsk(struct xdp_sock *xsk)

Use xs, and not xsk for consistency.

> +{
> +	struct net_device *dev = xsk->dev;
> +	u32 qid = xsk->queue_id;
> +
> +	if (!dev->_rx[qid].xsk)
> +		return;
> +
> +	dev_clear_direct_xsk_prog(dev);
> +	dev->_rx[qid].xsk = NULL;
> +	static_branch_dec(&xdp_direct_xsk_needed);
> +	xsk->flags &= ~XDP_SOCK_DIRECT;
> +}
> +
> +static int xdp_set_direct_xsk(struct xdp_sock *xsk)

Same here.

> +{
> +	struct net_device *dev = xsk->dev;
> +	u32 qid = xsk->queue_id;
> +	int err = 0;
> +
> +	if (dev->_rx[qid].xsk)
> +		return -EEXIST;
> +
> +	xsk->flags |= XDP_SOCK_DIRECT;
> +	static_branch_inc(&xdp_direct_xsk_needed);
> +	dev->_rx[qid].xsk = xsk;
> +	err = dev_set_direct_xsk_prog(dev);
> +	if (err)
> +		xdp_clear_direct_xsk(xsk);
> +
> +	return err;
> +}
> +
> +struct xdp_sock *xdp_get_xsk_from_qid(struct net_device *dev, u16 queue_id)
> +{
> +	return dev->_rx[queue_id].xsk;
> +}
> +EXPORT_SYMBOL(xdp_get_xsk_from_qid);
> +
>   void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
>   {
>   	xskq_produce_flush_addr_n(umem->cq, nb_entries);
> @@ -464,6 +504,11 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>   		return;
>   	WRITE_ONCE(xs->state, XSK_UNBOUND);
>   
> +	if (xs->flags & XDP_SOCK_DIRECT) {
> +		rtnl_lock();
> +		xdp_clear_direct_xsk(xs);
> +		rtnl_unlock();
> +	}
>   	/* Wait for driver to stop using the xdp socket. */
>   	xdp_del_sk_umem(xs->umem, xs);
>   	xs->dev = NULL;
> @@ -604,7 +649,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   
>   	flags = sxdp->sxdp_flags;
>   	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY |
> -		      XDP_USE_NEED_WAKEUP))
> +		      XDP_USE_NEED_WAKEUP | XDP_DIRECT))
>   		return -EINVAL;
>   
>   	rtnl_lock();
> @@ -632,7 +677,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		struct socket *sock;
>   
>   		if ((flags & XDP_COPY) || (flags & XDP_ZEROCOPY) ||
> -		    (flags & XDP_USE_NEED_WAKEUP)) {
> +		    (flags & XDP_USE_NEED_WAKEUP) || (flags & XDP_DIRECT)) {
>   			/* Cannot specify flags for shared sockets. */
>   			err = -EINVAL;
>   			goto out_unlock;
> @@ -688,6 +733,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   	xskq_set_umem(xs->rx, xs->umem->size, xs->umem->chunk_mask);
>   	xskq_set_umem(xs->tx, xs->umem->size, xs->umem->chunk_mask);
>   	xdp_add_sk_umem(xs->umem, xs);
> +	if (flags & XDP_DIRECT)
> +		err = xdp_set_direct_xsk(xs);
>   
>   out_unlock:
>   	if (err) {
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
> index be328c59389d..d202b5d40859 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -25,6 +25,11 @@
>    * application.
>    */
>   #define XDP_USE_NEED_WAKEUP (1 << 3)
> +/* This option allows an AF_XDP socket bound to a queue to receive all
> + * the packets directly from that queue when there is no XDP program
> + * attached to the device.
> + */
> +#define XDP_DIRECT	(1 << 4)
>   
>   /* Flags for xsk_umem_config flags */
>   #define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << 0)
> 
