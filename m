Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535C64164E4
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbhIWSOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242689AbhIWSOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3C6610C8;
        Thu, 23 Sep 2021 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420782;
        bh=JszZEhzKH2ZrJM1/H0dQz59yU6fi6F4Uu7Kc5qdwk7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ff5SllCWr49nkhlXvN/aQF7WHB3ftLia70sKOmrhq+JYaRWuVZ6uczQsgjBp1sSXI
         BJfeIp0x6OIE+Av8JKwPc52Matuj5OU4x4LkRDM9/FyE0ZnhgqkVq4PluCFYpIwZfo
         GoInaFxJWicEzbDIHRdC+I/RpJrDI+lI9VM+kvEFC2oh9+TJUdMgJaiP/YiPB2RWZk
         6gvRcXrSELrxdI2U84K1fDVXnyMFppq82SSwZ+rPqQlBQ9rVN0f8Q0WDJm1RYwWRlE
         0ijCq3hNSZLYYKpGAeqrrYjMJhIuYnIDPQYycgV9f4pXoFddFdyd5DscPDOqfNVEur
         qtCVJKcajsE7A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and registration status
Date:   Thu, 23 Sep 2021 21:12:48 +0300
Message-Id: <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

devlink is a software interface that doesn't depend on any hardware
capabilities. The failure in SW means memory issues, wrong parameters,
programmer error e.t.c.

Like any other such interface in the kernel, the returned status of
devlink APIs should be checked and propagated further and not ignored.

Fixes: 4ab0c6a8ffd7 ("bnxt_en: add support to enable VF-representors")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  5 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 13 -------------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 037767b370d5..4c483fd91dbe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13370,7 +13370,9 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	bnxt_inv_fw_health_reg(bp);
-	bnxt_dl_register(bp);
+	rc = bnxt_dl_register(bp);
+	if (rc)
+		goto init_err_dl;
 
 	rc = register_netdev(dev);
 	if (rc)
@@ -13390,6 +13392,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 init_err_cleanup:
 	bnxt_dl_unregister(bp);
+init_err_dl:
 	bnxt_shutdown_tc(bp);
 	bnxt_clear_int_mode(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index bf7d3c17049b..dc0851f709f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -134,7 +134,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!bp->dl || !health)
+	if (!health)
 		return;
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
@@ -188,7 +188,7 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!bp->dl || !health)
+	if (!health)
 		return;
 
 	if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
@@ -781,6 +781,7 @@ int bnxt_dl_register(struct bnxt *bp)
 {
 	const struct devlink_ops *devlink_ops;
 	struct devlink_port_attrs attrs = {};
+	struct bnxt_dl *bp_dl;
 	struct devlink *dl;
 	int rc;
 
@@ -795,7 +796,9 @@ int bnxt_dl_register(struct bnxt *bp)
 		return -ENOMEM;
 	}
 
-	bnxt_link_bp_to_dl(bp, dl);
+	bp->dl = dl;
+	bp_dl = devlink_priv(dl);
+	bp_dl->bp = bp;
 
 	/* Add switchdev eswitch mode setting, if SRIOV supported */
 	if (pci_find_ext_capability(bp->pdev, PCI_EXT_CAP_ID_SRIOV) &&
@@ -826,7 +829,6 @@ int bnxt_dl_register(struct bnxt *bp)
 err_dl_port_unreg:
 	devlink_port_unregister(&bp->dl_port);
 err_dl_free:
-	bnxt_link_bp_to_dl(bp, NULL);
 	devlink_free(dl);
 	return rc;
 }
@@ -835,9 +837,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
 {
 	struct devlink *dl = bp->dl;
 
-	if (!dl)
-		return;
-
 	if (BNXT_PF(bp)) {
 		bnxt_dl_params_unregister(bp);
 		devlink_port_unregister(&bp->dl_port);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d889f240da2b..406dc655a5fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -20,19 +20,6 @@ static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
 	return ((struct bnxt_dl *)devlink_priv(dl))->bp;
 }
 
-/* To clear devlink pointer from bp, pass NULL dl */
-static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
-{
-	bp->dl = dl;
-
-	/* add a back pointer in dl to bp */
-	if (dl) {
-		struct bnxt_dl *bp_dl = devlink_priv(dl);
-
-		bp_dl->bp = bp;
-	}
-}
-
 #define NVM_OFF_MSIX_VEC_PER_PF_MAX	108
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
-- 
2.31.1

