Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D3E13913B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgAMMqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:46:00 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:42809
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbgAMMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:46:00 -0500
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 7B5A520498;
        Mon, 13 Jan 2020 12:45:55 +0000 (UTC)
From:   Martin Schiller <ms@dev.tdt.de>
To:     khc@pm.waw.pl, davem@davemloft.net
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
Date:   Mon, 13 Jan 2020 13:45:50 +0100
Message-Id: <20200113124551.2570-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables you to configure mode (DTE/DCE), Modulo, Window, T1, T2, N2 via
sethdlc (which needs to be patched as well).

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 drivers/net/wan/hdlc_x25.c      | 67 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/hdlc/ioctl.h | 11 +++++-
 include/uapi/linux/if.h         |  1 +
 3 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 5643675ff724..b28051eba736 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -21,8 +21,17 @@
 #include <linux/skbuff.h>
 #include <net/x25device.h>
 
+struct x25_state {
+	x25_hdlc_proto settings;
+};
+
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
 
+static inline struct x25_state* state(hdlc_device *hdlc)
+{
+	return (struct x25_state *)hdlc->state;
+}
+
 /* These functions are callbacks called by LAPB layer */
 
 static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
@@ -132,6 +141,8 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 static int x25_open(struct net_device *dev)
 {
 	int result;
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct lapb_parms_struct params;
 	static const struct lapb_register_struct cb = {
 		.connect_confirmation = x25_connected,
 		.connect_indication = x25_connected,
@@ -144,6 +155,26 @@ static int x25_open(struct net_device *dev)
 	result = lapb_register(dev, &cb);
 	if (result != LAPB_OK)
 		return result;
+
+	result = lapb_getparms(dev, &params);
+	if (result != LAPB_OK)
+		return result;
+
+	if (state(hdlc)->settings.dce)
+		params.mode = params.mode | LAPB_DCE;
+
+	if (state(hdlc)->settings.modulo == 128)
+		params.mode = params.mode | LAPB_EXTENDED;
+
+	params.window = state(hdlc)->settings.window;
+	params.t1 = state(hdlc)->settings.t1;
+	params.t2 = state(hdlc)->settings.t2;
+	params.n2 = state(hdlc)->settings.n2;
+
+	result = lapb_setparms(dev, &params);
+	if (result != LAPB_OK)
+		return result;
+
 	return 0;
 }
 
@@ -186,6 +217,9 @@ static struct hdlc_proto proto = {
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 {
+	x25_hdlc_proto __user *x25_s = ifr->ifr_settings.ifs_ifsu.x25;
+	const size_t size = sizeof(x25_hdlc_proto);
+	x25_hdlc_proto new_settings;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	int result;
 
@@ -194,7 +228,13 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
 		ifr->ifr_settings.type = IF_PROTO_X25;
-		return 0; /* return protocol only, no settable parameters */
+		if (ifr->ifr_settings.size < size) {
+			ifr->ifr_settings.size = size; /* data size wanted */
+			return -ENOBUFS;
+		}
+		if (copy_to_user(x25_s, &state(hdlc)->settings, size))
+			return -EFAULT;
+		return 0;
 
 	case IF_PROTO_X25:
 		if (!capable(CAP_NET_ADMIN))
@@ -203,12 +243,35 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 
+		if (copy_from_user(&new_settings, x25_s, size))
+			return -EFAULT;
+
+		if ((new_settings.dce != 0 &&
+		     new_settings.dce != 1) ||
+		    (new_settings.modulo != 8 &&
+		     new_settings.modulo != 128) ||
+		    new_settings.window < 1 ||
+		    (new_settings.modulo == 8 &&
+		     new_settings.window > 7) ||
+		    (new_settings.modulo == 128 &&
+		     new_settings.window > 127) ||
+		    new_settings.t1 < 1 ||
+		    new_settings.t1 > 255 ||
+		    new_settings.t2 < 1 ||
+		    new_settings.t2 > 255 ||
+		    new_settings.n2 < 1 ||
+		    new_settings.n2 > 255)
+			return -EINVAL;
+
 		result=hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
 		if (result)
 			return result;
 
-		if ((result = attach_hdlc_protocol(dev, &proto, 0)))
+		if ((result = attach_hdlc_protocol(dev, &proto,
+						   sizeof(struct x25_state))))
 			return result;
+
+		memcpy(&state(hdlc)->settings, &new_settings, size);
 		dev->type = ARPHRD_X25;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdlc/ioctl.h
index 0fe4238e8246..3656ce8b8af0 100644
--- a/include/uapi/linux/hdlc/ioctl.h
+++ b/include/uapi/linux/hdlc/ioctl.h
@@ -3,7 +3,7 @@
 #define __HDLC_IOCTL_H__
 
 
-#define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc utility */
+#define GENERIC_HDLC_VERSION 5	/* For synchronization with sethdlc utility */
 
 #define CLOCK_DEFAULT   0	/* Default setting */
 #define CLOCK_EXT	1	/* External TX and RX clock - DTE */
@@ -79,6 +79,15 @@ typedef struct {
     unsigned int timeout;
 } cisco_proto;
 
+typedef struct {
+	unsigned short dce; /* 1 for DCE (network side) operation */
+	unsigned int modulo; /* modulo (8 = basic / 128 = extended) */
+	unsigned int window; /* frame window size */
+	unsigned int t1; /* timeout t1 */
+	unsigned int t2; /* timeout t2 */
+	unsigned int n2; /* frame retry counter */
+} x25_hdlc_proto;
+
 /* PPP doesn't need any info now - supply length = 0 to ioctl */
 
 #endif /* __ASSEMBLY__ */
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 4bf33344aab1..be714cd8c826 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -213,6 +213,7 @@ struct if_settings {
 		fr_proto		__user *fr;
 		fr_proto_pvc		__user *fr_pvc;
 		fr_proto_pvc_info	__user *fr_pvc_info;
+		x25_hdlc_proto		__user *x25;
 
 		/* interface settings */
 		sync_serial_settings	__user *sync;
-- 
2.20.1

