Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E983D9567
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhG1SkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhG1SkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627497610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BhGUbLOqvYauXPaXxsNzBiQ1sZLlExxdLVjO0HjaZvY=;
        b=Zt7CSMU0IoDmY1UATy9a2ptCfbZRKxbjuBt4WA5HdVp4WEuhg0LqnxCPaS0KAmTAqlhpFo
        ezl3ZeUNcFmQZj2aWJh94NH0auU8nbatxWfMQ/3zUsDL1gVlhVTo737saVxt8tXTcTzKHZ
        TEdkDDFSW8n+poG7NoZPI5jKve5PxZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-A69sZy76NPan2qbhFuUgEw-1; Wed, 28 Jul 2021 14:40:07 -0400
X-MC-Unique: A69sZy76NPan2qbhFuUgEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D55B871805;
        Wed, 28 Jul 2021 18:40:00 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.194.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F6E660BD9;
        Wed, 28 Jul 2021 18:39:57 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Alaa Hleilel <alaa@nvidia.com>
Subject: [PATCH net-next] net/sched: store the last executed chain also for clsact egress
Date:   Wed, 28 Jul 2021 20:08:00 +0200
Message-Id: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
id' in the skb extension. However, userspace programs (like ovs) are able
to setup egress rules, and datapath gets confused in case it doesn't find
the 'chain id' for a packet that's "recirculated" by tc.
Change tcf_classify() to have the same semantic as tcf_classify_ingress()
so that a single function can be called in ingress / egress, using the tc
ingress / egress block respectively.

Suggested-by: Alaa Hleilel <alaa@nvidia.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/pkt_cls.h    | 22 +++++++--------------
 net/core/dev.c           |  5 ++---
 net/sched/cls_api.c      | 42 ++++++++++++++++------------------------
 net/sched/sch_atm.c      |  2 +-
 net/sched/sch_cake.c     |  2 +-
 net/sched/sch_cbq.c      |  2 +-
 net/sched/sch_drr.c      |  2 +-
 net/sched/sch_dsmark.c   |  2 +-
 net/sched/sch_ets.c      |  2 +-
 net/sched/sch_fq_codel.c |  2 +-
 net/sched/sch_fq_pie.c   |  2 +-
 net/sched/sch_hfsc.c     |  2 +-
 net/sched/sch_htb.c      |  2 +-
 net/sched/sch_multiq.c   |  2 +-
 net/sched/sch_prio.c     |  2 +-
 net/sched/sch_qfq.c      |  2 +-
 net/sched/sch_sfb.c      |  2 +-
 net/sched/sch_sfq.c      |  2 +-
 18 files changed, 41 insertions(+), 58 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ec7823921bd2..dc28fcb6f0a2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -76,12 +76,10 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		 struct tcf_result *res, bool compat_mode);
-int tcf_classify_ingress(struct sk_buff *skb,
-			 const struct tcf_block *ingress_block,
-			 const struct tcf_proto *tp, struct tcf_result *res,
-			 bool compat_mode);
+int tcf_classify(struct sk_buff *skb,
+		 const struct tcf_block *block,
+		 const struct tcf_proto *tp, struct tcf_result *res,
+		 bool compat_mode);
 
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
@@ -138,20 +136,14 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, flow_setup_cb_t *cb,
 {
 }
 
-static inline int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+static inline int tcf_classify(struct sk_buff *skb,
+			       const struct tcf_block *block,
+			       const struct tcf_proto *tp,
 			       struct tcf_result *res, bool compat_mode)
 {
 	return TC_ACT_UNSPEC;
 }
 
-static inline int tcf_classify_ingress(struct sk_buff *skb,
-				       const struct tcf_block *ingress_block,
-				       const struct tcf_proto *tp,
-				       struct tcf_result *res, bool compat_mode)
-{
-	return TC_ACT_UNSPEC;
-}
-
 #endif
 
 static inline unsigned long
diff --git a/net/core/dev.c b/net/core/dev.c
index fb5d12a3d52d..90d4cc223e79 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4012,7 +4012,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	qdisc_skb_cb(skb)->post_ct = false;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
+	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
@@ -5164,8 +5164,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify_ingress(skb, miniq->block, miniq->filter_list,
-				     &cl_res, false)) {
+	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 1167cd0be179..7be5b9d2aead 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1577,20 +1577,10 @@ static inline int __tcf_classify(struct sk_buff *skb,
 #endif
 }
 
-int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+int tcf_classify(struct sk_buff *skb,
+		 const struct tcf_block *block,
+		 const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode)
-{
-	u32 last_executed_chain = 0;
-
-	return __tcf_classify(skb, tp, tp, res, compat_mode,
-			      &last_executed_chain);
-}
-EXPORT_SYMBOL(tcf_classify);
-
-int tcf_classify_ingress(struct sk_buff *skb,
-			 const struct tcf_block *ingress_block,
-			 const struct tcf_proto *tp,
-			 struct tcf_result *res, bool compat_mode)
 {
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 last_executed_chain = 0;
@@ -1603,20 +1593,22 @@ int tcf_classify_ingress(struct sk_buff *skb,
 	struct tc_skb_ext *ext;
 	int ret;
 
-	ext = skb_ext_find(skb, TC_SKB_EXT);
+	if (block) {
+		ext = skb_ext_find(skb, TC_SKB_EXT);
 
-	if (ext && ext->chain) {
-		struct tcf_chain *fchain;
+		if (ext && ext->chain) {
+			struct tcf_chain *fchain;
 
-		fchain = tcf_chain_lookup_rcu(ingress_block, ext->chain);
-		if (!fchain)
-			return TC_ACT_SHOT;
+			fchain = tcf_chain_lookup_rcu(block, ext->chain);
+			if (!fchain)
+				return TC_ACT_SHOT;
 
-		/* Consume, so cloned/redirect skbs won't inherit ext */
-		skb_ext_del(skb, TC_SKB_EXT);
+			/* Consume, so cloned/redirect skbs won't inherit ext */
+			skb_ext_del(skb, TC_SKB_EXT);
 
-		tp = rcu_dereference_bh(fchain->filter_chain);
-		last_executed_chain = fchain->index;
+			tp = rcu_dereference_bh(fchain->filter_chain);
+			last_executed_chain = fchain->index;
+		}
 	}
 
 	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
@@ -1635,7 +1627,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 	return ret;
 #endif
 }
-EXPORT_SYMBOL(tcf_classify_ingress);
+EXPORT_SYMBOL(tcf_classify);
 
 struct tcf_chain_info {
 	struct tcf_proto __rcu **pprev;
@@ -3825,7 +3817,7 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 
 	fl = rcu_dereference_bh(qe->filter_chain);
 
-	switch (tcf_classify(skb, fl, &cl_res, false)) {
+	switch (tcf_classify(skb, NULL, fl, &cl_res, false)) {
 	case TC_ACT_SHOT:
 		qdisc_qstats_drop(sch);
 		__qdisc_drop(skb, to_free);
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index d0c9a57398fc..7d8518176b45 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -394,7 +394,7 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		list_for_each_entry(flow, &p->flows, list) {
 			fl = rcu_dereference_bh(flow->filter_list);
 			if (fl) {
-				result = tcf_classify(skb, fl, &res, true);
+				result = tcf_classify(skb, NULL, fl, &res, true);
 				if (result < 0)
 					continue;
 				flow = (struct atm_flow_data *)res.class;
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 951542843cab..ecc5c4d93779 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1665,7 +1665,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 		goto hash;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, filter, &res, false);
+	result = tcf_classify(skb, NULL, filter, &res, false);
 
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index b79a7e27bb31..2dabaffd39d0 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -228,7 +228,7 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		/*
 		 * Step 2+n. Apply classifier.
 		 */
-		result = tcf_classify(skb, fl, &res, true);
+		result = tcf_classify(skb, NULL, fl, &res, true);
 		if (!fl || result < 0)
 			goto fallback;
 
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index fc1e47069593..642cd179b7a7 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -317,7 +317,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index d320bcfb2da2..4c100d105269 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -242,7 +242,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	else {
 		struct tcf_result res;
 		struct tcf_proto *fl = rcu_dereference_bh(p->filter_list);
-		int result = tcf_classify(skb, fl, &res, false);
+		int result = tcf_classify(skb, NULL, fl, &res, false);
 
 		pr_debug("result %d class 0x%04x\n", result, res.classid);
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index c1e84d1eeaba..925924fab1ab 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -390,7 +390,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, fl, &res, false);
+		err = tcf_classify(skb, NULL, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bbd5f8753600..c4afdd026f51 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -91,7 +91,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_codel_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, filter, &res, false);
+	result = tcf_classify(skb, NULL, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index cac684952edc..830f3559f727 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -94,7 +94,7 @@ static unsigned int fq_pie_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_pie_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, filter, &res, false);
+	result = tcf_classify(skb, NULL, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index bf0034c66e35..b7ac30cca035 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1130,7 +1130,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	head = &q->root;
 	tcf = rcu_dereference_bh(q->root.filter_list);
-	while (tcf && (result = tcf_classify(skb, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5f7ac27a5264..81ea8332547a 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -238,7 +238,7 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	while (tcf && (result = tcf_classify(skb, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 5c27b4270b90..e282e7382117 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -36,7 +36,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	int err;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	err = tcf_classify(skb, fl, &res, false);
+	err = tcf_classify(skb, NULL, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 	switch (err) {
 	case TC_ACT_STOLEN:
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3eabb871a1d5..03fdf31ccb6a 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -39,7 +39,7 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, fl, &res, false);
+		err = tcf_classify(skb, NULL, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index b692a0de1ad5..58a9d42b52b8 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -690,7 +690,7 @@ static struct qfq_class *qfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index dde829d4b9f8..3d061a13d7ed 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -257,7 +257,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	struct tcf_result res;
 	int result;
 
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 066754a18569..f8e569f79f13 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -178,7 +178,7 @@ static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return sfq_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
-- 
2.31.1

