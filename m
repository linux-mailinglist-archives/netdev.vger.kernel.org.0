Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFDC175E2F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCBP3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:29:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:55388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgCBP3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 10:29:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96E2CAFE8;
        Mon,  2 Mar 2020 15:29:42 +0000 (UTC)
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
Date:   Mon, 2 Mar 2020 16:29:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.03.20 15:21, Denis Kirjanov wrote:
> the patch adds a basic xdo logic to the netfront driver
> 
> XDP redirect is not supported yet
> 
> v2:
> - avoid data copying while passing to XDP
> - tell xen-natback that we need the headroom space

Please add the patch history below the "---" delimiter

> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>   drivers/net/xen-netback/common.h |   1 +
>   drivers/net/xen-netback/rx.c     |   9 ++-
>   drivers/net/xen-netback/xenbus.c |  21 ++++++
>   drivers/net/xen-netfront.c       | 157 +++++++++++++++++++++++++++++++++++++++
>   4 files changed, 186 insertions(+), 2 deletions(-)

You are modifying xen-netback sources. Please Cc the maintainers.

> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 05847eb..0750c6f 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -280,6 +280,7 @@ struct xenvif {
>   	u8 ip_csum:1;
>   	u8 ipv6_csum:1;
>   	u8 multicast_control:1;
> +	u8 xdp_enabled:1;
>   
>   	/* Is this interface disabled? True when backend discovers
>   	 * frontend is rogue.
> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
> index ef58870..a110a59 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -33,6 +33,11 @@
>   #include <xen/xen.h>
>   #include <xen/events.h>
>   
> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
> +{
> +	return (vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0);
> +}
> +
>   static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
>   {
>   	RING_IDX prod, cons;
> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
>   				struct xen_netif_rx_request *req,
>   				struct xen_netif_rx_response *rsp)
>   {
> -	unsigned int offset = 0;
> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>   	unsigned int flags;
>   
>   	do {
> @@ -389,7 +394,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
>   			flags |= XEN_NETRXF_extra_info;
>   	}
>   
> -	rsp->offset = 0;
> +	rsp->offset = xenvif_rx_xdp_offset(queue->vif);
>   	rsp->flags = flags;
>   	rsp->id = req->id;
>   	rsp->status = (s16)offset;
> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
> index 286054b..81a6023 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
>   	}
>   }
>   
> +static void read_xenbus_fronetend_xdp(struct backend_info *be,
> +				      struct xenbus_device *dev)

Typo: s/fronetend/frontend/

> +{
> +	struct xenvif *vif = be->vif;
> +	unsigned int val;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "feature-xdp", "%u", &val);
> +	if (err < 0)
> +		return;
> +	vif->xdp_enabled = val;
> +}
> +
>   /**
>    * Callback received when the frontend's state changes.
>    */
> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device *dev,
>   		set_backend_state(be, XenbusStateConnected);
>   		break;
>   
> +	case XenbusStateReconfiguring:
> +		read_xenbus_fronetend_xdp(be, dev);
> +		xenbus_switch_state(dev, XenbusStateReconfigured);
> +		break;
> +
Where is the reaction to the backend being set to "Reconfigured"?

>   	case XenbusStateClosing:
>   		set_backend_state(be, XenbusStateClosing);
>   		break;
> @@ -935,6 +954,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
>   
>   	vif->gso_mask = 0;
>   
> +	vif->xdp_enabled = 0;
> +
>   	if (xenbus_read_unsigned(dev->otherend, "feature-gso-tcpv4", 0))
>   		vif->gso_mask |= GSO_BIT(TCPV4);
>   
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..db8a280 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -44,6 +44,8 @@
>   #include <linux/mm.h>
>   #include <linux/slab.h>
>   #include <net/ip.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
>   
>   #include <xen/xen.h>
>   #include <xen/xenbus.h>
> @@ -102,6 +104,8 @@ struct netfront_queue {
>   	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>   	struct netfront_info *info;
>   
> +	struct bpf_prog __rcu *xdp_prog;
> +
>   	struct napi_struct napi;
>   
>   	/* Split event channels support, tx_* == rx_* when using
> @@ -778,6 +782,40 @@ static int xennet_get_extras(struct netfront_queue *queue,
>   	return err;
>   }
>   
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +	case XDP_TX:
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
> +	if (act != XDP_PASS && act != XDP_TX)
> +		xdp->data_hard_start = NULL;
> +
> +	return act;
> +}
> +
>   static int xennet_get_responses(struct netfront_queue *queue,
>   				struct netfront_rx_info *rinfo, RING_IDX rp,
>   				struct sk_buff_head *list)
> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>   	int slots = 1;
>   	int err = 0;
>   	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
>   
>   	if (rx->flags & XEN_NETRXF_extra_info) {
>   		err = xennet_get_extras(queue, extras, rp);
> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_queue *queue,
>   
>   		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>   
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			/* currently only a single page contains data */
> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
> +			verdict = xennet_run_xdp(queue,
> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
> +				       rx, xdp_prog, &xdp);
> +
> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
> +				err = -EINVAL;
> +				goto next;
> +			}
> +
> +		}
> +		rcu_read_unlock();
>   		__skb_queue_tail(list, skb);
>   
>   next:
> @@ -1261,6 +1318,105 @@ static void xennet_poll_controller(struct net_device *dev)
>   }
>   #endif
>   
> +#define NETBACK_XDP_HEADROOM_DISABLE	0
> +#define NETBACK_XDP_HEADROOM_ENABLE	1
> +
> +static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
> +{
> +	struct xenbus_transaction xbt;
> +	const char *message;
> +	int err;
> +
> +again:
> +	err = xenbus_transaction_start(&xbt);
> +	if (err) {
> +		xenbus_dev_fatal(np->xbdev, err, "starting transaction");
> +		goto out;
> +	}
> +
> +	err = xenbus_printf(xbt, np->xbdev->nodename, "feature-xdp", "%d", xdp);
> +	if (err) {
> +		message = "writing feature-xdp";
> +		goto abort_transaction;
> +	}
> +
> +	err = xenbus_transaction_end(xbt, 0);
> +	if (err) {
> +		if (err == -EAGAIN)
> +			goto again;

Writing a single node to Xenstore doesn't need a transaction.

> +	}
> +
> +	return 0;
> +
> +abort_transaction:
> +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
> +	xenbus_transaction_end(xbt, 1);
> +out:
> +	return err;
> +}
> +
> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int i, err;
> +
> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
> +	if (!old_prog && !prog)
> +		return 0;
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
> +	err = talk_to_netback_xdp(np, old_prog ? NETBACK_XDP_HEADROOM_DISABLE:
> +				  NETBACK_XDP_HEADROOM_ENABLE);
> +	if (err)
> +		return err;
> +
> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);

What is happening in case the backend doesn't support XDP?

Is it really a good idea to communicate xdp_set via a frontend state
change? This will be rather slow. OTOH I have no idea how often this
might happen.


Juergen
