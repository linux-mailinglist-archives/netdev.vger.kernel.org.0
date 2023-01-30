Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4499B6808F4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbjA3JYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbjA3JYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:24:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80142ED4D;
        Mon, 30 Jan 2023 01:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=waVJAjm2FM0jvuh0ozqoP97gMNRNVBgPKhaSSg5Yxhg=; b=QTYv8MI6OQAM8sT2MzrC8lgZb2
        L7Ft8VBeI/rYi4wvdhNRIkk+89gbjy9aIv1X4usSq3UcRbM2VqLo2MpOUC+5qfxyguvoWKr5GHx64
        tYSYgh1k523R3StIKwtgPkxLbHoU0OskEf2l+H4ySafLO43GnmfafqNMYzVkxE+/8/4poWzaTQ/lp
        lqbYjeu9vuT/c1tSwraqQ+I68EOddD4ZaKS3cKZcGo/Z7QETCvghPhHpksAPizeLr7o5lXtEdKHIo
        O5+0BsnFwGf+zWUiSaEhgD41XRRwmBfnaknYFcKCzkYl5E0zbVQ6v339RIqSGz2riXL0D2RB56RfS
        qRVU0BNA==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQN4-002oBB-0G; Mon, 30 Jan 2023 09:22:38 +0000
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
Subject: [PATCH 11/23] afs: use bvec_set_folio to initialize a bvec
Date:   Mon, 30 Jan 2023 10:21:45 +0100
Message-Id: <20230130092157.1759539-12-hch@lst.de>
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

Use the bvec_set_folio helper to initialize a bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/afs/write.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 19df10d63323d8..2d17891b618e6e 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -992,7 +992,7 @@ int afs_launder_folio(struct folio *folio)
 {
 	struct afs_vnode *vnode = AFS_FS_I(folio_inode(folio));
 	struct iov_iter iter;
-	struct bio_vec bv[1];
+	struct bio_vec bv;
 	unsigned long priv;
 	unsigned int f, t;
 	int ret = 0;
@@ -1008,10 +1008,8 @@ int afs_launder_folio(struct folio *folio)
 			t = afs_folio_dirty_to(folio, priv);
 		}
 
-		bv[0].bv_page = &folio->page;
-		bv[0].bv_offset = f;
-		bv[0].bv_len = t - f;
-		iov_iter_bvec(&iter, ITER_SOURCE, bv, 1, bv[0].bv_len);
+		bvec_set_folio(&bv, folio, t - f, f);
+		iov_iter_bvec(&iter, ITER_SOURCE, &bv, 1, bv.bv_len);
 
 		trace_afs_folio_dirty(vnode, tracepoint_string("launder"), folio);
 		ret = afs_store_data(vnode, &iter, folio_pos(folio) + f, true);
-- 
2.39.0

