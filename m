Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585B0280ED2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgJBI2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:28:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:49818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgJBI2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:28:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5843AAD31;
        Fri,  2 Oct 2020 08:28:15 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     davem@davemloft.net, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: [PATCH v10 3/7] nvme-tcp: check page by sendpage_ok() before calling kernel_sendpage()
Date:   Fri,  2 Oct 2020 16:27:30 +0800
Message-Id: <20201002082734.13925-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002082734.13925-1-colyli@suse.de>
References: <20201002082734.13925-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently nvme_tcp_try_send_data() doesn't use kernel_sendpage() to
send slab pages. But for pages allocated by __get_free_pages() without
__GFP_COMP, which also have refcount as 0, they are still sent by
kernel_sendpage() to remote end, this is problematic.

The new introduced helper sendpage_ok() checks both PageSlab tag and
page_count counter, and returns true if the checking page is OK to be
sent by kernel_sendpage().

This patch fixes the page checking issue of nvme_tcp_try_send_data()
with sendpage_ok(). If sendpage_ok() returns true, send this page by
kernel_sendpage(), otherwise use sock_no_sendpage to handle this page.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: stable@vger.kernel.org
---
 drivers/nvme/host/tcp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8f4f29f18b8c..d6a3e1487354 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -913,12 +913,11 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 		else
 			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
-		/* can't zcopy slab pages */
-		if (unlikely(PageSlab(page))) {
-			ret = sock_no_sendpage(queue->sock, page, offset, len,
+		if (sendpage_ok(page)) {
+			ret = kernel_sendpage(queue->sock, page, offset, len,
 					flags);
 		} else {
-			ret = kernel_sendpage(queue->sock, page, offset, len,
+			ret = sock_no_sendpage(queue->sock, page, offset, len,
 					flags);
 		}
 		if (ret <= 0)
-- 
2.26.2

