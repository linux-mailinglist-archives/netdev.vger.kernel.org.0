Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D300680920
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbjA3J0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbjA3JZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:25:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB112FCF0;
        Mon, 30 Jan 2023 01:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iTork4lgSqwAnNzEK3lzK1UwHk37chVOVoUGPRhe1ko=; b=Qx6f/vAlt0702Bw2gaA0yw3fMn
        DSbWXckp85GKL6x2K0wVZWlmBP/HHAMGhBrYB08/Vlm/YRJQCq3kI3xMG/WASmjfzQ5X57qRgvH1M
        aDf2q/VfFfkAfOqqUqPetL8Nnll6XIjG7NgvoDUHbD0cnB+MO8UuF7ljYLg4f4YTGaLPU4yXfmMbt
        xSZ2xC24sTznBHqPUwQ2KOdIbwsTxD5YqcKUievCZTrFdiYRp348Iffsdx6IiKzBdbwdD1fWYnp87
        CKqOs2Hi1NMEf6sOsnEZOuE8nGXc6MpsuZ0+93w6fPSfAyQf9ElR2gHbrsn8rljB8JPoxhMSuKyqW
        Ecg9ip0g==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQNF-002oFW-6t; Mon, 30 Jan 2023 09:22:49 +0000
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
Subject: [PATCH 14/23] coredump: use bvec_set_page to initialize a bvec
Date:   Mon, 30 Jan 2023 10:21:48 +0100
Message-Id: <20230130092157.1759539-15-hch@lst.de>
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
 fs/coredump.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index de78bde2991beb..0a6873a9c4d0cd 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -840,11 +840,7 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 
 static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 {
-	struct bio_vec bvec = {
-		.bv_page	= page,
-		.bv_offset	= 0,
-		.bv_len		= PAGE_SIZE,
-	};
+	struct bio_vec bvec;
 	struct iov_iter iter;
 	struct file *file = cprm->file;
 	loff_t pos;
@@ -860,6 +856,7 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	if (dump_interrupted())
 		return 0;
 	pos = file->f_pos;
+	bvec_set_page(&bvec, page, PAGE_SIZE, 0);
 	iov_iter_bvec(&iter, ITER_SOURCE, &bvec, 1, PAGE_SIZE);
 	n = __kernel_write_iter(cprm->file, &iter, &pos);
 	if (n != PAGE_SIZE)
-- 
2.39.0

