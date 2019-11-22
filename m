Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596CD1060A6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfKVFuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:50:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfKVFux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF4F2072E;
        Fri, 22 Nov 2019 05:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401852;
        bh=S615hVEhfTbt+JvODgP4V36d/mpY9ddDExp/9W+7x+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA1K19feAr7FPZ0sUTb0XORcSjKuldPg+6P8lqPG6wk0GFRGzQ1A+BaMAKa2728Bz
         QeO3PGhken9mLny45xCu+tyvI8/S/gHv73WKvZsooVnXJPQ5sinc7oQYuHEVJP7v2A
         LTO5SWBTdyFe+Z2A4W9ocXZP5vCXffF5Eifr4RCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 090/219] bnxt_en: Return linux standard errors in bnxt_ethtool.c
Date:   Fri, 22 Nov 2019 00:47:02 -0500
Message-Id: <20191122054911.1750-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 7c675421afef18253a86ffc383f57bc15ef32ea8 ]

Currently firmware specific errors are returned directly in flash_device
and reset ethtool hooks. Modify it to return linux standard errors
to userspace when flashing operations fail.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 56 +++++++++++++------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index da9b876899963..eaa285bf908b9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1444,14 +1444,22 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	rc = hwrm_send_message(bp, &req, sizeof(req), FLASH_NVRAM_TIMEOUT);
 	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
 
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to flash the device\n");
+		rc = -EACCES;
+	} else if (rc) {
+		rc = -EIO;
+	}
 	return rc;
 }
 
 static int bnxt_firmware_reset(struct net_device *dev,
 			       u16 dir_type)
 {
-	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_fw_reset_input req = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
 
@@ -1491,7 +1499,15 @@ static int bnxt_firmware_reset(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to reset the device\n");
+		rc = -EACCES;
+	} else if (rc) {
+		rc = -EIO;
+	}
+	return rc;
 }
 
 static int bnxt_flash_firmware(struct net_device *dev,
@@ -1698,9 +1714,9 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_nvm_install_update_input install = {0};
 	const struct firmware *fw;
+	int rc, hwrm_err = 0;
 	u32 item_len;
 	u16 index;
-	int rc;
 
 	bnxt_hwrm_fw_set_time(bp);
 
@@ -1743,15 +1759,16 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 			memcpy(kmem, fw->data, fw->size);
 			modify.host_src_addr = cpu_to_le64(dma_handle);
 
-			rc = hwrm_send_message(bp, &modify, sizeof(modify),
-					       FLASH_PACKAGE_TIMEOUT);
+			hwrm_err = hwrm_send_message(bp, &modify,
+						     sizeof(modify),
+						     FLASH_PACKAGE_TIMEOUT);
 			dma_free_coherent(&bp->pdev->dev, fw->size, kmem,
 					  dma_handle);
 		}
 	}
 	release_firmware(fw);
-	if (rc)
-		return rc;
+	if (rc || hwrm_err)
+		goto err_exit;
 
 	if ((install_type & 0xffff) == 0)
 		install_type >>= 16;
@@ -1759,12 +1776,10 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	install.install_type = cpu_to_le32(install_type);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &install, sizeof(install),
-				INSTALL_PACKAGE_TIMEOUT);
-	if (rc) {
-		rc = -EOPNOTSUPP;
+	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
+				      INSTALL_PACKAGE_TIMEOUT);
+	if (hwrm_err)
 		goto flash_pkg_exit;
-	}
 
 	if (resp->error_code) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
@@ -1772,12 +1787,11 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 		if (error_code == NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
-			rc = _hwrm_send_message(bp, &install, sizeof(install),
-						INSTALL_PACKAGE_TIMEOUT);
-			if (rc) {
-				rc = -EOPNOTSUPP;
+			hwrm_err = _hwrm_send_message(bp, &install,
+						      sizeof(install),
+						      INSTALL_PACKAGE_TIMEOUT);
+			if (hwrm_err)
 				goto flash_pkg_exit;
-			}
 		}
 	}
 
@@ -1788,6 +1802,14 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	}
 flash_pkg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
+err_exit:
+	if (hwrm_err == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to flash the device\n");
+		rc = -EACCES;
+	} else if (hwrm_err) {
+		rc = -EOPNOTSUPP;
+	}
 	return rc;
 }
 
-- 
2.20.1

