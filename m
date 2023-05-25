Return-Path: <netdev+bounces-5470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6492A71179D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AFCB2815EA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC97C24147;
	Thu, 25 May 2023 19:49:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFEAFC05
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 19:49:43 +0000 (UTC)
X-Greylist: delayed 297 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 12:49:38 PDT
Received: from st43p00im-ztfb10063301.me.com (st43p00im-ztfb10063301.me.com [17.58.63.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23353183
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy; s=sig1;
	t=1685043809; bh=fdpV1BOWUhzFVyxuRcEvxni/QzZ+ln6nzdFaQXEZp/k=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=TAfAJXWG7SJ4O4YGemZPDMeMSuDEPJ3BUv2u8fDcnmnC3ubDIqOI6C3SRhaoO1/2q
	 goDiP9KluWKooGAGgDaGAdvXaJ8Vg1uoduFnJIJ18fbXqD3nzPA+FNNXzeTsP/OuST
	 XD3BN7ZXH5emd2Qy21wfqFZZRHMKJOd78Ptlxyi6DoCArAAoR0yL5XkVKyqQT7Mefj
	 lg95kWhtk/InIkRyJW+dfFe+O+LeB1tDeA9El9aAXlFgKreYI7edFij3RkpRudIE47
	 Ks6r6qj47PT1BgD7dd5lG9kZSj9bhubPp/x07eouP/TyQjIhJpyC8p+IfJC+ZS3xcf
	 ENdfORC9fxe3A==
Received: from Eagle.se1.pen.gy (st43p00im-dlb-asmtp-mailmevip.me.com [17.42.251.41])
	by st43p00im-ztfb10063301.me.com (Postfix) with ESMTPSA id 7932F70043F;
	Thu, 25 May 2023 19:43:27 +0000 (UTC)
From: Foster Snowhill <forst@pen.gy>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Georgi Valkov <gvalkov@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] usbnet: ipheth: add CDC NCM support
Date: Thu, 25 May 2023 21:42:55 +0200
Message-Id: <20230525194255.4516-2-forst@pen.gy>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525194255.4516-1-forst@pen.gy>
References: <20230525194255.4516-1-forst@pen.gy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: aAa-133HLRdmitGFuzXp98aBLejaXN4v
X-Proofpoint-GUID: aAa-133HLRdmitGFuzXp98aBLejaXN4v
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.573,18.0.957,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2023-05-18=5F15:2023-05-17=5F02,2023-05-18=5F15,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=1030 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2305250166
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Recent iOS releases support CDC NCM encapsulation on RX. This mode is
the default on macOS and Windows. In this mode, an iOS device may include
one or more Ethernet frames inside a single URB.

Freshly booted iOS devices start in legacy mode, but are put into
NCM mode by the official Apple driver. When reconnecting such a device
from a macOS/Windows machine to a Linux host, the device stays in
NCM mode, making it unusable with the legacy ipheth driver code.

To correctly support such a device, the driver has to either support
the NCM mode too, or put the device back into legacy mode.

To match the behaviour of the macOS/Windows driver, and since there
is no documented control command to revert to legacy mode, implement
NCM support. The device is attempted to be put into NCM mode by default,
and falls back to legacy mode if the attempt fails.

Signed-off-by: Foster Snowhill <forst@pen.gy>
Tested-by: Georgi Valkov <gvalkov@gmail.com>
---
v2:
  - Fix code formatting (RCS, 80 col width, remove redundant type casts)
  - Drop an unrelated goto label-related hunk from this patch
v1: https://lore.kernel.org/netdev/20230516210127.35841-1-forst@pen.gy/

v2 tested by me on net-next, amd64, Ubuntu 23.04, iPhone Xs Max, iOS 16.5.

There is an interest, specifically from Georgi, to have this patch
backported to v5.15 to then be used in OpenWrt.

Neither me nor Georgi are by any means skilled in developing for the
Linux kernel. Please review the patch carefully and advise if any
changes are needed in regards to security (e.g. data validation)
or code formatting.
---
 drivers/net/usb/ipheth.c | 185 ++++++++++++++++++++++++++++++++-------
 1 file changed, 152 insertions(+), 33 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 8875a3d0e..6677ac700 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
+#include <linux/usb/cdc.h>
 
 #define USB_VENDOR_APPLE        0x05ac
 
@@ -59,8 +60,11 @@
 #define IPHETH_USBINTF_SUBCLASS 253
 #define IPHETH_USBINTF_PROTO    1
 
-#define IPHETH_BUF_SIZE         1514
 #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
+#define IPHETH_NCM_HEADER_SIZE  (12 + 96) /* NCMH + NCM0 */
+#define IPHETH_TX_BUF_SIZE      ETH_FRAME_LEN
+#define IPHETH_RX_BUF_SIZE      65536
+
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 
 #define IPHETH_INTFNUM          2
@@ -71,6 +75,7 @@
 #define IPHETH_CTRL_TIMEOUT     (5 * HZ)
 
 #define IPHETH_CMD_GET_MACADDR   0x00
+#define IPHETH_CMD_ENABLE_NCM    0x04
 #define IPHETH_CMD_CARRIER_CHECK 0x45
 
 #define IPHETH_CARRIER_CHECK_TIMEOUT round_jiffies_relative(1 * HZ)
@@ -84,6 +89,8 @@ static const struct usb_device_id ipheth_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
 
+static const char ipheth_start_packet[] = { 0x00, 0x01, 0x01, 0x00 };
+
 struct ipheth_device {
 	struct usb_device *udev;
 	struct usb_interface *intf;
@@ -97,6 +104,7 @@ struct ipheth_device {
 	u8 bulk_out;
 	struct delayed_work carrier_work;
 	bool confirmed_pairing;
+	int (*rcvbulk_callback)(struct urb *urb);
 };
 
 static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags);
@@ -116,12 +124,12 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (rx_urb == NULL)
 		goto free_tx_urb;
 
-	tx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	tx_buf = usb_alloc_coherent(iphone->udev, IPHETH_TX_BUF_SIZE,
 				    GFP_KERNEL, &tx_urb->transfer_dma);
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -134,7 +142,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	return 0;
 
 free_tx_buf:
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, tx_buf,
 			  tx_urb->transfer_dma);
 free_rx_urb:
 	usb_free_urb(rx_urb);
@@ -146,9 +154,9 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_RX_BUF_SIZE, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
 	usb_free_urb(iphone->rx_urb);
 	usb_free_urb(iphone->tx_urb);
@@ -160,14 +168,105 @@ static void ipheth_kill_urbs(struct ipheth_device *dev)
 	usb_kill_urb(dev->rx_urb);
 }
 
-static void ipheth_rcvbulk_callback(struct urb *urb)
+static int ipheth_consume_skb(char *buf, int len, struct ipheth_device *dev)
 {
-	struct ipheth_device *dev;
 	struct sk_buff *skb;
-	int status;
+
+	skb = dev_alloc_skb(len);
+	if (!skb) {
+		dev->net->stats.rx_dropped++;
+		return -ENOMEM;
+	}
+
+	skb_put_data(skb, buf, len);
+	skb->dev = dev->net;
+	skb->protocol = eth_type_trans(skb, dev->net);
+
+	dev->net->stats.rx_packets++;
+	dev->net->stats.rx_bytes += len;
+	netif_rx(skb);
+
+	return 0;
+}
+
+static int ipheth_rcvbulk_callback_legacy(struct urb *urb)
+{
+	struct ipheth_device *dev;
 	char *buf;
 	int len;
 
+	dev = urb->context;
+
+	if (urb->actual_length <= IPHETH_IP_ALIGN) {
+		dev->net->stats.rx_length_errors++;
+		return -EINVAL;
+	}
+	len = urb->actual_length - IPHETH_IP_ALIGN;
+	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
+
+	return ipheth_consume_skb(buf, len, dev);
+}
+
+static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
+{
+	struct usb_cdc_ncm_nth16 *ncmh;
+	struct usb_cdc_ncm_ndp16 *ncm0;
+	struct usb_cdc_ncm_dpe16 *dpe;
+	struct ipheth_device *dev;
+	int retval = -EINVAL;
+	char *buf;
+	int len;
+
+	dev = urb->context;
+
+	if (urb->actual_length < IPHETH_NCM_HEADER_SIZE) {
+		dev->net->stats.rx_length_errors++;
+		return retval;
+	}
+
+	ncmh = urb->transfer_buffer;
+	if (ncmh->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN) ||
+	    le16_to_cpu(ncmh->wNdpIndex) >= urb->actual_length) {
+		dev->net->stats.rx_errors++;
+		return retval;
+	}
+
+	ncm0 = urb->transfer_buffer + le16_to_cpu(ncmh->wNdpIndex);
+	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN) ||
+	    le16_to_cpu(ncmh->wHeaderLength) + le16_to_cpu(ncm0->wLength) >=
+	    urb->actual_length) {
+		dev->net->stats.rx_errors++;
+		return retval;
+	}
+
+	dpe = ncm0->dpe16;
+	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
+	       le16_to_cpu(dpe->wDatagramLength) != 0) {
+		if (le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
+		    le16_to_cpu(dpe->wDatagramIndex) +
+		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length) {
+			dev->net->stats.rx_length_errors++;
+			return retval;
+		}
+
+		buf = urb->transfer_buffer + le16_to_cpu(dpe->wDatagramIndex);
+		len = le16_to_cpu(dpe->wDatagramLength);
+
+		retval = ipheth_consume_skb(buf, len, dev);
+		if (retval != 0)
+			return retval;
+
+		dpe++;
+	}
+
+	return 0;
+}
+
+static void ipheth_rcvbulk_callback(struct urb *urb)
+{
+	struct ipheth_device *dev;
+	int retval, status;
+
 	dev = urb->context;
 	if (dev == NULL)
 		return;
@@ -187,29 +286,25 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
 		return;
 	}
 
-	if (urb->actual_length <= IPHETH_IP_ALIGN) {
-		dev->net->stats.rx_length_errors++;
-		return;
-	}
-	len = urb->actual_length - IPHETH_IP_ALIGN;
-	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
-
-	skb = dev_alloc_skb(len);
-	if (!skb) {
-		dev_err(&dev->intf->dev, "%s: dev_alloc_skb: -ENOMEM\n",
-			__func__);
-		dev->net->stats.rx_dropped++;
+	/* The very first frame we receive from device has a fixed 4-byte value
+	 * We can safely skip it
+	 */
+	if (unlikely
+		(urb->actual_length == sizeof(ipheth_start_packet) &&
+		 memcmp(urb->transfer_buffer, ipheth_start_packet,
+			sizeof(ipheth_start_packet)) == 0
+	))
+		goto rx_submit;
+
+	retval = dev->rcvbulk_callback(urb);
+	if (retval != 0) {
+		dev_err(&dev->intf->dev, "%s: callback retval: %d\n",
+			__func__, retval);
 		return;
 	}
 
-	skb_put_data(skb, buf, len);
-	skb->dev = dev->net;
-	skb->protocol = eth_type_trans(skb, dev->net);
-
-	dev->net->stats.rx_packets++;
-	dev->net->stats.rx_bytes += len;
+rx_submit:
 	dev->confirmed_pairing = true;
-	netif_rx(skb);
 	ipheth_rx_submit(dev, GFP_ATOMIC);
 }
 
@@ -310,6 +405,27 @@ static int ipheth_get_macaddr(struct ipheth_device *dev)
 	return retval;
 }
 
+static int ipheth_enable_ncm(struct ipheth_device *dev)
+{
+	struct usb_device *udev = dev->udev;
+	int retval;
+
+	retval = usb_control_msg(udev,
+				 usb_sndctrlpipe(udev, IPHETH_CTRL_ENDP),
+				 IPHETH_CMD_ENABLE_NCM, /* request */
+				 0x40, /* request type */
+				 0x00, /* value */
+				 0x02, /* index */
+				 NULL,
+				 0,
+				 IPHETH_CTRL_TIMEOUT);
+
+	dev_info(&dev->intf->dev, "%s: usb_control_msg: %d\n",
+		 __func__, retval);
+
+	return retval;
+}
+
 static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 {
 	struct usb_device *udev = dev->udev;
@@ -317,7 +433,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
+			  dev->rx_buf, IPHETH_RX_BUF_SIZE,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -365,7 +481,7 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct net_device *net)
 	int retval;
 
 	/* Paranoid */
-	if (skb->len > IPHETH_BUF_SIZE) {
+	if (skb->len > IPHETH_TX_BUF_SIZE) {
 		WARN(1, "%s: skb too large: %d bytes\n", __func__, skb->len);
 		dev->net->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
@@ -373,12 +489,10 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct net_device *net)
 	}
 
 	memcpy(dev->tx_buf, skb->data, skb->len);
-	if (skb->len < IPHETH_BUF_SIZE)
-		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
 
 	usb_fill_bulk_urb(dev->tx_urb, udev,
 			  usb_sndbulkpipe(udev, dev->bulk_out),
-			  dev->tx_buf, IPHETH_BUF_SIZE,
+			  dev->tx_buf, skb->len,
 			  ipheth_sndbulk_callback,
 			  dev);
 	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -450,6 +564,7 @@ static int ipheth_probe(struct usb_interface *intf,
 	dev->net = netdev;
 	dev->intf = intf;
 	dev->confirmed_pairing = false;
+	dev->rcvbulk_callback = ipheth_rcvbulk_callback_legacy;
 	/* Set up endpoints */
 	hintf = usb_altnum_to_altsetting(intf, IPHETH_ALT_INTFNUM);
 	if (hintf == NULL) {
@@ -481,6 +596,10 @@ static int ipheth_probe(struct usb_interface *intf,
 	if (retval)
 		goto err_get_macaddr;
 
+	retval = ipheth_enable_ncm(dev);
+	if (!retval)
+		dev->rcvbulk_callback = ipheth_rcvbulk_callback_ncm;
+
 	INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
 
 	retval = ipheth_alloc_urbs(dev);
-- 
2.40.1


