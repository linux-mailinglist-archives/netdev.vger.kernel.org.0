Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A34596C5B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbfHTWdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37000 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FvnsJsb+w2ZuBrkHyqnsorgjcylhtYoM3DK8yzFejpA=; b=Bixt2uQA+xqoHWdmT+dTS/dESo
        a5x7CJgSdBBhzhur3Wix+ouwoPzjF+7fz84zTF0i7u5kIYzxd1LbEsXOm0KRJXfbOrcxmTqqjwYYy
        OGSDcfBENMKZE82Q5NgvCLzweSk1xMQoE7c/y5/Cnh3MIcWQDDSuzvE05O8PDcp4CRI3rjckbfNgL
        QWsoZI2PDCLyZLv0uwt5Rg1VRxhnFNU7U1RzKcyLfpl/DFP90FSM5R8clyjKmlpXEK+NjmcAeta9L
        o0mEZ+1AtJc0id44wYI6Vy2dLcmbnwKy4HEMpooz0Lb4RWwBG6bt8CAp0nAJ5bEVhNO8vvAZxqJgG
        BL7MaBZg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rY-Q7; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 21/38] 9p: Move lock from client to trans_fd
Date:   Tue, 20 Aug 2019 15:32:42 -0700
Message-Id: <20190820223259.22348-22-willy@infradead.org>
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

The trans_fd back end is now the only transport using the client
spinlock so move it into the transport connection.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/9p/client.h |  2 --
 net/9p/client.c         |  1 -
 net/9p/trans_fd.c       | 36 +++++++++++++++++++++---------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index a50f98cff203..0ff697676d00 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -86,7 +86,6 @@ struct p9_req_t {
 
 /**
  * struct p9_client - per client instance state
- * @lock: protect @fids and @reqs
  * @msize: maximum data size negotiated by protocol
  * @proto_version: 9P protocol version to use
  * @trans_mod: module API instantiated with this client
@@ -100,7 +99,6 @@ struct p9_req_t {
  * state that has been instantiated.
  */
 struct p9_client {
-	spinlock_t lock;
 	unsigned int msize;
 	unsigned char proto_version;
 	struct p9_trans_module *trans_mod;
diff --git a/net/9p/client.c b/net/9p/client.c
index ca7bd0949ebb..1b419fcc5033 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1006,7 +1006,6 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	client_id = utsname()->nodename;
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
 
-	spin_lock_init(&clnt->lock);
 	xa_init_flags(&clnt->fids, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	xa_init_flags(&clnt->reqs, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 05fa9cb2897e..74d946e02cf9 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -112,6 +112,7 @@ struct p9_poll_wait {
 struct p9_conn {
 	struct list_head mux_list;
 	struct p9_client *client;
+	spinlock_t lock;
 	int err;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
@@ -188,10 +189,10 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	p9_debug(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
 
-	spin_lock(&m->client->lock);
+	spin_lock(&m->lock);
 
 	if (m->err) {
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->lock);
 		return;
 	}
 
@@ -211,7 +212,7 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
+	spin_unlock(&m->lock);
 }
 
 static __poll_t
@@ -357,19 +358,19 @@ static void p9_read_work(struct work_struct *work)
 	if ((m->rreq) && (m->rc.offset == m->rc.capacity)) {
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
 		m->rreq->rc.size = m->rc.offset;
-		spin_lock(&m->client->lock);
+		spin_lock(&m->lock);
 		if (m->rreq->status == REQ_STATUS_SENT) {
 			list_del(&m->rreq->req_list);
 			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
 		} else {
-			spin_unlock(&m->client->lock);
+			spin_unlock(&m->lock);
 			p9_debug(P9_DEBUG_ERROR,
 				 "Request tag %d errored out while we were reading the reply\n",
 				 m->rc.tag);
 			err = -EIO;
 			goto error;
 		}
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->lock);
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
 		m->rc.capacity = 0;
@@ -447,10 +448,10 @@ static void p9_write_work(struct work_struct *work)
 	}
 
 	if (!m->wsize) {
-		spin_lock(&m->client->lock);
+		spin_lock(&m->lock);
 		if (list_empty(&m->unsent_req_list)) {
 			clear_bit(Wworksched, &m->wsched);
-			spin_unlock(&m->client->lock);
+			spin_unlock(&m->lock);
 			return;
 		}
 
@@ -465,7 +466,7 @@ static void p9_write_work(struct work_struct *work)
 		m->wpos = 0;
 		p9_req_get(req);
 		m->wreq = req;
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->lock);
 	}
 
 	p9_debug(P9_DEBUG_TRANS, "mux %p pos %d size %d\n",
@@ -663,10 +664,10 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	if (m->err < 0)
 		return m->err;
 
-	spin_lock(&client->lock);
+	spin_lock(&m->lock);
 	req->status = REQ_STATUS_UNSENT;
 	list_add_tail(&req->req_list, &m->unsent_req_list);
-	spin_unlock(&client->lock);
+	spin_unlock(&m->lock);
 
 	if (test_and_clear_bit(Wpending, &m->wsched))
 		n = EPOLLOUT;
@@ -681,11 +682,13 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 
 static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 {
+	struct p9_trans_fd *ts = client->trans;
+	struct p9_conn *m = &ts->conn;
 	int ret = 1;
 
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
-	spin_lock(&client->lock);
+	spin_lock(&m->lock);
 
 	if (req->status == REQ_STATUS_UNSENT) {
 		list_del(&req->req_list);
@@ -693,21 +696,24 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 		p9_req_put(req);
 		ret = 0;
 	}
-	spin_unlock(&client->lock);
+	spin_unlock(&m->lock);
 
 	return ret;
 }
 
 static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 {
+	struct p9_trans_fd *ts = client->trans;
+	struct p9_conn *m = &ts->conn;
+
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
 	/* we haven't received a response for oldreq,
 	 * remove it from the list.
 	 */
-	spin_lock(&client->lock);
+	spin_lock(&m->lock);
 	list_del(&req->req_list);
-	spin_unlock(&client->lock);
+	spin_unlock(&m->lock);
 	p9_req_put(req);
 
 	return 0;
-- 
2.23.0.rc1

