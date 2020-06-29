Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FE020D117
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgF2Si2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:38:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728022AbgF2Si0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:38:26 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2C51613923748716BC46;
        Mon, 29 Jun 2020 18:47:47 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 29 Jun 2020
 18:47:41 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hariprasad@chelsio.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: cxgb4: fix return error value in t4_prep_fw
Date:   Mon, 29 Jun 2020 18:49:51 +0800
Message-ID: <1593427791-41194-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t4_prep_fw goto bye tag with positive return value when something
bad happened and which can not free resource in adap_init0.
so fix it to return negative value.

Fixes: 16e47624e76b ("cxgb4: Add new scheme to update T4/T5 firmware")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 2a3480f..9121cef 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3493,7 +3493,7 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 	drv_fw = &fw_info->fw_hdr;

 	/* Read the header of the firmware on the card */
-	ret = -t4_read_flash(adap, FLASH_FW_START,
+	ret = t4_read_flash(adap, FLASH_FW_START,
 			    sizeof(*card_fw) / sizeof(uint32_t),
 			    (uint32_t *)card_fw, 1);
 	if (ret == 0) {
@@ -3522,8 +3522,8 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 		   should_install_fs_fw(adap, card_fw_usable,
 					be32_to_cpu(fs_fw->fw_ver),
 					be32_to_cpu(card_fw->fw_ver))) {
-		ret = -t4_fw_upgrade(adap, adap->mbox, fw_data,
-				     fw_size, 0);
+		ret = t4_fw_upgrade(adap, adap->mbox, fw_data,
+				    fw_size, 0);
 		if (ret != 0) {
 			dev_err(adap->pdev_dev,
 				"failed to install firmware: %d\n", ret);
@@ -3554,7 +3554,7 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 			FW_HDR_FW_VER_MICRO_G(c), FW_HDR_FW_VER_BUILD_G(c),
 			FW_HDR_FW_VER_MAJOR_G(k), FW_HDR_FW_VER_MINOR_G(k),
 			FW_HDR_FW_VER_MICRO_G(k), FW_HDR_FW_VER_BUILD_G(k));
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto bye;
 	}

--
2.7.4

