Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA0F5034B9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 09:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiDPHvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 03:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiDPHvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 03:51:37 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3BBFFF7C;
        Sat, 16 Apr 2022 00:49:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u18so12226979eda.3;
        Sat, 16 Apr 2022 00:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cD7bYu8rs/so682Nko36Jvqr7LZ1RuM3bEKeTQK06kY=;
        b=mGQnAVartGWjUnqMJjUCRI1woWCEuWWXcDeABVBGkWxNcan0KCI6Zq6qGOym/4aMBG
         YE6BLz0AsAAUeMPP/MOdiMp4a2vZVMHhURLune1Hya5Lb6Q7GzMs4yi4ULzjDcMDajkU
         nQ5ueH2A20hG8WdgTilRfHCyE4anIhMQa+aNJ4O9aoQ1hRe8Fb8wdW3lsZVmNgqkNC8m
         jVgyX/EgTEiAXtqcBE7HErxiwDgow0Fb+VlqN+3WhQmtTumst0SVInEPbCtHhMH3I9pY
         XhwJzep6aMEuNrTL3hgORtUNEnkEPU5lvp3w+XskMRJuj2oDhFuQxD/oS8cSOaCEn+Rb
         pORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cD7bYu8rs/so682Nko36Jvqr7LZ1RuM3bEKeTQK06kY=;
        b=zyzyBqlDM3cCGrhZIGCsOoL0QOq/CZkCbONNsXcrGqgyALKQ3fZQfQTmGYBapmO81i
         tR34p6SOlRJpaOzDz2GUO90tjOdOs4/ECfVIQjg8ErV/SNcYa090K6GNz04OeKCUh2fn
         6PcxTxQLem0NK/lDcmxpt18BNHAJosPi+aaXrthUaNHfAGd1rZBb+hFdJukiq7ZSGY2W
         PcThiEjq/tKofMrcetpdn0LmAz+qL8nQVIohunnrApqP3WUiBv3KHsnDc1pNdG4WGTvo
         XKvoUDyMn9WU8YScOldAjfrDVrs3Xu+rbRSkn4+jCYtiTZpygfhHz7G2W1xxp5Xo4cm0
         So0A==
X-Gm-Message-State: AOAM531OUhwJG1PI0KtMd6AEnYYeCaImcxezultLrIzKcSjba3NCNKqR
        szyVUwgG94+Q8JmYg3j6iLc/FanjAd+NvQ==
X-Google-Smtp-Source: ABdhPJxVimzxW60TH3hN3HuZVXuMvYoPh68zl7PqvMDMk6y/MAU916h/TjucTL0Mov0UeVX1IRWhzA==
X-Received: by 2002:a50:d78e:0:b0:416:2cd7:7ac5 with SMTP id w14-20020a50d78e000000b004162cd77ac5mr2707098edi.320.1650095343167;
        Sat, 16 Apr 2022 00:49:03 -0700 (PDT)
Received: from localhost.localdomain ([197.156.190.183])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090654cd00b006e0db351d01sm2407532ejp.124.2022.04.16.00.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 00:49:02 -0700 (PDT)
From:   David Kahurani <k.kahurani@gmail.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de, dan.carpenter@oracle.com,
        David Kahurani <k.kahurani@gmail.com>
Subject: [PATCH] net: ax88179: add proper error handling of usb read errors
Date:   Sat, 16 Apr 2022 10:48:17 +0300
Message-Id: <20220416074817.571160-1-k.kahurani@gmail.com>
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

Reads that are lesser than the requested size lead to uninit-value bugs.
In this particular case a variable which was supposed to be initialized
after a read is left uninitialized after a partial read.

Qualify such reads as errors and handle them correctly and while at it
convert the reader functions to return zero on success for easier error
handling.

Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to
gigabit ethernet adapter driver")
Signed-off-by: David Kahurani <k.kahurani@gmail.com>
Reported-and-tested-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
---
 drivers/net/usb/ax88179_178a.c | 279 ++++++++++++++++++++++++++-------
 1 file changed, 226 insertions(+), 53 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e2fa56b92..5113ed63f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -185,8 +185,9 @@ static const struct {
 	{7, 0xcc, 0x4c, 0x18, 8},
 };
 
-static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			      u16 size, void *data, int in_pm)
+static int __must_check __ax88179_read_cmd(struct usbnet *dev, u8 cmd,
+					   u16 value, u16 index, u16 size,
+					   void *data, int in_pm)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
@@ -201,11 +202,15 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
 			    index, ret);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
@@ -249,26 +254,33 @@ static void ax88179_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value,
 	}
 }
 
-static int ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				 u16 index, u16 size, void *data)
+static int __must_check ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd,
+					      u16 value, u16 index, u16 size,
+					      void *data)
 {
 	int ret;
 
 	if (2 == size) {
 		u16 buf;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
+		if (ret)
+			return ret;
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
+		if (ret)
+			return ret;
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 1);
+		if (ret)
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
@@ -290,26 +302,32 @@ static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 	return ret;
 }
 
-static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			    u16 size, void *data)
+static int __must_check ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value,
+					 u16 index, u16 size, void *data)
 {
 	int ret;
 
 	if (2 == size) {
 		u16 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		if (ret)
+			return ret;
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		if (ret)
+			return ret;
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 0);
+		if (ret)
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
@@ -354,8 +372,15 @@ static int ax88179_mdio_read(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	u16 res;
+	int ret;
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
+		return ret;
+	}
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, phy_id, (__u16)loc, 2, &res);
 	return res;
 }
 
@@ -416,7 +441,7 @@ ax88179_phy_write_mmd_indirect(struct usbnet *dev, u16 prtad, u16 devad,
 	ret = ax88179_write_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
 				MII_MMD_DATA, 2, &data);
 
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	return 0;
@@ -427,19 +452,31 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usbnet *dev = usb_get_intfdata(intf);
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 
 	usbnet_suspend(intf, message);
 
 	/* Disable RX path */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			      2, 2, &tmp16);
+	ret = ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+				    2, 2, &tmp16);
+
+	if (ret) {
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
+				    2, 2, &tmp16);
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHYPWR_RSTCTL: %d\n", ret);
+		return ret;
+	}
 
 	tmp16 |= AX_PHYPWR_RSTCTL_BZ | AX_PHYPWR_RSTCTL_IPRL;
 	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
@@ -462,6 +499,7 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 {
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 	int (*fnr)(struct usbnet *, u8, u16, u16, u16, void *);
 	int (*fnw)(struct usbnet *, u8, u16, u16, u16, const void *);
 
@@ -481,11 +519,19 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 
 	/* Enable Auto Detach bit */
 	tmp8 = 0;
-	fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ret = fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read CLK_SELECT: %d", ret);
+		return ret;
+	}
 	tmp8 |= AX_CLK_SELECT_ULR;
 	fnw(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
-	fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ret = fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHYPWR_RSTCTL: %d", ret);
+		return ret;
+	}
 	tmp16 |= AX_PHYPWR_RSTCTL_AT;
 	fnw(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 
@@ -497,6 +543,7 @@ static int ax88179_resume(struct usb_interface *intf)
 	struct usbnet *dev = usb_get_intfdata(intf);
 	u16 tmp16;
 	u8 tmp8;
+	int ret;
 
 	usbnet_link_change(dev, 0, 0);
 
@@ -515,7 +562,14 @@ static int ax88179_resume(struct usb_interface *intf)
 	ax88179_auto_detach(dev, 1);
 
 	/* Enable clock */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+	ret = ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read CLK_SELECT %d\n", ret);
+
+		return ret;
+	}
+
 	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
 	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	msleep(100);
@@ -601,7 +655,7 @@ ax88179_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom,
 		ret = __ax88179_read_cmd(dev, AX_ACCESS_EEPROM, i, 1, 2,
 					 &eeprom_buff[i - first_word],
 					 0);
-		if (ret < 0) {
+		if (ret) {
 			kfree(eeprom_buff);
 			return -EIO;
 		}
@@ -645,7 +699,7 @@ ax88179_set_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom,
 	if (eeprom->offset & 1) {
 		ret = ax88179_read_cmd(dev, AX_ACCESS_EEPROM, first_word, 1, 2,
 				       &eeprom_buff[0]);
-		if (ret < 0) {
+		if (ret) {
 			netdev_err(net, "Failed to read EEPROM at offset 0x%02x.\n", first_word);
 			goto free;
 		}
@@ -654,7 +708,7 @@ ax88179_set_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom,
 	if ((eeprom->offset + eeprom->len) & 1) {
 		ret = ax88179_read_cmd(dev, AX_ACCESS_EEPROM, last_word, 1, 2,
 				       &eeprom_buff[last_word - first_word]);
-		if (ret < 0) {
+		if (ret) {
 			netdev_err(net, "Failed to read EEPROM at offset 0x%02x.\n", last_word);
 			goto free;
 		}
@@ -951,23 +1005,45 @@ static int
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
+		if (ret) {
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
+		if (ret) {
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
+		if (ret) {
+			netdev_dbg(dev->net, "Failed to read TXCOE_CTL: %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp ^= AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 		       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
@@ -980,19 +1056,36 @@ static int ax88179_change_mtu(struct net_device *net, int new_mtu)
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
+		if (ret) {
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
+				       AX_MEDIUM_STATUS_MODE,
+				       2, 2, &tmp16);
+		if (ret) {
+			netdev_dbg(dev->net,
+				   "Failed to read MEDIUM_STATUS_MODE %d\n",
+				   ret);
+			return ret;
+		}
+
 		tmp16 &= ~AX_MEDIUM_JUMBO_EN;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 				  2, 2, &tmp16);
@@ -1045,6 +1138,7 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 	u8 i, buf, eeprom[20];
 	u16 csum, delay = HZ / 10;
 	unsigned long jtimeout;
+	int ret;
 
 	/* Read EEPROM content */
 	for (i = 0; i < 6; i++) {
@@ -1060,16 +1154,29 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 
 		jtimeout = jiffies + delay;
 		do {
-			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
-					 1, 1, &buf);
+			ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
+					       1, 1, &buf);
+			if (ret) {
+				netdev_dbg(dev->net,
+					   "Failed to read SROM_CMD: %d\n",
+					   ret);
+				return ret;
+			}
 
 			if (time_after(jiffies, jtimeout))
 				return -EINVAL;
 
 		} while (buf & EEP_BUSY);
 
-		__ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				   2, 2, &eeprom[i * 2], 0);
+		ret = __ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
+					 2, 2, &eeprom[i * 2], 0);
+
+		if (ret) {
+			netdev_dbg(dev->net,
+				   "Failed to read SROM_DATA_LOW: %d\n",
+				   ret);
+			return ret;
+		}
 
 		if ((i == 0) && (eeprom[0] == 0xFF))
 			return -EINVAL;
@@ -1149,12 +1256,20 @@ static int ax88179_convert_old_led(struct usbnet *dev, u16 *ledvalue)
 
 static int ax88179_led_setting(struct usbnet *dev)
 {
+	int ret;
 	u8 ledfd, value = 0;
 	u16 tmp, ledact, ledlink, ledvalue = 0, delay = HZ / 10;
 	unsigned long jtimeout;
 
 	/* Check AX88179 version. UA1 or UA2*/
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1, &value);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, GENERAL_STATUS, 1, 1,
+			       &value);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read GENERAL_STATUS: %d\n",
+			   ret);
+		return ret;
+	}
 
 	if (!(value & AX_SECLD)) {	/* UA1 */
 		value = AX_GPIO_CTRL_GPIO3EN | AX_GPIO_CTRL_GPIO2EN |
@@ -1178,20 +1293,39 @@ static int ax88179_led_setting(struct usbnet *dev)
 
 		jtimeout = jiffies + delay;
 		do {
-			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
-					 1, 1, &value);
+			ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
+					       1, 1, &value);
+			if (ret) {
+				netdev_dbg(dev->net,
+					   "Failed to read SROM_CMD: %d\n",
+					   ret);
+				return ret;
+			}
 
 			if (time_after(jiffies, jtimeout))
 				return -EINVAL;
 
 		} while (value & EEP_BUSY);
 
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
-				 1, 1, &value);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_HIGH,
+				       1, 1, &value);
+		if (ret) {
+			netdev_dbg(dev->net, "Failed to read SROM_DATA_HIGH: %d\n",
+				   ret);
+			return ret;
+		}
+
 		ledvalue = (value << 8);
 
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				 1, 1, &value);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
+				       1, 1, &value);
+
+		if (ret) {
+			netdev_dbg(dev->net, "Failed to read SROM_DATA_LOW: %d",
+				   ret);
+			return ret;
+		}
+
 		ledvalue |= value;
 
 		/* load internal ROM for defaule setting */
@@ -1213,11 +1347,21 @@ static int ax88179_led_setting(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
 			  GMII_PHYPAGE, 2, &tmp);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
-			 GMII_LED_ACT, 2, &ledact);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+			       GMII_LED_ACT, 2, &ledact);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
-			 GMII_LED_LINK, 2, &ledlink);
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
+		return ret;
+	}
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+			       GMII_LED_LINK, 2, &ledlink);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d", ret);
+		return ret;
+	}
 
 	ledact &= GMII_LED_ACTIVE_MASK;
 	ledlink &= GMII_LED_LINK_MASK;
@@ -1295,6 +1439,7 @@ static int ax88179_led_setting(struct usbnet *dev)
 static void ax88179_get_mac_addr(struct usbnet *dev)
 {
 	u8 mac[ETH_ALEN];
+	int ret;
 
 	memset(mac, 0, sizeof(mac));
 
@@ -1303,8 +1448,12 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 		netif_dbg(dev, ifup, dev->net,
 			  "MAC address read from device tree");
 	} else {
-		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
-				 ETH_ALEN, mac);
+		ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
+				       ETH_ALEN, mac);
+
+		if (ret)
+			netdev_dbg(dev->net, "Failed to read NODE_ID: %d", ret);
+
 		netif_dbg(dev, ifup, dev->net,
 			  "MAC address read from ASIX chip");
 	}
@@ -1572,6 +1721,7 @@ static int ax88179_link_reset(struct usbnet *dev)
 	u16 mode, tmp16, delay = HZ / 10;
 	u32 tmp32 = 0x40000000;
 	unsigned long jtimeout;
+	int ret;
 
 	jtimeout = jiffies + delay;
 	while (tmp32 & 0x40000000) {
@@ -1581,7 +1731,13 @@ static int ax88179_link_reset(struct usbnet *dev)
 				  &ax179_data->rxctl);
 
 		/*link up, check the usb device control TX FIFO full or empty*/
-		ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
+		ret = ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
+
+		if (ret) {
+			netdev_dbg(dev->net, "Failed to read TX FIFO: %d\n",
+				   ret);
+			return ret;
+		}
 
 		if (time_after(jiffies, jtimeout))
 			return 0;
@@ -1590,11 +1746,21 @@ static int ax88179_link_reset(struct usbnet *dev)
 	mode = AX_MEDIUM_RECEIVE_EN | AX_MEDIUM_TXFLOW_CTRLEN |
 	       AX_MEDIUM_RXFLOW_CTRLEN;
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
-			 1, 1, &link_sts);
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, PHYSICAL_LINK_STATUS,
+			       1, 1, &link_sts);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read LINK_STATUS: %d", ret);
+		return ret;
+	}
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
+			       GMII_PHY_PHYSR, 2, &tmp16);
 
-	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID,
-			 GMII_PHY_PHYSR, 2, &tmp16);
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read PHY_ID: %d\n", ret);
+		return ret;
+	}
 
 	if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
 		return 0;
@@ -1732,9 +1898,16 @@ static int ax88179_reset(struct usbnet *dev)
 static int ax88179_stop(struct usbnet *dev)
 {
 	u16 tmp16;
+	int ret;
+
+	ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			       2, 2, &tmp16);
+
+	if (ret) {
+		netdev_dbg(dev->net, "Failed to read STATUS_MODE: %d\n", ret);
+		return ret;
+	}
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			 2, 2, &tmp16);
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			  2, 2, &tmp16);
-- 
2.25.1

