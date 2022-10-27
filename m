Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61260FA16
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiJ0OFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiJ0OEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:04:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CD4140DE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:04:36 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MynQV5DqxzpVnp;
        Thu, 27 Oct 2022 22:01:06 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 22:04:32 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>,
        <sebastian.reichel@collabora.com>, <peda@axentia.se>,
        <khalasa@piap.pl>, <kuba@kernel.org>,
        <u.kleine-koenig@pengutronix.de>, <michael@walle.cc>,
        <sameo@linux.intel.com>, <robert.dolca@intel.com>,
        <clement.perrochaud@nxp.com>, <r.baldyga@samsung.com>,
        <cuissard@marvell.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 2/4] nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
Date:   Thu, 27 Oct 2022 22:03:30 +0800
Message-ID: <20221027140332.18336-3-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027140332.18336-1-shangxiaojing@huawei.com>
References: <20221027140332.18336-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nxp_nci_send() will call nxp_nci_i2c_write(), and only free skb when
nxp_nci_i2c_write() failed. However, even if the nxp_nci_i2c_write()
run succeeds, the skb will not be freed in nxp_nci_i2c_write(). As the
result, the skb will memleak. nxp_nci_send() should also free the skb
when nxp_nci_i2c_write() succeeds.

Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/nfc/nxp-nci/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 7c93d484dc1b..580cb6ecffee 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -80,10 +80,13 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 		return -EINVAL;
 
 	r = info->phy_ops->write(info->phy_id, skb);
-	if (r < 0)
+	if (r < 0) {
 		kfree_skb(skb);
+		return r;
+	}
 
-	return r;
+	consume_skb(skb);
+	return 0;
 }
 
 static int nxp_nci_rf_pll_unlocked_ntf(struct nci_dev *ndev,
-- 
2.17.1

