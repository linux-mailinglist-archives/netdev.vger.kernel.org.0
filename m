Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC8D65E6C4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjAEIVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjAEIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:20:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FA55BA1E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:18:15 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NnfT86Yg6zJrBq;
        Thu,  5 Jan 2023 16:17:00 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 5 Jan
 2023 16:18:13 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <krzysztof.kozlowski@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sameo@linux.intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] NFC: netlink: put device in nfc_genl_se_io()
Date:   Thu, 5 Jan 2023 16:27:38 +0800
Message-ID: <20230105082738.671183-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nfc_genl_se_io() function is called, no matter it failed or succeed,
it does not put device. Fix it.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/nfc/netlink.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9d91087b9399..86601d400bd6 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1497,6 +1497,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int ret;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1510,25 +1511,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	ret = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+out:
+	nfc_put_device(dev);
+	return ret;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
-- 
2.34.1

