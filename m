Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D903F6950
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhHXS6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:08 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:34205 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230500AbhHXS6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:07 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 2D1F232254C;
        Tue, 24 Aug 2021 18:57:22 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-16-112.trex-nlb.outbound.svc.cluster.local [100.96.16.112])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 5BAA23211D8;
        Tue, 24 Aug 2021 18:57:20 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.16.112 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:21 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Abaft-Glossy: 7151e3f12471715c_1629831441731_2511376046
X-MC-Loop-Signature: 1629831441731:688725568
X-MC-Ingress-Time: 1629831441731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LqDZhnFUkByfiwr/bqkMIBICq8f+qNa1/xCNI8REbDo=; b=U6AAHPAG7ar6i0jbPiuJp1/mAV
        lfAxWA7iDjOh6DiurxKCIft8QjCp6nQSRbBrg/0I/1CYw9Vhr+vzpk4Fb5gVeLWEKZbXkB+KM7Gs3
        kKKQxKgtsj3eADmfQzcsNPyNJpfjCwG2ffwcMRlbw8nB4AS9R/HBQfGwfXLsE85uO9PPrC6j8qoNG
        E3TRc88oscBHpxEyyihnnyrL+87g5SnueoeXJ1DE0p1apkcH4Hft8hREiSvObL5dEdkAcaFMSOgTn
        uG//4bzcFVg6yLWaiQyxfEXpvHS1XTSB7XjfkZwXg6FbndwIFszupy1UXkOBfovIO8pyQGeMx6ESf
        rdO3CIZA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbr-00BQSi-DR; Tue, 24 Aug 2021 19:57:18 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 03/10] lan78xx: Set flow control threshold to prevent packet loss
Date:   Tue, 24 Aug 2021 19:56:06 +0100
Message-Id: <20210824185613.49545-4-john.efstathiades@pebblebay.com>
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

Set threshold at which flow control is triggered to 3/4 full of
the internal Rx packet FIFO to prevent packet drops at high data
rates. The new setting reduces the number of dropped UDP frames
and TCP retransmit requests especially on less capable CPUs.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 2896d31e5573..ccfb2d47932d 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -46,6 +46,19 @@
 
 #define MAX_RX_FIFO_SIZE		(12 * 1024)
 #define MAX_TX_FIFO_SIZE		(12 * 1024)
+
+#define FLOW_THRESHOLD(n)		((((n) + 511) / 512) & 0x7F)
+#define FLOW_CTRL_THRESHOLD(on, off)	((FLOW_THRESHOLD(on)  << 0) | \
+					 (FLOW_THRESHOLD(off) << 8))
+
+/* Flow control turned on when Rx FIFO level rises above this level (bytes) */
+#define FLOW_ON_SS			9216
+#define FLOW_ON_HS			8704
+
+/* Flow control turned off when Rx FIFO level falls below this level (bytes) */
+#define FLOW_OFF_SS			4096
+#define FLOW_OFF_HS			1024
+
 #define DEFAULT_BURST_CAP_SIZE		(MAX_TX_FIFO_SIZE)
 #define DEFAULT_BULK_IN_DELAY		(0x0800)
 #define MAX_SINGLE_PACKET_SIZE		(9000)
@@ -1135,9 +1148,9 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 		flow |= FLOW_CR_RX_FCEN_;
 
 	if (dev->udev->speed == USB_SPEED_SUPER)
-		fct_flow = 0x817;
+		fct_flow = FLOW_CTRL_THRESHOLD(FLOW_ON_SS, FLOW_OFF_SS);
 	else if (dev->udev->speed == USB_SPEED_HIGH)
-		fct_flow = 0x211;
+		fct_flow = FLOW_CTRL_THRESHOLD(FLOW_ON_HS, FLOW_OFF_HS);
 
 	netif_dbg(dev, link, dev->net, "rx pause %s, tx pause %s",
 		  (cap & FLOW_CTRL_RX ? "enabled" : "disabled"),
-- 
2.25.1

