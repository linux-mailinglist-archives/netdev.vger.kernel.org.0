Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567F1104274
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfKTRtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45037 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbfKTRtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id az9so91567plb.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zir4cMFKdhHHBiW52HrvBuP5dnpiffMnYC1FNPmRTJs=;
        b=T4Hxwu/i8aeByxr00MngAAz2Z4EZjfXfX2cfDUi0ilaWzzIXlM5F1OUHFeWpPA0jUr
         EJLMncSUukuR7DYF1nGxppbzmxEqa7MumemV52hVbfRb56gPpqFMBjtnzoUF4lWMeNkX
         bn0VRdYlJfvZ038cMY/W5WCte6T9pGOsprviyuSN/nCczgnt1y1FT9Yxdk57f9z2mrA/
         x3eNMDDEvdrPXbC3ZKQ96v4LFY4N5neIajBZt1EngOaL5OUkfN9ZxGq0myD4aJpDsnbw
         X//7jidPVn5AlVpjC3lStb0SsXqSWz+jhMLogfDntzO7zqDMzYrs6T1bmnBvw+OThDed
         LZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zir4cMFKdhHHBiW52HrvBuP5dnpiffMnYC1FNPmRTJs=;
        b=R2KlXV7GFFidJKe3zEGbVDLtNSlim1WMJg5iv/fUSCuLZYkbmMVBPTWV3hBdPrFVgx
         j6QkYh+4nuBhuFwydbBC0o105D5ghQgrDCGM0DTMAHuTLJ0LEa6RWU6739emgFYtS1Ah
         3chOxaUQnm27C4/hb4j8mJjDrRnq4gNNT7qk3wcSmupNL4WY1eevE7DaRQ6pAkeHg2qB
         Kg2jZgXc8YYhC+Juk8X7kV/bZGQEJDiWnkxFKbG1AWjj/iShsdPxeWW8xWkADd+Xto+M
         g2Dv3kyZzhsRYQW5RznjZoWrXgS79oMeMtFLYk9JYJUlDxG3ZBiRgyiEvxm7yc3Qm0Xj
         bfMQ==
X-Gm-Message-State: APjAAAV4y8ODDKV2GkyOIvGR2ePYlXnKRrFXvZV4tH55xEWjRPf1ce+E
        Sde6SlwrTutLOMNQKknlQN+2A6Wr
X-Google-Smtp-Source: APXvYqxzdrWRUb7+tEniSt1OhXEJd3QGM6z/IPa4cSVsK4VHTVGZR979nibS7fChxOs/JSk7oQ6lZw==
X-Received: by 2002:a17:902:7b98:: with SMTP id w24mr4195100pll.307.1574272154513;
        Wed, 20 Nov 2019 09:49:14 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:13 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [PATCH v3 05/16] octeontx2-af: Set discovery ID for RVUM block
Date:   Wed, 20 Nov 2019 23:17:55 +0530
Message-Id: <1574272086-21055-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
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
index d221540..a0c7886 100644
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

