Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8B6808B4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjA3JYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbjA3JXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74822BF3F;
        Mon, 30 Jan 2023 01:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mraJ0dlvK0XwWYXGT0DcPLxhMI+ORe9CMkm05FoHT2s=; b=xOHsjob9PMRyKJ4ILlqtTtT2a1
        BSDOhN5jc440njcpUba2nJJn4oWzHKlh5DYh9s2DBTQtSytoXVfg4egryfmJiUwA01qRqHZMyDpJp
        k41/6F52tAyqKs8+FJOHLgI6idVUYxVWw63f6ikxbMTvsonHwp2rvU8xER17XbkQQKwuPuEorYONu
        lBoFR+e+It6xCOx7b04q0jrJemUo+IGk3r0FJ+y3wfCceEClP5rP1JfvxWkw6DvlJRuxLS8JZSWNH
        vd36DpSVg9AJW+qEayHR4sasRkMheP1AdnGvgFgKp2vugbGtPTxQCn4k0/VQoq9AZDuR9Q9Nfmonk
        fGtYvRqg==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQMo-002o3h-6D; Mon, 30 Jan 2023 09:22:22 +0000
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
Subject: [PATCH 05/23] target: use bvec_set_page to initialize bvecs
Date:   Mon, 30 Jan 2023 10:21:39 +0100
Message-Id: <20230130092157.1759539-6-hch@lst.de>
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

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index fd584111da45c0..ce0e000b74fc39 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -281,10 +281,8 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
-		aio_cmd->bvecs[i].bv_page = sg_page(sg);
-		aio_cmd->bvecs[i].bv_len = sg->length;
-		aio_cmd->bvecs[i].bv_offset = sg->offset;
-
+		bvec_set_page(&aio_cmd->bvecs[i], sg_page(sg), sg->length,
+			      sg->offset);
 		len += sg->length;
 	}
 
@@ -329,10 +327,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 	}
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
-		bvec[i].bv_page = sg_page(sg);
-		bvec[i].bv_len = sg->length;
-		bvec[i].bv_offset = sg->offset;
-
+		bvec_set_page(&bvec[i], sg_page(sg), sg->length, sg->offset);
 		len += sg->length;
 	}
 
@@ -465,10 +460,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	for (i = 0; i < nolb; i++) {
-		bvec[i].bv_page = sg_page(&cmd->t_data_sg[0]);
-		bvec[i].bv_len = cmd->t_data_sg[0].length;
-		bvec[i].bv_offset = cmd->t_data_sg[0].offset;
-
+		bvec_set_page(&bvec[i], sg_page(&cmd->t_data_sg[0]),
+			      cmd->t_data_sg[0].length,
+			      cmd->t_data_sg[0].offset);
 		len += se_dev->dev_attrib.block_size;
 	}
 
-- 
2.39.0

