Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1F3F695F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhHXS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:23 -0400
Received: from crane.ash.relay.mailchannels.net ([23.83.222.43]:59343 "EHLO
        crane.ash.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234038AbhHXS6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:14 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 68FCB920BB6;
        Tue, 24 Aug 2021 18:57:23 +0000 (UTC)
Received: from ares.krystal.co.uk (unknown [127.0.0.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id EE054920B5F;
        Tue, 24 Aug 2021 18:57:21 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.100.96.74 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:23 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Drop-Supply: 25f3c7452642be8a_1629831443240_2950002745
X-MC-Loop-Signature: 1629831443240:305183511
X-MC-Ingress-Time: 1629831443240
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k1Dk9r/jJV5c6GXDrbYpTJHLaskj6jut04Qz53Q8ES4=; b=PITo9w6Vxf68vOdHta2ZAXNFCC
        p0IpMD99m0c8jtYwHWprj8Pye7dnbc39qe/sO8hVyJfzoCK6cPPsBWWkbx700whRsERmoQnAkT210
        kiWfNKIY+PBUL6024Fg/a0Rpmjur1g9y9bQbtzvqywb+zxneuP0ofIfK5x2C00VcWw5OfJfZNifSI
        MxFiMXhcdOiAamuhvVp35ci86BOtXIeEj1bhmKVx5gKtjd9UcKvA0K71dY3dXI0+yXsg3Ne3xGiQo
        Vxe6uG5So9gjo2tiMjotnVT2IliaNCCD10n/s1HAHXvp7yANrFD2C7hdv7AYcsokNqwdGIuYTjzm/
        ZTJ88CiA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbs-00BQSi-T7; Tue, 24 Aug 2021 19:57:19 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 09/10] lan78xx: Fix race condition in disconnect handling
Date:   Tue, 24 Aug 2021 19:56:12 +0100
Message-Id: <20210824185613.49545-10-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a device disconnect at roughly the same time as a
deferred PHY link reset there is a race condition that can result
in a kernel lock up due to a null pointer dereference in the
driver's deferred work handling routine lan78xx_delayedwork().
The following changes fix this problem.

Add new status flag EVENT_DEV_DISCONNECT to indicate when the
device has been removed and use it to prevent operations, such as
register access, that will fail once the device is removed.

Stop processing of deferred work items when the driver's USB
disconnect handler is invoked.

Disconnect the PHY only after the network device has been
unregistered and all delayed work has been cancelled.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 66 +++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9f395504f77e..4ec752d9751a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -360,6 +360,7 @@ struct usb_context {
 #define EVENT_DEV_ASLEEP		7
 #define EVENT_DEV_OPEN			8
 #define EVENT_STAT_UPDATE		9
+#define EVENT_DEV_DISCONNECT		10
 
 struct statstage {
 	struct mutex			access_lock;	/* for stats access */
@@ -444,9 +445,13 @@ MODULE_PARM_DESC(msg_level, "Override default message level");
 
 static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
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
 
@@ -470,9 +475,13 @@ static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 
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
 
@@ -3146,16 +3155,23 @@ static void tx_complete(struct urb *urb)
 		/* software-driven interface shutdown */
 		case -ECONNRESET:
 		case -ESHUTDOWN:
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx err interface gone %d\n",
+				  entry->urb->status);
 			break;
 
 		case -EPROTO:
 		case -ETIME:
 		case -EILSEQ:
 			netif_stop_queue(dev->net);
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx err queue stopped %d\n",
+				  entry->urb->status);
 			break;
 		default:
 			netif_dbg(dev, tx_err, dev->net,
-				  "tx err %d\n", entry->urb->status);
+				  "unknown tx err %d\n",
+				  entry->urb->status);
 			break;
 		}
 	}
@@ -3489,6 +3505,7 @@ static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
 			lan78xx_defer_kevent(dev, EVENT_RX_HALT);
 			break;
 		case -ENODEV:
+		case -ENOENT:
 			netif_dbg(dev, ifdown, dev->net, "device gone\n");
 			netif_device_detach(dev->net);
 			break;
@@ -3689,6 +3706,12 @@ static void lan78xx_tx_bh(struct lan78xx_net *dev)
 		lan78xx_defer_kevent(dev, EVENT_TX_HALT);
 		usb_autopm_put_interface_async(dev->intf);
 		break;
+	case -ENODEV:
+	case -ENOENT:
+		netif_dbg(dev, tx_err, dev->net,
+			  "tx: submit urb err %d (disconnected?)", ret);
+		netif_device_detach(dev->net);
+		break;
 	default:
 		usb_autopm_put_interface_async(dev->intf);
 		netif_dbg(dev, tx_err, dev->net,
@@ -3783,6 +3806,9 @@ static void lan78xx_delayedwork(struct work_struct *work)
 
 	dev = container_of(work, struct lan78xx_net, wq.work);
 
+	if (test_bit(EVENT_DEV_DISCONNECT, &dev->flags))
+		return;
+
 	if (usb_autopm_get_interface(dev->intf) < 0)
 		return;
 
@@ -3857,6 +3883,7 @@ static void intr_complete(struct urb *urb)
 
 	/* software-driven interface shutdown */
 	case -ENOENT:			/* urb killed */
+	case -ENODEV:			/* hardware gone */
 	case -ESHUTDOWN:		/* hardware gone */
 		netif_dbg(dev, ifdown, dev->net,
 			  "intr shutdown, code %d\n", status);
@@ -3870,14 +3897,29 @@ static void intr_complete(struct urb *urb)
 		break;
 	}
 
-	if (!netif_running(dev->net))
+	if (!netif_device_present(dev->net) ||
+	    !netif_running(dev->net)) {
+		netdev_warn(dev->net, "not submitting new status URB");
 		return;
+	}
 
 	memset(urb->transfer_buffer, 0, urb->transfer_buffer_length);
 	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status != 0)
+
+	switch (status) {
+	case  0:
+		break;
+	case -ENODEV:
+	case -ENOENT:
+		netif_dbg(dev, timer, dev->net,
+			  "intr resubmit %d (disconnect?)", status);
+		netif_device_detach(dev->net);
+		break;
+	default:
 		netif_err(dev, timer, dev->net,
 			  "intr resubmit --> %d\n", status);
+		break;
+	}
 }
 
 static void lan78xx_disconnect(struct usb_interface *intf)
@@ -3892,8 +3934,15 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	set_bit(EVENT_DEV_DISCONNECT, &dev->flags);
+
 	udev = interface_to_usbdev(intf);
 	net = dev->net;
+
+	unregister_netdev(net);
+
+	cancel_delayed_work_sync(&dev->wq);
+
 	phydev = net->phydev;
 
 	phy_unregister_fixup_for_uid(PHY_KSZ9031RNX, 0xfffffff0);
@@ -3904,12 +3953,11 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (phy_is_pseudo_fixed_link(phydev))
 		fixed_phy_unregister(phydev);
 
-	unregister_netdev(net);
-
-	cancel_delayed_work_sync(&dev->wq);
-
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
+	if (timer_pending(&dev->stat_monitor))
+		del_timer_sync(&dev->stat_monitor);
+
 	lan78xx_unbind(dev, intf);
 
 	usb_kill_urb(dev->urb_intr);
-- 
2.25.1

