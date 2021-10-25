Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42730439EC6
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhJYS7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbhJYS7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:59:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4C6C061745;
        Mon, 25 Oct 2021 11:57:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 5so3310676edw.7;
        Mon, 25 Oct 2021 11:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSrwdKn4j1IR6tWs2e+m5mktsAHe2q2d8pJjt8+EW9M=;
        b=M2OihwE61e9vwvCtP0hKhTORY1FYqqA6DpTLBSEJA8udmcxBeM+bm6OpuKIvmm3sZk
         tNWCh/Jn3RZGxr0Blv9FC9o4/C7+fxLtbKbEMfns57FRM3Dz8UyBYhl38YdTmQ6DI8ME
         xwHaMQ2QzgyeFj/KuNaVS4kJZlnEY5UidUUnSJvuOpP8Ysqq8GM5CrMGlt4hCTBtNr/i
         axdjdvwMB6JkY8LgAh6JHHOMx7oOsfVdXixyL3vpXMUT9lgPpV9eehTmhvBImaCZ7Ywa
         jGP6ypAx2UdecLGUmrWe2Ft8h0ysN2rC810M9E2ucZVeZ9bkRVViZpmvngybdzOAUi5V
         p2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSrwdKn4j1IR6tWs2e+m5mktsAHe2q2d8pJjt8+EW9M=;
        b=Qtq6ZEjY4Bxkju1uRKfXOkD2ufFP1r2aDcdWcRI35ETQ82A/kGWvdXJvcJbAGxvoih
         w357bEeRPVxob27NJWouX1g/pFdPAo3KYb25c+4dooP1ZcLvd9u4I0zyrEId6Dq/bND1
         DQn0Go5/xoJVxjAxkVS6Uy+1W6rsWYr56NH612pnu7k/sCXA4Zf2/LZ72eRHbeDNWRsR
         /ThhQ0coFWQDXADVewVfTt8XRzGU7X4FQwcefXd8f+b2Qy6/ZsJooIVqvOfY9bntfqK7
         d6n6lkQJq8LCrqcLXuXHQpWGyOyBZliYlsGyvc2GyneGuFjNSKKyzp7NjuafKDbgEnZK
         hE5g==
X-Gm-Message-State: AOAM532HL/7MRfND4o6BYFrawOi5k4Yhsv/HOuympghNhC6Lc1tFXElj
        URgl9yXsRPG3QdKKq8/rbIU=
X-Google-Smtp-Source: ABdhPJzXvYoVEakp5AvCinSrBcXrIuJRh8ZUuSMBOQZRASwTiI2F+ICDZknF7KwQOhkD+G+bmgbt4w==
X-Received: by 2002:a17:907:9714:: with SMTP id jg20mr5292236ejc.318.1635188233672;
        Mon, 25 Oct 2021 11:57:13 -0700 (PDT)
Received: from md2k7s8c.fritz.box ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id v15sm9381940edi.89.2021.10.25.11.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 11:57:13 -0700 (PDT)
From:   Andreas Oetken <ennoerlangen@gmail.com>
X-Google-Original-From: Andreas Oetken <andreas.oetken@siemens-energy.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Oetken <ennoerlangen@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens-energy.com>
Subject: [PATCH net-next v2] net: hsr: Add support for redbox supervision frames
Date:   Mon, 25 Oct 2021 20:56:18 +0200
Message-Id: <20211025185618.3020774-1-andreas.oetken@siemens-energy.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

added support for the redbox supervision frames
as defined in the IEC-62439-3:2018.

Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
---
 net/hsr/hsr_device.c   |  8 +++---
 net/hsr/hsr_forward.c  | 54 ++++++++++++++++++++++++++++++++-----
 net/hsr/hsr_framereg.c | 61 ++++++++++++++++++++++++++++++++++--------
 net/hsr/hsr_main.h     | 16 +++++++----
 4 files changed, 113 insertions(+), 26 deletions(-)

Changed in V2
- rebased on net-next
- updated is_supervision frame to include check for redbox supervision
  frames
- fixed unnecessary packing of struct
- used u8 instead of __u8 for non uAPI fields

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index e00fbb16391f6..737e4f17e1c6d 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -309,9 +309,9 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	}
 	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 
-	hsr_stag->HSR_TLV_type = type;
+	hsr_stag->tlv.HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
-	hsr_stag->HSR_TLV_length = hsr->prot_version ?
+	hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
 				sizeof(struct hsr_sup_payload) : 12;
 
 	/* Payload: MacAddressA */
@@ -350,8 +350,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
 	hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 	hsr->sup_sequence_nr++;
-	hsr_stag->HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
-	hsr_stag->HSR_TLV_length = sizeof(struct hsr_sup_payload);
+	hsr_stag->tlv.HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
+	hsr_stag->tlv.HSR_TLV_length = sizeof(struct hsr_sup_payload);
 
 	/* Payload: MacAddressA */
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ceb8afb2a62f4..e59cbb4f0cd15 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -37,6 +37,8 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	struct ethhdr *eth_hdr;
 	struct hsr_sup_tag *hsr_sup_tag;
 	struct hsrv1_ethhdr_sp *hsr_V1_hdr;
+	struct hsr_sup_tlv *hsr_sup_tlv;
+	u16 total_length = 0;
 
 	WARN_ON_ONCE(!skb_mac_header_was_set(skb));
 	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
@@ -53,23 +55,63 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 	/* Get the supervision header from correct location. */
 	if (eth_hdr->h_proto == htons(ETH_P_HSR)) { /* Okay HSRv1. */
+		total_length = sizeof(struct hsrv1_ethhdr_sp);
+		if (!pskb_may_pull(skb, total_length))
+			return false;
+
 		hsr_V1_hdr = (struct hsrv1_ethhdr_sp *)skb_mac_header(skb);
 		if (hsr_V1_hdr->hsr.encap_proto != htons(ETH_P_PRP))
 			return false;
 
 		hsr_sup_tag = &hsr_V1_hdr->hsr_sup;
 	} else {
+		total_length = sizeof(struct hsrv0_ethhdr_sp);
+		if (!pskb_may_pull(skb, total_length))
+			return false;
+
 		hsr_sup_tag =
 		     &((struct hsrv0_ethhdr_sp *)skb_mac_header(skb))->hsr_sup;
 	}
 
-	if (hsr_sup_tag->HSR_TLV_type != HSR_TLV_ANNOUNCE &&
-	    hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
-	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
-	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
+	if (hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_ANNOUNCE &&
+	    hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
+	    hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
+	    hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
 		return false;
-	if (hsr_sup_tag->HSR_TLV_length != 12 &&
-	    hsr_sup_tag->HSR_TLV_length != sizeof(struct hsr_sup_payload))
+	if (hsr_sup_tag->tlv.HSR_TLV_length != 12 &&
+	    hsr_sup_tag->tlv.HSR_TLV_length != sizeof(struct hsr_sup_payload))
+		return false;
+
+	/* Get next tlv */
+	total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tag->tlv.HSR_TLV_length;
+	if (!pskb_may_pull(skb, total_length))
+		return false;
+	skb_pull(skb, total_length);
+	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
+	skb_push(skb, total_length);
+
+	/* if this is a redbox supervision frame we need to verify
+	 * that more data is available
+	 */
+	if (hsr_sup_tlv->HSR_TLV_type == PRP_TLV_REDBOX_MAC) {
+		/* tlv length must be a length of a mac address */
+		if (hsr_sup_tlv->HSR_TLV_length != sizeof(struct hsr_sup_payload))
+			return false;
+
+		/* make sure another tlv follows */
+		total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tlv->HSR_TLV_length;
+		if (!pskb_may_pull(skb, total_length))
+			return false;
+
+		/* get next tlv */
+		skb_pull(skb, total_length);
+		hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
+		skb_push(skb, total_length);
+	}
+
+	/* end of tlvs must follow at the end */
+	if (hsr_sup_tlv->HSR_TLV_type == HSR_TLV_EOT &&
+	    hsr_sup_tlv->HSR_TLV_length != 0)
 		return false;
 
 	return true;
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index e31949479305e..80ee3c08dba74 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -265,11 +265,14 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	struct hsr_port *port_rcv = frame->port_rcv;
 	struct hsr_priv *hsr = port_rcv->hsr;
 	struct hsr_sup_payload *hsr_sp;
+	struct hsr_sup_tlv *hsr_sup_tlv;
 	struct hsr_node *node_real;
 	struct sk_buff *skb = NULL;
 	struct list_head *node_db;
 	struct ethhdr *ethhdr;
 	int i;
+	unsigned int pull_size = 0;
+	unsigned int total_pull_size = 0;
 
 	/* Here either frame->skb_hsr or frame->skb_prp should be
 	 * valid as supervision frame always will have protocol
@@ -284,18 +287,26 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	if (!skb)
 		return;
 
-	ethhdr = (struct ethhdr *)skb_mac_header(skb);
-
 	/* Leave the ethernet header. */
-	skb_pull(skb, sizeof(struct ethhdr));
+	pull_size = sizeof(struct ethhdr);
+	skb_pull(skb, pull_size);
+	total_pull_size += pull_size;
+
+	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 
 	/* And leave the HSR tag. */
-	if (ethhdr->h_proto == htons(ETH_P_HSR))
-		skb_pull(skb, sizeof(struct hsr_tag));
+	if (ethhdr->h_proto == htons(ETH_P_HSR)) {
+		pull_size = sizeof(struct ethhdr);
+		skb_pull(skb, pull_size);
+		total_pull_size += pull_size;
+	}
 
 	/* And leave the HSR sup tag. */
-	skb_pull(skb, sizeof(struct hsr_sup_tag));
+	pull_size = sizeof(struct hsr_tag);
+	skb_pull(skb, pull_size);
+	total_pull_size += pull_size;
 
+	/* get HSR sup payload */
 	hsr_sp = (struct hsr_sup_payload *)skb->data;
 
 	/* Merge node_curr (registered on macaddress_B) into node_real */
@@ -312,6 +323,37 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		/* Node has already been merged */
 		goto done;
 
+	/* Leave the first HSR sup payload. */
+	pull_size = sizeof(struct hsr_sup_payload);
+	skb_pull(skb, pull_size);
+	total_pull_size += pull_size;
+
+	/* Get second supervision tlv */
+	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
+	/* And check if it is a redbox mac TLV */
+	if (hsr_sup_tlv->HSR_TLV_type == PRP_TLV_REDBOX_MAC) {
+		/* We could stop here after pushing hsr_sup_payload,
+		 * or proceed and allow macaddress_B and for redboxes.
+		 */
+		/* Sanity check length */
+		if (hsr_sup_tlv->HSR_TLV_length != 6)
+			goto done;
+
+		/* Leave the second HSR sup tlv. */
+		pull_size = sizeof(struct hsr_sup_tlv);
+		skb_pull(skb, pull_size);
+		total_pull_size += pull_size;
+
+		/* Get redbox mac address. */
+		hsr_sp = (struct hsr_sup_payload *)skb->data;
+
+		/* Check if redbox mac and node mac are equal. */
+		if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->macaddress_A)) {
+			/* This is a redbox supervision frame for a VDAN! */
+			goto done;
+		}
+	}
+
 	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
 	for (i = 0; i < HSR_PT_PORTS; i++) {
 		if (!node_curr->time_in_stale[i] &&
@@ -331,11 +373,8 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	kfree_rcu(node_curr, rcu_head);
 
 done:
-	/* PRP uses v0 header */
-	if (ethhdr->h_proto == htons(ETH_P_HSR))
-		skb_push(skb, sizeof(struct hsrv1_ethhdr_sp));
-	else
-		skb_push(skb, sizeof(struct hsrv0_ethhdr_sp));
+	/* Push back here */
+	skb_push(skb, total_pull_size);
 }
 
 /* 'skb' is a frame meant for this host, that is to be passed to upper layers.
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 53d1f7a824630..043e4e9a16945 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -35,13 +35,15 @@
  * HSR_NODE_FORGET_TIME?
  */
 #define PRUNE_PERIOD			 3000 /* ms */
-
+#define HSR_TLV_EOT				   0  /* End of TLVs */
 #define HSR_TLV_ANNOUNCE		   22
 #define HSR_TLV_LIFE_CHECK		   23
 /* PRP V1 life check for Duplicate discard */
 #define PRP_TLV_LIFE_CHECK_DD		   20
 /* PRP V1 life check for Duplicate Accept */
 #define PRP_TLV_LIFE_CHECK_DA		   21
+/* PRP V1 life redundancy box MAC address */
+#define PRP_TLV_REDBOX_MAC		   30
 
 /* HSR Tag.
  * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
@@ -94,14 +96,18 @@ struct hsr_vlan_ethhdr {
 	struct hsr_tag	hsr_tag;
 } __packed;
 
+struct hsr_sup_tlv {
+	u8		HSR_TLV_type;
+	u8		HSR_TLV_length;
+};
+
 /* HSR/PRP Supervision Frame data types.
  * Field names as defined in the IEC:2010 standard for HSR.
  */
 struct hsr_sup_tag {
-	__be16		path_and_HSR_ver;
-	__be16		sequence_nr;
-	__u8		HSR_TLV_type;
-	__u8		HSR_TLV_length;
+	__be16				path_and_HSR_ver;
+	__be16				sequence_nr;
+	struct hsr_sup_tlv  tlv;
 } __packed;
 
 struct hsr_sup_payload {
-- 
2.30.2

