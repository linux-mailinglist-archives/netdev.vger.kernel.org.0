Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF8631B83B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBOLn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:43:57 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:45292 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhBOLnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:43:47 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 11FBgofv011373;
        Mon, 15 Feb 2021 03:42:51 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     secdev@chelsio.com, varun@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds
Date:   Mon, 15 Feb 2021 17:12:26 +0530
Message-Id: <20210215114226.10003-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Max imm data size in cxgb4 is not similar to the max imm data size
in the chtls. This caused an mismatch in output of is_ofld_imm() of
cxgb4 and chtls. So fixed this by keeping the max wreq size of imm data
same in both chtls and cxgb4 as MAX_IMM_OFLD_TX_DATA_WR_LEN.

As cxgb4's max imm. data value for ofld packets is changed to
MAX_IMM_OFLD_TX_DATA_WR_LEN. Using the same in cxgbit also.

Fixes: 36bedb3f2e5b8 ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h        |  3 +++
 drivers/net/ethernet/chelsio/cxgb4/sge.c              | 11 ++++++++---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.h   |  3 ---
 drivers/target/iscsi/cxgbit/cxgbit_target.c           |  3 +--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 1b49f2fa9b18..34546f5312ee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -46,6 +46,9 @@
 #define MAX_ULD_QSETS 16
 #define MAX_ULD_NPORTS 4
 
+/* ulp_mem_io + ulptx_idata + payload + padding */
+#define MAX_IMM_ULPTX_WR_LEN (32 + 8 + 256 + 8)
+
 /* CPL message priority levels */
 enum {
 	CPL_PRIORITY_DATA     = 0,  /* data messages */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 196652a114c5..3334c9e2152a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2842,17 +2842,22 @@ int t4_mgmt_tx(struct adapter *adap, struct sk_buff *skb)
  *	@skb: the packet
  *
  *	Returns true if a packet can be sent as an offload WR with immediate
- *	data.  We currently use the same limit as for Ethernet packets.
+ *	data.
+ *	FW_OFLD_TX_DATA_WR limits the payload to 255 bytes due to 8-bit field.
+ *      However, FW_ULPTX_WR commands have a 256 byte immediate only
+ *      payload limit.
  */
 static inline int is_ofld_imm(const struct sk_buff *skb)
 {
 	struct work_request_hdr *req = (struct work_request_hdr *)skb->data;
 	unsigned long opcode = FW_WR_OP_G(ntohl(req->wr_hi));
 
-	if (opcode == FW_CRYPTO_LOOKASIDE_WR)
+	if (unlikely(opcode == FW_ULPTX_WR))
+		return skb->len <= MAX_IMM_ULPTX_WR_LEN;
+	else if (opcode == FW_CRYPTO_LOOKASIDE_WR)
 		return skb->len <= SGE_MAX_WR_LEN;
 	else
-		return skb->len <= MAX_IMM_TX_PKT_LEN;
+		return skb->len <= MAX_IMM_OFLD_TX_DATA_WR_LEN;
 }
 
 /**
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
index 47ba81e42f5d..b1161bdeda4d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
@@ -50,9 +50,6 @@
 #define MIN_RCV_WND (24 * 1024U)
 #define LOOPBACK(x)     (((x) & htonl(0xff000000)) == htonl(0x7f000000))
 
-/* ulp_mem_io + ulptx_idata + payload + padding */
-#define MAX_IMM_ULPTX_WR_LEN (32 + 8 + 256 + 8)
-
 /* for TX: a skb must have a headroom of at least TX_HEADER_LEN bytes */
 #define TX_HEADER_LEN \
 	(sizeof(struct fw_ofld_tx_data_wr) + sizeof(struct sge_opaque_hdr))
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 9b3eb2e8c92a..b926e1d6c7b8 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -86,8 +86,7 @@ static int cxgbit_is_ofld_imm(const struct sk_buff *skb)
 	if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_ISO))
 		length += sizeof(struct cpl_tx_data_iso);
 
-#define MAX_IMM_TX_PKT_LEN	256
-	return length <= MAX_IMM_TX_PKT_LEN;
+	return length <= MAX_IMM_OFLD_TX_DATA_WR_LEN;
 }
 
 /*
-- 
2.28.0.rc1.6.gae46588

