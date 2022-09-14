Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED175B90BE
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiINXDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiINXDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:03:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865A86C2A;
        Wed, 14 Sep 2022 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663196608; x=1694732608;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=okFxm6J6JgAWD25P1QvzLpwm/ooPbFnL+ZgqoSOVW1s=;
  b=TLiVU3vt+d/cwBFHkRur2nxyvHdTQpA+n4x4/hHEalf0VOvDXbnru1c0
   OVd7aB+32yDy6uwLDBXZ7TxP7Z7fqyheBWeYxTrpTs1YxmzDgU921p7K2
   CHk+KuMqbM7dMTC62G8buJ9hbZNuzj7E0G5oXRdxJ02eQ6KDaleFUR/3S
   e8/Krxk6rIj3PydHgh84qdslTihFh55ViQCO0ongHR4D/qdQvzMzr6xuR
   jK4GSSuJKwH8Yfr1PWNGCsRes29OX+CNINBneogmfUxriUi1Y1BMjI0u8
   vSggDYgXA7xHGPnZgJKUq4g0fCK0StoWIVA/bNY947kb9dJHIowZOeInl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299374103"
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="299374103"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:03:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="945700062"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:03:26 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
In-Reply-To: <20220914153303.1792444-5-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com>
Date:   Wed, 14 Sep 2022 16:03:26 -0700
Message-ID: <87r10dh83l.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> IEEE 802.1Q clause 12.29.1.1 "The queueMaxSDUTable structure and data
> types" and 8.6.8.4 "Enhancements for scheduled traffic" talk about the
> existence of a per traffic class limitation of maximum frame sizes, with
> a fallback on the port-based MTU.
>
> As far as I am able to understand, the 802.1Q Service Data Unit (SDU)
> represents the MAC Service Data Unit (MSDU, i.e. L2 payload), excluding
> any number of prepended VLAN headers which may be otherwise present in
> the MSDU. Therefore, the queueMaxSDU is directly comparable to the
> device MTU (1500 means L2 payload sizes are accepted, or frame sizes of
> 1518 octets, or 1522 plus one VLAN header). Drivers which offload this
> are directly responsible of translating into other units of measurement.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Could you please add an example of the 'tc' command syntax you are
thinking about?

Another point to think about: does it make sense to allow 'only' the
max-sdu to be changed, i.e. the user doesn't set an a schedule, nor a
map, only the max-sdu information.

>  include/net/pkt_sched.h        |   1 +
>  include/uapi/linux/pkt_sched.h |  11 +++
>  net/sched/sch_taprio.c         | 122 ++++++++++++++++++++++++++++++++-
>  3 files changed, 133 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 29f65632ebc5..88080998557b 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -168,6 +168,7 @@ struct tc_taprio_qopt_offload {
>  	ktime_t base_time;
>  	u64 cycle_time;
>  	u64 cycle_time_extension;
> +	u32 max_sdu[TC_MAX_QUEUE];
>  
>  	size_t num_entries;
>  	struct tc_taprio_sched_entry entries[];
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index f292b467b27f..000eec106856 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1232,6 +1232,16 @@ enum {
>  #define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
>  #define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
>  
> +enum {
> +	TCA_TAPRIO_TC_ENTRY_UNSPEC,
> +	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
> +	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
> +
> +	/* add new constants above here */
> +	__TCA_TAPRIO_TC_ENTRY_CNT,
> +	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
> +};
> +
>  enum {
>  	TCA_TAPRIO_ATTR_UNSPEC,
>  	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
> @@ -1245,6 +1255,7 @@ enum {
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>  	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
>  	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
> +	TCA_TAPRIO_ATTR_TC_ENTRY, /* nest */
>  	__TCA_TAPRIO_ATTR_MAX,
>  };
>  
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 2a4b8f59f444..834cbed88e4f 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -79,6 +79,7 @@ struct taprio_sched {
>  	struct sched_gate_list __rcu *admin_sched;
>  	struct hrtimer advance_timer;
>  	struct list_head taprio_list;
> +	u32 max_sdu[TC_MAX_QUEUE];
>  	u32 txtime_delay;
>  };
>  
> @@ -416,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
>  			      struct Qdisc *child, struct sk_buff **to_free)
>  {
>  	struct taprio_sched *q = qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	int prio = skb->priority;
> +	u8 tc;
>  
>  	/* sk_flags are only safe to use on full sockets. */
>  	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
> @@ -427,6 +431,12 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
>  			return qdisc_drop(skb, sch, to_free);
>  	}
>  
> +	/* Devices with full offload are expected to honor this in hardware */
> +	tc = netdev_get_prio_tc_map(dev, prio);
> +	if (q->max_sdu[tc] &&
> +	    q->max_sdu[tc] < max_t(int, 0, skb->len - skb_mac_header_len(skb)))
> +		return qdisc_drop(skb, sch, to_free);
> +
>  	qdisc_qstats_backlog_inc(sch, skb);
>  	sch->q.qlen++;
>  
> @@ -761,6 +771,11 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
>  	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
>  };
>  
> +static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
> +	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
> +	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
> +};
> +
>  static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
>  	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
>  		.len = sizeof(struct tc_mqprio_qopt)
> @@ -773,6 +788,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
>  	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
>  	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
>  	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
> +	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
>  };
>  
>  static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
> @@ -1236,7 +1252,7 @@ static int taprio_enable_offload(struct net_device *dev,
>  {
>  	const struct net_device_ops *ops = dev->netdev_ops;
>  	struct tc_taprio_qopt_offload *offload;
> -	int err = 0;
> +	int tc, err = 0;
>  
>  	if (!ops->ndo_setup_tc) {
>  		NL_SET_ERR_MSG(extack,
> @@ -1253,6 +1269,9 @@ static int taprio_enable_offload(struct net_device *dev,
>  	offload->enable = 1;
>  	taprio_sched_to_offload(dev, sched, offload);
>  
> +	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
> +		offload->max_sdu[tc] = q->max_sdu[tc];
> +
>  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>  	if (err < 0) {
>  		NL_SET_ERR_MSG(extack,
> @@ -1387,6 +1406,73 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
>  	return err;
>  }
>  
> +static int taprio_parse_tc_entry(struct Qdisc *sch,
> +				 struct nlattr *opt,
> +				 unsigned long *seen_tcs,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
> +	struct taprio_sched *q = qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	u32 max_sdu = 0;
> +	int err, tc;
> +
> +	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
> +			       taprio_tc_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> +		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");
> +		return -EINVAL;
> +	}
> +
> +	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> +	if (tc >= TC_QOPT_MAX_QUEUE) {
> +		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");
> +		return -ERANGE;
> +	}
> +
> +	if (*seen_tcs & BIT(tc)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Duplicate TC entry");
> +		return -EINVAL;
> +	}
> +
> +	*seen_tcs |= BIT(tc);
> +
> +	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
> +		max_sdu = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
> +
> +	if (max_sdu > dev->max_mtu) {
> +		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
> +		return -ERANGE;
> +	}
> +
> +	q->max_sdu[tc] = max_sdu;
> +
> +	return 0;
> +}
> +
> +static int taprio_parse_tc_entries(struct Qdisc *sch,
> +				   struct nlattr *opt,
> +				   struct netlink_ext_ack *extack)
> +{
> +	unsigned long seen_tcs = 0;
> +	struct nlattr *n;
> +	int err = 0, rem;
> +
> +	nla_for_each_nested(n, opt, rem) {
> +		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
> +			continue;
> +
> +		err = taprio_parse_tc_entry(sch, n, &seen_tcs, extack);
> +		if (err)
> +			break;
> +	}
> +
> +	return err;
> +}
> +
>  static int taprio_mqprio_cmp(const struct net_device *dev,
>  			     const struct tc_mqprio_qopt *mqprio)
>  {
> @@ -1465,6 +1551,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	if (err < 0)
>  		return err;
>  
> +	err = taprio_parse_tc_entries(sch, opt, extack);
> +	if (err)
> +		return err;
> +
>  	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
>  	if (!new_admin) {
>  		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
> @@ -1855,6 +1945,33 @@ static int dump_schedule(struct sk_buff *msg,
>  	return -1;
>  }
>  
> +static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
> +{
> +	struct nlattr *n;
> +	int tc;
> +
> +	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
> +		n = nla_nest_start(skb, TCA_TAPRIO_ATTR_TC_ENTRY);
> +		if (!n)
> +			return -EMSGSIZE;
> +
> +		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_INDEX, tc))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
> +				q->max_sdu[tc]))
> +			goto nla_put_failure;
> +
> +		nla_nest_end(skb, n);
> +	}
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, n);
> +	return -EMSGSIZE;
> +}
> +
>  static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>  {
>  	struct taprio_sched *q = qdisc_priv(sch);
> @@ -1894,6 +2011,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>  	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
>  		goto options_error;
>  
> +	if (taprio_dump_tc_entries(q, skb))
> +		goto options_error;
> +
>  	if (oper && dump_schedule(skb, oper))
>  		goto options_error;
>  
> -- 
> 2.34.1
>

-- 
Vinicius
