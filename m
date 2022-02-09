Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3644AF2F3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiBINgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiBINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0FB5C0612BE;
        Wed,  9 Feb 2022 05:36:25 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2D999601CD;
        Wed,  9 Feb 2022 14:36:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/14] netfilter: conntrack: make all extensions 8-byte alignned
Date:   Wed,  9 Feb 2022 14:36:05 +0100
Message-Id: <20220209133616.165104-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

All extensions except one need 8 byte alignment, so just make that the
default.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_extend.h | 5 +----
 net/netfilter/nf_conntrack_acct.c           | 1 -
 net/netfilter/nf_conntrack_ecache.c         | 1 -
 net/netfilter/nf_conntrack_extend.c         | 2 +-
 net/netfilter/nf_conntrack_helper.c         | 1 -
 net/netfilter/nf_conntrack_labels.c         | 1 -
 net/netfilter/nf_conntrack_seqadj.c         | 1 -
 net/netfilter/nf_conntrack_timeout.c        | 1 -
 net/netfilter/nf_conntrack_timestamp.c      | 1 -
 net/netfilter/nf_nat_core.c                 | 1 -
 net/netfilter/nf_synproxy_core.c            | 1 -
 net/sched/act_ct.c                          | 1 -
 12 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index c7515d82ab06..705a4487f023 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -49,7 +49,7 @@ enum nf_ct_ext_id {
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	char data[];
+	char data[] __aligned(8);
 };
 
 static inline bool __nf_ct_ext_exist(const struct nf_ct_ext *ext, u8 id)
@@ -83,10 +83,7 @@ struct nf_ct_ext_type {
 	void (*destroy)(struct nf_conn *ct);
 
 	enum nf_ct_ext_id id;
-
-	/* Length and min alignment. */
 	u8 len;
-	u8 align;
 };
 
 int nf_ct_extend_register(const struct nf_ct_ext_type *type);
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 91bc8df3e4b0..c9b20b86711c 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -24,7 +24,6 @@ MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
 static const struct nf_ct_ext_type acct_extend = {
 	.len	= sizeof(struct nf_conn_acct),
-	.align	= __alignof__(struct nf_conn_acct),
 	.id	= NF_CT_EXT_ACCT,
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 41768ff19464..1cf2c8cd6a4a 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -306,7 +306,6 @@ static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
 static const struct nf_ct_ext_type event_extend = {
 	.len	= sizeof(struct nf_conntrack_ecache),
-	.align	= __alignof__(struct nf_conntrack_ecache),
 	.id	= NF_CT_EXT_ECACHE,
 };
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 3dbe2329c3f1..c62f477c6533 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -65,7 +65,7 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 		return NULL;
 	}
 
-	newoff = ALIGN(oldlen, t->align);
+	newoff = ALIGN(oldlen, __alignof__(struct nf_ct_ext));
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ae4488a13c70..e8f6a389bd01 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -552,7 +552,6 @@ EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
 static const struct nf_ct_ext_type helper_extend = {
 	.len	= sizeof(struct nf_conn_help),
-	.align	= __alignof__(struct nf_conn_help),
 	.id	= NF_CT_EXT_HELPER,
 };
 
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 522792556632..6323358dbe73 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -81,7 +81,6 @@ EXPORT_SYMBOL_GPL(nf_connlabels_put);
 
 static const struct nf_ct_ext_type labels_extend = {
 	.len    = sizeof(struct nf_conn_labels),
-	.align  = __alignof__(struct nf_conn_labels),
 	.id     = NF_CT_EXT_LABELS,
 };
 
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 3066449f8bd8..b13b3a8a1082 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -235,7 +235,6 @@ EXPORT_SYMBOL_GPL(nf_ct_seq_offset);
 
 static const struct nf_ct_ext_type nf_ct_seqadj_extend = {
 	.len	= sizeof(struct nf_conn_seqadj),
-	.align	= __alignof__(struct nf_conn_seqadj),
 	.id	= NF_CT_EXT_SEQADJ,
 };
 
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 14387e0b8008..816fe680375d 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -137,7 +137,6 @@ EXPORT_SYMBOL_GPL(nf_ct_destroy_timeout);
 
 static const struct nf_ct_ext_type timeout_extend = {
 	.len	= sizeof(struct nf_conn_timeout),
-	.align	= __alignof__(struct nf_conn_timeout),
 	.id	= NF_CT_EXT_TIMEOUT,
 };
 
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index f656d393fa92..81878d9786ba 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -21,7 +21,6 @@ MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
 
 static const struct nf_ct_ext_type tstamp_extend = {
 	.len	= sizeof(struct nf_conn_tstamp),
-	.align	= __alignof__(struct nf_conn_tstamp),
 	.id	= NF_CT_EXT_TSTAMP,
 };
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2d06a66899b2..d0000f63b0af 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -877,7 +877,6 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 
 static struct nf_ct_ext_type nat_extend __read_mostly = {
 	.len		= sizeof(struct nf_conn_nat),
-	.align		= __alignof__(struct nf_conn_nat),
 	.destroy	= nf_nat_cleanup_conntrack,
 	.id		= NF_CT_EXT_NAT,
 };
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 2dfc5dae0656..d5c1e93c4ba3 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -238,7 +238,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 
 static struct nf_ct_ext_type nf_ct_synproxy_extend __read_mostly = {
 	.len		= sizeof(struct nf_conn_synproxy),
-	.align		= __alignof__(struct nf_conn_synproxy),
 	.id		= NF_CT_EXT_SYNPROXY,
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247fc6468..78ccd16be05e 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -59,7 +59,6 @@ static const struct rhashtable_params zones_params = {
 
 static struct nf_ct_ext_type act_ct_extend __read_mostly = {
 	.len		= sizeof(struct nf_conn_act_ct_ext),
-	.align		= __alignof__(struct nf_conn_act_ct_ext),
 	.id		= NF_CT_EXT_ACT_CT,
 };
 
-- 
2.30.2

