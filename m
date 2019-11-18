Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04811000D2
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfKRI5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:07 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39185 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRI5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so9413205plk.6
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Drinw5FovCIuoevQL8Ir5V5sUhZRBxS95WFE7pwc/Ro=;
        b=d/vsMLeHwMH653k4o74BBjdIhOdHBHrB2h4dzKf5PqLmJNFvA8s0PTjpmRPdewFtQd
         k1aJXeJuQiyca81iKCYSFme+tQPpTES/GhFP0Asy8YSxWq2uX0FJhgi/ScRsM6r4Sh/9
         3Gz8izEo34w8u/s7WbrVLNwXUPb+TmS9wCUIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Drinw5FovCIuoevQL8Ir5V5sUhZRBxS95WFE7pwc/Ro=;
        b=nz/jKuGRTT2ZX/s6Ve97rlgHgdHFfaUDhoJ55+q6VVT7Fjse/M+CWSEI+z4CS9Cyh5
         Vw3y0OAIqZeI/1FnGClFS+ywYGsM/CcEveWVvHKXGjvNqv+2vW0CEQtvyomHK9Jop9Nl
         gQvn+BITtwGObe8bcUUoEqGae7FMsAPRE8GhIWQop6lqVEB6Aati66x+22lGUNGneZ7P
         6NxduyIDpKIiqZejJpqQ9P0T988BX8sgDaP1WETixtxFDaBImYoNYf8F2OYe7pwrckE7
         YVkoFx6MGIY4o1gkWfVs4z9QtwdUyFujHnmFp+DGhbatbq2GJKvpAIqTYMDefewZMp2l
         UAew==
X-Gm-Message-State: APjAAAWEhJlQS5M08zryucm1fQkg7K8Q5o5n8KfY6Zd2I0+VxR3HT72/
        JbOr9m+FjH2pVAIYorCnCxqkqg==
X-Google-Smtp-Source: APXvYqxvKHHF4GYiLqIHVG0Z55G6QRdIaTd3pvx2o1evSdNqqE3UFO9v+0gWzCWWfahw0Z/Es/c01g==
X-Received: by 2002:a17:90a:19d1:: with SMTP id 17mr38156919pjj.52.1574067425091;
        Mon, 18 Nov 2019 00:57:05 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:04 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 4/9] bnxt_en: Extend ETHTOOL_RESET to hot reset driver.
Date:   Mon, 18 Nov 2019 03:56:38 -0500
Message-Id: <1574067403-4344-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If firmware supports hot reset, extend ETHTOOL_RESET to support
hot reset driver which does not require a driver reload after
ETHTOOL_RESET.  The driver will go through the same coordinated
reset sequence as a firmware initiated fatal/non-fatal reset.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 9 +++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0e5b5b8..b081a55 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6947,6 +6947,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->flags |= BNXT_FLAG_ROCEV2_CAP;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PCIE_STATS_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_PCIE_STATS_SUPPORTED;
+	if (flags & FUNC_QCAPS_RESP_FLAGS_HOT_RESET_CAPABLE)
+		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_STATS_SUPPORTED;
 	if (flags &  FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f2b5da7..271085f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1671,6 +1671,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
+	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c5cd8d8..0641020 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1787,6 +1787,8 @@ static int bnxt_firmware_reset(struct net_device *dev,
 	case BNXT_FW_RESET_CHIP:
 		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
 		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
+		if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+			req.flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 		break;
 	case BNXT_FW_RESET_AP:
 		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP;
@@ -2983,7 +2985,8 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		return -EOPNOTSUPP;
 	}
 
-	if (pci_vfs_assigned(bp->pdev)) {
+	if (pci_vfs_assigned(bp->pdev) &&
+	    !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) {
 		netdev_err(dev,
 			   "Reset not allowed when VFs are assigned to VMs\n");
 		return -EBUSY;
@@ -2996,7 +2999,9 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 
 		rc = bnxt_firmware_reset(dev, BNXT_FW_RESET_CHIP);
 		if (!rc) {
-			netdev_info(dev, "Reset request successful. Reload driver to complete reset\n");
+			netdev_info(dev, "Reset request successful.\n");
+			if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
+				netdev_info(dev, "Reload driver to complete reset\n");
 			*flags = 0;
 		}
 	} else if (*flags == ETH_RESET_AP) {
-- 
2.5.1

