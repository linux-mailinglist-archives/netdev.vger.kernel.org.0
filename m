Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF562D996
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiKQLjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiKQLix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:38:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F6E429A5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:38:52 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCdGF0Jn5zRpHP;
        Thu, 17 Nov 2022 19:38:29 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 19:38:49 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>, <pavel@denx.de>,
        <u.kleine-koenig@pengutronix.de>, <kuba@kernel.org>,
        <michael@walle.cc>, <cuissard@marvell.com>,
        <sameo@linux.intel.com>, <clement.perrochaud@nxp.com>,
        <r.baldyga@samsung.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 1/3] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
Date:   Thu, 17 Nov 2022 19:37:12 +0800
Message-ID: <20221117113714.12776-2-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221117113714.12776-1-shangxiaojing@huawei.com>
References: <20221117113714.12776-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
won't free the skb when it failed for the test_bit(). Free the skb when
test_bit() failed.

Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Suggested-by: Pavel Machek <pavel@denx.de>
---
 drivers/nfc/nfcmrvl/i2c.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 24436c9e54c9..97600826af69 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -112,8 +112,10 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_private *priv,
 	struct nfcmrvl_i2c_drv_data *drv_data = priv->drv_data;
 	int ret;
 
-	if (test_bit(NFCMRVL_PHY_ERROR, &priv->flags))
+	if (test_bit(NFCMRVL_PHY_ERROR, &priv->flags)) {
+		kfree_skb(skb);
 		return -EREMOTEIO;
+	}
 
 	ret = i2c_master_send(drv_data->i2c, skb->data, skb->len);
 
-- 
2.17.1

