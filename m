Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F68575FB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfF0Ae1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbfF0Ae0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:26 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 269622183F;
        Thu, 27 Jun 2019 00:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595665;
        bh=GVTh7Cz9Q+YKxrkJKHIJy/O/ZUcor4umK5FQrN5KMnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAUM8KUJo8WNNyP1HmNEXIiFojXhDkFnUEx4iERDvBynN1RRH/nroOk4qgh9VVn/u
         UL5YnbIt3xVybego6ns5EFDDIeq+Be5mX3+Si7yacAUarUq6mkMfY0BtW2lYe5QNG6
         ZgwoVfsDXouXs/Jcat7v9LnKUp8LjOA89sdUBnWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinhard Speyerer <rspmn@arcor.de>,
        Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 72/95] qmi_wwan: add support for QMAP padding in the RX path
Date:   Wed, 26 Jun 2019 20:29:57 -0400
Message-Id: <20190627003021.19867-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 61356088ace1866a847a727d4d40da7bf00b67fc ]

The QMAP code in the qmi_wwan driver is based on the CodeAurora GobiNet
driver which does not process QMAP padding in the RX path correctly.
Add support for QMAP padding to qmimux_rx_fixup() according to the
description of the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1

