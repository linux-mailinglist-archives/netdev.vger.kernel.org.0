Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256E4689D4A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjBCPIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbjBCPIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:08:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AA45BAE;
        Fri,  3 Feb 2023 07:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NE7sXkVgEfW+BeR3L//yGcuDdB7IsjAlK/DMIBSqu7s=; b=Fnp2jdWYwTMeXbFAtIvQJYNyQa
        WjxRrbcqlA+uZSnkDXcvF3dawsJcLTYFwDLsZpSEdD3p0mAI5oPEH0MgdQwtTmcsdRUlT4/hPTTNv
        5W2SQzUVH614kF+/yXtuNxk+euPwDwTlrNXF584VKES2RwzzWDRe4Wcm3IdLqhGjdBw+ZmCW2y32Y
        z/uflXsj/D+flVPW5oPqHSjieXrEKDnDtsbIZ3MG8mKAME+0M542GyP/3Zyi8JaWgTOwxUTTLPZxx
        x5BNmyk84X8G5phlnQhcTWFZU/CFzC5luKWY771AIOrD85rcQY7rqjLT8p2eCbdfUfCLs2UqdR/bv
        NhlHME6w==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxen-002awC-7J; Fri, 03 Feb 2023 15:07:17 +0000
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
Subject: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
Date:   Fri,  3 Feb 2023 16:06:23 +0100
Message-Id: <20230203150634.3199647-13-hch@lst.de>
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

Use the bvec_set_page helper to initialize a bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ceph/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 764598e1efd91f..90b2aa7963bf29 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -103,14 +103,10 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
 		size += bytes;
 
 		for ( ; bytes; idx++, bvec_idx++) {
-			struct bio_vec bv = {
-				.bv_page = pages[idx],
-				.bv_len = min_t(int, bytes, PAGE_SIZE - start),
-				.bv_offset = start,
-			};
-
-			bvecs[bvec_idx] = bv;
-			bytes -= bv.bv_len;
+			int len = min_t(int, bytes, PAGE_SIZE - start);
+
+			bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
+			bytes -= len;
 			start = 0;
 		}
 	}
-- 
2.39.0

