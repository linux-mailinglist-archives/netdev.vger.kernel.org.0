Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31E0689D1B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbjBCPIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjBCPHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:07:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552EFA0EA5;
        Fri,  3 Feb 2023 07:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WNOyAXyw5xLCthfoZy3e9p002HqnVw4VbBE86ULx41A=; b=hU1CqlCryou0nt23x7WKfgr9Yr
        Ze5pIoPK6R4xw6mzaF8Q13tT8AMdmc2pWHsPTaFT1tqAz0xMyzYUxgmuYr7ZpV+P+Fg+FuAqTYxaR
        o0KZ4xD9kRy/O3CUuF5ORgePKTIyprfQ/wp+cqJo9oLWqqRHk/tD6t2wSyKvk/7ne3sAsqWVXTNxc
        wjcc81M/GPoPtNKhO0d0cqBNfOSWqvGO/JfvXq+qWQ8QuWBiBrSBvCXZDh5P7DRYTIH5DD3oowHRu
        s28l5RjE8e6R6oXed9bn5RpUQB7Y+rkkaRQv759E+VNBc92z5H+MHU4P4MwaAFy/2mreTkAfweGEw
        Yz+nSGhQ==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxeY-002ank-IB; Fri, 03 Feb 2023 15:07:03 +0000
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
Date:   Fri,  3 Feb 2023 16:06:19 +0100
Message-Id: <20230203150634.3199647-9-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230203150634.3199647-1-hch@lst.de>
References: <20230203150634.3199647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize the copy up bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
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

