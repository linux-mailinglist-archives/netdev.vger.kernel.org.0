Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8133DF102
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhHCPDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236529AbhHCPDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:03:39 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D3AC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:03:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b13so14791164wrs.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=adIoClHrdxjs1P8Eo7QvDzhihIv9G7m/DJiWBXswifI=;
        b=KdFj7sgvXc0Z6Vxk4Xq5OJoEKMyNI25wmruKfnzJzOccU8SFbwbJMWx1aviDOKz9Or
         w9edi7mcV+ywqy/Pb3eAAc0izXTb3e3qckDaOxlVwIuhp5SpQPpihyBzIUYHdimXt7XQ
         NvHLYecnl7Mm37NcIHHwcyoMGjz2I7gQPeVVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=adIoClHrdxjs1P8Eo7QvDzhihIv9G7m/DJiWBXswifI=;
        b=TwY+6C/zva+hMbb56aW4TBv2rCltriPMGj2nDexPAunOZ9GqhXL9DHYWP33nirWlWn
         ys5y3RORY26qs1sNyQPl8KP5kIqCWBnooUCtaTDmCt0osH/9pj9nrMRffa/IofsVHlua
         vCw5HfO89rFjJTQ8QATWQwPGrPmFx2WghsxL2sqR6luvtfzZbsO2Hklh0u5BYM6cUhbP
         W60QHdmeIHC9Ehr38mkphuCOm3YhdgO3AXymmO8GqobTjDYAqihSiaFptblZaUpUpu+W
         Q4tsmW6lb0ejPlwtnzmbr94+wjZYVtzBsinKwNOCWxYyR+yfuiucFaZzgdJP6+fKdy75
         /Lrg==
X-Gm-Message-State: AOAM530IEyEfQncKDeqeFj+1nX9RrdHc5fOO38Rhns0p2CVy1Udp9Z99
        MNLtruMrtqhSgo0nla14tXiMVxt3tnN4cw==
X-Google-Smtp-Source: ABdhPJxWjhF9HRuF6fpjGzCIPGenevU3zYhKX/t6KpxcumWw6QSgMPbVrgKHa9C8eb+iglcDR2YRsA==
X-Received: by 2002:adf:db07:: with SMTP id s7mr24496752wri.106.1628003006834;
        Tue, 03 Aug 2021 08:03:26 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id l5sm16883641wrc.90.2021.08.03.08.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:03:26 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net 1/2] net: usb: pegasus: Check the return value of get_geristers() and friends;
Date:   Tue,  3 Aug 2021 18:03:16 +0300
Message-Id: <20210803150317.5325-2-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803150317.5325-1-petko.manolov@konsulko.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

Certain call sites of get_geristers() did not do proper error handling.  This
could be a problem as get_geristers() typically return the data via pointer to a
buffer.  If an error occured the code is carelessly manipulating the wrong data.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
---
 drivers/net/usb/pegasus.c | 102 ++++++++++++++++++++++++++------------
 1 file changed, 70 insertions(+), 32 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 9a907182569c..924be11ee72c 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -132,9 +132,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
 static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
 			 const void *data)
 {
-	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
+	int ret;
+
+	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
 				    PEGASUS_REQT_WRITE, 0, indx, data, size,
 				    1000, GFP_NOIO);
+	if (ret < 0)
+		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
+
+	return ret;
 }
 
 /*
@@ -145,10 +151,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
 static int set_register(pegasus_t *pegasus, __u16 indx, __u8 data)
 {
 	void *buf = &data;
+	int ret;
 
-	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
+	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
 				    PEGASUS_REQT_WRITE, data, indx, buf, 1,
 				    1000, GFP_NOIO);
+	if (ret < 0)
+		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
+
+	return ret;
 }
 
 static int update_eth_regs_async(pegasus_t *pegasus)
@@ -188,10 +199,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 
 static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
 {
-	int i;
-	__u8 data[4] = { phy, 0, 0, indx };
+	int i, ret = -ETIMEDOUT;
 	__le16 regdi;
-	int ret = -ETIMEDOUT;
+	__u8 data[4] = { phy, 0, 0, indx };
 
 	if (cmd & PHY_WRITE) {
 		__le16 *t = (__le16 *) & data[1];
@@ -211,8 +221,9 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
 		goto fail;
 	if (cmd & PHY_READ) {
 		ret = get_registers(p, PhyData, 2, &regdi);
+		if (ret < 0)
+			goto fail;
 		*regd = le16_to_cpu(regdi);
-		return ret;
 	}
 	return 0;
 fail:
@@ -235,9 +246,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
 static int mdio_read(struct net_device *dev, int phy_id, int loc)
 {
 	pegasus_t *pegasus = netdev_priv(dev);
+	int ret;
 	u16 res;
 
-	read_mii_word(pegasus, phy_id, loc, &res);
+	ret = read_mii_word(pegasus, phy_id, loc, &res);
+	if (ret < 0)
+		return ret;
+
 	return (int)res;
 }
 
@@ -251,10 +266,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 
 static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 {
-	int i;
-	__u8 tmp = 0;
+	int ret, i;
 	__le16 retdatai;
-	int ret;
+	__u8 tmp = 0;
 
 	set_register(pegasus, EpromCtrl, 0);
 	set_register(pegasus, EpromOffset, index);
@@ -262,21 +276,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 
 	for (i = 0; i < REG_TIMEOUT; i++) {
 		ret = get_registers(pegasus, EpromCtrl, 1, &tmp);
+		if (ret < 0)
+			goto fail;
 		if (tmp & EPROM_DONE)
 			break;
-		if (ret == -ESHUTDOWN)
-			goto fail;
 	}
-	if (i >= REG_TIMEOUT)
+	if (i >= REG_TIMEOUT) {
+		ret = -ETIMEDOUT;
 		goto fail;
+	}
 
 	ret = get_registers(pegasus, EpromData, 2, &retdatai);
+	if (ret < 0)
+		goto fail;
 	*retdata = le16_to_cpu(retdatai);
 	return ret;
 
 fail:
-	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
-	return -ETIMEDOUT;
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	return ret;
 }
 
 #ifdef	PEGASUS_WRITE_EEPROM
@@ -324,10 +342,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
 	return ret;
 
 fail:
-	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return -ETIMEDOUT;
 }
-#endif				/* PEGASUS_WRITE_EEPROM */
+#endif	/* PEGASUS_WRITE_EEPROM */
 
 static inline int get_node_id(pegasus_t *pegasus, u8 *id)
 {
@@ -367,19 +385,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
 	return;
 err:
 	eth_hw_addr_random(pegasus->net);
-	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
+	netif_dbg(pegasus, drv, pegasus->net, "software assigned MAC address.\n");
 
 	return;
 }
 
 static inline int reset_mac(pegasus_t *pegasus)
 {
+	int ret, i;
 	__u8 data = 0x8;
-	int i;
 
 	set_register(pegasus, EthCtrl1, data);
 	for (i = 0; i < REG_TIMEOUT; i++) {
-		get_registers(pegasus, EthCtrl1, 1, &data);
+		ret = get_registers(pegasus, EthCtrl1, 1, &data);
+		if (ret < 0)
+			goto fail;
 		if (~data & 0x08) {
 			if (loopback)
 				break;
@@ -402,22 +422,29 @@ static inline int reset_mac(pegasus_t *pegasus)
 	}
 	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_ELCON) {
 		__u16 auxmode;
-		read_mii_word(pegasus, 3, 0x1b, &auxmode);
+		ret = read_mii_word(pegasus, 3, 0x1b, &auxmode);
+		if (ret < 0)
+			goto fail;
 		auxmode |= 4;
 		write_mii_word(pegasus, 3, 0x1b, &auxmode);
 	}
 
 	return 0;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	return ret;
 }
 
 static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 {
-	__u16 linkpart;
-	__u8 data[4];
 	pegasus_t *pegasus = netdev_priv(dev);
 	int ret;
+	__u16 linkpart;
+	__u8 data[4];
 
-	read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
+	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
+	if (ret < 0)
+		goto fail;
 	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
 	data[1] = 0;
 	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
@@ -435,11 +462,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
 	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
 		u16 auxmode;
-		read_mii_word(pegasus, 0, 0x1b, &auxmode);
+		ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
+		if (ret < 0)
+			goto fail;
 		auxmode |= 4;
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
+	return 0;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
 }
 
@@ -447,9 +479,9 @@ static void read_bulk_callback(struct urb *urb)
 {
 	pegasus_t *pegasus = urb->context;
 	struct net_device *net;
+	u8 *buf = urb->transfer_buffer;
 	int rx_status, count = urb->actual_length;
 	int status = urb->status;
-	u8 *buf = urb->transfer_buffer;
 	__u16 pkt_len;
 
 	if (!pegasus)
@@ -998,8 +1030,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
 		data[0] = pegasus->phy;
 		fallthrough;
 	case SIOCDEVPRIVATE + 1:
-		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
-		res = 0;
+		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
 		break;
 	case SIOCDEVPRIVATE + 2:
 		if (!capable(CAP_NET_ADMIN))
@@ -1033,22 +1064,25 @@ static void pegasus_set_multicast(struct net_device *net)
 
 static __u8 mii_phy_probe(pegasus_t *pegasus)
 {
-	int i;
+	int i, ret;
 	__u16 tmp;
 
 	for (i = 0; i < 32; i++) {
-		read_mii_word(pegasus, i, MII_BMSR, &tmp);
+		ret = read_mii_word(pegasus, i, MII_BMSR, &tmp)
+		if (ret < 0)
+			goto out;
 		if (tmp == 0 || tmp == 0xffff || (tmp & BMSR_MEDIA) == 0)
 			continue;
 		else
 			return i;
 	}
-
+fail:
 	return 0xff;
 }
 
 static inline void setup_pegasus_II(pegasus_t *pegasus)
 {
+	int ret;
 	__u8 data = 0xa5;
 
 	set_register(pegasus, Reg1d, 0);
@@ -1060,7 +1094,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg7b, 2);
 
 	set_register(pegasus, 0x83, data);
-	get_registers(pegasus, 0x83, 1, &data);
+	ret = get_registers(pegasus, 0x83, 1, &data);
+	if (ret < 0)
+		goto fail;
 
 	if (data == 0xa5)
 		pegasus->chip = 0x8513;
@@ -1075,6 +1111,8 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg81, 6);
 	else
 		set_register(pegasus, Reg81, 2);
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 }
 
 static void check_carrier(struct work_struct *work)
-- 
2.30.2

