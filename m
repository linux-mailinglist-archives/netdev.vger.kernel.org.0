Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782AB3048D3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388058AbhAZFjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:18 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44359 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730427AbhAZCvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:51:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMwR7au_1611629414;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMwR7au_1611629414)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Jan 2021 10:50:30 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, rajur@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH net-next] cxgb4: remove redundant NULL check
Date:   Tue, 26 Jan 2021 10:50:13 +0800
Message-Id: <1611629413-81373-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below warnings reported by coccicheck:
./drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:323:3-9: WARNING:
NULL check before some freeing functions is not needed.
./drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3554:2-8: WARNING:
NULL check before some freeing functions is not needed.
./drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:157:2-7: WARNING:
NULL check before some freeing functions is not needed.
./drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:525:3-9: WARNING:
NULL check before some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c     | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c | 6 ++----
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index ce28820..12fcf84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -323,8 +323,7 @@ void t4_cleanup_clip_tbl(struct adapter *adap)
 	struct clip_tbl *ctbl = adap->clipt;
 
 	if (ctbl) {
-		if (ctbl->cl_list)
-			kvfree(ctbl->cl_list);
+		kvfree(ctbl->cl_list);
 		kvfree(ctbl);
 	}
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 75474f8..94eb8a6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -3554,8 +3554,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 	}
 
 out_free:
-	if (data)
-		kvfree(data);
+	kvfree(data);
 
 #undef QDESC_GET_FLQ
 #undef QDESC_GET_RXQ
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
index 77648e4..dd66b24 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
@@ -157,8 +157,7 @@ static int cudbg_alloc_compress_buff(struct cudbg_init *pdbg_init)
 
 static void cudbg_free_compress_buff(struct cudbg_init *pdbg_init)
 {
-	if (pdbg_init->compress_buff)
-		vfree(pdbg_init->compress_buff);
+	vfree(pdbg_init->compress_buff);
 }
 
 int cxgb4_cudbg_collect(struct adapter *adap, void *buf, u32 *buf_size,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index dede025..97a811f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -525,12 +525,10 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
 	for (i = 0; i < t->size; i++) {
 		struct cxgb4_link *link = &t->table[i];
 
-		if (link->tid_map)
-			kvfree(link->tid_map);
+		kvfree(link->tid_map);
 	}
 
-	if (t)
-		kvfree(t);
+	kvfree(t);
 
 	return NULL;
 }
-- 
1.8.3.1

