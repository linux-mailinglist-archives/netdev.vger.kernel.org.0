Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E441EF6EC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgFEMAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgFEMAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 08:00:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10F7C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 05:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZkydSh6STLYZRXDoU5zzN5Mscgf9Pq50DgNGZkD80cs=; b=jh9ZJa4UpIAU5ifJGejq24wd9U
        OdARNRU067AHWfb5VvFQ9qQsDVgFchvtroqMwcB2VzVLKlt6n2E4kuD4IXfCojjLBT7d/G/ZSFqAt
        8C2H7Jcrvixzved/tOvVi/pr+dXhtPKcnq6Dt32DtwHNcXffeBYV+kuo4RyOCZpG3GJK7BkxJ0HT6
        qEAoHXSPu9FLKeCjpogng7KVcPnmweA7UXFeE1QGh0lCnsqifsAN+yvQAiMqrNafILLdxbEOKjiP9
        PweaujFTpsQ+3IP4piQOvSpGennMuVMmI6wSkFwr/+qD0+jYIC698t2NFFazYD+XAWqkbTRKEgDVx
        IWrdxaKg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jhB1b-0006yb-1v; Fri, 05 Jun 2020 12:00:39 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Date:   Fri,  5 Jun 2020 05:00:37 -0700
Message-Id: <20200605120037.17427-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The XArray interface is easier for this driver to use.  Also fixes a
bug reported by the improper use of GFP_ATOMIC.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 2d8d6131bc5f..488f8f326ee5 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -20,6 +20,7 @@
 /* auto-bind range */
 #define QRTR_MIN_EPH_SOCKET 0x4000
 #define QRTR_MAX_EPH_SOCKET 0x7fff
+#define QRTR_PORT_RANGE	XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
 
 /**
  * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
@@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
-static DEFINE_IDR(qrtr_ports);
-static DEFINE_MUTEX(qrtr_port_lock);
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
 
 /**
  * struct qrtr_node - endpoint node
@@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
 		port = 0;
 
 	rcu_read_lock();
-	ipc = idr_find(&qrtr_ports, port);
+	ipc = xa_load(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
 	rcu_read_unlock();
@@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 
 	__sock_put(&ipc->sk);
 
-	mutex_lock(&qrtr_port_lock);
-	idr_remove(&qrtr_ports, port);
-	mutex_unlock(&qrtr_port_lock);
+	xa_erase(&qrtr_ports, port);
 
 	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
 	 * wait for it to up increment the refcount */
@@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
 	int rc;
 
-	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		rc = idr_alloc(&qrtr_ports, ipc,
-			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
-			       GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
+				GFP_KERNEL);
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
@@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
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
2.26.2

