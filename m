Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC19E359DFF
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhDILyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:54:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16864 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhDILyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:54:20 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FGxLc0DBnz9x87;
        Fri,  9 Apr 2021 19:51:52 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.176.196) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 19:53:55 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <rajur@chelsio.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Qiheng Lin <linqiheng@huawei.com>
Subject: [PATCH net-next] cxgb4: remove unneeded if-null-free check
Date:   Fri, 9 Apr 2021 19:53:39 +0800
Message-ID: <20210409115339.4598-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.176.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:529:3-9: WARNING:
 NULL check before some freeing functions is not needed.
drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:533:2-8: WARNING:
 NULL check before some freeing functions is not needed.
drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:161:2-7: WARNING:
 NULL check before some freeing functions is not needed.
drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:327:3-9: WARNING:
 NULL check before some freeing functions is not needed.

Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c     | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c | 8 ++------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index ce28820c57c9..12fcf84d67ad 100644
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
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
index 77648e4ab4cc..dd66b244466d 100644
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
index dede02505ceb..a5d2f84dcdd5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -524,13 +524,9 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
 out_no_mem:
 	for (i = 0; i < t->size; i++) {
 		struct cxgb4_link *link = &t->table[i];
-
-		if (link->tid_map)
-			kvfree(link->tid_map);
+		kvfree(link->tid_map);
 	}
-
-	if (t)
-		kvfree(t);
+	kvfree(t);
 
 	return NULL;
 }
-- 
2.31.1

