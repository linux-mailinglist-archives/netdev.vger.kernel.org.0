Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A6F300812
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbhAVQBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbhAVQBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:01:00 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A939FC061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:18 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id a109so5526430otc.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qpNdCAKICP0UB5OknYDWRj1L6fMqJ0u0YADyo5AvMbk=;
        b=ecEG7Y9x1a2FrX2H3sqhSZT3mk2EhvcIwGIdmp+y+tFIM30Blwq/opebzHa19/0WKC
         nBn4010o7OdPxadZyUtkBGFyUbO++k0MtQ2wl4Kwj1U0HjDx2u77jw29QQIsmcSI+/CS
         k8hmiX2LH7BK/K8hTW8Jwj9uHNqIEK2SB6DUp29YzwQ1xs7lNTK25H5Te6PQeSi3STHx
         sOUXlp45LC2NgfpACr4ds8QXMaR+4gLbpNYcYI1qM0+xGyYVXofISuCQC5mDIk+yPFwT
         jzMKi16EyCoHv0lYB8MDCU1bJ7aKaWnlsdoMilABSyvn9SXYt9nsf2De+9dhcV9uIRXo
         tHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qpNdCAKICP0UB5OknYDWRj1L6fMqJ0u0YADyo5AvMbk=;
        b=jbH1DdF8J7SJ0RBKwcwpynhVKEMLmKk7vr1Y3bhwTWvfZuX4tLh3dT3lpY9N8rYU2f
         6ujPh8WBFL9iCQIfdVJRmQqubmQZp2cxrqSGMITCo6YA5tB6rhrvhELL62GJPcgF8m+d
         e0P/qQykvEsn74vGXN8kU63VfQt4F4WMWWG3K03T6PIicYiqHqEsDe3K9dJlTzyn8hMW
         wkte6c+ZAcJ2zJyGpA8UCkATuB3t5FIUQg1WVu/MHMQ6zFj+DTJ4wWLqrmLLAUJen3Gt
         Nq+z0dU4Z94EZv0SgBBYaliryL1gZzxehVTjFIDiGX3ZkcF6vuRRtBebkXFlLmE8TM1I
         Njjw==
X-Gm-Message-State: AOAM532hU5yMIBxTadefOvQBOaC9v3HauQnj2cIaswYGkn+N5OonCGZR
        TXyzoWa2FLGI0/H3wiH4+Q==
X-Google-Smtp-Source: ABdhPJwwR3KqcPGY9peAGbYDs4M0c/5k2DydYUqz212fShDpO9K7HxXYUvVGK2Kqq0MOZEXkGujVQw==
X-Received: by 2002:a9d:7b5a:: with SMTP id f26mr3583601oto.95.1611331218109;
        Fri, 22 Jan 2021 08:00:18 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y24sm1674942oos.44.2021.01.22.08.00.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:00:17 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 1/3] net: hsr: generate supervision frame without HSR tag
Date:   Fri, 22 Jan 2021 09:59:46 -0600
Message-Id: <20210122155948.5573-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210122155948.5573-1-george.mccollister@gmail.com>
References: <20210122155948.5573-1-george.mccollister@gmail.com>
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

