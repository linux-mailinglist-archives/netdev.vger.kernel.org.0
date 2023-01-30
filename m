Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1B6808CC
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbjA3JY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbjA3JXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB62DE79;
        Mon, 30 Jan 2023 01:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PasJ3iDfX2TllVLQ6e7N8/T+ZQHWRBi9Mi0fIgNsQxA=; b=SyOpTX9CZKgu/mdg93Px99ohqU
        lpY5+Plpyd7Zy3mO80AFoiDBWvs4Fx74nS7dp1CeTeZRYGYVgZlN3xShKOlsqOHMR8YDIfD97TAOl
        i6DuUXOwtd+Qsu7XWKS9q2lROG9nFii2MJjf2cIawTQo8pmmmRvWWh3yI3j64SspCOd4hOaDYQT59
        IxVhU3Tj/X05Ke06JXfdsywRjVOFjJJT2OqUrGdoAw1YlbWzSVrtgtw54YyS4zmtMPEU8NVcbK/29
        hwDgey6wC2KTsvdLDoGO0KUy407IzJh0Nss1p0gnq5DmSbrdtNR41EirSVoNLrufaOEJ9Q1DMff9S
        /WQX3d/Q==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQMw-002o87-6w; Mon, 30 Jan 2023 09:22:30 +0000
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
Subject: [PATCH 08/23] rbd: use bvec_set_page to initialize the copy up bvec
Date:   Mon, 30 Jan 2023 10:21:42 +0100
Message-Id: <20230130092157.1759539-9-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230130092157.1759539-1-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,NO_DNS_FOR_FROM,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize the copy up bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 04453f4a319cb4..1faca7e07a4d52 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3068,13 +3068,12 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
 
 	for (i = 0; i < obj_req->copyup_bvec_count; i++) {
 		unsigned int len = min(obj_overlap, (u64)PAGE_SIZE);
+		struct page *page = alloc_page(GFP_NOIO);
 
-		obj_req->copyup_bvecs[i].bv_page = alloc_page(GFP_NOIO);
-		if (!obj_req->copyup_bvecs[i].bv_page)
+		if (!page)
 			return -ENOMEM;
 
-		obj_req->copyup_bvecs[i].bv_offset = 0;
-		obj_req->copyup_bvecs[i].bv_len = len;
+		bvec_set_page(&obj_req->copyup_bvecs[i], page, len, 0);
 		obj_overlap -= len;
 	}
 
-- 
2.39.0

