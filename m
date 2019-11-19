Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35901022D8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKSLSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:08 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34634 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:08 -0500
Received: by mail-pj1-f68.google.com with SMTP id bo14so2546046pjb.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+ltsqzbUUyntcpy8N8U0dUWEpQ2+g2jWHN02fwqxwkM=;
        b=kupZgFUC0VhpZqeGv75yVpr9Bz+HKUxOeKHV3LiIdYrDM4tyVH0fU2Qq7fqA0DlzAU
         yTeTeyCTITQJ2Dh2x+x9KciZqvdtL0Cc+C7BC0GMsZWazqXScFBwoSuWbLIX4deEg9Lb
         zBMT0JPqsDQt6gYSc5oHP1QwgBGF0e4MRrwW+zkR4vr0JKRx6dSTjMGqcnQXUTbJkXwF
         EZrjsYjuMDEvN7csQ7fh7VboMCho1q/cSIrEUr25GpQ24eJsGqPiMRTEuC4Q0D2/cqs/
         5OUI7SAj8VLyvZjs7HyecuVLwTyg+lJmPSWh82+7y/pDeoTFu8dss0A/qe5I3FAlFRnh
         WnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+ltsqzbUUyntcpy8N8U0dUWEpQ2+g2jWHN02fwqxwkM=;
        b=KrTgBunyvrN0UrXPZ8GsXaR/w2gq2pt4PNLzqw58wG+tmhTt3wxwj+8gdebDZ+c53F
         eGxXka6RDS1Mimt06zq7408JQ25WPu9ScRZdSkG/erWXOWRCxD/rO8g/6lLXSnlTxDF8
         VSKHYckd8KOpFDfOq1w621AzW6jn6ujk9XB9s1bIgJ96CH3s0WsMKrmuuRnDx3HJhcaP
         oHetEQOQqdv/DHiB//ePhVfUdpqbQhCJfcx3j3veY4FHuTBnkvI1ck1GbTj5Hqn1nOHe
         UZt68SHHHvu2btN675SiUp+NGAm1lmojcz19RnzjdqZ4bCoCMXniTp6n62khhKbMAwwy
         X25A==
X-Gm-Message-State: APjAAAXR2U1hu/4BHFhPznQ0zEEmyRQoZE7aHqVtOBgeRTUIrnex9ZWH
        fa4PQ41mjG4V9rCWyvRfGcbpgXvkK7s=
X-Google-Smtp-Source: APXvYqy/h386Wl38IESpRRSQQ/IKIIb7gHKFoVPndgdRNtKJNf6L1r3zoteuOKA5t07Ha2I5QEFX1w==
X-Received: by 2002:a17:902:854c:: with SMTP id d12mr25396985plo.264.1574162287048;
        Tue, 19 Nov 2019 03:18:07 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:06 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [PATCH v2 05/15] octeontx2-af: Set discovery ID for RVUM block
Date:   Tue, 19 Nov 2019 16:47:29 +0530
Message-Id: <1574162259-28181-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 730d0fa..35ad21d 100644
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
@@ -2226,6 +2239,9 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	}
 	rvu->irq_allocated[RVU_AF_INT_VEC_PFME] = true;
 
+	/* Clear TRPEND bit for all PF */
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_AF_PFTRPEND, INTR_MASK(rvu->hw->total_pfs));
 	/* Enable ME interrupt for all PFs*/
 	rvu_write64(rvu, BLKADDR_RVUM,
 		    RVU_AF_PFME_INT, INTR_MASK(rvu->hw->total_pfs));
@@ -2549,6 +2565,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_regions;
 	}
 
+	pci_set_master(pdev);
+
 	/* Map Admin function CSRs */
 	rvu->afreg_base = pcim_iomap(pdev, PCI_AF_REG_BAR_NUM, 0);
 	rvu->pfreg_base = pcim_iomap(pdev, PCI_PF_REG_BAR_NUM, 0);
@@ -2587,6 +2605,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_flr;
 
+	rvu_setup_rvum_blk_revid(rvu);
+
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
 	if (err)
@@ -2607,6 +2627,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_fwdata_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
+	rvu_clear_rvum_blk_revid(rvu);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -2631,7 +2652,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
-
+	rvu_clear_rvum_blk_revid(rvu);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 9d8942a..a3ecb5d 100644
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

