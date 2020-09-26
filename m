Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29938279B0F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 18:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgIZQ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 12:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgIZQ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 12:56:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA3BC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 09:56:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c3so1022425plz.5
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 09:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SVaJEVx3uY1TIDW2WVtd8VWUc74/BP701w9CmWsP2ok=;
        b=CxiwS6oP1IEB7r6bdBr1EaoR1GNhHMPSER8WzM0pd7a/qZU1XucYgI9FiVHsnwdaGY
         9hHs3vswi2h8ER5CDxaKDT7aIXmw6dx6bVx5l/lDVwHUyX2hDcD/fkbvhOn1zeqMYvp7
         iXI7DRSHufFp2SLp03tAYIiEp/X1/GrLcgw+opDyZqE4IsF46LPY1PvANrdKpgZRQ0Rm
         mT9R7Mrh7bIjt8Y49ERHl7qrtsjoOAYDUC1eEw5bbHUKgQX0k0K+P1il+QqPB4Z6F/MG
         4Qco9Rk9WT9mOtVzPHP2jbdq10F6wPXoe/MWUDGJts3nPKdWhK9eBVsQcrBsX+/xP1At
         L3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SVaJEVx3uY1TIDW2WVtd8VWUc74/BP701w9CmWsP2ok=;
        b=mw/C75l4bj/iK13lhQHJnWTx7rTrUBXly5RBV1FS5kV4WduDACXVSd0P4/XL70Ec8i
         3wilNyt0+eejLkip8TopE7AyA04aT79kkOcKwxDKo9lJqTp7dktQCT5xqeOG1Z72PqJf
         JpceE+29lObWU1Y5P2URUuXZef1NPRd4jqQAdBLjFulaWJhiovFMi2zfErGx3NIuXZAz
         3NP/+j3lgLvWSgHByDFzaJ9h/0uEmpLkNvrSN2LyhePL7coI0msjZqN1vsktlHDDwHYU
         vWGONHhvIzgLSi1QShyO4DAc69fLemzZmq71DV7lHHUl9gNZnStjkRRc49aBLWpUoVIq
         eYfg==
X-Gm-Message-State: AOAM5321DL2Zm2WG48cRhc7obmxE71R8iYOtm17yX1pX4kGHhHlNDcgU
        eo9Fqivr/qpxvUpP1yG2S97s
X-Google-Smtp-Source: ABdhPJzNC6LFuvvQ5gUUw3Dq9W9gpSzB7SSeCXmcxmo9cmtpNJPtro32GrVENIJbYn7rZ5aLySsRQQ==
X-Received: by 2002:a17:90a:2a88:: with SMTP id j8mr1192410pjd.35.1601139395744;
        Sat, 26 Sep 2020 09:56:35 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:20d:ee7b:91b:1587:faf3:6b2b])
        by smtp.gmail.com with ESMTPSA id kf10sm2220996pjb.2.2020.09.26.09.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 09:56:34 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sboyd@kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks
Date:   Sat, 26 Sep 2020 22:26:25 +0530
Message-Id: <20200926165625.11660-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu read locks are needed to avoid potential race condition while
dereferencing radix tree from multiple threads. The issue was identified
by syzbot. Below is the crash report:

=============================
WARNING: suspicious RCU usage
5.7.0-syzkaller #0 Not tainted
-----------------------------
include/linux/radix-tree.h:176 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/u4:1/21:
 #0: ffff88821b097938 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: spin_unlock_irq include/linux/spinlock.h:403 [inline]
 #0: ffff88821b097938 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: process_one_work+0x6df/0xfd0 kernel/workqueue.c:2241
 #1: ffffc90000dd7d80 ((work_completion)(&qrtr_ns.work)){+.+.}-{0:0}, at: process_one_work+0x71e/0xfd0 kernel/workqueue.c:2243

stack backtrace:
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: qrtr_ns_handler qrtr_ns_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 radix_tree_deref_slot include/linux/radix-tree.h:176 [inline]
 ctrl_cmd_new_lookup net/qrtr/ns.c:558 [inline]
 qrtr_ns_worker+0x2aff/0x4500 net/qrtr/ns.c:674
 process_one_work+0x76e/0xfd0 kernel/workqueue.c:2268
 worker_thread+0xa7f/0x1450 kernel/workqueue.c:2414
 kthread+0x353/0x380 kernel/kthread.c:268

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reported-and-tested-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/ns.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index d8252fdab851..934999b56d60 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -193,12 +193,13 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 	struct qrtr_server *srv;
 	struct qrtr_node *node;
 	void __rcu **slot;
-	int ret;
+	int ret = 0;
 
 	node = node_get(qrtr_ns.local_node);
 	if (!node)
 		return 0;
 
+	rcu_read_lock();
 	/* Announce the list of servers registered in this node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
@@ -206,11 +207,14 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 		ret = service_announce_new(sq, srv);
 		if (ret < 0) {
 			pr_err("failed to announce new service\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static struct qrtr_server *server_add(unsigned int service,
@@ -335,7 +339,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	struct qrtr_node *node;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -344,11 +348,13 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	if (!node)
 		return 0;
 
+	rcu_read_lock();
 	/* Advertise removal of this client to all servers of remote node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 		server_del(node, srv->port);
 	}
+	rcu_read_unlock();
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -359,6 +365,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_BYE);
 	pkt.client.node = cpu_to_le32(from->sq_node);
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 
@@ -372,11 +379,14 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send bye cmd\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
@@ -394,7 +404,7 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	struct list_head *li;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -434,6 +444,7 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	pkt.client.node = cpu_to_le32(node_id);
 	pkt.client.port = cpu_to_le32(port);
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 
@@ -447,11 +458,14 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send del client cmd\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
@@ -554,6 +568,7 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
 	filter.service = service;
 	filter.instance = instance;
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(node_slot, &nodes, &node_iter, 0) {
 		node = radix_tree_deref_slot(node_slot);
 
@@ -568,6 +583,7 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
 			lookup_notify(from, srv, true);
 		}
 	}
+	rcu_read_unlock();
 
 	/* Empty notification, to indicate end of listing */
 	lookup_notify(from, NULL, true);
-- 
2.17.1

