Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828AC1C34EB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgEDIvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728374AbgEDIvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC22C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so6525295plo.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zmf/jFr8bq7R4ngtvJKpkgWbS6TEEE1SpQnL33It7w0=;
        b=a3XbOVj5wMUNSoQRjA5J67Vt7BoajsAn0OCd210sRwsOjFNHu1gPBG1tTLl38Xiq3L
         iTLP9A5tE+VJKdiGmmFbjfapvZKnxF+QIWHQagwtjQEP+ZNtE/bX6fVot/AGKl5NEFEB
         4qCdjFajRhH0Z9WrQ3c3gh6gGkTDRQK9WlNtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zmf/jFr8bq7R4ngtvJKpkgWbS6TEEE1SpQnL33It7w0=;
        b=Zrv43+6dzmZrgooYszZInCN6Ce5iXcTDnmaQuMDPTg1iFcghEG4LWXQlO8oFoDimGU
         56RBYkxom4bmLL6aF4hCfWI4HcVInl6J+ptHhcyKcgfpYIv4rLl58n/BUNniPv2bornm
         JJEnH3uDP5cPOZoCAs4++jIef6R8G4KlzSjeAKBKbPVJ6TsZVR1MUAa540ZJtDvll/Yn
         lf2JlDyqlmhBtjqwcK/9DsKGQ5orAjEC8UB4u9tzY5+50mNoTg+ydw1GWIRyuZrbuv9b
         vkyH5kZ+dxu1AfnHr/WJnouIxGqAldxDXcDGUN4Y1B1ONV+zgf1a8+nVn9Ke6nifBChP
         2cvg==
X-Gm-Message-State: AGi0Pua+G/C5Ouleo0C0+D/RICoAY3eu/0lotOq2oZ04kTM981SgI9pv
        oZ+uJb4/2KR1AAC/zMc3pDBcJg==
X-Google-Smtp-Source: APiQypLNCaMzipyYPFQx0iOLXCZj3kCOvAgDHE9aWUdd7JGaxax+As6VxbVig+/Ea2kPxIixXL1Aqg==
X-Received: by 2002:a17:902:c281:: with SMTP id i1mr17255943pld.327.1588582278988;
        Mon, 04 May 2020 01:51:18 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 11/15] bnxt_en: Add support for L2 doorbell size.
Date:   Mon,  4 May 2020 04:50:37 -0400
Message-Id: <1588582241-31066-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the L2 doorbell size from the firmware and only map the portion
of the doorbell BAR for L2 use.  This will leave the remaining doorbell
BAR available for the RoCE driver to use.  The RoCE driver can map
the remaining portion as write-combining to support the push feature.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 43 ++++++++++++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2e56402..8f11344 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6364,6 +6364,7 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 {
 	struct hwrm_func_qcfg_input req = {0};
 	struct hwrm_func_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	u32 min_db_offset = 0;
 	u16 flags;
 	int rc;
 
@@ -6412,6 +6413,21 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 	if (!bp->max_mtu)
 		bp->max_mtu = BNXT_MAX_MTU;
 
+	if (bp->db_size)
+		goto func_qcfg_exit;
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		if (BNXT_PF(bp))
+			min_db_offset = DB_PF_OFFSET_P5;
+		else
+			min_db_offset = DB_VF_OFFSET_P5;
+	}
+	bp->db_size = PAGE_ALIGN(le16_to_cpu(resp->l2_doorbell_bar_size_kb) *
+				 1024);
+	if (!bp->db_size || bp->db_size > pci_resource_len(bp->pdev, 2) ||
+	    bp->db_size <= min_db_offset)
+		bp->db_size = pci_resource_len(bp->pdev, 2);
+
 func_qcfg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
@@ -10898,6 +10914,9 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	bp->dev = dev;
 	bp->pdev = pdev;
 
+	/* Doorbell BAR bp->bar1 is mapped after bnxt_fw_init_one_p2()
+	 * determines the BAR size.
+	 */
 	bp->bar0 = pci_ioremap_bar(pdev, 0);
 	if (!bp->bar0) {
 		dev_err(&pdev->dev, "Cannot map device registers, aborting\n");
@@ -10905,13 +10924,6 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 		goto init_err_release;
 	}
 
-	bp->bar1 = pci_ioremap_bar(pdev, 2);
-	if (!bp->bar1) {
-		dev_err(&pdev->dev, "Cannot map doorbell registers, aborting\n");
-		rc = -ENOMEM;
-		goto init_err_release;
-	}
-
 	bp->bar2 = pci_ioremap_bar(pdev, 4);
 	if (!bp->bar2) {
 		dev_err(&pdev->dev, "Cannot map bar4 registers, aborting\n");
@@ -11833,6 +11845,16 @@ static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
 	return 0;
 }
 
+static int bnxt_map_db_bar(struct bnxt *bp)
+{
+	if (!bp->db_size)
+		return -ENODEV;
+	bp->bar1 = pci_iomap(bp->pdev, 2, bp->db_size);
+	if (!bp->bar1)
+		return -ENOMEM;
+	return 0;
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -11893,6 +11915,13 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_pci_clean;
 
+	rc = bnxt_map_db_bar(bp);
+	if (rc) {
+		dev_err(&pdev->dev, "Cannot map doorbell BAR rc = %d, aborting\n",
+			rc);
+		goto init_err_pci_clean;
+	}
+
 	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
 			   NETIF_F_TSO | NETIF_F_TSO6 |
 			   NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a3b80409..6114b0a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1820,6 +1820,7 @@ struct bnxt {
 	/* ensure atomic 64-bit doorbell writes on 32-bit systems. */
 	spinlock_t		db_lock;
 #endif
+	int			db_size;
 
 #define BNXT_NTP_FLTR_MAX_FLTR	4096
 #define BNXT_NTP_FLTR_HASH_SIZE	512
-- 
2.5.1

