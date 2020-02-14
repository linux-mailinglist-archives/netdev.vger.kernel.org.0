Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A915EE98
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390351AbgBNRlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389704AbgBNQDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C3F24680;
        Fri, 14 Feb 2020 16:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696217;
        bh=wySVuzOAKsVfP2zWPLQgRaUCUUY7XFfw5EC5uuHR3qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVvxThtXEtMBi37UTATY5v1gc83Sb7s7rq7wGhwREnvMRd5PmnA57LBokhSPyDJRG
         eiM7/3psYX2WCeYIrBYOsPSsLY8kEViQJmpnG8T9aEsCjXj4pudmrqjSCGIEMUQiF7
         yNjg7JTkkYIl2zy1cp4/hDhFrLD8cB+mZrJFJhNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 081/459] wan/hdlc_x25: fix skb handling
Date:   Fri, 14 Feb 2020 10:55:31 -0500
Message-Id: <20200214160149.11681-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 953c4a08dfc9ffe763a8340ac10f459d6c6cc4eb ]

o call skb_reset_network_header() before hdlc->xmit()
 o change skb proto to HDLC (0x0019) before hdlc->xmit()
 o call dev_queue_xmit_nit() before hdlc->xmit()

This changes make it possible to trace (tcpdump) outgoing layer2
(ETH_P_HDLC) packets

Additionally call skb_reset_network_header() after each skb_push() /
skb_pull().

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 5643675ff7241..bf78073ee7fd9 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -62,11 +62,12 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
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
 
@@ -79,6 +80,13 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
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
 
@@ -93,6 +101,7 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
+		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
-- 
2.20.1

