Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC83F4BEA
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhHWNyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:54:24 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:19283 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230091AbhHWNyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:54:21 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 92D90363690;
        Mon, 23 Aug 2021 13:53:33 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-11-200.trex-nlb.outbound.svc.cluster.local [100.96.11.200])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 595B6363686;
        Mon, 23 Aug 2021 13:53:32 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.11.200 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Eight-Harbor: 2429f0a738287c69_1629726813408_1212514254
X-MC-Loop-Signature: 1629726813408:3957856849
X-MC-Ingress-Time: 1629726813407
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LqDZhnFUkByfiwr/bqkMIBICq8f+qNa1/xCNI8REbDo=; b=wJsO2DaxGmswtqm/679VareTbL
        XDvk47rjkoc7NONBGcM85kFDiglrV8ZG8Vp/80BNJImm7gZtq6XVjrGIFCrp3BrzSMgZnswfalYMu
        4CsX68ddzQIySkihYferhJtPcRsmAb//iUkSoU/p8fMyxzpe8ezgnjplYVV1Xqi8F0rLKUjojxCFu
        IopKazTiptxGJXnGSHqhtUd1n0HRhd1Ud2n4HatZtHFYoTe6qvR18JVX7T14pNzsxRky/8C823AxS
        m3neSx4YgkUmxkFUwmJBWLbge7IrxVQ2wiXW2Sg05NRozh/WnruOx9mD0HKBwMcR89LIJMIQ8HT+N
        QT/4OUhQ==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOI-003PzY-MD; Mon, 23 Aug 2021 14:53:30 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 03/10] lan78xx: Set flow control threshold to prevent packet loss
Date:   Mon, 23 Aug 2021 14:52:22 +0100
Message-Id: <20210823135229.36581-4-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
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

