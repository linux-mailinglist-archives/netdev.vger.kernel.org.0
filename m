Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2F6EB77A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDVE7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjDVE7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:59:34 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911171BEF;
        Fri, 21 Apr 2023 21:59:31 -0700 (PDT)
X-QQ-mid: bizesmtp66t1682139540t4rjm7vb
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Apr 2023 12:58:59 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: QityeSR92A2eB5yq0dju3AG3oC7nzzD208XVA7OS3vUF09xrEpCMuInDue1JJ
        RJr408AVMzeu+TydL18vI3G01qdtic8mU/CXEd7bCyoXP9/Mh+ScZhkBurWdGSsMW8V8JZA
        TnmKuQvvyvTUmdm+5eYG3E917fi4SrKu1r2Fx4RU5d/lq1aDCGiRcaRT98DC7dFpXsC7xsp
        QD/8SPwgJQXLgsaJjUmVyfJshtk9cRPkuibUGHbt1HjPdqhdrfrWyAUbizvF1+ASQuk3ud0
        d6VRqvEGUy2mrYz03Z+DDdljE6IsUn9QQCIEi08ET8H0KxfDCKkS4H4ZXl+vfYQDBKvLYhp
        j/lOHGYUBIvLRs59W3pW4AkJ1tD1vSiA1n3CD22dS2W314JtZNRi7ijKT4PC/4E1nnhVgYD
        f4w5HJiO3Eg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5170876042864715615
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v4 4/8] net: txgbe: Add SFP module identify
Date:   Sat, 22 Apr 2023 12:56:17 +0800
Message-Id: <20230422045621.360918-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230422045621.360918-1-jiawenwu@trustnetic.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register SFP platform device to get modules information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 28 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 8acd6a0d84dc..d2dbaf19e53d 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -42,6 +42,7 @@ config TXGBE
 	depends on PCI
 	select I2C_DESIGNWARE_PLATFORM
 	select LIBWX
+	select SFP
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index d573f77007db..3fbcfd217079 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -105,6 +105,25 @@ static int txgbe_i2c_register(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_sfp_register(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct platform_device_info info = {};
+	struct platform_device *sfp_dev;
+
+	info.parent = &pdev->dev;
+	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_SFP]);
+	info.name = "sfp";
+	info.id = (pdev->bus->number << 8) | pdev->devfn;
+	sfp_dev = platform_device_register_full(&info);
+	if (IS_ERR(sfp_dev))
+		return PTR_ERR(sfp_dev);
+
+	txgbe->sfp_dev = sfp_dev;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -121,8 +140,16 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err_unregister_swnode;
 	}
 
+	ret = txgbe_sfp_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register sfp\n");
+		goto err_unregister_i2c;
+	}
+
 	return 0;
 
+err_unregister_i2c:
+	platform_device_unregister(txgbe->i2c_dev);
 err_unregister_swnode:
 	software_node_unregister_node_group(txgbe->nodes.group);
 
@@ -131,6 +158,7 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	platform_device_unregister(txgbe->sfp_dev);
 	platform_device_unregister(txgbe->i2c_dev);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 771aefbc7c80..aa94c4fce311 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -149,6 +149,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 };
 
-- 
2.27.0

