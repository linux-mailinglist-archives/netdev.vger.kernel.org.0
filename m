Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7240689D92
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjBCPJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbjBCPIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:08:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78BBFF16;
        Fri,  3 Feb 2023 07:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dTKHKRVOiZxguFuEK9aGNi2iPJtbueeyhuxlyEfvmCc=; b=ULLWnIwzUEY6/Q9qVLO7gvw8+M
        XsquPGePTfZjP71b/MLnNmfVIaXdCxfgge7DX2eGe+aN1hNlVP8iNAHk3pdpMmw6X6XyWKRLwXxD1
        SaFjagBM0qpcLD4IijuTRJSPdNtwoh4gCxAi/L2yCyhGidBHFlB54moxrLT1CExRm7Qqk0oPRC3QF
        UztvULRJdPUYIYff571U59dCOzSWdY1aio0h51LL7NmLO9oUnqLBJjGB66OPdgeSs41hpd6cdOYoX
        /GPjwx4gaHfw2ikNfMjjpM+lD07l/GZC7P4wkmWbqemcZIiGRC8zjRr9UFx1SoNfbMlMuFli+EJdN
        XKD8CnIA==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxf4-002b8L-GQ; Fri, 03 Feb 2023 15:07:34 +0000
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
Subject: [PATCH 17/23] splice: use bvec_set_page to initialize a bvec
Date:   Fri,  3 Feb 2023 16:06:28 +0100
Message-Id: <20230203150634.3199647-18-hch@lst.de>
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
 fs/splice.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 5969b7a1d353a8..87d9b19349de63 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -675,9 +675,8 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				goto done;
 			}
 
-			array[n].bv_page = buf->page;
-			array[n].bv_len = this_len;
-			array[n].bv_offset = buf->offset;
+			bvec_set_page(&array[n], buf->page, this_len,
+				      buf->offset);
 			left -= this_len;
 			n++;
 		}
-- 
2.39.0

