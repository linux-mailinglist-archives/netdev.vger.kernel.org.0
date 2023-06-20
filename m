Return-Path: <netdev+bounces-12284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C33736F92
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 17:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D891C2033E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E94D174CE;
	Tue, 20 Jun 2023 14:57:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F417721
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:57:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5131BEA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687273046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kX6Xzyb5DYMqpSrTmxybyUGZQ2hNwo35+Ji3qVw7rrY=;
	b=XtfZnuboBiIr6C5qukcWb9WHvFuYiruLl5511F1GWJtxEnbGG4Ollh3DAI+sMc2+OzVpQv
	1SzFP8u8mNff5+9KBv5ocN6UPE7voghzgCpiCNE99V7CE26TSSBmVzKweL33UpuTACKJqG
	ZOsLqBFePTMPh2j8BqrW6ktttUwJ4K0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-ICwZLUEsPqKT1b5qYpONaQ-1; Tue, 20 Jun 2023 10:57:22 -0400
X-MC-Unique: ICwZLUEsPqKT1b5qYpONaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D7458B5AF6;
	Tue, 20 Jun 2023 14:54:25 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 554F914682FA;
	Tue, 20 Jun 2023 14:54:23 +0000 (UTC)
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
	Sagi Grimberg <sagi@grimberg.me>,
	Willem de Bruijn <willemb@google.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-nvme@lists.infradead.org
Subject: [PATCH net-next v3 10/18] nvme/host: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date: Tue, 20 Jun 2023 15:53:29 +0100
Message-ID: <20230620145338.1300897-11-dhowells@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header, data
pages and trailer.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Sagi Grimberg <sagi@grimberg.me>
Acked-by: Willem de Bruijn <willemb@google.com>
cc: Keith Busch <kbusch@kernel.org>
cc: Jens Axboe <axboe@fb.com>
cc: Christoph Hellwig <hch@lst.de>
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

Notes:
    ver #2)
     - Wrap lines at 80.
    
    ver #3)
     - Split nvme/host from nvme/target changes.

 drivers/nvme/host/tcp.c | 46 +++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index bf0230442d57..6f31cdbb696a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -997,25 +997,25 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 	u32 h2cdata_left = req->h2cdata_left;
 
 	while (true) {
+		struct bio_vec bvec;
+		struct msghdr msg = {
+			.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
+		};
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
 
@@ -1054,22 +1054,24 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
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
 
@@ -1093,6 +1095,8 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	struct nvme_tcp_data_pdu *pdu = nvme_tcp_req_data_pdu(req);
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_MORE, };
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) - req->offset + hdgst;
 	int ret;
@@ -1101,13 +1105,11 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
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
 


