Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C023C13E5BA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbgAPRQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390925AbgAPROH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D81246A7;
        Thu, 16 Jan 2020 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194847;
        bh=jqkd9CEtE5Z2F84odOJ6zX5sxDrEAVpb22A8buy7Ug8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt0x3q46x6TWjp882qAqHdKTYBJfvRBezTJDppz1FbpEXSz40MYxNl7Wd8gj/KmLR
         WB4Ef1lR5UaBGvE7abe4an08di9o4US8t5US+8bCVdsdNuk5ExarjZ/DsjHHChsIam
         90KjkLiwE/vqB7ulI5CyjGGxdT/LFQmJ5feLOt1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 644/671] tipc: update mon's self addr when node addr generated
Date:   Thu, 16 Jan 2020 12:04:42 -0500
Message-Id: <20200116170509.12787-381-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 46cb01eeeb86fca6afe24dda1167b0cb95424e29 ]

In commit 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address
hash values"), the 32-bit node address only generated after one second
trial period expired. However the self's addr in struct tipc_monitor do
not update according to node address generated. This lead to it is
always zero as initial value. As result, sorting algorithm using this
value does not work as expected, neither neighbor monitoring framework.

In this commit, we add a fix to update self's addr when 32-bit node
address generated.

Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/monitor.c | 15 +++++++++++++++
 net/tipc/monitor.h |  1 +
 net/tipc/net.c     |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 67f69389ec17..23706ee16607 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -665,6 +665,21 @@ void tipc_mon_delete(struct net *net, int bearer_id)
 	kfree(mon);
 }
 
+void tipc_mon_reinit_self(struct net *net)
+{
+	struct tipc_monitor *mon;
+	int bearer_id;
+
+	for (bearer_id = 0; bearer_id < MAX_BEARERS; bearer_id++) {
+		mon = tipc_monitor(net, bearer_id);
+		if (!mon)
+			continue;
+		write_lock_bh(&mon->lock);
+		mon->self->addr = tipc_own_addr(net);
+		write_unlock_bh(&mon->lock);
+	}
+}
+
 int tipc_nl_monitor_set_threshold(struct net *net, u32 cluster_size)
 {
 	struct tipc_net *tn = tipc_net(net);
diff --git a/net/tipc/monitor.h b/net/tipc/monitor.h
index 2a21b93e0d04..ed63d2e650b0 100644
--- a/net/tipc/monitor.h
+++ b/net/tipc/monitor.h
@@ -77,6 +77,7 @@ int __tipc_nl_add_monitor(struct net *net, struct tipc_nl_msg *msg,
 			  u32 bearer_id);
 int tipc_nl_add_monitor_peer(struct net *net, struct tipc_nl_msg *msg,
 			     u32 bearer_id, u32 *prev_node);
+void tipc_mon_reinit_self(struct net *net);
 
 extern const int tipc_max_domain_size;
 #endif
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 7ce1e86b024f..2e2e938fe4b7 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -42,6 +42,7 @@
 #include "node.h"
 #include "bcast.h"
 #include "netlink.h"
+#include "monitor.h"
 
 /*
  * The TIPC locking policy is designed to ensure a very fine locking
@@ -136,6 +137,7 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 	tipc_set_node_addr(net, addr);
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
+	tipc_mon_reinit_self(net);
 	tipc_nametbl_publish(net, TIPC_CFG_SRV, addr, addr,
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
-- 
2.20.1

