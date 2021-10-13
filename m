Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE91F42B91B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhJMHcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbhJMHb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:31:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338DC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:29:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t16so6134047eds.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fvy5AX06Y7UxaD8VNz9YIf3Py2gHDWTYK1gTVeEoyHM=;
        b=I8b0onhP9hLd4w0rECCEXDSKjFxv89tDA4/AtcZ3mPf+HOsy0oBtBbN/Hp137zPdMn
         Qw+K5wEYCxpHMYUzqNzj+w60I8Pk5uZkAKsQNZeX/QOHuWgGTdXHx/O5qmjzLtviPviI
         OzBcwJGlgfJrNXOlV++IJMwvEmw13ZIyQ4hlUHsxbU6/6nBvDz2F9hr3wcq9Aj/4oxZE
         HYdxYtGWxeFlRLaygAXNt6cdEBHMpFqRiCfm14AKi91ewrbyN+VnLO2fhcGzZ94LbmlH
         +eEmgI5eNr7pyv6ErrvdE1jKPPQ0wDPyYbMuwApYOAxMqW66AV+4xmEatDFkfX4tCc5t
         CRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fvy5AX06Y7UxaD8VNz9YIf3Py2gHDWTYK1gTVeEoyHM=;
        b=Pk31XDPmfwusTtrVhnS61c9u9CRDQlpkWeGFIxwVRF3a+2DnuW0PoopRAkDRcb5rQQ
         FLrW8/PPMbVwViC/U3J/HicFBc3gLzVZ5gA030enq7yb4zbSPa5hbCVGGHrTloaMuAQr
         TJOkN7N9kuQlatJaBzX2QTIKHP4wrV33+vNsWb52sq9qE5YsHEeSjfsnD6SxKJDG1UZa
         A4uSVYjpO2r/jr7AII7CA+aYw5Zmse/2uYwRChncP/8BCJl/DR52NEZ+FNuc+gt7zjZn
         CvqQnWwfG1KbmdM1F4mJB2EJTC82eeYjPCuGaT8E17lgBvEZ1lI8HcsCbHJhaE3VOr5+
         E+sA==
X-Gm-Message-State: AOAM532rMIkJQUyXGcJ4RCKp5jhH9wjX7IPD51pWhmZQ4d9K3J6aVqon
        lOFQNKyGZ1Ytxbf5iEiwj5E=
X-Google-Smtp-Source: ABdhPJz+MslAKH8DxApfVa2CRy5g2PbPhT+6qLGfT1aFsu7/A3e6HG9dLp0OsgPVsKT2Jb3C0M54nw==
X-Received: by 2002:aa7:c2da:: with SMTP id m26mr7122098edp.89.1634110195343;
        Wed, 13 Oct 2021 00:29:55 -0700 (PDT)
Received: from md2k7s8c.fritz.box ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id n16sm7207356eda.93.2021.10.13.00.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:29:55 -0700 (PDT)
From:   Andreas Oetken <ennoerlangen@gmail.com>
X-Google-Original-From: Andreas Oetken <andreas.oetken@siemens-energy.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens-energy.com>
Subject: [PATCH] net: hsr: Add support for redbox supervision frames
Date:   Wed, 13 Oct 2021 09:29:51 +0200
Message-Id: <20211013072951.1697003-1-andreas.oetken@siemens-energy.com>
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
 net/hsr/hsr_device.c   |  8 ++++----
 net/hsr/hsr_forward.c  | 12 ++++++------
 net/hsr/hsr_framereg.c | 35 +++++++++++++++++++++++++++++++++++
 net/hsr/hsr_main.h     | 14 ++++++++++----
 4 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index fdd9c00082a8..b1677b0a9202 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -511,9 +511,9 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	}
 	spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
 
-	hsr_stag->HSR_TLV_type = type;
+	hsr_stag->tlv.HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
-	hsr_stag->HSR_TLV_length = hsr->prot_version ?
+	hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
 				sizeof(struct hsr_sup_payload) : 12;
 
 	/* Payload: MacAddressA */
@@ -560,8 +560,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
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
index d4d434b9f598..312d6a86c124 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -95,13 +95,13 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 			&((struct hsrv0_ethhdr_vlan_sp *)eth_hdr)->hsr_sup;
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
 		return false;
 
 	return true;
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index bb1351c38397..e7c6efbc41af 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -265,6 +265,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	struct hsr_port *port_rcv = frame->port_rcv;
 	struct hsr_priv *hsr = port_rcv->hsr;
 	struct hsr_sup_payload *hsr_sp;
+	struct hsr_sup_tlv *hsr_sup_tlv;
 	struct hsr_node *node_real;
 	struct sk_buff *skb = NULL;
 	struct list_head *node_db;
@@ -312,6 +313,40 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		/* Node has already been merged */
 		goto done;
 
+	/* Leave the first HSR sup payload. */
+	skb_pull(skb, sizeof(struct hsr_sup_payload));
+
+	/* Get second supervision tlv */
+	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
+	/* And check if it is a redbox mac TLV */
+	if (hsr_sup_tlv->HSR_TLV_type == PRP_TLV_REDBOX_MAC) {
+		/* We could stop here after pushing hsr_sup_payload,
+		 * or proceed and allow macaddress_B and for redboxes.
+		 */
+		/* Sanity check length */
+		if (hsr_sup_tlv->HSR_TLV_length != 6) {
+			skb_push(skb, sizeof(struct hsr_sup_payload));
+			goto done;
+		}
+		/* Leave the second HSR sup tlv. */
+		skb_pull(skb, sizeof(struct hsr_sup_tlv));
+
+		/* Get redbox mac address. */
+		hsr_sp = (struct hsr_sup_payload *)skb->data;
+
+		/* Check if redbox mac and node mac are equal. */
+		if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->macaddress_A)) {
+			/* This is a redbox supervision frame for a VDAN! */
+			/* Push second TLV and payload here */
+			skb_push(skb, sizeof(struct hsr_sup_payload) + sizeof(struct hsr_sup_tlv));
+			goto done;
+		}
+		/* Push second TLV here */
+		skb_push(skb, sizeof(struct hsr_sup_tlv));
+	}
+	/* Push payload here */
+	skb_push(skb, sizeof(struct hsr_sup_payload));
+
 	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
 	for (i = 0; i < HSR_PT_PORTS; i++) {
 		if (!node_curr->time_in_stale[i] &&
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index bbaef001d55d..fc3bed792ba7 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -43,6 +43,8 @@
 #define PRP_TLV_LIFE_CHECK_DD		   20
 /* PRP V1 life check for Duplicate Accept */
 #define PRP_TLV_LIFE_CHECK_DA		   21
+/* PRP V1 life redundancy box MAC address */
+#define PRP_TLV_REDBOX_MAC		   30
 
 /* HSR Tag.
  * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
@@ -95,14 +97,18 @@ struct hsr_vlan_ethhdr {
 	struct hsr_tag	hsr_tag;
 } __packed;
 
+struct hsr_sup_tlv {
+	__u8		HSR_TLV_type;
+	__u8		HSR_TLV_length;
+} __packed;
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

