Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8A0299DD7
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411517AbgJ0AKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439197AbgJ0AKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C552221F7;
        Tue, 27 Oct 2020 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757420;
        bh=5RsE8WgbAZa7kQKYv0oZSsI36+PNI0rp8vB1x3q5S/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MouxwtyNiYABqZQk6cpfACa3B3DkAOqxFzuoqklrB/4JRdqdQuyIIzW7P4jJNKeYj
         jP+WW9DqIUnS1eh4xQnOjgNYovcUYflxo8mHioMVVbe0ODv7bQTmi/2Hjx08nIZ2qE
         OnlVHK5Cpwx75Hi8aiyIKxDRuxsrYfmlRtd03Zmc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/46] drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values
Date:   Mon, 26 Oct 2020 20:09:27 -0400
Message-Id: <20201027000946.1026923-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 8306266c1d51aac9aa7aa907fe99032a58c6382c ]

The fr_hard_header function is used to prepend the header to skbs before
transmission. It is used in 3 situations:
1) When a control packet is generated internally in this driver;
2) When a user sends an skb on an Ethernet-emulating PVC device;
3) When a user sends an skb on a normal PVC device.

These 3 situations need to be handled differently by fr_hard_header.
Different headers should be prepended to the skb in different situations.

Currently fr_hard_header distinguishes these 3 situations using
skb->protocol. For situation 1 and 2, a special skb->protocol value
will be assigned before calling fr_hard_header, so that it can recognize
these 2 situations. All skb->protocol values other than these special ones
are treated by fr_hard_header as situation 3.

However, it is possible that in situation 3, the user sends an skb with
one of the special skb->protocol values. In this case, fr_hard_header
would incorrectly treat it as situation 1 or 2.

This patch tries to solve this issue by using skb->dev instead of
skb->protocol to distinguish between these 3 situations. For situation
1, skb->dev would be NULL; for situation 2, skb->dev->type would be
ARPHRD_ETHER; and for situation 3, skb->dev->type would be ARPHRD_DLCI.

This way fr_hard_header would be able to distinguish these 3 situations
correctly regardless what skb->protocol value the user tries to use in
situation 3.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_fr.c | 98 ++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 5a8dbeaf1a427..d3b5532180585 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -275,63 +275,69 @@ static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 
 static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
 {
-	u16 head_len;
 	struct sk_buff *skb = *skb_p;
 
-	switch (skb->protocol) {
-	case cpu_to_be16(NLPID_CCITT_ANSI_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CCITT_ANSI_LMI;
-		break;
-
-	case cpu_to_be16(NLPID_CISCO_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CISCO_LMI;
-		break;
-
-	case cpu_to_be16(ETH_P_IP):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IP;
-		break;
-
-	case cpu_to_be16(ETH_P_IPV6):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IPV6;
-		break;
-
-	case cpu_to_be16(ETH_P_802_3):
-		head_len = 10;
-		if (skb_headroom(skb) < head_len) {
-			struct sk_buff *skb2 = skb_realloc_headroom(skb,
-								    head_len);
+	if (!skb->dev) { /* Control packets */
+		switch (dlci) {
+		case LMI_CCITT_ANSI_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CCITT_ANSI_LMI;
+			break;
+
+		case LMI_CISCO_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CISCO_LMI;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+
+	} else if (skb->dev->type == ARPHRD_DLCI) {
+		switch (skb->protocol) {
+		case htons(ETH_P_IP):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IP;
+			break;
+
+		case htons(ETH_P_IPV6):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IPV6;
+			break;
+
+		default:
+			skb_push(skb, 10);
+			skb->data[3] = FR_PAD;
+			skb->data[4] = NLPID_SNAP;
+			/* OUI 00-00-00 indicates an Ethertype follows */
+			skb->data[5] = 0x00;
+			skb->data[6] = 0x00;
+			skb->data[7] = 0x00;
+			/* This should be an Ethertype: */
+			*(__be16 *)(skb->data + 8) = skb->protocol;
+		}
+
+	} else if (skb->dev->type == ARPHRD_ETHER) {
+		if (skb_headroom(skb) < 10) {
+			struct sk_buff *skb2 = skb_realloc_headroom(skb, 10);
 			if (!skb2)
 				return -ENOBUFS;
 			dev_kfree_skb(skb);
 			skb = *skb_p = skb2;
 		}
-		skb_push(skb, head_len);
+		skb_push(skb, 10);
 		skb->data[3] = FR_PAD;
 		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
+		/* OUI 00-80-C2 stands for the 802.1 organization */
+		skb->data[5] = 0x00;
 		skb->data[6] = 0x80;
 		skb->data[7] = 0xC2;
+		/* PID 00-07 stands for Ethernet frames without FCS */
 		skb->data[8] = 0x00;
-		skb->data[9] = 0x07; /* bridged Ethernet frame w/out FCS */
-		break;
+		skb->data[9] = 0x07;
 
-	default:
-		head_len = 10;
-		skb_push(skb, head_len);
-		skb->data[3] = FR_PAD;
-		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
-		skb->data[6] = FR_PAD;
-		skb->data[7] = FR_PAD;
-		*(__be16*)(skb->data + 8) = skb->protocol;
+	} else {
+		return -EINVAL;
 	}
 
 	dlci_to_q922(skb->data, dlci);
@@ -427,8 +433,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 				skb_put(skb, pad);
 				memset(skb->data + len, 0, pad);
 			}
-			skb->protocol = cpu_to_be16(ETH_P_802_3);
 		}
+		skb->dev = dev;
 		if (!fr_hard_header(&skb, pvc->dlci)) {
 			dev->stats.tx_bytes += skb->len;
 			dev->stats.tx_packets++;
@@ -496,10 +502,8 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	memset(skb->data, 0, len);
 	skb_reserve(skb, 4);
 	if (lmi == LMI_CISCO) {
-		skb->protocol = cpu_to_be16(NLPID_CISCO_LMI);
 		fr_hard_header(&skb, LMI_CISCO_DLCI);
 	} else {
-		skb->protocol = cpu_to_be16(NLPID_CCITT_ANSI_LMI);
 		fr_hard_header(&skb, LMI_CCITT_ANSI_DLCI);
 	}
 	data = skb_tail_pointer(skb);
-- 
2.25.1

