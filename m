Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8AE377157
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhEHLKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 07:10:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17602 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhEHLKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 07:10:43 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FckzW0QjBz16PYg;
        Sat,  8 May 2021 19:07:03 +0800 (CST)
Received: from localhost (10.174.243.60) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Sat, 8 May 2021
 19:09:29 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <luciano.coelho@intel.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <dingxiaoxiong@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] iwlwifi: pnvm: fix resource leaks in iwl_pnvm_get_from_fs
Date:   Sat, 8 May 2021 19:09:25 +0800
Message-ID: <1620472165-7960-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.60]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the error return path does not release the "pnvm" when
kmemdup fails and also the "pnvm" is not relased in the normal
path. These lead to a resource leak. Fix these by releasing "pnvm"
before return.

Addresses-Coverity: ("Resource leak")
Fixes: cdda18fbbefa ("iwlwifi: pnvm: move file loading code to a separate function")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 40f2109a097f..d4ac83848926 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -322,10 +322,13 @@ static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 	}
 
 	*data = kmemdup(pnvm->data, pnvm->size, GFP_KERNEL);
-	if (!*data)
+	if (!*data) {
+		release_firmware(pnvm);
 		return -ENOMEM;
+	}
 
 	*len = pnvm->size;
+	release_firmware(pnvm);
 
 	return 0;
 }
-- 
2.19.1

