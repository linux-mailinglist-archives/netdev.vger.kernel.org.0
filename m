Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B2F221295
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGOQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:34 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36162 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgGOQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:31 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06FGePcV052859;
        Wed, 15 Jul 2020 11:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594831225;
        bh=YX1hQHzR0bx50hxRExt6+tAtM5SB1EQinYiKWTnG54E=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=b59VysrivzpXUidUtnof1snft+7xOSCX9PMBfJUFr1VTEMABorYdtLIUeASXgSlpT
         UWOo6E1YAyFvHcA6awUBLxcdvLxuNMFULZWxL3ibDV2g3pXUx7pZwrHfzLjAVpDQIv
         q1RPBXVibc68QgoTBzl6HhsOngSTDRi4koNCY1HE=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGePxS031902;
        Wed, 15 Jul 2020 11:40:25 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 11:40:24 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 11:40:24 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeCvf081717;
        Wed, 15 Jul 2020 11:40:23 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next PATCH v2 7/9] net: hsr: define and use proto_ops ptrs to handle hsr specific frames
Date:   Wed, 15 Jul 2020 12:40:08 -0400
Message-ID: <20200715164012.1222-8-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparatory patch to introduce PRP, refactor the code specific to
handling HSR frames into separate functions and call them through
proto_ops function pointers.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_device.c  |  5 +++-
 net/hsr/hsr_forward.c | 63 +++++++++++++++++++++++++------------------
 net/hsr/hsr_forward.h |  7 ++++-
 net/hsr/hsr_main.h    |  8 ++++++
 4 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 5410854f9ca6..07d5c2e06b49 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -440,9 +440,12 @@ static struct device_type hsr_type = {
 
 static struct hsr_proto_ops hsr_ops = {
 	.send_sv_frame = send_hsr_supervision_frame,
+	.create_tagged_frame = hsr_create_tagged_frame,
+	.get_untagged_frame = hsr_get_untagged_frame,
+	.fill_frame_info = hsr_fill_frame_info,
 };
 
-struct hsr_proto_ops prp_ops = {
+static struct hsr_proto_ops prp_ops = {
 	.send_sv_frame = send_prp_supervision_frame,
 };
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 3a536a7d98e8..7fc6cc7b29bb 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -116,8 +116,8 @@ static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
 	return skb;
 }
 
-static struct sk_buff *frame_get_stripped_skb(struct hsr_frame_info *frame,
-					      struct hsr_port *port)
+struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
+				       struct hsr_port *port)
 {
 	if (!frame->skb_std)
 		frame->skb_std = create_stripped_skb(frame->skb_hsr, frame);
@@ -187,8 +187,8 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 /* If the original frame was an HSR tagged frame, just clone it to be sent
  * unchanged. Otherwise, create a private frame especially tagged for 'port'.
  */
-static struct sk_buff *frame_get_tagged_skb(struct hsr_frame_info *frame,
-					    struct hsr_port *port)
+struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
+					struct hsr_port *port)
 {
 	if (frame->skb_hsr)
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
@@ -252,6 +252,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 	struct sk_buff *skb;
 
 	hsr_for_each_port(frame->port_rcv->hsr, port) {
+		struct hsr_priv *hsr = port->hsr;
 		/* Don't send frame back the way it came */
 		if (port == frame->port_rcv)
 			continue;
@@ -277,9 +278,10 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		}
 
 		if (port->type != HSR_PT_MASTER)
-			skb = frame_get_tagged_skb(frame, port);
+			skb = hsr->proto_ops->create_tagged_frame(frame, port);
 		else
-			skb = frame_get_stripped_skb(frame, port);
+			skb = hsr->proto_ops->get_untagged_frame(frame, port);
+
 		if (!skb) {
 			/* FIXME: Record the dropped frame? */
 			continue;
@@ -312,12 +314,34 @@ static void check_local_dest(struct hsr_priv *hsr, struct sk_buff *skb,
 	}
 }
 
-static int hsr_fill_frame_info(struct hsr_frame_info *frame,
-			       struct sk_buff *skb, struct hsr_port *port)
+void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			 struct hsr_frame_info *frame)
 {
-	struct ethhdr *ethhdr;
+	struct hsr_priv *hsr = frame->port_rcv->hsr;
 	unsigned long irqflags;
 
+	if (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR)) {
+		frame->skb_std = NULL;
+		frame->skb_hsr = skb;
+		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
+	} else {
+		frame->skb_std = skb;
+		frame->skb_hsr = NULL;
+		/* Sequence nr for the master node */
+		spin_lock_irqsave(&hsr->seqnr_lock, irqflags);
+		frame->sequence_nr = hsr->sequence_nr;
+		hsr->sequence_nr++;
+		spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
+	}
+}
+
+static int fill_frame_info(struct hsr_frame_info *frame,
+			   struct sk_buff *skb, struct hsr_port *port)
+{
+	struct hsr_priv *hsr = port->hsr;
+	struct ethhdr *ethhdr;
+	__be16 proto;
+
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
 	frame->node_src = hsr_get_node(port, skb, frame->is_supervision);
 	if (!frame->node_src)
@@ -330,23 +354,10 @@ static int hsr_fill_frame_info(struct hsr_frame_info *frame,
 		/* FIXME: */
 		netdev_warn_once(skb->dev, "VLAN not yet supported");
 	}
-	if (ethhdr->h_proto == htons(ETH_P_PRP) ||
-	    ethhdr->h_proto == htons(ETH_P_HSR)) {
-		frame->skb_std = NULL;
-		frame->skb_hsr = skb;
-		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
-	} else {
-		frame->skb_std = skb;
-		frame->skb_hsr = NULL;
-		/* Sequence nr for the master node */
-		spin_lock_irqsave(&port->hsr->seqnr_lock, irqflags);
-		frame->sequence_nr = port->hsr->sequence_nr;
-		port->hsr->sequence_nr++;
-		spin_unlock_irqrestore(&port->hsr->seqnr_lock, irqflags);
-	}
-
+	proto = ethhdr->h_proto;
 	frame->port_rcv = port;
-	check_local_dest(port->hsr, skb, frame);
+	hsr->proto_ops->fill_frame_info(proto, skb, frame);
+	check_local_dest(hsr, skb, frame);
 
 	return 0;
 }
@@ -362,7 +373,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 		goto out_drop;
 	}
 
-	if (hsr_fill_frame_info(&frame, skb, port) < 0)
+	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
 	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_forward_do(&frame);
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index b2a6fa319d94..893207792d56 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -14,5 +14,10 @@
 #include "hsr_main.h"
 
 void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port);
-
+struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
+					struct hsr_port *port);
+struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
+				       struct hsr_port *port);
+void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			 struct hsr_frame_info *frame);
 #endif /* __HSR_FORWARD_H */
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 58e1ad21b66f..14f442c57a84 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -162,9 +162,17 @@ enum hsr_version {
 	PRP_V1,
 };
 
+struct hsr_frame_info;
+
 struct hsr_proto_ops {
 	/* format and send supervision frame */
 	void (*send_sv_frame)(struct hsr_port *port, unsigned long *interval);
+	struct sk_buff * (*get_untagged_frame)(struct hsr_frame_info *frame,
+					       struct hsr_port *port);
+	struct sk_buff * (*create_tagged_frame)(struct hsr_frame_info *frame,
+						struct hsr_port *port);
+	void (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
+				struct hsr_frame_info *frame);
 };
 
 struct hsr_priv {
-- 
2.17.1

