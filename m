Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FCA21C66C
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgGKV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:28:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47980 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727793AbgGKV25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:28:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 12 Jul 2020 00:28:49 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06BLSn22028048;
        Sun, 12 Jul 2020 00:28:49 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 1/4] net/sched: Add skb->hash field editing via act_skbedit
Date:   Sun, 12 Jul 2020 00:28:45 +0300
Message-Id: <20200711212848.20914-2-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200711212848.20914-1-lariel@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend act_skbedit api to allow writing into skb->hash
field.

To modify skb->hash user selects the hash algorithm
to use for the hash computation and can provide a
hash basis value to be used in the calculation.
The hash value will be calculated on the packet in the
datapath and will be set into skb->hash field.

Current implementation supports only the asymmetric l4 hash
algorithm that first checks whether the skb->hash was already
set with l4 hash value (possibly by the device driver) and uses
the existing value. If hash value wasn't set, it computes the
hash value in place using the kernel implementation of the
Jenkins hash algorithm.

Usage example:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto tcp \
action skbedit hash asym_l4 basis 5 \
action goto chain 2

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_skbedit.h        |  2 ++
 include/uapi/linux/tc_act/tc_skbedit.h |  7 +++++
 net/sched/act_skbedit.c                | 38 ++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index 00bfee70609e..44a8a4625556 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -18,6 +18,8 @@ struct tcf_skbedit_params {
 	u32 mask;
 	u16 queue_mapping;
 	u16 ptype;
+	u32 hash_alg;
+	u32 hash_basis;
 	struct rcu_head rcu;
 };
 
diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/tc_act/tc_skbedit.h
index 800e93377218..5877811b093b 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,11 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_HASH			0x40
+
+enum {
+	TCA_SKBEDIT_HASH_ALG_ASYM_L4,
+};
 
 struct tc_skbedit {
 	tc_gen;
@@ -45,6 +50,8 @@ enum {
 	TCA_SKBEDIT_PTYPE,
 	TCA_SKBEDIT_MASK,
 	TCA_SKBEDIT_FLAGS,
+	TCA_SKBEDIT_HASH,
+	TCA_SKBEDIT_HASH_BASIS,
 	__TCA_SKBEDIT_MAX
 };
 #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b125b2be4467..2cc66c798afb 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -66,6 +66,20 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 	if (params->flags & SKBEDIT_F_PTYPE)
 		skb->pkt_type = params->ptype;
+
+	if (params->flags & SKBEDIT_F_HASH) {
+		u32 hash;
+
+		hash = skb_get_hash(skb);
+		/* If a hash basis was provided, add it into
+		 * hash calculation here and re-set skb->hash
+		 * to the new result with sw_hash indication
+		 * and keeping the l4 hash indication.
+		 */
+		hash = jhash_1word(hash, params->hash_basis);
+		__skb_set_sw_hash(skb, hash, skb->l4_hash);
+	}
+
 	return action;
 
 err:
@@ -91,6 +105,8 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_HASH]		= { .len = sizeof(u32) },
+	[TCA_SKBEDIT_HASH_BASIS]	= { .len = sizeof(u32) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -107,6 +123,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u32 hash_alg, hash_basis = 0;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -156,6 +173,17 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 			flags |= SKBEDIT_F_INHERITDSFIELD;
 	}
 
+	if (tb[TCA_SKBEDIT_HASH] != NULL) {
+		hash_alg = nla_get_u32(tb[TCA_SKBEDIT_HASH]);
+		if (hash_alg > TCA_SKBEDIT_HASH_ALG_ASYM_L4)
+			return -EINVAL;
+
+		flags |= SKBEDIT_F_HASH;
+
+		if (tb[TCA_SKBEDIT_HASH_BASIS])
+			hash_basis = nla_get_u32(tb[TCA_SKBEDIT_HASH_BASIS]);
+	}
+
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
@@ -213,6 +241,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	params_new->mask = 0xffffffff;
 	if (flags & SKBEDIT_F_MASK)
 		params_new->mask = *mask;
+	if (flags & SKBEDIT_F_HASH) {
+		params_new->hash_alg = hash_alg;
+		params_new->hash_basis = hash_basis;
+	}
 
 	spin_lock_bh(&d->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -276,6 +308,12 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
+	if (params->flags & SKBEDIT_F_HASH) {
+		if (nla_put_u32(skb, TCA_SKBEDIT_HASH, params->hash_alg))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, TCA_SKBEDIT_HASH_BASIS, params->hash_basis))
+			goto nla_put_failure;
+	}
 
 	tcf_tm_dump(&t, &d->tcf_tm);
 	if (nla_put_64bit(skb, TCA_SKBEDIT_TM, sizeof(t), &t, TCA_SKBEDIT_PAD))
-- 
2.25.2

