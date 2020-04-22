Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF51B491B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgDVPuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:50:19 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:22345 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgDVPuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:50:19 -0400
Received: from vishal.asicdesigners.com (ashwini.asicdesigners.com [10.193.177.145] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 03MFoC95001483;
        Wed, 22 Apr 2020 08:50:13 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net] cxgb4: fix adapter crash due to wrong MC size
Date:   Wed, 22 Apr 2020 21:20:07 +0530
Message-Id: <20200422155007.17216-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the absence of MC1, the size calculation function
cudbg_mem_region_size() was returing wrong MC size and
resulted in adapter crash. This patch adds new argument
to cudbg_mem_region_size() which will have actual size
and returns error to caller in the absence of MC1.

Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 19c11568113a..7b9cd69f9844 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1049,9 +1049,9 @@ static void cudbg_t4_fwcache(struct cudbg_init *pdbg_init,
 	}
 }
 
-static unsigned long cudbg_mem_region_size(struct cudbg_init *pdbg_init,
-					   struct cudbg_error *cudbg_err,
-					   u8 mem_type)
+static int cudbg_mem_region_size(struct cudbg_init *pdbg_init,
+				 struct cudbg_error *cudbg_err,
+				 u8 mem_type, unsigned long *region_size)
 {
 	struct adapter *padap = pdbg_init->adap;
 	struct cudbg_meminfo mem_info;
@@ -1060,15 +1060,23 @@ static unsigned long cudbg_mem_region_size(struct cudbg_init *pdbg_init,
 
 	memset(&mem_info, 0, sizeof(struct cudbg_meminfo));
 	rc = cudbg_fill_meminfo(padap, &mem_info);
-	if (rc)
+	if (rc) {
+		cudbg_err->sys_err = rc;
 		return rc;
+	}
 
 	cudbg_t4_fwcache(pdbg_init, cudbg_err);
 	rc = cudbg_meminfo_get_mem_index(padap, &mem_info, mem_type, &mc_idx);
-	if (rc)
+	if (rc) {
+		cudbg_err->sys_err = rc;
 		return rc;
+	}
+
+	if (region_size)
+		*region_size = mem_info.avail[mc_idx].limit -
+			       mem_info.avail[mc_idx].base;
 
-	return mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+	return 0;
 }
 
 static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
@@ -1076,7 +1084,12 @@ static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
 				    struct cudbg_error *cudbg_err,
 				    u8 mem_type)
 {
-	unsigned long size = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type);
+	unsigned long size = 0;
+	int rc;
+
+	rc = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type, &size);
+	if (rc)
+		return rc;
 
 	return cudbg_read_fw_mem(pdbg_init, dbg_buff, mem_type, size,
 				 cudbg_err);
-- 
2.21.1

