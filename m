Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACA62D8CF6
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406484AbgLMMAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:00:50 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:48188 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406353AbgLMMAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 07:00:34 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id E2DE880F0;
        Sun, 13 Dec 2020 03:51:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com E2DE880F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860309;
        bh=43dh5TDpbjPDWI5rP+bxvM4DzJVHggfYvMBC1O0Pmic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQxamTObhzGfayJUG9/0iXSXUgN3b5hTiP5YyKgM4UdB0JqXksUKPODO5W3L/RGFW
         1B/spSnbHIJOAU8TKQR/FKhJzV0Bf3Q/4DId0vvc8o7/+BVpif67WSnbUWyC3fzOq8
         6sItHFNs3V5+QiLG1Gb+QjQ3kx3qA42sOrZjdh68=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 3/5] bnxt_en: Restructure bnxt_flash_package_from_fw_obj() to execute in a loop.
Date:   Sun, 13 Dec 2020 06:51:44 -0500
Message-Id: <1607860306-17244-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

On NICs with a smaller NVRAM, FW installation may fail after multiple
updates due to fragmentation.  The driver can retry when FW returns
a special error code.  To faciliate the retry, we restructure the
logic that performs the flashing in a loop.  The actual retry logic
will be added in the next patch.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 60 +++++++++----------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7635ff84b928..fa4f9941498e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2461,58 +2461,54 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		install_type >>= 16;
 	install.install_type = cpu_to_le32(install_type);
 
-	rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
-				  BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
-				  &index, &item_len, NULL);
-	if (rc) {
-		netdev_err(dev, "PKG update area not created in nvram\n");
-		return rc;
-	}
+	do {
+		rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
+					  BNX_DIR_ORDINAL_FIRST,
+					  BNX_DIR_EXT_NONE,
+					  &index, &item_len, NULL);
+		if (rc) {
+			netdev_err(dev, "PKG update area not created in nvram\n");
+			break;
+		}
+		if (fw->size > item_len) {
+			netdev_err(dev, "PKG insufficient update area in nvram: %lu\n",
+				   (unsigned long)fw->size);
+			rc = -EFBIG;
+			break;
+		}
 
-	if (fw->size > item_len) {
-		netdev_err(dev, "PKG insufficient update area in nvram: %lu\n",
-			   (unsigned long)fw->size);
-		rc = -EFBIG;
-	} else {
 		modify.dir_idx = cpu_to_le16(index);
 		modify.len = cpu_to_le32(fw->size);
 
 		memcpy(kmem, fw->data, fw->size);
 		rc = hwrm_send_message(bp, &modify, sizeof(modify),
 				       FLASH_PACKAGE_TIMEOUT);
-	}
-	if (rc)
-		goto err_exit;
-
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &install, sizeof(install),
-				INSTALL_PACKAGE_TIMEOUT);
-	memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
+		if (rc)
+			break;
 
-	if (rc) {
-		u8 error_code = ((struct hwrm_err_output *)&resp)->cmd_err;
+		mutex_lock(&bp->hwrm_cmd_lock);
+		rc = _hwrm_send_message(bp, &install, sizeof(install),
+					INSTALL_PACKAGE_TIMEOUT);
+		memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
 
-		if (resp.error_code && error_code ==
+		if (rc && ((struct hwrm_err_output *)&resp)->cmd_err ==
 		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
-			install.flags |= cpu_to_le16(
-			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
+			install.flags |=
+				cpu_to_le16(NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
+
 			rc = _hwrm_send_message(bp, &install, sizeof(install),
 						INSTALL_PACKAGE_TIMEOUT);
 			memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
 		}
-		if (rc)
-			goto flash_pkg_exit;
-	}
+		mutex_unlock(&bp->hwrm_cmd_lock);
+	} while (false);
 
+	dma_free_coherent(&bp->pdev->dev, fw->size, kmem, dma_handle);
 	if (resp.result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
 			   (s8)resp.result, (int)resp.problem_item);
 		rc = -ENOPKG;
 	}
-flash_pkg_exit:
-	mutex_unlock(&bp->hwrm_cmd_lock);
-err_exit:
-	dma_free_coherent(&bp->pdev->dev, fw->size, kmem, dma_handle);
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
 	return rc;
-- 
2.18.1

