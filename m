Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3B21502C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgGEWW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA76C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t15so1755937pjq.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RKIOGmVt1hPZeAINg/OgX8E+IyHiXYWzOy8dFPygyyY=;
        b=MBadmLGvB8aVRUQn+x91djpRxM3vJz43D7kcctv50N+B5BboDcraqediDpXDjCe3G1
         w8Ek3Qmo9QX63HGZgKbG03dX8w6ABqKJ2HVSXuFvCJOHZteuVWm58LVqOVfJzcPmcyYA
         qbL+O4utQTAunwzAY+6F1xOZmro414H4up/fk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RKIOGmVt1hPZeAINg/OgX8E+IyHiXYWzOy8dFPygyyY=;
        b=lIEEkHqsZEeXww4xQ7cXQg6c0LlgRf11jyHxR7xosNyRVTS7iebm5kyIN8MaeS+Aq2
         RNf1Vs45tOcd9sFSvzrc5sxeRtrwI/zy0lV4/moN5g+X8gCSNQW5ZaC2I1sdYlf5+mG0
         rNg9gvdibdB5rYNEtlK8j1QZ7CAdfp+aER8i1tJpIrHSurf0GtPBwJrSzIXS4gtwb3NP
         o2oBdkw+sXZ9XilSvX1wM2WpRd+SplEsPDjy2pIdlJICxgFjd0IGM6gT006O7iFZNiUy
         GHhUuaU6VanAggLDWBwcVsKWx3u6KOvNklilNDNqN1+RASogU4NuN6o//AQnw5IkuTkP
         QFpA==
X-Gm-Message-State: AOAM5337mk4Zj0W3Ilh4hNdgMFajGZS4YZR/BshkZw+YHzPBqYZ4Vgf2
        BhdtBu5G4gqfvjnkItmpOnY/CS3GZZ0=
X-Google-Smtp-Source: ABdhPJzB4iI1dEOEQDbzPt00Haf0YRluMMFFEULfirFYgVaaeOUTOEyoU0UO70WuVIB6A9c6k6gVLg==
X-Received: by 2002:a17:90a:20e9:: with SMTP id f96mr49758379pjg.13.1593987777983;
        Sun, 05 Jul 2020 15:22:57 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 8/8] bnxt_en: allow firmware to disable VLAN offloads
Date:   Sun,  5 Jul 2020 18:22:12 -0400
Message-Id: <1593987732-1336-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
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
index 586ecfb..072962c 100644
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
@@ -7034,7 +7042,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -7059,6 +7067,12 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
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
@@ -12037,8 +12051,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

