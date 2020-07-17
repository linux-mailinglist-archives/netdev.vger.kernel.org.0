Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4C223F4A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGQPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:15:18 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35788 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgGQPPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:15:18 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HFFDLc013298;
        Fri, 17 Jul 2020 10:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594998913;
        bh=22xCI2rLwzkGNrjRKKsT/ANJsxuoRQPnQp7a0zUc31c=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=ZsaJoTfPWBDhvjqESgPXwTuN0Rk20+scACbMVnTwsHJHx9/792Cyj5IsYqpvIr9BP
         2B7hFFZFJfx2dnvwml3ccAjiw3vxE673ioxcGS97GTYY5AKROZ+vBQ10y+Xcg0DXH8
         letPTy5cL5oauUqhUMngRIOUpDWDo4XWYbdadXzk=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HFFDVx111735
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 10:15:13 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 10:15:13 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 10:15:12 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HFFBme010522;
        Fri, 17 Jul 2020 10:15:12 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next PATCH v3 2/7] net: hsr: introduce common code for skb initialization
Date:   Fri, 17 Jul 2020 11:15:06 -0400
Message-ID: <20200717151511.329-3-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200717151511.329-1-m-karicheri2@ti.com>
References: <20200717151511.329-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparatory patch to introduce PRP protocol support in the
driver, refactor the skb init code to a separate function.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_device.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 40ac45123a62..600b9da4a44e 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -230,15 +230,11 @@ static const struct header_ops hsr_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
-static void send_hsr_supervision_frame(struct hsr_port *master,
-				       u8 type, u8 hsr_ver)
+static struct sk_buff *hsr_init_skb(struct hsr_port *master, u8 hsr_ver)
 {
+	struct hsr_priv *hsr = master->hsr;
 	struct sk_buff *skb;
 	int hlen, tlen;
-	struct hsr_tag *hsr_tag;
-	struct hsr_sup_tag *hsr_stag;
-	struct hsr_sup_payload *hsr_sp;
-	unsigned long irqflags;
 
 	hlen = LL_RESERVED_SPACE(master->dev);
 	tlen = master->dev->needed_tailroom;
@@ -247,22 +243,44 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 			    sizeof(struct hsr_sup_payload) + hlen + tlen);
 
 	if (!skb)
-		return;
+		return skb;
 
 	skb_reserve(skb, hlen);
-
 	skb->dev = master->dev;
 	skb->protocol = htons(hsr_ver ? ETH_P_HSR : ETH_P_PRP);
 	skb->priority = TC_PRIO_CONTROL;
 
 	if (dev_hard_header(skb, skb->dev, (hsr_ver ? ETH_P_HSR : ETH_P_PRP),
-			    master->hsr->sup_multicast_addr,
+			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
+
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 
+	return skb;
+out:
+	kfree_skb(skb);
+
+	return NULL;
+}
+
+static void send_hsr_supervision_frame(struct hsr_port *master,
+				       u8 type, u8 hsr_ver)
+{
+	struct sk_buff *skb;
+	struct hsr_tag *hsr_tag;
+	struct hsr_sup_tag *hsr_stag;
+	struct hsr_sup_payload *hsr_sp;
+	unsigned long irqflags;
+
+	skb = hsr_init_skb(master, hsr_ver);
+	if (!skb) {
+		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
+		return;
+	}
+
 	if (hsr_ver > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
 		hsr_tag->encap_proto = htons(ETH_P_PRP);
@@ -299,11 +317,8 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		return;
 
 	hsr_forward_skb(skb, master);
-	return;
 
-out:
-	WARN_ONCE(1, "HSR: Could not send supervision frame\n");
-	kfree_skb(skb);
+	return;
 }
 
 /* Announce (supervision frame) timer function
-- 
2.17.1

