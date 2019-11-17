Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74EE0FFAAD
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfKQQPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:07 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46967 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:15:06 -0500
Received: by mail-pl1-f193.google.com with SMTP id l4so8216180plt.13
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AyjjBttWDDwaMIainXSWHEXXcOveDn8MDbRCTBhfKXQ=;
        b=mMTXmOEQyKnqAkpDkhdauYin/j6mYHCLkBcdNcyVnG1jcAaWOhdgJdnrOZwTNvqMLD
         vxcVaV7W/oGR0OuagUraXPRVMIGBsyY12XzTgLPmJVXZXh3ZxyzFxfRy1ieLgTNEVw/u
         3/CQVRgZbUfMi5DMOvTJ8POMB/ZMcobH/hz2sf0pY9EpsONLg8cj2AiWnjKBfT6kgcRy
         DmYrnU7BvpnH7gAl7S6AC6G9ZrntaNk0tpw4fi7OCyfMf0Mf1rK/VwKel+SOSaTBe0oT
         20UE54o7goWRkiT1IniQixorE53Jr6l+lvXb9PNzDn9baXuvS+cEqX9mupz4N9csZ29e
         GLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AyjjBttWDDwaMIainXSWHEXXcOveDn8MDbRCTBhfKXQ=;
        b=V2M+0ExjvniKigaORGS8580INiNCy+WXWYud/VVIu6Bc4A4I9D/Uv+acRy+wnWBpJk
         RBiQ3HsPc6PXJV8K1Vl6Ms0Manl/S6kxrOHhjAiF9pR47v1cgDlNo5L/Fpe0c1Vs6Krk
         GL32cQlMD8DcbyFtcOQIlA/R63c+FhkEXiTZy4YUDL5dWTUwVf93IuW/KNs2hbuyUY5I
         izJqKohnj/qS6pm0SW6r5souERwEg8c86qBF1ath3UaZHEypHW/ijwygfjpPqKr2VNcG
         6web9GKXwQPnXlv8d/gK27pER0O5gvnTePdFkwL9Be52kTj2HFxPHb08Iwbs9jBcGRtw
         vHYw==
X-Gm-Message-State: APjAAAUNP1rQJgCmoDQ40TMWHhUM8f158cgaFYp9P3L1spvfYg1UGGKB
        9/rM72PucaEs0JDqWu16Z/vlx11GRWw=
X-Google-Smtp-Source: APXvYqzhANyIsERIFNFQs8HdZmjf8naBt9PAIqBbFEwsPlEU1/76OL1TjLtusLRjaN0rdclkqpPTkg==
X-Received: by 2002:a17:90a:77c3:: with SMTP id e3mr34662711pjs.14.1574007305766;
        Sun, 17 Nov 2019 08:15:05 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.15.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:15:05 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [PATCH 05/15] octeontx2-af: Set discovery ID for RVUM block
Date:   Sun, 17 Nov 2019 21:44:16 +0530
Message-Id: <1574007266-17123-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Currently there is no way for AF dependent drivers in
any domain to check if the AF driver is loaded. This
patch sets a ID for RVUM block which will automatically
reflects in PF/VFs discovery register which they can
check and defer their probe until AF is up.

Also fixed an issue which occurs when kernel driver is
unbinded, bus mastering gets disabled by the PCI subsystem
which results interrupts not working when driver is reloaded.
Hence enabled bus mastering  in probe(). Also cleared
transaction pending bit which gets set during driver unbind
due to clearing of bus mastering ME bit.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 23 +++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  3 +++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 90c30e6..0bf4096 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -421,6 +421,19 @@ static void rvu_check_block_implemented(struct rvu *rvu)
 	}
 }
 
+static void rvu_setup_rvum_blk_revid(struct rvu *rvu)
+{
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_PRIV_BLOCK_TYPEX_REV(BLKTYPE_RVUM),
+		    RVU_BLK_RVUM_REVID);
+}
+
+static void rvu_clear_rvum_blk_revid(struct rvu *rvu)
+{
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_PRIV_BLOCK_TYPEX_REV(BLKTYPE_RVUM), 0x00);
+}
+
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf)
 {
 	int err;
@@ -2225,6 +2238,9 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	}
 	rvu->irq_allocated[RVU_AF_INT_VEC_PFME] = true;
 
+	/* Clear TRPEND bit for all PF */
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_AF_PFTRPEND, INTR_MASK(rvu->hw->total_pfs));
 	/* Enable ME interrupt for all PFs*/
 	rvu_write64(rvu, BLKADDR_RVUM,
 		    RVU_AF_PFME_INT, INTR_MASK(rvu->hw->total_pfs));
@@ -2548,6 +2564,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_regions;
 	}
 
+	pci_set_master(pdev);
+
 	/* Map Admin function CSRs */
 	rvu->afreg_base = pcim_iomap(pdev, PCI_AF_REG_BAR_NUM, 0);
 	rvu->pfreg_base = pcim_iomap(pdev, PCI_PF_REG_BAR_NUM, 0);
@@ -2586,6 +2604,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_flr;
 
+	rvu_setup_rvum_blk_revid(rvu);
+
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
 	if (err)
@@ -2606,6 +2626,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_fwdata_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
+	rvu_clear_rvum_blk_revid(rvu);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -2630,7 +2651,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
-
+	rvu_clear_rvum_blk_revid(rvu);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index f6a260d..627c649 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -11,6 +11,9 @@
 #ifndef RVU_STRUCT_H
 #define RVU_STRUCT_H
 
+/* RVU Block revision IDs */
+#define RVU_BLK_RVUM_REVID		0x01
+
 /* RVU Block Address Enumeration */
 enum rvu_block_addr_e {
 	BLKADDR_RVUM		= 0x0ULL,
-- 
2.7.4

