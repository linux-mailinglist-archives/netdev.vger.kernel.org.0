Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047C26443BF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiLFM7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiLFM7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:59:04 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD591057E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:58:52 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1442977d77dso16154113fac.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1Z91YzsanF8U0ilh0dm0yoWMW+J7/pQLJRrhggoUNE=;
        b=m04LQN+vmgwoOTnOtDKV+9/qBsx7thy4psq1vtp/n5ANrwRUuob3772lBoRYqe4p9N
         3lpyWzddGAzdVUOpfZRfHadx7FTGfwC3vkvs/iqtyN7g++1LIM5gjjUeHhOO6P4Qnll+
         zsk67HF3fj1YMNYeiw3fMle/Ljot1YwbDfmISCtDjiEu9EMFPs3NcaqjiBa8ZTc1Sw7d
         cUeoylk9GSBjY1P1sPDk3MFpJYZf9jPPwZqfQpDmR42tnN/2mmKLwLy0it6ucw6kvaDy
         mWQu46hmoFxAmhuEiC8oAlT2zKXAQdsVQXJwDGxWNbSZjRYNOLXs04KWt+RdWkp3fQQD
         OmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1Z91YzsanF8U0ilh0dm0yoWMW+J7/pQLJRrhggoUNE=;
        b=BEcOsrlx0SNSken5ZtRQaE6KZKvuXRm+Ap7pyPdogshmeFnNVMIyAfTHCFyR2yQ/Iq
         yJE048NprgiA8I3DVG4e63M8pypiO+dF3gp6ZwBmHpwNa+MaFzHh7xc0VMW832AuKR0n
         OBz9n/9/KS1CmlOMZbJuMoRtZ14abOvGszMt3OpOPPFBENsuU1T8oqPqEAh9VILjKSaC
         kzDP/feppDDv3UkqzLtqmj4Fi6aBCIFGLf4OZJLWEzlLS0DQjYrrZ218irxzsRTfzHzS
         KNMl9iNlr2yrAYukK0tHnHpuQC342dBFiltuHqCcA46cXco57IWmPMoN5xHFS8bUfAsN
         Qh1g==
X-Gm-Message-State: ANoB5pnTfNA+MsNohPbX+Rax8bviLORr3dUbEq3TzXPUw6D2oK0c+Auj
        kim0XlF6E/c6UU+Vcjex2GvA52D1ilp3mRFu
X-Google-Smtp-Source: AA0mqf7p3A9T1yOFiKJx2KiTiTsrsRv3BJ5Al/oH4Jd6ameEVhbbtD/Ff3oUdsocWTCnsKXHTdgNyw==
X-Received: by 2002:a05:6871:410d:b0:144:4557:320a with SMTP id la13-20020a056871410d00b001444557320amr9263952oab.112.1670331531929;
        Tue, 06 Dec 2022 04:58:51 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6544:c4a9:5a4c:3545])
        by smtp.gmail.com with ESMTPSA id cm5-20020a056830650500b0066b9a6bf3bcsm8944770otb.12.2022.12.06.04.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:58:51 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v5 4/4] net/sched: avoid indirect classify functions on retpoline kernels
Date:   Tue,  6 Dec 2022 09:58:27 -0300
Message-Id: <20221206125827.1832477-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206125827.1832477-1-pctammela@mojatatu.com>
References: <20221206125827.1832477-1-pctammela@mojatatu.com>
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

Expose the necessary tc classifier functions and wire up cls_api to use
direct calls in retpoline kernels.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 net/sched/cls_api.c      | 3 ++-
 net/sched/cls_basic.c    | 6 ++++--
 net/sched/cls_bpf.c      | 6 ++++--
 net/sched/cls_cgroup.c   | 6 ++++--
 net/sched/cls_flow.c     | 6 ++++--
 net/sched/cls_flower.c   | 6 ++++--
 net/sched/cls_fw.c       | 6 ++++--
 net/sched/cls_matchall.c | 6 ++++--
 net/sched/cls_route.c    | 6 ++++--
 net/sched/cls_rsvp.c     | 2 ++
 net/sched/cls_rsvp.h     | 6 +++---
 net/sched/cls_rsvp6.c    | 2 ++
 net/sched/cls_tcindex.c  | 7 ++++---
 net/sched/cls_u32.c      | 6 ++++--
 14 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a2c276116244..39b6f6331dee 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -40,6 +40,7 @@
 #include <net/tc_act/tc_mpls.h>
 #include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
+#include <net/tc_wrapper.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -1564,7 +1565,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 		    tp->protocol != htons(ETH_P_ALL))
 			continue;
 
-		err = tp->classify(skb, tp, res);
+		err = tc_classify(skb, tp, res);
 #ifdef CONFIG_NET_CLS_ACT
 		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
 			first_tp = orig_tp;
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index d229ce99e554..1b92c33b5f81 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -18,6 +18,7 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 struct basic_head {
 	struct list_head	flist;
@@ -36,8 +37,9 @@ struct basic_filter {
 	struct rcu_work		rwork;
 };
 
-static int basic_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			  struct tcf_result *res)
+TC_INDIRECT_SCOPE int basic_classify(struct sk_buff *skb,
+				     const struct tcf_proto *tp,
+				     struct tcf_result *res)
 {
 	int r;
 	struct basic_head *head = rcu_dereference_bh(tp->root);
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index bc317b3eac12..466c26df853a 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -19,6 +19,7 @@
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
+#include <net/tc_wrapper.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Daniel Borkmann <dborkman@redhat.com>");
@@ -77,8 +78,9 @@ static int cls_bpf_exec_opcode(int code)
 	}
 }
 
-static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			    struct tcf_result *res)
+TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_buff *skb,
+				       const struct tcf_proto *tp,
+				       struct tcf_result *res)
 {
 	struct cls_bpf_head *head = rcu_dereference_bh(tp->root);
 	bool at_ingress = skb_at_tc_ingress(skb);
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index ed00001b528a..bd9322d71910 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -13,6 +13,7 @@
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 #include <net/cls_cgroup.h>
+#include <net/tc_wrapper.h>
 
 struct cls_cgroup_head {
 	u32			handle;
@@ -22,8 +23,9 @@ struct cls_cgroup_head {
 	struct rcu_work		rwork;
 };
 
-static int cls_cgroup_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			       struct tcf_result *res)
+TC_INDIRECT_SCOPE int cls_cgroup_classify(struct sk_buff *skb,
+					  const struct tcf_proto *tp,
+					  struct tcf_result *res)
 {
 	struct cls_cgroup_head *head = rcu_dereference_bh(tp->root);
 	u32 classid = task_get_classid(skb);
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 014cd3de7b5d..535668e1f748 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -24,6 +24,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/flow_dissector.h>
+#include <net/tc_wrapper.h>
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
@@ -292,8 +293,9 @@ static u32 flow_key_get(struct sk_buff *skb, int key, struct flow_keys *flow)
 			  (1 << FLOW_KEY_NFCT_PROTO_SRC) |	\
 			  (1 << FLOW_KEY_NFCT_PROTO_DST))
 
-static int flow_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			 struct tcf_result *res)
+TC_INDIRECT_SCOPE int flow_classify(struct sk_buff *skb,
+				    const struct tcf_proto *tp,
+				    struct tcf_result *res)
 {
 	struct flow_head *head = rcu_dereference_bh(tp->root);
 	struct flow_filter *f;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 25bc57ee6ea1..0b15698b3531 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -27,6 +27,7 @@
 #include <net/vxlan.h>
 #include <net/erspan.h>
 #include <net/gtp.h>
+#include <net/tc_wrapper.h>
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
@@ -305,8 +306,9 @@ static u16 fl_ct_info_to_flower_map[] = {
 					TCA_FLOWER_KEY_CT_FLAGS_NEW,
 };
 
-static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int fl_classify(struct sk_buff *skb,
+				  const struct tcf_proto *tp,
+				  struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
 	bool post_ct = tc_skb_cb(skb)->post_ct;
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index a32351da968c..ae9439a6c56c 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -21,6 +21,7 @@
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
 #include <net/sch_generic.h>
+#include <net/tc_wrapper.h>
 
 #define HTSIZE 256
 
@@ -47,8 +48,9 @@ static u32 fw_hash(u32 handle)
 	return handle % HTSIZE;
 }
 
-static int fw_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		       struct tcf_result *res)
+TC_INDIRECT_SCOPE int fw_classify(struct sk_buff *skb,
+				  const struct tcf_proto *tp,
+				  struct tcf_result *res)
 {
 	struct fw_head *head = rcu_dereference_bh(tp->root);
 	struct fw_filter *f;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 39a5d9c170de..705f63da2c21 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -12,6 +12,7 @@
 
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 struct cls_mall_head {
 	struct tcf_exts exts;
@@ -24,8 +25,9 @@ struct cls_mall_head {
 	bool deleting;
 };
 
-static int mall_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			 struct tcf_result *res)
+TC_INDIRECT_SCOPE int mall_classify(struct sk_buff *skb,
+				    const struct tcf_proto *tp,
+				    struct tcf_result *res)
 {
 	struct cls_mall_head *head = rcu_dereference_bh(tp->root);
 
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 9e43b929d4ca..d0c53724d3e8 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -17,6 +17,7 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 /*
  * 1. For now we assume that route tags < 256.
@@ -121,8 +122,9 @@ static inline int route4_hash_wild(void)
 	return 0;						\
 }
 
-static int route4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			   struct tcf_result *res)
+TC_INDIRECT_SCOPE int route4_classify(struct sk_buff *skb,
+				      const struct tcf_proto *tp,
+				      struct tcf_result *res)
 {
 	struct route4_head *head = rcu_dereference_bh(tp->root);
 	struct dst_entry *dst;
diff --git a/net/sched/cls_rsvp.c b/net/sched/cls_rsvp.c
index de1c1d4da597..03d8619bd9c6 100644
--- a/net/sched/cls_rsvp.c
+++ b/net/sched/cls_rsvp.c
@@ -15,10 +15,12 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
+#include <net/tc_wrapper.h>
 
 #define RSVP_DST_LEN	1
 #define RSVP_ID		"rsvp"
 #define RSVP_OPS	cls_rsvp_ops
+#define RSVP_CLS	rsvp_classify
 
 #include "cls_rsvp.h"
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index b00a7dbd0587..869efba9f834 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -124,8 +124,8 @@ static inline unsigned int hash_src(__be32 *src)
 		return r;				\
 }
 
-static int rsvp_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			 struct tcf_result *res)
+TC_INDIRECT_SCOPE int RSVP_CLS(struct sk_buff *skb, const struct tcf_proto *tp,
+			       struct tcf_result *res)
 {
 	struct rsvp_head *head = rcu_dereference_bh(tp->root);
 	struct rsvp_session *s;
@@ -738,7 +738,7 @@ static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 
 static struct tcf_proto_ops RSVP_OPS __read_mostly = {
 	.kind		=	RSVP_ID,
-	.classify	=	rsvp_classify,
+	.classify	=	RSVP_CLS,
 	.init		=	rsvp_init,
 	.destroy	=	rsvp_destroy,
 	.get		=	rsvp_get,
diff --git a/net/sched/cls_rsvp6.c b/net/sched/cls_rsvp6.c
index 64078846000e..e627cc32d633 100644
--- a/net/sched/cls_rsvp6.c
+++ b/net/sched/cls_rsvp6.c
@@ -15,10 +15,12 @@
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
 #include <net/netlink.h>
+#include <net/tc_wrapper.h>
 
 #define RSVP_DST_LEN	4
 #define RSVP_ID		"rsvp6"
 #define RSVP_OPS	cls_rsvp6_ops
+#define RSVP_CLS rsvp6_classify
 
 #include "cls_rsvp.h"
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..eb0e9458e722 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -16,6 +16,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/sch_generic.h>
+#include <net/tc_wrapper.h>
 
 /*
  * Passing parameters to the root seems to be done more awkwardly than really
@@ -98,9 +99,9 @@ static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
 	return NULL;
 }
 
-
-static int tcindex_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			    struct tcf_result *res)
+TC_INDIRECT_SCOPE int tcindex_classify(struct sk_buff *skb,
+				       const struct tcf_proto *tp,
+				       struct tcf_result *res)
 {
 	struct tcindex_data *p = rcu_dereference_bh(tp->root);
 	struct tcindex_filter_result *f;
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 34d25f7a0687..4e2e269f121f 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -39,6 +39,7 @@
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
 #include <linux/idr.h>
+#include <net/tc_wrapper.h>
 
 struct tc_u_knode {
 	struct tc_u_knode __rcu	*next;
@@ -100,8 +101,9 @@ static inline unsigned int u32_hash_fold(__be32 key,
 	return h;
 }
 
-static int u32_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			struct tcf_result *res)
+TC_INDIRECT_SCOPE int u32_classify(struct sk_buff *skb,
+				   const struct tcf_proto *tp,
+				   struct tcf_result *res)
 {
 	struct {
 		struct tc_u_knode *knode;
-- 
2.34.1

