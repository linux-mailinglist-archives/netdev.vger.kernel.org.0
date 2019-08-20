Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6272196C4F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbfHTWdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AwzYE3CFMojGwX+Ip6BkOSqW9iI3mfTJ+t+02MwvhKc=; b=LKH0ahLNaaRaA4xHofDWsiX6mN
        rn/EejyrkHkpklnleccUBexieuuEF4Qw0v87iphhC2uEI9UshmM/iIXnKUvKfnn1Zm5G1Dik02Gmj
        qimwzc9kpA7KUIgE/qPwL3tKrtSeRrasVj/v/8O/tAU22/Z6uWldHhHnziSVta70jRhOIJ9hftUOa
        HBQWlyztEcjxno8aZSf9HVx2/0oFn+EqCgGhy8yTf6aueYS8cA2bH3CpIInCXrhEuU/fmud7WU3P7
        sLfrcLhhGcbLEC+fp1jTm6IJE+JwEOOxg6SK7wINMoh0Uh2pf0TnnROx9W1XX0KwPjdU5s+ds7aPL
        M4lSCtHg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005su-Hm; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 35/38] tipc: Convert conn_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:56 -0700
Message-Id: <20190820223259.22348-36-willy@infradead.org>
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

Replace idr_lock with the internal XArray lock.  The idr_in_use
counter isn't needed as we can free all the elements in the array
without it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/tipc/topsrv.c | 49 ++++++++++++++---------------------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 3a12fc18239b..72b3180e0ea5 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -54,9 +54,7 @@
 
 /**
  * struct tipc_topsrv - TIPC server structure
- * @conn_idr: identifier set of connection
- * @idr_lock: protect the connection identifier set
- * @idr_in_use: amount of allocated identifier entry
+ * @conns: identifier set of connection
  * @net: network namspace instance
  * @awork: accept work item
  * @rcv_wq: receive workqueue
@@ -65,9 +63,7 @@
  * @name: server name
  */
 struct tipc_topsrv {
-	struct idr conn_idr;
-	spinlock_t idr_lock; /* for idr list */
-	int idr_in_use;
+	struct xarray conns;
 	struct net *net;
 	struct work_struct awork;
 	struct workqueue_struct *rcv_wq;
@@ -127,10 +123,7 @@ static void tipc_conn_kref_release(struct kref *kref)
 	struct tipc_topsrv *s = con->server;
 	struct outqueue_entry *e, *safe;
 
-	spin_lock_bh(&s->idr_lock);
-	idr_remove(&s->conn_idr, con->conid);
-	s->idr_in_use--;
-	spin_unlock_bh(&s->idr_lock);
+	xa_erase_bh(&s->conns, con->conid);
 	if (con->sock)
 		sock_release(con->sock);
 
@@ -194,16 +187,12 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
 	INIT_WORK(&con->swork, tipc_conn_send_work);
 	INIT_WORK(&con->rwork, tipc_conn_recv_work);
 
-	spin_lock_bh(&s->idr_lock);
-	ret = idr_alloc(&s->conn_idr, con, 0, 0, GFP_ATOMIC);
+	ret = xa_alloc_bh(&s->conns, &con->conid, con, xa_limit_32b,
+			GFP_ATOMIC);
 	if (ret < 0) {
 		kfree(con);
-		spin_unlock_bh(&s->idr_lock);
 		return ERR_PTR(-ENOMEM);
 	}
-	con->conid = ret;
-	s->idr_in_use++;
-	spin_unlock_bh(&s->idr_lock);
 
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
@@ -215,11 +204,11 @@ static struct tipc_conn *tipc_conn_lookup(struct tipc_topsrv *s, int conid)
 {
 	struct tipc_conn *con;
 
-	spin_lock_bh(&s->idr_lock);
-	con = idr_find(&s->conn_idr, conid);
+	xa_lock_bh(&s->conns);
+	con = xa_load(&s->conns, conid);
 	if (!connected(con) || !kref_get_unless_zero(&con->kref))
 		con = NULL;
-	spin_unlock_bh(&s->idr_lock);
+	xa_unlock_bh(&s->conns);
 	return con;
 }
 
@@ -655,9 +644,7 @@ static int tipc_topsrv_start(struct net *net)
 	tn->topsrv = srv;
 	atomic_set(&tn->subscription_count, 0);
 
-	spin_lock_init(&srv->idr_lock);
-	idr_init(&srv->conn_idr);
-	srv->idr_in_use = 0;
+	xa_init_flags(&srv->conns, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_BH);
 
 	ret = tipc_topsrv_work_start(srv);
 	if (ret < 0)
@@ -675,24 +662,16 @@ static void tipc_topsrv_stop(struct net *net)
 	struct tipc_topsrv *srv = tipc_topsrv(net);
 	struct socket *lsock = srv->listener;
 	struct tipc_conn *con;
-	int id;
-
-	spin_lock_bh(&srv->idr_lock);
-	for (id = 0; srv->idr_in_use; id++) {
-		con = idr_find(&srv->conn_idr, id);
-		if (con) {
-			spin_unlock_bh(&srv->idr_lock);
-			tipc_conn_close(con);
-			spin_lock_bh(&srv->idr_lock);
-		}
-	}
+	unsigned long id;
+
+	xa_for_each(&srv->conns, id, con)
+		tipc_conn_close(con);
+
 	__module_get(lsock->ops->owner);
 	__module_get(lsock->sk->sk_prot_creator->owner);
 	srv->listener = NULL;
-	spin_unlock_bh(&srv->idr_lock);
 	sock_release(lsock);
 	tipc_topsrv_work_stop(srv);
-	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
 
-- 
2.23.0.rc1

