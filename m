Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29243129FB9
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfLXJbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:31:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726375AbfLXJbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:31:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577179891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2OgPlUbtt0EhHovyMc8ZzmMFcwPBZMfABCBpzcnS6w=;
        b=Y/QCFO3ItgarHOGfadg9jiSYyB6p32EqmrkVk3Pzj1V9YvQW0R5jibN7Zg9DGONQab79Jh
        qqj/fC6kr2KjAq04LG0d8EDHh5OogkfKUfLwdbWEkipwfKe0nQu2W1tLmZ/oe7Ai8uB2LR
        J1w9wAhSD8xZFfNoyBFY7SIFJ/kMs/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-TVHM8bXVO06ESothTwdI4Q-1; Tue, 24 Dec 2019 04:31:28 -0500
X-MC-Unique: TVHM8bXVO06ESothTwdI4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA4DF2F29;
        Tue, 24 Dec 2019 09:31:26 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB4B410018FF;
        Tue, 24 Dec 2019 09:31:25 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 2/2] net/sched: add delete_empty() to filters and use it in cls_flower
Date:   Tue, 24 Dec 2019 10:30:53 +0100
Message-Id: <a59aea617b35657ea22faaafb54a18a4645b3b36.1577179314.git.dcaratti@redhat.com>
In-Reply-To: <cover.1577179314.git.dcaratti@redhat.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

on tc filters that don't support lockless insertion/removal, there is no
need to guard against concurrent insertion when a removal is in progress.
Therefore, we can avoid taking the filter lock and doing a full walk()
when deleting: it's sufficient to decrease the refcount.
This fixes situations where walk() was wrongly detecting a non-empty
filter on deletion, like it happened with cls_u32 in the error path of
change(), thus leading to failures in the following tdc selftests:

 6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
 6658: (filter, u32) Add/Replace u32 with custom hash table and invalid h=
andle
 74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id

On cls_flower, and on (future) lockless filters, this check is necessary:
move all the check_empty() logic in a callback so that each filter
can have its own implementation.

Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp i=
s empty")
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Suggested-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/sch_generic.h |  2 ++
 net/sched/cls_api.c       | 29 ++++-------------------------
 net/sched/cls_flower.c    | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 144f264ea394..5e294da0967e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -308,6 +308,8 @@ struct tcf_proto_ops {
 	int			(*delete)(struct tcf_proto *tp, void *arg,
 					  bool *last, bool rtnl_held,
 					  struct netlink_ext_ack *);
+	bool			(*delete_empty)(struct tcf_proto *tp,
+						bool rtnl_held);
 	void			(*walk)(struct tcf_proto *tp,
 					struct tcf_walker *arg, bool rtnl_held);
 	int			(*reoffload)(struct tcf_proto *tp, bool add,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6a0eacafdb19..7900db8d4c06 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -308,33 +308,12 @@ static void tcf_proto_put(struct tcf_proto *tp, boo=
l rtnl_held,
 		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
=20
-static int walker_check_empty(struct tcf_proto *tp, void *fh,
-			      struct tcf_walker *arg)
-{
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
-
 static bool tcf_proto_check_delete(struct tcf_proto *tp, bool rtnl_held)
 {
-	spin_lock(&tp->lock);
-	if (tcf_proto_is_empty(tp, rtnl_held))
-		tp->deleting =3D true;
-	spin_unlock(&tp->lock);
+	if (tp->ops->delete_empty)
+		return tp->ops->delete_empty(tp, rtnl_held);
+
+	tp->deleting =3D true;
 	return tp->deleting;
 }
=20
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0d125de54285..e0316d18529e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2773,6 +2773,28 @@ static void fl_bind_class(void *fh, u32 classid, u=
nsigned long cl)
 		f->res.class =3D cl;
 }
=20
+static int walker_check_empty(struct tcf_proto *tp, void *fh,
+			      struct tcf_walker *arg)
+{
+	if (fh) {
+		arg->nonempty =3D true;
+		return -1;
+	}
+	return 0;
+}
+
+static bool fl_delete_empty(struct tcf_proto *tp, bool rtnl_held)
+{
+	struct tcf_walker walker =3D { .fn =3D walker_check_empty, };
+
+	spin_lock(&tp->lock);
+	fl_walk(tp, &walker, rtnl_held);
+	tp->deleting =3D !walker.nonempty;
+	spin_unlock(&tp->lock);
+
+	return tp->deleting;
+}
+
 static struct tcf_proto_ops cls_fl_ops __read_mostly =3D {
 	.kind		=3D "flower",
 	.classify	=3D fl_classify,
@@ -2782,6 +2804,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostl=
y =3D {
 	.put		=3D fl_put,
 	.change		=3D fl_change,
 	.delete		=3D fl_delete,
+	.delete_empty	=3D fl_delete_empty,
 	.walk		=3D fl_walk,
 	.reoffload	=3D fl_reoffload,
 	.hw_add		=3D fl_hw_add,
--=20
2.24.1

