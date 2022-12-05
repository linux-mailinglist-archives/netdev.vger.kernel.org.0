Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F2642E77
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiLERQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLERQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:16:10 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D091C119
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:16:04 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1441d7d40c6so14197238fac.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZluMKMeN6IsWoVI927FrZKDiSQG5znfnFnu4iEnYPIM=;
        b=bKvY+sDGl+36dEXtusxYv+EoyUwpEkvmBR9NhfM+j+47+/VTrHtIiHtGDBepKDqFMn
         cddVQKHdkkdQnALEneKLQKilAikigKrGvp922tdXWt/u166oApBmNHvQOaKU6WqIgxfl
         s6sTdRbzxIb7xHrWz9WPvlYRifogHpluDTZQBOhM7qWrdSbpyuVzgqN4SfOZ+W4Ceo9K
         7d/G7o9A4EjQqQPJHsKYRwGvi00xwsg55ehaGyrdrcWCSICZPd51kgNETHFaHkKUD8sE
         yJq5lFnjj0YMD0W0Fgt0+mhxgb5ufmoGNLtDpwzZczHEgL0T8EJRzex9nfa0MicLC9zv
         D44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZluMKMeN6IsWoVI927FrZKDiSQG5znfnFnu4iEnYPIM=;
        b=EuUzbqDkqFMTt5fOQ/R3Fi2DkPJnvun7Ots7baQCQlI15Sgz1NPiHJWR6A6hOoPxj4
         e/lnKruKqnfKh81gpsI+4zA2f2NlXHhOdAY9rPsM4KUrGcoKVbpevCV38juqTDlJGyXG
         Gu9gtV0c9oYmA+y2m1RoeVTnw441Nyi/mj2gzHrbMWbqfqI4tvQiw83uhLivahwxbwvk
         6iNC7GUFIGKbupPn4WWSi80SRf4BkvtDR+zzYGxMuJf6A/sESYQ6bBp//m1+co5rT02u
         IU5GnGunxPlAHZmESQ+MYefZ1mFKPdaP18ZJgFNl6q92Je62wuHBHikF/kVXWhvfgUrW
         1Kpg==
X-Gm-Message-State: ANoB5pnEO++u5D5EY8IIrXLInPWiL/Ui+FO92t/UBl6aOQOhUwwTwuGt
        GtQaRdoirGyIpsg1IkuBUR+p0wZ1Xe+jabB5
X-Google-Smtp-Source: AA0mqf55N41gEr4KUFg4cbD8w8xkGdp4AgWdvljArbXCME88bdT/U7Rsps8x6L9igVu7dIfV1eoeXw==
X-Received: by 2002:a05:6870:d784:b0:13a:ec33:4ed with SMTP id bd4-20020a056870d78400b0013aec3304edmr39689919oab.56.1670260563590;
        Mon, 05 Dec 2022 09:16:03 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id l17-20020a056871069100b0013d6d924995sm9429225oao.19.2022.12.05.09.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:16:03 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v3 2/4] net/sched: add retpoline wrapper for tc
Date:   Mon,  5 Dec 2022 14:15:18 -0300
Message-Id: <20221205171520.1731689-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205171520.1731689-1-pctammela@mojatatu.com>
References: <20221205171520.1731689-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
optimize actions and filters that are compiled as built-ins into a direct call.
The calls are ordered according to relevance. Testing data shows that
the pps difference between first and last is between 0.5%-1.0%.

On subsequent patches we expose the classifiers and actions functions
and wire up the wrapper into tc.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/tc_wrapper.h | 226 +++++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig        |  13 +++
 2 files changed, 239 insertions(+)
 create mode 100644 include/net/tc_wrapper.h

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
new file mode 100644
index 000000000000..3bdebbfdf9d2
--- /dev/null
+++ b/include/net/tc_wrapper.h
@@ -0,0 +1,226 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_WRAPPER_H
+#define __NET_TC_WRAPPER_H
+
+#include <linux/indirect_call_wrapper.h>
+#include <net/pkt_cls.h>
+
+#if IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
+
+#define TC_INDIRECT_SCOPE
+
+/* TC Actions */
+#ifdef CONFIG_NET_CLS_ACT
+
+#define TC_INDIRECT_ACTION_DECLARE(fname)                              \
+	INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,       \
+					    const struct tc_action *a, \
+					    struct tcf_result *res))
+
+TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_connmark_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ct_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ctinfo_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_gact_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_gate_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ife_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_ipt_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_mirred_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_mpls_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_nat_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_pedit_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_police_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_sample_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_simp_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_skbedit_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_skbmod_act);
+TC_INDIRECT_ACTION_DECLARE(tcf_vlan_act);
+TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
+
+static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+#if IS_BUILTIN(CONFIG_NET_ACT_GACT)
+	if (a->ops->act == tcf_gact_act)
+		return tcf_gact_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MIRRED)
+	if (a->ops->act == tcf_mirred_act)
+		return tcf_mirred_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_PEDIT)
+	if (a->ops->act == tcf_pedit_act)
+		return tcf_pedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBEDIT)
+	if (a->ops->act == tcf_skbedit_act)
+		return tcf_skbedit_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SKBMOD)
+	if (a->ops->act == tcf_skbmod_act)
+		return tcf_skbmod_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_POLICE)
+	if (a->ops->act == tcf_police_act)
+		return tcf_police_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
+	if (a->ops->act == tcf_bpf_act)
+		return tcf_bpf_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CONNMARK)
+	if (a->ops->act == tcf_connmark_act)
+		return tcf_connmark_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CSUM)
+	if (a->ops->act == tcf_csum_act)
+		return tcf_csum_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CT)
+	if (a->ops->act == tcf_ct_act)
+		return tcf_ct_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_CTINFO)
+	if (a->ops->act == tcf_ctinfo_act)
+		return tcf_ctinfo_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_GATE)
+	if (a->ops->act == tcf_gate_act)
+		return tcf_gate_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_MPLS)
+	if (a->ops->act == tcf_mpls_act)
+		return tcf_mpls_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_NAT)
+	if (a->ops->act == tcf_nat_act)
+		return tcf_nat_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_TUNNEL_KEY)
+	if (a->ops->act == tunnel_key_act)
+		return tunnel_key_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_VLAN)
+	if (a->ops->act == tcf_vlan_act)
+		return tcf_vlan_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IFE)
+	if (a->ops->act == tcf_ife_act)
+		return tcf_ife_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_IPT)
+	if (a->ops->act == tcf_ipt_act)
+		return tcf_ipt_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SIMP)
+	if (a->ops->act == tcf_simp_act)
+		return tcf_simp_act(skb, a, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_ACT_SAMPLE)
+	if (a->ops->act == tcf_sample_act)
+		return tcf_sample_act(skb, a, res);
+#endif
+
+	return a->ops->act(skb, a, res);
+}
+
+#endif /* CONFIG_NET_CLS_ACT */
+
+/* TC Filters */
+#ifdef CONFIG_NET_CLS
+
+#define TC_INDIRECT_FILTER_DECLARE(fname)                               \
+	INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,        \
+					    const struct tcf_proto *tp, \
+					    struct tcf_result *res))
+
+TC_INDIRECT_FILTER_DECLARE(basic_classify);
+TC_INDIRECT_FILTER_DECLARE(cls_bpf_classify);
+TC_INDIRECT_FILTER_DECLARE(cls_cgroup_classify);
+TC_INDIRECT_FILTER_DECLARE(fl_classify);
+TC_INDIRECT_FILTER_DECLARE(flow_classify);
+TC_INDIRECT_FILTER_DECLARE(fw_classify);
+TC_INDIRECT_FILTER_DECLARE(mall_classify);
+TC_INDIRECT_FILTER_DECLARE(route4_classify);
+TC_INDIRECT_FILTER_DECLARE(rsvp_classify);
+TC_INDIRECT_FILTER_DECLARE(rsvp6_classify);
+TC_INDIRECT_FILTER_DECLARE(tcindex_classify);
+TC_INDIRECT_FILTER_DECLARE(u32_classify);
+
+static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+#if IS_BUILTIN(CONFIG_NET_CLS_BPF)
+	if (tp->classify == cls_bpf_classify)
+		return cls_bpf_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_U32)
+	if (tp->classify == u32_classify)
+		return u32_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOWER)
+	if (tp->classify == fl_classify)
+		return fl_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FW)
+	if (tp->classify == fw_classify)
+		return fw_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_MATCHALL)
+	if (tp->classify == mall_classify)
+		return mall_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_BASIC)
+	if (tp->classify == basic_classify)
+		return basic_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
+	if (tp->classify == cls_cgroup_classify)
+		return cls_cgroup_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_FLOW)
+	if (tp->classify == flow_classify)
+		return flow_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_ROUTE4)
+	if (tp->classify == route4_classify)
+		return route4_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP)
+	if (tp->classify == rsvp_classify)
+		return rsvp_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_RSVP6)
+	if (tp->classify == rsvp6_classify)
+		return rsvp6_classify(skb, tp, res);
+#endif
+#if IS_BUILTIN(CONFIG_NET_CLS_TCINDEX)
+	if (tp->classify == tcindex_classify)
+		return tcindex_classify(skb, tp, res);
+#endif
+
+	return tp->classify(skb, tp, res);
+}
+
+#endif /* CONFIG_NET_CLS */
+
+#else
+
+#define TC_INDIRECT_SCOPE static
+
+static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	return a->ops->act(skb, a, res);
+}
+
+static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+				struct tcf_result *res)
+{
+	return tp->classify(skb, tp, res);
+}
+
+#endif
+
+#endif /* __NET_TC_WRAPPER_H */
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..9bc055f8013e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -1021,6 +1021,19 @@ config NET_TC_SKB_EXT
 
 	  Say N here if you won't be using tc<->ovs offload or tc chains offload.
 
+config NET_TC_INDIRECT_WRAPPER
+	bool "TC indirect call wrapper"
+	depends on NET_SCHED
+	depends on RETPOLINE
+
+	help
+	  Say Y here to skip indirect calls in the TC datapath for known
+	  builtin classifiers/actions under CONFIG_RETPOLINE kernels.
+
+	  TC may run slower on CPUs with hardware based mitigations.
+
+	  If unsure, say N.
+
 endif # NET_SCHED
 
 config NET_SCH_FIFO
-- 
2.34.1

