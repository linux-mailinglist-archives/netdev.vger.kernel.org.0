Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5A6808A9
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbjA3JX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjA3JXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D3B125B7;
        Mon, 30 Jan 2023 01:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qHieNPI7z3sFtodokWVnoougmLvZVnqE3Y/VparMyFY=; b=ODubD1C2BRMqrFChW7fD2/w9bG
        Bek9dBQcKN5N+ru2staBvvFXiwAiWim7hYwhHUZGSLXX24jbnEbAqdmS5Ajj9+NlnFCavBXfsfhs3
        XI6lzCu2GeqKtRgevITrArS3zGcwLMRZMxlr4utu1juNhvass81bDd906uTcf5xiZsb6cCOqyl8nK
        m98KeGJ9SE/V3c3ZRyUJeGtRoQ5nsh6i4jGrfSPRpVbUu4hyqMBJxi9JGDZJNhoGK0a94aCuKbtu8
        rmmcphUXaeiu9gmh/7++19/XF9wkSuRyP7q7ZgI/exYaX7pXYil/gd10qOnCgTC3hp+S0hEq97BKO
        qjR+Sy/Q==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQMh-002o1D-D3; Mon, 30 Jan 2023 09:22:15 +0000
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
Subject: [PATCH 03/23] block: add a bvec_set_virt helper
Date:   Mon, 30 Jan 2023 10:21:37 +0100
Message-Id: <20230130092157.1759539-4-hch@lst.de>
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

A small wrapper around bvec_set_page for callers that have a virtual
address.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bvec.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f094512ce3bda9..7031d83af02267 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -63,6 +63,18 @@ static inline void bvec_set_folio(struct bio_vec *bv, struct folio *folio,
 	bvec_set_page(bv, &folio->page, len, offset);
 }
 
+/**
+ * bvec_set_virt - initialize a bvec based on a virtual address
+ * @bv:		bvec to initialize
+ * @vaddr:	virtual address to set the bvec to
+ * @len:	length of the bvec
+ */
+static inline void bvec_set_virt(struct bio_vec *bv, void *vaddr,
+		unsigned int len)
+{
+	bvec_set_page(bv, virt_to_page(vaddr), len, offset_in_page(vaddr));
+}
+
 struct bvec_iter {
 	sector_t		bi_sector;	/* device address in 512 byte
 						   sectors */
-- 
2.39.0

