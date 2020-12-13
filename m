Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C50B2D8CF2
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406335AbgLML7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:59:41 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:48158 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406111AbgLML7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:59:38 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2020 06:59:37 EST
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9B7C780E3;
        Sun, 13 Dec 2020 03:51:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9B7C780E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860308;
        bh=tNZ2QE5xM5XntgPhPqhkf0PDpB7Xwzw8/nYf2VJt7+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQdMSE0T8rPY9HUfCEA9cyDXhH1bVKERnK4XdVGW9WOngX6FAxsoK8UQw1vOOjf6N
         CYtuh8OLhIMZy4eAsX5X1bDwwCyVML7i8SjQFeNcWOzR7QUPrlnpNvk4SwAQJEyqrK
         F16Y3PH4X3yIE7tEZcSOLnmfJCBqx5f5ABFXQGxY=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 1/5] bnxt_en: Refactor bnxt_flash_nvram.
Date:   Sun, 13 Dec 2020 06:51:42 -0500
Message-Id: <1607860306-17244-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Refactor bnxt_flash_nvram() into __bnxt_flash_nvram() that takes an
additional dir_item_len parameter.  The new function will be used
in subsequent patches with the dir_item_len parameter set to create
the UPDATE directory during flashing.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 51 ++++++++++++-------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7b444fcb6289..11edf4998de7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2100,19 +2100,16 @@ static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
 				u16 ext, u16 *index, u32 *item_length,
 				u32 *data_length);
 
-static int bnxt_flash_nvram(struct net_device *dev,
-			    u16 dir_type,
-			    u16 dir_ordinal,
-			    u16 dir_ext,
-			    u16 dir_attr,
-			    const u8 *data,
-			    size_t data_len)
+static int __bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+			      u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+			      u32 dir_item_len, const u8 *data,
+			      size_t data_len)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
 	struct hwrm_nvm_write_input req = {0};
 	dma_addr_t dma_handle;
-	u8 *kmem;
+	u8 *kmem = NULL;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_WRITE, -1, -1);
 
@@ -2120,26 +2117,42 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	req.dir_ordinal = cpu_to_le16(dir_ordinal);
 	req.dir_ext = cpu_to_le16(dir_ext);
 	req.dir_attr = cpu_to_le16(dir_attr);
-	req.dir_data_length = cpu_to_le32(data_len);
+	req.dir_item_length = cpu_to_le32(dir_item_len);
+	if (data_len && data) {
+		req.dir_data_length = cpu_to_le32(data_len);
 
-	kmem = dma_alloc_coherent(&bp->pdev->dev, data_len, &dma_handle,
-				  GFP_KERNEL);
-	if (!kmem) {
-		netdev_err(dev, "dma_alloc_coherent failure, length = %u\n",
-			   (unsigned)data_len);
-		return -ENOMEM;
+		kmem = dma_alloc_coherent(&bp->pdev->dev, data_len, &dma_handle,
+					  GFP_KERNEL);
+		if (!kmem)
+			return -ENOMEM;
+
+		memcpy(kmem, data, data_len);
+		req.host_src_addr = cpu_to_le64(dma_handle);
 	}
-	memcpy(kmem, data, data_len);
-	req.host_src_addr = cpu_to_le64(dma_handle);
 
-	rc = hwrm_send_message(bp, &req, sizeof(req), FLASH_NVRAM_TIMEOUT);
-	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), FLASH_NVRAM_TIMEOUT);
+	if (kmem)
+		dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
 
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
 	return rc;
 }
 
+static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+			    const u8 *data, size_t data_len)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int rc;
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = __bnxt_flash_nvram(dev, dir_type, dir_ordinal, dir_ext, dir_attr,
+				0, data, data_len);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 				    u8 self_reset, u8 flags)
 {
-- 
2.18.1

