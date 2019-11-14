Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739C9FBFA2
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfKNF1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:54 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34541 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfKNF1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:54 -0500
Received: by mail-pg1-f196.google.com with SMTP id z188so2964922pgb.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YNUl3xbIYN0LUTo26vqR/FdsPfkLSNskEkJz0XjG2e8=;
        b=J82uRkv7MmVYe7yTPLvCrkcbHPpwd5KsWOo/NIsit67kPMkfKPbwqDWNIY941JlXCc
         h3Z8iqxGfxnYSRTNAGDebAunazQ1zPy7eRcbqW6UoleIA5hQRVYEjw1O+WXyD0jBxv0J
         Msm9X7uJnifwlj/8ql1YbLH6QFcwYcSt8wLPXEEzHkGp9/hJKIqqvqeSsgw6x3qdW7B6
         uDIL4/UTEg2ljdgapAr8p37M5WDAhjnF3gv4EtT7GLmhgSfSRbDyrLkKVsGXQF3OgWLQ
         8WiSgEHW5wlo9mFolKCfD+XqIC3tyMFgVXLhvTxqa7xJXd8sORXAQcAwYzbKuz9uJWqZ
         dGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YNUl3xbIYN0LUTo26vqR/FdsPfkLSNskEkJz0XjG2e8=;
        b=GObkb5kAoqppJSmSug8BzvA+7Tv6Vb8ABkaKn47Bj5riWOMx2bQ4xllqnXAlPHjW3N
         6AwaiachTen0YdCQYJAf4ghhW5HrVFDIDGwUTcUb4nHHbIGqPHSn7z6IJq+0qXcDz0AZ
         AiHvi0E4TtWxXJcQBbn2FvfH4lsBSOXUJi4tgIzEwKHlib2QSfA9vEE9qONP4MYNzo8d
         D2VvhEnrlc7druig/Qa5waOAB1NltpH42lN8KfRQUqpGdMeIZGJEdFpJx4MZoqH8KViD
         wGJyBsSQKH1nPDe6kp3SF2vuC5AlSdUY2H0ugMPw4+72Xlur4HblSyQ+zYRP4gdaxQpF
         n/2A==
X-Gm-Message-State: APjAAAU6KUvOG3AkwpJYN0TMcp+oGr+nhEu0q+RpROFE+C9GCe8wFhz0
        WOtypfUrvVmfFcC9+zO2Bd9yQtq7IUs=
X-Google-Smtp-Source: APXvYqz9dBYo0JkllzuM/C4/Z3fFbVFQGLPVk67bTOtjpSWYxVUswPQDUPGNC/IlgxjacYGlobqCOg==
X-Received: by 2002:a62:8748:: with SMTP id i69mr6164925pfe.224.1573709272787;
        Wed, 13 Nov 2019 21:27:52 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:52 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Kiran Kumar K <kirankumark@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 13/18] octeontx2-af: Add more RSS algorithms
Date:   Thu, 14 Nov 2019 10:56:28 +0530
Message-Id: <1573709193-15446-14-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

This patch adds support for few more RSS key types for flow key
algorithm to compute rss hash index.

Following flow key types have been added.
- Tunnel types like NVGRE, VXLAN, GENEVE.
- L2 offload type ETH_DMAC, Here we will consider only DMAC 6 bytes.
- And extension header IPV6_EXT (1 byte followed by IPV6 header
- Hashing inner protocol fields for inner DMAC, IPv4/v6, TCP, UDP, SCTP.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  12 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 113 +++++++++++++++++++--
 2 files changed, 114 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 94c198a..de3fe25 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -580,6 +580,18 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_TCP	BIT(3)
 #define NIX_FLOW_KEY_TYPE_UDP	BIT(4)
 #define NIX_FLOW_KEY_TYPE_SCTP	BIT(5)
+#define NIX_FLOW_KEY_TYPE_NVGRE    BIT(6)
+#define NIX_FLOW_KEY_TYPE_VXLAN    BIT(7)
+#define NIX_FLOW_KEY_TYPE_GENEVE   BIT(8)
+#define NIX_FLOW_KEY_TYPE_ETH_DMAC BIT(9)
+#define NIX_FLOW_KEY_TYPE_IPV6_EXT BIT(10)
+#define NIX_FLOW_KEY_TYPE_GTPU       BIT(11)
+#define NIX_FLOW_KEY_TYPE_INNR_IPV4     BIT(12)
+#define NIX_FLOW_KEY_TYPE_INNR_IPV6     BIT(13)
+#define NIX_FLOW_KEY_TYPE_INNR_TCP      BIT(14)
+#define NIX_FLOW_KEY_TYPE_INNR_UDP      BIT(15)
+#define NIX_FLOW_KEY_TYPE_INNR_SCTP     BIT(16)
+#define NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC BIT(17)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index b881808..994ed71 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2032,51 +2032,82 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 		if (field_marker)
 			memset(&tmp, 0, sizeof(tmp));
 
+		field_marker = true;
+		keyoff_marker = true;
 		switch (key_type) {
 		case NIX_FLOW_KEY_TYPE_PORT:
 			field->sel_chan = true;
 			/* This should be set to 1, when SEL_CHAN is set */
 			field->bytesm1 = 1;
-			field_marker = true;
-			keyoff_marker = true;
 			break;
 		case NIX_FLOW_KEY_TYPE_IPV4:
+		case NIX_FLOW_KEY_TYPE_INNR_IPV4:
 			field->lid = NPC_LID_LC;
 			field->ltype_match = NPC_LT_LC_IP;
+			if (key_type == NIX_FLOW_KEY_TYPE_INNR_IPV4) {
+				field->lid = NPC_LID_LG;
+				field->ltype_match = NPC_LT_LG_TU_IP;
+			}
 			field->hdr_offset = 12; /* SIP offset */
 			field->bytesm1 = 7; /* SIP + DIP, 8 bytes */
 			field->ltype_mask = 0xF; /* Match only IPv4 */
-			field_marker = true;
 			keyoff_marker = false;
 			break;
 		case NIX_FLOW_KEY_TYPE_IPV6:
+		case NIX_FLOW_KEY_TYPE_INNR_IPV6:
 			field->lid = NPC_LID_LC;
 			field->ltype_match = NPC_LT_LC_IP6;
+			if (key_type == NIX_FLOW_KEY_TYPE_INNR_IPV6) {
+				field->lid = NPC_LID_LG;
+				field->ltype_match = NPC_LT_LG_TU_IP6;
+			}
 			field->hdr_offset = 8; /* SIP offset */
 			field->bytesm1 = 31; /* SIP + DIP, 32 bytes */
 			field->ltype_mask = 0xF; /* Match only IPv6 */
-			field_marker = true;
-			keyoff_marker = true;
 			break;
 		case NIX_FLOW_KEY_TYPE_TCP:
 		case NIX_FLOW_KEY_TYPE_UDP:
 		case NIX_FLOW_KEY_TYPE_SCTP:
+		case NIX_FLOW_KEY_TYPE_INNR_TCP:
+		case NIX_FLOW_KEY_TYPE_INNR_UDP:
+		case NIX_FLOW_KEY_TYPE_INNR_SCTP:
 			field->lid = NPC_LID_LD;
+			if (key_type == NIX_FLOW_KEY_TYPE_INNR_TCP ||
+			    key_type == NIX_FLOW_KEY_TYPE_INNR_UDP ||
+			    key_type == NIX_FLOW_KEY_TYPE_INNR_SCTP)
+				field->lid = NPC_LID_LH;
 			field->bytesm1 = 3; /* Sport + Dport, 4 bytes */
-			if (key_type == NIX_FLOW_KEY_TYPE_TCP && valid_key) {
+
+			/* Enum values for NPC_LID_LD and NPC_LID_LG are same,
+			 * so no need to change the ltype_match, just change
+			 * the lid for inner protocols
+			 */
+			BUILD_BUG_ON((int)NPC_LT_LD_TCP !=
+				     (int)NPC_LT_LH_TU_TCP);
+			BUILD_BUG_ON((int)NPC_LT_LD_UDP !=
+				     (int)NPC_LT_LH_TU_UDP);
+			BUILD_BUG_ON((int)NPC_LT_LD_SCTP !=
+				     (int)NPC_LT_LH_TU_SCTP);
+
+			if ((key_type == NIX_FLOW_KEY_TYPE_TCP ||
+			     key_type == NIX_FLOW_KEY_TYPE_INNR_TCP) &&
+			    valid_key) {
 				field->ltype_match |= NPC_LT_LD_TCP;
 				group_member = true;
-			} else if (key_type == NIX_FLOW_KEY_TYPE_UDP &&
+			} else if ((key_type == NIX_FLOW_KEY_TYPE_UDP ||
+				    key_type == NIX_FLOW_KEY_TYPE_INNR_UDP) &&
 				   valid_key) {
 				field->ltype_match |= NPC_LT_LD_UDP;
 				group_member = true;
-			} else if (key_type == NIX_FLOW_KEY_TYPE_SCTP &&
+			} else if ((key_type == NIX_FLOW_KEY_TYPE_SCTP ||
+				    key_type == NIX_FLOW_KEY_TYPE_INNR_SCTP) &&
 				   valid_key) {
 				field->ltype_match |= NPC_LT_LD_SCTP;
 				group_member = true;
 			}
 			field->ltype_mask = ~field->ltype_match;
-			if (key_type == NIX_FLOW_KEY_TYPE_SCTP) {
+			if (key_type == NIX_FLOW_KEY_TYPE_SCTP ||
+			    key_type == NIX_FLOW_KEY_TYPE_INNR_SCTP) {
 				/* Handle the case where any of the group item
 				 * is enabled in the group but not the final one
 				 */
@@ -2084,13 +2115,73 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 					valid_key = true;
 					group_member = false;
 				}
-				field_marker = true;
-				keyoff_marker = true;
 			} else {
 				field_marker = false;
 				keyoff_marker = false;
 			}
 			break;
+		case NIX_FLOW_KEY_TYPE_NVGRE:
+			field->lid = NPC_LID_LD;
+			field->hdr_offset = 4; /* VSID offset */
+			field->bytesm1 = 2;
+			field->ltype_match = NPC_LT_LD_NVGRE;
+			field->ltype_mask = 0xF;
+			break;
+		case NIX_FLOW_KEY_TYPE_VXLAN:
+		case NIX_FLOW_KEY_TYPE_GENEVE:
+			field->lid = NPC_LID_LE;
+			field->bytesm1 = 2;
+			field->hdr_offset = 4;
+			field->ltype_mask = 0xF;
+			field_marker = false;
+			keyoff_marker = false;
+
+			if (key_type == NIX_FLOW_KEY_TYPE_VXLAN && valid_key) {
+				field->ltype_match |= NPC_LT_LE_VXLAN;
+				group_member = true;
+			}
+
+			if (key_type == NIX_FLOW_KEY_TYPE_GENEVE && valid_key) {
+				field->ltype_match |= NPC_LT_LE_GENEVE;
+				group_member = true;
+			}
+
+			if (key_type == NIX_FLOW_KEY_TYPE_GENEVE) {
+				if (group_member) {
+					field->ltype_mask = ~field->ltype_match;
+					field_marker = true;
+					keyoff_marker = true;
+					valid_key = true;
+					group_member = false;
+				}
+			}
+			break;
+		case NIX_FLOW_KEY_TYPE_ETH_DMAC:
+		case NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC:
+			field->lid = NPC_LID_LA;
+			field->ltype_match = NPC_LT_LA_ETHER;
+			if (key_type == NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC) {
+				field->lid = NPC_LID_LF;
+				field->ltype_match = NPC_LT_LF_TU_ETHER;
+			}
+			field->hdr_offset = 0;
+			field->bytesm1 = 5; /* DMAC 6 Byte */
+			field->ltype_mask = 0xF;
+			break;
+		case NIX_FLOW_KEY_TYPE_IPV6_EXT:
+			field->lid = NPC_LID_LC;
+			field->hdr_offset = 40; /* IPV6 hdr */
+			field->bytesm1 = 0; /* 1 Byte ext hdr*/
+			field->ltype_match = NPC_LT_LC_IP6_EXT;
+			field->ltype_mask = 0xF;
+			break;
+		case NIX_FLOW_KEY_TYPE_GTPU:
+			field->lid = NPC_LID_LE;
+			field->hdr_offset = 4;
+			field->bytesm1 = 3; /* 4 bytes TID*/
+			field->ltype_match = NPC_LT_LE_GTPU;
+			field->ltype_mask = 0xF;
+			break;
 		}
 		field->ena = 1;
 
-- 
2.7.4

