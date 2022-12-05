Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49D7643875
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiLEWxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiLEWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:53:30 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A401DA67
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 14:53:25 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id e205so14786594oif.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 14:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eCU+V2C0K8jVr6/JnDHCTyER8iY+Br0k2hrepRYUPnU=;
        b=160fkNBq7agKZup3dZ1GGlsgSeq6oN9AvN9yJwq37ZGPg9kbjbmyEnkIZjh5WCbdp8
         8m5uZ4SjcND3PVibLALihUmPsTN3DGqYduwxoff4Qgwi6ZdgI20A3O48zUmff+0rJlW9
         t+Wkkjn5lbU9+3NwZ6aAF8hLv2TDWZh2w6HBJ7eMbvEVZXTbtaymHjN8OCVBiqbyo5JC
         7sWTF9CB8nlr8WnYwFLU7D24kZSMnQss22YiLQ+tDCfPkKmk+r+VKdR9brHOd97BbUzq
         rB7BrzrcSRFZagMeChdjP8aR+ZyjX6wwmAA8KQxgi6FCtuS7PiOxgzpESahTkGJzEFN0
         X24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCU+V2C0K8jVr6/JnDHCTyER8iY+Br0k2hrepRYUPnU=;
        b=JPs0XFnJoYcek7beP4Znd8Yjmhj6WFfERl7Tl2k1pI4MHwB6gmuBzbsi19Jnh+/yQM
         VpF7/5eqUsbIWTgoNItCIExumL3MKzsxnkiNYdf6ganE48L2cwCBK5QDKcaS9gOOJCp5
         l6K0BP42r6zGmAvV1pp4DubPpMJN4YhLcxaIpGpBdzYnU47ylKrX2MmXDg3S4a0FVTyW
         RX4dWK91zES6q210zUAU8YPNB94yKsEGT5EtHvKSuDmcy4u662aqScfdI7XcbWRbcVQF
         o9spV/82V7gd58N9PdQbSUvKb0Ue7cspg7fiO63s/cesN93jaSDYSpNLb0TpE5RFUFzG
         hmfw==
X-Gm-Message-State: ANoB5plnkuf0dOmH/dAaohFVOhOBz0/wUYp1Nh49HFMYLvtG6po3qI9f
        OvIciR5oduewhemmcyBYy51IDV9K2JB0akqn
X-Google-Smtp-Source: AA0mqf74ycYl8TXiNHhdkghVky2BTl2DfvNBiW/IkFh9rY4kB4Elmoy8HNQXU51/VzpLiqbxhGsZfA==
X-Received: by 2002:aca:b4c5:0:b0:35a:cf84:d834 with SMTP id d188-20020acab4c5000000b0035acf84d834mr44424140oif.41.1670280803940;
        Mon, 05 Dec 2022 14:53:23 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id e5-20020a544f05000000b0035a5ed5d935sm7608935oiy.16.2022.12.05.14.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 14:53:23 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v4 3/4] net/sched: avoid indirect act functions on retpoline kernels
Date:   Mon,  5 Dec 2022 19:53:05 -0300
Message-Id: <20221205225306.1778712-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205225306.1778712-1-pctammela@mojatatu.com>
References: <20221205225306.1778712-1-pctammela@mojatatu.com>
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

Expose the necessary tc act functions and wire up act_api to use
direct calls in retpoline kernels.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 net/sched/act_api.c        | 3 ++-
 net/sched/act_bpf.c        | 6 ++++--
 net/sched/act_connmark.c   | 6 ++++--
 net/sched/act_csum.c       | 6 ++++--
 net/sched/act_ct.c         | 5 +++--
 net/sched/act_ctinfo.c     | 6 ++++--
 net/sched/act_gact.c       | 6 ++++--
 net/sched/act_gate.c       | 6 ++++--
 net/sched/act_ife.c        | 6 ++++--
 net/sched/act_ipt.c        | 6 ++++--
 net/sched/act_mirred.c     | 6 ++++--
 net/sched/act_mpls.c       | 6 ++++--
 net/sched/act_nat.c        | 7 ++++---
 net/sched/act_pedit.c      | 6 ++++--
 net/sched/act_police.c     | 6 ++++--
 net/sched/act_sample.c     | 6 ++++--
 net/sched/act_simple.c     | 6 ++++--
 net/sched/act_skbedit.c    | 6 ++++--
 net/sched/act_skbmod.c     | 6 ++++--
 net/sched/act_tunnel_key.c | 6 ++++--
 net/sched/act_vlan.c       | 6 ++++--
 21 files changed, 81 insertions(+), 42 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9f4c0f5f45c1..44d4b1e4e18e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -23,6 +23,7 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
+#include <net/tc_wrapper.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -1080,7 +1081,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 
 		repeat_ttl = 32;
 repeat:
-		ret = a->ops->act(skb, a, res);
+		ret = tc_act(skb, a, res);
 		if (unlikely(ret == TC_ACT_REPEAT)) {
 			if (--repeat_ttl != 0)
 				goto repeat;
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index b79eee44e24e..b0455fda7d0b 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -18,6 +18,7 @@
 
 #include <linux/tc_act/tc_bpf.h>
 #include <net/tc_act/tc_bpf.h>
+#include <net/tc_wrapper.h>
 
 #define ACT_BPF_NAME_LEN	256
 
@@ -31,8 +32,9 @@ struct tcf_bpf_cfg {
 
 static struct tc_action_ops act_bpf_ops;
 
-static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
+				  const struct tc_action *act,
+				  struct tcf_result *res)
 {
 	bool at_ingress = skb_at_tc_ingress(skb);
 	struct tcf_bpf *prog = to_bpf(act);
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 66b143bb04ac..3e643aced3b3 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -20,6 +20,7 @@
 #include <net/pkt_cls.h>
 #include <uapi/linux/tc_act/tc_connmark.h>
 #include <net/tc_act/tc_connmark.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -27,8 +28,9 @@
 
 static struct tc_action_ops act_connmark_ops;
 
-static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
-			    struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
+				       const struct tc_action *a,
+				       struct tcf_result *res)
 {
 	const struct nf_conntrack_tuple_hash *thash;
 	struct nf_conntrack_tuple tuple;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 1366adf9b909..95e9304024b7 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -32,6 +32,7 @@
 
 #include <linux/tc_act/tc_csum.h>
 #include <net/tc_act/tc_csum.h>
+#include <net/tc_wrapper.h>
 
 static const struct nla_policy csum_policy[TCA_CSUM_MAX + 1] = {
 	[TCA_CSUM_PARMS] = { .len = sizeof(struct tc_csum), },
@@ -563,8 +564,9 @@ static int tcf_csum_ipv6(struct sk_buff *skb, u32 update_flags)
 	return 0;
 }
 
-static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_csum_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_csum *p = to_tcf_csum(a);
 	bool orig_vlan_tag_present = false;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index da0b7f665277..249c138376bb 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -24,6 +24,7 @@
 #include <net/ipv6_frag.h>
 #include <uapi/linux/tc_act/tc_ct.h>
 #include <net/tc_act/tc_ct.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -1038,8 +1039,8 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 #endif
 }
 
-static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
-		      struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
+				 struct tcf_result *res)
 {
 	struct net *net = dev_net(skb->dev);
 	enum ip_conntrack_info ctinfo;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index d4102f0a9abd..0064934a4eac 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -18,6 +18,7 @@
 #include <net/pkt_cls.h>
 #include <uapi/linux/tc_act/tc_ctinfo.h>
 #include <net/tc_act/tc_ctinfo.h>
+#include <net/tc_wrapper.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -75,8 +76,9 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 	skb->mark = ct->mark & cp->cpmarkmask;
 }
 
-static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	const struct nf_conntrack_tuple_hash *thash = NULL;
 	struct tcf_ctinfo *ca = to_ctinfo(a);
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 62d682b96b88..54f1b13b2360 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -18,6 +18,7 @@
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_gact.h>
 #include <net/tc_act/tc_gact.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_gact_ops;
 
@@ -145,8 +146,9 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_gact_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_gact *gact = to_gact(a);
 	int action = READ_ONCE(gact->tcf_action);
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 3049878e7315..9b8def0be41e 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -14,6 +14,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gate.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_gate_ops;
 
@@ -113,8 +114,9 @@ static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
-static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_gate_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_gate *gact = to_gate(a);
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41d63b33461d..bc7611b0744c 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -29,6 +29,7 @@
 #include <net/tc_act/tc_ife.h>
 #include <linux/etherdevice.h>
 #include <net/ife.h>
+#include <net/tc_wrapper.h>
 
 static int max_metacnt = IFE_META_MAX + 1;
 static struct tc_action_ops act_ife_ops;
@@ -861,8 +862,9 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 }
 
-static int tcf_ife_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ife_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	struct tcf_ife_info *ife = to_ife(a);
 	struct tcf_ife_params *p;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 1625e1037416..5d96ffebd40f 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -20,6 +20,7 @@
 #include <net/pkt_sched.h>
 #include <linux/tc_act/tc_ipt.h>
 #include <net/tc_act/tc_ipt.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 
@@ -216,8 +217,9 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 			      a, &act_xt_ops, tp, flags);
 }
 
-static int tcf_ipt_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	int ret = 0, result = 0;
 	struct tcf_ipt *ipt = to_ipt(a);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b8ad6ae282c0..7284bcea7b0b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -24,6 +24,7 @@
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_mirred.h>
+#include <net/tc_wrapper.h>
 
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
@@ -217,8 +218,9 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 	return err;
 }
 
-static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_mirred *m = to_mirred(a);
 	struct sk_buff *skb2 = skb;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8ad25cc8ccd5..ff47ce4d3968 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -14,6 +14,7 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_mpls_ops;
 
@@ -49,8 +50,9 @@ static __be32 tcf_mpls_get_lse(struct mpls_shim_hdr *lse,
 	return cpu_to_be32(new_lse);
 }
 
-static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_mpls_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_mpls *m = to_mpls(a);
 	struct tcf_mpls_params *p;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 9265145f1040..74c74be33048 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -24,7 +24,7 @@
 #include <net/tc_act/tc_nat.h>
 #include <net/tcp.h>
 #include <net/udp.h>
-
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_nat_ops;
 
@@ -98,8 +98,9 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	return err;
 }
 
-static int tcf_nat_act(struct sk_buff *skb, const struct tc_action *a,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_nat_act(struct sk_buff *skb,
+				  const struct tc_action *a,
+				  struct tcf_result *res)
 {
 	struct tcf_nat *p = to_tcf_nat(a);
 	struct iphdr *iph;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 94ed5857ce67..a0378e9f0121 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -20,6 +20,7 @@
 #include <net/tc_act/tc_pedit.h>
 #include <uapi/linux/tc_act/tc_pedit.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 static struct tc_action_ops act_pedit_ops;
 
@@ -319,8 +320,9 @@ static int pedit_skb_hdr_offset(struct sk_buff *skb,
 	return ret;
 }
 
-static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
-			 struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
+				    const struct tc_action *a,
+				    struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
 	u32 max_offset;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0adb26e366a7..227cba58ce9f 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -19,6 +19,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_police.h>
+#include <net/tc_wrapper.h>
 
 /* Each policer is serialized by its individual spinlock */
 
@@ -242,8 +243,9 @@ static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
 	return len <= limit;
 }
 
-static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_police_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_police *police = to_police(a);
 	s64 now, toks, ppstoks = 0, ptoks = 0;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 7a25477f5d99..98dea08c1764 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -20,6 +20,7 @@
 #include <net/tc_act/tc_sample.h>
 #include <net/psample.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/if_arp.h>
 
@@ -153,8 +154,9 @@ static bool tcf_sample_dev_ok_push(struct net_device *dev)
 	}
 }
 
-static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_sample_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_sample *s = to_sample(a);
 	struct psample_group *psample_group;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 18d376135461..4b84514534f3 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -14,6 +14,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_defact.h>
 #include <net/tc_act/tc_defact.h>
@@ -21,8 +22,9 @@
 static struct tc_action_ops act_simp_ops;
 
 #define SIMP_MAX_DATA	32
-static int tcf_simp_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_simp_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_defact *d = to_defact(a);
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 1710780c908a..ce7008cf291c 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -16,6 +16,7 @@
 #include <net/ipv6.h>
 #include <net/dsfield.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_skbedit.h>
@@ -36,8 +37,9 @@ static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
 	return netdev_cap_txqueue(skb->dev, queue_mapping);
 }
 
-static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
-			   struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
+				      const struct tc_action *a,
+				      struct tcf_result *res)
 {
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tcf_skbedit_params *params;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index d98758a63934..dffa990a9629 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -15,14 +15,16 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_skbmod.h>
 #include <net/tc_act/tc_skbmod.h>
 
 static struct tc_action_ops act_skbmod_ops;
 
-static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_skbmod *d = to_skbmod(a);
 	int action, max_edit_len, err;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2691a3d8e451..2d12d2626415 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -16,14 +16,16 @@
 #include <net/pkt_sched.h>
 #include <net/dst.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_tunnel_key.h>
 
 static struct tc_action_ops act_tunnel_key_ops;
 
-static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int tunnel_key_act(struct sk_buff *skb,
+				     const struct tc_action *a,
+				     struct tcf_result *res)
 {
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
 	struct tcf_tunnel_key_params *params;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 7b24e898a3e6..0251442f5f29 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -12,14 +12,16 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #include <linux/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_vlan.h>
 
 static struct tc_action_ops act_vlan_ops;
 
-static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcf_vlan_act(struct sk_buff *skb,
+				   const struct tc_action *a,
+				   struct tcf_result *res)
 {
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_vlan_params *p;
-- 
2.34.1

