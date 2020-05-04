Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DDB1C34E6
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgEDIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728394AbgEDIvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B8FC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w3so6530086plz.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kg62eFxgwO2wu4QCcrY1ViR4TKDLoUjlJtZW3IvM6+w=;
        b=VgOtVtRapYBH2bBsGPG4exNU/1cb8rJ+MrdUb1XWZWkZTmC4UWoFeoIUfvOr7AHu5D
         +kbsJ04VnvTWNFHPCsKvBhAKa9+eqhiteg8c1wMbRks8OwviUNJ/6NVc5mg+WsgJ4KOn
         bu08d8hOxEfkeO6QxvwW/PWg46giMqLEZfoPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kg62eFxgwO2wu4QCcrY1ViR4TKDLoUjlJtZW3IvM6+w=;
        b=XOx4zivKFdq+rNCRCBd+mkoKybXf+T0BTHfMuoKXYIzCDQSeh4dNIGOwURQnUl/+ky
         2F+sBjss2BmprD7oeVzeRok2mnEjRky4ZjlgmTjtO/sGOvG8HL1W5aKsPCcyAhiUDAVm
         7ZGZ84nKy6L2vM1s6xYbPft05ONJAoi8bgXALnr4HnK5yEhCN4ZzF+QRXL4ySx+Tt6If
         me69iNjFdyMvbUPmImdhehvlXUP5xTvE5YM/N3CydCSOZhr2qtddZHJFguF+ZDns1JcV
         UoKAGdIEJX/H+dHO+Xm/vmSpmhwSg8ijPmInhUTcwHbm4BelNdNR5+LkrlTPPOD8rISF
         qCmA==
X-Gm-Message-State: AGi0PuZMP6FLS+OAVLcvCPmFEuPvziab4sy5CABNBICIunPu3NOOabRf
        mvWvC9Kj4OkaUzHhMgRJyWDP7A==
X-Google-Smtp-Source: APiQypKcNgag3xsJb7t/53umsV9lu82PRTfPbsnsDkk3sln/BjRd3KdzoO9+mV6WzF1LJGfCUGikHg==
X-Received: by 2002:a17:90a:5584:: with SMTP id c4mr16807387pji.51.1588582268372;
        Mon, 04 May 2020 01:51:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:08 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 06/15] bnxt_en: refactor ethtool firmware reset types
Date:   Mon,  4 May 2020 04:50:32 -0400
Message-Id: <1588582241-31066-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The case statement in bnxt_firmware_reset() dangerously mixes types.
This patch separates the application processor and whole chip resets
from the rest such that the selection is performed on a pure type.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 38 +++++++++++++++--------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ed6a322..d99da82 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1768,10 +1768,10 @@ static int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 	return rc;
 }
 
-static int bnxt_firmware_reset(struct net_device *dev, u16 dir_type)
+static int bnxt_firmware_reset(struct net_device *dev,
+			       enum bnxt_nvm_directory_type dir_type)
 {
 	u8 self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTNONE;
-	struct bnxt *bp = netdev_priv(dev);
 	u8 proc_type, flags = 0;
 
 	/* TODO: Address self-reset of APE/KONG/BONO/TANG or ungraceful reset */
@@ -1798,15 +1798,6 @@ static int bnxt_firmware_reset(struct net_device *dev, u16 dir_type)
 	case BNX_DIR_TYPE_BONO_PATCH:
 		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_ROCE;
 		break;
-	case BNXT_FW_RESET_CHIP:
-		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
-		self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
-		if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
-			flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
-		break;
-	case BNXT_FW_RESET_AP:
-		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP;
-		break;
 	default:
 		return -EINVAL;
 	}
@@ -1814,6 +1805,27 @@ static int bnxt_firmware_reset(struct net_device *dev, u16 dir_type)
 	return bnxt_hwrm_firmware_reset(dev, proc_type, self_reset, flags);
 }
 
+static int bnxt_firmware_reset_chip(struct net_device *dev)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u8 flags = 0;
+
+	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+		flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
+
+	return bnxt_hwrm_firmware_reset(dev,
+					FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP,
+					FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP,
+					flags);
+}
+
+static int bnxt_firmware_reset_ap(struct net_device *dev)
+{
+	return bnxt_hwrm_firmware_reset(dev, FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP,
+					FW_RESET_REQ_SELFRST_STATUS_SELFRSTNONE,
+					0);
+}
+
 static int bnxt_flash_firmware(struct net_device *dev,
 			       u16 dir_type,
 			       const u8 *fw_data,
@@ -3006,7 +3018,7 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		if (bp->hwrm_spec_code < 0x10803)
 			return -EOPNOTSUPP;
 
-		rc = bnxt_firmware_reset(dev, BNXT_FW_RESET_CHIP);
+		rc = bnxt_firmware_reset_chip(dev);
 		if (!rc) {
 			netdev_info(dev, "Reset request successful.\n");
 			if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
@@ -3018,7 +3030,7 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		if (bp->hwrm_spec_code < 0x10803)
 			return -EOPNOTSUPP;
 
-		rc = bnxt_firmware_reset(dev, BNXT_FW_RESET_AP);
+		rc = bnxt_firmware_reset_ap(dev);
 		if (!rc) {
 			netdev_info(dev, "Reset Application Processor request successful.\n");
 			*flags = 0;
-- 
2.5.1

