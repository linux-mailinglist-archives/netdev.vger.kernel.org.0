Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD272134D6
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGCHUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgGCHUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65870C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:16 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so31545289wrm.4
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kRgAXLnHk/Ewm1fweDofjzme2yxJuLD+yZ6tkSbz5HU=;
        b=Le9Zca3MezgqXsLMkt1qm7YyD5n9T88drUxYlDbdVKE3hkda7p3aOishKNQmDeAg+n
         AQ5wmOTPpWfs04bj4iqLJYzmgOj3ki6tNWSpYYPWFuf1C3C/OAsaBdoHaPd9LzylWm+r
         phiSt+v15o4MHlwou5CjPNRstN19Yrwz10nx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kRgAXLnHk/Ewm1fweDofjzme2yxJuLD+yZ6tkSbz5HU=;
        b=kBpqHR3/A2WpTB6IJX/g5YU3a5SmXcjD9oXcGHd5UfC0zdeX/L0mVFn5Aum7itZHqZ
         kqUX0fciBJeS1g9/rP/L0J/5LMNL7baVToOTdoPVBJj8I+90iGBkI+uNAot8H9zi3++o
         YyLmHsJ933L7VMJcZTXsybYjUVZ7nqb3z8yHQDfD/2T6ug5AtYClHY+phZWtfZGprC+k
         FqJI68d4PseTazfg34P3pZqH2YPckx8fNBcBHqCTWc2pXs3pobDgjMf4yBcchLF060TP
         Q4Ii8i3AuW+j7maEAHJoF679X3y/FMARkNKJILgoN09721aJV4fNnENNoLttoGS8NObU
         gy8g==
X-Gm-Message-State: AOAM533Bc0FYgasNaBX7LJj3FuwGCjp1AByFKA2dhsY5sVCljmCtNVrH
        8pm9mQlDl3P6mGvRNbT8TeopIA==
X-Google-Smtp-Source: ABdhPJyuTGBHlmUENMHKbROGSVaaRBumXMd61npfcUeW8FiuMzj6cAqvuIHir2g7ZyUkL0w+YBoNaQ==
X-Received: by 2002:a5d:6786:: with SMTP id v6mr34800808wru.258.1593760814965;
        Fri, 03 Jul 2020 00:20:14 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 8/8] bnxt_en: allow firmware to disable VLAN offloads
Date:   Fri,  3 Jul 2020 03:19:47 -0400
Message-Id: <1593760787-31695-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Bare-metal use cases require giving firmware and the embedded
application processor control over VLAN offloads. The driver should
not attempt to override or utilize this feature in such scenarios
since it will not work as expected.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 22 +++++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  3 +++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c7a6a2a..5553bad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5208,6 +5208,14 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		if (flags &
 		    VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP)
 			bp->flags |= BNXT_FLAG_ROCE_MIRROR_CAP;
+
+		/* Older P5 fw before EXT_HW_STATS support did not set
+		 * VLAN_STRIP_CAP properly.
+		 */
+		if ((flags & VNIC_QCAPS_RESP_FLAGS_VLAN_STRIP_CAP) ||
+		    ((bp->flags & BNXT_FLAG_CHIP_P5) &&
+		     !(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED)))
+			bp->fw_cap |= BNXT_FW_CAP_VLAN_RX_STRIP;
 		bp->max_tpa_v2 = le16_to_cpu(resp->max_aggs_supported);
 		if (bp->max_tpa_v2)
 			bp->hw_ring_stats_size =
@@ -7028,7 +7036,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -7053,6 +7061,12 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_ERROR_RECOVERY;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD)
 		bp->fw_cap |= BNXT_FW_CAP_ERR_RECOVER_RELOAD;
+	if (!(flags & FUNC_QCAPS_RESP_FLAGS_VLAN_ACCELERATION_TX_DISABLED))
+		bp->fw_cap |= BNXT_FW_CAP_VLAN_TX_INSERT;
+
+	flags_ext = le32_to_cpu(resp->flags_ext);
+	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED;
 
 	bp->tx_push_thresh = 0;
 	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
@@ -12031,8 +12045,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				    NETIF_F_GSO_GRE_CSUM;
 	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
-	dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX |
-			    BNXT_HW_FEATURE_VLAN_ALL_TX;
+	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
+		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
+		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_TX;
 	if (BNXT_SUPPORTS_TPA(bp))
 		dev->hw_features |= NETIF_F_GRO_HW;
 	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 13c4064..d556e56 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1716,6 +1716,9 @@ struct bnxt {
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 	#define BNXT_FW_CAP_SHARED_PORT_CFG		0x00400000
+	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
+	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
+	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
-- 
1.8.3.1

