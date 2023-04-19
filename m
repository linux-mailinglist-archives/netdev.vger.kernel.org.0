Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5E16E753B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjDSIbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjDSIbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:31:19 -0400
X-Greylist: delayed 113 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 01:30:58 PDT
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48ADCC1D;
        Wed, 19 Apr 2023 01:30:57 -0700 (PDT)
X-QQ-mid: bizesmtp68t1681892941tlvcx37i
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 16:29:00 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: +oIWmpEafD8Rbt12g7AWeObfmd3XKPv+z6RgD17MkAZi6IlAkCVoMgGE2PJc6
        tm5bKP5p8flC8JKqrlUGgpXBGjEvn7lRs6LSp6F2ocM7nW0qAsbgZFaqjVAfAJINWOiBxFR
        H+5hj13acbm5DoPgiMgaSlZQLhmLDKoHn4CTXRWIhKkhtg9OLMi0n6ltpG5qV1lThh7CMM/
        eSVGPZ1NWEgBAgpuZMBU0vNk+FdPIxYYg/f2WZSLjcYTNfIbXS14ck4YMBrZB3GTxoFZN0g
        1JA/L1vPLm+6w2nq4RPXwIn3N6L3groj2KFEbNXmhZ7bTos1Ej7FmvNb1HOKxtfheIyR+o0
        Tx++gKwlOd6KTRK3ZAFnkxwMtkTB9QIMeexeDuE9/Cfkwebwx8Ah6BewReCHvVe/O+my51K
        uHOKY8HRqSWWqP3sL4GEnQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 18199863075408619699
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 4/8] net: txgbe: Add SFP module identify
Date:   Wed, 19 Apr 2023 16:27:35 +0800
Message-Id: <20230419082739.295180-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230419082739.295180-1-jiawenwu@trustnetic.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
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
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 27 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 3 files changed, 29 insertions(+)

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
index 8bb7f1d9acc7..faa0479f1df3 100644
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
@@ -121,6 +140,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err;
 	}
 
+	ret = txgbe_sfp_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register sfp\n");
+		goto err;
+	}
+
 	return 0;
 
 err:
@@ -131,6 +156,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->sfp_dev)
+		platform_device_unregister(txgbe->sfp_dev);
 	if (txgbe->i2c_dev)
 		platform_device_unregister(txgbe->i2c_dev);
 
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

