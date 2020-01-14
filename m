Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2D213ABCF
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgANODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:03:00 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:61238
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728920AbgANODA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:03:00 -0500
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 8A01D20C94;
        Tue, 14 Jan 2020 14:02:57 +0000 (UTC)
From:   Martin Schiller <ms@dev.tdt.de>
To:     kubakici@wp.pl, khc@pm.waw.pl, davem@davemloft.net
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH v2 2/2] wan/hdlc_x25: fix skb handling
Date:   Tue, 14 Jan 2020 15:02:23 +0100
Message-Id: <20200114140223.22446-2-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114140223.22446-1-ms@dev.tdt.de>
References: <20200114140223.22446-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 o call skb_reset_network_header() before hdlc->xmit()
 o change skb proto to HDLC (0x0019) before hdlc->xmit()
 o call dev_queue_xmit_nit() before hdlc->xmit()

This changes make it possible to trace (tcpdump) outgoing layer2
(ETH_P_HDLC) packets

Additionally call skb_reset_network_header() after each skb_push() /
skb_pull().

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 drivers/net/wan/hdlc_x25.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 0479a2bf42f7..9eaad151c27f 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -71,11 +71,12 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	skb_push(skb, 1);
-
 	if (skb_cow(skb, 1))
 		return NET_RX_DROP;
 
+	skb_push(skb, 1);
+	skb_reset_network_header(skb);
+
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
 
@@ -88,6 +89,13 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+
+	skb_reset_network_header(skb);
+	skb->protocol = hdlc_type_trans(skb, dev);
+
+	if (dev_nit_active(dev))
+		dev_queue_xmit_nit(skb, dev);
+
 	hdlc->xmit(skb, dev); /* Ignore return value :-( */
 }
 
@@ -102,6 +110,7 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
+		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
-- 
2.20.1

