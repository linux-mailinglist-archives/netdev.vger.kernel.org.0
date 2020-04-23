Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02531B6215
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgDWRiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:38:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:36160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgDWRiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 13:38:16 -0400
IronPort-SDR: Ybdp7NKhgjrrPLett2OXe8OQIFj/nqvLf5VeQHvmeHVk8PZOjlKT6RQp4kYDWKqDXWLor8ta5q
 m065L+neCBIQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 10:38:14 -0700
IronPort-SDR: As36uu2yBJB8tGN71LkYAWZWCPUUFbh6XYWYwsaHPGvm4cveeAuMbA7xVG0eS1qR/5qv4H3R26
 zHAhjIucJjdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="457581194"
Received: from rkumbar-mobl2.amr.corp.intel.com (HELO ellie) ([10.212.66.92])
  by fmsmga006.fm.intel.com with ESMTP; 23 Apr 2020 10:38:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <Po.Liu@nxp.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
In-Reply-To: <20200422024852.23224-2-Po.Liu@nxp.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com> <20200422024852.23224-2-Po.Liu@nxp.com>
Date:   Thu, 23 Apr 2020 10:38:11 -0700
Message-ID: <878sim2jcs.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Po Liu <Po.Liu@nxp.com> writes:

> Introduce a ingress frame gate control flow action.
> Tc gate action does the work like this:
> Assume there is a gate allow specified ingress frames can be passed at
> specific time slot, and be dropped at specific time slot. Tc filter
> chooses the ingress frames, and tc gate action would specify what slot
> does these frames can be passed to device and what time slot would be
> dropped.
> Tc gate action would provide an entry list to tell how much time gate
> keep open and how much time gate keep state close. Gate action also
> assign a start time to tell when the entry list start. Then driver would
> repeat the gate entry list cyclically.
> For the software simulation, gate action requires the user assign a time
> clock type.
>
> Below is the setting example in user space. Tc filter a stream source ip
> address is 192.168.0.20 and gate action own two time slots. One is last
> 200ms gate open let frame pass another is last 100ms gate close let
> frames dropped. When the frames have passed total frames over 8000000
> bytes, frames will be dropped in one 200000000ns time slot.
>
>> tc qdisc add dev eth0 ingress
>
>> tc filter add dev eth0 parent ffff: protocol ip \
> 	   flower src_ip 192.168.0.20 \
> 	   action gate index 2 clockid CLOCK_TAI \
> 	   sched-entry open 200000000 -1 8000000 \
> 	   sched-entry close 100000000 -1 -1

From the insight that Vladimir gave, it really makes it easier for me to
understand if you added these filters and actions in two steps. The
first, you would add the "time based" actions and the second you would
plug the filters into the actions. And I think this would match real
world usage better.

Another small usability improvement is to make the "extra" parameters to
'sched-entry close' optional, if packets that arrive during a closed
gate are dropped, those parameters don't make much sense.

>
>> tc chain del dev eth0 ingress chain 0
>
> "sched-entry" follow the name taprio style. Gate state is
> "open"/"close". Follow with period nanosecond. Then next item is internal
> priority value means which ingress queue should put. "-1" means
> wildcard. The last value optional specifies the maximum number of
> MSDU octets that are permitted to pass the gate during the specified
> time interval.
> Base-time is not set will be 0 as default, as result start time would
> be ((N + 1) * cycletime) which is the minimal of future time.
>
> Below example shows filtering a stream with destination mac address is
> 10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
> action would run with one close time slot which means always keep close.
> The time cycle is total 200000000ns. The base-time would calculate by:
>
>  1357000000000 + (N + 1) * cycletime
>
> When the total value is the future time, it will be the start time.
> The cycletime here would be 200000000ns for this case.
>
>> tc filter add dev eth0 parent ffff:  protocol ip \
> 	   flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
> 	   action gate index 12 base-time 1357000000000 \
> 	   sched-entry close 200000000 -1 -1 \
> 	   clockid CLOCK_TAI
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>  include/net/tc_act/tc_gate.h        |  54 +++
>  include/uapi/linux/pkt_cls.h        |   1 +
>  include/uapi/linux/tc_act/tc_gate.h |  47 ++
>  net/sched/Kconfig                   |  13 +
>  net/sched/Makefile                  |   1 +
>  net/sched/act_gate.c                | 647 ++++++++++++++++++++++++++++
>  6 files changed, 763 insertions(+)
>  create mode 100644 include/net/tc_act/tc_gate.h
>  create mode 100644 include/uapi/linux/tc_act/tc_gate.h
>  create mode 100644 net/sched/act_gate.c
>
> diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
> new file mode 100644
> index 000000000000..b0ace55b2aaa
> --- /dev/null
> +++ b/include/net/tc_act/tc_gate.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* Copyright 2020 NXP */
> +
> +#ifndef __NET_TC_GATE_H
> +#define __NET_TC_GATE_H
> +
> +#include <net/act_api.h>
> +#include <linux/tc_act/tc_gate.h>
> +
> +struct tcfg_gate_entry {
> +	int			index;
> +	u8			gate_state;
> +	u32			interval;
> +	s32			ipv;
> +	s32			maxoctets;
> +	struct list_head	list;
> +};
> +
> +struct tcf_gate_params {
> +	s32			tcfg_priority;
> +	u64			tcfg_basetime;
> +	u64			tcfg_cycletime;
> +	u64			tcfg_cycletime_ext;
> +	u32			tcfg_flags;
> +	s32			tcfg_clockid;
> +	size_t			num_entries;
> +	struct list_head	entries;
> +};
> +
> +#define GATE_ACT_GATE_OPEN	BIT(0)
> +#define GATE_ACT_PENDING	BIT(1)
> +struct gate_action {
> +	struct tcf_gate_params param;
> +	spinlock_t entry_lock;
> +	u8 current_gate_status;
> +	ktime_t current_close_time;
> +	u32 current_entry_octets;
> +	s32 current_max_octets;
> +	struct tcfg_gate_entry __rcu *next_entry;
> +	struct hrtimer hitimer;
> +	enum tk_offsets tk_offset;
> +	struct rcu_head rcu;
> +};
> +
> +struct tcf_gate {
> +	struct tc_action		common;
> +	struct gate_action __rcu	*actg;
> +};
> +#define to_gate(a) ((struct tcf_gate *)a)
> +
> +#define get_gate_param(act) ((struct tcf_gate_params *)act)
> +#define get_gate_action(p) ((struct gate_action *)p)
> +
> +#endif
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 9f06d29cab70..fc672b232437 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -134,6 +134,7 @@ enum tca_id {
>  	TCA_ID_CTINFO,
>  	TCA_ID_MPLS,
>  	TCA_ID_CT,
> +	TCA_ID_GATE,
>  	/* other actions go here */
>  	__TCA_ID_MAX = 255
>  };
> diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
> new file mode 100644
> index 000000000000..f214b3a6d44f
> --- /dev/null
> +++ b/include/uapi/linux/tc_act/tc_gate.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/* Copyright 2020 NXP */
> +
> +#ifndef __LINUX_TC_GATE_H
> +#define __LINUX_TC_GATE_H
> +
> +#include <linux/pkt_cls.h>
> +
> +struct tc_gate {
> +	tc_gen;
> +};
> +
> +enum {
> +	TCA_GATE_ENTRY_UNSPEC,
> +	TCA_GATE_ENTRY_INDEX,
> +	TCA_GATE_ENTRY_GATE,
> +	TCA_GATE_ENTRY_INTERVAL,
> +	TCA_GATE_ENTRY_IPV,
> +	TCA_GATE_ENTRY_MAX_OCTETS,
> +	__TCA_GATE_ENTRY_MAX,
> +};
> +#define TCA_GATE_ENTRY_MAX (__TCA_GATE_ENTRY_MAX - 1)
> +
> +enum {
> +	TCA_GATE_ONE_ENTRY_UNSPEC,
> +	TCA_GATE_ONE_ENTRY,
> +	__TCA_GATE_ONE_ENTRY_MAX,
> +};
> +#define TCA_GATE_ONE_ENTRY_MAX (__TCA_GATE_ONE_ENTRY_MAX - 1)
> +
> +enum {
> +	TCA_GATE_UNSPEC,
> +	TCA_GATE_TM,
> +	TCA_GATE_PARMS,
> +	TCA_GATE_PAD,
> +	TCA_GATE_PRIORITY,
> +	TCA_GATE_ENTRY_LIST,
> +	TCA_GATE_BASE_TIME,
> +	TCA_GATE_CYCLE_TIME,
> +	TCA_GATE_CYCLE_TIME_EXT,
> +	TCA_GATE_FLAGS,
> +	TCA_GATE_CLOCKID,
> +	__TCA_GATE_MAX,
> +};
> +#define TCA_GATE_MAX (__TCA_GATE_MAX - 1)
> +
> +#endif
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index bfbefb7bff9d..1314549c7567 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -981,6 +981,19 @@ config NET_ACT_CT
>  	  To compile this code as a module, choose M here: the
>  	  module will be called act_ct.
>  
> +config NET_ACT_GATE
> +	tristate "Frame gate entry list control tc action"
> +	depends on NET_CLS_ACT
> +	help
> +	  Say Y here to allow to control the ingress flow to be passed at
> +	  specific time slot and be dropped at other specific time slot by
> +	  the gate entry list. The manipulation will simulate the IEEE
> +	  802.1Qci stream gate control behavior.
> +
> +	  If unsure, say N.
> +	  To compile this code as a module, choose M here: the
> +	  module will be called act_gate.
> +
>  config NET_IFE_SKBMARK
>  	tristate "Support to encoding decoding skb mark on IFE action"
>  	depends on NET_ACT_IFE
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index 31c367a6cd09..66bbf9a98f9e 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_NET_IFE_SKBPRIO)	+= act_meta_skbprio.o
>  obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
>  obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
>  obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
> +obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
>  obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
>  obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
>  obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> new file mode 100644
> index 000000000000..e932f402b4f1
> --- /dev/null
> +++ b/net/sched/act_gate.c
> @@ -0,0 +1,647 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* Copyright 2020 NXP */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/skbuff.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <net/act_api.h>
> +#include <net/netlink.h>
> +#include <net/pkt_cls.h>
> +#include <net/tc_act/tc_gate.h>
> +
> +static unsigned int gate_net_id;
> +static struct tc_action_ops act_gate_ops;
> +
> +static ktime_t gate_get_time(struct gate_action *gact)
> +{
> +	ktime_t mono = ktime_get();
> +
> +	switch (gact->tk_offset) {
> +	case TK_OFFS_MAX:
> +		return mono;
> +	default:
> +		return ktime_mono_to_any(mono, gact->tk_offset);
> +	}
> +
> +	return KTIME_MAX;
> +}
> +
> +static int gate_get_start_time(struct gate_action *gact, ktime_t *start)
> +{
> +	struct tcf_gate_params *param = get_gate_param(gact);
> +	ktime_t now, base, cycle;
> +	u64 n;
> +
> +	base = ns_to_ktime(param->tcfg_basetime);
> +	now = gate_get_time(gact);
> +
> +	if (ktime_after(base, now)) {
> +		*start = base;
> +		return 0;
> +	}
> +
> +	cycle = param->tcfg_cycletime;
> +
> +	/* cycle time should not be zero */
> +	if (WARN_ON(!cycle))
> +		return -EFAULT;
> +
> +	n = div64_u64(ktime_sub_ns(now, base), cycle);
> +	*start = ktime_add_ns(base, (n + 1) * cycle);
> +	return 0;
> +}
> +
> +static void gate_start_timer(struct gate_action *gact, ktime_t start)
> +{
> +	ktime_t expires;
> +
> +	expires = hrtimer_get_expires(&gact->hitimer);
> +	if (expires == 0)
> +		expires = KTIME_MAX;
> +
> +	start = min_t(ktime_t, start, expires);
> +
> +	hrtimer_start(&gact->hitimer, start, HRTIMER_MODE_ABS);
> +}
> +
> +static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
> +{
> +	struct gate_action *gact = container_of(timer, struct gate_action,
> +						hitimer);
> +	struct tcf_gate_params *p = get_gate_param(gact);
> +	struct tcfg_gate_entry *next;
> +	ktime_t close_time, now;
> +
> +	spin_lock(&gact->entry_lock);
> +
> +	next = rcu_dereference_protected(gact->next_entry,
> +					 lockdep_is_held(&gact->entry_lock));
> +
> +	/* cycle start, clear pending bit, clear total octets */
> +	gact->current_gate_status = next->gate_state ? GATE_ACT_GATE_OPEN : 0;
> +	gact->current_entry_octets = 0;
> +	gact->current_max_octets = next->maxoctets;
> +
> +	gact->current_close_time = ktime_add_ns(gact->current_close_time,
> +						next->interval);
> +
> +	close_time = gact->current_close_time;
> +
> +	if (list_is_last(&next->list, &p->entries))
> +		next = list_first_entry(&p->entries,
> +					struct tcfg_gate_entry, list);
> +	else
> +		next = list_next_entry(next, list);
> +
> +	now = gate_get_time(gact);
> +
> +	if (ktime_after(now, close_time)) {
> +		ktime_t cycle, base;
> +		u64 n;
> +
> +		cycle = p->tcfg_cycletime;
> +		base = ns_to_ktime(p->tcfg_basetime);
> +		n = div64_u64(ktime_sub_ns(now, base), cycle);
> +		close_time = ktime_add_ns(base, (n + 1) * cycle);
> +	}
> +
> +	rcu_assign_pointer(gact->next_entry, next);
> +	spin_unlock(&gact->entry_lock);
> +
> +	hrtimer_set_expires(&gact->hitimer, close_time);
> +
> +	return HRTIMER_RESTART;
> +}
> +
> +static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
> +			struct tcf_result *res)
> +{
> +	struct tcf_gate *g = to_gate(a);
> +	struct gate_action *gact;
> +	int action;
> +
> +	tcf_lastuse_update(&g->tcf_tm);
> +	bstats_cpu_update(this_cpu_ptr(g->common.cpu_bstats), skb);
> +
> +	action = READ_ONCE(g->tcf_action);
> +	rcu_read_lock();
> +	gact = rcu_dereference_bh(g->actg);
> +	if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
> +		rcu_read_unlock();
> +		return action;
> +	}
> +
> +	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
> +		goto drop;
> +
> +	if (gact->current_max_octets >= 0) {
> +		gact->current_entry_octets += qdisc_pkt_len(skb);
> +		if (gact->current_entry_octets > gact->current_max_octets) {
> +			qstats_overlimit_inc(this_cpu_ptr(g->common.cpu_qstats));
> +			goto drop;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return action;
> +drop:
> +	rcu_read_unlock();
> +	qstats_drop_inc(this_cpu_ptr(g->common.cpu_qstats));
> +	return TC_ACT_SHOT;
> +}
> +
> +static const struct nla_policy entry_policy[TCA_GATE_ENTRY_MAX + 1] = {
> +	[TCA_GATE_ENTRY_INDEX]		= { .type = NLA_U32 },
> +	[TCA_GATE_ENTRY_GATE]		= { .type = NLA_FLAG },
> +	[TCA_GATE_ENTRY_INTERVAL]	= { .type = NLA_U32 },
> +	[TCA_GATE_ENTRY_IPV]		= { .type = NLA_S32 },
> +	[TCA_GATE_ENTRY_MAX_OCTETS]	= { .type = NLA_S32 },
> +};
> +
> +static const struct nla_policy gate_policy[TCA_GATE_MAX + 1] = {
> +	[TCA_GATE_PARMS]		= { .len = sizeof(struct tc_gate),
> +					    .type = NLA_EXACT_LEN },
> +	[TCA_GATE_PRIORITY]		= { .type = NLA_S32 },
> +	[TCA_GATE_ENTRY_LIST]		= { .type = NLA_NESTED },
> +	[TCA_GATE_BASE_TIME]		= { .type = NLA_U64 },
> +	[TCA_GATE_CYCLE_TIME]		= { .type = NLA_U64 },
> +	[TCA_GATE_CYCLE_TIME_EXT]	= { .type = NLA_U64 },
> +	[TCA_GATE_FLAGS]		= { .type = NLA_U32 },
> +	[TCA_GATE_CLOCKID]		= { .type = NLA_S32 },
> +};
> +
> +static int fill_gate_entry(struct nlattr **tb, struct tcfg_gate_entry *entry,
> +			   struct netlink_ext_ack *extack)
> +{
> +	u32 interval = 0;
> +
> +	entry->gate_state = nla_get_flag(tb[TCA_GATE_ENTRY_GATE]);
> +
> +	if (tb[TCA_GATE_ENTRY_INTERVAL])
> +		interval = nla_get_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
> +
> +	if (interval == 0) {
> +		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> +		return -EINVAL;
> +	}
> +
> +	entry->interval = interval;
> +
> +	if (tb[TCA_GATE_ENTRY_IPV])
> +		entry->ipv = nla_get_s32(tb[TCA_GATE_ENTRY_IPV]);
> +	else
> +		entry->ipv = -1;
> +
> +	if (tb[TCA_GATE_ENTRY_MAX_OCTETS])
> +		entry->maxoctets = nla_get_s32(tb[TCA_GATE_ENTRY_MAX_OCTETS]);
> +	else
> +		entry->maxoctets = -1;
> +
> +	return 0;
> +}
> +
> +static int parse_gate_entry(struct nlattr *n, struct  tcfg_gate_entry *entry,
> +			    int index, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[TCA_GATE_ENTRY_MAX + 1] = { };
> +	int err;
> +
> +	err = nla_parse_nested(tb, TCA_GATE_ENTRY_MAX, n, entry_policy, extack);
> +	if (err < 0) {
> +		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
> +		return -EINVAL;
> +	}
> +
> +	entry->index = index;
> +
> +	return fill_gate_entry(tb, entry, extack);
> +}
> +
> +static int parse_gate_list(struct nlattr *list_attr,
> +			   struct tcf_gate_params *sched,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct tcfg_gate_entry *entry, *e;
> +	struct nlattr *n;
> +	int err, rem;
> +	int i = 0;
> +
> +	if (!list_attr)
> +		return -EINVAL;
> +
> +	nla_for_each_nested(n, list_attr, rem) {
> +		if (nla_type(n) != TCA_GATE_ONE_ENTRY) {
> +			NL_SET_ERR_MSG(extack, "Attribute isn't type 'entry'");
> +			continue;
> +		}
> +
> +		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +		if (!entry) {
> +			NL_SET_ERR_MSG(extack, "Not enough memory for entry");
> +			err = -ENOMEM;
> +			goto release_list;
> +		}
> +
> +		err = parse_gate_entry(n, entry, i, extack);
> +		if (err < 0) {
> +			kfree(entry);
> +			goto release_list;
> +		}
> +
> +		list_add_tail(&entry->list, &sched->entries);
> +		i++;
> +	}
> +
> +	sched->num_entries = i;
> +
> +	return i;
> +
> +release_list:
> +	list_for_each_entry_safe(entry, e, &sched->entries, list) {
> +		list_del(&entry->list);
> +		kfree(entry);
> +	}
> +
> +	return err;
> +}
> +
> +static int tcf_gate_init(struct net *net, struct nlattr *nla,
> +			 struct nlattr *est, struct tc_action **a,
> +			 int ovr, int bind, bool rtnl_held,
> +			 struct tcf_proto *tp, u32 flags,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, gate_net_id);
> +	enum tk_offsets tk_offset = TK_OFFS_TAI;
> +	struct nlattr *tb[TCA_GATE_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcfg_gate_entry *next;
> +	struct tcf_gate_params *p;
> +	struct gate_action *gact;
> +	s32 clockid = CLOCK_TAI;
> +	struct tc_gate *parm;
> +	struct tcf_gate *g;
> +	int ret = 0, err;
> +	u64 basetime = 0;
> +	u32 gflags = 0;
> +	s32 prio = -1;
> +	ktime_t start;
> +	u32 index;
> +
> +	if (!nla)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested(tb, TCA_GATE_MAX, nla, gate_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_GATE_PARMS])
> +		return -EINVAL;
> +	parm = nla_data(tb[TCA_GATE_PARMS]);
> +	index = parm->index;
> +	err = tcf_idr_check_alloc(tn, &index, a, bind);
> +	if (err < 0)
> +		return err;
> +
> +	if (err && bind)
> +		return 0;
> +
> +	if (!err) {
> +		ret = tcf_idr_create_from_flags(tn, index, est, a,
> +						&act_gate_ops, bind, flags);
> +		if (ret) {
> +			tcf_idr_cleanup(tn, index);
> +			return ret;
> +		}
> +
> +		ret = ACT_P_CREATED;
> +	} else if (!ovr) {
> +		tcf_idr_release(*a, bind);
> +		return -EEXIST;
> +	}
> +
> +	if (tb[TCA_GATE_PRIORITY])
> +		prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
> +
> +	if (tb[TCA_GATE_BASE_TIME])
> +		basetime = nla_get_u64(tb[TCA_GATE_BASE_TIME]);
> +
> +	if (tb[TCA_GATE_FLAGS])
> +		gflags = nla_get_u32(tb[TCA_GATE_FLAGS]);
> +
> +	if (tb[TCA_GATE_CLOCKID]) {
> +		clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
> +		switch (clockid) {
> +		case CLOCK_REALTIME:
> +			tk_offset = TK_OFFS_REAL;
> +			break;
> +		case CLOCK_MONOTONIC:
> +			tk_offset = TK_OFFS_MAX;
> +			break;
> +		case CLOCK_BOOTTIME:
> +			tk_offset = TK_OFFS_BOOT;
> +			break;
> +		case CLOCK_TAI:
> +			tk_offset = TK_OFFS_TAI;
> +			break;
> +		default:
> +			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
> +			goto release_idr;
> +		}
> +	}
> +
> +	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> +	if (err < 0)
> +		goto release_idr;
> +
> +	g = to_gate(*a);
> +
> +	gact = kzalloc(sizeof(*gact), GFP_KERNEL);
> +	if (!gact) {
> +		err = -ENOMEM;
> +		goto put_chain;
> +	}
> +
> +	p = get_gate_param(gact);
> +
> +	INIT_LIST_HEAD(&p->entries);
> +	if (tb[TCA_GATE_ENTRY_LIST]) {
> +		err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
> +		if (err < 0)
> +			goto release_mem;
> +	}
> +
> +	if (tb[TCA_GATE_CYCLE_TIME]) {
> +		p->tcfg_cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
> +	} else {
> +		struct tcfg_gate_entry *entry;
> +		ktime_t cycle = 0;
> +
> +		list_for_each_entry(entry, &p->entries, list)
> +			cycle = ktime_add_ns(cycle, entry->interval);
> +		p->tcfg_cycletime = cycle;
> +	}
> +
> +	if (tb[TCA_GATE_CYCLE_TIME_EXT])
> +		p->tcfg_cycletime_ext =
> +			nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
> +
> +	p->tcfg_priority = prio;
> +	p->tcfg_basetime = basetime;
> +	p->tcfg_clockid = clockid;
> +	p->tcfg_flags = gflags;
> +
> +	gact->tk_offset = tk_offset;
> +	spin_lock_init(&gact->entry_lock);
> +	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS);
> +	gact->hitimer.function = gate_timer_func;
> +

One idea that just happened, if you find a way to enable RX timestamping
and can rely that all packets have a timestamp, the code can simplified
a lot. You wouldn't need any hrtimers, and deciding to drop or not
a packet becomes a couple of mathematical operations. Seems worth a
thought.

The real question is: if requiring for the driver to support at least
software RX timestamping is excessive (doesn't seem so to me).


Cheers,
-- 
Vinicius
