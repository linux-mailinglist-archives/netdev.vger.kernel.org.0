Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF59A229A5E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgGVOlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:41:00 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54752 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGVOk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:40:29 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeO2V130835;
        Wed, 22 Jul 2020 09:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595428824;
        bh=VjMzGhRct2LIwrzk7MxT7P2Uq1yPwO4aN9tynpi+ghg=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=ptTHhLUDpF7x6K0AXFud31u2VI/b7AaWYJInKFM/PfbBH3iGJQ0WmKAzszUA7GFF+
         YKV+Q1zJFGI0iFFT2lnxjMUzQ7jPh0tlnHKbP5s6lj7tCFSaKR1iX6EhP7vSwoiGNB
         ZC5F/FgB9O9naP2ls5WdrlQp63aA1SGBdMYFchGo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06MEeOI1073558
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 09:40:24 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 22
 Jul 2020 09:40:24 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Jul 2020 09:40:24 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeMLB043940;
        Wed, 22 Jul 2020 09:40:24 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next v5 PATCH 3/7] net: hsr: introduce protocol specific function pointers
Date:   Wed, 22 Jul 2020 10:40:18 -0400
Message-ID: <20200722144022.15746-4-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722144022.15746-1-m-karicheri2@ti.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparatory patch to introduce support for PRP protocol, add a
protocol ops ptr in the private hsr structure to hold function
pointers as some of the functions at protocol level packet
handling is different for HSR vs PRP. It is expected that PRP will
add its of set of functions for protocol handling. Modify existing
hsr_announce() function to call proto_ops->send_sv_frame() to send
supervision frame for HSR. This is expected to be different for PRP.
So introduce a ops function ptr, send_sv_frame() for the same and
initialize it to send_hsr_supervsion_frame(). Modify hsr_announce()
to call proto_ops->send_sv_frame().

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_device.c | 70 ++++++++++++++++++++++++--------------------
 net/hsr/hsr_main.h   |  6 ++++
 2 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index bfe2d1449dbd..006e715eccb6 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -230,7 +230,7 @@ static const struct header_ops hsr_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
-static struct sk_buff *hsr_init_skb(struct hsr_port *master, u8 hsr_ver)
+static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 {
 	struct hsr_priv *hsr = master->hsr;
 	struct sk_buff *skb;
@@ -247,10 +247,10 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u8 hsr_ver)
 
 	skb_reserve(skb, hlen);
 	skb->dev = master->dev;
-	skb->protocol = htons(hsr_ver ? ETH_P_HSR : ETH_P_PRP);
+	skb->protocol = htons(proto);
 	skb->priority = TC_PRIO_CONTROL;
 
-	if (dev_hard_header(skb, skb->dev, (hsr_ver ? ETH_P_HSR : ETH_P_PRP),
+	if (dev_hard_header(skb, skb->dev, proto,
 			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
@@ -267,47 +267,62 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u8 hsr_ver)
 }
 
 static void send_hsr_supervision_frame(struct hsr_port *master,
-				       u8 type, u8 hsr_ver)
+				       unsigned long *interval)
 {
+	struct hsr_priv *hsr = master->hsr;
+	__u8 type = HSR_TLV_LIFE_CHECK;
+	struct hsr_tag *hsr_tag = NULL;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
-	struct hsr_tag *hsr_tag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
+	u16 proto;
+
+	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
+	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
+		type = HSR_TLV_ANNOUNCE;
+		*interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
+		hsr->announce_count++;
+	}
+
+	if (!hsr->prot_version)
+		proto = ETH_P_PRP;
+	else
+		proto = ETH_P_HSR;
 
-	skb = hsr_init_skb(master, hsr_ver);
+	skb = hsr_init_skb(master, proto);
 	if (!skb) {
 		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
 		return;
 	}
 
-	if (hsr_ver > 0) {
+	if (hsr->prot_version > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
 		hsr_tag->encap_proto = htons(ETH_P_PRP);
 		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
 	}
 
 	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
-	set_hsr_stag_path(hsr_stag, (hsr_ver ? 0x0 : 0xf));
-	set_hsr_stag_HSR_ver(hsr_stag, hsr_ver);
+	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
+	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
 	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
-	if (hsr_ver > 0) {
-		hsr_stag->sequence_nr = htons(master->hsr->sup_sequence_nr);
-		hsr_tag->sequence_nr = htons(master->hsr->sequence_nr);
-		master->hsr->sup_sequence_nr++;
-		master->hsr->sequence_nr++;
+	if (hsr->prot_version > 0) {
+		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
+		hsr->sup_sequence_nr++;
+		hsr_tag->sequence_nr = htons(hsr->sequence_nr);
+		hsr->sequence_nr++;
 	} else {
-		hsr_stag->sequence_nr = htons(master->hsr->sequence_nr);
-		master->hsr->sequence_nr++;
+		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
+		hsr->sequence_nr++;
 	}
 	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 
 	hsr_stag->HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
-	hsr_stag->HSR_TLV_length =
-				hsr_ver ? sizeof(struct hsr_sup_payload) : 12;
+	hsr_stag->HSR_TLV_length = hsr->prot_version ?
+				sizeof(struct hsr_sup_payload) : 12;
 
 	/* Payload: MacAddressA */
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
@@ -333,19 +348,7 @@ static void hsr_announce(struct timer_list *t)
 
 	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-
-	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
-		send_hsr_supervision_frame(master, HSR_TLV_ANNOUNCE,
-					   hsr->prot_version);
-		hsr->announce_count++;
-
-		interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
-	} else {
-		send_hsr_supervision_frame(master, HSR_TLV_LIFE_CHECK,
-					   hsr->prot_version);
-
-		interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
-	}
+	hsr->proto_ops->send_sv_frame(master, &interval);
 
 	if (is_admin_up(master->dev))
 		mod_timer(&hsr->announce_timer, jiffies + interval);
@@ -382,6 +385,10 @@ static struct device_type hsr_type = {
 	.name = "hsr",
 };
 
+static struct hsr_proto_ops hsr_ops = {
+	.send_sv_frame = send_hsr_supervision_frame,
+};
+
 void hsr_dev_setup(struct net_device *dev)
 {
 	eth_hw_addr_random(dev);
@@ -445,6 +452,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (protocol_version == PRP_V1)
 		return -EPROTONOSUPPORT;
 
+	hsr->proto_ops = &hsr_ops;
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
 	res = hsr_create_self_node(hsr, hsr_dev->dev_addr,
 				   slave[1]->dev_addr);
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 8cf10d67d5f9..671270115a50 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -140,6 +140,11 @@ enum hsr_version {
 	PRP_V1,
 };
 
+struct hsr_proto_ops {
+	/* format and send supervision frame */
+	void (*send_sv_frame)(struct hsr_port *port, unsigned long *interval);
+};
+
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
@@ -153,6 +158,7 @@ struct hsr_priv {
 	enum hsr_version prot_version;	/* Indicate if HSRv0, HSRv1 or PRPv1 */
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
+	struct hsr_proto_ops	*proto_ops;
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
-- 
2.17.1

