Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310A62D50C7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgLJCRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgLJCQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 21:16:55 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] rtnetlink: RCU-annotate both dimensions of rtnl_msg_handlers
Date:   Wed,  9 Dec 2020 18:16:08 -0800
Message-Id: <20201210021608.1105566-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use rcu_assign_pointer to assign both the table and the entries,
but the entries are not marked as __rcu. This generates sparse
warnings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 60917ff4a00b..bb0596c41b3e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -139,7 +139,7 @@ bool lockdep_rtnl_is_held(void)
 EXPORT_SYMBOL(lockdep_rtnl_is_held);
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 
-static struct rtnl_link *__rcu *rtnl_msg_handlers[RTNL_FAMILY_MAX + 1];
+static struct rtnl_link __rcu *__rcu *rtnl_msg_handlers[RTNL_FAMILY_MAX + 1];
 
 static inline int rtm_msgindex(int msgtype)
 {
@@ -157,7 +157,7 @@ static inline int rtm_msgindex(int msgtype)
 
 static struct rtnl_link *rtnl_get_link(int protocol, int msgtype)
 {
-	struct rtnl_link **tab;
+	struct rtnl_link __rcu **tab;
 
 	if (protocol >= ARRAY_SIZE(rtnl_msg_handlers))
 		protocol = PF_UNSPEC;
@@ -166,7 +166,7 @@ static struct rtnl_link *rtnl_get_link(int protocol, int msgtype)
 	if (!tab)
 		tab = rcu_dereference_rtnl(rtnl_msg_handlers[PF_UNSPEC]);
 
-	return tab[msgtype];
+	return rcu_dereference_rtnl(tab[msgtype]);
 }
 
 static int rtnl_register_internal(struct module *owner,
@@ -183,7 +183,7 @@ static int rtnl_register_internal(struct module *owner,
 	msgindex = rtm_msgindex(msgtype);
 
 	rtnl_lock();
-	tab = rtnl_msg_handlers[protocol];
+	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
 	if (tab == NULL) {
 		tab = kcalloc(RTM_NR_MSGTYPES, sizeof(void *), GFP_KERNEL);
 		if (!tab)
@@ -286,7 +286,8 @@ void rtnl_register(int protocol, int msgtype,
  */
 int rtnl_unregister(int protocol, int msgtype)
 {
-	struct rtnl_link **tab, *link;
+	struct rtnl_link __rcu **tab;
+	struct rtnl_link *link;
 	int msgindex;
 
 	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
@@ -299,7 +300,7 @@ int rtnl_unregister(int protocol, int msgtype)
 		return -ENOENT;
 	}
 
-	link = tab[msgindex];
+	link = rtnl_dereference(tab[msgindex]);
 	rcu_assign_pointer(tab[msgindex], NULL);
 	rtnl_unlock();
 
@@ -318,20 +319,21 @@ EXPORT_SYMBOL_GPL(rtnl_unregister);
  */
 void rtnl_unregister_all(int protocol)
 {
-	struct rtnl_link **tab, *link;
+	struct rtnl_link __rcu **tab;
+	struct rtnl_link *link;
 	int msgindex;
 
 	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
 
 	rtnl_lock();
-	tab = rtnl_msg_handlers[protocol];
+	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
 	if (!tab) {
 		rtnl_unlock();
 		return;
 	}
 	RCU_INIT_POINTER(rtnl_msg_handlers[protocol], NULL);
 	for (msgindex = 0; msgindex < RTM_NR_MSGTYPES; msgindex++) {
-		link = tab[msgindex];
+		link = rtnl_dereference(tab[msgindex]);
 		if (!link)
 			continue;
 
@@ -3754,7 +3756,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 		s_idx = 1;
 
 	for (idx = 1; idx <= RTNL_FAMILY_MAX; idx++) {
-		struct rtnl_link **tab;
+		struct rtnl_link __rcu **tab;
 		struct rtnl_link *link;
 		rtnl_dumpit_func dumpit;
 
@@ -3768,7 +3770,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!tab)
 			continue;
 
-		link = tab[type];
+		link = rcu_dereference_rtnl(tab[type]);
 		if (!link)
 			continue;
 
-- 
2.26.2

