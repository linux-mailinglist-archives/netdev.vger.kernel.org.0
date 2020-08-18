Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB6248BD9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgHRQov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:44:51 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:13901 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgHRQot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597769087; x=1629305087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xxv/yDjemQvZ/pge0wayJNkQ0RG4xuY7VsDnEhXS79c=;
  b=K98Im81JDrJmIp+05+Ff5rOD3eR73ln7q9pmaXj324aEx8Ef20lBneS3
   /03zRmwytvFXc9v0yH7ODv8qJJ9zMuEqfPze0IDnq/w2417cf5ci9Y5nA
   Mg7yxDIFpfF+xgjlTuMrwJC/El/P4XfViHsNq7gmSWz6VgPT7MRljJY63
   i7okBKYFz+o/JW5GyXaIWWZYPS218HbYdYRaKP2wqHAucdxBNhII62t3p
   8CYg3zlaJVpPntuhP8PFkMnrdxAzeCE+hF+n9/RdYJT813gX99G1/n1O4
   KhalZY/QGEucoYvI/hVL9qutCaCPhAVw8nZ/ObQ9ZeYjqFqsQTT/TZz59
   w==;
IronPort-SDR: tErf2QkoPnd3dUPkp1yiEKRvHMhQljecaPkpZ5ZmGaiQQql3rgbm4Lv1DbmoV85rvQbtj1ix4s
 HVh1Y8Y6xHd4iEvyRT7O/jpNQ1RwlFmyXrjH92Lx93HA7qFq82m5fuJV+7hzCRf3tGKvkHvuOX
 0kfI66aaN5oq3JMWtFx87L/YQNdxQOJfK6KiFETzTID+RDEpa+v9bpKqEEbTLwdRZbHn3qYlOs
 AUDOezl8PDFsvH5nHFlg/chmFm3BuRhMED4rOiJkzdfRksdvDl72C5pKpnF594sBPEqK8Wceg+
 ZTs=
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="88479769"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2020 09:44:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 09:44:43 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 18 Aug 2020 09:43:56 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v4 2/3] smsc95xx: use usbnet->driver_priv
Date:   Tue, 18 Aug 2020 18:44:02 +0200
Message-ID: <20200818164403.209985-3-andre.edich@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200818164403.209985-1-andre.edich@microchip.com>
References: <20200818164403.209985-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using `void *driver_priv` instead of `unsigned long data[]` is more
straightforward way to recover the `struct smsc95xx_priv *` from the
`struct net_device *`.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 61 +++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 3fdf7c2b2d25..f200684875fb 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -457,7 +457,7 @@ static unsigned int smsc95xx_hash(char addr[ETH_ALEN])
 static void smsc95xx_set_multicast(struct net_device *netdev)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -552,7 +552,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
 
 static int smsc95xx_link_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	struct mii_if_info *mii = &dev->mii;
 	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
 	unsigned long flags;
@@ -620,7 +620,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 
 static void set_carrier(struct usbnet *dev, bool link)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	if (pdata->link_ok == link)
 		return;
@@ -749,7 +749,7 @@ static void smsc95xx_ethtool_get_wol(struct net_device *net,
 				     struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	wolinfo->supported = SUPPORTED_WAKE;
 	wolinfo->wolopts = pdata->wolopts;
@@ -759,7 +759,7 @@ static int smsc95xx_ethtool_set_wol(struct net_device *net,
 				    struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (wolinfo->wolopts & ~SUPPORTED_WAKE)
@@ -798,7 +798,7 @@ static int get_mdix_status(struct net_device *net)
 static void set_mdix_status(struct net_device *net, __u8 mdix_ctrl)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int buf;
 
 	if ((pdata->chip_id == ID_REV_CHIP_ID_9500A_) ||
@@ -847,7 +847,7 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
 				       struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	retval = usbnet_get_link_ksettings(net, cmd);
@@ -862,7 +862,7 @@ static int smsc95xx_set_link_ksettings(struct net_device *net,
 				       const struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	if (pdata->mdix_ctrl != cmd->base.eth_tp_mdix_ctrl)
@@ -944,7 +944,7 @@ static int smsc95xx_set_mac_address(struct usbnet *dev)
 /* starts the TX path */
 static int smsc95xx_start_tx_path(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -964,7 +964,7 @@ static int smsc95xx_start_tx_path(struct usbnet *dev)
 /* Starts the Receive path */
 static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
@@ -1021,7 +1021,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 
 static int smsc95xx_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 read_buf, write_buf, burst_cap;
 	int ret = 0, timeout;
 
@@ -1249,7 +1249,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct smsc95xx_priv *pdata = NULL;
+	struct smsc95xx_priv *pdata;
 	u32 val;
 	int ret;
 
@@ -1261,13 +1261,12 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		return ret;
 	}
 
-	dev->data[0] = (unsigned long)kzalloc(sizeof(struct smsc95xx_priv),
-					      GFP_KERNEL);
-
-	pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
+	dev->driver_priv = pdata;
+
 	spin_lock_init(&pdata->mac_cr_lock);
 
 	/* LAN95xx devices do not alter the computed checksum of 0 to 0xffff.
@@ -1330,15 +1329,11 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
-
-	if (pdata) {
-		cancel_delayed_work_sync(&pdata->carrier_check);
-		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
-		kfree(pdata);
-		pdata = NULL;
-		dev->data[0] = 0;
-	}
+	struct smsc95xx_priv *pdata = dev->driver_priv;
+
+	cancel_delayed_work_sync(&pdata->carrier_check);
+	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
+	kfree(pdata);
 }
 
 static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
@@ -1388,7 +1383,7 @@ static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend0(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1427,7 +1422,7 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1474,7 +1469,7 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend2(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1496,7 +1491,7 @@ static int smsc95xx_enter_suspend2(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend3(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1535,7 +1530,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (!netif_running(dev->net)) {
@@ -1583,7 +1578,7 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val, link_up;
 	int ret;
 
@@ -1854,7 +1849,7 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	u32 val;
 
 	BUG_ON(!dev);
-	pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	pdata = dev->driver_priv;
 	suspend_flags = pdata->suspend_flags;
 
 	netdev_dbg(dev->net, "resume suspend_flags=0x%02x\n", suspend_flags);
@@ -2074,7 +2069,7 @@ static struct sk_buff *smsc95xx_tx_fixup(struct usbnet *dev,
 
 static int smsc95xx_manage_power(struct usbnet *dev, int on)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	dev->intf->needs_remote_wakeup = on;
 
-- 
2.28.0

