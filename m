Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A959C3E5D22
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbhHJORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242503AbhHJOQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F546101E;
        Tue, 10 Aug 2021 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604961;
        bh=CU/QFcwVoy09irlJKb8oM5GtgslsHMAw8RAZRjaQ/no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Crgi1VDAixdpfn3D9FbaMpzhqTeyyUt2YrZM6heOIlej3MvcsxWCv4LbnJk+Xl7wy
         8fVYDWfp85MqaFxddrOuncurNz+r43FK8yk7nK5Guw+sLecz41SsjFB8CAY3XViQd9
         sh7ZjK202Zm7nq+UhmXx5nb5XGw7qZaQTnP0YEvsmD8Ja8uehtjOf7Qn6U9BCAs1LJ
         X0Kl7EHIe2lvmzn2SQTiN9KfRls9HKUSASq1IGkwBJYUtsb2bnQp6Y3zqTPF3aUunt
         Y5LPhu/eWR4j3PJ63IB/6Rds4AL95KQ9cthBa8HIt9eXFviUjg38IBpPNRPF9DtmUL
         EYxCnlXuLLKvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petko Manolov <petkan@nucleusys.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/20] net: usb: pegasus: Check the return value of get_geristers() and friends;
Date:   Tue, 10 Aug 2021 10:15:35 -0400
Message-Id: <20210810141538.3117707-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit 8a160e2e9aeb8318159b48701ad8a6e22274372d ]

Certain call sites of get_geristers() did not do proper error handling.  This
could be a problem as get_geristers() typically return the data via pointer to a
buffer.  If an error occurred the code is carelessly manipulating the wrong data.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 108 ++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 33 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 32e1335c94ad..fd033891810f 100644
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
@@ -999,8 +1033,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
 		data[0] = pegasus->phy;
 		fallthrough;
 	case SIOCDEVPRIVATE + 1:
-		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
-		res = 0;
+		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
 		break;
 	case SIOCDEVPRIVATE + 2:
 		if (!capable(CAP_NET_ADMIN))
@@ -1034,22 +1067,25 @@ static void pegasus_set_multicast(struct net_device *net)
 
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
@@ -1061,7 +1097,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg7b, 2);
 
 	set_register(pegasus, 0x83, data);
-	get_registers(pegasus, 0x83, 1, &data);
+	ret = get_registers(pegasus, 0x83, 1, &data);
+	if (ret < 0)
+		goto fail;
 
 	if (data == 0xa5)
 		pegasus->chip = 0x8513;
@@ -1076,6 +1114,10 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
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

