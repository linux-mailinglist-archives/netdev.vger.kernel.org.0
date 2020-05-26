Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1251C7656
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgEFQbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:00 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51746 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730129AbgEFQaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:46 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUdIJ087473;
        Wed, 6 May 2020 11:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782639;
        bh=b61WU755w4Kty08jwSkR08ZmnLegbcL7sRigA0i8968=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=PeHwohV/GjzXI0K6G1UTt1ZU0vXnGBGsih7Jv8V4Q0zDX56L4gyIi32ePE038yErD
         Qxxg68c05rdq+j+x6k4WdtFS3+k9L/eTIsbMmdsyEWUfxrRsmDXLMF5vLMzEly2LVg
         HArVKiGHITaA9l77L8V0k3zaEB+rk1wnmhx+WKDo=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUd5G104793;
        Wed, 6 May 2020 11:30:39 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:39 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:39 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDo119719;
        Wed, 6 May 2020 11:30:39 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 11/13] net: prp: add supervision frame generation and handling support
Date:   Wed, 6 May 2020 12:30:31 -0400
Message-ID: <20200506163033.3843-12-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for sending and handling supervision frames. For PRP,
supervision frame format is similar to HSR version 0, but have a
PRP Redunancy Control Trailor (RCT) added.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_prp_device.c  | 50 ++++++++++++++++++++++++++++-------
 net/hsr-prp/hsr_prp_forward.c |  4 ++-
 net/hsr-prp/hsr_prp_main.h    | 22 +++++++++++++++
 3 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index 501de23a97f5..3c463e185f64 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -237,13 +237,20 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 {
 	struct sk_buff *skb;
 	int hlen, tlen;
-	struct hsr_tag *hsr_tag;
+	struct hsr_tag *hsr_tag = NULL;
+	struct prp_rct *rct;
 	struct hsr_prp_sup_tag *hsr_stag;
 	struct hsr_prp_sup_payload *hsr_sp;
 	unsigned long irqflags;
+	u16 proto;
+	u8 *tail;
 
 	hlen = LL_RESERVED_SPACE(master->dev);
 	tlen = master->dev->needed_tailroom;
+	/* skb size is same for PRP/HSR frames, only difference
+	 * being for PRP, it is a trailor and for HSR it is a
+	 * header
+	 */
 	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
 			    sizeof(struct hsr_prp_sup_tag) +
 			    sizeof(struct hsr_prp_sup_payload) + hlen + tlen);
@@ -252,12 +259,15 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 		return;
 
 	skb_reserve(skb, hlen);
-
+	if (!proto_ver)
+		proto = ETH_P_PRP;
+	else
+		proto = (proto_ver == HSR_V1) ? ETH_P_HSR : ETH_P_PRP;
 	skb->dev = master->dev;
-	skb->protocol = htons(proto_ver ? ETH_P_HSR : ETH_P_PRP);
+	skb->protocol = htons(proto);
 	skb->priority = TC_PRIO_CONTROL;
 
-	if (dev_hard_header(skb, skb->dev, (proto_ver ? ETH_P_HSR : ETH_P_PRP),
+	if (dev_hard_header(skb, skb->dev, proto,
 			    master->priv->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
@@ -265,7 +275,7 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 
-	if (proto_ver > 0) {
+	if (proto_ver == HSR_V1) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
 		hsr_tag->encap_proto = htons(ETH_P_PRP);
 		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
@@ -273,15 +283,19 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 
 	hsr_stag = skb_put(skb, sizeof(struct hsr_prp_sup_tag));
 	set_hsr_stag_path(hsr_stag, (proto_ver ? 0x0 : 0xf));
-	set_hsr_stag_HSR_ver(hsr_stag, proto_ver);
+	set_hsr_stag_HSR_ver(hsr_stag, proto_ver ? 0x1 : 0x0);
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
 	spin_lock_irqsave(&master->priv->seqnr_lock, irqflags);
 	if (proto_ver > 0) {
 		hsr_stag->sequence_nr = htons(master->priv->sup_sequence_nr);
-		hsr_tag->sequence_nr = htons(master->priv->sequence_nr);
+		if (hsr_tag)
+			hsr_tag->sequence_nr = htons(master->priv->sequence_nr);
 		master->priv->sup_sequence_nr++;
-		master->priv->sequence_nr++;
+		if (proto_ver == HSR_V1) {
+			hsr_tag->sequence_nr = htons(master->priv->sequence_nr);
+			master->priv->sequence_nr++;
+		}
 	} else {
 		hsr_stag->sequence_nr = htons(master->priv->sequence_nr);
 		master->priv->sequence_nr++;
@@ -300,6 +314,16 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 	if (skb_put_padto(skb, ETH_ZLEN + HSR_PRP_HLEN))
 		return;
 
+	spin_lock_irqsave(&master->priv->seqnr_lock, irqflags);
+	if (proto_ver == PRP_V1) {
+		tail = skb_tail_pointer(skb) - HSR_PRP_HLEN;
+		rct = (struct prp_rct *)tail;
+		rct->PRP_suffix = htons(ETH_P_PRP);
+		set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
+		rct->sequence_nr = htons(master->priv->sequence_nr);
+		master->priv->sequence_nr++;
+	}
+	spin_unlock_irqrestore(&master->priv->seqnr_lock, irqflags);
 	hsr_prp_forward_skb(skb, master);
 	return;
 
@@ -328,8 +352,14 @@ static void hsr_prp_announce(struct timer_list *t)
 
 		interval = msecs_to_jiffies(HSR_PRP_ANNOUNCE_INTERVAL);
 	} else {
-		send_hsr_prp_supervision_frame(master, HSR_TLV_LIFE_CHECK,
-					       priv->prot_version);
+		if (priv->prot_version <= HSR_V1)
+			send_hsr_prp_supervision_frame(master,
+						       HSR_TLV_LIFE_CHECK,
+						       priv->prot_version);
+		else /* PRP */
+			send_hsr_prp_supervision_frame(master,
+						       PRP_TLV_LIFE_CHECK_DD,
+						       priv->prot_version);
 
 		interval = msecs_to_jiffies(HSR_PRP_LIFE_CHECK_INTERVAL);
 	}
diff --git a/net/hsr-prp/hsr_prp_forward.c b/net/hsr-prp/hsr_prp_forward.c
index 59b33d711ea6..d7e975919322 100644
--- a/net/hsr-prp/hsr_prp_forward.c
+++ b/net/hsr-prp/hsr_prp_forward.c
@@ -74,7 +74,9 @@ static bool is_supervision_frame(struct hsr_prp_priv *priv, struct sk_buff *skb)
 	}
 
 	if (hsr_sup_tag->HSR_TLV_type != HSR_TLV_ANNOUNCE &&
-	    hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK)
+	    hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
+	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
+	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
 		return false;
 	if (hsr_sup_tag->HSR_TLV_length != 12 &&
 	    hsr_sup_tag->HSR_TLV_length != sizeof(struct hsr_prp_sup_payload))
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index 00c312e5189f..17049d040226 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -33,6 +33,10 @@
 
 #define HSR_TLV_ANNOUNCE		   22
 #define HSR_TLV_LIFE_CHECK		   23
+/* PRP V1 life check for Duplicate discard */
+#define PRP_TLV_LIFE_CHECK_DD		   20
+/* PRP V1 life check for Duplicate Accept */
+#define PRP_TLV_LIFE_CHECK_DA		   21
 
 /* HSR Tag.
  * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
@@ -125,6 +129,24 @@ enum hsr_prp_port_type {
 	HSR_PRP_PT_PORTS,	/* This must be the last item in the enum */
 };
 
+/* PRP Redunancy Control Trailor (RCT).
+ * As defined in IEC-62439-4:2012, the PRP RCT is really { sequence Nr,
+ * Lan indentifier (LanId), LSDU_size and PRP_suffix = 0x88FB }.
+ *
+ * Field names as defined in the IEC:2012 standard for PRP.
+ */
+struct prp_rct {
+	__be16		sequence_nr;
+	__be16		lan_id_and_LSDU_size;
+	__be16		PRP_suffix;
+} __packed;
+
+static inline void set_prp_LSDU_size(struct prp_rct *rct, u16 LSDU_size)
+{
+	rct->lan_id_and_LSDU_size = htons((ntohs(rct->lan_id_and_LSDU_size) &
+					  0xF000) | (LSDU_size & 0x0FFF));
+}
+
 struct hsr_prp_port {
 	struct list_head	port_list;
 	struct net_device	*dev;
-- 
2.17.1

