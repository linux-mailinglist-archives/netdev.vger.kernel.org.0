Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823F2F31A9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbfKGOi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:38:57 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6169 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfKGOi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 09:38:57 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 57C3D9DAF4E7248871DB;
        Thu,  7 Nov 2019 22:38:46 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 7 Nov 2019
 22:38:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] cxgb4: Use match_string() helper to simplify the code
Date:   Thu, 7 Nov 2019 22:35:58 +0800
Message-ID: <20191107143558.44208-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

match_string() returns the array index of a matching string.
Use it instead of the open-coded implementation.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index c2e9278..50ad135 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/sort.h>
+#include <linux/string.h>
 
 #include "t4_regs.h"
 #include "cxgb4.h"
@@ -776,24 +777,18 @@ static int cudbg_get_mem_region(struct adapter *padap,
 				struct cudbg_mem_desc *mem_desc)
 {
 	u8 mc, found = 0;
-	u32 i, idx = 0;
-	int rc;
+	u32 idx = 0;
+	int rc, i;
 
 	rc = cudbg_meminfo_get_mem_index(padap, meminfo, mem_type, &mc);
 	if (rc)
 		return rc;
 
-	for (i = 0; i < ARRAY_SIZE(cudbg_region); i++) {
-		if (!strcmp(cudbg_region[i], region_name)) {
-			found = 1;
-			idx = i;
-			break;
-		}
-	}
-	if (!found)
+	i = match_string(cudbg_region, ARRAY_SIZE(cudbg_region), region_name);
+	if (i < 0)
 		return -EINVAL;
 
-	found = 0;
+	idx = i;
 	for (i = 0; i < meminfo->mem_c; i++) {
 		if (meminfo->mem[i].idx >= ARRAY_SIZE(cudbg_region))
 			continue; /* Skip holes */
-- 
2.7.4


