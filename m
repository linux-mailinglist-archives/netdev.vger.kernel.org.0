Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A9F59A6C6
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351629AbiHSTro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351628AbiHSTrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:47:40 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EFE11418A;
        Fri, 19 Aug 2022 12:47:39 -0700 (PDT)
Received: from stanislav-HLY-WX9XX.. (unknown [46.172.22.155])
        by mail.ispras.ru (Postfix) with ESMTPSA id 51FF740737D5;
        Fri, 19 Aug 2022 19:47:36 +0000 (UTC)
From:   Stanislav Goriainov <goriainov@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanislav Goriainov <goriainov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] qrtr: Convert qrtr_ports from IDR to XArray
Date:   Fri, 19 Aug 2022 22:47:27 +0300
Message-Id: <20220819194727.18911-2-goriainov@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819194727.18911-1-goriainov@ispras.ru>
References: <20220819194727.18911-1-goriainov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 3cbf7530a163d048a6376cd22fecb9cdcb23b192 upstream.

The XArray interface is easier for this driver to use.  Also fixes a
bug reported by the improper use of GFP_ATOMIC.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Stanislav Goriainov <goriainov@ispras.ru>
---
 net/qrtr/qrtr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 56cffbfa000b..13448ca5aeff 100644
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
@@ -635,7 +636,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
 		port = 0;
 
 	rcu_read_lock();
-	ipc = idr_find(&qrtr_ports, port);
+	ipc = xa_load(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
 	rcu_read_unlock();
@@ -677,9 +678,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 
 	__sock_put(&ipc->sk);
 
-	mutex_lock(&qrtr_port_lock);
-	idr_remove(&qrtr_ports, port);
-	mutex_unlock(&qrtr_port_lock);
+	xa_erase(&qrtr_ports, port);
 
 	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
 	 * wait for it to up increment the refcount */
@@ -698,29 +697,20 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
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
@@ -734,20 +724,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
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
2.34.1

