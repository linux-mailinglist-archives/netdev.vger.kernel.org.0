Return-Path: <netdev+bounces-8869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 656B172625A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B461D1C2080C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F237370DA;
	Wed,  7 Jun 2023 14:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25332370CF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:07:59 +0000 (UTC)
Received: from qs51p00im-qukt01071502.me.com (qs51p00im-qukt01071502.me.com [17.57.155.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39BE269D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy; s=sig1;
	t=1686146268; bh=p3sJVnJHa0UyFmXar8QowIz60JxwrC0mLM1V8ijANqI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UvZSeMBlvVn2L56HjQq/0NrN3A6DYsJEk61MOLWf0MZWDxnSE6JTXHVGN4dD3Vf0D
	 CsfkeU90Qx24Gw8EZMNJZKbaghhC0QEuqeEdg7jEVsokce/tfXFV8tMlDmknrzGtRb
	 9x5AaxmhsW9m66S4WZp6IqaHITw7+VXBzjIoDlAKYi0lbXhFEnv0lY4eosk/6YqUPu
	 SilAPjVME8o8BjjOXW/v9cvVhZXIOVsg7eiq2Dx/MobzaIfjQJbx32rgxLyxste6CG
	 3RXa5bcNUyJuMg4ReLLHolQqiXpXNSTDiSlu194/MGACOLBDukUqyh10uu2EkVx5FI
	 hvk2H6obXTujw==
Received: from fossa.iopsys.eu (qs51p00im-dlb-asmtp-mailmevip.me.com [17.57.155.28])
	by qs51p00im-qukt01071502.me.com (Postfix) with ESMTPSA id 5C4DD668040F;
	Wed,  7 Jun 2023 13:57:46 +0000 (UTC)
From: Foster Snowhill <forst@pen.gy>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Georgi Valkov <gvalkov@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v4 3/4] usbnet: ipheth: add CDC NCM support
Date: Wed,  7 Jun 2023 15:57:01 +0200
Message-Id: <20230607135702.32679-3-forst@pen.gy>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607135702.32679-1-forst@pen.gy>
References: <20230607135702.32679-1-forst@pen.gy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: avpw1YTM4aEym46RHfJZmtckNU-QM56N
X-Proofpoint-GUID: avpw1YTM4aEym46RHfJZmtckNU-QM56N
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F02:2020-02-14=5F02,2022-01-12=5F02,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1030 suspectscore=0 malwarescore=0 mlxlogscore=933 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2306070117
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
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
v4:
  - Set RX buffer size depending on encapsulation mode (legacy vs NCM)
  - Drop control frame URBs starting with 0x00 0x01
  - Fix bmRequestType for NCM enablement to match macOS driver
  - Factor out removing TX URB padding into a separate patch
v3: https://lore.kernel.org/netdev/20230527130309.34090-2-forst@pen.gy/
  No changes
v2: https://lore.kernel.org/netdev/20230525194255.4516-2-forst@pen.gy/
  - Fix code formatting (RCS, 80 col width, remove redundant type casts)
  - Drop an unrelated goto label-related hunk from this patch
v1: https://lore.kernel.org/netdev/20230516210127.35841-1-forst@pen.gy/
---
 drivers/net/usb/ipheth.c | 180 +++++++++++++++++++++++++++++++++------
 1 file changed, 155 insertions(+), 25 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index dd809e247..687d70cfc 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
+#include <linux/usb/cdc.h>
 
 #define USB_VENDOR_APPLE        0x05ac
 
@@ -59,8 +60,12 @@
 #define IPHETH_USBINTF_SUBCLASS 253
 #define IPHETH_USBINTF_PROTO    1
 
-#define IPHETH_BUF_SIZE         1514
 #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
+#define IPHETH_NCM_HEADER_SIZE  (12 + 96) /* NCMH + NCM0 */
+#define IPHETH_TX_BUF_SIZE      ETH_FRAME_LEN
+#define IPHETH_RX_BUF_SIZE_LEGACY (IPHETH_IP_ALIGN + ETH_FRAME_LEN)
+#define IPHETH_RX_BUF_SIZE_NCM	65536
+
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 
 #define IPHETH_INTFNUM          2
@@ -71,6 +76,7 @@
 #define IPHETH_CTRL_TIMEOUT     (5 * HZ)
 
 #define IPHETH_CMD_GET_MACADDR   0x00
+#define IPHETH_CMD_ENABLE_NCM    0x04
 #define IPHETH_CMD_CARRIER_CHECK 0x45
 
 #define IPHETH_CARRIER_CHECK_TIMEOUT round_jiffies_relative(1 * HZ)
@@ -97,6 +103,8 @@ struct ipheth_device {
 	u8 bulk_out;
 	struct delayed_work carrier_work;
 	bool confirmed_pairing;
+	int (*rcvbulk_callback)(struct urb *urb);
+	size_t rx_buf_len;
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
+	rx_buf = usb_alloc_coherent(iphone->udev, iphone->rx_buf_len,
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
+	usb_free_coherent(iphone->udev, iphone->rx_buf_len, iphone->rx_buf,
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
@@ -191,25 +290,27 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
 		dev->net->stats.rx_length_errors++;
 		return;
 	}
-	len = urb->actual_length - IPHETH_IP_ALIGN;
-	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
 
-	skb = dev_alloc_skb(len);
-	if (!skb) {
-		dev_err(&dev->intf->dev, "%s: dev_alloc_skb: -ENOMEM\n",
-			__func__);
-		dev->net->stats.rx_dropped++;
+	/* RX URBs starting with 0x00 0x01 do not encapsulate Ethernet frames,
+	 * but rather are control frames. Their purpose is not documented, and
+	 * they don't affect driver functionality, okay to drop them.
+	 * There is usually just one 4-byte control frame as the very first
+	 * URB received from the bulk IN endpoint.
+	 */
+	if (unlikely
+		(((char *)urb->transfer_buffer)[0] == 0 &&
+		 ((char *)urb->transfer_buffer)[1] == 1))
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
 
@@ -310,6 +411,27 @@ static int ipheth_get_macaddr(struct ipheth_device *dev)
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
+				 0x41, /* request type */
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
@@ -317,7 +439,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
+			  dev->rx_buf, dev->rx_buf_len,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -365,7 +487,7 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct net_device *net)
 	int retval;
 
 	/* Paranoid */
-	if (skb->len > IPHETH_BUF_SIZE) {
+	if (skb->len > IPHETH_TX_BUF_SIZE) {
 		WARN(1, "%s: skb too large: %d bytes\n", __func__, skb->len);
 		dev->net->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
@@ -448,6 +570,8 @@ static int ipheth_probe(struct usb_interface *intf,
 	dev->net = netdev;
 	dev->intf = intf;
 	dev->confirmed_pairing = false;
+	dev->rx_buf_len = IPHETH_RX_BUF_SIZE_LEGACY;
+	dev->rcvbulk_callback = ipheth_rcvbulk_callback_legacy;
 	/* Set up endpoints */
 	hintf = usb_altnum_to_altsetting(intf, IPHETH_ALT_INTFNUM);
 	if (hintf == NULL) {
@@ -479,6 +603,12 @@ static int ipheth_probe(struct usb_interface *intf,
 	if (retval)
 		goto err_get_macaddr;
 
+	retval = ipheth_enable_ncm(dev);
+	if (!retval) {
+		dev->rx_buf_len = IPHETH_RX_BUF_SIZE_NCM;
+		dev->rcvbulk_callback = ipheth_rcvbulk_callback_ncm;
+	}
+
 	INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
 
 	retval = ipheth_alloc_urbs(dev);
-- 
2.40.1


