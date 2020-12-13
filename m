Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899AC2D8CF3
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406362AbgLML7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:59:55 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:48162 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406190AbgLML7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:59:38 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 4503E80F7;
        Sun, 13 Dec 2020 03:51:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 4503E80F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860308;
        bh=Y4cUPMVMoyMz3tkDSp2GmiiUqUC0vfBHX/x/FkaW8kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFkm8+XQG076nFW6Dpli9hkmX5UPy+IAmbk7PtM1Kb7HyVZO1cdxCTmC2ePyiV0yF
         6KiBsTZZpZ+RNfzTeH8elrVNSatxwyr4yw9rWd7+OHApnN1xx2b/jtmNKNAFTcAae8
         3TKlDH9HhMsW0c/NlCh7zJYbzCOC5958zCc8ErPc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Michael Chan <michael.chan@broadocm.com>
Subject: [PATCH net-next 2/5] bnxt_en: Rearrange the logic in bnxt_flash_package_from_fw_obj().
Date:   Sun, 13 Dec 2020 06:51:43 -0500
Message-Id: <1607860306-17244-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function will be modified in the next patch to retry flashing
the firmware in a loop.  To facilate that, we rearrange the code so
that the steps that only need to be done once before the loop will be
moved to the top of the function.

Signed-off-by: Michael Chan <michael.chan@broadocm.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 63 +++++++++----------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 11edf4998de7..7635ff84b928 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2435,15 +2435,32 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type)
 {
-	struct bnxt *bp = netdev_priv(dev);
-	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_nvm_install_update_input install = {0};
+	struct hwrm_nvm_install_update_output resp = {0};
+	struct hwrm_nvm_modify_input modify = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	dma_addr_t dma_handle;
+	u8 *kmem = NULL;
 	u32 item_len;
 	int rc = 0;
 	u16 index;
 
 	bnxt_hwrm_fw_set_time(bp);
 
+	bnxt_hwrm_cmd_hdr_init(bp, &modify, HWRM_NVM_MODIFY, -1, -1);
+
+	kmem = dma_alloc_coherent(&bp->pdev->dev, fw->size, &dma_handle,
+				  GFP_KERNEL);
+	if (!kmem)
+		return -ENOMEM;
+
+	modify.host_src_addr = cpu_to_le64(dma_handle);
+
+	bnxt_hwrm_cmd_hdr_init(bp, &install, HWRM_NVM_INSTALL_UPDATE, -1, -1);
+	if ((install_type & 0xffff) == 0)
+		install_type >>= 16;
+	install.install_type = cpu_to_le32(install_type);
+
 	rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
 				  BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
 				  &index, &item_len, NULL);
@@ -2457,65 +2474,45 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 			   (unsigned long)fw->size);
 		rc = -EFBIG;
 	} else {
-		dma_addr_t dma_handle;
-		u8 *kmem;
-		struct hwrm_nvm_modify_input modify = {0};
-
-		bnxt_hwrm_cmd_hdr_init(bp, &modify, HWRM_NVM_MODIFY, -1, -1);
-
 		modify.dir_idx = cpu_to_le16(index);
 		modify.len = cpu_to_le32(fw->size);
 
-		kmem = dma_alloc_coherent(&bp->pdev->dev, fw->size,
-					  &dma_handle, GFP_KERNEL);
-		if (!kmem) {
-			netdev_err(dev,
-				   "dma_alloc_coherent failure, length = %u\n",
-				   (unsigned int)fw->size);
-			rc = -ENOMEM;
-		} else {
-			memcpy(kmem, fw->data, fw->size);
-			modify.host_src_addr = cpu_to_le64(dma_handle);
-
-			rc = hwrm_send_message(bp, &modify, sizeof(modify),
-					       FLASH_PACKAGE_TIMEOUT);
-			dma_free_coherent(&bp->pdev->dev, fw->size, kmem,
-					  dma_handle);
-		}
+		memcpy(kmem, fw->data, fw->size);
+		rc = hwrm_send_message(bp, &modify, sizeof(modify),
+				       FLASH_PACKAGE_TIMEOUT);
 	}
 	if (rc)
 		goto err_exit;
 
-	if ((install_type & 0xffff) == 0)
-		install_type >>= 16;
-	bnxt_hwrm_cmd_hdr_init(bp, &install, HWRM_NVM_INSTALL_UPDATE, -1, -1);
-	install.install_type = cpu_to_le32(install_type);
-
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &install, sizeof(install),
 				INSTALL_PACKAGE_TIMEOUT);
+	memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
+
 	if (rc) {
-		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
+		u8 error_code = ((struct hwrm_err_output *)&resp)->cmd_err;
 
-		if (resp->error_code && error_code ==
+		if (resp.error_code && error_code ==
 		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 			rc = _hwrm_send_message(bp, &install, sizeof(install),
 						INSTALL_PACKAGE_TIMEOUT);
+			memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
 		}
 		if (rc)
 			goto flash_pkg_exit;
 	}
 
-	if (resp->result) {
+	if (resp.result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
-			   (s8)resp->result, (int)resp->problem_item);
+			   (s8)resp.result, (int)resp.problem_item);
 		rc = -ENOPKG;
 	}
 flash_pkg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 err_exit:
+	dma_free_coherent(&bp->pdev->dev, fw->size, kmem, dma_handle);
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
 	return rc;
-- 
2.18.1

