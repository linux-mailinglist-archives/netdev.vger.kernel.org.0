Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2FF857B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKLAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:40:20 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32950 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726903AbfKLAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:40:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 38A3F4AC53;
        Tue, 12 Nov 2019 11:40:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received:received:received;
         s=mail_dkim; t=1573519213; bh=D6wSYolnnaGGUCfp42yd05Iow704javOn
        uwz29SwktM=; b=BV0Qu6b+z22uHJ/JFf1Wa/BOYYjLS172m+nORZ4x95aJPpCkk
        Oh9bru8nkj53+jDS9I7vBVgj98XRZfmFsPGLHs/7PrR0hBFk/bHjm6Rw93VjcFFn
        Wedn1BKVzkW7YpS3izDBpgTKBXqc7SVWnaEwafHlwG4loWpnpTHredtrBY=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RYFcF8dyTdEi; Tue, 12 Nov 2019 11:40:13 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 0C3C54AC54;
        Tue, 12 Nov 2019 11:40:12 +1100 (AEDT)
Received: from dhost.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 2FE164AC53;
        Tue, 12 Nov 2019 11:40:12 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [net-next] tipc: update mon's self addr when node addr generated
Date:   Tue, 12 Nov 2019 07:40:04 +0700
Message-Id: <20191112004004.3625-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address
hash values"), the 32-bit node address only generated after one second
trial period expired. However the self's addr in struct tipc_monitor do
not update according to node address generated. This lead to it is
always zero as initial value. As result, sorting algorithm using this
value does not work as expected, neither neighbor monitoring framework.

In this commit, we add a fix to update self's addr when 32-bit node
address generated.

Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash=
 values")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/monitor.c | 15 +++++++++++++++
 net/tipc/monitor.h |  1 +
 net/tipc/net.c     |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 6a6eae88442f..58708b4c7719 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -665,6 +665,21 @@ void tipc_mon_delete(struct net *net, int bearer_id)
 	kfree(mon);
 }
=20
+void tipc_mon_reinit_self(struct net *net)
+{
+	struct tipc_monitor *mon;
+	int bearer_id;
+
+	for (bearer_id =3D 0; bearer_id < MAX_BEARERS; bearer_id++) {
+		mon =3D tipc_monitor(net, bearer_id);
+		if (!mon)
+			continue;
+		write_lock_bh(&mon->lock);
+		mon->self->addr =3D tipc_own_addr(net);
+		write_unlock_bh(&mon->lock);
+	}
+}
+
 int tipc_nl_monitor_set_threshold(struct net *net, u32 cluster_size)
 {
 	struct tipc_net *tn =3D tipc_net(net);
diff --git a/net/tipc/monitor.h b/net/tipc/monitor.h
index 2a21b93e0d04..ed63d2e650b0 100644
--- a/net/tipc/monitor.h
+++ b/net/tipc/monitor.h
@@ -77,6 +77,7 @@ int __tipc_nl_add_monitor(struct net *net, struct tipc_=
nl_msg *msg,
 			  u32 bearer_id);
 int tipc_nl_add_monitor_peer(struct net *net, struct tipc_nl_msg *msg,
 			     u32 bearer_id, u32 *prev_node);
+void tipc_mon_reinit_self(struct net *net);
=20
 extern const int tipc_max_domain_size;
 #endif
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 85707c185360..2de3cec9929d 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -42,6 +42,7 @@
 #include "node.h"
 #include "bcast.h"
 #include "netlink.h"
+#include "monitor.h"
=20
 /*
  * The TIPC locking policy is designed to ensure a very fine locking
@@ -136,6 +137,7 @@ static void tipc_net_finalize(struct net *net, u32 ad=
dr)
 	tipc_set_node_addr(net, addr);
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
+	tipc_mon_reinit_self(net);
 	tipc_nametbl_publish(net, TIPC_CFG_SRV, addr, addr,
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
--=20
2.20.1

