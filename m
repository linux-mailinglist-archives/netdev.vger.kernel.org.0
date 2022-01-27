Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E5449E03B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbiA0LHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbiA0LHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:07:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E6C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:07:50 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2cy-0002MJ-2D; Thu, 27 Jan 2022 12:07:44 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2cx-003sC4-5a; Thu, 27 Jan 2022 12:07:43 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] usbnet: add devlink support
Date:   Thu, 27 Jan 2022 12:07:42 +0100
Message-Id: <20220127110742.922752-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The weakest link of usbnet devices is the USB cable. Currently there is
no way to automatically detect cable related issues except of analyzing
kernel log, which would differ depending on the USB host controller.

The Ethernet packet counter could potentially show evidence of some USB
related issues, but can be Ethernet related problem as well.

To provide generic way to detect USB issues or HW issues on different
levels we need to make use of devlink.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/Kconfig          |   1 +
 drivers/net/usb/Makefile         |   2 +-
 drivers/net/usb/usbnet-devlink.c | 235 +++++++++++++++++++++++++++++++
 drivers/net/usb/usbnet.c         |  64 +++++++--
 include/linux/usb/usbnet.h       |  24 ++++
 5 files changed, 317 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/usb/usbnet-devlink.c

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index b554054a7560..7c00bcddebcb 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -133,6 +133,7 @@ config USB_LAN78XX
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
 	select MII
+	select NET_DEVLINK
 	help
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 4964f7b326fb..c916c0692f40 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_USB_NET_RNDIS_HOST)	+= rndis_host.o
 obj-$(CONFIG_USB_NET_CDC_SUBSET_ENABLE)	+= cdc_subset.o
 obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
 obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
-obj-$(CONFIG_USB_USBNET)	+= usbnet.o
+obj-$(CONFIG_USB_USBNET)	+= usbnet.o usbnet-devlink.o
 obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
 obj-$(CONFIG_USB_NET_KALMIA)	+= kalmia.o
diff --git a/drivers/net/usb/usbnet-devlink.c b/drivers/net/usb/usbnet-devlink.c
new file mode 100644
index 000000000000..91c2e4eef695
--- /dev/null
+++ b/drivers/net/usb/usbnet-devlink.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/usb/usbnet.h>
+
+static struct usbnet *usbnet_from_devlink(struct devlink *devlink)
+{
+	struct usbnet_devlink_priv *priv = devlink_priv(devlink);
+
+	return priv->usbnet;
+}
+
+static int usbnet_usb_health_report(struct devlink_health_reporter *reporter,
+				    struct usbnet_devlink_priv *dl_priv,
+				    char *string, int err)
+{
+	char buf[50];
+
+	snprintf(buf, sizeof(buf), "%s %pe", string, ERR_PTR(err));
+
+	return devlink_health_report(reporter, buf, dl_priv);
+}
+
+int usbnet_usb_tx_health_report(struct usbnet *usbnet, char *string, int err)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(usbnet->devlink);
+
+	return usbnet_usb_health_report(dl_priv->usb_tx_fault_reporter,
+					dl_priv, string, err);
+}
+
+int usbnet_usb_rx_health_report(struct usbnet *usbnet, char *string, int err)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(usbnet->devlink);
+
+	return usbnet_usb_health_report(dl_priv->usb_rx_fault_reporter,
+					dl_priv, string, err);
+}
+
+int usbnet_usb_ctrl_health_report(struct usbnet *usbnet, char *string, int err)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(usbnet->devlink);
+
+	return usbnet_usb_health_report(dl_priv->usb_ctrl_fault_reporter,
+					dl_priv, string, err);
+}
+
+int usbnet_usb_intr_health_report(struct usbnet *usbnet, char *string, int err)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(usbnet->devlink);
+
+	return usbnet_usb_health_report(dl_priv->usb_intr_fault_reporter,
+					dl_priv, string, err);
+}
+
+static const struct
+devlink_health_reporter_ops usbnet_usb_ctrl_fault_reporter_ops = {
+	.name = "usb_ctrl",
+};
+
+static const struct
+devlink_health_reporter_ops usbnet_usb_intr_fault_reporter_ops = {
+	.name = "usb_intr",
+};
+
+static const struct
+devlink_health_reporter_ops usbnet_usb_tx_fault_reporter_ops = {
+	.name = "usb_tx",
+};
+
+static const struct
+devlink_health_reporter_ops usbnet_usb_rx_fault_reporter_ops = {
+	.name = "usb_rx",
+};
+
+static int usbnet_health_reporters_create(struct devlink *devlink)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(devlink);
+	struct usbnet *usbnet = usbnet_from_devlink(devlink);
+	int ret;
+
+	dl_priv->usb_rx_fault_reporter =
+		devlink_health_reporter_create(devlink,
+					       &usbnet_usb_rx_fault_reporter_ops,
+					       0, dl_priv);
+	if (IS_ERR(dl_priv->usb_rx_fault_reporter)) {
+		ret = PTR_ERR(dl_priv->usb_rx_fault_reporter);
+		goto create_error;
+	}
+
+	dl_priv->usb_tx_fault_reporter =
+		devlink_health_reporter_create(devlink,
+					       &usbnet_usb_tx_fault_reporter_ops,
+					       0, dl_priv);
+	if (IS_ERR(dl_priv->usb_tx_fault_reporter)) {
+		ret = PTR_ERR(dl_priv->usb_tx_fault_reporter);
+		goto destroy_usb_rx;
+	}
+
+	dl_priv->usb_ctrl_fault_reporter =
+		devlink_health_reporter_create(devlink,
+					       &usbnet_usb_ctrl_fault_reporter_ops,
+					       0, dl_priv);
+	if (IS_ERR(dl_priv->usb_ctrl_fault_reporter)) {
+		ret = PTR_ERR(dl_priv->usb_ctrl_fault_reporter);
+		goto destroy_usb_tx;
+	}
+
+	dl_priv->usb_intr_fault_reporter =
+		devlink_health_reporter_create(devlink,
+					       &usbnet_usb_intr_fault_reporter_ops,
+					       0, dl_priv);
+	if (IS_ERR(dl_priv->usb_intr_fault_reporter)) {
+		ret = PTR_ERR(dl_priv->usb_tx_fault_reporter);
+		goto destroy_usb_ctrl;
+	}
+
+	return 0;
+
+destroy_usb_ctrl:
+	devlink_health_reporter_destroy(dl_priv->usb_ctrl_fault_reporter);
+destroy_usb_tx:
+	devlink_health_reporter_destroy(dl_priv->usb_tx_fault_reporter);
+destroy_usb_rx:
+	devlink_health_reporter_destroy(dl_priv->usb_rx_fault_reporter);
+create_error:
+	netif_err(usbnet, probe, usbnet->net,
+		  "Failed to register health reporters. %pe\n", ERR_PTR(ret));
+
+	return ret;
+}
+
+static int usbnet_devlink_info_get(struct devlink *devlink,
+				 struct devlink_info_req *req,
+				 struct netlink_ext_ack *extack)
+{
+	struct usbnet *usbnet = usbnet_from_devlink(devlink);
+	char buf[10];
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	scnprintf(buf, 10, "%d.%d", 100, 200);
+	err = devlink_info_version_running_put(req, usbnet->driver_name, buf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops usbnet_devlink_ops = {
+	.info_get = usbnet_devlink_info_get,
+};
+
+static int usbnet_devlink_port_add(struct devlink *devlink)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(devlink);
+	struct usbnet *usbnet = usbnet_from_devlink(devlink);
+	struct devlink_port *devlink_port = &dl_priv->devlink_port;
+	struct devlink_port_attrs attrs = {};
+	int err;
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	devlink_port_attrs_set(devlink_port, &attrs);
+
+	err = devlink_port_register(usbnet->devlink, devlink_port, 0);
+	if (err)
+		return err;
+
+	devlink_port_type_eth_set(devlink_port, usbnet->net);
+
+	return 0;
+}
+
+int usbnet_devlink_alloc(struct usbnet *usbnet)
+{
+	struct net_device *net = usbnet->net;
+	struct device *dev = net->dev.parent;
+	struct usbnet_devlink_priv *dl_priv;
+	int ret;
+
+	usbnet->devlink =
+		devlink_alloc(&usbnet_devlink_ops, sizeof(*dl_priv), dev);
+	if (!usbnet->devlink) {
+		netif_err(usbnet, probe, usbnet->net, "devlink_alloc failed\n");
+		return -ENOMEM;
+	}
+	dl_priv = devlink_priv(usbnet->devlink);
+	dl_priv->usbnet = usbnet;
+
+	ret = usbnet_devlink_port_add(usbnet->devlink);
+	if (ret)
+		goto free_devlink;
+
+	ret = usbnet_health_reporters_create(usbnet->devlink);
+	if (ret)
+		goto free_port;
+
+	return 0;
+
+free_port:
+	devlink_port_type_clear(&dl_priv->devlink_port);
+	devlink_port_unregister(&dl_priv->devlink_port);
+free_devlink:
+	devlink_free(usbnet->devlink);
+
+	return ret;
+}
+
+void usbnet_devlink_free(struct usbnet *usbnet)
+{
+	struct usbnet_devlink_priv *dl_priv = devlink_priv(usbnet->devlink);
+	struct devlink_port *devlink_port = &dl_priv->devlink_port;
+
+	devlink_health_reporter_destroy(dl_priv->usb_rx_fault_reporter);
+	devlink_health_reporter_destroy(dl_priv->usb_tx_fault_reporter);
+	devlink_health_reporter_destroy(dl_priv->usb_ctrl_fault_reporter);
+	devlink_health_reporter_destroy(dl_priv->usb_intr_fault_reporter);
+
+	devlink_port_type_clear(devlink_port);
+	devlink_port_unregister(devlink_port);
+
+	devlink_free(usbnet->devlink);
+}
+
+void usbnet_devlink_register(struct usbnet *usbnet)
+{
+	devlink_register(usbnet->devlink);
+}
+
+void usbnet_devlink_unregister(struct usbnet *usbnet)
+{
+	devlink_unregister(usbnet->devlink);
+}
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 3fdca0cfda88..5e20b42c9b99 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -207,14 +207,18 @@ static void intr_complete (struct urb *urb)
 	 * already polls infrequently
 	 */
 	default:
+		usbnet_usb_intr_health_report(dev, "intr_complete err:", status);
 		netdev_dbg(dev->net, "intr status %d\n", status);
 		break;
 	}
 
 	status = usb_submit_urb (urb, GFP_ATOMIC);
-	if (status != 0)
+	if (status != 0) {
+		usbnet_usb_intr_health_report(dev, "intr_complete resubmit err:",
+					      status);
 		netif_err(dev, timer, dev->net,
 			  "intr resubmit --> %d\n", status);
+	}
 }
 
 static int init_status (struct usbnet *dev, struct usb_interface *intf)
@@ -269,6 +273,10 @@ int usbnet_status_start(struct usbnet *dev, gfp_t mem_flags)
 		dev_dbg(&dev->udev->dev, "incremented interrupt URB count to %d\n",
 			dev->interrupt_count);
 		mutex_unlock(&dev->interrupt_mutex);
+
+		if (ret < 0)
+			usbnet_usb_intr_health_report(dev, "status start err:",
+						      ret);
 	}
 	return ret;
 }
@@ -284,6 +292,9 @@ static int __usbnet_status_start_force(struct usbnet *dev, gfp_t mem_flags)
 		ret = usb_submit_urb(dev->interrupt, mem_flags);
 		dev_dbg(&dev->udev->dev,
 			"submitted interrupt URB for resume\n");
+		if (ret < 0)
+			usbnet_usb_intr_health_report(dev, "status start force err:",
+						      ret);
 	}
 	mutex_unlock(&dev->interrupt_mutex);
 	return ret;
@@ -522,7 +533,12 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 	    test_bit(EVENT_DEV_OPEN, &dev->flags) &&
 	    !test_bit (EVENT_RX_HALT, &dev->flags) &&
 	    !test_bit (EVENT_DEV_ASLEEP, &dev->flags)) {
-		switch (retval = usb_submit_urb (urb, GFP_ATOMIC)) {
+		retval = usb_submit_urb (urb, GFP_ATOMIC);
+		if (retval < 0)
+			usbnet_usb_rx_health_report(dev, "rx_submit err:",
+						    retval);
+
+		switch (retval) {
 		case -EPIPE:
 			usbnet_defer_kevent (dev, EVENT_RX_HALT);
 			break;
@@ -612,6 +628,7 @@ static void rx_complete (struct urb *urb)
 	 * storm, recovering as needed.
 	 */
 	case -EPIPE:
+		usbnet_usb_rx_health_report(dev, "rx_complete err:", urb_status);
 		dev->net->stats.rx_errors++;
 		usbnet_defer_kevent (dev, EVENT_RX_HALT);
 		fallthrough;
@@ -630,6 +647,7 @@ static void rx_complete (struct urb *urb)
 	case -EPROTO:
 	case -ETIME:
 	case -EILSEQ:
+		usbnet_usb_rx_health_report(dev, "rx_complete err:", urb_status);
 		dev->net->stats.rx_errors++;
 		if (!timer_pending (&dev->delay)) {
 			mod_timer (&dev->delay, jiffies + THROTTLE_JIFFIES);
@@ -1253,8 +1271,9 @@ static void tx_complete (struct urb *urb)
 	struct sk_buff		*skb = (struct sk_buff *) urb->context;
 	struct skb_data		*entry = (struct skb_data *) skb->cb;
 	struct usbnet		*dev = entry->dev;
+	int status = urb->status;
 
-	if (urb->status == 0) {
+	if (status == 0) {
 		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
 		unsigned long flags;
 
@@ -1265,7 +1284,10 @@ static void tx_complete (struct urb *urb)
 	} else {
 		dev->net->stats.tx_errors++;
 
-		switch (urb->status) {
+		usbnet_usb_tx_health_report(dev, "tx_complete err:",
+					    status);
+
+		switch (status) {
 		case -EPIPE:
 			usbnet_defer_kevent (dev, EVENT_TX_HALT);
 			break;
@@ -1286,7 +1308,7 @@ static void tx_complete (struct urb *urb)
 				mod_timer (&dev->delay,
 					jiffies + THROTTLE_JIFFIES);
 				netif_dbg(dev, link, dev->net,
-					  "tx throttle %d\n", urb->status);
+					  "tx throttle %d\n", status);
 			}
 			netif_stop_queue (dev->net);
 			break;
@@ -1458,7 +1480,12 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	}
 #endif
 
-	switch ((retval = usb_submit_urb (urb, GFP_ATOMIC))) {
+	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	if (retval < 0)
+		usbnet_usb_tx_health_report(dev, "tx_submit err:",
+					    retval);
+
+	switch (retval) {
 	case -EPIPE:
 		netif_stop_queue (net);
 		usbnet_defer_kevent (dev, EVENT_TX_HALT);
@@ -1629,6 +1656,10 @@ void usbnet_disconnect (struct usb_interface *intf)
 
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
+
+	usbnet_devlink_unregister(dev);
+	usbnet_devlink_free(dev);
+
 	kfree(dev->padding_pkt);
 
 	free_percpu(net->tstats);
@@ -1742,12 +1773,18 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
 	net->ethtool_ops = &usbnet_ethtool_ops;
 
+	status = usbnet_devlink_alloc(dev);
+	if (status)
+		goto out1;
+
+	usbnet_devlink_register(dev);
+
 	// allow device-specific bind/init procedures
 	// NOTE net->name still not usable ...
 	if (info->bind) {
 		status = info->bind (dev, udev);
 		if (status < 0)
-			goto out1;
+			goto probe_free_devlink;
 
 		// heuristic:  "usb%d" for links we know are two-host,
 		// else "eth%d" when there's reasonable doubt.  userspace
@@ -1859,6 +1896,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 out3:
 	if (info->unbind)
 		info->unbind (dev, udev);
+probe_free_devlink:
+	usbnet_devlink_unregister(dev);
+	usbnet_devlink_free(dev);
 out1:
 	/* subdrivers must undo all they did in bind() if they
 	 * fail it, but we may fail later and a deferred kevent
@@ -2036,6 +2076,9 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 	}
 	kfree(buf);
 out:
+	if (err < 0)
+		usbnet_usb_ctrl_health_report(dev, "read cmd err:", err);
+
 	return err;
 }
 
@@ -2068,6 +2111,9 @@ static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 	kfree(buf);
 
 out:
+	if (err < 0)
+		usbnet_usb_ctrl_health_report(dev, "write cmd err:", err);
+
 	return err;
 }
 
@@ -2137,9 +2183,10 @@ static void usbnet_async_cmd_cb(struct urb *urb)
 	struct usb_ctrlrequest *req = (struct usb_ctrlrequest *)urb->context;
 	int status = urb->status;
 
-	if (status < 0)
+	if (status < 0) {
 		dev_dbg(&urb->dev->dev, "%s failed with %d",
 			__func__, status);
+	}
 
 	kfree(req);
 	usb_free_urb(urb);
@@ -2192,6 +2239,7 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
+		usbnet_usb_ctrl_health_report(dev, "write cmd async err:", err);
 		netdev_err(dev->net, "Error submitting the control"
 			   " message: status=%d\n", err);
 		goto fail_free;
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 8336e86ce606..4215b92545dd 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -23,6 +23,10 @@
 #ifndef	__LINUX_USB_USBNET_H
 #define	__LINUX_USB_USBNET_H
 
+#include <linux/mii.h>
+#include <linux/usb.h>
+#include <net/devlink.h>
+
 /* interface from usbnet core to each USB networking link we handle */
 struct usbnet {
 	/* housekeeping */
@@ -84,6 +88,17 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
+
+	struct devlink *devlink;
+};
+
+struct usbnet_devlink_priv {
+	struct devlink_port devlink_port;
+	struct usbnet *usbnet;
+	struct devlink_health_reporter *usb_rx_fault_reporter;
+	struct devlink_health_reporter *usb_tx_fault_reporter;
+	struct devlink_health_reporter *usb_ctrl_fault_reporter;
+	struct devlink_health_reporter *usb_intr_fault_reporter;
 };
 
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
@@ -289,4 +304,13 @@ extern void usbnet_status_stop(struct usbnet *dev);
 
 extern void usbnet_update_max_qlen(struct usbnet *dev);
 
+int usbnet_devlink_alloc(struct usbnet *dev);
+void usbnet_devlink_free(struct usbnet *dev);
+void usbnet_devlink_register(struct usbnet *dev);
+void usbnet_devlink_unregister(struct usbnet *dev);
+int usbnet_usb_tx_health_report(struct usbnet *dev, char *str, int err);
+int usbnet_usb_rx_health_report(struct usbnet *dev, char *str, int err);
+int usbnet_usb_ctrl_health_report(struct usbnet *dev, char *str, int err);
+int usbnet_usb_intr_health_report(struct usbnet *dev, char *str, int err);
+
 #endif /* __LINUX_USB_USBNET_H */
-- 
2.30.2

