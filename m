Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085C068096E
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjA3J1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbjA3J1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:27:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40CD302A0;
        Mon, 30 Jan 2023 01:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=r7jFBCXbmxHB1tF8rt2BfZdisYi7y8611NyO0C6ZBqM=; b=IRSYebu92JqOTv8A5mkBlrCJoU
        soqPVK3Q3WkIDPk0g1kKyJ8lqXShiaM4/uHtHGG+1H107BE8gmKRpIIHCeQdhH3yGUk1mhuEMbGqS
        baor0Kd4SALd04/vAAxXA60oYEXu2Jz5URMvT1YHH/GGgw9NS5aIlUfmZPD3e3UYOtp8ZNZizARPL
        PCly0wXJiyK36Y8TqZBCQfpuFH9GgRgaKB5RmeGHQsLXp1ro2vk9RL5YGcyiYBzwL2h2TbxSKSJmK
        lespJWt10vPATdlaXFSrA72u2w5+VdDl7LSkRtNNhIcAgcJ1n0yVJSCb0YY+Y5AGY76RVoE4lzhaK
        SW038nYg==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQNv-002oS4-LT; Mon, 30 Jan 2023 09:23:32 +0000
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
Subject: [PATCH 22/23] vring: use bvec_set_page to initialize a bvec
Date:   Mon, 30 Jan 2023 10:21:56 +0100
Message-Id: <20230130092157.1759539-23-hch@lst.de>
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
 drivers/vhost/vringh.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 33eb941fcf1546..a1e27da544814a 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1126,9 +1126,8 @@ static int iotlb_translate(const struct vringh *vrh,
 		size = map->size - addr + map->start;
 		pa = map->addr + addr - map->start;
 		pfn = pa >> PAGE_SHIFT;
-		iov[ret].bv_page = pfn_to_page(pfn);
-		iov[ret].bv_len = min(len - s, size);
-		iov[ret].bv_offset = pa & (PAGE_SIZE - 1);
+		bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
+			      pa & (PAGE_SIZE - 1));
 		s += size;
 		addr += size;
 		++ret;
-- 
2.39.0

