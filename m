Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0130F2CD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhBDMAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:00:05 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:59550 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhBDL77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:59:59 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-Vt; Thu, 04 Feb 2021 11:32:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 5/9] lan78xx: fix race condition in PHY handling causing kernel lock up
Date:   Thu,  4 Feb 2021 11:31:17 +0000
Message-Id: <20210204113121.29786-6-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a device disconnect at roughly the same time as a deferred
PHY link reset there is a race condition that can result in kernel
lock up due to a null pointer dereference in the driver's deferred
work handling routine lan78xx_delayedwork().

Stop processing of deferred work items when the driver's USB disconnect
handler is invoked.

Disconnect the PHY only after the network device has been unregistered
and all delayed work has been been cancelled.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index d2fcc3c5eff2..7c815061e02e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -391,6 +391,7 @@ struct usb_context {
 #define EVENT_DEV_ASLEEP		7
 #define EVENT_DEV_OPEN			8
 #define EVENT_STAT_UPDATE		9
+#define EVENT_DEV_DISCONNECT		10
 
 struct statstage {
 	struct mutex			access_lock;	/* for stats access */
@@ -605,9 +606,14 @@ static int lan78xx_alloc_tx_resources(struct lan78xx_net *dev)
 
 static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 {
-	u32 *buf = kmalloc(sizeof(u32), GFP_KERNEL);
+	u32 *buf;
 	int ret;
 
+	if (test_bit(EVENT_DEV_DISCONNECT, &dev->flags))
+		return -ENODEV;
+
+	buf = kmalloc(sizeof(u32), GFP_KERNEL);
+
 	if (!buf)
 		return -ENOMEM;
 
@@ -631,9 +637,13 @@ static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 
 static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
 {
-	u32 *buf = kmalloc(sizeof(u32), GFP_KERNEL);
+	u32 *buf;
 	int ret;
 
+	if (test_bit(EVENT_DEV_DISCONNECT, &dev->flags))
+		return -ENODEV;
+
+	buf = kmalloc(sizeof(u32), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -2972,6 +2982,8 @@ static int lan78xx_open(struct net_device *net)
 	struct lan78xx_net *dev = netdev_priv(net);
 	int ret;
 
+	netif_dbg(dev, ifup, dev->net, "open device");
+
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
 		goto out;
@@ -3059,6 +3071,8 @@ static int lan78xx_stop(struct net_device *net)
 {
 	struct lan78xx_net *dev = netdev_priv(net);
 
+	netif_dbg(dev, ifup, dev->net, "stop device");
+
 	mutex_lock(&dev->dev_mutex);
 
 	if (timer_pending(&dev->stat_monitor))
@@ -3087,7 +3101,11 @@ static int lan78xx_stop(struct net_device *net)
 	 * can't flush_scheduled_work() until we drop rtnl (later),
 	 * else workers could deadlock; so make workers a NOP.
 	 */
-	dev->flags = 0;
+	clear_bit(EVENT_TX_HALT, &dev->flags);
+	clear_bit(EVENT_RX_HALT, &dev->flags);
+	clear_bit(EVENT_LINK_RESET, &dev->flags);
+	clear_bit(EVENT_STAT_UPDATE, &dev->flags);
+
 	cancel_delayed_work_sync(&dev->wq);
 
 	usb_autopm_put_interface(dev->intf);
@@ -3967,6 +3985,9 @@ static void lan78xx_delayedwork(struct work_struct *work)
 
 	dev = container_of(work, struct lan78xx_net, wq.work);
 
+	if (test_bit(EVENT_DEV_DISCONNECT, &dev->flags))
+		return;
+
 	if (usb_autopm_get_interface(dev->intf) < 0)
 		return;
 
@@ -4093,10 +4114,18 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	set_bit(EVENT_DEV_DISCONNECT, &dev->flags);
+
 	netif_napi_del(&dev->napi);
 
 	udev = interface_to_usbdev(intf);
+
 	net = dev->net;
+
+	unregister_netdev(net);
+
+	cancel_delayed_work_sync(&dev->wq);
+
 	phydev = net->phydev;
 
 	phy_unregister_fixup_for_uid(PHY_KSZ9031RNX, 0xfffffff0);
@@ -4107,10 +4136,6 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (phy_is_pseudo_fixed_link(phydev))
 		fixed_phy_unregister(phydev);
 
-	unregister_netdev(net);
-
-	cancel_delayed_work_sync(&dev->wq);
-
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
 	if (timer_pending(&dev->stat_monitor))
-- 
2.17.1

