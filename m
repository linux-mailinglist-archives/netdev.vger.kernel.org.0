Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00A6680919
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbjA3J0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjA3JZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:25:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0632FCD3;
        Mon, 30 Jan 2023 01:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/tbj/Tg5whekQ1nWXF3p7MKn9zbAs7XJmrxsAI8qP60=; b=xV25GZjMyWU+4JGmYdpveIpUhP
        MvUBg+0AGQ4cUbqnzgS5sBDTXnqtwa7wVQL/txup6BH72LNq11j+ASL+GP6Ibue6t7wZREu3rUD1l
        AbM+a9D4pvYCaOdcGlHWcEAPnUjRJfD7qL+Ec4haykBrsXqebtLBTfOzYEnuNsXcjCaaIrOmD+ztq
        2JXHp7gUfawgcgXQeeYMy7wfb7NKSz3L9UdWz8jhsCHlQU1PdTMj+77eXPkBEtZwJbklE0+6NhWXJ
        sYARddyVpzWrCXb6bGEWE7jP7S97NALXNFekXFrTAc58YTwg3nKtsaWoeAg5DvHQiBSK7BtPBNU5S
        UhaRvYWw==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQN9-002oCh-OO; Mon, 30 Jan 2023 09:22:44 +0000
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
Date:   Mon, 30 Jan 2023 10:21:46 +0100
Message-Id: <20230130092157.1759539-13-hch@lst.de>
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
 fs/ceph/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 764598e1efd91f..6419dce7c57987 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
 		size += bytes;
 
 		for ( ; bytes; idx++, bvec_idx++) {
-			struct bio_vec bv = {
-				.bv_page = pages[idx],
-				.bv_len = min_t(int, bytes, PAGE_SIZE - start),
-				.bv_offset = start,
-			};
+			struct bio_vec bv;
+
+			bvec_set_page(&bv, pages[idx], 
+				      min_t(int, bytes, PAGE_SIZE - start),
+				      start);
 
 			bvecs[bvec_idx] = bv;
 			bytes -= bv.bv_len;
-- 
2.39.0

