Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026312D8CF4
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406380AbgLMMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:00:10 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:48170 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406346AbgLML7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:59:49 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3F99E89A8;
        Sun, 13 Dec 2020 03:51:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3F99E89A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860310;
        bh=7Vsl/Nj8aOSsOzpM7TILQTmm8Q4u5IWl62J04Tv5hEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcU16SEvTKwOb2iaFNbDZ01mRL0zumrxiijr/Hg8NnhKILF+0LT9LdMBgiJQeETIV
         6BtcI9obS4mal7iIDtZ39v4LdopNYy/Mqpy+2rvMuztL0rN3PzpZtg53wMvtCGkLQK
         dqS4hrMYUNFYsonizvxSZJI72Fg5J69J0jRWTRCU=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/5] bnxt_en: Enable batch mode when using HWRM_NVM_MODIFY to flash packages.
Date:   Sun, 13 Dec 2020 06:51:46 -0500
Message-Id: <1607860306-17244-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current scheme allocates a DMA buffer as big as the requested
firmware package file and DMAs the contents to firmware in one
operation.  The buffer size can be several hundred kilo bytes and
the driver may not be able to allocate the memory.  This will cause
firmware upgrade to fail.

Improve the scheme by using smaller DMA blocks and calling firmware to
DMA each block in a batch mode.  Older firmware can cause excessive
NVRAM erases if the block size is too small so we try to allocate a
256K buffer to begin with and size it down successively if we cannot
allocate the memory.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 49 +++++++++++++++----
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 38ab882715c4..9ff79d5d14c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2432,6 +2432,10 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 	return rc;
 }
 
+#define BNXT_PKG_DMA_SIZE	0x40000
+#define BNXT_NVM_MORE_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_MODE))
+#define BNXT_NVM_LAST_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_LAST))
+
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type)
 {
@@ -2442,6 +2446,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	bool defrag_attempted = false;
 	dma_addr_t dma_handle;
 	u8 *kmem = NULL;
+	u32 modify_len;
 	u32 item_len;
 	int rc = 0;
 	u16 index;
@@ -2450,8 +2455,19 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 
 	bnxt_hwrm_cmd_hdr_init(bp, &modify, HWRM_NVM_MODIFY, -1, -1);
 
-	kmem = dma_alloc_coherent(&bp->pdev->dev, fw->size, &dma_handle,
-				  GFP_KERNEL);
+	/* Try allocating a large DMA buffer first.  Older fw will
+	 * cause excessive NVRAM erases when using small blocks.
+	 */
+	modify_len = roundup_pow_of_two(fw->size);
+	modify_len = min_t(u32, modify_len, BNXT_PKG_DMA_SIZE);
+	while (1) {
+		kmem = dma_alloc_coherent(&bp->pdev->dev, modify_len,
+					  &dma_handle, GFP_KERNEL);
+		if (!kmem && modify_len > PAGE_SIZE)
+			modify_len /= 2;
+		else
+			break;
+	}
 	if (!kmem)
 		return -ENOMEM;
 
@@ -2463,6 +2479,8 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	install.install_type = cpu_to_le32(install_type);
 
 	do {
+		u32 copied = 0, len = modify_len;
+
 		rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
 					  BNX_DIR_ORDINAL_FIRST,
 					  BNX_DIR_EXT_NONE,
@@ -2479,14 +2497,26 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		}
 
 		modify.dir_idx = cpu_to_le16(index);
-		modify.len = cpu_to_le32(fw->size);
 
-		memcpy(kmem, fw->data, fw->size);
-		rc = hwrm_send_message(bp, &modify, sizeof(modify),
-				       FLASH_PACKAGE_TIMEOUT);
-		if (rc)
-			break;
+		if (fw->size > modify_len)
+			modify.flags = BNXT_NVM_MORE_FLAG;
+		while (copied < fw->size) {
+			u32 balance = fw->size - copied;
 
+			if (balance <= modify_len) {
+				len = balance;
+				if (copied)
+					modify.flags |= BNXT_NVM_LAST_FLAG;
+			}
+			memcpy(kmem, fw->data + copied, len);
+			modify.len = cpu_to_le32(len);
+			modify.offset = cpu_to_le32(copied);
+			rc = hwrm_send_message(bp, &modify, sizeof(modify),
+					       FLASH_PACKAGE_TIMEOUT);
+			if (rc)
+				goto pkg_abort;
+			copied += len;
+		}
 		mutex_lock(&bp->hwrm_cmd_lock);
 		rc = _hwrm_send_message_silent(bp, &install, sizeof(install),
 					       INSTALL_PACKAGE_TIMEOUT);
@@ -2530,7 +2560,8 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		mutex_unlock(&bp->hwrm_cmd_lock);
 	} while (defrag_attempted && !rc);
 
-	dma_free_coherent(&bp->pdev->dev, fw->size, kmem, dma_handle);
+pkg_abort:
+	dma_free_coherent(&bp->pdev->dev, modify_len, kmem, dma_handle);
 	if (resp.result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
 			   (s8)resp.result, (int)resp.problem_item);
-- 
2.18.1

