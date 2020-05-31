Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEFD1E9605
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgEaHHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387402AbgEaHHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:07:05 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010D7C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:07:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so8265971wrt.5
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zuuk8Jvs9y7tcShD/HoX533qMHYTmDPbvbQa4HuJiek=;
        b=avP81T3Lbn0+xWjSrTlCnPZ3mLJAdIHWVMCjMTVlO3yzx9z2th1CUKNPMJgqHxuLr5
         qgTr3qKQGnKZAzv20oTAD21/zNYA9B6dhQ2d+zgyVqebKB8/cjM2a6Y0orVlbObyAWn8
         oKvlVNSQF6dV37W8tmcPM0Ds2TbILAW91hCQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zuuk8Jvs9y7tcShD/HoX533qMHYTmDPbvbQa4HuJiek=;
        b=dsVBQMMJdK0SSz7XY/dxDlIKXxmVdH/UrM57Pgfw49SKNlx7oqgm9fF271JjIi2NOI
         vOzj+46qWjkcqTEBH9o4Bczhu+7TfanYn1XwUXsJ4BdY1hGKt97kzZkV2pU5HFPrKe07
         wIiVk7J69RXUs+CMwzV+pcUJMnl8W0XFUleeTnfAvP1jNEKVQ3oZ94iu1e4fgAOzPKE0
         AalfuPIRBfuDwxwqhhNcYF+sRzrDNGlwhdYQwE365qkCEEEzkZkbI6shljfWytAyz8HL
         /cJqSaewYBHaWsMuJns/oC/5tlMiFGr1KKsgUPMwxkPXUNXuYiwhw6TpoHX4pNIHaCEO
         xwpg==
X-Gm-Message-State: AOAM533UFmzuI7nVs159Sp091oxMK39YMrcWOD+hQBM+T5FqXgnDxNEv
        ptKQyW3tP4qo/jryiz9yIDZ4Nd+BHOs=
X-Google-Smtp-Source: ABdhPJyJ2TnQbjwFXxzIaQ+E6rFN5J4Acoy2PalepdaRQrcYm0OjjZx9yn7WQ7Ymo7+Nph3+n6Oqhg==
X-Received: by 2002:adf:c98a:: with SMTP id f10mr4855861wrh.329.1590908823634;
        Sun, 31 May 2020 00:07:03 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.07.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:07:03 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 6/6] bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
Date:   Sun, 31 May 2020 12:33:45 +0530
Message-Id: <1590908625-10952-7-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If device does not allow fw_live_reset, issue FW_RESET command
without graceful flag, which requires a driver reload to reset
the firmware.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dd0c3f2..e5eb8d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1888,12 +1888,11 @@ static int bnxt_firmware_reset(struct net_device *dev,
 	return bnxt_hwrm_firmware_reset(dev, proc_type, self_reset, flags);
 }
 
-static int bnxt_firmware_reset_chip(struct net_device *dev)
+static int bnxt_firmware_reset_chip(struct net_device *dev, bool hot_reset)
 {
-	struct bnxt *bp = netdev_priv(dev);
 	u8 flags = 0;
 
-	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+	if (hot_reset)
 		flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 
 	return bnxt_hwrm_firmware_reset(dev,
@@ -3082,7 +3081,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 static int bnxt_reset(struct net_device *dev, u32 *flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	bool reload = false;
+	bool reload = false, hot_reset;
 	u32 req = *flags;
 
 	if (!req)
@@ -3093,8 +3092,10 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		return -EOPNOTSUPP;
 	}
 
-	if (pci_vfs_assigned(bp->pdev) &&
-	    !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) {
+	if (bnxt_hwrm_get_hot_reset(bp, &hot_reset))
+		hot_reset = !!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET);
+
+	if (pci_vfs_assigned(bp->pdev) && !hot_reset) {
 		netdev_err(dev,
 			   "Reset not allowed when VFs are assigned to VMs\n");
 		return -EBUSY;
@@ -3103,9 +3104,9 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 	if ((req & BNXT_FW_RESET_CHIP) == BNXT_FW_RESET_CHIP) {
 		/* This feature is not supported in older firmware versions */
 		if (bp->hwrm_spec_code >= 0x10803) {
-			if (!bnxt_firmware_reset_chip(dev)) {
+			if (!bnxt_firmware_reset_chip(dev, hot_reset)) {
 				netdev_info(dev, "Firmware reset request successful.\n");
-				if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
+				if (!hot_reset)
 					reload = true;
 				*flags &= ~BNXT_FW_RESET_CHIP;
 			}
-- 
1.8.3.1

