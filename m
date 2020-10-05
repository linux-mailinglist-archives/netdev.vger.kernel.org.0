Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25BD2830C0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 09:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJEHQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 03:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgJEHQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 03:16:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC5FC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 00:16:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t14so5416283pgl.10
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 00:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zMRkSrhSzgEABYu+gvHkrLf9ryTfEsMiBWXi614gWOk=;
        b=GWpF9vB6UjD8VKuoTaOq9gZf4RYzvhP9hZ1NPrK/M5P2Inxz8ifqVj3QN7rcofzKBz
         oSLMKQB1/g2KjdZqTtIIiqhBQmLp+ECJElISgetQUKG0omj7ixHAULSMA9hY/ZOUZ1CY
         EAlw3S/rzrjx8tizz50piI3An0KHshwGH/bJfogOZ1odIJoqKPYEvkRvR3TKtwMg+ZhA
         YsVqnWmmgpzb0TScTK4t4SLWZCRohddHX5UKj1n2bzswgaxqU0cM8rknArtu515AoM5d
         o33GOWdOtYCdKpvZSF84kFcDQT05xiZk5/Hhochd3oRRqR8Jb/YLH6dN2uydAmOjWcH7
         1UAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zMRkSrhSzgEABYu+gvHkrLf9ryTfEsMiBWXi614gWOk=;
        b=MCamVX+qglXn1sIWlPtR9vA2y70x7KVEMlNbNqA6QeEPAj2ZiP0XVbYohttE159u4G
         ZhN8FfMKpelefpeNv7yrhfbU55TCa2csTvk27lbPMKYGgLy1Uh89cO0vJ1FJDZQCVgZt
         SUI8wD5lZnYchQ3J9o8xZs1fyJwaOnSxNh0gsWi3yznkFWCqeOcO34q79oA9F4zYXgzL
         cQQfcKwGOT8SmsyS9RmbvePJC9g6LeU2DiDXlMJJjisAIuCJvsgklLkSfk8fYzPM0HK2
         q3Hjo+J5xZshDE5vWxwHoAxeDdBDRMajA3lO0rR82zDcwElkRQiHjNTxsRKoSLZ3Ogcf
         +anA==
X-Gm-Message-State: AOAM531JpLNgrx70BSmykU9ngMeX/HYybTLMAy+AwXIbJ/++44sx95Ut
        Hsojrtc1cDkDKrK0iobJcKAz
X-Google-Smtp-Source: ABdhPJxL0Ytg7U0s8xd4ChdvlwFALokXgr05eRcF2bNNMOlxH78kBpyLhwNlTPAmxtuNNZ3TXH0llQ==
X-Received: by 2002:a63:4945:: with SMTP id y5mr13123680pgk.181.1601882211024;
        Mon, 05 Oct 2020 00:16:51 -0700 (PDT)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id v10sm9606869pjf.34.2020.10.05.00.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 00:16:50 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        elder@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
Date:   Mon,  5 Oct 2020 12:46:42 +0530
Message-Id: <20201005071642.9621-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
fix it by excluding the locking for kernel_sendmsg().

While at it, let's also use radix_tree_deref_retry() to confirm the
validity of the pointer returned by radix_tree_deref_slot() and use
radix_tree_iter_resume() to resume iterating the tree properly before
releasing the lock as suggested by Doug.

Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
Reported-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Changes in v3:

* Collected reviews from Doug and addressed couple of nitpicks

Changes in v2:

* Used radix_tree_deref_retry() and radix_tree_iter_resume() as
suggested by Doug.

 net/qrtr/ns.c | 76 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 12 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 934999b56d60..b8559c882431 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -193,7 +193,7 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 	struct qrtr_server *srv;
 	struct qrtr_node *node;
 	void __rcu **slot;
-	int ret = 0;
+	int ret;
 
 	node = node_get(qrtr_ns.local_node);
 	if (!node)
@@ -203,18 +203,27 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 	/* Announce the list of servers registered in this node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		if (!srv)
+			continue;
+		if (radix_tree_deref_retry(srv)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+		slot = radix_tree_iter_resume(slot, &iter);
+		rcu_read_unlock();
 
 		ret = service_announce_new(sq, srv);
 		if (ret < 0) {
 			pr_err("failed to announce new service\n");
-			goto err_out;
+			return ret;
 		}
+
+		rcu_read_lock();
 	}
 
-err_out:
 	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static struct qrtr_server *server_add(unsigned int service,
@@ -339,7 +348,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	struct qrtr_node *node;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret = 0;
+	int ret;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -352,7 +361,16 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	/* Advertise removal of this client to all servers of remote node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		if (!srv)
+			continue;
+		if (radix_tree_deref_retry(srv)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+		slot = radix_tree_iter_resume(slot, &iter);
+		rcu_read_unlock();
 		server_del(node, srv->port);
+		rcu_read_lock();
 	}
 	rcu_read_unlock();
 
@@ -368,6 +386,14 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		if (!srv)
+			continue;
+		if (radix_tree_deref_retry(srv)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+		slot = radix_tree_iter_resume(slot, &iter);
+		rcu_read_unlock();
 
 		sq.sq_family = AF_QIPCRTR;
 		sq.sq_node = srv->node;
@@ -379,14 +405,14 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send bye cmd\n");
-			goto err_out;
+			return ret;
 		}
+		rcu_read_lock();
 	}
 
-err_out:
 	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
@@ -404,7 +430,7 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	struct list_head *li;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret = 0;
+	int ret;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -447,6 +473,14 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		if (!srv)
+			continue;
+		if (radix_tree_deref_retry(srv)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+		slot = radix_tree_iter_resume(slot, &iter);
+		rcu_read_unlock();
 
 		sq.sq_family = AF_QIPCRTR;
 		sq.sq_node = srv->node;
@@ -458,14 +492,14 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send del client cmd\n");
-			goto err_out;
+			return ret;
 		}
+		rcu_read_lock();
 	}
 
-err_out:
 	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
@@ -571,16 +605,34 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
 	rcu_read_lock();
 	radix_tree_for_each_slot(node_slot, &nodes, &node_iter, 0) {
 		node = radix_tree_deref_slot(node_slot);
+		if (!node)
+			continue;
+		if (radix_tree_deref_retry(node)) {
+			node_slot = radix_tree_iter_retry(&node_iter);
+			continue;
+		}
+		node_slot = radix_tree_iter_resume(node_slot, &node_iter);
 
 		radix_tree_for_each_slot(srv_slot, &node->servers,
 					 &srv_iter, 0) {
 			struct qrtr_server *srv;
 
 			srv = radix_tree_deref_slot(srv_slot);
+			if (!srv)
+				continue;
+			if (radix_tree_deref_retry(srv)) {
+				srv_slot = radix_tree_iter_retry(&srv_iter);
+				continue;
+			}
+
 			if (!server_match(srv, &filter))
 				continue;
 
+			srv_slot = radix_tree_iter_resume(srv_slot, &srv_iter);
+
+			rcu_read_unlock();
 			lookup_notify(from, srv, true);
+			rcu_read_lock();
 		}
 	}
 	rcu_read_unlock();
-- 
2.17.1

