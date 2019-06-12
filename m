Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E925442CFE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438300AbfFLRHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:07:48 -0400
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:18413 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438279AbfFLRHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:07:47 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2019 13:07:47 EDT
Received: from vsmx003.vodafonemail.xion.oxcs.net (unknown [192.168.75.197])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id 545DD3E04E0;
        Wed, 12 Jun 2019 17:02:33 +0000 (UTC)
Received: from arcor.de (unknown [2.247.255.147])
        by mta-7-out.mta.xion.oxcs.net (Postfix) with ESMTPA id D989630025D;
        Wed, 12 Jun 2019 17:02:22 +0000 (UTC)
Date:   Wed, 12 Jun 2019 19:02:13 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: [PATCH 1/4] qmi_wwan: add support for QMAP padding in the RX path
Message-ID: <23e6f9adb545bf29a6dd13aa920b94d70ea548c0.1560287477.git.rspmn@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QMAP code in the qmi_wwan driver is based on the CodeAurora GobiNet
driver which does not process QMAP padding in the RX path correctly.
Add support for QMAP padding to qmimux_rx_fixup() according to the
description of the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 drivers/net/usb/qmi_wwan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d9a6699abe59..fd3d078a1923 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -153,7 +153,7 @@ static bool qmimux_has_slaves(struct usbnet *dev)
 
 static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
-	unsigned int len, offset = 0;
+	unsigned int len, offset = 0, pad_len, pkt_len;
 	struct qmimux_hdr *hdr;
 	struct net_device *net;
 	struct sk_buff *skbn;
@@ -171,10 +171,16 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		if (hdr->pad & 0x80)
 			goto skip;
 
+		/* extract padding length and check for valid length info */
+		pad_len = hdr->pad & 0x3f;
+		if (len == 0 || pad_len >= len)
+			goto skip;
+		pkt_len = len - pad_len;
+
 		net = qmimux_find_dev(dev, hdr->mux_id);
 		if (!net)
 			goto skip;
-		skbn = netdev_alloc_skb(net, len);
+		skbn = netdev_alloc_skb(net, pkt_len);
 		if (!skbn)
 			return 0;
 		skbn->dev = net;
@@ -191,7 +197,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			goto skip;
 		}
 
-		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, len);
+		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
 		if (netif_rx(skbn) != NET_RX_SUCCESS)
 			return 0;
 
-- 
2.11.0

