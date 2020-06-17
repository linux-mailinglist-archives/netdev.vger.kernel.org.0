Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BC71FC633
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgFQG3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:29:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11828 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFQG3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:29:43 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05H6TOkQ026703;
        Tue, 16 Jun 2020 23:29:39 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 5/5] cxgb4: add support to read serial flash
Date:   Wed, 17 Jun 2020 11:59:07 +0530
Message-Id: <20200617062907.26121-6-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200617062907.26121-1-vishal@chelsio.com>
References: <20200617062907.26121-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to dump flash memory via
ethtool --get-dump

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h |  3 +-
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 38 +++++++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.h    |  4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 14 +++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h  |  1 +
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h
index fc3813050f0d..c84719e3ca08 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h
@@ -70,7 +70,8 @@ enum cudbg_dbg_entity_type {
 	CUDBG_HMA_INDIRECT = 67,
 	CUDBG_HMA = 68,
 	CUDBG_QDESC = 70,
-	CUDBG_MAX_ENTITY = 71,
+	CUDBG_FLASH = 71,
+	CUDBG_MAX_ENTITY = 72,
 };
 
 struct cudbg_init {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 7b9cd69f9844..a09790989584 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -3156,3 +3156,41 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 
 	return rc;
 }
+
+int cudbg_collect_flash(struct cudbg_init *pdbg_init,
+			struct cudbg_buffer *dbg_buff,
+			struct cudbg_error *cudbg_err)
+{
+	struct adapter *padap = pdbg_init->adap;
+	u32 count = padap->params.sf_size, n;
+	struct cudbg_buffer temp_buff = {0};
+	u32 addr, i;
+	int rc;
+
+	addr = FLASH_EXP_ROM_START;
+
+	for (i = 0; i < count; i += SF_PAGE_SIZE) {
+		n = min_t(u32, count - i, SF_PAGE_SIZE);
+
+		rc = cudbg_get_buff(pdbg_init, dbg_buff, n, &temp_buff);
+		if (rc) {
+			cudbg_err->sys_warn = CUDBG_STATUS_PARTIAL_DATA;
+			goto out;
+		}
+		rc = t4_read_flash(padap, addr, n, (u32 *)temp_buff.data, 0);
+		if (rc)
+			goto out;
+
+		addr += (n * 4);
+		rc = cudbg_write_and_release_buff(pdbg_init, &temp_buff,
+						  dbg_buff);
+		if (rc) {
+			cudbg_err->sys_warn = CUDBG_STATUS_PARTIAL_DATA;
+			goto out;
+		}
+	}
+
+out:
+	return rc;
+}
+
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
index 10ee6ed1d932..0f488d52797b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
@@ -162,7 +162,9 @@ int cudbg_collect_hma_meminfo(struct cudbg_init *pdbg_init,
 int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			struct cudbg_buffer *dbg_buff,
 			struct cudbg_error *cudbg_err);
-
+int cudbg_collect_flash(struct cudbg_init *pdbg_init,
+			struct cudbg_buffer *dbg_buff,
+			struct cudbg_error *cudbg_err);
 struct cudbg_entity_hdr *cudbg_get_entity_hdr(void *outbuf, int i);
 void cudbg_align_debug_buffer(struct cudbg_buffer *dbg_buff,
 			      struct cudbg_entity_hdr *entity_hdr);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
index e374b413d9ac..d7afe0746878 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
@@ -66,6 +66,10 @@ static const struct cxgb4_collect_entity cxgb4_collect_hw_dump[] = {
 	{ CUDBG_HMA_INDIRECT, cudbg_collect_hma_indirect },
 };
 
+static const struct cxgb4_collect_entity cxgb4_collect_flash_dump[] = {
+	{ CUDBG_FLASH, cudbg_collect_flash },
+};
+
 static u32 cxgb4_get_entity_length(struct adapter *adap, u32 entity)
 {
 	struct cudbg_tcam tcam_region = { 0 };
@@ -330,6 +334,9 @@ u32 cxgb4_get_dump_length(struct adapter *adap, u32 flag)
 		}
 	}
 
+	if (flag & CXGB4_ETH_DUMP_FLASH)
+		len += adap->params.sf_size;
+
 	/* If compression is enabled, a smaller destination buffer is enough */
 	wsize = cudbg_get_workspace_size();
 	if (wsize && len > CUDBG_DUMP_BUFF_SIZE)
@@ -468,6 +475,13 @@ int cxgb4_cudbg_collect(struct adapter *adap, void *buf, u32 *buf_size,
 					   buf,
 					   &total_size);
 
+	if (flag & CXGB4_ETH_DUMP_FLASH)
+		cxgb4_cudbg_collect_entity(&cudbg_init, &dbg_buff,
+					   cxgb4_collect_flash_dump,
+					   ARRAY_SIZE(cxgb4_collect_flash_dump),
+					   buf,
+					   &total_size);
+
 	cudbg_free_compress_buff(&cudbg_init);
 	cudbg_hdr->data_len = total_size;
 	if (cudbg_init.compress_type != CUDBG_COMPRESSION_NONE)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h
index 66b805c7a92c..c04a49b6378d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h
@@ -27,6 +27,7 @@ enum CXGB4_ETHTOOL_DUMP_FLAGS {
 	CXGB4_ETH_DUMP_NONE = ETH_FW_DUMP_DISABLE,
 	CXGB4_ETH_DUMP_MEM = (1 << 0), /* On-Chip Memory Dumps */
 	CXGB4_ETH_DUMP_HW = (1 << 1), /* various FW and HW dumps */
+	CXGB4_ETH_DUMP_FLASH = (1 << 2), /* Dump flash memory */
 };
 
 #define CXGB4_ETH_DUMP_ALL (CXGB4_ETH_DUMP_MEM | CXGB4_ETH_DUMP_HW)
-- 
2.18.2

