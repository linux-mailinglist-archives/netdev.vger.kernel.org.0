Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D96C689DBA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbjBCPMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbjBCPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:11:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A2CA841A;
        Fri,  3 Feb 2023 07:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=h+lHe/qj9+NLcJnalyqirfAInpcSjbUKRj83r5gu0OY=; b=opeqTYIsDd5ySHkM8/Z17yOBYI
        EYj/TALLVbPcdK9L0xzB5abV1zpI5xqkO2L2YF6MxMZvyva0gUzw7pgM34AaCSLiLPIiDfg6ywwlE
        p/uz0Hp+FcwrBScWBZ4n4X2ams8XcFdxqkklIPUnlIp6crcuB/NPS5dJIyr64dZwb44pwvjVg1Idr
        gjtWxsXOoyGZV1XK5Kjfjy+OQZ/3a8RJDFtiI3W/17L8wvNj+WCY1iJfsOS/RvmqrXRrNn9ZnCGQY
        VbPrXwoOPchaeJVVKF+sqRUov+yXi3gGw6ZN19Dh+G7on2Pg9/Hv3nMZoM1b+AA1D0a86INXiHkNn
        kOEksMvg==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxfB-002bFh-IR; Fri, 03 Feb 2023 15:07:42 +0000
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
Subject: [PATCH 19/23] swap: use bvec_set_page to initialize bvecs
Date:   Fri,  3 Feb 2023 16:06:30 +0100
Message-Id: <20230203150634.3199647-20-hch@lst.de>
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

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 3a5f921b932e82..233f6e6eb1c508 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -318,9 +318,7 @@ static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 		sio->pages = 0;
 		sio->len = 0;
 	}
-	sio->bvec[sio->pages].bv_page = page;
-	sio->bvec[sio->pages].bv_len = thp_size(page);
-	sio->bvec[sio->pages].bv_offset = 0;
+	bvec_set_page(&sio->bvec[sio->pages], page, thp_size(page), 0);
 	sio->len += thp_size(page);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
@@ -432,9 +430,7 @@ static void swap_readpage_fs(struct page *page,
 		sio->pages = 0;
 		sio->len = 0;
 	}
-	sio->bvec[sio->pages].bv_page = page;
-	sio->bvec[sio->pages].bv_len = thp_size(page);
-	sio->bvec[sio->pages].bv_offset = 0;
+	bvec_set_page(&sio->bvec[sio->pages], page, thp_size(page), 0);
 	sio->len += thp_size(page);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
-- 
2.39.0

