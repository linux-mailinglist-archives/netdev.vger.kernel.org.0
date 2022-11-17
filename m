Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0562D999
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbiKQLjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiKQLiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:38:55 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A5156D4A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:38:53 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NCdBG69n3zqSMX;
        Thu, 17 Nov 2022 19:35:02 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 19:38:51 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>, <pavel@denx.de>,
        <u.kleine-koenig@pengutronix.de>, <kuba@kernel.org>,
        <michael@walle.cc>, <cuissard@marvell.com>,
        <sameo@linux.intel.com>, <clement.perrochaud@nxp.com>,
        <r.baldyga@samsung.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 3/3] nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
Date:   Thu, 17 Nov 2022 19:37:14 +0800
Message-ID: <20221117113714.12776-4-shangxiaojing@huawei.com>
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

s3fwrn5_nci_send() won't free the skb when it failed for the check
before s3fwrn5_write(). As the result, the skb will memleak. Free the
skb when the check failed.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Suggested-by: Pavel Machek <pavel@denx.de>
---
 drivers/nfc/s3fwrn5/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 0270e05b68df..aec356880adf 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -105,6 +105,7 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	mutex_lock(&info->mutex);
 
 	if (s3fwrn5_get_mode(info) != S3FWRN5_MODE_NCI) {
+		kfree_skb(skb);
 		mutex_unlock(&info->mutex);
 		return -EINVAL;
 	}
-- 
2.17.1

