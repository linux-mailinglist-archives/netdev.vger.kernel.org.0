Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ABE68093A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbjA3J0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbjA3J0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:26:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB12B09E;
        Mon, 30 Jan 2023 01:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0OKWMBRutlSAGY543ff9AUr9eECMFxK84Mqoa+H011w=; b=TGW1NtTwMqIanaIKWqoOD1aWmB
        n/scJWrL64fK9k4OmvwoP0vaCMaQaJe9Y+VWY3W+oBkV4Zz5KRTgvvNzhTLAybTpNMypmc86NpWuW
        A6DJic9z1tz1F4S9KHSq9PGe7EQLxke9ZXXIQgiJFf/NHyDM8LsAsGYTs8K1VSljQIgpxA6Q8vcN+
        gkxoIqC9mz7btGrNG99XQEzTqkFz5So1CSl68dtRz5SSJVkhT79kCZOQhxXhh4kdvmuik+6cQ/s3J
        VzbxJG4gwIVB1atsV9i4jRnuqB9m3/Merfm1mu0MlDBtg87/cIKBrDvFskOHTF/k9hYJjdm93ZoXU
        OJuPg8Fw==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQNd-002oNl-Oa; Mon, 30 Jan 2023 09:23:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 20/23] rxrpc: use bvec_set_page to initialize a bvec
Date:   Mon, 30 Jan 2023 10:21:54 +0100
Message-Id: <20230130092157.1759539-21-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230130092157.1759539-1-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize a bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/rxrpc/rxperf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 16dcabb71ebe16..4a2e90015ca72c 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -493,7 +493,7 @@ static int rxperf_deliver_request(struct rxperf_call *call)
 static int rxperf_process_call(struct rxperf_call *call)
 {
 	struct msghdr msg = {};
-	struct bio_vec bv[1];
+	struct bio_vec bv;
 	struct kvec iov[1];
 	ssize_t n;
 	size_t reply_len = call->reply_len, len;
@@ -503,10 +503,8 @@ static int rxperf_process_call(struct rxperf_call *call)
 
 	while (reply_len > 0) {
 		len = min_t(size_t, reply_len, PAGE_SIZE);
-		bv[0].bv_page	= ZERO_PAGE(0);
-		bv[0].bv_offset	= 0;
-		bv[0].bv_len	= len;
-		iov_iter_bvec(&msg.msg_iter, WRITE, bv, 1, len);
+		bvec_set_page(&bv, ZERO_PAGE(0), len, 0);
+		iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, len);
 		msg.msg_flags = MSG_MORE;
 		n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
 					   len, rxperf_notify_end_reply_tx);
-- 
2.39.0

