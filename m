Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0F6B235F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390307AbfIMP3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:29:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35526 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389983AbfIMP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 11:29:03 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Sep 2019 18:28:56 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8DFSuJF018845;
        Fri, 13 Sep 2019 18:28:56 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 3/3] net: sched: use get_dev() action API in flow_action infra
Date:   Fri, 13 Sep 2019 18:28:41 +0300
Message-Id: <20190913152841.15755-4-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190913152841.15755-1-vladbu@mellanox.com>
References: <20190913152841.15755-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When filling in hardware intermediate representation tc_setup_flow_action()
directly obtains, checks and takes reference to dev used by mirred action,
instead of using act->ops->get_dev() API created specifically for this
purpose. In order to remove code duplication, refactor flow_action infra to
use action API when obtaining mirred action target dev. Extend get_dev()
with additional argument that is used to provide dev destructor to the
user.

Fixes: 5a6ff4b13d59 ("net: sched: take reference to action dev before calling offloads")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h  |  4 ++--
 net/sched/act_mirred.c | 21 +++++++++++++--------
 net/sched/cls_api.c    | 13 +++----------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 4be8b0daedf0..b18c699681ca 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -101,8 +101,8 @@ struct tc_action_ops {
 			struct netlink_ext_ack *);
 	void	(*stats_update)(struct tc_action *, u64, u32, u64, bool);
 	size_t  (*get_fill_size)(const struct tc_action *act);
-	struct net_device *(*get_dev)(const struct tc_action *a);
-	void	(*put_dev)(struct net_device *dev);
+	struct net_device *(*get_dev)(const struct tc_action *a,
+				      tc_action_priv_destructor *destructor);
 	struct psample_group *
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 9d1bf508075a..9ce073a05414 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -408,25 +408,31 @@ static struct notifier_block mirred_device_notifier = {
 	.notifier_call = mirred_device_event,
 };
 
-static struct net_device *tcf_mirred_get_dev(const struct tc_action *a)
+static void tcf_mirred_dev_put(void *priv)
+{
+	struct net_device *dev = priv;
+
+	dev_put(dev);
+}
+
+static struct net_device *
+tcf_mirred_get_dev(const struct tc_action *a,
+		   tc_action_priv_destructor *destructor)
 {
 	struct tcf_mirred *m = to_mirred(a);
 	struct net_device *dev;
 
 	rcu_read_lock();
 	dev = rcu_dereference(m->tcfm_dev);
-	if (dev)
+	if (dev) {
 		dev_hold(dev);
+		*destructor = tcf_mirred_dev_put;
+	}
 	rcu_read_unlock();
 
 	return dev;
 }
 
-static void tcf_mirred_put_dev(struct net_device *dev)
-{
-	dev_put(dev);
-}
-
 static size_t tcf_mirred_get_fill_size(const struct tc_action *act)
 {
 	return nla_total_size(sizeof(struct tc_mirred));
@@ -446,7 +452,6 @@ static struct tc_action_ops act_mirred_ops = {
 	.get_fill_size	=	tcf_mirred_get_fill_size,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
-	.put_dev	=	tcf_mirred_put_dev,
 };
 
 static __net_init int mirred_init_net(struct net *net)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 60d44b14750a..32577c248968 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3288,22 +3288,15 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 }
 EXPORT_SYMBOL(tc_cleanup_flow_action);
 
-static void tcf_mirred_put_dev(void *priv)
-{
-	struct net_device *dev = priv;
-
-	dev_put(dev);
-}
-
 static void tcf_mirred_get_dev(struct flow_action_entry *entry,
 			       const struct tc_action *act)
 {
-	entry->dev = tcf_mirred_dev(act);
+#ifdef CONFIG_NET_CLS_ACT
+	entry->dev = act->ops->get_dev(act, &entry->destructor);
 	if (!entry->dev)
 		return;
-	dev_hold(entry->dev);
-	entry->destructor = tcf_mirred_put_dev;
 	entry->destructor_priv = entry->dev;
+#endif
 }
 
 static void tcf_tunnel_encap_put_tunnel(void *priv)
-- 
2.21.0

