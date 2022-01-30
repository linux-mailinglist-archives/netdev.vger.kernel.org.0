Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3094A3861
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355805AbiA3TGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 14:06:02 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:58628 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231596AbiA3TFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 14:05:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3BCwlk_1643569515;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3BCwlk_1643569515)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 31 Jan 2022 03:05:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA node
Date:   Mon, 31 Jan 2022 03:03:00 +0800
Message-Id: <20220130190259.94593-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, pages are allocated in the process context, for its NUMA node
isn't equal to ibdev's, which is not the best policy for performance.

Applications will generally perform best when the processes are
accessing memory on the same NUMA node. When numa_balancing enabled
(which is enabled by most of OS distributions), it moves tasks closer to
the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
to the same node usually. This reduces the latency when accessing remote
memory.

According to our tests in different scenarios, there has up to 15.30%
performance drop (Redis benchmark) when accessing remote memory.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8935ef4811b0..2a28b045edfa 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2065,9 +2065,10 @@ int smcr_buf_reg_lgr(struct smc_link *lnk)
 	return rc;
 }
 
-static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
+static struct smc_buf_desc *smcr_new_buf_create(struct smc_connection *conn,
 						bool is_rmb, int bufsize)
 {
+	int node = ibdev_to_node(conn->lnk->smcibdev->ibdev);
 	struct smc_buf_desc *buf_desc;
 
 	/* try to alloc a new buffer */
@@ -2076,10 +2077,10 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 		return ERR_PTR(-ENOMEM);
 
 	buf_desc->order = get_order(bufsize);
-	buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
-				      __GFP_NOMEMALLOC | __GFP_COMP |
-				      __GFP_NORETRY | __GFP_ZERO,
-				      buf_desc->order);
+	buf_desc->pages = alloc_pages_node(node, GFP_KERNEL | __GFP_NOWARN |
+					   __GFP_NOMEMALLOC | __GFP_COMP |
+					   __GFP_NORETRY | __GFP_ZERO,
+					   buf_desc->order);
 	if (!buf_desc->pages) {
 		kfree(buf_desc);
 		return ERR_PTR(-EAGAIN);
@@ -2190,7 +2191,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		if (is_smcd)
 			buf_desc = smcd_new_buf_create(lgr, is_rmb, bufsize);
 		else
-			buf_desc = smcr_new_buf_create(lgr, is_rmb, bufsize);
+			buf_desc = smcr_new_buf_create(conn, is_rmb, bufsize);
 
 		if (PTR_ERR(buf_desc) == -ENOMEM)
 			break;
-- 
2.32.0.3.g01195cf9f

