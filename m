Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A455E5F2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbiF1Pa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347244AbiF1Pa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:30:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F9560F2;
        Tue, 28 Jun 2022 08:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656430225; x=1687966225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JwdoJVfvXnICLoEVhMj4K/dsP95yMel4W1jZvkV2frs=;
  b=KhpILrpPlsNxVEiiFA+6wiJPzh7rDyb+Vuxmy4X+9g+b7YLemI46+kyi
   8rsKUjTxXBgfAYIxfQL1EO2r2CpiPwgej0QYxXaexpft4EmNQorsps/rd
   dRIOdP5NbG/FyPI3M506rpPxlNpVL8c2WYZxiaL3sz1Zv+Bv2L0mmgglx
   71ASUvP6LSXkbg3SRLP7GKwY9LoCkzefOoGvzq9iRSHJEqMU1veA7tisU
   c+w3u/0nT6YZTdyJ5pA2FXmw6p2LqyGNSqpwAgU6AHPisJ8JBd6+LPf6V
   Qqh81nImeps6TiXhEuom8go3f7aWRSx8IuGhzwNKb21leUODBsDB1QLR4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280533667"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280533667"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 08:30:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="646957956"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2022 08:30:22 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SFUKaT030708;
        Tue, 28 Jun 2022 16:30:20 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Albert Huang <huangjie.albert@bytedance.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <atenart@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net : rps : supoort a single flow to use rps
Date:   Tue, 28 Jun 2022 17:29:56 +0200
Message-Id: <20220628152956.1407334-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628140044.65068-1-huangjie.albert@bytedance.com>
References: <20220628140044.65068-1-huangjie.albert@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Albert Huang <huangjie.albert@bytedance.com>
Date: Tue, 28 Jun 2022 22:00:37 +0800

> [PATCH] net : rps : supoort a single flow to use rps

Must be '[PATCH net-next] net: rps: ...'.

> From: "huangjie.albert" <huangjie.albert@bytedance.com>

Your Git mail settings is misconfigured, you appear as
'Albert Huang' in the 'From:' email header and as 'huangjie.albert'
in the SoB and in the commit author field, please fix.

> 
> In some scenarios(ipsec) or products(VPN gateway),
> we need to enable a single network stream to support RPS.
> but In the current rps implementation, there is no support
> for a single stream to utilize rps.
> 
> Introduce a hashtable to record flows that need to use rps.
> For these flows, use round robin to put them on different CPUs
> for further processing

How is this supposed to work, e.g. when the packet order is crucial?
Or is this made only for those consumers which allow whatever packet
arrival?
I feel like I'm missing an example of using this. Would be much
better if you included it in your series, e.g. some patch to make
the IPSec engine use it.

> 
> how to use:
> echo xxx > /sys/class/net/xxx/queues/rx-x/rps_cpus
> echo 1 > /sys/class/net/xxx/queues/rx-x/rps_single_flow
> and create a flow node with the function:
> rps_flow_node_create
> 
> This patch can improve the performance of a single stream,
> for example: On my virtual machine (4 vcpu + 8g), a single
> ipsec stream (3des encryption) can improve throughput by 3-4 times:
> before           after
> 212 Mbits/sec    698 Mbits/sec
> 
> Signed-off-by: huangjie.albert <huangjie.albert@bytedance.com>
> ---
>  include/linux/netdevice.h |  15 +++
>  net/core/dev.c            | 187 ++++++++++++++++++++++++++++++++++++++
>  net/core/net-sysfs.c      |  36 ++++++++
>  3 files changed, 238 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index f615a66c89e9..36412d0e0255 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -743,6 +743,7 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
>  struct netdev_rx_queue {
>  	struct xdp_rxq_info		xdp_rxq;
>  #ifdef CONFIG_RPS
> +	bool   rps_single_flow_enable;

I'd suggest to use some flags bitfield instead, so it would be way
more scalable and at the same time have the pre-determined size. Ar
per several LKML discussions, `bool` may have different size and
logics depending on architecture and compiler, so when using it not
on the stack inside a function, but in a structure, it might be not
easy then to track cacheline layout etc.
So, maybe

	unsigned long rps_flags;
 #define RPS_SINGLE_FLOW_ENABLE BIT(0)

or even

	DECLARE_BITMAP(rps_flags);
 #define RPS_SINGLE_FLOW_ENABLE 0

?

And regarding cacheline stuff I mentioned, have you checked whether
there were any changes due to the new field introduction?

>  	struct rps_map __rcu		*rps_map;
>  	struct rps_dev_flow_table __rcu	*rps_flow_table;
>  #endif
> @@ -811,6 +812,20 @@ struct xps_dev_maps {
>  #define XPS_RXQ_DEV_MAPS_SIZE(_tcs, _rxqs) (sizeof(struct xps_dev_maps) +\
>  	(_rxqs * (_tcs) * sizeof(struct xps_map *)))
>  
> +
> +/* define for rps_single_flow */
> +struct rps_flow_info_node {
> +	__be32 saddr;
> +	__be32 daddr;
> +	__u8 protocol;

I'd probably hash that and store as a u32 hash value instead. This
way you will provide support for protos other than IPv4 and simplify
the hotpath checks. Note that RPS core already hashes skbs when they
come without a hash passed from a NIC driver, so that could be
unified somehow.
I can't suggest comparing to sk_buff::hash directly as there are
plenty of different algos and NIC specifics, so that two packets
with the same tuple can have different values. But some local tuple
hashing is a way to go I'd say.

> +	u64  jiffies; /* keep the time update entry */
> +	struct hlist_node node;
> +};
> +#define MAX_MAINTENANCE_TIME (2000)
> +#define PERIODIC_AGEING_TIME (10000)
> +bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol);
> +void rps_single_flow_set(bool enable);
> +
>  #endif /* CONFIG_XPS */
>  
>  #define TC_MAX_QUEUE	16
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 08ce317fcec8..da3eb184fca1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4433,6 +4433,142 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>   * CPU from the RPS map of the receiving queue for a given skb.
>   * rcu_read_lock must be held on entry.
>   */
> +#define DEFAULT_HASH_BUKET_BIT (3)

                        ^^^^^
                        BUCKET


> +#define DEFAULT_QUOTA_PER_CPU (64)
> +static unsigned int  quota_per_cpu = DEFAULT_QUOTA_PER_CPU;

                      ^
Redundant space.

> +static atomic_t rps_flow_queue_enable_count = ATOMIC_INIT(0);

That's a pure candidate for a static key, atomic makes no sense
here.

> +static u64 last_aging_jiffies;
> +static DEFINE_HASHTABLE(rps_flow_info_htable, DEFAULT_HASH_BUKET_BIT);
> +static DEFINE_RWLOCK(rps_flow_rwlock);
> +
> +/* create rps flow node if not exist.
> + * update Timestamp for rps flow node if exist
> + */
> +bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol)
> +{
> +	/* hash key */
> +	u32 hash_key = saddr ^ daddr ^ protocol;
> +	struct rps_flow_info_node *p_rps_flow_info = NULL;

Please follow the Reverse Christmas Tree here.
Also, assigning @p_rps_flow_info (pretty long name BTW) to %NULL is
redundant -- you either find it in the table or unconditionally
allocate a new one.

> +
> +	/* no rps_single_flow_enable */
> +	if (!atomic_read(&rps_flow_queue_enable_count))
> +		return false;
> +
> +	/* find if the node already  exist */
> +	read_lock(&rps_flow_rwlock);
> +	hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
> +		if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
> +			&& (protocol == p_rps_flow_info->protocol)) {
> +			p_rps_flow_info->jiffies = jiffies;
> +			read_unlock(&rps_flow_rwlock);
> +			return true;
> +		}
> +	}
> +	read_unlock(&rps_flow_rwlock);
> +
> +	/*if not exist. get a new one */
> +	p_rps_flow_info = kmalloc(sizeof(*p_rps_flow_info), GFP_KERNEL);
> +	if (!p_rps_flow_info)
> +		return false;
> +
> +	memset(p_rps_flow_info, 0, sizeof(struct rps_flow_info_node));

Please prefer kzalloc() instead of kmalloc() + memset(). Also, I'd
say memset() is not needed in here as well -- you rewrite all of
the fields later on.

> +	p_rps_flow_info->saddr = saddr;
> +	p_rps_flow_info->daddr = daddr;
> +	p_rps_flow_info->protocol = protocol;
> +	p_rps_flow_info->jiffies = jiffies;
> +
> +	/*add the hash nodee*/
> +	write_lock(&rps_flow_rwlock);
> +	hash_add(rps_flow_info_htable, &p_rps_flow_info->node, hash_key);
> +	write_unlock(&rps_flow_rwlock);
> +	return true;
> +}
> +EXPORT_SYMBOL(rps_flow_node_create);
> +
> +static void rps_flow_node_clear(void)
> +{
> +	u32 bkt = 0;
> +	struct rps_flow_info_node *p_rps_flow_entry = NULL;
> +	struct hlist_node *tmp;

RCT, see above.

> +
> +	write_lock(&rps_flow_rwlock);
> +	hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
> +		hash_del(&p_rps_flow_entry->node);
> +		kfree(p_rps_flow_entry);
> +	}
> +	write_unlock(&rps_flow_rwlock);
> +}
> +
> +void rps_single_flow_set(bool enable)
> +{
> +	if (enable) {
> +		atomic_inc(&rps_flow_queue_enable_count);
> +	} else {
> +		atomic_dec(&rps_flow_queue_enable_count);
> +		if (!atomic_read(&rps_flow_queue_enable_count))
> +			rps_flow_node_clear();
> +	}
> +}
> +EXPORT_SYMBOL(rps_single_flow_set);
> +
> +/* compute hash */
> +static inline u32 rps_flow_hash_update(void)

No inlines in C files with only a few exceptions with some strong
reasons.

> +{
> +	static u32 packet_count;
> +	static u32 hash_count;

`static`? It will place them into BSS then and make SMP-unfriendly,
what's the purpose?

> +
> +	packet_count++;
> +	if (packet_count % quota_per_cpu) {
> +		packet_count = 0;
> +		hash_count++;
> +		if (hash_count == U32_MAX)
> +			hash_count = 0;
> +	}
> +	return hash_count;
> +}
> +
> +/* delete aging rps_flow  */
> +static inline bool rps_flow_node_aging_period(void)

Inlines.

> +{
> +	u32 bkt = 0;

RCT.

> +	struct rps_flow_info_node *p_rps_flow_entry = NULL;
> +	struct hlist_node *tmp;
> +
> +	if (jiffies_to_msecs(jiffies - last_aging_jiffies) < PERIODIC_AGEING_TIME)
> +		return false;

@last_aging_jiffies must be protected as well. At least with
{READ,WRITE}_ONCE().

> +
> +	last_aging_jiffies = jiffies;
> +	write_lock(&rps_flow_rwlock);
> +	hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
> +		if (jiffies_to_msecs(jiffies - p_rps_flow_entry->jiffies) >= MAX_MAINTENANCE_TIME) {
> +			hash_del(&p_rps_flow_entry->node);
> +			kfree(p_rps_flow_entry);
> +		}
> +	}
> +	write_unlock(&rps_flow_rwlock);
> +	return true;

So the users of your feature have to call rps_flow_node_create() on
a regular basis in order to keep the flow in the table? I'm not sure
I'm following the concept, again, an example would help a lot.

> +}
> +
> +/*  find vailed rps_flow */

            ^^^^^^
	    valid?

> +static inline struct rps_flow_info_node *rps_flow_find_vailed_node(__be32 saddr,

Inlines.

> +		__be32 daddr, __u8 protocol)
> +{
> +	struct rps_flow_info_node *p_rps_flow_info = NULL;
> +	u32 hash_key = saddr ^ daddr ^ protocol;
> +
> +	read_lock(&rps_flow_rwlock);
> +	hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
> +		if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
> +		&& (protocol == p_rps_flow_info->protocol)
> +		&& (jiffies_to_msecs(jiffies - p_rps_flow_info->jiffies) < MAX_MAINTENANCE_TIME)) {

Too long lines, there's a wrap possible to fix that.

> +			read_unlock(&rps_flow_rwlock);
> +			return p_rps_flow_info;
> +		}
> +	}
> +	read_unlock(&rps_flow_rwlock);
> +	return NULL;
> +}
> +
>  static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>  		       struct rps_dev_flow **rflowp)
>  {
> @@ -4465,6 +4601,57 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>  		goto done;
>  
>  	skb_reset_network_header(skb);
> +	/* this is to set rps for single flow */
> +	if (unlikely(rxqueue->rps_single_flow_enable)) {
> +		/* clean the old node */
> +		rps_flow_node_aging_period();
> +
> +		/* no rps ,skip it*/
> +		if (!map)
> +			goto orgin_rps;
> +
> +		/* skip vlan first  */
> +		if (skb_vlan_tag_present(skb))
> +			goto done;

Why?

> +
> +		switch (skb->protocol) {
> +		/*  ipv4  */
> +		case htons(ETH_P_IP): {
> +			const struct iphdr *iph;
> +			struct rps_flow_info_node *p_flow;

RCT.

> +
> +			iph = (struct iphdr *)skb_network_header(skb);
> +			/* hash map to match the src and dest ipaddr */
> +			p_flow = rps_flow_find_vailed_node(iph->saddr, iph->daddr, iph->protocol);
> +			/* check if vailed */
> +			if (p_flow) {
> +				pr_debug("single flow rps,flow info: saddr = %pI4, daddr =%pI4, proto=%d\n",
> +						&p_flow->saddr,
> +						&p_flow->daddr,
> +						p_flow->protocol);

I'm not sure pr_debug() is okay there. If you want to leave some
space for tracing, prefer tracing API.

> +			} else {
> +				goto orgin_rps;
> +			}
> +		}
> +		break;
> +		/* to do, ipv6 */
> +		default:
> +			goto orgin_rps;
> +

Redundant newline in here.

> +		}
> +
> +		/* get the target cpu */
> +		u32 hash_single_flow = rps_flow_hash_update();
> +
> +		tcpu = map->cpus[hash_single_flow % map->len];
> +		if (cpu_online(tcpu)) {
> +			cpu = tcpu;
> +			pr_debug("single flow rps, target cpuid = %d\n", cpu);

Same here.

> +			return cpu;
> +		}
> +	}
> +
> +orgin_rps:

   ^^^^^
   origin? Original?

>  	hash = skb_get_hash(skb);
>  	if (!hash)
>  		goto done;
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index e319e242dddf..c72ce20081e8 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -978,6 +978,41 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
>  	return len;
>  }
>  
> +static ssize_t show_rps_single_flow(struct netdev_rx_queue *queue, char *buf)
> +{
> +	unsigned long val = 0;

Redundant initialization.

> +
> +	val = queue->rps_single_flow_enable;
> +	return sprintf(buf, "%lu\n", val);
> +}
> +
> +static ssize_t store_rps_single_flow(struct netdev_rx_queue *queue, const char *buf, size_t len)
> +{
> +	int rc;
> +	unsigned long enable;
> +	bool rps_single_flow_enable = false;

RCT.

> +
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	rc = kstrtoul(buf, 0, &enable);
> +	if (rc < 0)
> +		return rc;
> +
> +	rps_single_flow_enable = !!enable;
> +
> +	/* if changed, store the new one */
> +	if (rps_single_flow_enable != queue->rps_single_flow_enable) {
> +		queue->rps_single_flow_enable = rps_single_flow_enable;
> +		rps_single_flow_set(rps_single_flow_enable);
> +	}
> +
> +	return len;
> +}
> +
> +static struct rx_queue_attribute rps_single_flow_attribute  __ro_after_init
> +	= __ATTR(rps_single_flow, 0644, show_rps_single_flow, store_rps_single_flow);
> +
>  static struct rx_queue_attribute rps_cpus_attribute __ro_after_init
>  	= __ATTR(rps_cpus, 0644, show_rps_map, store_rps_map);
>  
> @@ -988,6 +1023,7 @@ static struct rx_queue_attribute rps_dev_flow_table_cnt_attribute __ro_after_ini
>  
>  static struct attribute *rx_queue_default_attrs[] __ro_after_init = {
>  #ifdef CONFIG_RPS
> +	&rps_single_flow_attribute.attr,
>  	&rps_cpus_attribute.attr,
>  	&rps_dev_flow_table_cnt_attribute.attr,
>  #endif
> -- 
> 2.31.1

Thanks,
Olek
