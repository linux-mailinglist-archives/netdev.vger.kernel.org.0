Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8A34F80B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 06:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCaEht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 00:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhCaEhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 00:37:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B32BC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 21:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Uu/REj8xsu7OZC7N2C/I1JBW/vM03sB0JFwoUaNvhTA=; b=s6+3bEwWSO06+HWZ/GKnw6w23x
        m4gVnzLKyZR2mwq1fc2QVmjtRRdZxUntWdgHFEa5t6LsiccTtHv/VQcz6dV0VdKQfUO28dJQeN5Ck
        0wg1w1pvJzMq9kYieoVHI/TXlopHOTNvUUsOfkZqnwD0k7ZYwEIGqHx/K1tErl4NeXX6gbXkv9HRN
        57Npcjo9pEj8+aQBPErKL70Y91DKipq+oLrSq1WIwcdPsWFxWZ/b1q56pIdN1vU0gU23yIpsiFIms
        LXDvB8590TZdV5a50fR9xS8V9qai1tMQeQb58aeile7nnZd4xRkoxTT514LmtQshCJBaDp32sF9+K
        zG6hIrLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lRSaz-0041fP-2c; Wed, 31 Mar 2021 04:36:52 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Date:   Wed, 31 Mar 2021 05:36:42 +0100
Message-Id: <20210331043643.959675-1-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XArray interface is easier for this driver to use.  Also fixes a
bug reported by the improper use of GFP_ATOMIC.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/qrtr/qrtr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index dfc820ee553a..4b46c69e14ab 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -20,6 +20,8 @@
 /* auto-bind range */
 #define QRTR_MIN_EPH_SOCKET 0x4000
 #define QRTR_MAX_EPH_SOCKET 0x7fff
+#define QRTR_EPH_PORT_RANGE \
+		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
 
 /**
  * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
@@ -106,8 +108,7 @@ static LIST_HEAD(qrtr_all_nodes);
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
-static DEFINE_IDR(qrtr_ports);
-static DEFINE_MUTEX(qrtr_port_lock);
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
 
 /**
  * struct qrtr_node - endpoint node
@@ -653,7 +654,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
 		port = 0;
 
 	rcu_read_lock();
-	ipc = idr_find(&qrtr_ports, port);
+	ipc = xa_load(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
 	rcu_read_unlock();
@@ -695,9 +696,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 
 	__sock_put(&ipc->sk);
 
-	mutex_lock(&qrtr_port_lock);
-	idr_remove(&qrtr_ports, port);
-	mutex_unlock(&qrtr_port_lock);
+	xa_erase(&qrtr_ports, port);
 
 	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
 	 * wait for it to up increment the refcount */
@@ -716,29 +715,20 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
  */
 static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
-	u32 min_port;
 	int rc;
 
-	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		min_port = QRTR_MIN_EPH_SOCKET;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
-		if (!rc)
-			*port = min_port;
+		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
+				GFP_KERNEL);
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
-		min_port = 0;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
+		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
 	} else {
-		min_port = *port;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
-		if (!rc)
-			*port = min_port;
+		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
 	}
-	mutex_unlock(&qrtr_port_lock);
 
-	if (rc == -ENOSPC)
+	if (rc == -EBUSY)
 		return -EADDRINUSE;
 	else if (rc < 0)
 		return rc;
@@ -752,20 +742,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 static void qrtr_reset_ports(void)
 {
 	struct qrtr_sock *ipc;
-	int id;
-
-	mutex_lock(&qrtr_port_lock);
-	idr_for_each_entry(&qrtr_ports, ipc, id) {
-		/* Don't reset control port */
-		if (id == 0)
-			continue;
+	unsigned long index;
 
+	rcu_read_lock();
+	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
 		sock_hold(&ipc->sk);
 		ipc->sk.sk_err = ENETRESET;
 		ipc->sk.sk_error_report(&ipc->sk);
 		sock_put(&ipc->sk);
 	}
-	mutex_unlock(&qrtr_port_lock);
+	rcu_read_unlock();
 }
 
 /* Bind socket to address.
-- 
2.30.2

