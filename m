Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22C7315BDC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhBJBFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbhBJBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:03:31 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A1C0613D6
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 17:02:51 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id z36so146552ooi.6
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eOxu1z2uH5iAstmwN4aKBHL2reWh3fcayQ/91K0mJHM=;
        b=GnoFjVU6PVia8Pn0q+4Ok/7BZi8T64U/nlsozmYtWCv72X4iPexNfIqs06Re+uZDnP
         Dljal034V89APICAuk5mDMcNec6itt0oADlX/9PlTZaiV+y3f6VsABkmnSV7MoRsAIo3
         nTutMDWmdic/uDCeaa2cUHi5ag9eZCCzG5p4RrArMBAUXixT3ock/TMo9Ugeu+mBEmsQ
         k0vlgnzFYrFkS1i1Y8/GtDHVPhVgsWGLhgbO3o9K7ihtRkitBhPJDUkTsmzYWw86zlBE
         kkYmbOA1IbCmRtIbRnhEZosXajExj+qoDq1bZq+5DW19f2xJvqPaDDsJ5JpHkDnvaGLt
         gheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eOxu1z2uH5iAstmwN4aKBHL2reWh3fcayQ/91K0mJHM=;
        b=IbiWUwxd0LhVjX2tPXwpy06O565Qh9R7udzlxA98+G1m6cTpJNqHWDNJpQv4wKLMsB
         C9IbE0TG66SU0ik/tGlFYGfHYp1zYMHMuK5WGfFkn0uBBu6rN5O9TXg1dqwCDdgKZEMv
         JaB5Obwd0oKCRNFAL+fN7EffrpAWvXUnCymNBYyKYpDsvHzz3WFL7CzNGcWbK9GEAev3
         b5kgriPXxyd4VgVwyOpG5qvyeCQhxQm/roVkpu3lPIpNs/Zr2cWMwh48ibIQiZtgtn+y
         bddaNaguC8jg3TelkBgUFYGMFFEgUNHHVNwvSWFSdUNHOmTeZucYYfw+EEAuq5V3whQS
         WFbA==
X-Gm-Message-State: AOAM533XJkFdHwvLYg+lz8QRn5G9rg4/0CL8iASdiJCXC0Url6Cdv7Mf
        jtV01xFbrWWiW3TqUsNo1w==
X-Google-Smtp-Source: ABdhPJxb6DcCwsY2tUcg1DuSOmnFtputPk4Nmkd0DsgvApLOg1ypw5bkC1/tmF6tR/KJDq7n5FJAvw==
X-Received: by 2002:a4a:b103:: with SMTP id a3mr446353ooo.30.1612918970819;
        Tue, 09 Feb 2021 17:02:50 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id i9sm101811oii.34.2021.02.09.17.02.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 17:02:49 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 1/4] net: hsr: generate supervision frame without HSR/PRP tag
Date:   Tue,  9 Feb 2021 19:02:10 -0600
Message-Id: <20210210010213.27553-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210210010213.27553-1-george.mccollister@gmail.com>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a switch to offload insertion of HSR/PRP tags, frames must not be
sent to the CPU facing switch port with a tag. Generate supervision frames
(eth type ETH_P_PRP) without HSR v1 (ETH_P_HSR)/PRP tag and rely on
create_tagged_frame which inserts it later. This will allow skipping the
tag insertion for all outgoing frames in the future which is required for
HSR v1/PRP tag insertions to be offloaded.

HSR v0 supervision frames always contain tag information so insertion of
the tag can't be offloaded. IEC 62439-3 Ed.2.0 (HSR v1) specifically
notes that this was changed since v0 to allow offloading.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/hsr/hsr_device.c  | 39 +++++++--------------------------------
 net/hsr/hsr_forward.c |  8 +++++++-
 2 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ab953a1a0d6c..ec6a68b403d5 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -230,7 +230,7 @@ static const struct header_ops hsr_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
-static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
+static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 {
 	struct hsr_priv *hsr = master->hsr;
 	struct sk_buff *skb;
@@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 	 * being, for PRP it is a trailer and for HSR it is a
 	 * header
 	 */
-	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
-			    sizeof(struct hsr_sup_tag) +
+	skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
 			    sizeof(struct hsr_sup_payload) + hlen + tlen);
 
 	if (!skb)
@@ -251,10 +250,9 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 
 	skb_reserve(skb, hlen);
 	skb->dev = master->dev;
-	skb->protocol = htons(proto);
 	skb->priority = TC_PRIO_CONTROL;
 
-	if (dev_hard_header(skb, skb->dev, proto,
+	if (dev_hard_header(skb, skb->dev, ETH_P_PRP,
 			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
@@ -275,12 +273,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 {
 	struct hsr_priv *hsr = master->hsr;
 	__u8 type = HSR_TLV_LIFE_CHECK;
-	struct hsr_tag *hsr_tag = NULL;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
-	u16 proto;
 
 	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
 	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
@@ -289,23 +285,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr->announce_count++;
 	}
 
-	if (!hsr->prot_version)
-		proto = ETH_P_PRP;
-	else
-		proto = ETH_P_HSR;
-
-	skb = hsr_init_skb(master, proto);
+	skb = hsr_init_skb(master);
 	if (!skb) {
 		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
 		return;
 	}
 
-	if (hsr->prot_version > 0) {
-		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
-		hsr_tag->encap_proto = htons(ETH_P_PRP);
-		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
-	}
-
 	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
 	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
@@ -315,8 +300,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	if (hsr->prot_version > 0) {
 		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 		hsr->sup_sequence_nr++;
-		hsr_tag->sequence_nr = htons(hsr->sequence_nr);
-		hsr->sequence_nr++;
 	} else {
 		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
@@ -332,7 +315,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
+	if (skb_put_padto(skb, ETH_ZLEN))
 		return;
 
 	hsr_forward_skb(skb, master);
@@ -348,10 +331,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	struct hsr_sup_tag *hsr_stag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
-	struct prp_rct *rct;
-	u8 *tail;
 
-	skb = hsr_init_skb(master, ETH_P_PRP);
+	skb = hsr_init_skb(master);
 	if (!skb) {
 		WARN_ONCE(1, "PRP: Could not send supervision frame\n");
 		return;
@@ -373,17 +354,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN)) {
+	if (skb_put_padto(skb, ETH_ZLEN)) {
 		spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 		return;
 	}
 
-	tail = skb_tail_pointer(skb) - HSR_HLEN;
-	rct = (struct prp_rct *)tail;
-	rct->PRP_suffix = htons(ETH_P_PRP);
-	set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
-	rct->sequence_nr = htons(hsr->sequence_nr);
-	hsr->sequence_nr++;
 	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 
 	hsr_forward_skb(skb, master);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index cadfccd7876e..d32cd87d5c5b 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -186,6 +186,7 @@ static struct sk_buff *prp_fill_rct(struct sk_buff *skb,
 	set_prp_LSDU_size(trailer, lsdu_size);
 	trailer->sequence_nr = htons(frame->sequence_nr);
 	trailer->PRP_suffix = htons(ETH_P_PRP);
+	skb->protocol = eth_hdr(skb)->h_proto;
 
 	return skb;
 }
@@ -226,6 +227,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
 	hsr_ethhdr->hsr_tag.encap_proto = hsr_ethhdr->ethhdr.h_proto;
 	hsr_ethhdr->ethhdr.h_proto = htons(proto_version ?
 			ETH_P_HSR : ETH_P_PRP);
+	skb->protocol = hsr_ethhdr->ethhdr.h_proto;
 
 	return skb;
 }
@@ -454,7 +456,11 @@ static void handle_std_frame(struct sk_buff *skb,
 void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			 struct hsr_frame_info *frame)
 {
-	if (proto == htons(ETH_P_PRP) ||
+	struct hsr_port *port = frame->port_rcv;
+	struct hsr_priv *hsr = port->hsr;
+
+	/* HSRv0 supervisory frames double as a tag so treat them as tagged. */
+	if ((!hsr->prot_version && proto == htons(ETH_P_PRP)) ||
 	    proto == htons(ETH_P_HSR)) {
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
-- 
2.11.0

