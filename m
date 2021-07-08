Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B0D3BF79E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 11:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGHJco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 05:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhGHJcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 05:32:43 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592EAC06175F;
        Thu,  8 Jul 2021 02:30:02 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1625736598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F+3S4xnK9TmTf0ZoWZseFYs+ALq/OEM1GTjw6tmkjAk=;
        b=j6onS+7DFYt1n5sXnypetUJq5castzHqm7cgZ1KX9nqLEDiAAFHVdeAztdSbMii3cHoS4M
        8rMwIaouzxrpFmHWFqfpMva0RX+419g2osXXVkpoYtA2srSR+BSQSFV89PSzEH6qCvoCYb
        3quJTGIUy17k3fDL3ZsCN2LTJPp3NHQ=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, ryazanov.s.a@gmail.com,
        johannes.berg@intel.com, avagin@gmail.com, vladimir.oltean@nxp.com,
        cong.wang@bytedance.com, roopa@cumulusnetworks.com,
        yajun.deng@linux.dev, zhudi21@huawei.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: rtnetlink: Fix rtnl_dereference may be return NULL
Date:   Thu,  8 Jul 2021 17:29:36 +0800
Message-Id: <20210708092936.20044-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value 'link' may be NULL in rtnl_unregister(), this leads to
kfree_rcu(NULL, xxx), so add this case handling. And modify the return
value to 'void' in rtnl_unregister(). there is no case using it.

Fixes: addf9b90de22 (net: rtnetlink: use rcu to free rtnl message handlers)
Fixes: 51e13685bd93 (rtnetlink: RCU-annotate both dimensions of rtnl_msg_handlers)
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/rtnetlink.h |  2 +-
 net/core/rtnetlink.c    | 18 ++++++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 384e800665f2..9d263ad9ea48 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -17,7 +17,7 @@ void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
 int rtnl_register_module(struct module *owner, int protocol, int msgtype,
 			 rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
-int rtnl_unregister(int protocol, int msgtype);
+void rtnl_unregister(int protocol, int msgtype);
 void rtnl_unregister_all(int protocol);
 
 static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..e80177c195a5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -281,10 +281,8 @@ void rtnl_register(int protocol, int msgtype,
  * rtnl_unregister - Unregister a rtnetlink message type
  * @protocol: Protocol family or PF_UNSPEC
  * @msgtype: rtnetlink message type
- *
- * Returns 0 on success or a negative error code.
  */
-int rtnl_unregister(int protocol, int msgtype)
+void rtnl_unregister(int protocol, int msgtype)
 {
 	struct rtnl_link __rcu **tab;
 	struct rtnl_link *link;
@@ -295,18 +293,18 @@ int rtnl_unregister(int protocol, int msgtype)
 
 	rtnl_lock();
 	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
-	if (!tab) {
-		rtnl_unlock();
-		return -ENOENT;
-	}
+	if (!tab)
+		goto unlock;
 
 	link = rtnl_dereference(tab[msgindex]);
-	rcu_assign_pointer(tab[msgindex], NULL);
-	rtnl_unlock();
+	if (!link)
+		goto unlock;
 
+	rcu_assign_pointer(tab[msgindex], NULL);
 	kfree_rcu(link, rcu);
 
-	return 0;
+unlock:
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(rtnl_unregister);
 
-- 
2.32.0

