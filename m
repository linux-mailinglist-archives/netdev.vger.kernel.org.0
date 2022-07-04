Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DB565554
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiGDM35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiGDM3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:29:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844F121B8;
        Mon,  4 Jul 2022 05:29:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lc4qP3D0hzYd0m;
        Mon,  4 Jul 2022 20:29:05 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 4 Jul
 2022 20:29:50 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <paskripkin@gmail.com>, <linux@rempel-privat.de>, <andrew@lunn.ch>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: asix: change the type of asix_set_sw/hw_mii to static
Date:   Mon, 4 Jul 2022 20:34:48 +0800
Message-ID: <20220704123448.128980-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions of asix_set_sw/hw_mii are not called in other files, so
change them to static.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/usb/asix.h        |  3 ---
 drivers/net/usb/asix_common.c | 40 ++++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2c81236c6c7c..02d4096a9c9d 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -213,9 +213,6 @@ void asix_rx_fixup_common_free(struct asix_common_private *dp);
 struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 			      gfp_t flags);
 
-int asix_set_sw_mii(struct usbnet *dev, int in_pm);
-int asix_set_hw_mii(struct usbnet *dev, int in_pm);
-
 int asix_read_phy_addr(struct usbnet *dev, bool internal);
 
 int asix_sw_reset(struct usbnet *dev, u8 flags, int in_pm);
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 632fa6c1d5e3..0c3a4d3d164f 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -68,6 +68,27 @@ void asix_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			       value, index, data, size);
 }
 
+static int asix_set_sw_mii(struct usbnet *dev, int in_pm)
+{
+	int ret;
+
+	ret = asix_write_cmd(dev, AX_CMD_SET_SW_MII, 0x0000, 0, 0, NULL, in_pm);
+
+	if (ret < 0)
+		netdev_err(dev->net, "Failed to enable software MII access\n");
+	return ret;
+}
+
+static int asix_set_hw_mii(struct usbnet *dev, int in_pm)
+{
+	int ret;
+
+	ret = asix_write_cmd(dev, AX_CMD_SET_HW_MII, 0x0000, 0, 0, NULL, in_pm);
+	if (ret < 0)
+		netdev_err(dev->net, "Failed to enable hardware MII access\n");
+	return ret;
+}
+
 static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 {
 	int i, ret;
@@ -297,25 +318,6 @@ struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	return skb;
 }
 
-int asix_set_sw_mii(struct usbnet *dev, int in_pm)
-{
-	int ret;
-	ret = asix_write_cmd(dev, AX_CMD_SET_SW_MII, 0x0000, 0, 0, NULL, in_pm);
-
-	if (ret < 0)
-		netdev_err(dev->net, "Failed to enable software MII access\n");
-	return ret;
-}
-
-int asix_set_hw_mii(struct usbnet *dev, int in_pm)
-{
-	int ret;
-	ret = asix_write_cmd(dev, AX_CMD_SET_HW_MII, 0x0000, 0, 0, NULL, in_pm);
-	if (ret < 0)
-		netdev_err(dev->net, "Failed to enable hardware MII access\n");
-	return ret;
-}
-
 int asix_read_phy_addr(struct usbnet *dev, bool internal)
 {
 	int ret, offset;
-- 
2.17.1

