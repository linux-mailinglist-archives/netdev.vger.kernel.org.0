Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93C11D4CD5
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgEOLlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 07:41:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55279 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726242AbgEOLlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 07:41:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 15 May 2020 14:40:52 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04FBeq2e027497;
        Fri, 15 May 2020 14:40:52 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        kuba@kernel.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 2/4] net: sched: implement terse dump support in act
Date:   Fri, 15 May 2020 14:40:12 +0300
Message-Id: <20200515114014.3135-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200515114014.3135-1-vladbu@mellanox.com>
References: <20200515114014.3135-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend tcf_action_dump() with boolean argument 'terse' that is used to
request terse-mode action dump. In terse mode only essential data needed to
identify particular action (action kind, cookie, etc.) and its stats is put
to resulting skb and everything else is omitted. Implement
tcf_exts_terse_dump() helper in cls API that is intended to be used to
request terse dump of all exts (actions) attached to the filter.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V1 -> V2:
    
    - Remove redundant newline after tcf_exts_terse_dump() function.

 include/net/act_api.h |  2 +-
 include/net/pkt_cls.h |  1 +
 net/sched/act_api.c   | 30 +++++++++++++++++++++++-------
 net/sched/cls_api.c   | 28 +++++++++++++++++++++++++++-
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c24d7643548e..1b4bfc4437be 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -193,7 +193,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
-		    int ref);
+		    int ref, bool terse);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
 int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
 
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 04aa0649f3b0..ed65619cbc47 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -325,6 +325,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
 void tcf_exts_destroy(struct tcf_exts *exts);
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src);
 int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts);
+int tcf_exts_terse_dump(struct sk_buff *skb, struct tcf_exts *exts);
 int tcf_exts_dump_stats(struct sk_buff *skb, struct tcf_exts *exts);
 
 /**
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index fbbec2e562f5..8ac7eb0a8309 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -766,12 +766,10 @@ tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	return a->ops->dump(skb, a, bind, ref);
 }
 
-int
-tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
+static int
+tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a)
 {
-	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
-	struct nlattr *nest;
 	struct tc_cookie *cookie;
 
 	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
@@ -789,6 +787,23 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+int
+tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
+{
+	int err = -EINVAL;
+	unsigned char *b = skb_tail_pointer(skb);
+	struct nlattr *nest;
+
+	if (tcf_action_dump_terse(skb, a))
+		goto nla_put_failure;
+
 	if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
 	    nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
 			       a->hw_stats, TCA_ACT_HW_STATS_ANY))
@@ -820,7 +835,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 EXPORT_SYMBOL(tcf_action_dump_1);
 
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
-		    int bind, int ref)
+		    int bind, int ref, bool terse)
 {
 	struct tc_action *a;
 	int err = -EINVAL, i;
@@ -831,7 +846,8 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
 		nest = nla_nest_start_noflag(skb, i + 1);
 		if (nest == NULL)
 			goto nla_put_failure;
-		err = tcf_action_dump_1(skb, a, bind, ref);
+		err = terse ? tcf_action_dump_terse(skb, a) :
+			tcf_action_dump_1(skb, a, bind, ref);
 		if (err < 0)
 			goto errout;
 		nla_nest_end(skb, nest);
@@ -1133,7 +1149,7 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	if (!nest)
 		goto out_nlmsg_trim;
 
-	if (tcf_action_dump(skb, actions, bind, ref) < 0)
+	if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
 		goto out_nlmsg_trim;
 
 	nla_nest_end(skb, nest);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index cb2c10e0fee5..752d608f4442 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3179,7 +3179,8 @@ int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts)
 			if (nest == NULL)
 				goto nla_put_failure;
 
-			if (tcf_action_dump(skb, exts->actions, 0, 0) < 0)
+			if (tcf_action_dump(skb, exts->actions, 0, 0, false)
+			    < 0)
 				goto nla_put_failure;
 			nla_nest_end(skb, nest);
 		} else if (exts->police) {
@@ -3203,6 +3204,31 @@ int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_dump);
 
+int tcf_exts_terse_dump(struct sk_buff *skb, struct tcf_exts *exts)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	struct nlattr *nest;
+
+	if (!exts->action || !tcf_exts_has_actions(exts))
+		return 0;
+
+	nest = nla_nest_start_noflag(skb, exts->action);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (tcf_action_dump(skb, exts->actions, 0, 0, true) < 0)
+		goto nla_put_failure;
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+#else
+	return 0;
+#endif
+}
+EXPORT_SYMBOL(tcf_exts_terse_dump);
 
 int tcf_exts_dump_stats(struct sk_buff *skb, struct tcf_exts *exts)
 {
-- 
2.21.0

