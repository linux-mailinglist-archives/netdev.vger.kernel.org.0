Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB6930A953
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhBAOGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhBAOF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:05:59 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C31DC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:05:19 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id d18so18890759oic.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qpNdCAKICP0UB5OknYDWRj1L6fMqJ0u0YADyo5AvMbk=;
        b=Im0wO3FroOywaGwnqt6QwhPNgyKu12HobXc6X7Kv6GTocZ8gMITUrKSmxO8CFExgQ4
         z7zFH5OVp4ySxKzWYSUcElvmhWBQ3Ilxus8ibOl5mhCDuyZIZb5Vmx/ghDOmqHJRsXMf
         awe56fSAH0nVxsrrqZ7mWkgURU6FZvUbz2s85h7/k8RdkgRwXB8I9sFBEkqljkme0hU4
         5El46/Z0x9/T7EjtP+BPYvUqVPMfiI96umoqXvjMZaMeESD/BAgzd2ASHsFrqh6QqDyQ
         cLbFWqmSUBUE9aswC5fd5MOegydMSwxiWO2yq1I7+0dZlIktYbB+fNWLSqT4uu+uJtuB
         3Wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qpNdCAKICP0UB5OknYDWRj1L6fMqJ0u0YADyo5AvMbk=;
        b=FdKmc6+xy6nvU4fMl8l9wb0eyzjcpRaxs37cvpiyyJpYPf/lAx7DFRWGsZFRh+88XI
         1dN8IH+lekzEisfwUmDp+ze7hWKwKGOkJn7rFZLvpDG2nDhhTBHmMff1cvd8ImFxagoP
         /pcsYgP11wkxoj70Xx79WIuy8X4IEw37elXVLIUQ/RohHUpA0sg4HPClvH6QYpkGX17+
         mlFgaPWmMsJB2062yL27BSgH1iioy801uspfbm9F5cyZrC3CwrUCqJ6TuakXbPoGMl7m
         fG+eW639YWrFok1AC4fTQIhHyvrg8p0IcHG/HMWnaXrSTj30AdWJFMWKw8Tlxyq5gtQ3
         bE7Q==
X-Gm-Message-State: AOAM531RPQPDu5j5dSU3QSK362nNNcZqCViWjUWtofULkOhSkexA2GU2
        NdlIUhoUxJfrhMemPBLwWQ==
X-Google-Smtp-Source: ABdhPJwMqSwv9CoQs618zagxu12ruiZ81PXNxzIrKu5O1jyRgqO+WxWc/UJ+dq+Gyhm47qwClWrN3A==
X-Received: by 2002:aca:3306:: with SMTP id z6mr10286814oiz.141.1612188318990;
        Mon, 01 Feb 2021 06:05:18 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id q6sm3967972otm.68.2021.02.01.06.05.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 06:05:17 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame without HSR tag
Date:   Mon,  1 Feb 2021 08:05:00 -0600
Message-Id: <20210201140503.130625-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210201140503.130625-1-george.mccollister@gmail.com>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generate supervision frame without HSR/PRP tag and rely on existing
code which inserts it later.
This will allow HSR/PRP tag insertions to be offloaded in the future.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/hsr/hsr_device.c  | 32 ++++----------------------------
 net/hsr/hsr_forward.c | 10 +++++++---
 2 files changed, 11 insertions(+), 31 deletions(-)

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
index cadfccd7876e..a5566b2245a0 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -454,8 +454,10 @@ static void handle_std_frame(struct sk_buff *skb,
 void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			 struct hsr_frame_info *frame)
 {
-	if (proto == htons(ETH_P_PRP) ||
-	    proto == htons(ETH_P_HSR)) {
+	struct hsr_port *port = frame->port_rcv;
+
+	if (port->type != HSR_PT_MASTER &&
+	    (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
 		frame->skb_prp = NULL;
@@ -473,8 +475,10 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 {
 	/* Supervision frame */
 	struct prp_rct *rct = skb_get_PRP_rct(skb);
+	struct hsr_port *port = frame->port_rcv;
 
-	if (rct &&
+	if (port->type != HSR_PT_MASTER &&
+	    rct &&
 	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
 		frame->skb_hsr = NULL;
 		frame->skb_std = NULL;
-- 
2.11.0

