Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E41118183
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfLJHtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:35 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42839 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfLJHtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:35 -0500
Received: by mail-pl1-f196.google.com with SMTP id x13so6952356plr.9
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hO5+6W/w1Bzyu6K0Y0IvT9WLguPZy1/AoAtZJes3k3A=;
        b=IPTeZmXkTj5Rna9uJ/4Auk8HJsSusmEeWq/Yj64DmQndHWd4Q4Cc9aRkexpI+MuWOX
         cGst6uldHu+iQRHSvjmyCgMXl+GWgjIlqx3Gg82+NHWRu5OrOV+W61BXumGtOdt6oOj4
         MRVKiNjETggg+yiRUgzOihO64DKVRewUqO8so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hO5+6W/w1Bzyu6K0Y0IvT9WLguPZy1/AoAtZJes3k3A=;
        b=Dg0j9jvCrR8DryCtgdCUjNqSNITTYL8xqwpmDv9nqyKEjrAq0LEDT1u+M0kYwXueyn
         GoGCjzDSPWDhMu6x41uIlRjJ5oihLJsKdO/9LLtEvFgqhIPpOBrpkG+khlGvnNDkvVAT
         DovxqRnsup/ZtV7LpsJkekDQTRCi279zas/nmXsI0oAcPpXkOmOdI7QPpDIreox/M45G
         7jtn3CComHUhjOagmEtdbrZlQ3gHoRn1hbgNdJPAShLC3hBx35jKgSZcbPkKHJY86SFS
         XONyROgR1MvMrJlTQb+BjacPFAsN37mtmXFci8e0rbu/Qc06XM2aa1ArDnbtvFZ7sfNb
         NWiA==
X-Gm-Message-State: APjAAAVifPL+NlLE2y0/dIqVkUAygY/yV6F08UOSSTVh010DTDPNjgsW
        uOmktXbI7OqYczC6a0CHFPCQiE4uAH0=
X-Google-Smtp-Source: APXvYqzNiedLwOkY0oJN59Ltn8dS3qzd02b1gVQ7lmNQjaZaqXYU8i0YLK8ZMBG266CySCvrWoamtA==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr10787274pls.328.1575964174209;
        Mon, 09 Dec 2019 23:49:34 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:33 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 4/7] bnxt_en: Fix bp->fw_health allocation and free logic.
Date:   Tue, 10 Dec 2019 02:49:10 -0500
Message-Id: <1575964153-11299-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

bp->fw_health needs to be allocated for either the firmware initiated
reset feature or the driver initiated error recovery feature.  The
current code is not allocating bp->fw_health for all the necessary cases.
This patch corrects the logic to allocate bp->fw_health correctly when
needed.  If allocation fails, we clear the feature flags.

We also add the the missing kfree(bp->fw_health) when the driver is
unloaded.  If we get an async reset message from the firmware, we also
need to make sure that we have a valid bp->fw_health before proceeding.

Fixes: 07f83d72d238 ("bnxt_en: Discover firmware error recovery capabilities.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 ++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 65c1c4e..d6a5fce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2001,6 +2001,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
 		u32 data1 = le32_to_cpu(cmpl->event_data1);
 
+		if (!bp->fw_health)
+			goto async_event_process_exit;
+
 		bp->fw_reset_timestamp = jiffies;
 		bp->fw_reset_min_dsecs = cmpl->timestamp_lo;
 		if (!bp->fw_reset_min_dsecs)
@@ -4421,8 +4424,9 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
 			    FUNC_DRV_RGTR_REQ_ENABLES_ASYNC_EVENT_FWD);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
-	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
-		FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
+	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE;
+	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT |
 			 FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT;
@@ -7115,14 +7119,6 @@ static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
 		goto err_recovery_out;
-	if (!fw_health) {
-		fw_health = kzalloc(sizeof(*fw_health), GFP_KERNEL);
-		bp->fw_health = fw_health;
-		if (!fw_health) {
-			rc = -ENOMEM;
-			goto err_recovery_out;
-		}
-	}
 	fw_health->flags = le32_to_cpu(resp->flags);
 	if ((fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) &&
 	    !(bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL)) {
@@ -10485,6 +10481,23 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
 
+static void bnxt_alloc_fw_health(struct bnxt *bp)
+{
+	if (bp->fw_health)
+		return;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) &&
+	    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return;
+
+	bp->fw_health = kzalloc(sizeof(*bp->fw_health), GFP_KERNEL);
+	if (!bp->fw_health) {
+		netdev_warn(bp->dev, "Failed to allocate fw_health\n");
+		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+	}
+}
+
 static int bnxt_fw_init_one_p1(struct bnxt *bp)
 {
 	int rc;
@@ -10531,6 +10544,7 @@ static int bnxt_fw_init_one_p2(struct bnxt *bp)
 		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
 			    rc);
 
+	bnxt_alloc_fw_health(bp);
 	rc = bnxt_hwrm_error_recovery_qcfg(bp);
 	if (rc)
 		netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
@@ -11418,6 +11432,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	kfree(bp->fw_health);
+	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
-- 
2.5.1

