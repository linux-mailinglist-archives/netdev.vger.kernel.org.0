Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671E32818B9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbgJBRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388444AbgJBRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:06:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468FCC0613E5
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 10:06:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i3so1176749pjz.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 10:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=WEF88UBAm1AOHbRLsfGtXCNV3fv2hbwh0i2IvA/BUgo=;
        b=XPajEMgIqFnEcvtWOo9UvcYsGLrPyjcBCR1srNCYQWPzm0eNAfYCaqarB3iTcVyrhI
         l6wrkGUVdPbJMJHkeftMmrJfjVcf+msqSj+H5IaUfVNA+Auv0QyX8gu2wVyqzeAoccbJ
         UkJJeymOlIXhV+pleQyMn8gk/3ZKYTG5JMMzDAWxyWys0teukYiYStYTiupDF74ohsIg
         p1tdu66S6X+XGw8lQNerIJj/xoVwOIorBJjGlShO1yu0e8taM5tPqrtj/SQ5EPvYUbYv
         ema5mr35RUVVzX0mFtugEadDxENy99X/vdHQqceeroknkgiG7VpezTP5Rh81e43MExZm
         SWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WEF88UBAm1AOHbRLsfGtXCNV3fv2hbwh0i2IvA/BUgo=;
        b=RaT0Wf9J0f+7fmIMCDiT1bjcMCywN8Z7m2VITnAI/kOUmm9LpM3VWlaALISnLiZYvK
         nX0rH6N55XN70amlnh8VRZ89/d7HyPpWp/bpLUtq5yYagvA8kXv1AHvY/uxvWpqtnUWC
         sqlQdXBR6EhAwykPnT03nPK4B6aAVXOVEfdniK5EwUIQIRa7qPIzreh5F3VqZ6X+M04p
         HUQd9kDekZQvIcYe3sI5no2g64g6eGh8VBC7fx4jU+B6OFO+Rjev3zkUxKZHExA67tz4
         cx8Fz+H31Y+gJ+8Jwye1OiPDQiUtLiyyQnQYLyFX5H4m+duQCYJyAHKqpAuegRPm7vz2
         5d2A==
X-Gm-Message-State: AOAM531jH8tM9/IwkG2Q47nGPTMy5qCDiGIJNL6jycc+vpMv+dHMXcPD
        /QCBJFTvKHm9vdutdmOGZTeE
X-Google-Smtp-Source: ABdhPJwSdakfsAvtHHJHZqjmTu0vXmQ+kjaMTX/ffsxP5Wag9eehpr/2/AH9ET9oyq05TwGIVxPERQ==
X-Received: by 2002:a17:90a:c255:: with SMTP id d21mr3873583pjx.212.1601658377720;
        Fri, 02 Oct 2020 10:06:17 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:648b:81b4:b1f8:3dc1:c168:1411])
        by smtp.gmail.com with ESMTPSA id z8sm2193583pgr.70.2020.10.02.10.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 10:06:16 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        elder@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
Date:   Fri,  2 Oct 2020 22:35:26 +0530
Message-Id: <20201002170526.15450-1-manivannan.sadhasivam@linaro.org>
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
Reported-by: Doug Anderson <dianders@chromium.org>
Tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Changes in v2:

* Used radix_tree_deref_retry() and radix_tree_iter_resume() as
suggested by Doug.

 net/qrtr/ns.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 934999b56d60..dadbe2885be2 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -203,15 +203,24 @@ static int announce_servers(struct sockaddr_qrtr *sq)
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
 
 	return ret;
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
@@ -379,11 +405,11 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
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
 
 	return ret;
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
@@ -458,11 +492,11 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
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
 
 	return ret;
@@ -571,16 +605,33 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
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
+			srv_slot = radix_tree_iter_resume(srv_slot, &srv_iter);
+
 			if (!server_match(srv, &filter))
 				continue;
 
+			rcu_read_unlock();
 			lookup_notify(from, srv, true);
+			rcu_read_lock();
 		}
 	}
 	rcu_read_unlock();
-- 
2.17.1

