Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05F63DF3E6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhHCRZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbhHCRZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:25:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C4C0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 10:25:39 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k4so12917944wms.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 10:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gfLRzLBsd8Qqq3ef1vz7d+tTRzcFiMHvFpjqF3BOrGo=;
        b=jVb/Thq2TZvez+i0qBrsVvOunXvkdkIDmpJg/nqyAYZYAeg9Ovlk6LhJYheYt/c8as
         42kc6jxgo1JRERKH0xntsW6JFzZyOh0lq6APhttIU+OMsUkeWmtGI1TqGzZe+NRXHXMA
         zmPFXueNQTBVfiAZHHTR2HD/YncN0ZtUqQrEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gfLRzLBsd8Qqq3ef1vz7d+tTRzcFiMHvFpjqF3BOrGo=;
        b=kgBTtJcaEJstwZp1Kiqhf1tGCoor6N2Ex3R9VrubYxe8eIw55qxEyUTs1Gsn49AuGA
         o9qvzrhki+9828ToIC4xc7tvASYqwmCajfId5TRgEoFLzaubhTFcDGVkhxcZcBdN7Phv
         ShfSIPEW2rYhVfar0gMPOSeoWcAv/VY//eByplaTzFBcluQ+uLRVcM3JwWv71+VBNwaU
         czDUtT39BeuWqFE1k3IjDeHZzl+Nj9kDgN2my9qDbs3Uv+08n54xc40/zw8qDsjhi7Uw
         jtqUReoJ6Z+uYmbp8f9Y7ywYcdkhVibbvNol9Pj4dYqlt/7dqEjo40+KDrQumkYjsxwj
         Ze1g==
X-Gm-Message-State: AOAM533eoeJ7RrhWjaf+FrFCiEZuaB9TF8AJTn8i6K5R7y/R7L7bIRYn
        zmV2eKYi2Uaa85fwAt6Kb/WGlX5Sc/3ypg==
X-Google-Smtp-Source: ABdhPJwjN36egXWKSNY/qxa6hzDQdZCNLzbv4qI38htvuYYUxZY6ZiXHi1dAih7bdn9OhQkW8cD7Hw==
X-Received: by 2002:a1c:1b55:: with SMTP id b82mr5452455wmb.121.1628011537871;
        Tue, 03 Aug 2021 10:25:37 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id e5sm18489190wrr.36.2021.08.03.10.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:25:37 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net v3 1/2] net: usb: pegasus: Check the return value of get_geristers() and friends;
Date:   Tue,  3 Aug 2021 20:25:23 +0300
Message-Id: <20210803172524.6088-2-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803172524.6088-1-petko.manolov@konsulko.com>
References: <20210803172524.6088-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

Certain call sites of get_geristers() did not do proper error handling.  This
could be a problem as get_geristers() typically return the data via pointer to a
buffer.  If an error occurred the code is carelessly manipulating the wrong data.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
---
 drivers/net/usb/pegasus.c | 108 ++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 33 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 9a907182569c..22353bab76c8 100644
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
+	int i, ret;
 	__le16 regdi;
-	int ret = -ETIMEDOUT;
+	__u8 data[4] = { phy, 0, 0, indx };
 
 	if (cmd & PHY_WRITE) {
 		__le16 *t = (__le16 *) & data[1];
@@ -207,12 +217,15 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
 		if (data[0] & PHY_DONE)
 			break;
 	}
-	if (i >= REG_TIMEOUT)
+	if (i >= REG_TIMEOUT) {
+		ret = -ETIMEDOUT;
 		goto fail;
+	}
 	if (cmd & PHY_READ) {
 		ret = get_registers(p, PhyData, 2, &regdi);
+		if (ret < 0)
+			goto fail;
 		*regd = le16_to_cpu(regdi);
-		return ret;
 	}
 	return 0;
 fail:
@@ -235,9 +248,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
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
 
@@ -251,10 +268,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 
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
@@ -262,21 +278,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 
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
@@ -324,10 +344,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
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
@@ -367,19 +387,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
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
@@ -402,22 +424,29 @@ static inline int reset_mac(pegasus_t *pegasus)
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
@@ -435,11 +464,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
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
 
@@ -447,9 +481,9 @@ static void read_bulk_callback(struct urb *urb)
 {
 	pegasus_t *pegasus = urb->context;
 	struct net_device *net;
+	u8 *buf = urb->transfer_buffer;
 	int rx_status, count = urb->actual_length;
 	int status = urb->status;
-	u8 *buf = urb->transfer_buffer;
 	__u16 pkt_len;
 
 	if (!pegasus)
@@ -998,8 +1032,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
 		data[0] = pegasus->phy;
 		fallthrough;
 	case SIOCDEVPRIVATE + 1:
-		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
-		res = 0;
+		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
 		break;
 	case SIOCDEVPRIVATE + 2:
 		if (!capable(CAP_NET_ADMIN))
@@ -1033,22 +1066,25 @@ static void pegasus_set_multicast(struct net_device *net)
 
 static __u8 mii_phy_probe(pegasus_t *pegasus)
 {
-	int i;
+	int i, ret;
 	__u16 tmp;
 
 	for (i = 0; i < 32; i++) {
-		read_mii_word(pegasus, i, MII_BMSR, &tmp);
+		ret = read_mii_word(pegasus, i, MII_BMSR, &tmp);
+		if (ret < 0)
+			goto fail;
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
@@ -1060,7 +1096,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg7b, 2);
 
 	set_register(pegasus, 0x83, data);
-	get_registers(pegasus, 0x83, 1, &data);
+	ret = get_registers(pegasus, 0x83, 1, &data);
+	if (ret < 0)
+		goto fail;
 
 	if (data == 0xa5)
 		pegasus->chip = 0x8513;
@@ -1075,6 +1113,10 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg81, 6);
 	else
 		set_register(pegasus, Reg81, 2);
+
+	return;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 }
 
 static void check_carrier(struct work_struct *work)
-- 
2.30.2

