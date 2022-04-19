Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F96506702
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350054AbiDSIg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343768AbiDSIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:36:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD8727FEB;
        Tue, 19 Apr 2022 01:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650357247; x=1681893247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdW08Py1YP21b97JQu1mB+MqRhlfnPj5Y35sUtUMmik=;
  b=ra3akAO2VlwEe4gnLlD9ajK/196kAQOYpTbkwIHYVjXdBi8eiBlufKTX
   gucylmIV4h9q9AOnyXqDawt+nYJtAPBP2uunqLHC9D3cmo6qLOR0msQmI
   C83lQ1s9PqJY/8qpoIc3VEwp+ExonaHuK2wgo/dxrNh+yzgDqG0S3V7lA
   KJC5kkW6uIYqMNwxAQRdLvaLC4gCyr3AYyz+isi3MeQ2ItBpP/D+Os/fL
   MuakYWHyNz8A2wFNrMImnOQKiZsXppsxtsdAK0lZpDWltcxZiinRj21yL
   /SAe8at2SnllQb6Qx1H57UioAiFaXq8cQVCCcT1zuqiHz6RKPhfFDO4rE
   w==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643698800"; 
   d="scan'208";a="160923880"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2022 01:34:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Apr 2022 01:34:06 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 19 Apr 2022 01:34:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 1/2] net: phy: Add phy latency adjustment support in phy framework.
Date:   Tue, 19 Apr 2022 10:37:03 +0200
Message-ID: <20220419083704.48573-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419083704.48573-1-horatiu.vultur@microchip.com>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add adjustment support for latency for the phy using sysfs.
This is used to adjust the latency of the phy based on link mode
and direction.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ABI/testing/sysfs-class-net-phydev        | 10 ++++
 drivers/net/phy/phy_device.c                  | 58 +++++++++++++++++++
 include/linux/phy.h                           |  9 +++
 3 files changed, 77 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index ac722dd5e694..a99bbfeddb6f 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -63,3 +63,13 @@ Description:
 		only used internally by the kernel and their placement are
 		not meant to be stable across kernel versions. This is intended
 		for facilitating the debugging of PHY drivers.
+
+What:		/sys/class/mdio_bus/<bus>/<device>/adjust_latency
+Date:		April 2022
+KernelVersion:	5.19
+Contact:	netdev@vger.kernel.org
+Description:
+		This file adjusts the latency in the PHY. To set value,
+		write three integers into the file: interface mode, RX latency,
+		TX latency. When the file is read, it returns the supported
+		interface modes and the latency values.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def..80bf04ca0e02 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -529,6 +529,48 @@ static ssize_t phy_dev_flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phy_dev_flags);
 
+static ssize_t adjust_latency_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	ssize_t count = 0;
+	int err, i;
+	s32 rx, tx;
+
+	for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; ++i) {
+		err = phydev->drv->get_adj_latency(phydev, i, &rx, &tx);
+		if (err == -EINVAL)
+			continue;
+
+		count += sprintf(&buf[count], "%d rx: %d, tx: %d\n", i, rx, tx);
+	}
+
+	return count;
+}
+
+static ssize_t adjust_latency_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	enum ethtool_link_mode_bit_indices link_mode;
+	int cnt, err = -EINVAL;
+	s32 rx, tx;
+
+	cnt = sscanf(buf, "%u %d %d", &link_mode, &rx, &tx);
+	if (cnt != 3)
+		goto out;
+
+	err = phydev->drv->set_adj_latency(phydev, link_mode, rx, tx);
+	if (err)
+		goto out;
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_RW(adjust_latency);
+
 static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_id.attr,
 	&dev_attr_phy_interface.attr,
@@ -3009,6 +3051,16 @@ static int phy_probe(struct device *dev)
 
 	phydev->drv = phydrv;
 
+	if (phydev->drv &&
+	    phydev->drv->set_adj_latency &&
+	    phydev->drv->get_adj_latency) {
+		err = sysfs_create_file(&phydev->mdio.dev.kobj,
+					&dev_attr_adjust_latency.attr);
+		if (err)
+			phydev_err(phydev, "error creating 'adjust_latency' sysfs entry\n");
+		err = 0;
+	}
+
 	/* Disable the interrupt if the PHY doesn't support it
 	 * but the interrupt is still a valid one
 	 */
@@ -3112,6 +3164,12 @@ static int phy_remove(struct device *dev)
 	if (phydev->drv && phydev->drv->remove)
 		phydev->drv->remove(phydev);
 
+	if (phydev->drv &&
+	    phydev->drv->set_adj_latency &&
+	    phydev->drv->get_adj_latency)
+		sysfs_remove_file(&phydev->mdio.dev.kobj,
+				  &dev_attr_adjust_latency.attr);
+
 	/* Assert the reset signal */
 	phy_device_reset(phydev, 1);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c2253..584e467ff4d1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -932,6 +932,15 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+	/** @set_adj_latency: Set the latency values of the PHY */
+	int (*set_adj_latency)(struct phy_device *dev,
+			       enum ethtool_link_mode_bit_indices link_mode,
+			       s32 rx, s32 tx);
+	/** @get_latency: Get the latency values of the PHY */
+	int (*get_adj_latency)(struct phy_device *dev,
+			       enum ethtool_link_mode_bit_indices link_mode,
+			       s32 *rx, s32 *tx);
+
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.33.0

