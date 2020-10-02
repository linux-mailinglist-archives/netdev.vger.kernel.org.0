Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4D2814CA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbgJBOPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgJBOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:15:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE20C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:15:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so840488pgo.13
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 07:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zVK/huinEYYRTVj7T9kF8Bo0Krp4Ekz8MpSBljbooe4=;
        b=OtpA+J086PPaULXyT2OUBlpIC6o/fu0AFdHv+FsZIzsM126+Oa00Pwb32a0nnmbuEI
         BFCwx8rNRuYn+Fwsl7hgZKIhBW+2snvdyggZLM7uygZsaHKMQ/bTpIN9hzcrWLYmb0IW
         iI0nMZ21c9oAV2/HlKKFae8tdPdMDYk4YkyWUxVnhn92hhZpOiMwbRgnFnZlUXxCSuaI
         87upU3CFFBChfVdJ/DAXNAhyP7ajnEzkF+lY6tbhJaTpH6Hz8jiaue/FaQHyFXOTGjsQ
         dZGv0rFpyemuRC0o1CJQ8ixyjJquCNwKsH4m/doe558WAJw/KJMFDnjlXTMykYZOUbEs
         3yKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zVK/huinEYYRTVj7T9kF8Bo0Krp4Ekz8MpSBljbooe4=;
        b=ECORWglAHHoiKjXwyfPje9IiBiXcmQSTDEIcYMVHD8NOS8mgTkPjdjn03kINHfIJRC
         2w89+WLHA1ZLmR/l4gwnLZw63K5chYF6A2HYZxlh2DcrPOlQFvO1MH9HvEuBUEh4FyOz
         dzPbOJCtqDpkXmU3G3E5Izq8eitr2gW0P2zgv/9JiY5FUF6B9BLqzXNpVt5S3RZTJUqt
         nrmyUzZsZ3D4/63f8WwHeKoe/EZKMilBA4yiQCMcgLCDYwCA6wQx7HVNoCQDL42c8Gmw
         RKP1OvxSv3+j1IZObY2fOjs9+JDfLDn5O+RZTQl8P83mjPZ7rs+Azwr2kxtIpl5CoEQF
         Zt6g==
X-Gm-Message-State: AOAM531qV2blBMJwx5Z1zGyIdNa0ZAdkNzF0uACYLJqhNgNiA0zinVXo
        2d9PzQvTEgLCo7rF5ZQrx+/u
X-Google-Smtp-Source: ABdhPJwemyA7OihJWpDPPxfXtYNtwFT0YQz+lKBX5/7hpLXnIiGMzFb8EvrU963NVX+jJvrX5DWFEQ==
X-Received: by 2002:a63:c74a:: with SMTP id v10mr2378007pgg.240.1601648145779;
        Fri, 02 Oct 2020 07:15:45 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:648b:81b4:b1f8:3dc1:c168:1411])
        by smtp.gmail.com with ESMTPSA id s2sm1695851pjg.52.2020.10.02.07.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 07:15:44 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        elder@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
Date:   Fri,  2 Oct 2020 19:45:31 +0530
Message-Id: <20201002141531.7081-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
fix it by excluding the locking for kernel_sendmsg().

Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
Reported-by: Doug Anderson <dianders@chromium.org>
Tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/ns.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 934999b56d60..0515433de922 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -203,15 +203,17 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 	/* Announce the list of servers registered in this node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
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
@@ -352,7 +354,9 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	/* Advertise removal of this client to all servers of remote node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		rcu_read_unlock();
 		server_del(node, srv->port);
+		rcu_read_lock();
 	}
 	rcu_read_unlock();
 
@@ -368,6 +372,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		rcu_read_unlock();
 
 		sq.sq_family = AF_QIPCRTR;
 		sq.sq_node = srv->node;
@@ -379,11 +384,11 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
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
@@ -447,6 +452,7 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
+		rcu_read_unlock();
 
 		sq.sq_family = AF_QIPCRTR;
 		sq.sq_node = srv->node;
@@ -458,11 +464,11 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
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
@@ -580,7 +586,9 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
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

