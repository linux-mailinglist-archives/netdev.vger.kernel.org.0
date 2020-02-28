Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F9B17409F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgB1T71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1T71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:59:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A80524677;
        Fri, 28 Feb 2020 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582919966;
        bh=tyBX90khT6bNWT68Y7TyXRI7V9dJLZC+oocIz50GU4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LsH9pzRuMZaS3vD47ts/bcHbaw9osNZVvoUYNK8KOlJ+Z57r9iAu/CR75GHmQlkJy
         FGQF9qT247/1sl6BFDlLFZM43jh1UcZnk27CeQuLLPURp2+E5XGw5s28125ypeDOXw
         KkLjskoxOMV+sCUZAJkb+oFoNH39T5OBF/AAU8No=
Date:   Fri, 28 Feb 2020 11:59:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify
 type of HW stats for a filter
Message-ID: <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228172505.14386-13-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-13-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 18:25:05 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, user who is adding an action expects HW to report stats,
> however it does not have exact expectations about the stats types.
> That is aligned with TCA_ACT_HW_STATS_TYPE_ANY.
> 
> Allow user to specify the type of HW stats for an action and require it.
> 
> Pass the information down to flow_offload layer.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - moved the stats attr from cls_flower (filter) to any action
> - rebased on top of cookie offload changes
> - adjusted the patch description a bit

Thanks, this looks good... I mean I wish we could just share actions
instead but this set is less objectionable than v1 :)

> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 71347a90a9d1..02b9bffa17ed 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -39,6 +39,7 @@ struct tc_action {
>  	struct gnet_stats_basic_cpu __percpu *cpu_bstats_hw;
>  	struct gnet_stats_queue __percpu *cpu_qstats;
>  	struct tc_cookie	__rcu *act_cookie;
> +	enum tca_act_hw_stats_type	hw_stats_type;
>  	struct tcf_chain	__rcu *goto_chain;
>  	u32			tcfa_flags;
>  };
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 449a63971451..096ea59a090b 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -17,6 +17,7 @@ enum {
>  	TCA_ACT_PAD,
>  	TCA_ACT_COOKIE,
>  	TCA_ACT_FLAGS,
> +	TCA_ACT_HW_STATS_TYPE,
>  	__TCA_ACT_MAX
>  };
>  
> @@ -118,6 +119,31 @@ enum tca_id {
>  
>  #define TCA_ID_MAX __TCA_ID_MAX
>  
> +/* tca HW stats type */
> +enum tca_act_hw_stats_type {
> +	TCA_ACT_HW_STATS_TYPE_ANY, /* User does not care, it's default
> +				    * when user does not pass the attr.
> +				    * Instructs the driver that user does not
> +				    * care if the HW stats are "immediate"
> +				    * or "delayed".
> +				    */
> +	TCA_ACT_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
> +					  * the current HW stats state from
> +					  * the device queried at the dump time.
> +					  */
> +	TCA_ACT_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
> +					* HW stats that might be out of date
> +					* for some time, maybe couple of
> +					* seconds. This is the case when driver
> +					* polls stats updates periodically
> +					* or when it gets async stats update
> +					* from the device.
> +					*/
> +	TCA_ACT_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
> +					 * any HW statistics.
> +					 */
> +};

On the ABI I wonder if we can redefine it a little bit..

Can we make the stat types into a bitfield?

On request:
 - no attr -> any stats allowed but some stats must be provided *
 - 0       -> no stats requested / disabled
 - 0x1     -> must be stat type0
 - 0x6     -> stat type1 or stat type2 are both fine

* no attr kinda doesn't work 'cause u32 offload has no stats and this
  is action-level now, not flower-level :S What about u32 and matchall?

We can add a separate attribute with "active" stat types:
 - no attr -> old kernel
 - 0       -> no stats are provided / stats disabled
 - 0x1     -> only stat type0 is used by drivers
 - 0x6     -> at least one driver is using type1 and one type2

That assumes that we may one day add another stat type which would 
not be just based on the reporting time.

If we only foresee time-based reporting would it make sense to turn 
the attribute into max acceptable delay in ms?

0        -> only immediate / blocking stats
(0, MAX) -> given reporting delay in ms is acceptable
MAX      -> don't care about stats at all

>  struct tc_police {
>  	__u32			index;
>  	int			action;
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 8c466a712cda..d6468b09b932 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -185,6 +185,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
>  	return  nla_total_size(0) /* action number nested */
>  		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
>  		+ cookie_len /* TCA_ACT_COOKIE */
> +		+ nla_total_size(sizeof(u8)) /* TCA_ACT_HW_STATS_TYPE */
>  		+ nla_total_size(0) /* TCA_ACT_STATS nested */
>  		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
>  		/* TCA_STATS_BASIC */
> @@ -788,6 +789,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>  	}
>  	rcu_read_unlock();
>  
> +	if (nla_put_u8(skb, TCA_ACT_HW_STATS_TYPE, a->hw_stats_type))
> +		goto nla_put_failure;
> +
>  	if (a->tcfa_flags) {
>  		struct nla_bitfield32 flags = { a->tcfa_flags,
>  						a->tcfa_flags, };
> @@ -854,12 +858,23 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
>  	return c;
>  }
>  
> +static inline enum tca_act_hw_stats_type

static inline in C source

> +tcf_action_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
> +{
> +	/* If the user did not pass the attr, that means he does
> +	 * not care about the type. Return "any" in that case.
> +	 */
> +	return hw_stats_type_attr ? nla_get_u8(hw_stats_type_attr) :
> +				    TCA_ACT_HW_STATS_TYPE_ANY;
> +}
> +
>  static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
>  static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
>  	[TCA_ACT_KIND]		= { .type = NLA_STRING },
>  	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
>  	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
>  				    .len = TC_COOKIE_MAX_SIZE },
> +	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_U8 },

We can use a POLICY with MIN/MAX here, perhaps?

>  	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
>  	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
>  				    .validation_data = &tca_act_flags_allowed },
> @@ -871,6 +886,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  				    bool rtnl_held,
>  				    struct netlink_ext_ack *extack)
>  {
> +	enum tca_act_hw_stats_type hw_stats_type = TCA_ACT_HW_STATS_TYPE_ANY;
>  	struct nla_bitfield32 flags = { 0, 0 };
>  	struct tc_action *a;
>  	struct tc_action_ops *a_o;
> @@ -903,6 +919,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  				goto err_out;
>  			}
>  		}
> +		hw_stats_type =
> +			tcf_action_hw_stats_type_get(tb[TCA_ACT_HW_STATS_TYPE]);
>  		if (tb[TCA_ACT_FLAGS])
>  			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
>  	} else {
> @@ -953,6 +971,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (!name && tb[TCA_ACT_COOKIE])
>  		tcf_set_action_cookie(&a->act_cookie, cookie);
>  
> +	if (!name)
> +		a->hw_stats_type = hw_stats_type;
> +
>  	/* module count goes up only when brand new policy is created
>  	 * if it exists and is only bound to in a_o->init() then
>  	 * ACT_P_CREATED is not returned (a zero is).
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 4e766c5ab77a..21bf37242153 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3458,9 +3458,28 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
>  #endif
>  }
>  
> +static inline enum flow_action_hw_stats_type

static inline in C source

> +tcf_flow_action_hw_stats_type(enum tca_act_hw_stats_type hw_stats_type)
> +{
> +	switch (hw_stats_type) {
> +	default:
> +		WARN_ON(1);
> +		/* fall-through */

without the policy change this seems user-triggerable

> +	case TCA_ACT_HW_STATS_TYPE_ANY:
> +		return FLOW_ACTION_HW_STATS_TYPE_ANY;
> +	case TCA_ACT_HW_STATS_TYPE_IMMEDIATE:
> +		return FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE;
> +	case TCA_ACT_HW_STATS_TYPE_DELAYED:
> +		return FLOW_ACTION_HW_STATS_TYPE_DELAYED;
> +	case TCA_ACT_HW_STATS_TYPE_DISABLED:
> +		return FLOW_ACTION_HW_STATS_TYPE_DISABLED;
> +	}
> +}
> +
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts)
>  {
> +	enum flow_action_hw_stats_type uninitialized_var(last_hw_stats_type);
>  	struct tc_action *act;
>  	int i, j, k, err = 0;
>  
> @@ -3476,6 +3495,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  		err = tcf_act_get_cookie(entry, act);
>  		if (err)
>  			goto err_out_locked;
> +
> +		entry->hw_stats_type =
> +			tcf_flow_action_hw_stats_type(act->hw_stats_type);
> +		if (i && last_hw_stats_type != entry->hw_stats_type)
> +			flow_action->mixed_hw_stats_types = true;
> +		last_hw_stats_type = entry->hw_stats_type;
> +
>  		if (is_tcf_gact_ok(act)) {
>  			entry->id = FLOW_ACTION_ACCEPT;
>  		} else if (is_tcf_gact_shot(act)) {

