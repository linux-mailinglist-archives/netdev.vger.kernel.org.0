Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB751386B9
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 14:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbgALN5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 08:57:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:11144 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732951AbgALN5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 08:57:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 05:57:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,425,1571727600"; 
   d="scan'208";a="422571332"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jan 2020 05:57:00 -0800
Date:   Sun, 12 Jan 2020 07:49:48 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf-next PATCH v2 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
Message-ID: <20200112064948.GA24292@ranger.igk.intel.com>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
 <157879666276.8200.5529955400195897154.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157879666276.8200.5529955400195897154.stgit@john-Precision-5820-Tower>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 06:37:42PM -0800, John Fastabend wrote:
> Now that we depend on rcu_call() and synchronize_rcu() to also wait
> for preempt_disabled region to complete the rcu read critical section
> in __dev_map_flush() is no longer required. Except in a few special
> cases in drivers that need it for other reasons.
> 
> These originally ensured the map reference was safe while a map was
> also being free'd. And additionally that bpf program updates via
> ndo_bpf did not happen while flush updates were in flight. But flush
> by new rules can only be called from preempt-disabled NAPI context.
> The synchronize_rcu from the map free path and the rcu_call from the
> delete path will ensure the reference there is safe. So lets remove
> the rcu_read_lock and rcu_read_unlock pair to avoid any confusion
> around how this is being protected.
> 
> If the rcu_read_lock was required it would mean errors in the above
> logic and the original patch would also be wrong.
> 
> Now that we have done above we put the rcu_read_lock in the driver
> code where it is needed in a driver dependent way. I think this
> helps readability of the code so we know where and why we are
> taking read locks. Most drivers will not need rcu_read_locks here
> and further XDP drivers already have rcu_read_locks in their code
> paths for reading xdp programs on RX side so this makes it symmetric
> where we don't have half of rcu critical sections define in driver
> and the other half in devmap.
> 
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  drivers/net/veth.c       |    6 +++++-
>  drivers/net/virtio_net.c |    8 ++++++--
>  kernel/bpf/devmap.c      |    5 +++--
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index a552df3..184e1b4 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -377,6 +377,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>  	unsigned int max_len;
>  	struct veth_rq *rq;
>  
> +	rcu_read_lock();
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>  		ret = -EINVAL;
>  		goto drop;
> @@ -418,11 +419,14 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>  	if (flags & XDP_XMIT_FLUSH)
>  		__veth_xdp_flush(rq);
>  
> -	if (likely(!drops))
> +	if (likely(!drops)) {
> +		rcu_read_unlock();
>  		return n;
> +	}
>  
>  	ret = n - drops;
>  drop:
> +	rcu_read_unlock();
>  	atomic64_add(drops, &priv->dropped);
>  
>  	return ret;
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434..2c11f82 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -498,12 +498,16 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	void *ptr;
>  	int i;
>  
> +	rcu_read_lock();
> +
>  	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
>  	 * indicate XDP resources have been successfully allocated.
>  	 */
>  	xdp_prog = rcu_dereference(rq->xdp_prog);

We could convert that rcu_dereference to rcu_access_pointer so that we
don't need the rcu critical section here at all. Actually this was
suggested some time ago by David Ahern during the initial discussion
around this code. Not sure why we didn't change it.

Veth is also checking the xdp prog presence and it is doing that via
rcu_access_pointer so such conversion would make it more common, no?

xdp_prog is only check against NULL, so quoting the part of comment from
rcu_access_pointer:
"This is useful when the value of this pointer is accessed, but the pointer
is not dereferenced, for example, when testing an RCU-protected pointer
against NULL."

> -	if (!xdp_prog)
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
>  		return -ENXIO;
> +	}
>  
>  	sq = virtnet_xdp_sq(vi);
>  
> @@ -552,7 +556,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	sq->stats.xdp_tx_drops += drops;
>  	sq->stats.kicks += kicks;
>  	u64_stats_update_end(&sq->stats.syncp);
> -
> +	rcu_read_unlock();
>  	return ret;
>  }
>  
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f0bf525..d0ce2e2 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -372,16 +372,17 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
>   * from NET_RX_SOFTIRQ. Either way the poll routine must complete before the
>   * net device can be torn down. On devmap tear down we ensure the flush list
>   * is empty before completing to ensure all flush operations have completed.
> + * When drivers update the bpf program they may need to ensure any flush ops
> + * are also complete. Using synchronize_rcu or call_rcu will suffice for this
> + * because both wait for napi context to exit.
>   */
>  void __dev_map_flush(void)
>  {
>  	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
>  	struct xdp_bulk_queue *bq, *tmp;
>  
> -	rcu_read_lock();
>  	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
>  		bq_xmit_all(bq, XDP_XMIT_FLUSH);
> -	rcu_read_unlock();
>  }
>  
>  /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
> 
