Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA25E20E02B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389523AbgF2Un2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbgF2TOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F7EC08EB2E
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:35:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c1so324426pja.5
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Inm1E3UJpSD3TteRF3ctSMKegmN4/9AFV8PgSbT0xC8=;
        b=BrSfno1HxPHmeo+WC5AcCbVHAoxw1mFyygX02x2EypUHOxt8kkIm+ooTcISnPHPgw0
         3nrh4RA5+8rDe5a8EPqFEosu62912ZmVvlx4Y6CmK7zzhxogQ9oY65lrHjhkiqwzIA1z
         Ast7sp6sLzi2Ms8vK4h49nzaSaQPYK5/Ko7B4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Inm1E3UJpSD3TteRF3ctSMKegmN4/9AFV8PgSbT0xC8=;
        b=giHtPHr7+JfHig5uB7JH7jVh03a+82W+7C6dnIcYkjQbF6y5HKtQeb6alCpihyefQ2
         Y5h7gpguXfYzcZU3VLGkoZd3I/j7NeKGvUG6xMQdc+zHGU0ZApS6cJOFSfv0jlHvsEP4
         Qgo26TsDCchW430sQspXt+W0oU81FEeLOntidF/zT4QPpS7AuAjgx2ekpAsli9rCPnRH
         RDLBE1++RXFOR13YqcJPG36RKA2YgrVsmwpI/nqMpk+kaVt0Opvb1GsnlRRob0TpIqv+
         fZpKHlnf4cdTT2Iv/tcvCgjc6VO9dgY28SYsj6DMOXroGh0ZgRSZvoyGuQg5CNqBTNXx
         kP7w==
X-Gm-Message-State: AOAM5308Dxhyz5lZcbh2jqENj/rikbGX8WQiTRrTjxDx9Z5n4Z8AOl+W
        7OU+tL7x5kbrA/7hFTF2MqBxXQ==
X-Google-Smtp-Source: ABdhPJwPbUsEzmI65OAB9Dvb/5woYfvJgx5sSK4pmI7LgAukdrqNPt+tS6+7g7adtuSRgwAQHuN/4g==
X-Received: by 2002:a17:90b:698:: with SMTP id m24mr1275507pjz.15.1593412507146;
        Sun, 28 Jun 2020 23:35:07 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.35.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:35:06 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 8/8] bnxt_en: allow firmware to disable VLAN offloads
Date:   Mon, 29 Jun 2020 02:34:24 -0400
Message-Id: <1593412464-503-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
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
index 4f8fc28..451e0ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5210,6 +5210,14 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
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
@@ -7030,7 +7038,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -7055,6 +7063,12 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
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
@@ -12033,8 +12047,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

