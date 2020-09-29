Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B002427B9BD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgI2BdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbgI2BcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:32:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9010F235F7;
        Tue, 29 Sep 2020 01:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343123;
        bh=ZnCwhqYOLiU6cpx9pDpRXQLQEakhkJ0SRK+Z5Iq2s0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teYi01qDNgkuBnMIH5+yLSPcNxAa/+vbxYEPyKmxe/k++dDPz53Ak/o0+gWLZDAVS
         ysHq9n3z8Jcgtf+zJbIIOryo6WcoyApa+jYwHB8ucEep9TUqHMvsmuRBbto29mClSO
         OUgjh+rrwbp+/QCj808KIQuF5LADXd1K4TFonUt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/5] drivers/net/wan/hdlc: Set skb->protocol before transmitting
Date:   Mon, 28 Sep 2020 21:31:56 -0400
Message-Id: <20200929013157.2407108-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013157.2407108-1-sashal@kernel.org>
References: <20200929013157.2407108-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 9fb030a70431a2a2a1b292dbf0b2f399cc072c16 ]

This patch sets skb->protocol before transmitting frames on the HDLC
device, so that a user listening on the HDLC device with an AF_PACKET
socket will see outgoing frames' sll_protocol field correctly set and
consistent with that of incoming frames.

1. Control frames in hdlc_cisco and hdlc_ppp

When these drivers send control frames, skb->protocol is not set.

This value should be set to htons(ETH_P_HDLC), because when receiving
control frames, their skb->protocol is set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, which then calls
cisco_type_trans or ppp_type_trans. The skb->protocol of control frames
is set to htons(ETH_P_HDLC) so that the control frames can be received
by hdlc_rcv in hdlc.c, which calls cisco_rx or ppp_rx to process the
control frames.

2. hdlc_fr

When this driver sends control frames, skb->protocol is set to internal
values used in this driver.

When this driver sends data frames (from upper stacked PVC devices),
skb->protocol is the same as that of the user data packet being sent on
the upper PVC device (for normal PVC devices), or is htons(ETH_P_802_3)
(for Ethernet-emulating PVC devices).

However, skb->protocol for both control frames and data frames should be
set to htons(ETH_P_HDLC), because when receiving, all frames received on
the HDLC device will have their skb->protocol set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, and because this
driver doesn't provide a type_trans function in struct hdlc_proto,
all frames will have their skb->protocol set to htons(ETH_P_HDLC).
The frames are then received by hdlc_rcv in hdlc.c, which calls fr_rx
to process the frames (control frames are consumed and data frames
are re-received on upper PVC devices).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 drivers/net/wan/hdlc_fr.c    | 3 +++
 drivers/net/wan/hdlc_ppp.c   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 7f99fb666f196..1587789ba9343 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -120,6 +120,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	skb_put(skb, sizeof(struct cisco_packet));
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index b6e0cfb095d35..bba19d068207a 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -435,6 +435,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (pvc->state.fecn) /* TX Congestion counter */
 				dev->stats.tx_compressed++;
 			skb->dev = pvc->frad;
+			skb->protocol = htons(ETH_P_HDLC);
+			skb_reset_network_header(skb);
 			dev_queue_xmit(skb);
 			return NETDEV_TX_OK;
 		}
@@ -557,6 +559,7 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	skb_put(skb, i);
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 8a9aced850be3..f4cb0ab25b983 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -254,6 +254,7 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 	skb_queue_tail(&tx_queue, skb);
 }
-- 
2.25.1

