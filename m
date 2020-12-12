Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3002D8AAE
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgLLXpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgLLXpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:45:15 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: vxget: clean up sparse warnings
Date:   Sat, 12 Dec 2020 15:44:26 -0800
Message-Id: <20201212234426.177015-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is copying strings in 64 bit quantities, the device
returns them in big endian. As long as we store in big endian
IOW endian on both sides matches, we're good, so swap to_be64,
not from be64.

This fixes ~60 sparse warnings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/neterion/vxge/vxge-config.c   | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index da48dd85770c..5162b938a1ac 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -871,11 +871,11 @@ static enum vxge_hw_status
 __vxge_hw_vpath_card_info_get(struct __vxge_hw_virtualpath *vpath,
 			      struct vxge_hw_device_hw_info *hw_info)
 {
+	__be64 *serial_number = (void *)hw_info->serial_number;
+	__be64 *product_desc = (void *)hw_info->product_desc;
+	__be64 *part_number = (void *)hw_info->part_number;
 	enum vxge_hw_status status;
 	u64 data0, data1 = 0, steer_ctrl = 0;
-	u8 *serial_number = hw_info->serial_number;
-	u8 *part_number = hw_info->part_number;
-	u8 *product_desc = hw_info->product_desc;
 	u32 i, j = 0;
 
 	data0 = VXGE_HW_RTS_ACCESS_STEER_DATA0_MEMO_ITEM_SERIAL_NUMBER;
@@ -887,8 +887,8 @@ __vxge_hw_vpath_card_info_get(struct __vxge_hw_virtualpath *vpath,
 	if (status != VXGE_HW_OK)
 		return status;
 
-	((u64 *)serial_number)[0] = be64_to_cpu(data0);
-	((u64 *)serial_number)[1] = be64_to_cpu(data1);
+	serial_number[0] = cpu_to_be64(data0);
+	serial_number[1] = cpu_to_be64(data1);
 
 	data0 = VXGE_HW_RTS_ACCESS_STEER_DATA0_MEMO_ITEM_PART_NUMBER;
 	data1 = steer_ctrl = 0;
@@ -900,8 +900,8 @@ __vxge_hw_vpath_card_info_get(struct __vxge_hw_virtualpath *vpath,
 	if (status != VXGE_HW_OK)
 		return status;
 
-	((u64 *)part_number)[0] = be64_to_cpu(data0);
-	((u64 *)part_number)[1] = be64_to_cpu(data1);
+	part_number[0] = cpu_to_be64(data0);
+	part_number[1] = cpu_to_be64(data1);
 
 	for (i = VXGE_HW_RTS_ACCESS_STEER_DATA0_MEMO_ITEM_DESC_0;
 	     i <= VXGE_HW_RTS_ACCESS_STEER_DATA0_MEMO_ITEM_DESC_3; i++) {
@@ -915,8 +915,8 @@ __vxge_hw_vpath_card_info_get(struct __vxge_hw_virtualpath *vpath,
 		if (status != VXGE_HW_OK)
 			return status;
 
-		((u64 *)product_desc)[j++] = be64_to_cpu(data0);
-		((u64 *)product_desc)[j++] = be64_to_cpu(data1);
+		product_desc[j++] = cpu_to_be64(data0);
+		product_desc[j++] = cpu_to_be64(data1);
 	}
 
 	return status;
-- 
2.26.2

