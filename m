Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6017168092A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbjA3J0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbjA3JZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:25:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA3E2E805;
        Mon, 30 Jan 2023 01:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H8iGXniDuXNIMcEmftwucE48paWcF0Q5NpfWk1xxHIY=; b=vkfX3QmxaSI2iuDWWBVAgfs1Zx
        WJgWRBZS7ip4JAwCZLPFbMDGoA3ScG/xVr/qTFJBprf38vBJubWVSkw8js6gVYVnfwnFL+8PuIkb/
        3yIl/CnpBrFD4S/rUHc+8WzsJa3K7jDwAxYnX4tDOoXxTKGOmk355NCt78K71n7tEwRPNCtLZAVlN
        H0LUQyAGSYaSYwAAVj2vSxCeHizSWaCYlNT46D2TwkYR/HUhHibiarLafpbjqha+BpY01EKupxqcY
        kdkPUzsSd0uCI3yzdLhyQyxBNhLUCkR2LeXlbT+l1gjTCxSMzBomsRY67f1NNwpM3QsXMl7elLsVM
        i0BMP0YA==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQNW-002oKh-HS; Mon, 30 Jan 2023 09:23:07 +0000
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
Subject: [PATCH 18/23] io_uring: use bvec_set_page to initialize a bvec
Date:   Mon, 30 Jan 2023 10:21:52 +0100
Message-Id: <20230130092157.1759539-19-hch@lst.de>
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

Use the bvec_set_page helper to initialize a bvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/rsrc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 18de10c68a151b..a59fc02de5983c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1237,9 +1237,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		size_t vec_len;
 
 		vec_len = min_t(size_t, size, PAGE_SIZE - off);
-		imu->bvec[i].bv_page = pages[i];
-		imu->bvec[i].bv_len = vec_len;
-		imu->bvec[i].bv_offset = off;
+		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
 		off = 0;
 		size -= vec_len;
 	}
-- 
2.39.0

