Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3671B46F6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgDVOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:14:00 -0400
Received: from mail.buslov.dev ([199.247.26.29]:34951 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgDVOOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 10:14:00 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a01:d0:40b3:9801:fec2:781d:de90:e768])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 5D51F200C1;
        Wed, 22 Apr 2020 17:13:54 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1587564835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fc7VZMT/FTBhkKv7TrI5e5PP30B1ubSJV6HSWBlAy84=;
        b=EErVl6/Zp1ikxiCR+z+vprUneXi9SDO71CTDMsvWuPEBCqNolOlrYv6bkHlmYhw68timau
        /Tg91IZpCPCzPScXuH8yBENsQiTzm4duQhKXS9vW2L9erCo7+bcykZcg3rczI5pikyXKOl
        xrsG3EBlvDijVtopa6xRfsVPYyHn5mJownaD0WaD6YrA9Gj5yl3DhMv5DSV5Q5mzJblGCs
        DjMHP3KwqIXVeAmVxNmTrp9GXfiy4aA8OnSfjf4K55IOqtMGUwY5HF6hj2VEHVWmaHF3lD
        it+sD8bj6970dUKotbrp+fYvCRGjtGA5ymwF6wXqYlXwJYYidiOgyoyTPzMk7w==
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com> <20200422024852.23224-3-Po.Liu@nxp.com>
User-agent: mu4e 1.4.1; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v3,net-next  2/4] net: schedule: add action gate offloading
In-reply-to: <20200422024852.23224-3-Po.Liu@nxp.com>
Date:   Wed, 22 Apr 2020 17:14:07 +0300
Message-ID: <874ktbbob4.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 22 Apr 2020 at 05:48, Po Liu <Po.Liu@nxp.com> wrote:
> Add the gate action to the flow action entry. Add the gate parameters to
> the tc_setup_flow_action() queueing to the entries of flow_action_entry
> array provide to the driver.
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>  include/net/flow_offload.h   |  10 +++
>  include/net/tc_act/tc_gate.h | 115 +++++++++++++++++++++++++++++++++++
>  net/sched/cls_api.c          |  33 ++++++++++
>  3 files changed, 158 insertions(+)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3619c6acf60f..94a30fe02e6d 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -147,6 +147,7 @@ enum flow_action_id {
>  	FLOW_ACTION_MPLS_PUSH,
>  	FLOW_ACTION_MPLS_POP,
>  	FLOW_ACTION_MPLS_MANGLE,
> +	FLOW_ACTION_GATE,
>  	NUM_FLOW_ACTIONS,
>  };
>  
> @@ -255,6 +256,15 @@ struct flow_action_entry {
>  			u8		bos;
>  			u8		ttl;
>  		} mpls_mangle;
> +		struct {
> +			u32		index;
> +			s32		prio;
> +			u64		basetime;
> +			u64		cycletime;
> +			u64		cycletimeext;
> +			u32		num_entries;
> +			struct action_gate_entry *entries;
> +		} gate;
>  	};
>  	struct flow_action_cookie *cookie; /* user defined action cookie */
>  };
> diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
> index b0ace55b2aaa..62633cb02c7a 100644
> --- a/include/net/tc_act/tc_gate.h
> +++ b/include/net/tc_act/tc_gate.h
> @@ -7,6 +7,13 @@
>  #include <net/act_api.h>
>  #include <linux/tc_act/tc_gate.h>
>  
> +struct action_gate_entry {
> +	u8			gate_state;
> +	u32			interval;
> +	s32			ipv;
> +	s32			maxoctets;
> +};
> +
>  struct tcfg_gate_entry {
>  	int			index;
>  	u8			gate_state;
> @@ -51,4 +58,112 @@ struct tcf_gate {
>  #define get_gate_param(act) ((struct tcf_gate_params *)act)
>  #define get_gate_action(p) ((struct gate_action *)p)
>  
> +static inline bool is_tcf_gate(const struct tc_action *a)
> +{
> +#ifdef CONFIG_NET_CLS_ACT
> +	if (a->ops && a->ops->id == TCA_ID_GATE)
> +		return true;
> +#endif
> +	return false;
> +}
> +
> +static inline u32 tcf_gate_index(const struct tc_action *a)
> +{
> +	return a->tcfa_index;
> +}
> +
> +static inline s32 tcf_gate_prio(const struct tc_action *a)
> +{
> +	s32 tcfg_prio;
> +
> +	rcu_read_lock();
> +	tcfg_prio = rcu_dereference(to_gate(a)->actg)->param.tcfg_priority;
> +	rcu_read_unlock();
> +
> +	return tcfg_prio;
> +}
> +
> +static inline u64 tcf_gate_basetime(const struct tc_action *a)
> +{
> +	u64 tcfg_basetime;
> +
> +	rcu_read_lock();
> +	tcfg_basetime =
> +		rcu_dereference(to_gate(a)->actg)->param.tcfg_basetime;
> +	rcu_read_unlock();
> +
> +	return tcfg_basetime;
> +}
> +
> +static inline u64 tcf_gate_cycletime(const struct tc_action *a)
> +{
> +	u64 tcfg_cycletime;
> +
> +	rcu_read_lock();
> +	tcfg_cycletime =
> +		rcu_dereference(to_gate(a)->actg)->param.tcfg_cycletime;
> +	rcu_read_unlock();
> +
> +	return tcfg_cycletime;
> +}
> +
> +static inline u64 tcf_gate_cycletimeext(const struct tc_action *a)
> +{
> +	u64 tcfg_cycletimeext;
> +
> +	rcu_read_lock();
> +	tcfg_cycletimeext =
> +		rcu_dereference(to_gate(a)->actg)->param.tcfg_cycletime_ext;
> +	rcu_read_unlock();
> +
> +	return tcfg_cycletimeext;
> +}
> +
> +static inline u32 tcf_gate_num_entries(const struct tc_action *a)
> +{
> +	u32 num_entries;
> +
> +	rcu_read_lock();
> +	num_entries =
> +		rcu_dereference(to_gate(a)->actg)->param.num_entries;
> +	rcu_read_unlock();
> +
> +	return num_entries;
> +}
> +
> +static inline struct action_gate_entry
> +			*tcf_gate_get_list(const struct tc_action *a)
> +{
> +	struct action_gate_entry *oe;
> +	struct tcf_gate_params *p;
> +	struct tcfg_gate_entry *entry;
> +	u32 num_entries;
> +	int i = 0;
> +
> +	rcu_read_lock();
> +	p = &(rcu_dereference(to_gate(a)->actg)->param);
> +	num_entries = p->num_entries;
> +	rcu_read_unlock();

Here you obtain a pointer to part of rcu-protected object and use it
past rcu read lock block.

> +
> +	list_for_each_entry(entry, &p->entries, list)
> +		i++;
> +
> +	if (i != num_entries)
> +		return NULL;
> +
> +	oe = kzalloc(sizeof(*oe) * num_entries, GFP_KERNEL);
> +	if (!oe)
> +		return NULL;
> +
> +	i = 0;
> +	list_for_each_entry(entry, &p->entries, list) {
> +		oe[i].gate_state = entry->gate_state;
> +		oe[i].interval = entry->interval;
> +		oe[i].ipv = entry->ipv;
> +		oe[i].maxoctets = entry->maxoctets;
> +		i++;
> +	}
> +
> +	return oe;
> +}
>  #endif
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 55bd1429678f..ca8bf74be4ba 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -39,6 +39,7 @@
>  #include <net/tc_act/tc_skbedit.h>
>  #include <net/tc_act/tc_ct.h>
>  #include <net/tc_act/tc_mpls.h>
> +#include <net/tc_act/tc_gate.h>
>  #include <net/flow_offload.h>
>  
>  extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
> @@ -3523,6 +3524,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
>  #endif
>  }
>  
> +static void tcf_gate_entry_destructor(void *priv)
> +{
> +	struct action_gate_entry *oe = priv;
> +
> +	kfree(oe);
> +}
> +
> +static int tcf_gate_get_entries(struct flow_action_entry *entry,
> +				const struct tc_action *act)
> +{
> +	entry->gate.entries = tcf_gate_get_list(act);
> +
> +	if (!entry->gate.entries)
> +		return -EINVAL;
> +
> +	entry->destructor = tcf_gate_entry_destructor;
> +	entry->destructor_priv = entry->gate.entries;
> +
> +	return 0;
> +}
> +
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts)
>  {
> @@ -3669,6 +3691,17 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  		} else if (is_tcf_skbedit_priority(act)) {
>  			entry->id = FLOW_ACTION_PRIORITY;
>  			entry->priority = tcf_skbedit_priority(act);
> +		} else if (is_tcf_gate(act)) {
> +			entry->id = FLOW_ACTION_GATE;
> +			entry->gate.index = tcf_gate_index(act);
> +			entry->gate.prio = tcf_gate_prio(act);
> +			entry->gate.basetime = tcf_gate_basetime(act);
> +			entry->gate.cycletime = tcf_gate_cycletime(act);
> +			entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
> +			entry->gate.num_entries = tcf_gate_num_entries(act);
> +			err = tcf_gate_get_entries(entry, act);
> +			if (err)
> +				goto err_out;
>  		} else {
>  			err = -EOPNOTSUPP;
>  			goto err_out_locked;

