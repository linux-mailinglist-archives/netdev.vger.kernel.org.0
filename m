Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12F4668488
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbjALUxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbjALUxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:53:08 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD81C930
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:47 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s8so13047097plk.5
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QLATzbOgbg8CPE7t8qxFrrghz/rPwmq8ttbsYeL4qTs=;
        b=LSR+2l360h3crxTfyG/t2kNAziMHF+AbiMfTMQg01ghMSrkT/dOkpCAwfc0d4xnlrr
         Qv30ruAJLq8WltgyONFUV5WdMBR2PdijMjwdfz5z6Vll7cyymT9Av1RWkePswu2fUh+c
         Xzj4gvv0TKucWg9e9G86soUFDqbCUj563FvcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QLATzbOgbg8CPE7t8qxFrrghz/rPwmq8ttbsYeL4qTs=;
        b=1TnSUcnRc6tPHzSVOQMiyghjidBwRX0KCKeOShyjLfrn4hOZ7kwOSI4IYDQ3DHHMPW
         JTlRGHdD+XdtXFMxsS81GZzdIrPIHKqbIW+LCYjBjqaOo79qALpMqR8hgULJ6pL7HYH/
         061IOw+O6QwW5Xw32SQfxvYnwIb5vvA4XNgS1uwV/xUD63cgsBDu0pD5JaJihkupJ6PP
         G6DJKO7INgijV9hUh9OuFkEDmHNN8l7HSfKOTgKMLtR90EQK+ueISk1VzAuSSI7HwO36
         Dty7ib6GHYkFT9s2jKx6ja9l2fxR3dYtTFHyjrjwO9QWW+XloW8OX09zrlE5WAIAIYyW
         e38g==
X-Gm-Message-State: AFqh2kp4E8OfrarRzonA7wRaKm17a2zTMzvM7rRlVZbY+G4i8WvUCPXe
        YCr31fJdZV0s4o3FQIOkcZmBYg==
X-Google-Smtp-Source: AMrXdXt4t+eEEH6TyBUSP2Se0QyEv5bzsR5fBFYDaTJoCdqXU3JK8iLiMwB+r52PBSMgFLAmLV+VGw==
X-Received: by 2002:a05:6a21:3a82:b0:b6:7e03:5723 with SMTP id zv2-20020a056a213a8200b000b67e035723mr3877821pzb.42.1673555386892;
        Thu, 12 Jan 2023 12:29:46 -0800 (PST)
Received: from C02GC2QQMD6T.wifi.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 129-20020a630887000000b004777c56747csm10283855pgi.11.2023.01.12.12.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 12:29:46 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
Date:   Thu, 12 Jan 2023 12:29:32 -0800
Message-Id: <20230112202939.19562-2-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000061703b05f216fa70"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000061703b05f216fa70
Content-Transfer-Encoding: 8bit

Add auxiliary driver support.
An auxiliary device will be created if the hardware indicates
support for RDMA.
The bnxt_ulp_probe() function has been removed and a new
bnxt_rdma_aux_device_add() function has been added.
The bnxt_free_msix_vecs() and bnxt_req_msix_vecs() will now hold
the RTNL lock when they call the bnxt_close_nic()and bnxt_open_nic()
since the device close and open need to be protected under RTNL lock.
The operations between the bnxt_en and bnxt_re will be protected
using the en_ops_lock.
This will be used by the bnxt_re driver in a follow-on patch
to create ROCE interfaces.

Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/broadcom/Kconfig         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 164 +++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   4 +-
 5 files changed, 158 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index f4ca0c6c0f51..948586bf1b5b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -213,6 +213,7 @@ config BNXT
 	select NET_DEVLINK
 	select PAGE_POOL
 	select DIMLIB
+	select AUXILIARY_BUS
 	help
 	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
 	  Ethernet cards.  To compile this driver as a module, choose M here:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 16ce7a90610c..c5cbf2307e07 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13178,6 +13178,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(dev);
 
+	bnxt_rdma_aux_device_uninit(bp);
+	bnxt_aux_dev_free(bp);
+
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
@@ -13776,11 +13779,13 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_dl_fw_reporters_create(bp);
 
+	bnxt_rdma_aux_device_init(bp);
+
 	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
-	return 0;
 
+	return 0;
 init_err_cleanup:
 	bnxt_dl_unregister(bp);
 init_err_dl:
@@ -13824,7 +13829,6 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
-	bnxt_ulp_shutdown(bp);
 	bnxt_clear_int_mode(bp);
 	pci_disable_device(pdev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5163ef4a49ea..4df2da81708e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
 #include <linux/crash_dump.h>
+#include <linux/auxiliary_bus.h>
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
@@ -1631,6 +1632,12 @@ struct bnxt_fw_health {
 #define BNXT_FW_IF_RETRY		10
 #define BNXT_FW_SLOT_RESET_RETRY	4
 
+struct bnxt_aux_dev {
+	struct auxiliary_device aux_dev;
+	struct bnxt_en_dev *edev;
+	int id;
+};
+
 enum board_idx {
 	BCM57301,
 	BCM57302,
@@ -1852,6 +1859,7 @@ struct bnxt {
 #define BNXT_CHIP_P4_PLUS(bp)			\
 	(BNXT_CHIP_P4(bp) || BNXT_CHIP_P5(bp))
 
+	struct bnxt_aux_dev	*aux_dev;
 	struct bnxt_en_dev	*edev;
 
 	struct bnxt_napi	**bnapi;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 2e54bf4fc7a7..899d9adfd35f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -25,6 +25,8 @@
 #include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 
+static DEFINE_IDA(bnxt_aux_dev_ids);
+
 static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			     struct bnxt_ulp_ops *ulp_ops, void *handle)
 {
@@ -32,7 +34,6 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ulp *ulp;
 
-	ASSERT_RTNL();
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
@@ -50,7 +51,7 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			return -ENOMEM;
 	}
 
-	atomic_set(&ulp->ref_count, 0);
+	atomic_set(&ulp->ref_count, 1);
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
@@ -69,10 +70,11 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	struct bnxt_ulp *ulp;
 	int i = 0;
 
-	ASSERT_RTNL();
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
+	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
+
 	ulp = &edev->ulp_tbl[ulp_id];
 	if (!rcu_access_pointer(ulp->ulp_ops)) {
 		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
@@ -126,7 +128,6 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	int total_vecs;
 	int rc = 0;
 
-	ASSERT_RTNL();
 	if (ulp_id != BNXT_ROCE_ULP)
 		return -EINVAL;
 
@@ -149,10 +150,12 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 		max_idx = min_t(int, bp->total_irqs, max_cp_rings);
 		idx = max_idx - avail_msix;
 	}
+
 	edev->ulp_tbl[ulp_id].msix_base = idx;
 	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
 	hw_resc = &bp->hw_resc;
 	total_vecs = idx + avail_msix;
+	rtnl_lock();
 	if (bp->total_irqs < total_vecs ||
 	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
 		if (netif_running(dev)) {
@@ -162,6 +165,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			rc = bnxt_reserve_rings(bp, true);
 		}
 	}
+	rtnl_unlock();
 	if (rc) {
 		edev->ulp_tbl[ulp_id].msix_requested = 0;
 		return -EAGAIN;
@@ -184,7 +188,6 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 
-	ASSERT_RTNL();
 	if (ulp_id != BNXT_ROCE_ULP)
 		return -EINVAL;
 
@@ -193,10 +196,13 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
 
 	edev->ulp_tbl[ulp_id].msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
+	rtnl_lock();
 	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
 		bnxt_close_nic(bp, true, false);
 		bnxt_open_nic(bp, true, false);
 	}
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -347,25 +353,6 @@ void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 	}
 }
 
-void bnxt_ulp_shutdown(struct bnxt *bp)
-{
-	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	int i;
-
-	if (!edev)
-		return;
-
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_shutdown)
-			continue;
-		ops->ulp_shutdown(ulp->handle);
-	}
-}
-
 void bnxt_ulp_irq_stop(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
@@ -475,6 +462,135 @@ static const struct bnxt_en_ops bnxt_en_ops_tbl = {
 	.bnxt_register_fw_async_events	= bnxt_register_async_events,
 };
 
+void bnxt_aux_dev_free(struct bnxt *bp)
+{
+	kfree(bp->aux_dev);
+	bp->aux_dev = NULL;
+}
+
+static struct bnxt_aux_dev *bnxt_aux_dev_alloc(struct bnxt *bp)
+{
+	return kzalloc(sizeof(struct bnxt_aux_dev), GFP_KERNEL);
+}
+
+void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
+{
+	struct bnxt_aux_dev *bnxt_adev;
+	struct auxiliary_device *adev;
+
+	/* Skip if no auxiliary device init was done. */
+	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
+		return;
+
+	bnxt_adev = bp->aux_dev;
+	adev = &bnxt_adev->aux_dev;
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+	if (bnxt_adev->id >= 0)
+		ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
+}
+
+static void bnxt_aux_dev_release(struct device *dev)
+{
+	struct bnxt_aux_dev *bnxt_adev =
+		container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
+	struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
+
+	bnxt_adev->edev->en_ops = NULL;
+	kfree(bnxt_adev->edev);
+	bnxt_adev->edev = NULL;
+	bp->edev = NULL;
+}
+
+static void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
+{
+	edev->en_ops = &bnxt_en_ops_tbl;
+	edev->net = bp->dev;
+	edev->pdev = bp->pdev;
+	edev->l2_db_size = bp->db_size;
+	edev->l2_db_size_nc = bp->db_size;
+
+	if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
+		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
+	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
+		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
+}
+
+static int bnxt_rdma_aux_device_add(struct bnxt *bp)
+{
+	struct bnxt_aux_dev *bnxt_adev = bp->aux_dev;
+	struct bnxt_en_dev *edev = bnxt_adev->edev;
+	struct auxiliary_device *aux_dev;
+	int ret;
+
+	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+	if (!edev)
+		return -ENOMEM;
+
+	aux_dev = &bnxt_adev->aux_dev;
+	aux_dev->id = bnxt_adev->id;
+	aux_dev->name = "rdma";
+	aux_dev->dev.parent = &bp->pdev->dev;
+	aux_dev->dev.release = bnxt_aux_dev_release;
+
+	bnxt_adev->edev = edev;
+	bp->edev = edev;
+	bnxt_set_edev_info(edev, bp);
+
+	ret = auxiliary_device_init(aux_dev);
+	if (ret)
+		goto free_edev;
+
+	ret = auxiliary_device_add(aux_dev);
+	if (ret)
+		goto aux_dev_uninit;
+
+	return 0;
+aux_dev_uninit:
+	auxiliary_device_uninit(aux_dev);
+free_edev:
+	kfree(edev);
+	bp->edev = NULL;
+
+	return ret;
+}
+
+void bnxt_rdma_aux_device_init(struct bnxt *bp)
+{
+	int rc;
+
+	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
+		return;
+
+	bp->aux_dev = bnxt_aux_dev_alloc(bp);
+	if (!bp->aux_dev)
+		goto skip_ida_init;
+
+	bp->aux_dev->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
+	if (bp->aux_dev->id < 0) {
+		netdev_warn(bp->dev,
+			    "ida alloc failed for ROCE auxiliary device\n");
+		goto skip_aux_init;
+	}
+
+	/* If aux bus init fails, continue with netdev init. */
+	rc = bnxt_rdma_aux_device_add(bp);
+	if (rc) {
+		netdev_warn(bp->dev,
+			    "Failed to add auxiliary device for ROCE\n");
+		goto aux_add_failed;
+	}
+	return;
+
+aux_add_failed:
+	ida_free(&bnxt_aux_dev_ids, bp->aux_dev->id);
+	bp->aux_dev->id = -1;
+skip_aux_init:
+	bnxt_aux_dev_free(bp);
+skip_ida_init:
+	bp->flags &= ~BNXT_FLAG_ROCE_CAP;
+}
+
 struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 42b50abc3e91..47c7131e5549 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -102,10 +102,12 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
 void bnxt_ulp_stop(struct bnxt *bp);
 void bnxt_ulp_start(struct bnxt *bp, int err);
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
-void bnxt_ulp_shutdown(struct bnxt *bp);
 void bnxt_ulp_irq_stop(struct bnxt *bp);
 void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
 void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
+void bnxt_rdma_aux_device_uninit(struct bnxt *bp);
+void bnxt_rdma_aux_device_init(struct bnxt *bp);
+void bnxt_aux_dev_free(struct bnxt *bp);
 struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev);
 
 #endif
-- 
2.37.1 (Apple Git-137.1)


--00000000000061703b05f216fa70
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL5V9Rcr3BgQDj/Hq6cz
PlRa0bIMXC4epnWla/Y3aHgHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExMjIwMjk0N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAbUFjkMBJX8kYkWNK3Ace8NWyeq+Zsp8sZeThx
F+W9GfRB5eJYfSwqHppmhAfcAoxj1a3Zuo1qH/cgVrYsToxgMKWqDF6Ixric49v0QjhmUiq/QhTv
oNv73UP/H1BHeLJ72SWpaGyPbAwKJq6eBfxY0HTNK0Wov1fdwJLKWBysOfaT6FuiizSaMUO5xYji
ein3VsrUazvzJU76TLeEScYC6g32qwSUMNHgcCc0AiwRG9YTuZooTXI63UO41hS2npLXUGmWgZpk
dmh6piNC8DBuDz0kmH6Q1jTOoAocHoBZ7/jWDer6c+v2nJgZ7EzzLepLtn1bWmNRKSJmO5LzcMlx
--00000000000061703b05f216fa70--
