Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CC4F1800
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378453AbiDDPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353885AbiDDPMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:12:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6963F1EC7D;
        Mon,  4 Apr 2022 08:10:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bg10so20647759ejb.4;
        Mon, 04 Apr 2022 08:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BSegR3kntespBY2VEcJbUu6OkfZsuxzRqT8NRHHqTt8=;
        b=HtWrYxQ5p3TpjqELEC5GjCe++Gy3lMWgGKjvA//JiapLgM/Sdu+LUlOQQSbHaB9ESD
         43GNMEcSIW1WU4RXIM1qVPkLxY9uODKmuAWlg4XJnvd1JsC/XsgkzhFgCK1V4Ej4EdHx
         HHk5TPHU2LLnsDhV7oItm3EeIrQ1R6vb2csWMTlkaWYACjj8An8OEVyipMQvdAKshtSL
         t9agqSg0WORwgIVdB9MvyqXC6ubhu5VOtarqOHQ0cqubmZXNx8TGT0+xdtDPGO9Mfe+a
         85cacD2pRICkzcTg+61KfhlDHlTz5rvCTyIeI3K7M8PDlrRwYUPKA6GZGpsG71mCLhIu
         WctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BSegR3kntespBY2VEcJbUu6OkfZsuxzRqT8NRHHqTt8=;
        b=gDTayDQjWyhOP1W7LWSc+7VMdJoehGvEmJwiG5oSPqlDkCdUF9uE045Ii4IDFqeVYK
         bbOGV6MvO7clxVtH5thOxW+pDleUgin7G/qMzc9b7lNFtcoSa2E/tipYB3ZLaeMQF8UE
         2ywdKVhbCiBzZfleRR2vRtnHbeOgW3FBe44tLKTrZLmWy7WJnCQLIjJHalL9NkRxS4zh
         gGTu0Mvl610EysRXtHcmWO7t2wz7jUwvThy0kzNicVs9Ssh6Ykkx/X7tlFsftk7FD0Am
         Pao94S6L2UlpUIKXyd4DOcmXEQvCdW5BEt5NEFbdHV0WbENlY+R6D/Us7597ECBihMyv
         zldA==
X-Gm-Message-State: AOAM531sC8/4xD2m0J7+VPiy3O9xOnkGXjMRaAJi1M6hTs0ElGZAgYwe
        514hnUcEZ3qqEh8QFc22pWCMDLIbzPTSBshK
X-Google-Smtp-Source: ABdhPJw1rklWhUZEl38zY5UhA5vzxcL18qH4MCnI3td2r0jB94KI9a0+0/XJhjjIGs54yxevQXpHLg==
X-Received: by 2002:a17:907:60c8:b0:6da:83f0:9eaa with SMTP id hv8-20020a17090760c800b006da83f09eaamr478013ejc.605.1649085045462;
        Mon, 04 Apr 2022 08:10:45 -0700 (PDT)
Received: from localhost.localdomain ([154.123.172.173])
        by smtp.gmail.com with ESMTPSA id q16-20020a170906145000b006bdaf981589sm4481060ejc.81.2022.04.04.08.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 08:10:45 -0700 (PDT)
From:   David Kahurani <k.kahurani@gmail.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de, paskripkin@gmail.com,
        David Kahurani <k.kahurani@gmail.com>
Subject: [PATCH] net: ax88179: add proper error handling of usb read errors
Date:   Mon,  4 Apr 2022 18:10:36 +0300
Message-Id: <20220404151036.265901-1-k.kahurani@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reads that are lesser than the requested size lead to uninit-value bugs. Qualify
such reads as errors and handle them correctly.

ax88179_178a 2-1:0.35 (unnamed net_device) (uninitialized): Failed to read reg index 0x0001: -71
ax88179_178a 2-1:0.35 (unnamed net_device) (uninitialized): Failed to read reg index 0x0002: -71
=====================================================
BUG: KMSAN: uninit-value in ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
BUG: KMSAN: uninit-value in ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
 ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
 ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
 ax88179_bind+0xe75/0x1990 drivers/net/usb/ax88179_178a.c:1411
 usbnet_probe+0x1284/0x4140 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
 really_probe+0x67d/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1d3e/0x2400 drivers/base/core.c:3394
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x67d/0x1510 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:781 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:898
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:969
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1016

Signed-off-by: David Kahurani <k.kahurani@gmail.com>
Reported-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
---
 drivers/net/usb/ax88179_178a.c | 255 +++++++++++++++++++++++++++------
 1 file changed, 213 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e2fa56b92..b5e114bed 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -185,8 +185,9 @@ static const struct {
 	{7, 0xcc, 0x4c, 0x18, 8},
 };
 
-static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			      u16 size, void *data, int in_pm)
+static int __must_check __ax88179_read_cmd(struct usbnet *dev, u8 cmd,
+		                           u16 value, u16 index, u16 size,
+					   void *data, int in_pm)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
@@ -201,9 +202,12 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
 			    index, ret);
+	}
 
 	return ret;
 }
@@ -249,19 +253,26 @@ static void ax88179_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value,
 	}
 }
 
-static int ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				 u16 index, u16 size, void *data)
+static int __must_check ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd,
+		                              u16 value, u16 index, u16 size,
+					      void *data)
 {
 	int ret;
 
 	if (2 == size) {
 		u16 buf;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
+
+		if (ret < 0)
+			return ret;
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
+
+		if (ret < 0)
+			return ret;
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
@@ -290,19 +301,23 @@ static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 	return ret;
 }
 
-static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			    u16 size, void *data)
+static int __must_check ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value,
+                                         u16 index, u16 size, void *data)
 {
 	int ret;
 
 	if (2 == size) {
 		u16 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		if (ret < 0)
+			return ret;
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		if (ret < 0)
+			return ret;
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
@@ -354,8 +369,15 @@ static int ax88179_mdio_read(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	u16 res;
+	int ret;
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
+		return ret;
+	}
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
 	return res;
 }
 
@@ -427,19 +449,31 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usbnet *dev = usb_get_intfdata(intf);
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 
 	usbnet_suspend(intf, message);
 
 	/* Disable RX path */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			      2, 2, &tmp16);
+	ret = ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			            2, 2, &tmp16);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read MEDIUM_STATUS_MODE: %d\n",
+			   ret);
+		return ret;
+	}
+
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
 	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			       2, 2, &tmp16);
 
 	/* Force bulk-in zero length */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			      2, 2, &tmp16);
+	ret = ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+                                    2, 2, &tmp16);
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read PHYPWR_RSTCTL: %d\n", ret);
+		return ret;
+	}
 
 	tmp16 |= AX_PHYPWR_RSTCTL_BZ | AX_PHYPWR_RSTCTL_IPRL;
 	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
@@ -462,6 +496,7 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 {
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 	int (*fnr)(struct usbnet *, u8, u16, u16, u16, void *);
 	int (*fnw)(struct usbnet *, u8, u16, u16, u16, const void *);
 
@@ -481,11 +516,19 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 
 	/* Enable Auto Detach bit */
 	tmp8 = 0;
-	fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ret = fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read CLK_SELECT: %d", ret);
+		return ret;
+	}
 	tmp8 |= AX_CLK_SELECT_ULR;
 	fnw(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
-	fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ret = fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read PHYPWR_RSTCTL: %d", ret);
+		return ret;
+	}
 	tmp16 |= AX_PHYPWR_RSTCTL_AT;
 	fnw(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 
@@ -497,6 +540,7 @@ static int ax88179_resume(struct usb_interface *intf)
 	struct usbnet *dev = usb_get_intfdata(intf);
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 
 	usbnet_link_change(dev, 0, 0);
 
@@ -515,7 +559,14 @@ static int ax88179_resume(struct usb_interface *intf)
 	ax88179_auto_detach(dev, 1);
 
 	/* Enable clock */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+	ret = ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read CLK_SELECT %d\n", ret);
+
+		return ret;
+	}
+
 	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
 	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	msleep(100);
@@ -951,23 +1002,45 @@ static int
 ax88179_set_features(struct net_device *net, netdev_features_t features)
 {
 	u8 tmp;
+	int ret;
 	struct usbnet *dev = netdev_priv(net);
 	netdev_features_t changed = net->features ^ features;
 
 	if (changed & NETIF_F_IP_CSUM) {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL,
+				       1, 1, &tmp);
+		if (ret < 0){
+			netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
 	if (changed & NETIF_F_IPV6_CSUM) {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL,
+				       1, 1, &tmp);
+		if (ret < 0){
+			netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp ^= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
 	if (changed & NETIF_F_RXCSUM) {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL,
+				       1, 1, &tmp);
+		if (ret < 0){
+			netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp ^= AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 		       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
@@ -980,19 +1053,36 @@ static int ax88179_change_mtu(struct net_device *net, int new_mtu)
 {
 	struct usbnet *dev = netdev_priv(net);
 	u16 tmp16;
+	int ret;
 
 	net->mtu = new_mtu;
 	dev->hard_mtu = net->mtu + net->hard_header_len;
 
 	if (net->mtu > 1500) {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-				 2, 2, &tmp16);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC,
+				       AX_MEDIUM_STATUS_MODE,
+				       2, 2, &tmp16);
+		if (ret < 0){
+			netdev_dbg(dev->net,
+				   "Failed to read MEDIUM_STATUS_MODE %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp16 |= AX_MEDIUM_JUMBO_EN;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 				  2, 2, &tmp16);
 	} else {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-				 2, 2, &tmp16);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC,
+			               AX_MEDIUM_STATUS_MODE,
+				       2, 2, &tmp16);
+		if (ret < 0){
+			netdev_dbg(dev->net,
+				   "Failed to read MEDIUM_STATUS_MODE %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp16 &= ~AX_MEDIUM_JUMBO_EN;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 				  2, 2, &tmp16);
@@ -1045,6 +1135,7 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 	u8 i, buf, eeprom[20];
 	u16 csum, delay = HZ / 10;
 	unsigned long jtimeout;
+	int ret;
 
 	/* Read EEPROM content */
 	for (i = 0; i < 6; i++) {
@@ -1060,16 +1151,30 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 
 		jtimeout = jiffies + delay;
 		do {
-			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
-					 1, 1, &buf);
+		    ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
+					   1, 1, &buf);
+
+		    if (ret < 0) {
+			    netdev_dbg(dev->net,
+				       "Failed to read SROM_CMD: %d\n",
+			               ret);
+			    return ret;
+		    }
 
 			if (time_after(jiffies, jtimeout))
 				return -EINVAL;
 
 		} while (buf & EEP_BUSY);
 
-		__ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				   2, 2, &eeprom[i * 2], 0);
+		ret = __ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
+				         2, 2, &eeprom[i * 2], 0);
+
+		if (ret < 0) {
+			netdev_dbg(dev->net,
+				   "Failed to read SROM_DATA_LOW: %d\n",
+			           ret);
+			return ret;
+		}
 
 		if ((i == 0) && (eeprom[0] == 0xFF))
 			return -EINVAL;
@@ -1149,12 +1254,19 @@ static int ax88179_convert_old_led(struct usbnet *dev, u16 *ledvalue)
 
 static int ax88179_led_setting(struct usbnet *dev)
 {
+	int ret;
 	u8 ledfd, value = 0;
 	u16 tmp, ledact, ledlink, ledvalue = 0, delay = HZ / 10;
 	unsigned long jtimeout;
 
 	/* Check AX88179 version. UA1 or UA2*/
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1, &value);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1, &value);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read GENERAL_STATUS: %d\n",
+			   ret);
+		return ret;
+	}
 
 	if (!(value & AX_SECLD)) {	/* UA1 */
 		value = AX_GPIO_CTRL_GPIO3EN | AX_GPIO_CTRL_GPIO2EN |
@@ -1178,20 +1290,40 @@ static int ax88179_led_setting(struct usbnet *dev)
 
 		jtimeout = jiffies + delay;
 		do {
-			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
-					 1, 1, &value);
+			ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
+					       1, 1, &value);
+			if (ret < 0){
+				netdev_dbg(dev->net,
+					   "Failed to read SROM_CMD: %d\n",
+					   ret);
+				return ret;
+			}
 
 			if (time_after(jiffies, jtimeout))
 				return -EINVAL;
 
 		} while (value & EEP_BUSY);
 
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
 				 1, 1, &value);
+		if (ret < 0){
+			netdev_dbg(dev->net, "Failed to read SROM_DATA_HIGH: %d\n",
+				   ret);
+			return ret;
+		}
+
+
 		ledvalue = (value << 8);
 
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				 1, 1, &value);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
+				       1, 1, &value);
+
+		if (ret < 0) {
+			netdev_dbg(dev->net, "Failed to read SROM_DATA_LOW: %d",
+				   ret);
+			return ret;
+		}
+
 		ledvalue |= value;
 
 		/* load internal ROM for defaule setting */
@@ -1213,12 +1345,22 @@ static int ax88179_led_setting(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
 			  GMII_PHYPAGE, 2, &tmp);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
-			 GMII_LED_ACT, 2, &ledact);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+			       GMII_LED_ACT, 2, &ledact);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
+		return ret;
+	}
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
 			 GMII_LED_LINK, 2, &ledlink);
 
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
+		return ret;
+	}
+
 	ledact &= GMII_LED_ACTIVE_MASK;
 	ledlink &= GMII_LED_LINK_MASK;
 
@@ -1295,6 +1437,7 @@ static int ax88179_led_setting(struct usbnet *dev)
 static void ax88179_get_mac_addr(struct usbnet *dev)
 {
 	u8 mac[ETH_ALEN];
+	int ret;
 
 	memset(mac, 0, sizeof(mac));
 
@@ -1303,8 +1446,12 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 		netif_dbg(dev, ifup, dev->net,
 			  "MAC address read from device tree");
 	} else {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
 				 ETH_ALEN, mac);
+
+		if (ret < 0)
+			netdev_dbg(dev->net, "Failed to read NODE_ID: %d", ret);
+
 		netif_dbg(dev, ifup, dev->net,
 			  "MAC address read from ASIX chip");
 	}
@@ -1572,6 +1719,7 @@ static int ax88179_link_reset(struct usbnet *dev)
 	u16 mode, tmp16, delay = HZ / 10;
 	u32 tmp32 = 0x40000000;
 	unsigned long jtimeout;
+	int ret;
 
 	jtimeout = jiffies + delay;
 	while (tmp32 & 0x40000000) {
@@ -1581,7 +1729,13 @@ static int ax88179_link_reset(struct usbnet *dev)
 				  &ax179_data->rxctl);
 
 		/*link up, check the usb device control TX FIFO full or empty*/
-		ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
+		ret = ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
+
+		if (ret < 0) {
+			netdev_dbg(dev->net, "Failed to read TX FIFO: %d\n",
+				   ret);
+			return ret;
+		}
 
 		if (time_after(jiffies, jtimeout))
 			return 0;
@@ -1590,11 +1744,21 @@ static int ax88179_link_reset(struct usbnet *dev)
 	mode = AX_MEDIUM_RECEIVE_EN | AX_MEDIUM_TXFLOW_CTRLEN |
 	       AX_MEDIUM_RXFLOW_CTRLEN;
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
-			 1, 1, &link_sts);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
+			       1, 1, &link_sts);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
-			 GMII_PHY_PHYSR, 2, &tmp16);
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read LINK_STATUS: %d", ret);
+		return ret;
+	}
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+			       GMII_PHY_PHYSR, 2, &tmp16);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
+		return ret;
+	}
 
 	if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
 		return 0;
@@ -1732,9 +1896,16 @@ static int ax88179_reset(struct usbnet *dev)
 static int ax88179_stop(struct usbnet *dev)
 {
 	u16 tmp16;
+	int ret;
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			 2, 2, &tmp16);
+
+	if (ret < 0){
+		netdev_dbg(dev->net, "Failed to read STATUS_MODE: %d\n", ret);
+		return ret;
+	}
+
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			  2, 2, &tmp16);
-- 
2.25.1

