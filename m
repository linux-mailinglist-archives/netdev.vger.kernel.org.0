Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D671CD953
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgEKMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:05:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:33658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729609AbgEKMFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 08:05:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC5B8AC96;
        Mon, 11 May 2020 12:05:34 +0000 (UTC)
Subject: Re: [PATCH net-next v9 1/2] xen networking: add basic XDP support for
 xen-netfront
To:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org
Cc:     brouer@redhat.com, wei.liu@kernel.org, paul@xen.org,
        ilias.apalodimas@linaro.org
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-2-git-send-email-kda@linux-powerpc.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <649c940c-200b-f644-8932-7d54ac21a98b@suse.com>
Date:   Mon, 11 May 2020 14:05:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589192541-11686-2-git-send-email-kda@linux-powerpc.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.05.20 12:22, Denis Kirjanov wrote:
> The patch adds a basic XDP processing to xen-netfront driver.
> 
> We ran an XDP program for an RX response received from netback
> driver. Also we request xen-netback to adjust data offset for
> bpf_xdp_adjust_head() header space for custom headers.
> 
> synchronization between frontend and backend parts is done
> by using xenbus state switching:
> Reconfiguring -> Reconfigured- > Connected
> 
> UDP packets drop rate using xdp program is around 310 kpps
> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.

I'm still not seeing proper synchronization between frontend and
backend when an XDP program is activated.

Consider the following:

1. XDP program is not active, so RX responses have no XDP headroom
2. netback has pushed one (or more) RX responses to the ring page
3. XDP program is being activated -> Reconfiguring
4. netback acknowledges, will add XDP headroom for following RX
    responses
5. netfront reads RX response (2.) without XDP headroom from ring page
6. boom!


Juergen

> 
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> ---
>   drivers/net/Kconfig        |   1 +
>   drivers/net/xen-netfront.c | 317 ++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 312 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 25a8f93..45918ce 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -479,6 +479,7 @@ config XEN_NETDEV_FRONTEND
>   	tristate "Xen network device frontend driver"
>   	depends on XEN
>   	select XEN_XENBUS_FRONTEND
> +	select PAGE_POOL
>   	default y
>   	help
>   	  This driver provides support for Xen paravirtual network
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..33544c7 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -44,6 +44,9 @@
>   #include <linux/mm.h>
>   #include <linux/slab.h>
>   #include <net/ip.h>
> +#include <linux/bpf.h>
> +#include <net/page_pool.h>
> +#include <linux/bpf_trace.h>
>   
>   #include <xen/xen.h>
>   #include <xen/xenbus.h>
> @@ -102,6 +105,8 @@ struct netfront_queue {
>   	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>   	struct netfront_info *info;
>   
> +	struct bpf_prog __rcu *xdp_prog;
> +
>   	struct napi_struct napi;
>   
>   	/* Split event channels support, tx_* == rx_* when using
> @@ -144,6 +149,9 @@ struct netfront_queue {
>   	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
>   	grant_ref_t gref_rx_head;
>   	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
> +
> +	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
>   };
>   
>   struct netfront_info {
> @@ -159,6 +167,10 @@ struct netfront_info {
>   	struct netfront_stats __percpu *rx_stats;
>   	struct netfront_stats __percpu *tx_stats;
>   
> +	/* XDP state */
> +	bool netback_has_xdp_headroom;
> +	bool netfront_xdp_enabled;
> +
>   	atomic_t rx_gso_checksum_fixup;
>   };
>   
> @@ -265,8 +277,8 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
>   	if (unlikely(!skb))
>   		return NULL;
>   
> -	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> -	if (!page) {
> +	page = page_pool_dev_alloc_pages(queue->page_pool);
> +	if (unlikely(!page)) {
>   		kfree_skb(skb);
>   		return NULL;
>   	}
> @@ -560,6 +572,64 @@ static u16 xennet_select_queue(struct net_device *dev, struct sk_buff *skb,
>   	return queue_idx;
>   }
>   
> +static int xennet_xdp_xmit_one(struct net_device *dev, struct xdp_frame *xdpf)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
> +	struct netfront_queue *queue = NULL;
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned long flags;
> +	int notify;
> +	struct xen_netif_tx_request *tx;
> +
> +	queue = &np->queues[smp_processor_id() % num_queues];
> +
> +	spin_lock_irqsave(&queue->tx_lock, flags);
> +
> +	tx = xennet_make_first_txreq(queue, NULL,
> +				     virt_to_page(xdpf->data),
> +				     offset_in_page(xdpf->data),
> +				     xdpf->len);
> +
> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
> +	if (notify)
> +		notify_remote_via_irq(queue->tx_irq);
> +
> +	u64_stats_update_begin(&tx_stats->syncp);
> +	tx_stats->bytes += xdpf->len;
> +	tx_stats->packets++;
> +	u64_stats_update_end(&tx_stats->syncp);
> +
> +	xennet_tx_buf_gc(queue);
> +
> +	spin_unlock_irqrestore(&queue->tx_lock, flags);
> +	return 0;
> +}
> +
> +static int xennet_xdp_xmit(struct net_device *dev, int n,
> +			   struct xdp_frame **frames, u32 flags)
> +{
> +	int drops = 0;
> +	int i, err;
> +
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +		return -EINVAL;
> +
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +
> +		if (!xdpf)
> +			continue;
> +		err = xennet_xdp_xmit_one(dev, xdpf);
> +		if (err) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			drops++;
> +		}
> +	}
> +
> +	return n - drops;
> +}
> +
>   #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
>   
>   static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -778,9 +848,56 @@ static int xennet_get_extras(struct netfront_queue *queue,
>   	return err;
>   }
>   
> +static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +			  struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +			  struct xdp_buff *xdp, bool *need_xdp_flush)
> +{
> +	struct xdp_frame *xdpf;
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +	int err;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->rxq = &queue->xdp_rxq;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_TX:
> +		get_page(pdata);
> +		xdpf = convert_to_xdp_frame(xdp);
> +		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
> +		if (unlikely(err < 0))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +	case XDP_REDIRECT:
> +		get_page(pdata);
> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
> +		*need_xdp_flush = true;
> +		if (unlikely(err))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +	case XDP_PASS:
> +	case XDP_DROP:
> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +	return act;
> +}
> +
>   static int xennet_get_responses(struct netfront_queue *queue,
>   				struct netfront_rx_info *rinfo, RING_IDX rp,
> -				struct sk_buff_head *list)
> +				struct sk_buff_head *list,
> +				bool *need_xdp_flush)
>   {
>   	struct xen_netif_rx_response *rx = &rinfo->rx;
>   	struct xen_netif_extra_info *extras = rinfo->extras;
> @@ -792,6 +909,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>   	int slots = 1;
>   	int err = 0;
>   	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
>   
>   	if (rx->flags & XEN_NETRXF_extra_info) {
>   		err = xennet_get_extras(queue, extras, rp);
> @@ -827,9 +947,24 @@ static int xennet_get_responses(struct netfront_queue *queue,
>   
>   		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>   
> -		__skb_queue_tail(list, skb);
> -
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			if (!(rx->flags & XEN_NETRXF_more_data)) {
> +				/* currently only a single page contains data */
> +				verdict = xennet_run_xdp(queue,
> +							 skb_frag_page(&skb_shinfo(skb)->frags[0]),
> +							 rx, xdp_prog, &xdp, need_xdp_flush);
> +				if (verdict != XDP_PASS)
> +					err = -EINVAL;
> +			} else {
> +				/* drop the frame */
> +				err = -EINVAL;
> +			}
> +		}
> +		rcu_read_unlock();
>   next:
> +		__skb_queue_tail(list, skb);
>   		if (!(rx->flags & XEN_NETRXF_more_data))
>   			break;
>   
> @@ -997,7 +1132,9 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>   	struct sk_buff_head rxq;
>   	struct sk_buff_head errq;
>   	struct sk_buff_head tmpq;
> +	struct bpf_prog *xdp_prog;
>   	int err;
> +	bool need_xdp_flush = false;
>   
>   	spin_lock(&queue->rx_lock);
>   
> @@ -1010,11 +1147,17 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>   
>   	i = queue->rx.rsp_cons;
>   	work_done = 0;
> +	rcu_read_lock();
>   	while ((i != rp) && (work_done < budget)) {
>   		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
>   		memset(extras, 0, sizeof(rinfo.extras));
>   
> -		err = xennet_get_responses(queue, &rinfo, rp, &tmpq);
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog)
> +			rx->offset = XDP_PACKET_HEADROOM;
> +
> +		err = xennet_get_responses(queue, &rinfo, rp, &tmpq,
> +					   &need_xdp_flush);
>   
>   		if (unlikely(err)) {
>   err:
> @@ -1060,6 +1203,9 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>   		i = ++queue->rx.rsp_cons;
>   		work_done++;
>   	}
> +	if (need_xdp_flush)
> +		xdp_do_flush();
> +	rcu_read_unlock();
>   
>   	__skb_queue_purge(&errq);
>   
> @@ -1261,6 +1407,98 @@ static void xennet_poll_controller(struct net_device *dev)
>   }
>   #endif
>   
> +#define NETBACK_XDP_HEADROOM_DISABLE	0
> +#define NETBACK_XDP_HEADROOM_ENABLE	1
> +
> +static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
> +{
> +	int err;
> +
> +	err = xenbus_printf(XBT_NIL, np->xbdev->nodename,
> +			    "feature-xdp", "%u", xdp);
> +	if (err)
> +		pr_debug("Error writing feature-xdp\n");
> +
> +	return err;
> +}
> +
> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int i, err;
> +	unsigned long max_mtu = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
> +
> +	if (dev->mtu > max_mtu) {
> +		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_mtu);
> +		return -EINVAL;
> +	}
> +
> +	if (!np->netback_has_xdp_headroom)
> +		return 0;
> +
> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
> +
> +	err = talk_to_netback_xdp(np, prog ? NETBACK_XDP_HEADROOM_ENABLE :
> +				  NETBACK_XDP_HEADROOM_DISABLE);
> +	if (err)
> +		return err;
> +
> +	/* avoid race with XDP headroom adjustment */
> +	wait_event(module_wq,
> +		   xenbus_read_driver_state(np->xbdev->otherend) ==
> +		   XenbusStateReconfigured);
> +	np->netfront_xdp_enabled = true;
> +
> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
> +
> +	if (prog)
> +		bpf_prog_add(prog, dev->real_num_tx_queues);
> +
> +	for (i = 0; i < dev->real_num_tx_queues; ++i)
> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
> +
> +	if (old_prog)
> +		for (i = 0; i < dev->real_num_tx_queues; ++i)
> +			bpf_prog_put(old_prog);
> +
> +	xenbus_switch_state(np->xbdev, XenbusStateConnected);
> +
> +	return 0;
> +}
> +
> +static u32 xennet_xdp_query(struct net_device *dev)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned int i;
> +	struct netfront_queue *queue;
> +	const struct bpf_prog *xdp_prog;
> +
> +	for (i = 0; i < num_queues; ++i) {
> +		queue = &np->queues[i];
> +		xdp_prog = rtnl_dereference(queue->xdp_prog);
> +		if (xdp_prog)
> +			return xdp_prog->aux->id;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = xennet_xdp_query(dev);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static const struct net_device_ops xennet_netdev_ops = {
>   	.ndo_open            = xennet_open,
>   	.ndo_stop            = xennet_close,
> @@ -1272,6 +1510,8 @@ static void xennet_poll_controller(struct net_device *dev)
>   	.ndo_fix_features    = xennet_fix_features,
>   	.ndo_set_features    = xennet_set_features,
>   	.ndo_select_queue    = xennet_select_queue,
> +	.ndo_bpf            = xennet_xdp,
> +	.ndo_xdp_xmit	    = xennet_xdp_xmit,
>   #ifdef CONFIG_NET_POLL_CONTROLLER
>   	.ndo_poll_controller = xennet_poll_controller,
>   #endif
> @@ -1331,6 +1571,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
>   	SET_NETDEV_DEV(netdev, &dev->dev);
>   
>   	np->netdev = netdev;
> +	np->netfront_xdp_enabled = false;
>   
>   	netif_carrier_off(netdev);
>   
> @@ -1419,6 +1660,8 @@ static void xennet_disconnect_backend(struct netfront_info *info)
>   		queue->rx_ring_ref = GRANT_INVALID_REF;
>   		queue->tx.sring = NULL;
>   		queue->rx.sring = NULL;
> +
> +		page_pool_destroy(queue->page_pool);
>   	}
>   }
>   
> @@ -1754,6 +1997,49 @@ static void xennet_destroy_queues(struct netfront_info *info)
>   	info->queues = NULL;
>   }
>   
> +static int xennet_create_page_pool(struct netfront_queue *queue)
> +{
> +	int err;
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = 0,
> +		.pool_size = NET_RX_RING_SIZE,
> +		.nid = NUMA_NO_NODE,
> +		.dev = &queue->info->netdev->dev,
> +		.offset = XDP_PACKET_HEADROOM,
> +		.max_len = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> +	};
> +
> +	queue->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(queue->page_pool)) {
> +		err = PTR_ERR(queue->page_pool);
> +		queue->page_pool = NULL;
> +		return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&queue->xdp_rxq, queue->info->netdev,
> +			       queue->id);
> +	if (err) {
> +		netdev_err(queue->info->netdev, "xdp_rxq_info_reg failed\n");
> +		goto err_free_pp;
> +	}
> +
> +	err = xdp_rxq_info_reg_mem_model(&queue->xdp_rxq,
> +					 MEM_TYPE_PAGE_POOL, queue->page_pool);
> +	if (err) {
> +		netdev_err(queue->info->netdev, "xdp_rxq_info_reg_mem_model failed\n");
> +		goto err_unregister_rxq;
> +	}
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&queue->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(queue->page_pool);
> +	queue->page_pool = NULL;
> +	return err;
> +}
> +
>   static int xennet_create_queues(struct netfront_info *info,
>   				unsigned int *num_queues)
>   {
> @@ -1779,6 +2065,14 @@ static int xennet_create_queues(struct netfront_info *info,
>   			break;
>   		}
>   
> +		/* use page pool recycling instead of buddy allocator */
> +		ret = xennet_create_page_pool(queue);
> +		if (ret < 0) {
> +			dev_err(&info->xbdev->dev, "can't allocate page pool\n");
> +			*num_queues = i;
> +			return ret;
> +		}
> +
>   		netif_napi_add(queue->info->netdev, &queue->napi,
>   			       xennet_poll, 64);
>   		if (netif_running(info->netdev))
> @@ -1825,6 +2119,15 @@ static int talk_to_netback(struct xenbus_device *dev,
>   		goto out_unlocked;
>   	}
>   
> +	info->netback_has_xdp_headroom = xenbus_read_unsigned(info->xbdev->otherend,
> +							      "feature-xdp-headroom", 0);
> +	/* set the current xen-netfront xdp state */
> +	err = talk_to_netback_xdp(info, info->netfront_xdp_enabled ?
> +				  NETBACK_XDP_HEADROOM_ENABLE :
> +				  NETBACK_XDP_HEADROOM_DISABLE);
> +	if (err)
> +		goto out_unlocked;
> +
>   	rtnl_lock();
>   	if (info->queues)
>   		xennet_destroy_queues(info);
> @@ -1959,6 +2262,8 @@ static int xennet_connect(struct net_device *dev)
>   	err = talk_to_netback(np->xbdev, np);
>   	if (err)
>   		return err;
> +	if (np->netback_has_xdp_headroom)
> +		pr_info("backend supports XDP headroom\n");
>   
>   	/* talk_to_netback() sets the correct number of queues */
>   	num_queues = dev->real_num_tx_queues;
> 

