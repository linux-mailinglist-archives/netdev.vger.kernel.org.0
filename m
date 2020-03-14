Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD5185A42
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 06:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCOFXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 01:23:49 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41332 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727877AbgCOFXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 01:23:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jD15T-00010Z-J1; Sat, 14 Mar 2020 08:19:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>,
        syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH net] geneve: move debug check after netdev unregister
Date:   Sat, 14 Mar 2020 08:18:42 +0100
Message-Id: <20200314071842.17832-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <0000000000000ea4b4059fb33201@google.com>
References: <0000000000000ea4b4059fb33201@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debug check must be done after unregister_netdevice_many() call --
the list_del() for this is done inside .ndo_stop.

Fixes: 2843a25348f8 ("geneve: speedup geneve tunnels dismantle")
Reported-and-tested-by: <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>
Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/geneve.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 75757e9954ba..09f279c0182b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1845,8 +1845,6 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
 		if (!net_eq(dev_net(geneve->dev), net))
 			unregister_netdevice_queue(geneve->dev, head);
 	}
-
-	WARN_ON_ONCE(!list_empty(&gn->sock_list));
 }
 
 static void __net_exit geneve_exit_batch_net(struct list_head *net_list)
@@ -1861,6 +1859,12 @@ static void __net_exit geneve_exit_batch_net(struct list_head *net_list)
 	/* unregister the devices gathered above */
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
+
+	list_for_each_entry(net, net_list, exit_list) {
+		const struct geneve_net *gn = net_generic(net, geneve_net_id);
+
+		WARN_ON_ONCE(!list_empty(&gn->sock_list));
+	}
 }
 
 static struct pernet_operations geneve_net_ops = {
-- 
2.24.1

