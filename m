Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E05812BDEE
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 16:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfL1PhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 10:37:14 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726080AbfL1PhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 10:37:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577547431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=esqrg2+SrDkCed2GrHUpTDXcQ/FBa2asjQ4zWlXoAYg=;
        b=KOV80LH+I5XbNtAbxblC6OLMvey2x0x6SWLC68SP0ExA/SGYBnWnh1lfXEyCJLvO1Zfn+o
        uSLJu8J6hibH5F+MWl807tlIUd2s8aIRAz/Z3Vp3JpjJJPRz64HtLpZNcQod99aViKMkKL
        wDNwAJvbH5kVjL04/vh8dZ66NU0fIq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-Z-wIBFEBMBu1SBrXA-BLOA-1; Sat, 28 Dec 2019 10:37:09 -0500
X-MC-Unique: Z-wIBFEBMBu1SBrXA-BLOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8347E10054E3;
        Sat, 28 Dec 2019 15:37:08 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-204-20.brq.redhat.com [10.40.204.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D8BF60BE0;
        Sat, 28 Dec 2019 15:37:04 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net] net/sched: add delete_empty() to filters and use it in cls_flower
Date:   Sat, 28 Dec 2019 16:36:58 +0100
Message-Id: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert "net/sched: cls_u32: fix refcount leak in the error path of
u32_change()", and fix the u32 refcount leak in a more generic way that
preserves the semantic of rule dumping.
On tc filters that don't support lockless insertion/removal, there is no
need to guard against concurrent insertion when a removal is in progress.
Therefore, for most of them we can avoid a full walk() when deleting, and
just decrease the refcount, like it was done on older Linux kernels.
This fixes situations where walk() was wrongly detecting a non-empty
filter, like it happened with cls_u32 in the error path of change(), thus
leading to failures in the following tdc selftests:

 6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
 6658: (filter, u32) Add/Replace u32 with custom hash table and invalid h=
andle
 74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id

On cls_flower, and on (future) lockless filters, this check is necessary:
move all the check_empty() logic in a callback so that each filter
can have its own implementation. For cls_flower, it's sufficient to check
if no IDRs have been allocated.

This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.

Changes since v1:
 - document the need for delete_empty() when TCF_PROTO_OPS_DOIT_UNLOCKED
   is used, thanks to Vlad Buslov
 - implement delete_empty() without doing fl_walk(), thanks to Vlad Buslo=
v
 - squash revert and new fix in a single patch, to be nice with bisect
   tests that run tdc on u32 filter, thanks to Dave Miller

Fixes: 275c44aa194b ("net/sched: cls_u32: fix refcount leak in the error =
path of u32_change()")
Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp i=
s empty")
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Suggested-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/sch_generic.h |  5 +++++
 net/sched/cls_api.c       | 31 +++++--------------------------
 net/sched/cls_flower.c    | 12 ++++++++++++
 net/sched/cls_u32.c       | 25 -------------------------
 4 files changed, 22 insertions(+), 51 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 144f264ea394..fceddf89592a 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -308,6 +308,7 @@ struct tcf_proto_ops {
 	int			(*delete)(struct tcf_proto *tp, void *arg,
 					  bool *last, bool rtnl_held,
 					  struct netlink_ext_ack *);
+	bool			(*delete_empty)(struct tcf_proto *tp);
 	void			(*walk)(struct tcf_proto *tp,
 					struct tcf_walker *arg, bool rtnl_held);
 	int			(*reoffload)(struct tcf_proto *tp, bool add,
@@ -336,6 +337,10 @@ struct tcf_proto_ops {
 	int			flags;
 };
=20
+/* Classifiers setting TCF_PROTO_OPS_DOIT_UNLOCKED in tcf_proto_ops->fla=
gs
+ * are expected to implement tcf_proto_ops->delete_empty(), otherwise ra=
ce
+ * conditions can occur when filters are inserted/deleted simultaneously=
.
+ */
 enum tcf_proto_ops_flags {
 	TCF_PROTO_OPS_DOIT_UNLOCKED =3D 1,
 };
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6a0eacafdb19..76e0d122616a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -308,33 +308,12 @@ static void tcf_proto_put(struct tcf_proto *tp, boo=
l rtnl_held,
 		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
=20
-static int walker_check_empty(struct tcf_proto *tp, void *fh,
-			      struct tcf_walker *arg)
+static bool tcf_proto_check_delete(struct tcf_proto *tp)
 {
-	if (fh) {
-		arg->nonempty =3D true;
-		return -1;
-	}
-	return 0;
-}
-
-static bool tcf_proto_is_empty(struct tcf_proto *tp, bool rtnl_held)
-{
-	struct tcf_walker walker =3D { .fn =3D walker_check_empty, };
-
-	if (tp->ops->walk) {
-		tp->ops->walk(tp, &walker, rtnl_held);
-		return !walker.nonempty;
-	}
-	return true;
-}
+	if (tp->ops->delete_empty)
+		return tp->ops->delete_empty(tp);
=20
-static bool tcf_proto_check_delete(struct tcf_proto *tp, bool rtnl_held)
-{
-	spin_lock(&tp->lock);
-	if (tcf_proto_is_empty(tp, rtnl_held))
-		tp->deleting =3D true;
-	spin_unlock(&tp->lock);
+	tp->deleting =3D true;
 	return tp->deleting;
 }
=20
@@ -1751,7 +1730,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_ch=
ain *chain,
 	 * concurrently.
 	 * Mark tp for deletion if it is empty.
 	 */
-	if (!tp_iter || !tcf_proto_check_delete(tp, rtnl_held)) {
+	if (!tp_iter || !tcf_proto_check_delete(tp)) {
 		mutex_unlock(&chain->filter_chain_lock);
 		return;
 	}
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0d125de54285..b0f42e62dd76 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2773,6 +2773,17 @@ static void fl_bind_class(void *fh, u32 classid, u=
nsigned long cl)
 		f->res.class =3D cl;
 }
=20
+static bool fl_delete_empty(struct tcf_proto *tp)
+{
+	struct cls_fl_head *head =3D fl_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	tp->deleting =3D idr_is_empty(&head->handle_idr);
+	spin_unlock(&tp->lock);
+
+	return tp->deleting;
+}
+
 static struct tcf_proto_ops cls_fl_ops __read_mostly =3D {
 	.kind		=3D "flower",
 	.classify	=3D fl_classify,
@@ -2782,6 +2793,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostl=
y =3D {
 	.put		=3D fl_put,
 	.change		=3D fl_change,
 	.delete		=3D fl_delete,
+	.delete_empty	=3D fl_delete_empty,
 	.walk		=3D fl_walk,
 	.reoffload	=3D fl_reoffload,
 	.hw_add		=3D fl_hw_add,
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 66c6bcec16cb..a0e6fac613de 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1108,33 +1108,10 @@ static int u32_change(struct net *net, struct sk_=
buff *in_skb,
 	return err;
 }
=20
-static bool u32_hnode_empty(struct tc_u_hnode *ht, bool *non_root_ht)
-{
-	int i;
-
-	if (!ht)
-		return true;
-	if (!ht->is_root) {
-		*non_root_ht =3D true;
-		return false;
-	}
-	if (*non_root_ht)
-		return false;
-	if (ht->refcnt < 2)
-		return true;
-
-	for (i =3D 0; i <=3D ht->divisor; i++) {
-		if (rtnl_dereference(ht->ht[i]))
-			return false;
-	}
-	return true;
-}
-
 static void u32_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		     bool rtnl_held)
 {
 	struct tc_u_common *tp_c =3D tp->data;
-	bool non_root_ht =3D false;
 	struct tc_u_hnode *ht;
 	struct tc_u_knode *n;
 	unsigned int h;
@@ -1147,8 +1124,6 @@ static void u32_walk(struct tcf_proto *tp, struct t=
cf_walker *arg,
 	     ht =3D rtnl_dereference(ht->next)) {
 		if (ht->prio !=3D tp->prio)
 			continue;
-		if (u32_hnode_empty(ht, &non_root_ht))
-			return;
 		if (arg->count >=3D arg->skip) {
 			if (arg->fn(tp, ht, arg) < 0) {
 				arg->stop =3D 1;
--=20
2.24.1

