Return-Path: <netdev+bounces-11502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAFF37335B9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08B4B1C21048
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3740A1DCC0;
	Fri, 16 Jun 2023 16:13:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2635B1DCBE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:13:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CAC3A9D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686932022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjLAMzNfvZhacy7TMP165gYQvQOU+UG7wgtZUHPODnQ=;
	b=O3j6fP4NEOPHfedbgfPBLUcitdJeLHLdnFhld2m3jWVloVrzBv8hyf360WD0l8dmwgeZeM
	hlY+/G7sBPxIM1LECOWCVkV7Xs3MsDdQHHVz1RnM5qngPpu0wfKcuC50Y9xnjmmIjE8zyb
	9RvHIlvbtd6skOvRZkVawKmJ7PbPEig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-ZlJJyylbON2KeVO0CVHemQ-1; Fri, 16 Jun 2023 12:13:40 -0400
X-MC-Unique: ZlJJyylbON2KeVO0CVHemQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E694338041D5;
	Fri, 16 Jun 2023 16:13:39 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3E0A40D1B60;
	Fri, 16 Jun 2023 16:13:37 +0000 (UTC)
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
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-nvme@lists.infradead.org
Subject: [PATCH net-next 10/17] nvme: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date: Fri, 16 Jun 2023 17:12:53 +0100
Message-ID: <20230616161301.622169-11-dhowells@redhat.com>
In-Reply-To: <20230616161301.622169-1-dhowells@redhat.com>
References: <20230616161301.622169-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header, data
pages and trailer.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Keith Busch <kbusch@kernel.org>
cc: Jens Axboe <axboe@fb.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Sagi Grimberg <sagi@grimberg.me>
cc: Chaitanya Kulkarni <kch@nvidia.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-nvme@lists.infradead.org
cc: netdev@vger.kernel.org
---
 drivers/nvme/host/tcp.c   | 44 ++++++++++++++++++-------------------
 drivers/nvme/target/tcp.c | 46 ++++++++++++++++++++++++---------------
 2 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index bf0230442d57..947868c66ef4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -997,25 +997,23 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 	u32 h2cdata_left = req->h2cdata_left;
 
 	while (true) {
+		struct bio_vec bvec;
+		struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES, };
 		struct page *page = nvme_tcp_req_cur_page(req);
 		size_t offset = nvme_tcp_req_cur_offset(req);
 		size_t len = nvme_tcp_req_cur_length(req);
 		bool last = nvme_tcp_pdu_last_send(req, len);
 		int req_data_sent = req->data_sent;
-		int ret, flags = MSG_DONTWAIT;
+		int ret;
 
 		if (last && !queue->data_digest && !nvme_tcp_queue_more(queue))
-			flags |= MSG_EOR;
+			msg.msg_flags |= MSG_EOR;
 		else
-			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+			msg.msg_flags |= MSG_MORE;
 
-		if (sendpage_ok(page)) {
-			ret = kernel_sendpage(queue->sock, page, offset, len,
-					flags);
-		} else {
-			ret = sock_no_sendpage(queue->sock, page, offset, len,
-					flags);
-		}
+		bvec_set_page(&bvec, page, len, offset);
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
+		ret = sock_sendmsg(queue->sock, &msg);
 		if (ret <= 0)
 			return ret;
 
@@ -1054,22 +1052,24 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	struct nvme_tcp_cmd_pdu *pdu = nvme_tcp_req_cmd_pdu(req);
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES, };
 	bool inline_data = nvme_tcp_has_inline_data(req);
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) + hdgst - req->offset;
-	int flags = MSG_DONTWAIT;
 	int ret;
 
 	if (inline_data || nvme_tcp_queue_more(queue))
-		flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+		msg.msg_flags |= MSG_MORE;
 	else
-		flags |= MSG_EOR;
+		msg.msg_flags |= MSG_EOR;
 
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
-	ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
-			offset_in_page(pdu) + req->offset, len,  flags);
+	bvec_set_virt(&bvec, (void *)pdu + req->offset, len);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
+	ret = sock_sendmsg(queue->sock, &msg);
 	if (unlikely(ret <= 0))
 		return ret;
 
@@ -1093,6 +1093,8 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	struct nvme_tcp_data_pdu *pdu = nvme_tcp_req_data_pdu(req);
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_MORE, };
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) - req->offset + hdgst;
 	int ret;
@@ -1101,13 +1103,11 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
 	if (!req->h2cdata_left)
-		ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
-				offset_in_page(pdu) + req->offset, len,
-				MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST);
-	else
-		ret = sock_no_sendpage(queue->sock, virt_to_page(pdu),
-				offset_in_page(pdu) + req->offset, len,
-				MSG_DONTWAIT | MSG_MORE);
+		msg.msg_flags |= MSG_SPLICE_PAGES;
+
+	bvec_set_virt(&bvec, (void *)pdu + req->offset, len);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
+	ret = sock_sendmsg(queue->sock, &msg);
 	if (unlikely(ret <= 0))
 		return ret;
 
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index ed98df72c76b..868aa4de2e4c 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -576,13 +576,17 @@ static void nvmet_tcp_execute_request(struct nvmet_tcp_cmd *cmd)
 
 static int nvmet_try_send_data_pdu(struct nvmet_tcp_cmd *cmd)
 {
+	struct msghdr msg = {
+		.msg_flags = MSG_DONTWAIT | MSG_MORE | MSG_SPLICE_PAGES,
+	};
+	struct bio_vec bvec;
 	u8 hdgst = nvmet_tcp_hdgst_len(cmd->queue);
 	int left = sizeof(*cmd->data_pdu) - cmd->offset + hdgst;
 	int ret;
 
-	ret = kernel_sendpage(cmd->queue->sock, virt_to_page(cmd->data_pdu),
-			offset_in_page(cmd->data_pdu) + cmd->offset,
-			left, MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST);
+	bvec_set_virt(&bvec, (void *)cmd->data_pdu + cmd->offset, left);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, left);
+	ret = sock_sendmsg(cmd->queue->sock, &msg);
 	if (ret <= 0)
 		return ret;
 
@@ -603,17 +607,21 @@ static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 	int ret;
 
 	while (cmd->cur_sg) {
+		struct msghdr msg = {
+			.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
+		};
 		struct page *page = sg_page(cmd->cur_sg);
+		struct bio_vec bvec;
 		u32 left = cmd->cur_sg->length - cmd->offset;
-		int flags = MSG_DONTWAIT;
 
 		if ((!last_in_batch && cmd->queue->send_list_len) ||
 		    cmd->wbytes_done + left < cmd->req.transfer_len ||
 		    queue->data_digest || !queue->nvme_sq.sqhd_disabled)
-			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+			msg.msg_flags |= MSG_MORE;
 
-		ret = kernel_sendpage(cmd->queue->sock, page, cmd->offset,
-					left, flags);
+		bvec_set_page(&bvec, page, left, cmd->offset);
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, left);
+		ret = sock_sendmsg(cmd->queue->sock, &msg);
 		if (ret <= 0)
 			return ret;
 
@@ -649,18 +657,20 @@ static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 static int nvmet_try_send_response(struct nvmet_tcp_cmd *cmd,
 		bool last_in_batch)
 {
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES, };
+	struct bio_vec bvec;
 	u8 hdgst = nvmet_tcp_hdgst_len(cmd->queue);
 	int left = sizeof(*cmd->rsp_pdu) - cmd->offset + hdgst;
-	int flags = MSG_DONTWAIT;
 	int ret;
 
 	if (!last_in_batch && cmd->queue->send_list_len)
-		flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+		msg.msg_flags |= MSG_MORE;
 	else
-		flags |= MSG_EOR;
+		msg.msg_flags |= MSG_EOR;
 
-	ret = kernel_sendpage(cmd->queue->sock, virt_to_page(cmd->rsp_pdu),
-		offset_in_page(cmd->rsp_pdu) + cmd->offset, left, flags);
+	bvec_set_virt(&bvec, (void *)cmd->rsp_pdu + cmd->offset, left);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, left);
+	ret = sock_sendmsg(cmd->queue->sock, &msg);
 	if (ret <= 0)
 		return ret;
 	cmd->offset += ret;
@@ -677,18 +687,20 @@ static int nvmet_try_send_response(struct nvmet_tcp_cmd *cmd,
 
 static int nvmet_try_send_r2t(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 {
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES, };
+	struct bio_vec bvec;
 	u8 hdgst = nvmet_tcp_hdgst_len(cmd->queue);
 	int left = sizeof(*cmd->r2t_pdu) - cmd->offset + hdgst;
-	int flags = MSG_DONTWAIT;
 	int ret;
 
 	if (!last_in_batch && cmd->queue->send_list_len)
-		flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+		msg.msg_flags |= MSG_MORE;
 	else
-		flags |= MSG_EOR;
+		msg.msg_flags |= MSG_EOR;
 
-	ret = kernel_sendpage(cmd->queue->sock, virt_to_page(cmd->r2t_pdu),
-		offset_in_page(cmd->r2t_pdu) + cmd->offset, left, flags);
+	bvec_set_virt(&bvec, (void *)cmd->r2t_pdu + cmd->offset, left);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, left);
+	ret = sock_sendmsg(cmd->queue->sock, &msg);
 	if (ret <= 0)
 		return ret;
 	cmd->offset += ret;


