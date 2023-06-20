Return-Path: <netdev+bounces-12283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9307E736F87
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 17:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4A251C20CC0
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3640F171CE;
	Tue, 20 Jun 2023 14:57:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254FE17721
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:57:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55EA1737
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687273041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPVmbLfi9bgga9t/1pR/YmjTCDUThBHs3vchY9icGtA=;
	b=TQAiQiVrDTADOAtnpROiC6W7TxL9Pjao/451jtBsSv4dEHG9mUYMaIwD3Akba/hHLD+4a9
	Wgx7fy+uPBI4ndTM0nB+tBkz+fdlF7SQCv/krnJoh9esQBL+bJPfrKcdw00GlxB+r5j8zq
	1TJT7BiJV0uNZgZ6ko5m+YcFvgFW5MA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-azJhDjRHOim524o5jKEhlw-1; Tue, 20 Jun 2023 10:57:14 -0400
X-MC-Unique: azJhDjRHOim524o5jKEhlw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 543CA3C1A5FB;
	Tue, 20 Jun 2023 14:54:33 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F4C51400C34;
	Tue, 20 Jun 2023 14:54:31 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@oss.oracle.com
Subject: [PATCH net-next v3 13/18] ocfs2: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
Date: Tue, 20 Jun 2023 15:53:32 +0100
Message-ID: <20230620145338.1300897-14-dhowells@redhat.com>
In-Reply-To: <20230620145338.1300897-1-dhowells@redhat.com>
References: <20230620145338.1300897-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix ocfs2 to use the page fragment allocator rather than kzalloc in order
to allocate the buffers for the handshake message and keepalive request and
reply messages.

Switch from using sendpage() to using sendmsg() + MSG_SPLICE_PAGES so that
sendpage can be phased out.

Signed-off-by: David Howells <dhowells@redhat.com>

cc: Mark Fasheh <mark@fasheh.com>
cc: Joel Becker <jlbec@evilplan.org>
cc: Joseph Qi <joseph.qi@linux.alibaba.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: ocfs2-devel@oss.oracle.com
cc: netdev@vger.kernel.org
---

Notes:
    ver #2)
     - Wrap lines at 80.

 fs/ocfs2/cluster/tcp.c | 109 +++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aecbd712a00c..969d347ed9fa 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -110,9 +110,6 @@ static struct work_struct o2net_listen_work;
 static struct o2hb_callback_func o2net_hb_up, o2net_hb_down;
 #define O2NET_HB_PRI 0x1
 
-static struct o2net_handshake *o2net_hand;
-static struct o2net_msg *o2net_keep_req, *o2net_keep_resp;
-
 static int o2net_sys_err_translations[O2NET_ERR_MAX] =
 		{[O2NET_ERR_NONE]	= 0,
 		 [O2NET_ERR_NO_HNDLR]	= -ENOPROTOOPT,
@@ -930,19 +927,22 @@ static int o2net_send_tcp_msg(struct socket *sock, struct kvec *vec,
 }
 
 static void o2net_sendpage(struct o2net_sock_container *sc,
-			   void *kmalloced_virt,
-			   size_t size)
+			   void *virt, size_t size)
 {
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+	struct msghdr msg = {};
+	struct bio_vec bv;
 	ssize_t ret;
 
+	bvec_set_virt(&bv, virt, size);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, size);
+
 	while (1) {
+		msg.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES;
 		mutex_lock(&sc->sc_send_lock);
-		ret = sc->sc_sock->ops->sendpage(sc->sc_sock,
-						 virt_to_page(kmalloced_virt),
-						 offset_in_page(kmalloced_virt),
-						 size, MSG_DONTWAIT);
+		ret = sock_sendmsg(sc->sc_sock, &msg);
 		mutex_unlock(&sc->sc_send_lock);
+
 		if (ret == size)
 			break;
 		if (ret == (ssize_t)-EAGAIN) {
@@ -1168,6 +1168,7 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 				 struct o2net_msg *hdr)
 {
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+	struct o2net_msg *keep_resp;
 	int ret = 0, handler_status;
 	enum  o2net_system_error syserr;
 	struct o2net_msg_handler *nmh = NULL;
@@ -1186,8 +1187,17 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 					   be32_to_cpu(hdr->status));
 			goto out;
 		case O2NET_MSG_KEEP_REQ_MAGIC:
-			o2net_sendpage(sc, o2net_keep_resp,
-				       sizeof(*o2net_keep_resp));
+			keep_resp = alloc_skb_frag(sizeof(*keep_resp),
+						   GFP_KERNEL);
+			if (!keep_resp) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memset(keep_resp, 0, sizeof(*keep_resp));
+			keep_resp->magic =
+				cpu_to_be16(O2NET_MSG_KEEP_RESP_MAGIC);
+			o2net_sendpage(sc, keep_resp, sizeof(*keep_resp));
+			folio_put(virt_to_folio(keep_resp));
 			goto out;
 		case O2NET_MSG_KEEP_RESP_MAGIC:
 			goto out;
@@ -1439,15 +1449,23 @@ static void o2net_rx_until_empty(struct work_struct *work)
 	sc_put(sc);
 }
 
-static void o2net_initialize_handshake(void)
+static struct o2net_handshake *o2net_initialize_handshake(void)
 {
-	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
-		O2HB_MAX_WRITE_TIMEOUT_MS);
-	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(o2net_idle_timeout());
-	o2net_hand->o2net_keepalive_delay_ms = cpu_to_be32(
-		o2net_keepalive_delay());
-	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
-		o2net_reconnect_delay());
+	struct o2net_handshake *hand;
+
+	hand = alloc_skb_frag(sizeof(*hand), GFP_KERNEL);
+	if (!hand)
+		return NULL;
+
+	memset(hand, 0, sizeof(*hand));
+	hand->protocol_version		= cpu_to_be64(O2NET_PROTOCOL_VERSION);
+	hand->connector_id		= cpu_to_be64(1);
+	hand->o2hb_heartbeat_timeout_ms	=
+		cpu_to_be32(O2HB_MAX_WRITE_TIMEOUT_MS);
+	hand->o2net_idle_timeout_ms	= cpu_to_be32(o2net_idle_timeout());
+	hand->o2net_keepalive_delay_ms	= cpu_to_be32(o2net_keepalive_delay());
+	hand->o2net_reconnect_delay_ms	= cpu_to_be32(o2net_reconnect_delay());
+	return hand;
 }
 
 /* ------------------------------------------------------------ */
@@ -1456,16 +1474,22 @@ static void o2net_initialize_handshake(void)
  * rx path will see the response and mark the sc valid */
 static void o2net_sc_connect_completed(struct work_struct *work)
 {
+	struct o2net_handshake *hand;
 	struct o2net_sock_container *sc =
 		container_of(work, struct o2net_sock_container,
 			     sc_connect_work);
 
+	hand = o2net_initialize_handshake();
+	if (!hand)
+		goto out;
+
 	mlog(ML_MSG, "sc sending handshake with ver %llu id %llx\n",
               (unsigned long long)O2NET_PROTOCOL_VERSION,
-	      (unsigned long long)be64_to_cpu(o2net_hand->connector_id));
+	      (unsigned long long)be64_to_cpu(hand->connector_id));
 
-	o2net_initialize_handshake();
-	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
+	o2net_sendpage(sc, hand, sizeof(*hand));
+	folio_put(virt_to_folio(hand));
+out:
 	sc_put(sc);
 }
 
@@ -1475,8 +1499,15 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 	struct o2net_sock_container *sc =
 		container_of(work, struct o2net_sock_container,
 			     sc_keepalive_work.work);
+	struct o2net_msg *keep_req;
 
-	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
+	keep_req = alloc_skb_frag(sizeof(*keep_req), GFP_KERNEL);
+	if (keep_req) {
+		memset(keep_req, 0, sizeof(*keep_req));
+		keep_req->magic = cpu_to_be16(O2NET_MSG_KEEP_REQ_MAGIC);
+		o2net_sendpage(sc, keep_req, sizeof(*keep_req));
+		folio_put(virt_to_folio(keep_req));
+	}
 	sc_put(sc);
 }
 
@@ -1780,6 +1811,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct socket *new_sock = NULL;
 	struct o2nm_node *node = NULL;
 	struct o2nm_node *local_node = NULL;
+	struct o2net_handshake *hand;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
 	unsigned int nofs_flag;
@@ -1882,8 +1914,11 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
 
-	o2net_initialize_handshake();
-	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
+	hand = o2net_initialize_handshake();
+	if (hand) {
+		o2net_sendpage(sc, hand, sizeof(*hand));
+		folio_put(virt_to_folio(hand));
+	}
 
 out:
 	if (new_sock)
@@ -2090,21 +2125,8 @@ int o2net_init(void)
 	unsigned long i;
 
 	o2quo_init();
-
 	o2net_debugfs_init();
 
-	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
-	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
-		goto out;
-
-	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
-	o2net_hand->connector_id = cpu_to_be64(1);
-
-	o2net_keep_req->magic = cpu_to_be16(O2NET_MSG_KEEP_REQ_MAGIC);
-	o2net_keep_resp->magic = cpu_to_be16(O2NET_MSG_KEEP_RESP_MAGIC);
-
 	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
 		struct o2net_node *nn = o2net_nn_from_num(i);
 
@@ -2122,21 +2144,10 @@ int o2net_init(void)
 	}
 
 	return 0;
-
-out:
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
-	o2net_debugfs_exit();
-	o2quo_exit();
-	return -ENOMEM;
 }
 
 void o2net_exit(void)
 {
 	o2quo_exit();
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
 }


