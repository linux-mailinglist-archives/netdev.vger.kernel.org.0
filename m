Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99E065A68B
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLaUEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 15:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiLaUEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 15:04:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50FB6242;
        Sat, 31 Dec 2022 12:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 525E6B80917;
        Sat, 31 Dec 2022 20:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD0BC433F0;
        Sat, 31 Dec 2022 20:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672517084;
        bh=/XX5D6c/7U4fzdnyVEUJ//yyryAw9/ODhKqUW0yQu0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwfo84DOWJN3fGRJq/0ymSSD6rpvegt72SX7ZqjjbyJuZTMDoc1/RCIW2wCgl1pwk
         cynypQD1UnnKdJX65wgfNJSVNx+LXDirOGBbYPzbxdfzyKyJ/YOGh3ID1dQeZvTbvk
         1kYBP2WOhYZd68n9zW+hj4rdivnwh5n1WzWfLUe9Zv3MArKCHTixH8uTHh6PyQSK+B
         LaZcDwqpV71awo2f95Q0alwv1+oTKmjHYl8yOYvGRVEuk1EaWRVn0R8Kbj1H1W/n/2
         XvXXXMrHxpdoBBh1zkdVS9yYouglUzF1tmIHEbTqe+oRpL4ceAYGAjCNwUd+F4Shrz
         wIxTyl2KkyihA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Marco Elver <elver@google.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 2/7] 9p/client: fix data race on req->status
Date:   Sat, 31 Dec 2022 15:04:34 -0500
Message-Id: <20221231200439.1748686-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221231200439.1748686-1-sashal@kernel.org>
References: <20221231200439.1748686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 1a4f69ef15ec29b213e2b086b2502644e8ef76ee ]

KCSAN reported a race between writing req->status in p9_client_cb and
accessing it in p9_client_rpc's wait_event.

Accesses to req itself is protected by the data barrier (writing req
fields, write barrier, writing status // reading status, read barrier,
reading other req fields), but status accesses themselves apparently
also must be annotated properly with WRITE_ONCE/READ_ONCE when we
access it without locks.

Follows:
 - error paths writing status in various threads all can notify
p9_client_rpc, so these all also need WRITE_ONCE
 - there's a similar read loop in trans_virtio for zc case that also
needs READ_ONCE
 - other reads in trans_fd should be protected by the trans_fd lock and
lists state machine, as corresponding writers all are within trans_fd
and should be under the same lock. If KCSAN complains on them we likely
will have something else to fix as well, so it's better to leave them
unmarked and look again if required.

Link: https://lkml.kernel.org/r/20221205124756.426350-1-asmadeus@codewreck.org
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c       | 15 ++++++++-------
 net/9p/trans_fd.c     | 12 ++++++------
 net/9p/trans_rdma.c   |  4 ++--
 net/9p/trans_virtio.c |  9 +++++----
 net/9p/trans_xen.c    |  4 ++--
 5 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index aaa37b07e30a..29565e021495 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -438,7 +438,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 	 * the status change is visible to another thread
 	 */
 	smp_wmb();
-	req->status = status;
+	WRITE_ONCE(req->status, status);
 
 	wake_up(&req->wq);
 	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
@@ -600,7 +600,7 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 	/* if we haven't received a response for oldreq,
 	 * remove it from the list
 	 */
-	if (oldreq->status == REQ_STATUS_SENT) {
+	if (READ_ONCE(oldreq->status) == REQ_STATUS_SENT) {
 		if (c->trans_mod->cancelled)
 			c->trans_mod->cancelled(c, oldreq);
 	}
@@ -697,7 +697,8 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	}
 again:
 	/* Wait for the response */
-	err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
+	err = wait_event_killable(req->wq,
+				  READ_ONCE(req->status) >= REQ_STATUS_RCVD);
 
 	/* Make sure our req is coherent with regard to updates in other
 	 * threads - echoes to wmb() in the callback
@@ -711,7 +712,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 		goto again;
 	}
 
-	if (req->status == REQ_STATUS_ERROR) {
+	if (READ_ONCE(req->status) == REQ_STATUS_ERROR) {
 		p9_debug(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
 		err = req->t_err;
 	}
@@ -724,7 +725,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 			p9_client_flush(c, req);
 
 		/* if we received the response anyway, don't signal error */
-		if (req->status == REQ_STATUS_RCVD)
+		if (READ_ONCE(req->status) == REQ_STATUS_RCVD)
 			err = 0;
 	}
 recalc_sigpending:
@@ -793,7 +794,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 		if (err != -ERESTARTSYS)
 			goto recalc_sigpending;
 	}
-	if (req->status == REQ_STATUS_ERROR) {
+	if (READ_ONCE(req->status) == REQ_STATUS_ERROR) {
 		p9_debug(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
 		err = req->t_err;
 	}
@@ -806,7 +807,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 			p9_client_flush(c, req);
 
 		/* if we received the response anyway, don't signal error */
-		if (req->status == REQ_STATUS_RCVD)
+		if (READ_ONCE(req->status) == REQ_STATUS_RCVD)
 			err = 0;
 	}
 recalc_sigpending:
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 07db2f436d44..5a1aecf7fe48 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -202,11 +202,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
-		req->status = REQ_STATUS_ERROR;
+		WRITE_ONCE(req->status, REQ_STATUS_ERROR);
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
-		req->status = REQ_STATUS_ERROR;
+		WRITE_ONCE(req->status, REQ_STATUS_ERROR);
 	}
 
 	spin_unlock(&m->req_lock);
@@ -467,7 +467,7 @@ static void p9_write_work(struct work_struct *work)
 
 		req = list_entry(m->unsent_req_list.next, struct p9_req_t,
 			       req_list);
-		req->status = REQ_STATUS_SENT;
+		WRITE_ONCE(req->status, REQ_STATUS_SENT);
 		p9_debug(P9_DEBUG_TRANS, "move req %p\n", req);
 		list_move_tail(&req->req_list, &m->req_list);
 
@@ -676,7 +676,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 		return m->err;
 
 	spin_lock(&m->req_lock);
-	req->status = REQ_STATUS_UNSENT;
+	WRITE_ONCE(req->status, REQ_STATUS_UNSENT);
 	list_add_tail(&req->req_list, &m->unsent_req_list);
 	spin_unlock(&m->req_lock);
 
@@ -703,7 +703,7 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 
 	if (req->status == REQ_STATUS_UNSENT) {
 		list_del(&req->req_list);
-		req->status = REQ_STATUS_FLSHD;
+		WRITE_ONCE(req->status, REQ_STATUS_FLSHD);
 		p9_req_put(client, req);
 		ret = 0;
 	}
@@ -732,7 +732,7 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 	 * remove it from the list.
 	 */
 	list_del(&req->req_list);
-	req->status = REQ_STATUS_FLSHD;
+	WRITE_ONCE(req->status, REQ_STATUS_FLSHD);
 	spin_unlock(&m->req_lock);
 
 	p9_req_put(client, req);
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 6ff706760676..e9a830c69058 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -507,7 +507,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	 * because doing if after could erase the REQ_STATUS_RCVD
 	 * status in case of a very fast reply.
 	 */
-	req->status = REQ_STATUS_SENT;
+	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
 		goto send_error;
@@ -517,7 +517,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
  /* Handle errors that happened during or while preparing the send: */
  send_error:
-	req->status = REQ_STATUS_ERROR;
+	WRITE_ONCE(req->status, REQ_STATUS_ERROR);
 	kfree(c);
 	p9_debug(P9_DEBUG_ERROR, "Error %d in rdma_request()\n", err);
 
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e757f0601304..3f3eb03cda7d 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -263,7 +263,7 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 
 	p9_debug(P9_DEBUG_TRANS, "9p debug: virtio request\n");
 
-	req->status = REQ_STATUS_SENT;
+	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 req_retry:
 	spin_lock_irqsave(&chan->lock, flags);
 
@@ -469,7 +469,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 			inlen = n;
 		}
 	}
-	req->status = REQ_STATUS_SENT;
+	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 req_retry_pinned:
 	spin_lock_irqsave(&chan->lock, flags);
 
@@ -532,9 +532,10 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	kicked = 1;
 	p9_debug(P9_DEBUG_TRANS, "virtio request kicked\n");
-	err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
+	err = wait_event_killable(req->wq,
+			          READ_ONCE(req->status) >= REQ_STATUS_RCVD);
 	// RERROR needs reply (== error string) in static data
-	if (req->status == REQ_STATUS_RCVD &&
+	if (READ_ONCE(req->status) == REQ_STATUS_RCVD &&
 	    unlikely(req->rc.sdata[4] == P9_RERROR))
 		handle_rerror(req, in_hdr_len, offs, in_pages);
 
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index aaa5fd364691..cf1b89ba522b 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -157,7 +157,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 			      &masked_prod, masked_cons,
 			      XEN_9PFS_RING_SIZE(ring));
 
-	p9_req->status = REQ_STATUS_SENT;
+	WRITE_ONCE(p9_req->status, REQ_STATUS_SENT);
 	virt_wmb();			/* write ring before updating pointer */
 	prod += size;
 	ring->intf->out_prod = prod;
@@ -212,7 +212,7 @@ static void p9_xen_response(struct work_struct *work)
 			dev_warn(&priv->dev->dev,
 				 "requested packet size too big: %d for tag %d with capacity %zd\n",
 				 h.size, h.tag, req->rc.capacity);
-			req->status = REQ_STATUS_ERROR;
+			WRITE_ONCE(req->status, REQ_STATUS_ERROR);
 			goto recv_error;
 		}
 
-- 
2.35.1

