Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C75322E47A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgG0Dap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0Dao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E2EC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so1428306pfh.3
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XgOjzv1EdV6wnW0ljXZYGfHHCKyd+/XjPnyFswctSok=;
        b=KJFHTFnYRLQkK98n5/4vpJsuRDGoR5ckmC4SLRXpmioUC6JPExY+Nt4EYcL6Okd0Ae
         XWujwCybYwghN2VOYMlWs1POyXtegHn76ZOdjD9w7cBOgCg3IOhx/sTaBbrQYvvIwHkt
         N8bgZrnVhxL6bKVv1LEmVq+rVlPiNo8UvZdUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XgOjzv1EdV6wnW0ljXZYGfHHCKyd+/XjPnyFswctSok=;
        b=DfLlaw6bgVDLCUinkYBHNU8OcAVtqz+8OQlkRCjQrKZWCNdUTDS4U+k/+pehL/SvbU
         ADUCi86rTdKXRdviGHUBJWoHcOMbIlnLg3RDKdbANJ2YylTX0Kc8SF0MBCrqtUBlEchD
         GLoi2e9uUpCK+2xayPpnkz+dnUs+kn4mLbjaK3bA4SayUjyFIKwlkPjVGsVNSidHS8lc
         l2uwZYsWsvLERZO/7kAj4WqFUSyo6OQBfJZ0YRsxOk07wcH/P4sUiWdcRrbM+BuhZdp1
         LfbyFzeZRoTEIeC7oSjTePk45LYUk15Bdft++m2b4j4snsZ1aCWzkKASnjU4TnchN7Ii
         cF3Q==
X-Gm-Message-State: AOAM531r9aL5upyNqy1AXgMeaoApMM/VRIR6QfewxI/48c2ntsOQ1/TO
        brEK2jc4eaoFw0YHGvna/EWpnQ==
X-Google-Smtp-Source: ABdhPJzXJyl262BFfNZjOn2iSPcU6cyoRQQOI2TYIAgNv9QCIMBklGxKqFZf6e3NlsjYdXDuVDZkyA==
X-Received: by 2002:a63:1059:: with SMTP id 25mr11175672pgq.302.1595820643574;
        Sun, 26 Jul 2020 20:30:43 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 10/10] bnxt_en: Add support for 'ethtool -d'
Date:   Sun, 26 Jul 2020 23:29:46 -0400
Message-Id: <1595820586-2203-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add support to dump PXP registers and PCIe statistics.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 32 +++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 55 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +
 4 files changed, 94 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 014edd8..943345b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10220,6 +10220,38 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
+			 u32 *reg_buf)
+{
+	struct hwrm_dbg_read_direct_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_dbg_read_direct_input req = {0};
+	__le32 *dbg_reg_buf;
+	dma_addr_t mapping;
+	int rc, i;
+
+	dbg_reg_buf = dma_alloc_coherent(&bp->pdev->dev, num_words * 4,
+					 &mapping, GFP_KERNEL);
+	if (!dbg_reg_buf)
+		return -ENOMEM;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_DBG_READ_DIRECT, -1, -1);
+	req.host_dest_addr = cpu_to_le64(mapping);
+	req.read_addr = cpu_to_le32(reg_off + CHIMP_REG_VIEW_ADDR);
+	req.read_len32 = cpu_to_le32(num_words);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc || resp->error_code) {
+		rc = -EIO;
+		goto dbg_rd_reg_exit;
+	}
+	for (i = 0; i < num_words; i++)
+		reg_buf[i] = le32_to_cpu(dbg_reg_buf[i]);
+
+dbg_rd_reg_exit:
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	dma_free_coherent(&bp->pdev->dev, num_words * 4, dbg_reg_buf, mapping);
+	return rc;
+}
+
 static int bnxt_dbg_hwrm_ring_info_get(struct bnxt *bp, u8 ring_type,
 				       u32 ring_id, u32 *prod, u32 *cons)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0c9b79b..5a13eb6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1304,6 +1304,9 @@ struct bnxt_test_info {
 	char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
 };
 
+#define CHIMP_REG_VIEW_ADDR				\
+	((bp->flags & BNXT_FLAG_CHIP_P5) ? 0x80000000 : 0xb1000000)
+
 #define BNXT_GRCPF_REG_CHIMP_COMM		0x0
 #define BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER	0x100
 #define BNXT_GRCPF_REG_WINDOW_BASE_OUT		0x400
@@ -2117,6 +2120,8 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
+			 u32 *reg_buf);
 void bnxt_fw_exception(struct bnxt *bp);
 void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ff380d7..7fd7997 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1324,6 +1324,59 @@ static void bnxt_get_drvinfo(struct net_device *dev,
 	info->regdump_len = 0;
 }
 
+static int bnxt_get_regs_len(struct net_device *dev)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int reg_len;
+
+	reg_len = BNXT_PXP_REG_LEN;
+
+	if (bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED)
+		reg_len += sizeof(struct pcie_ctx_hw_stats);
+
+	return reg_len;
+}
+
+static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
+			  void *_p)
+{
+	struct pcie_ctx_hw_stats *hw_pcie_stats;
+	struct hwrm_pcie_qstats_input req = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	dma_addr_t hw_pcie_stats_addr;
+	int rc;
+
+	regs->version = 0;
+	bnxt_dbg_hwrm_rd_reg(bp, 0, BNXT_PXP_REG_LEN / 4, _p);
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED))
+		return;
+
+	hw_pcie_stats = dma_alloc_coherent(&bp->pdev->dev,
+					   sizeof(*hw_pcie_stats),
+					   &hw_pcie_stats_addr, GFP_KERNEL);
+	if (!hw_pcie_stats)
+		return;
+
+	regs->version = 1;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PCIE_QSTATS, -1, -1);
+	req.pcie_stat_size = cpu_to_le16(sizeof(*hw_pcie_stats));
+	req.pcie_stat_host_addr = cpu_to_le64(hw_pcie_stats_addr);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc) {
+		__le64 *src = (__le64 *)hw_pcie_stats;
+		u64 *dst = (u64 *)(_p + BNXT_PXP_REG_LEN);
+		int i;
+
+		for (i = 0; i < sizeof(*hw_pcie_stats) / sizeof(__le64); i++)
+			dst[i] = le64_to_cpu(src[i]);
+	}
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	dma_free_coherent(&bp->pdev->dev, sizeof(*hw_pcie_stats), hw_pcie_stats,
+			  hw_pcie_stats_addr);
+}
+
 static void bnxt_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -3596,6 +3649,8 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
 	.get_drvinfo		= bnxt_get_drvinfo,
+	.get_regs_len		= bnxt_get_regs_len,
+	.get_regs		= bnxt_get_regs,
 	.get_wol		= bnxt_get_wol,
 	.set_wol		= bnxt_set_wol,
 	.get_coalesce		= bnxt_get_coalesce,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index dddbca1..34f44dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -84,6 +84,8 @@ struct hwrm_dbg_cmn_output {
 				  ETH_RESET_PHY | ETH_RESET_RAM)	\
 				 << ETH_RESET_SHARED_SHIFT)
 
+#define BNXT_PXP_REG_LEN	0x3110
+
 extern const struct ethtool_ops bnxt_ethtool_ops;
 
 u32 bnxt_get_rxfh_indir_size(struct net_device *dev);
-- 
1.8.3.1

