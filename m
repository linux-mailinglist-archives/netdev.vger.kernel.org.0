Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8CC4DD368
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiCRDD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiCRDDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:03:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1838F1FDFD7;
        Thu, 17 Mar 2022 20:02:07 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KKTKJ3hV9zfYpG;
        Fri, 18 Mar 2022 11:00:36 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 18 Mar
 2022 11:02:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <luciano.coelho@intel.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ayala.beker@intel.com>, <emmanuel.grumbach@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] wlwifi: mei: Fix build error without CFG80211
Date:   Fri, 18 Mar 2022 11:01:49 +0800
Message-ID: <20220318030149.1328-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CFG80211 is n and IWLMEI is y,  building fails:

drivers/net/wireless/intel/iwlwifi/mei/net.o: In function `iwl_mei_tx_copy_to_csme':
net.c:(.text+0xd0): undefined reference to `ieee80211_hdrlen'

Make IWLMEI depends on CFG80211 to fix this.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 85e704283755..8c003cd29ab7 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -137,7 +137,7 @@ endif
 
 config IWLMEI
 	tristate "Intel Management Engine communication over WLAN"
-	depends on INTEL_MEI
+	depends on INTEL_MEI && CFG80211
 	depends on PM
 	help
 	  Enables the iwlmei kernel module.
-- 
2.17.1

