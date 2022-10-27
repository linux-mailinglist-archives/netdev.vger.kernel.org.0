Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5560FA11
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiJ0OE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiJ0OEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:04:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E9D13D3D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:04:35 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MynNv4sMSzVhlr;
        Thu, 27 Oct 2022 21:59:43 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 22:04:31 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>,
        <sebastian.reichel@collabora.com>, <peda@axentia.se>,
        <khalasa@piap.pl>, <kuba@kernel.org>,
        <u.kleine-koenig@pengutronix.de>, <michael@walle.cc>,
        <sameo@linux.intel.com>, <robert.dolca@intel.com>,
        <clement.perrochaud@nxp.com>, <r.baldyga@samsung.com>,
        <cuissard@marvell.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 1/4] nfc: fdp: Fix potential memory leak in fdp_nci_send()
Date:   Thu, 27 Oct 2022 22:03:29 +0800
Message-ID: <20221027140332.18336-2-shangxiaojing@huawei.com>
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

fdp_nci_send() will call fdp_nci_i2c_write that will not free skb in
the function. As a result, when fdp_nci_i2c_write() finished, the skb
will memleak. fdp_nci_send() should free skb after fdp_nci_i2c_write()
finished.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/nfc/fdp/fdp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index c6b3334f24c9..f12f903a9dd1 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -249,11 +249,19 @@ static int fdp_nci_close(struct nci_dev *ndev)
 static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
+	int ret;
 
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
 
-	return info->phy_ops->write(info->phy, skb);
+	ret = info->phy_ops->write(info->phy, skb);
+	if (ret < 0) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	consume_skb(skb);
+	return 0;
 }
 
 static int fdp_nci_request_firmware(struct nci_dev *ndev)
-- 
2.17.1

