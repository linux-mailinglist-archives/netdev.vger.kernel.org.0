Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64225A1ED1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbiHZCa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbiHZCa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:30:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDAA3AE72;
        Thu, 25 Aug 2022 19:30:25 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MDNy31VtszkWKl;
        Fri, 26 Aug 2022 10:26:51 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 10:30:23 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 26 Aug
 2022 10:30:23 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <tony0620emma@gmail.com>, <kvalo@kernel.org>, <phhuang@realtek.com>
Subject: [PATCH -next v2] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Date:   Fri, 26 Aug 2022 10:38:17 +0800
Message-ID: <20220826023817.3908255-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing destroy_workqueue() before return from rtw_core_init()
in error path.

Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  Change labe name to 'out'.
---
 drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 790dcfed1125..475ce0e3071c 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2094,7 +2094,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
 	if (ret) {
 		rtw_warn(rtwdev, "no firmware loaded\n");
-		return ret;
+		goto out;
 	}
 
 	if (chip->wow_fw_name) {
@@ -2104,11 +2104,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 			wait_for_completion(&rtwdev->fw.completion);
 			if (rtwdev->fw.firmware)
 				release_firmware(rtwdev->fw.firmware);
-			return ret;
+			goto out;
 		}
 	}
 
 	return 0;
+
+out:
+	destroy_workqueue(rtwdev->tx_wq);
+	return ret;
 }
 EXPORT_SYMBOL(rtw_core_init);
 
-- 
2.25.1

