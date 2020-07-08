Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8441A218672
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgGHLyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgGHLyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71331C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:37 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so48568530wrj.13
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dYvrf8EJ2cIum3i3LNmTXoKf6FTLIiD3cYgEa1HxtDw=;
        b=N8aw7Ga4jCB/TGDnTjDIc48XtJgqWa4LE7YhW2YkUKOgiLU2Rxwy6wU9SzCqbXs96e
         w/htsieb3RijztiM21M9n3ctYABt8eWtIaKhBHJoP3Q0SKAOe0LnSjT3w4gQrAVYL27o
         4L1brUK53LDm2uCXn5obIuWnRzKdslr3+ppeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dYvrf8EJ2cIum3i3LNmTXoKf6FTLIiD3cYgEa1HxtDw=;
        b=FVajGSl4uKkD64Uv2s0Adghm/ghWY2A204tuTkCJu3bnfv7g9QETsi1tc5XIscCWwh
         og68AUvF8M2LNCNZKejQA9z9OHJT5W3NUquKFZoG1jJlDFNq3p30W76CDV5/51tnDHK9
         e4D9jKrH+be7SdY/zLbs7yxFabp7kXA3fPRmqfhDTHMdSKVsTr55KoBgfIVQA8Z7FM4b
         REPAuJOD63XNB3Yt7NvVZIifhXKm1L2CP9Vx5bG0Yc9jYkXCeOibbYorjh0IBkFoTLhb
         ALbyqPsP4nbNJEm5Kgv8ohDen31KcjgGkcO6WLutRJsKd7LBmMelp7qumkxDly2kJeUk
         F4sg==
X-Gm-Message-State: AOAM5334XJMSEZl+g4rimbNwUWWHyUBK3t+6R+/AERGk6pJ5M3MiViO2
        hMzi0llHFAnpmr76hvGQCB+Lqg==
X-Google-Smtp-Source: ABdhPJwvRndASjBgZYlqr4ybl7zLZj1fDEvRN5TzrzJ+fOQAp7SluBDU5XWeAVbLpQJ7OsvjpAxjMA==
X-Received: by 2002:adf:a4cf:: with SMTP id h15mr57447307wrb.229.1594209276031;
        Wed, 08 Jul 2020 04:54:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 9/9] bnxt_en: allow firmware to disable VLAN offloads
Date:   Wed,  8 Jul 2020 07:54:01 -0400
Message-Id: <1594209241-1692-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
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
index 749dc7c..4395623 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5218,6 +5218,14 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
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
@@ -7049,7 +7057,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -7074,6 +7082,12 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
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
@@ -12052,8 +12066,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

