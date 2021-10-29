Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E069443FA4B
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhJ2J5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:57:43 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:49480 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231567AbhJ2J5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 05:57:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uu8FkR3_1635501306;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uu8FkR3_1635501306)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 17:55:12 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     luciano.coelho@intel.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] wlwifi: Fix missing error code in iwl_pci_probe()
Date:   Fri, 29 Oct 2021 17:55:04 +0800
Message-Id: <1635501304-85589-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'ret'.

Eliminate the follow smatch warning:

drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1376 iwl_pci_probe() warn:
missing error code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 1f171f4f1437 ("iwlwifi: Add support for getting rf id with blank otp")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index cff76a528967..33250d24c2b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1442,9 +1442,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (iwl_trans->trans_cfg->rf_id &&
 	    iwl_trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_9000 &&
-	    !CSR_HW_RFID_TYPE(iwl_trans->hw_rf_id) && get_crf_id(iwl_trans))
+	    !CSR_HW_RFID_TYPE(iwl_trans->hw_rf_id) && get_crf_id(iwl_trans)) {
 		ret = -EINVAL;
 		goto out_free_trans;
+	}
 
 	dev_info = iwl_pci_find_dev_info(pdev->device, pdev->subsystem_device,
 					 CSR_HW_REV_TYPE(iwl_trans->hw_rev),
-- 
2.19.1.6.gb485710b

