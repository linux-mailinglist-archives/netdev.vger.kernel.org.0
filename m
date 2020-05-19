Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E62A1D9367
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgESJft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:35:49 -0400
Received: from s2.neomailbox.net ([5.148.176.60]:16822 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgESJfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 05:35:48 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2020 05:35:48 EDT
From:   Antonio Quartulli <a@unstable.cc>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Antonio Quartulli <a@unstable.cc>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] net/sch_generic.h: use sizeof_member() and get rid of unused variable
Date:   Tue, 19 May 2020 11:13:33 +0200
Message-Id: <20200519091333.20923-1-a@unstable.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiling with -Wunused triggers the following warning:

./include/net/sch_generic.h: In function ‘qdisc_cb_private_validate’:
./include/net/sch_generic.h:464:23: warning: unused variable ‘qcb’ [-Wunused-variable]
  464 |  struct qdisc_skb_cb *qcb;
      |                       ^~~

as the qcb variable is only used to compute the sizeof one of its members.

Get rid of the warning by using the provided sizeof_member() macro
and avoid having a variable at all.

At the same time use sizeof_member() also for computing the sizeof
skb->cb, thus avoiding ‘qdisc_cb_private_validate’ to have an skb
argument at all.

Cc: Toke Høiland-Jørgensen <toke@toke.dk>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Antonio Quartulli <a@unstable.cc>

---

Affected code has been compile-tested on x86_64

 include/net/codel_qdisc.h | 2 +-
 include/net/pie.h         | 2 +-
 include/net/sch_generic.h | 9 ++++-----
 net/sched/sch_cake.c      | 2 +-
 net/sched/sch_choke.c     | 2 +-
 net/sched/sch_fq.c        | 2 +-
 net/sched/sch_netem.c     | 2 +-
 net/sched/sch_sfb.c       | 2 +-
 8 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/codel_qdisc.h b/include/net/codel_qdisc.h
index 098630f83a55..c59d17de4ef3 100644
--- a/include/net/codel_qdisc.h
+++ b/include/net/codel_qdisc.h
@@ -57,7 +57,7 @@ struct codel_skb_cb {
 
 static struct codel_skb_cb *get_codel_cb(const struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct codel_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct codel_skb_cb));
 	return (struct codel_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/include/net/pie.h b/include/net/pie.h
index 3fe2361e03b4..c15fe3032ad0 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -109,7 +109,7 @@ static inline void pie_vars_init(struct pie_vars *vars)
 
 static inline struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct pie_skb_cb));
 	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c510b03b9751..8e1f7a0d7572 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -459,12 +459,11 @@ static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
 #define tcf_proto_dereference(p, tp)					\
 	rcu_dereference_protected(p, lockdep_tcf_proto_is_locked(tp))
 
-static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
+static inline void qdisc_cb_private_validate(int sz)
 {
-	struct qdisc_skb_cb *qcb;
-
-	BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb, data) + sz);
-	BUILD_BUG_ON(sizeof(qcb->data) < sz);
+	BUILD_BUG_ON(sizeof_field(struct sk_buff, cb) <
+		     offsetof(struct qdisc_skb_cb, data) + sz);
+	BUILD_BUG_ON(sizeof_field(struct qdisc_skb_cb, data) < sz);
 }
 
 static inline int qdisc_qlen_cpu(const struct Qdisc *q)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 1496e87cd07b..2800551b7465 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -281,7 +281,7 @@ static u64 us_to_ns(u64 us)
 
 static struct cobalt_skb_cb *get_cobalt_cb(const struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct cobalt_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct cobalt_skb_cb));
 	return (struct cobalt_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index bd618b00d319..6badd324df43 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -137,7 +137,7 @@ struct choke_skb_cb {
 
 static inline struct choke_skb_cb *choke_skb_cb(const struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct choke_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct choke_skb_cb));
 	return (struct choke_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 8f06a808c59a..0c2497509a3d 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -56,7 +56,7 @@ struct fq_skb_cb {
 
 static inline struct fq_skb_cb *fq_skb_cb(struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct fq_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct fq_skb_cb));
 	return (struct fq_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 84f82771cdf5..2b930d928c5c 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -161,7 +161,7 @@ struct netem_skb_cb {
 static inline struct netem_skb_cb *netem_skb_cb(struct sk_buff *skb)
 {
 	/* we assume we can use skb next/prev/tstamp as storage for rb_node */
-	qdisc_cb_private_validate(skb, sizeof(struct netem_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct netem_skb_cb));
 	return (struct netem_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 4074c50ac3d7..ffaf145a7b05 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -91,7 +91,7 @@ struct sfb_skb_cb {
 
 static inline struct sfb_skb_cb *sfb_skb_cb(const struct sk_buff *skb)
 {
-	qdisc_cb_private_validate(skb, sizeof(struct sfb_skb_cb));
+	qdisc_cb_private_validate(sizeof(struct sfb_skb_cb));
 	return (struct sfb_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
-- 
2.26.2

