Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF65F2FB8F7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395090AbhASOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:09:17 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40509 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393779AbhASNJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 08:09:13 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 19 Jan 2021 14:08:15 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10JC8FR3021916;
        Tue, 19 Jan 2021 14:08:15 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/5] net: sched: Add extack to Qdisc_class_ops.delete
Date:   Tue, 19 Jan 2021 14:08:12 +0200
Message-Id: <20210119120815.463334-3-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119120815.463334-1-maximmi@mellanox.com>
References: <20210119120815.463334-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a following commit, sch_htb will start using extack in the delete
class operation to pass hardware errors in offload mode. This commit
prepares for that by adding the extack parameter to this callback and
converting usage of the existing qdiscs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/sch_generic.h | 3 ++-
 net/sched/sch_api.c       | 7 ++++---
 net/sched/sch_atm.c       | 3 ++-
 net/sched/sch_cbq.c       | 3 ++-
 net/sched/sch_drr.c       | 3 ++-
 net/sched/sch_dsmark.c    | 3 ++-
 net/sched/sch_hfsc.c      | 3 ++-
 net/sched/sch_htb.c       | 3 ++-
 net/sched/sch_qfq.c       | 3 ++-
 net/sched/sch_sfb.c       | 3 ++-
 10 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9448e8cf1ee6..2e94f2f5e895 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -210,7 +210,8 @@ struct Qdisc_class_ops {
 	int			(*change)(struct Qdisc *, u32, u32,
 					struct nlattr **, unsigned long *,
 					struct netlink_ext_ack *);
-	int			(*delete)(struct Qdisc *, unsigned long);
+	int			(*delete)(struct Qdisc *, unsigned long,
+					  struct netlink_ext_ack *);
 	void			(*walk)(struct Qdisc *, struct qdisc_walker * arg);
 
 	/* Filter manipulation */
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 51cb553e4317..433a4ec42b55 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1865,7 +1865,8 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 static int tclass_del_notify(struct net *net,
 			     const struct Qdisc_class_ops *cops,
 			     struct sk_buff *oskb, struct nlmsghdr *n,
-			     struct Qdisc *q, unsigned long cl)
+			     struct Qdisc *q, unsigned long cl,
+			     struct netlink_ext_ack *extack)
 {
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	struct sk_buff *skb;
@@ -1884,7 +1885,7 @@ static int tclass_del_notify(struct net *net,
 		return -EINVAL;
 	}
 
-	err = cops->delete(q, cl);
+	err = cops->delete(q, cl, extack);
 	if (err) {
 		kfree_skb(skb);
 		return err;
@@ -2087,7 +2088,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 				goto out;
 			break;
 		case RTM_DELTCLASS:
-			err = tclass_del_notify(net, cops, skb, n, q, cl);
+			err = tclass_del_notify(net, cops, skb, n, q, cl, extack);
 			/* Unbind the class with flilters with 0 */
 			tc_bind_tclass(q, portid, clid, 0);
 			goto out;
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 007bd2d9f1ff..d0c9a57398fc 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -320,7 +320,8 @@ static int atm_tc_change(struct Qdisc *sch, u32 classid, u32 parent,
 	return error;
 }
 
-static int atm_tc_delete(struct Qdisc *sch, unsigned long arg)
+static int atm_tc_delete(struct Qdisc *sch, unsigned long arg,
+			 struct netlink_ext_ack *extack)
 {
 	struct atm_qdisc_data *p = qdisc_priv(sch);
 	struct atm_flow_data *flow = (struct atm_flow_data *)arg;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 53d45e029c36..320b3d31fa97 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1675,7 +1675,8 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	return err;
 }
 
-static int cbq_delete(struct Qdisc *sch, unsigned long arg)
+static int cbq_delete(struct Qdisc *sch, unsigned long arg,
+		      struct netlink_ext_ack *extack)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	struct cbq_class *cl = (struct cbq_class *)arg;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index dde564670ad8..fc1e47069593 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -146,7 +146,8 @@ static void drr_destroy_class(struct Qdisc *sch, struct drr_class *cl)
 	kfree(cl);
 }
 
-static int drr_delete_class(struct Qdisc *sch, unsigned long arg)
+static int drr_delete_class(struct Qdisc *sch, unsigned long arg,
+			    struct netlink_ext_ack *extack)
 {
 	struct drr_sched *q = qdisc_priv(sch);
 	struct drr_class *cl = (struct drr_class *)arg;
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 2b88710994d7..cd2748e2d4a2 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -150,7 +150,8 @@ static int dsmark_change(struct Qdisc *sch, u32 classid, u32 parent,
 	return err;
 }
 
-static int dsmark_delete(struct Qdisc *sch, unsigned long arg)
+static int dsmark_delete(struct Qdisc *sch, unsigned long arg,
+			 struct netlink_ext_ack *extack)
 {
 	struct dsmark_qdisc_data *p = qdisc_priv(sch);
 
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d1902fca9844..bf0034c66e35 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1090,7 +1090,8 @@ hfsc_destroy_class(struct Qdisc *sch, struct hfsc_class *cl)
 }
 
 static int
-hfsc_delete_class(struct Qdisc *sch, unsigned long arg)
+hfsc_delete_class(struct Qdisc *sch, unsigned long arg,
+		  struct netlink_ext_ack *extack)
 {
 	struct hfsc_sched *q = qdisc_priv(sch);
 	struct hfsc_class *cl = (struct hfsc_class *)arg;
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cd70dbcbd72f..a8fc97b05bd8 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1246,7 +1246,8 @@ static void htb_destroy(struct Qdisc *sch)
 	__qdisc_reset_queue(&q->direct_queue);
 }
 
-static int htb_delete(struct Qdisc *sch, unsigned long arg)
+static int htb_delete(struct Qdisc *sch, unsigned long arg,
+		      struct netlink_ext_ack *extack)
 {
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl = (struct htb_class *)arg;
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 6335230a971e..1db9d4a2ef5e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -529,7 +529,8 @@ static void qfq_destroy_class(struct Qdisc *sch, struct qfq_class *cl)
 	kfree(cl);
 }
 
-static int qfq_delete_class(struct Qdisc *sch, unsigned long arg)
+static int qfq_delete_class(struct Qdisc *sch, unsigned long arg,
+			    struct netlink_ext_ack *extack)
 {
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl = (struct qfq_class *)arg;
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index da047a37a3bf..dde829d4b9f8 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -649,7 +649,8 @@ static int sfb_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	return -ENOSYS;
 }
 
-static int sfb_delete(struct Qdisc *sch, unsigned long cl)
+static int sfb_delete(struct Qdisc *sch, unsigned long cl,
+		      struct netlink_ext_ack *extack)
 {
 	return -ENOSYS;
 }
-- 
2.25.1

