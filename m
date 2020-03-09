Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C434317E746
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCISfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34181 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8951E21B0E;
        Mon,  9 Mar 2020 14:35:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=iDjMnq0wm+jbhZr/QaVKxyaAMqkq8dVCZ598dtJW4T4=; b=QY5p5qHv
        TTVWbO2YeDlU5iM5W+BYdZzLaHmqPuJqazfywF8Rbi6ZOUHhMjh/5qY7v+lh30Dq
        mDRrVRpddJj6PrvlLQI3yIEiSGxxVYvdUuRsYqFDHHc1H6dlpsXARCpg8NMZCcxo
        sWnC4jAfCEfsYKnTxLFqtSuuEjW1ZktGGnGPSC93C3cMSxZywp1kQzKUY8RFt8DC
        tKTZHJeJsWnWYkNs7jrh5zgx22N7WcCZ5Kh2U80ED6y8BQkgUotgwwiwXBXLnOwJ
        OcOuc9HdqrSwIar7v4ntg+jxIMcOV7bl+OGxqKZxhQEloktgJryHkYTAsAWQ5jDB
        J6rMyyReKSH7NA==
X-ME-Sender: <xms:hIxmXsTcUe2M5TVZTI_5sdCczQBTuEjykWY7hk-EWJkIogcolS7W2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsth
    gvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:hIxmXnbSgmL6MrV1AE0-6z6QVEda9pNLeeJ0k59_eXF8tdBiMMjEjA>
    <xmx:hIxmXhMyyqLj8JyRerFtKXrxWzj3TmMB7x35--XkDPDP4x3_gb6dDA>
    <xmx:hIxmXoMwwG5NcC1JU00J6CHsTPQjreLbVF745vfsJKUeFSDi-MWM0A>
    <xmx:hIxmXqC2juX_wBx6dBqd54XyHQTU0PxbBoylV4BvbXXC0A7jIK13nQ>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19C6230614FA;
        Mon,  9 Mar 2020 14:35:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] net: sched: Add centralized RED flag checking
Date:   Mon,  9 Mar 2020 20:34:59 +0200
Message-Id: <20200309183503.173802-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309183503.173802-1-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The qdiscs RED, GRED, SFQ and CHOKE use different subsets of the same pool
of global RED flags. Add a common function for all of these to validate
that only supported flags are passed. In later patches this function will
be extended with a check for flag compatibility / meaningfulness.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/red.h     | 12 ++++++++++++
 net/sched/sch_choke.c |  5 +++++
 net/sched/sch_gred.c  |  7 +++----
 net/sched/sch_red.c   |  5 +++++
 net/sched/sch_sfq.c   | 10 ++++++++--
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 9665582c4687..bb7bac52c365 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -179,6 +179,18 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
 	return true;
 }
 
+static inline bool red_check_flags(unsigned int flags,
+				   unsigned int supported_flags,
+				   struct netlink_ext_ack *extack)
+{
+	if (flags & ~supported_flags) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported RED flags specified");
+		return false;
+	}
+
+	return true;
+}
+
 static inline void red_set_parms(struct red_parms *p,
 				 u32 qth_min, u32 qth_max, u8 Wlog, u8 Plog,
 				 u8 Scell_log, u8 *stab, u32 max_P)
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index a36974e9c601..c0e0c9f1ace3 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -78,6 +78,8 @@ static unsigned int choke_len(const struct choke_sched_data *q)
 	return (q->tail - q->head) & q->tab_mask;
 }
 
+#define CHOKE_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP)
+
 /* Is ECN parameter configured */
 static int use_ecn(const struct choke_sched_data *q)
 {
@@ -370,6 +372,9 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
 		return -EINVAL;
 
+	if (!red_check_flags(ctl->flags, CHOKE_SUPPORTED_FLAGS, extack))
+		return -EINVAL;
+
 	if (ctl->limit > CHOKE_MAX_QUEUE)
 		return -EINVAL;
 
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 8599c6f31b05..5e1cb4b243ce 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -428,6 +428,8 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 		NL_SET_ERR_MSG_MOD(extack, "can't set per-Qdisc RED flags when per-virtual queue flags are used");
 		return -EINVAL;
 	}
+	if (!red_check_flags(sopt->flags, GRED_VQ_RED_FLAGS, extack))
+		return -EINVAL;
 
 	sch_tree_lock(sch);
 	table->DPs = sopt->DPs;
@@ -590,11 +592,8 @@ static int gred_vq_validate(struct gred_sched *table, u32 cdp,
 			NL_SET_ERR_MSG_MOD(extack, "can't change per-virtual queue RED flags when per-Qdisc flags are used");
 			return -EINVAL;
 		}
-		if (red_flags & ~GRED_VQ_RED_FLAGS) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "invalid RED flags specified");
+		if (!red_check_flags(red_flags, GRED_VQ_RED_FLAGS, extack))
 			return -EINVAL;
-		}
 	}
 
 	return 0;
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 1695421333e3..f9839d68b811 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -44,6 +44,8 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
+#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
+
 static inline int red_use_ecn(struct red_sched_data *q)
 {
 	return q->flags & TC_RED_ECN;
@@ -216,6 +218,9 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
 		return -EINVAL;
 
+	if (!red_check_flags(ctl->flags, RED_SUPPORTED_FLAGS, extack))
+		return -EINVAL;
+
 	if (ctl->limit > 0) {
 		child = fifo_create_dflt(sch, &bfifo_qdisc_ops, ctl->limit,
 					 extack);
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index c787d4d46017..28949e0ec075 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -325,6 +325,8 @@ static unsigned int sfq_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return 0;
 }
 
+#define SFQ_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP)
+
 /* Is ECN parameter configured */
 static int sfq_prob_mark(const struct sfq_sched_data *q)
 {
@@ -620,7 +622,8 @@ static void sfq_perturbation(struct timer_list *t)
 		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
 }
 
-static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
+static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
+		      struct netlink_ext_ack *extack)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	struct tc_sfq_qopt *ctl = nla_data(opt);
@@ -640,6 +643,9 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
 					ctl_v1->Wlog))
 		return -EINVAL;
+	if (ctl_v1 && !red_check_flags(ctl_v1->flags, SFQ_SUPPORTED_FLAGS,
+				       extack))
+		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
 		if (!p)
@@ -750,7 +756,7 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt,
 	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 
 	if (opt) {
-		int err = sfq_change(sch, opt);
+		int err = sfq_change(sch, opt, extack);
 		if (err)
 			return err;
 	}
-- 
2.24.1

