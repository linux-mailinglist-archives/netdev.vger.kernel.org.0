Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A37D2D8CF5
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406401AbgLMMA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:00:26 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:48154 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406353AbgLML7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:59:53 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9615A8289;
        Sun, 13 Dec 2020 03:51:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9615A8289
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860310;
        bh=/PxFOWytsI2v5AxOWJfIsEVsm0W5cBxZ9qJWhzIsoyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXKRcHUHOUR2RqbLQaTZMfjzkzySsDoiBcGzeSnvwH5Fmw0HpuP5eWUDxOJiivJr0
         uKquN0Vgr0kfnbIWJQdZiR6hAolsjIIru180EqXeO2WRAXVCdAyrkaw9nMV1LCB5D7
         Fv6HWP1nH/HdLrDI6Yflw1u1mWOiHDDgs1Obe2Kc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 4/5] bnxt_en: Retry installing FW package under NO_SPACE error condition.
Date:   Sun, 13 Dec 2020 06:51:45 -0500
Message-Id: <1607860306-17244-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

In bnxt_flash_package_from_fw_obj(), if firmware returns the NO_SPACE
error, call __bnxt_flash_nvram() to create the UPDATE directory and
then loop back and retry one more time.

Since the first try may fail, we use the silent version to send the
firmware commands.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 37 ++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index fa4f9941498e..38ab882715c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2439,6 +2439,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	struct hwrm_nvm_install_update_output resp = {0};
 	struct hwrm_nvm_modify_input modify = {0};
 	struct bnxt *bp = netdev_priv(dev);
+	bool defrag_attempted = false;
 	dma_addr_t dma_handle;
 	u8 *kmem = NULL;
 	u32 item_len;
@@ -2487,21 +2488,47 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 			break;
 
 		mutex_lock(&bp->hwrm_cmd_lock);
-		rc = _hwrm_send_message(bp, &install, sizeof(install),
-					INSTALL_PACKAGE_TIMEOUT);
+		rc = _hwrm_send_message_silent(bp, &install, sizeof(install),
+					       INSTALL_PACKAGE_TIMEOUT);
 		memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
 
+		if (defrag_attempted) {
+			/* We have tried to defragment already in the previous
+			 * iteration. Return with the result for INSTALL_UPDATE
+			 */
+			mutex_unlock(&bp->hwrm_cmd_lock);
+			break;
+		}
+
 		if (rc && ((struct hwrm_err_output *)&resp)->cmd_err ==
 		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |=
 				cpu_to_le16(NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 
-			rc = _hwrm_send_message(bp, &install, sizeof(install),
-						INSTALL_PACKAGE_TIMEOUT);
+			rc = _hwrm_send_message_silent(bp, &install,
+						       sizeof(install),
+						       INSTALL_PACKAGE_TIMEOUT);
 			memcpy(&resp, bp->hwrm_cmd_resp_addr, sizeof(resp));
+
+			if (rc && ((struct hwrm_err_output *)&resp)->cmd_err ==
+			    NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE) {
+				/* FW has cleared NVM area, driver will create
+				 * UPDATE directory and try the flash again
+				 */
+				defrag_attempted = true;
+				rc = __bnxt_flash_nvram(bp->dev,
+							BNX_DIR_TYPE_UPDATE,
+							BNX_DIR_ORDINAL_FIRST,
+							0, 0, item_len, NULL,
+							0);
+			} else if (rc) {
+				netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x\n", rc);
+			}
+		} else if (rc) {
+			netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x\n", rc);
 		}
 		mutex_unlock(&bp->hwrm_cmd_lock);
-	} while (false);
+	} while (defrag_attempted && !rc);
 
 	dma_free_coherent(&bp->pdev->dev, fw->size, kmem, dma_handle);
 	if (resp.result) {
-- 
2.18.1

