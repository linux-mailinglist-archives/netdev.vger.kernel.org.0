Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD0394793
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE1T6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 15:58:01 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:37078 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhE1T56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 15:57:58 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 15:57:58 EDT
Received: from localhost (unknown [191.7.188.166])
        by sysclose.org (Postfix) with ESMTPSA id 29C142612;
        Fri, 28 May 2021 19:50:07 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 29C142612
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1622231407;
        bh=D0j6GxPlIBW9f8ox5fHoFaN6uWkdULsDB8dh7iYThmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mX2Icc1GeChDgskMx0HT8W95wmCl4zw3+cy2HABk0S1PAtNokzV1qF4MapCbkmzX3
         djBaeag//L/Yvyx6lhnSWR27FtPi1xQEAdEGAfE1KKO160npEDyMO6Dgp/F0hn8gra
         /6OCjvDOzNWYsYzlDOJGG3zARr1fpiYxtZBN/5qeXFgaq6izGCFezTxlepCjvXHMuf
         ZgGSt1JFTDLq0/ctAauUHP6Lq6EKLtRe6d5bJLPNkr7Jr3scRwBxbiSoBT8tuOpZaA
         HCx07VB5AkHQ+7qLIKcZm50UIq0g7Zu4er8Tc+JIZxAveI9QbKZHQiwhqlJIFOUr/F
         0f3XYyvI3iaNw==
Date:   Fri, 28 May 2021 16:49:46 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [ovs-dev] [RFC net-next] openvswitch: Introduce per-cpu upcall
 dispatch
Message-ID: <YLFJWoj6+N1FTmka@p50>
References: <20210430153325.28322-1-mark.d.gray@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430153325.28322-1-mark.d.gray@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Mark,

I think this patch is going in the right direction but there
are some points that I think we should address. See below.

On Fri, Apr 30, 2021 at 11:33:25AM -0400, Mark Gray wrote:
> The Open vSwitch kernel module uses the upcall mechanism to send
> packets from kernel space to user space when it misses in the kernel
> space flow table. The upcall sends packets via a Netlink socket.
> Currently, a Netlink socket is created for every vport. In this way,
> there is a 1:1 mapping between a vport and a Netlink socket.
> When a packet is received by a vport, if it needs to be sent to
> user space, it is sent via the corresponding Netlink socket.
> 
> This mechanism, with various iterations of the corresponding user
> space code, has seen some limitations and issues:
> 
> * On systems with a large number of vports, there is a correspondingly
> large number of Netlink sockets which can limit scaling.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
> * Packet reordering on upcalls.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
> * A thundering herd issue.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
> 
> This patch introduces an alternative, feature-negotiated, upcall
> mode using a per-cpu dispatch rather than a per-vport dispatch.
> 
> In this mode, the Netlink socket to be used for the upcall is
> selected based on the CPU of the thread that is executing the upcall.
> In this way, it resolves the issues above as:
> 
> a) The number of Netlink sockets scales with the number of CPUs
> rather than the number of vports.
> b) Ordering per-flow is maintained as packets are distributed to
> CPUs based on mechanisms such as RSS and flows are distributed
> to a single user space thread.
> c) Packets from a flow can only wake up one user space thread.
> 
> The corresponding user space code can be found at:
> https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html

Thanks for writing a nice commit description.

> 
> Bugzilla: https://bugzilla.redhat.com/1844576
> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
> ---
>  include/uapi/linux/openvswitch.h |  8 ++++
>  net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       | 18 ++++++++
>  net/openvswitch/flow_netlink.c   |  4 --
>  4 files changed, 94 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 8d16744edc31..6571b57b2268 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -70,6 +70,8 @@ enum ovs_datapath_cmd {
>   * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
>   * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
>   * not be sent.
> + * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
> + * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
>   * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
>   * datapath.  Always present in notifications.
>   * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
> @@ -87,6 +89,9 @@ enum ovs_datapath_attr {
>  	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
>  	OVS_DP_ATTR_PAD,
>  	OVS_DP_ATTR_MASKS_CACHE_SIZE,
> +	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
> +				     * dispatch mode
> +				     */
>  	__OVS_DP_ATTR_MAX
>  };
>  
> @@ -127,6 +132,9 @@ struct ovs_vport_stats {
>  /* Allow tc offload recirc sharing */
>  #define OVS_DP_F_TC_RECIRC_SHARING	(1 << 2)
>  
> +/* Allow per-cpu dispatch of upcalls */
> +#define OVS_DP_F_DISPATCH_UPCALL_PER_CPU	(1 << 3)
> +
>  /* Fixed logical ports. */
>  #define OVSP_LOCAL      ((__u32)0)
>  
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 9d6ef6cb9b26..98d54f41fdaa 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -121,6 +121,8 @@ int lockdep_ovsl_is_held(void)
>  #endif
>  
>  static struct vport *new_vport(const struct vport_parms *);
> +static u32 ovs_dp_get_upcall_portid(const struct datapath *, uint32_t);
> +static int ovs_dp_set_upcall_portids(struct datapath *, const struct nlattr *);
>  static int queue_gso_packets(struct datapath *dp, struct sk_buff *,
>  			     const struct sw_flow_key *,
>  			     const struct dp_upcall_info *,
> @@ -238,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>  
>  		memset(&upcall, 0, sizeof(upcall));
>  		upcall.cmd = OVS_PACKET_CMD_MISS;
> -		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
> +
> +		if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
> +			upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
> +		else
> +			upcall.portid = ovs_vport_find_upcall_portid(p, skb);
> +

We don't expect that to change during packet processing, so I
wondered if that could be improved. However, user_feature is
in the same cache line as stats_percpu which is also used.


>  		upcall.mru = OVS_CB(skb)->mru;
>  		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
>  		if (unlikely(error))
> @@ -1590,16 +1597,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>  
>  DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
>  
> +static int ovs_dp_set_upcall_portids(struct datapath *dp,
> +				     const struct nlattr *ids)
> +{
> +	struct dp_portids *old, *dp_portids;
> +
> +	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
> +		return -EINVAL;
> +
> +	old = ovsl_dereference(dp->upcall_portids);
> +
> +	dp_portids = kmalloc(sizeof(*dp_portids) + nla_len(ids),
> +			     GFP_KERNEL);
> +	if (!dp)

I suspect you meant dp_portids.

> +		return -ENOMEM;
> +
> +	dp_portids->n_ids = nla_len(ids) / sizeof(u32);
> +	nla_memcpy(dp_portids->ids, ids, nla_len(ids));
> +
> +	rcu_assign_pointer(dp->upcall_portids, dp_portids);
> +
> +	if (old)
> +		kfree_rcu(old, rcu);

IIRC, the kfree_rcu() checks for NULL pointers.


> +	return 0;
> +}
> +
> +static u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
> +{
> +	struct dp_portids *dp_portids;
> +
> +	dp_portids = rcu_dereference_ovsl(dp->upcall_portids);
> +
> +	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && dp_portids) {

The OVS_DP_F_DISPATCH_UPCALL_PER_CPU needs to be verified
by the caller to decide whether to use this function or
ovs_vport_find_upcall_portid(), so perhaps function could
check only if dp_portids is set.


> +		if (cpu_id < dp_portids->n_ids) {
> +			return dp_portids->ids[cpu_id];
> +		} else if (dp_portids->n_ids > 0 && cpu_id >= dp_portids->n_ids) {
> +			/* If the number of netlink PIDs is mismatched with the number of
> +			 * CPUs as seen by the kernel, log this and send the upcall to an
> +			 * arbitrary socket (0) in order to not drop packets
> +			 */
> +			pr_info_ratelimited("cpu_id mismatch with handler threads");
> +			return dp_portids->ids[0];

Instead of returning a fixed pid for all other unmapped CPUs, perhaps
it could distribute among mapped ones to help with the load:

            return dp_portids->ids[cpu_id % dp_portids->n_ids]


> +		} else {
> +			return 0;
> +		}
> +	} else {
> +		return 0;
> +	}
> +}
> +
>  static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>  {
>  	u32 user_features = 0;
> +	int err;
>  
>  	if (a[OVS_DP_ATTR_USER_FEATURES]) {
>  		user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
>  
>  		if (user_features & ~(OVS_DP_F_VPORT_PIDS |
>  				      OVS_DP_F_UNALIGNED |
> -				      OVS_DP_F_TC_RECIRC_SHARING))
> +				      OVS_DP_F_TC_RECIRC_SHARING |
> +				      OVS_DP_F_DISPATCH_UPCALL_PER_CPU))
>  			return -EOPNOTSUPP;
>  
>  #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> @@ -1620,6 +1678,14 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>  
>  	dp->user_features = user_features;
>  
> +	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
> +	    a[OVS_DP_ATTR_PER_CPU_PIDS]) {
> +		/* Upcall Netlink Port IDs have been updated */
> +		err = ovs_dp_set_upcall_portids(dp, a[OVS_DP_ATTR_PER_CPU_PIDS]);
> +		if (err)
> +			return err;
> +	}

It is possible to switch between per_cpu_pids and per_ports_pids
and vice versa. It seems this patch doesn't count for that.


> +
>  	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
>  		static_branch_enable(&tc_recirc_sharing_support);
>  	else
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 38f7d3e66ca6..6003eba81958 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -50,6 +50,21 @@ struct dp_stats_percpu {
>  	struct u64_stats_sync syncp;
>  };
>  
> +/**
> + * struct dp_portids - array of netlink portids of for a datapath.
> + *                     This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
> + *                     is enabled and must be protected by rcu.
> + * @rcu: RCU callback head for deferred destruction.
> + * @n_ids: Size of @ids array.
> + * @ids: Array storing the Netlink socket PIDs indexed by CPU ID for packets
> + *       that miss the flow table.
> + */
> +struct dp_portids {
> +	struct rcu_head rcu;
> +	u32 n_ids;
> +	u32 ids[];
> +};

It doesn't have any relation to ports, so the name is somewhat
misleading and confusing with the existing one.  What do you
think about the suggestion below:

	struct dp_nlsk_pids {
		struct rcu_head rcu;
		u32 n_pids;
		u32 pids[];
	};

> +
>  /**
>   * struct datapath - datapath for flow-based packet switching
>   * @rcu: RCU callback head for deferred destruction.
> @@ -61,6 +76,7 @@ struct dp_stats_percpu {
>   * @net: Reference to net namespace.
>   * @max_headroom: the maximum headroom of all vports in this datapath; it will
>   * be used by all the internal vports in this dp.
> + * @upcall_portids: RCU protected 'struct dp_portids'.
>   *
>   * Context: See the comment on locking at the top of datapath.c for additional
>   * locking information.
> @@ -87,6 +103,8 @@ struct datapath {
>  
>  	/* Switch meters. */
>  	struct dp_meter_table meter_tbl;
> +
> +	struct dp_portids __rcu *upcall_portids;
>  };
>  
>  /**
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index fd1f809e9bc1..97242bc1d960 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -2928,10 +2928,6 @@ static int validate_userspace(const struct nlattr *attr)
>  	if (error)
>  		return error;
>  
> -	if (!a[OVS_USERSPACE_ATTR_PID] ||
> -	    !nla_get_u32(a[OVS_USERSPACE_ATTR_PID]))
> -		return -EINVAL;
> -

It can't be removed because it is still required by ovs_dp_upcall().

There is a problem with the action output_userspace which still
uses the netlink OVS_USERSPACE_ATTR_PID to set upcall.portid.
Later ovs_dp_upcall() returns -ENOTCONN if that is missing.

The userspace patchset posted together with this patch does:

  static uint32_t
  dpif_netlink_port_get_pid(const struct dpif *dpif_, odp_port_t port_no)
  {
      const struct dpif_netlink *dpif = dpif_netlink_cast(dpif_);
      uint32_t ret;
  
      /* In per-cpu dispatch mode, vports do not have an associated PID */
      if (DISPATCH_MODE_PER_CPU(dpif)) {
          return 0;
      }
  
That is used by compose_slow_path() to create userspace actions. So,
it seems all userspace actions would be using id 0 and that would
discarded by the kernel with -ENOTCONN.
 
--
fbl
