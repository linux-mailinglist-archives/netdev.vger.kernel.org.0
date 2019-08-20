Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC696C60
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbfHTWds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730990AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pv49RFD9C+s7CO0mJEtOqJ4XIjF3fRmlHkVxSSOmTAU=; b=SKYj8bj6lcpfcApWc44hN3lMNM
        T3wO7eBP43ROFX2QVYOoPUUxMhOknMlUXSWMc8gu1ncvVZmGgeUndMTZJefEFBp2oxz/z9Az7F8pq
        YR35GvbMCQ5ejLHh+VG2VANIZLQIurInq0OZNTSKSoIM9+TIi9Z19ol2RelQqtt98zTclofcJSDFt
        cLkisMIJtUoqzkRv3ImeC+bkzIx1QcAH+zgLOO/WSJWOWXZ+nIoIxl0rA5mrrZpHCFqhXB1EubWLR
        hZYyPDWy9dWgZ7F+4KvdKKi2oCRge7ewUdQlaY3033D/h29fvGst6ozvK8sma2PHSPyCVZyqQV8RF
        KCDWxkYw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005r9-Hv; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 17/38] qrtr: Convert qrtr_ports to XArray
Date:   Tue, 20 Aug 2019 15:32:38 -0700
Message-Id: <20190820223259.22348-18-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Replace the qrtr_port_lock mutex with the XArray internal spinlock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/qrtr/qrtr.c | 43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e02fa6be76d2..fdbc20442a93 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -104,8 +104,7 @@ static LIST_HEAD(qrtr_all_nodes);
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
-static DEFINE_IDR(qrtr_ports);
-static DEFINE_MUTEX(qrtr_port_lock);
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
 
 /**
  * struct qrtr_node - endpoint node
@@ -483,11 +482,11 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
 	if (port == QRTR_PORT_CTRL)
 		port = 0;
 
-	mutex_lock(&qrtr_port_lock);
-	ipc = idr_find(&qrtr_ports, port);
+	xa_lock(&qrtr_ports);
+	ipc = xa_load(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
-	mutex_unlock(&qrtr_port_lock);
+	xa_unlock(&qrtr_ports);
 
 	return ipc;
 }
@@ -526,9 +525,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 
 	__sock_put(&ipc->sk);
 
-	mutex_lock(&qrtr_port_lock);
-	idr_remove(&qrtr_ports, port);
-	mutex_unlock(&qrtr_port_lock);
+	xa_erase(&qrtr_ports, port);
 }
 
 /* Assign port number to socket.
@@ -545,25 +542,19 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
 	int rc;
 
-	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		rc = idr_alloc(&qrtr_ports, ipc,
-			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
-			       GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		rc = xa_alloc(&qrtr_ports, port, ipc,
+				XA_LIMIT(QRTR_MIN_EPH_SOCKET,
+					QRTR_MAX_EPH_SOCKET), GFP_KERNEL);
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
-		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
+		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
 	} else {
-		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
 	}
-	mutex_unlock(&qrtr_port_lock);
 
-	if (rc == -ENOSPC)
+	if (rc == -EBUSY)
 		return -EADDRINUSE;
 	else if (rc < 0)
 		return rc;
@@ -577,20 +568,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
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
+	unsigned long id;
 
+	xa_lock(&qrtr_ports);
+	xa_for_each_start(&qrtr_ports, id, ipc, 1) {
 		sock_hold(&ipc->sk);
 		ipc->sk.sk_err = ENETRESET;
 		ipc->sk.sk_error_report(&ipc->sk);
 		sock_put(&ipc->sk);
 	}
-	mutex_unlock(&qrtr_port_lock);
+	xa_unlock(&qrtr_ports);
 }
 
 /* Bind socket to address.
-- 
2.23.0.rc1

