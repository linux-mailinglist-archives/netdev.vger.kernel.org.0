Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D622D30FFCD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBDWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBDWAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:00:43 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9CC061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:00:03 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id n7so5321874oic.11
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fdRfZFSaOXPBtGvI5pkTo8JDuSXxlPXCgYgl9rI+dP8=;
        b=XT16Z6zMmDD6Ljfys7j9OhEfJVMg5BYnokcTU7cSjluLOXyqFhoxYvv3aEMd5jFCpO
         Ojrlmmp8dIkoFmyB2wSgjPbCnbpcTlV8XoQtmmfFF1GeeDsQUImFticvFLq95wkOuGO3
         KCXyjE+of1aMfz8YuVVeC4HPGoyo2POevZfRU1GZfeQq1xrlThn2JCQEY/iu2l1H1sev
         VM4Yu/1OpQJCMh9lmPIthU8lfex1Q/hkRJ9QjL0UaH469M1tGX+Ak3OtptPt67vIUraw
         kz2BlENIlfe2RdJjFCUxrHOjUKchkdI92VzMObe5zef22VCizyl4PPnTDjvqXc5pqZgA
         HtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fdRfZFSaOXPBtGvI5pkTo8JDuSXxlPXCgYgl9rI+dP8=;
        b=CwEnBWs+CVUJIxGktGf+7RI5B2miYDSnqPFPxl77YHgK8mC+IzAUG6Js5LFo13uFDv
         XxRaMubQ3w/lyau18IVzGxvkDpXdW2mbZieGeIm0VtKTTo2aWpDJ91uEqRyJ9FRA/ejs
         JvNbDnjkI8NqmQj8PFmjCurGfP6bUz61KX459qQqDB1xXBTszu9/rt3y/9oK8JnUtjMR
         SiVt7emlkktObkWKAfxAyjRlKtqyz07W+BfJLwQ5BJvRXgImJ8xF5q8moSs5p1ynT9Kc
         k3du2FvGZ1b5qhD8l9B006NWOjhkweUlz66M3SMmsNTw674T3NeUcBsoamldVy/x8RWb
         zy5g==
X-Gm-Message-State: AOAM530kTxpxOOk4/fVavN2VOkI0hviqnhGdSRR9/SV87bv1OklALyS3
        HytvR/8RLltCiFKsnAwKKA==
X-Google-Smtp-Source: ABdhPJw9rzgLOF3qmqhd3/NQzrljBa+QL4BMwFgH/ePp72Us7/mV/1k2hPySLUvTDQwmLz9JoxAXmg==
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr1103023oiw.92.1612476002573;
        Thu, 04 Feb 2021 14:00:02 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y10sm1361395ooy.11.2021.02.04.14.00.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 14:00:01 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 1/4] net: hsr: generate supervision frame without HSR/PRP tag
Date:   Thu,  4 Feb 2021 15:59:23 -0600
Message-Id: <20210204215926.64377-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210204215926.64377-1-george.mccollister@gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
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
 net/hsr/hsr_device.c  | 32 ++++----------------------------
 net/hsr/hsr_forward.c |  6 +++++-
 2 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ab953a1a0d6c..161b8da6a21d 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 	 * being, for PRP it is a trailer and for HSR it is a
 	 * header
 	 */
-	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
-			    sizeof(struct hsr_sup_tag) +
+	skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
 			    sizeof(struct hsr_sup_payload) + hlen + tlen);
 
 	if (!skb)
@@ -275,12 +274,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
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
@@ -289,23 +286,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr->announce_count++;
 	}
 
-	if (!hsr->prot_version)
-		proto = ETH_P_PRP;
-	else
-		proto = ETH_P_HSR;
-
-	skb = hsr_init_skb(master, proto);
+	skb = hsr_init_skb(master, ETH_P_PRP);
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
@@ -315,8 +301,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	if (hsr->prot_version > 0) {
 		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 		hsr->sup_sequence_nr++;
-		hsr_tag->sequence_nr = htons(hsr->sequence_nr);
-		hsr->sequence_nr++;
 	} else {
 		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
@@ -332,7 +316,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
+	if (skb_put_padto(skb, ETH_ZLEN))
 		return;
 
 	hsr_forward_skb(skb, master);
@@ -348,8 +332,6 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	struct hsr_sup_tag *hsr_stag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
-	struct prp_rct *rct;
-	u8 *tail;
 
 	skb = hsr_init_skb(master, ETH_P_PRP);
 	if (!skb) {
@@ -373,17 +355,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
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
index cadfccd7876e..c11be87daa8f 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -454,7 +454,11 @@ static void handle_std_frame(struct sk_buff *skb,
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

