Return-Path: <netdev+bounces-3121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 648EB70593C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568C71C20C38
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B30271E4;
	Tue, 16 May 2023 21:02:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315DD290EA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:02:07 +0000 (UTC)
Received: from mail-40136.proton.ch (mail-40136.proton.ch [185.70.40.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BD97681
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:02:01 -0700 (PDT)
Date: Tue, 16 May 2023 21:01:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy;
	s=protonmail2; t=1684270918; x=1684530118;
	bh=Wy31KG6+FVp34d0/XhKkgwRjsPccyKDA5Hf2WlNGVI0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=bcixOc4I7Ig46FQHq26Dt4Dkm9J9zfE7t10suY6SlR4Lm5d09ThXdoSTvF9pxVv7N
	 e8OJ6ud2OVesTJAoWP11vdCpy+Fe19iAbtt/ibNCxXlWbrQ3yoZ8CSMcj4+NcCFmnj
	 pOdNE9R3/bWOgBiHsj53AeKsm5d5g2XMU7uXRpVtTY7gj1sa9RddjrLFytzp2g4w+D
	 Eg/AhYLYsgudfZuw0joFHh/GD9bX6xG4yE6aPTKGTlxvWcdthjd/mV+5oHuKpaPSRI
	 Gmgte7hmgUBvqSnRTjcw8/7CcKliWZJdv6HiouefQuuA9pRBSBbK5BSNLlXQ0XQAEm
	 y8TLO7cVk9slw==
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
From: Foster Snowhill <forst@pen.gy>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org, Foster Snowhill <forst@pen.gy>, Georgi Valkov <gvalkov@gmail.com>
Subject: [PATCH] net: usb: ipheth: add CDC NCM support
Message-ID: <20230516210127.35841-1-forst@pen.gy>
Feedback-ID: 31160380:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
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
Georgi Valkov and I have been using this patch for one year with OpenWrt,
Linux kernel versions 5.10 and 5.15 on the following devices:

* Linksys WRT3200ACM (Marvell Armada 385, ARMv7-A LE), with iPhone 7 Plus
* Linksys EA8300 (Qualcomm IPQ4019, ARMv7-A LE), with iPhone Xs Max

Georgi also performed limited tests on

* TP-Link TL-WR1043ND (QCA9558, MIPS 74Kc BE)
* OrangePi Zero (Allwinner H2+, ARMv7-A LE)

There is an interest, specifically from Georgi, to have this patch
backported to v5.15 to then be used in OpenWrt.

Neither me nor Georgi are by any means skilled in developing for the
Linux kernel. Please review the patch carefully and advise if any
changes are needed in regards to security (e.g. data validation)
or code formatting.
---
 drivers/net/usb/ipheth.c | 186 ++++++++++++++++++++++++++++++++-------
 1 file changed, 152 insertions(+), 34 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 6a769df0b..3cdf92b39 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
+#include <linux/usb/cdc.h>
=20
 #define USB_VENDOR_APPLE        0x05ac
=20
@@ -59,8 +60,11 @@
 #define IPHETH_USBINTF_SUBCLASS 253
 #define IPHETH_USBINTF_PROTO    1
=20
-#define IPHETH_BUF_SIZE         1514
 #define IPHETH_IP_ALIGN=09=092=09/* padding at front of URB */
+#define IPHETH_NCM_HEADER_SIZE  (12 + 96) /* NCMH + NCM0 */
+#define IPHETH_TX_BUF_SIZE      ETH_FRAME_LEN
+#define IPHETH_RX_BUF_SIZE      65536
+
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
=20
 #define IPHETH_INTFNUM          2
@@ -71,6 +75,7 @@
 #define IPHETH_CTRL_TIMEOUT     (5 * HZ)
=20
 #define IPHETH_CMD_GET_MACADDR   0x00
+#define IPHETH_CMD_ENABLE_NCM    0x04
 #define IPHETH_CMD_CARRIER_CHECK 0x45
=20
 #define IPHETH_CARRIER_CHECK_TIMEOUT round_jiffies_relative(1 * HZ)
@@ -84,6 +89,8 @@ static const struct usb_device_id ipheth_table[] =3D {
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
=20
+static const char ipheth_start_packet[] =3D { 0x00, 0x01, 0x01, 0x00 };
+
 struct ipheth_device {
 =09struct usb_device *udev;
 =09struct usb_interface *intf;
@@ -97,6 +104,7 @@ struct ipheth_device {
 =09u8 bulk_out;
 =09struct delayed_work carrier_work;
 =09bool confirmed_pairing;
+=09int (*rcvbulk_callback)(struct urb *urb);
 };
=20
 static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags);
@@ -116,12 +124,12 @@ static int ipheth_alloc_urbs(struct ipheth_device *ip=
hone)
 =09if (rx_urb =3D=3D NULL)
 =09=09goto free_tx_urb;
=20
-=09tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+=09tx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_TX_BUF_SIZE,
 =09=09=09=09    GFP_KERNEL, &tx_urb->transfer_dma);
 =09if (tx_buf =3D=3D NULL)
 =09=09goto free_rx_urb;
=20
-=09rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP=
_ALIGN,
+=09rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
 =09=09=09=09    GFP_KERNEL, &rx_urb->transfer_dma);
 =09if (rx_buf =3D=3D NULL)
 =09=09goto free_tx_buf;
@@ -134,7 +142,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *ipho=
ne)
 =09return 0;
=20
 free_tx_buf:
-=09usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
+=09usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, tx_buf,
 =09=09=09  tx_urb->transfer_dma);
 free_rx_urb:
 =09usb_free_urb(rx_urb);
@@ -146,9 +154,9 @@ static int ipheth_alloc_urbs(struct ipheth_device *ipho=
ne)
=20
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-=09usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, ipho=
ne->rx_buf,
+=09usb_free_coherent(iphone->udev, IPHETH_RX_BUF_SIZE, iphone->rx_buf,
 =09=09=09  iphone->rx_urb->transfer_dma);
-=09usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
+=09usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, iphone->tx_buf,
 =09=09=09  iphone->tx_urb->transfer_dma);
 =09usb_free_urb(iphone->rx_urb);
 =09usb_free_urb(iphone->tx_urb);
@@ -160,14 +168,104 @@ static void ipheth_kill_urbs(struct ipheth_device *d=
ev)
 =09usb_kill_urb(dev->rx_urb);
 }
=20
-static void ipheth_rcvbulk_callback(struct urb *urb)
+static int ipheth_consume_skb(char *buf, int len, struct ipheth_device *de=
v)
 {
-=09struct ipheth_device *dev;
 =09struct sk_buff *skb;
-=09int status;
+
+=09skb =3D dev_alloc_skb(len);
+=09if (!skb) {
+=09=09dev->net->stats.rx_dropped++;
+=09=09return -ENOMEM;
+=09}
+
+=09skb_put_data(skb, buf, len);
+=09skb->dev =3D dev->net;
+=09skb->protocol =3D eth_type_trans(skb, dev->net);
+
+=09dev->net->stats.rx_packets++;
+=09dev->net->stats.rx_bytes +=3D len;
+=09netif_rx(skb);
+
+=09return 0;
+}
+
+static int ipheth_rcvbulk_callback_legacy(struct urb *urb)
+{
+=09struct ipheth_device *dev;
 =09char *buf;
 =09int len;
=20
+=09dev =3D urb->context;
+
+=09if (urb->actual_length <=3D IPHETH_IP_ALIGN) {
+=09=09dev->net->stats.rx_length_errors++;
+=09=09return -EINVAL;
+=09}
+=09len =3D urb->actual_length - IPHETH_IP_ALIGN;
+=09buf =3D urb->transfer_buffer + IPHETH_IP_ALIGN;
+
+=09return ipheth_consume_skb(buf, len, dev);
+}
+
+static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
+{
+=09struct ipheth_device *dev;
+=09struct usb_cdc_ncm_nth16 *ncmh;
+=09struct usb_cdc_ncm_ndp16 *ncm0;
+=09struct usb_cdc_ncm_dpe16 *dpe;
+=09char *buf;
+=09int len;
+=09int retval =3D -EINVAL;
+
+=09dev =3D urb->context;
+
+=09if (urb->actual_length < IPHETH_NCM_HEADER_SIZE) {
+=09=09dev->net->stats.rx_length_errors++;
+=09=09return retval;
+=09}
+
+=09ncmh =3D (struct usb_cdc_ncm_nth16 *)(urb->transfer_buffer);
+=09if (ncmh->dwSignature !=3D cpu_to_le32(USB_CDC_NCM_NTH16_SIGN) ||
+=09    le16_to_cpu(ncmh->wNdpIndex) >=3D urb->actual_length) {
+=09=09dev->net->stats.rx_errors++;
+=09=09return retval;
+=09}
+
+=09ncm0 =3D (struct usb_cdc_ncm_ndp16 *)(urb->transfer_buffer + le16_to_cp=
u(ncmh->wNdpIndex));
+=09if (ncm0->dwSignature !=3D cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN) ||
+=09    le16_to_cpu(ncmh->wHeaderLength) + le16_to_cpu(ncm0->wLength) >=3D =
urb->actual_length) {
+=09=09dev->net->stats.rx_errors++;
+=09=09return retval;
+=09}
+
+=09dpe =3D ncm0->dpe16;
+=09while (le16_to_cpu(dpe->wDatagramIndex) !=3D 0 &&
+=09       le16_to_cpu(dpe->wDatagramLength) !=3D 0) {
+=09=09if (le16_to_cpu(dpe->wDatagramIndex) >=3D urb->actual_length ||
+=09=09    (le16_to_cpu(dpe->wDatagramIndex) + le16_to_cpu(dpe->wDatagramLe=
ngth))
+=09=09    > urb->actual_length) {
+=09=09=09dev->net->stats.rx_length_errors++;
+=09=09=09return retval;
+=09=09}
+
+=09=09buf =3D urb->transfer_buffer + le16_to_cpu(dpe->wDatagramIndex);
+=09=09len =3D le16_to_cpu(dpe->wDatagramLength);
+
+=09=09retval =3D ipheth_consume_skb(buf, len, dev);
+=09=09if (retval !=3D 0)
+=09=09=09return retval;
+
+=09=09dpe++;
+=09}
+
+=09return 0;
+}
+
+static void ipheth_rcvbulk_callback(struct urb *urb)
+{
+=09struct ipheth_device *dev;
+=09int retval, status;
+
 =09dev =3D urb->context;
 =09if (dev =3D=3D NULL)
 =09=09return;
@@ -187,29 +285,25 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
 =09=09return;
 =09}
=20
-=09if (urb->actual_length <=3D IPHETH_IP_ALIGN) {
-=09=09dev->net->stats.rx_length_errors++;
-=09=09return;
-=09}
-=09len =3D urb->actual_length - IPHETH_IP_ALIGN;
-=09buf =3D urb->transfer_buffer + IPHETH_IP_ALIGN;
-
-=09skb =3D dev_alloc_skb(len);
-=09if (!skb) {
-=09=09dev_err(&dev->intf->dev, "%s: dev_alloc_skb: -ENOMEM\n",
-=09=09=09__func__);
-=09=09dev->net->stats.rx_dropped++;
+=09/* The very first frame we receive from device has a fixed 4-byte value
+=09 * We can safely skip it
+=09 */
+=09if (unlikely
+=09=09(urb->actual_length =3D=3D sizeof(ipheth_start_packet) &&
+=09=09 memcmp(urb->transfer_buffer, ipheth_start_packet,
+=09=09=09sizeof(ipheth_start_packet)) =3D=3D 0
+=09))
+=09=09goto rx_submit;
+
+=09retval =3D dev->rcvbulk_callback(urb);
+=09if (retval !=3D 0) {
+=09=09dev_err(&dev->intf->dev, "%s: callback retval: %d\n",
+=09=09=09__func__, retval);
 =09=09return;
 =09}
=20
-=09skb_put_data(skb, buf, len);
-=09skb->dev =3D dev->net;
-=09skb->protocol =3D eth_type_trans(skb, dev->net);
-
-=09dev->net->stats.rx_packets++;
-=09dev->net->stats.rx_bytes +=3D len;
+rx_submit:
 =09dev->confirmed_pairing =3D true;
-=09netif_rx(skb);
 =09ipheth_rx_submit(dev, GFP_ATOMIC);
 }
=20
@@ -310,6 +404,27 @@ static int ipheth_get_macaddr(struct ipheth_device *de=
v)
 =09return retval;
 }
=20
+static int ipheth_enable_ncm(struct ipheth_device *dev)
+{
+=09struct usb_device *udev =3D dev->udev;
+=09int retval;
+
+=09retval =3D usb_control_msg(udev,
+=09=09=09=09 usb_sndctrlpipe(udev, IPHETH_CTRL_ENDP),
+=09=09=09=09 IPHETH_CMD_ENABLE_NCM, /* request */
+=09=09=09=09 0x40, /* request type */
+=09=09=09=09 0x00, /* value */
+=09=09=09=09 0x02, /* index */
+=09=09=09=09 NULL,
+=09=09=09=09 0,
+=09=09=09=09 IPHETH_CTRL_TIMEOUT);
+
+=09dev_info(&dev->intf->dev, "%s: usb_control_msg: %d\n",
+=09=09 __func__, retval);
+
+=09return retval;
+}
+
 static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 {
 =09struct usb_device *udev =3D dev->udev;
@@ -317,7 +432,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, =
gfp_t mem_flags)
=20
 =09usb_fill_bulk_urb(dev->rx_urb, udev,
 =09=09=09  usb_rcvbulkpipe(udev, dev->bulk_in),
-=09=09=09  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
+=09=09=09  dev->rx_buf, IPHETH_RX_BUF_SIZE,
 =09=09=09  ipheth_rcvbulk_callback,
 =09=09=09  dev);
 =09dev->rx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
@@ -365,7 +480,7 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struc=
t net_device *net)
 =09int retval;
=20
 =09/* Paranoid */
-=09if (skb->len > IPHETH_BUF_SIZE) {
+=09if (skb->len > IPHETH_TX_BUF_SIZE) {
 =09=09WARN(1, "%s: skb too large: %d bytes\n", __func__, skb->len);
 =09=09dev->net->stats.tx_dropped++;
 =09=09dev_kfree_skb_any(skb);
@@ -373,12 +488,10 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, str=
uct net_device *net)
 =09}
=20
 =09memcpy(dev->tx_buf, skb->data, skb->len);
-=09if (skb->len < IPHETH_BUF_SIZE)
-=09=09memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
=20
 =09usb_fill_bulk_urb(dev->tx_urb, udev,
 =09=09=09  usb_sndbulkpipe(udev, dev->bulk_out),
-=09=09=09  dev->tx_buf, IPHETH_BUF_SIZE,
+=09=09=09  dev->tx_buf, skb->len,
 =09=09=09  ipheth_sndbulk_callback,
 =09=09=09  dev);
 =09dev->tx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
@@ -450,6 +563,7 @@ static int ipheth_probe(struct usb_interface *intf,
 =09dev->net =3D netdev;
 =09dev->intf =3D intf;
 =09dev->confirmed_pairing =3D false;
+=09dev->rcvbulk_callback =3D ipheth_rcvbulk_callback_legacy;
 =09/* Set up endpoints */
 =09hintf =3D usb_altnum_to_altsetting(intf, IPHETH_ALT_INTFNUM);
 =09if (hintf =3D=3D NULL) {
@@ -481,6 +595,10 @@ static int ipheth_probe(struct usb_interface *intf,
 =09if (retval)
 =09=09goto err_get_macaddr;
=20
+=09retval =3D ipheth_enable_ncm(dev);
+=09if (retval =3D=3D 0)
+=09=09dev->rcvbulk_callback =3D ipheth_rcvbulk_callback_ncm;
+
 =09INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
=20
 =09retval =3D ipheth_alloc_urbs(dev);
@@ -510,8 +628,8 @@ static int ipheth_probe(struct usb_interface *intf,
 =09ipheth_free_urbs(dev);
 err_alloc_urbs:
 err_get_macaddr:
-err_alloc_ctrl_buf:
 =09kfree(dev->ctrl_buf);
+err_alloc_ctrl_buf:
 err_endpoints:
 =09free_netdev(netdev);
 =09return retval;
--=20
2.40.1



