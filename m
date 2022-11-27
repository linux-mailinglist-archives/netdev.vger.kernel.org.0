Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9952639922
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 02:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiK0BsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 20:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiK0BsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 20:48:10 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2941116A
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 17:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669513686; x=1701049686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sV8HlDFcmgjRFP4IOTM1YhmhyfScwlMQzYNZQ5pysPM=;
  b=k/oP+YjWtCm9nHjABkboiuePqo5dB8w4Mf4T3rvhMU0PlLKwZZ1lFmi5
   GHuP00HKO25md+wCSllThfqGNIWsB+9nHe5A9t8oTl4qMQoaq//c5y79B
   ayJYb/uhKRhK3a7OvfmcSMoUAbrfMPl/f0bvp36cpctz1HZlL/Jm3MKTD
   c=;
X-IronPort-AV: E=Sophos;i="5.96,197,1665446400"; 
   d="scan'208";a="271096606"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 01:48:05 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id A7B65423B5;
        Sun, 27 Nov 2022 01:48:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 27 Nov 2022 01:48:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 27 Nov 2022 01:47:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pctammela@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <pctammela@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH RFC net-next 1/3] net/sched: add retpoline wrapper for tc
Date:   Sun, 27 Nov 2022 10:47:49 +0900
Message-ID: <20221127014749.38849-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221125175207.473866-2-pctammela@mojatatu.com>
References: <20221125175207.473866-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D39UWB003.ant.amazon.com (10.43.161.215) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Pedro Tammela <pctammela@gmail.com>
Date:   Fri, 25 Nov 2022 14:52:05 -0300
> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
> optimize actions and filters that are compiled as built-ins into a direct call.
> The calls are ordered alphabetically, but new ones should be ideally
> added last.
> 
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/tc_wrapper.h | 274 +++++++++++++++++++++++++++++++++++++++
>  net/sched/Kconfig        |  13 ++
>  2 files changed, 287 insertions(+)
>  create mode 100644 include/net/tc_wrapper.h
> 
> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
> new file mode 100644
> index 000000000000..7890d2810148
> --- /dev/null
> +++ b/include/net/tc_wrapper.h
> @@ -0,0 +1,274 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_TC_WRAPPER_H
> +#define __NET_TC_WRAPPER_H
> +
> +#include <linux/indirect_call_wrapper.h>
> +#include <net/pkt_cls.h>
> +
> +#if IS_ENABLED(CONFIG_RETPOLINE) && IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
> +
> +#define TC_INDIRECT_SCOPE
> +
> +/* TC Actions */
> +INDIRECT_CALLABLE_DECLARE(int tcf_bpf_act(struct sk_buff *skb,
> +					  const struct tc_action *a,
> +					  struct tcf_result *res));

I prefer writing this like below than repeating INDIRECT_CALLABLE_DECLARE()
as all action have the same args.

  #define TC_INDIRECT_ACTION_DECLARE(func) \
  	INDIRECT_CALLABLE_DECLARE(int func(...))

  TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
  TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
  ...


> +INDIRECT_CALLABLE_DECLARE(int tcf_connmark_act(struct sk_buff *skb,
> +					       const struct tc_action *a,
> +					       struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_csum_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_ct_act(struct sk_buff *skb,
> +					 const struct tc_action *a,
> +					 struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_ctinfo_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_gact_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_gate_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_ife_act(struct sk_buff *skb,
> +					  const struct tc_action *a,
> +					  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_ipt_act(struct sk_buff *skb,
> +					  const struct tc_action *a,
> +					  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_mirred_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_mpls_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_nat_act(struct sk_buff *skb,
> +					  const struct tc_action *a,
> +					  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_pedit_act(struct sk_buff *skb,
> +					    const struct tc_action *a,
> +					    struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_police_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_sample_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_simp_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_skbedit_act(struct sk_buff *skb,
> +					      const struct tc_action *a,
> +					      struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_skbmod_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcf_vlan_act(struct sk_buff *skb,
> +					   const struct tc_action *a,
> +					   struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tunnel_key_act(struct sk_buff *skb,
> +					     const struct tc_action *a,
> +					     struct tcf_result *res));
> +
> +/* TC Filters */
> +INDIRECT_CALLABLE_DECLARE(int basic_classify(struct sk_buff *skb,
> +					     const struct tcf_proto *tp,
> +					     struct tcf_result *res));

Same here.


> +INDIRECT_CALLABLE_DECLARE(int cls_bpf_classify(struct sk_buff *skb,
> +					       const struct tcf_proto *tp,
> +					       struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int cls_cgroup_classify(struct sk_buff *skb,
> +						  const struct tcf_proto *tp,
> +						  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int fl_classify(struct sk_buff *skb,
> +					  const struct tcf_proto *tp,
> +					  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int flow_classify(struct sk_buff *skb,
> +					    const struct tcf_proto *tp,
> +					    struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int fw_classify(struct sk_buff *skb,
> +					  const struct tcf_proto *tp,
> +					  struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int mall_classify(struct sk_buff *skb,
> +					    const struct tcf_proto *tp,
> +					    struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int route4_classify(struct sk_buff *skb,
> +					      const struct tcf_proto *tp,
> +					      struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int rsvp_classify(struct sk_buff *skb,
> +					    const struct tcf_proto *tp,
> +					    struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int rsvp6_classify(struct sk_buff *skb,
> +					     const struct tcf_proto *tp,
> +					     struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int tcindex_classify(struct sk_buff *skb,
> +					       const struct tcf_proto *tp,
> +					       struct tcf_result *res));
> +INDIRECT_CALLABLE_DECLARE(int u32_classify(struct sk_buff *skb,
> +					   const struct tcf_proto *tp,
> +					   struct tcf_result *res));
> +
> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> +			   struct tcf_result *res)
> +{
> +	if (0) { /* noop */ }
> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
> +	else if (a->ops->act == tcf_bpf_act)
> +		return tcf_bpf_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CONNMARK)
> +	else if (a->ops->act == tcf_connmark_act)
> +		return tcf_connmark_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CSUM)
> +	else if (a->ops->act == tcf_csum_act)
> +		return tcf_csum_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CT)
> +	else if (a->ops->act == tcf_ct_act)
> +		return tcf_ct_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CTINFO)
> +	else if (a->ops->act == tcf_ctinfo_act)
> +		return tcf_ctinfo_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_GACT)
> +	else if (a->ops->act == tcf_gact_act)
> +		return tcf_gact_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_GATE)
> +	else if (a->ops->act == tcf_gate_act)
> +		return tcf_gate_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_IFE)
> +	else if (a->ops->act == tcf_ife_act)
> +		return tcf_ife_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_IPT)
> +	else if (a->ops->act == tcf_ipt_act)
> +		return tcf_ipt_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_MIRRED)
> +	else if (a->ops->act == tcf_mirred_act)
> +		return tcf_mirred_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_MPLS)
> +	else if (a->ops->act == tcf_mpls_act)
> +		return tcf_mpls_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_NAT)
> +	else if (a->ops->act == tcf_nat_act)
> +		return tcf_nat_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_PEDIT)
> +	else if (a->ops->act == tcf_pedit_act)
> +		return tcf_pedit_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_POLICE)
> +	else if (a->ops->act == tcf_police_act)
> +		return tcf_police_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SAMPLE)
> +	else if (a->ops->act == tcf_sample_act)
> +		return tcf_sample_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SIMP)
> +	else if (a->ops->act == tcf_simp_act)
> +		return tcf_simp_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SKBEDIT)
> +	else if (a->ops->act == tcf_skbedit_act)
> +		return tcf_skbedit_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SKBMOD)
> +	else if (a->ops->act == tcf_skbmod_act)
> +		return tcf_skbmod_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_TUNNEL_KEY)
> +	else if (a->ops->act == tunnel_key_act)
> +		return tunnel_key_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_VLAN)
> +	else if (a->ops->act == tcf_vlan_act)
> +		return tcf_vlan_act(skb, a, res);
> +#endif
> +	else
> +		return a->ops->act(skb, a, res);
> +}
> +
> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +				struct tcf_result *res)
> +{
> +	if (0) { /* noop */ }
> +#if IS_BUILTIN(CONFIG_NET_CLS_BASIC)
> +	else if (tp->classify == basic_classify)
> +		return basic_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_BPF)
> +	else if (tp->classify == cls_bpf_classify)
> +		return cls_bpf_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
> +	else if (tp->classify == cls_cgroup_classify)
> +		return cls_cgroup_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FLOW)
> +	else if (tp->classify == flow_classify)
> +		return flow_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FLOWER)
> +	else if (tp->classify == fl_classify)
> +		return fl_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FW)
> +	else if (tp->classify == fw_classify)
> +		return fw_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_MATCHALL)
> +	else if (tp->classify == mall_classify)
> +		return mall_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_ROUTE4)
> +	else if (tp->classify == route4_classify)
> +		return route4_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_RSVP)
> +	else if (tp->classify == rsvp_classify)
> +		return rsvp_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_RSVP6)
> +	else if (tp->classify == rsvp6_classify)
> +		return rsvp_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_TCINDEX)
> +	else if (tp->classify == tcindex_classify)
> +		return tcindex_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_U32)
> +	else if (tp->classify == u32_classify)
> +		return u32_classify(skb, tp, res);
> +#endif
> +	else
> +		return tp->classify(skb, tp, res);
> +}
> +
> +#else
> +
> +#define TC_INDIRECT_SCOPE static
> +
> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> +			   struct tcf_result *res)
> +{
> +	return a->ops->act(skb, a, res);
> +}
> +
> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +				struct tcf_result *res)
> +{
> +	return tp->classify(skb, tp, res);
> +}
> +
> +#endif
> +
> +#endif /* __NET_TC_WRAPPER_H */
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 1e8ab4749c6c..9bc055f8013e 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -1021,6 +1021,19 @@ config NET_TC_SKB_EXT
>  
>  	  Say N here if you won't be using tc<->ovs offload or tc chains offload.
>  
> +config NET_TC_INDIRECT_WRAPPER
> +	bool "TC indirect call wrapper"
> +	depends on NET_SCHED
> +	depends on RETPOLINE
> +
> +	help
> +	  Say Y here to skip indirect calls in the TC datapath for known
> +	  builtin classifiers/actions under CONFIG_RETPOLINE kernels.
> +
> +	  TC may run slower on CPUs with hardware based mitigations.
> +
> +	  If unsure, say N.
> +
>  endif # NET_SCHED
>  
>  config NET_SCH_FIFO
> -- 
> 2.34.1
