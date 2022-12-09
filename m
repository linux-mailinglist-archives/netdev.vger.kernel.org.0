Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD77647B32
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLIBPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLIBPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:15:44 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA90CD2C0;
        Thu,  8 Dec 2022 17:15:43 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NStKP2wF7zJpDQ;
        Fri,  9 Dec 2022 09:12:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 09:15:41 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stas.yakovlev@gmail.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linville@tuxdriver.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH v2] ipw2200: fix memory leak in ipw_wdev_init()
Date:   Fri, 9 Dec 2022 09:24:22 +0800
Message-ID: <20221209012422.182669-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error path of ipw_wdev_init(), exception value is returned, and
the memory applied for in the function is not released. Also the memory
is not released in ipw_pci_probe(). As a result, memory leakage occurs.
So memory release needs to be added to the error path of ipw_wdev_init().

Fixes: a3caa99e6c68 ("libipw: initiate cfg80211 API conversion (v2)")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: return value of wiphy_register() instead of -EIO
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5b483de18c81..4c317a7c93ac 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11397,9 +11397,14 @@ static int ipw_wdev_init(struct net_device *dev)
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */
-	if (wiphy_register(wdev->wiphy))
-		rc = -EIO;
+	rc = wiphy_register(wdev->wiphy);
+	if (rc)
+		goto out;
+
+	return 0;
 out:
+	kfree(priv->ieee->a_band.channels);
+	kfree(priv->ieee->bg_band.channels);
 	return rc;
 }
 
-- 
2.34.1

