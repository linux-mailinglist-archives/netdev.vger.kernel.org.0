Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC3D30132E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 06:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbhAWFKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAWFKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:10:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED7C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 21:09:28 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g15so5177201pjd.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 21:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P3CC7sYWb/MS+EO/zY0Hx22yLx7P5Oy6ecV2MXZgk38=;
        b=P+OcGmjv8DVhNj3JoxvUB6zwHmfBjG5uUehTMWF/SWWujfk82YR22PVPCW0PqyePzD
         xsBGahZ/TaNmSsDBcs31hjlIpJRjlD3J4P42i1FfSwbKASqxMoud73bik+QFatHOCWwg
         L41kUgS0KLQf8Rg3rB+bnpKd9dKgwgpjABTm3JQxLfH6yxReNPnVOPXkpHEJ+nEko6/l
         ZXODGDBVBuNFcXCt4siPOZGAM/AYxK9JF6J/XqkYQrsYSybi4POX7hAp5RIlyNt+bw0w
         dVLNybL20rgzt1sowYU6A9jfPwUBEC4GFzpZuhGWIhpYUyIjVic9F0581fd7pdYFjMmU
         D2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P3CC7sYWb/MS+EO/zY0Hx22yLx7P5Oy6ecV2MXZgk38=;
        b=nEVAtMMfr5v1K06KgSPQY9i6Zcv7jI/FqS42OQlvepPk4wbVHdLfzJp7xe9w1hzxlG
         BO/XP5L0u07kbcqWUFC7wvO53bMSMNh8xg39vQ4GO/SR2JzBLQfdlDxWl7OOWz7lfEsV
         4x0PT7n8+Wyr91b9m6QDtX5jw3bIqBxfa+Jfso8/S/D6+iAUhZFKYOdltE7PG5UaloBx
         uY79mC38l9t3W/0EUEVroBluJ9t65Iuat2JzBk58J0hRCD3U5nCzA5G6tnKJ6rZ7Veok
         XT1QaxRYXKYJZsCD2+r5kG+qCJI71UbneTv8A32gfjv2abxE8dDeb5wPoIcPW81ehJxl
         xWcg==
X-Gm-Message-State: AOAM531cs6qB1XsPgmzl3o8vihPRggacSxjJysdi6hDZy2r07QYTP/2s
        vJJycp8R+VLKwdRM1F1gHGg=
X-Google-Smtp-Source: ABdhPJwSKh7tuzDP81nksBVxnQJMBy4DimjCwe/zl09CdkIjJx0ogWwckXCuR1BORqknGGdT0HFpmA==
X-Received: by 2002:a17:902:c085:b029:de:ad05:8e90 with SMTP id j5-20020a170902c085b02900dead058e90mr8317751pld.42.1611378567951;
        Fri, 22 Jan 2021 21:09:27 -0800 (PST)
Received: from hyd1358.marvell.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id w11sm10257824pge.28.2021.01.22.21.09.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 21:09:27 -0800 (PST)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Support ESP/AH RSS hashing
Date:   Sat, 23 Jan 2021 10:39:12 +0530
Message-Id: <1611378552-13288-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Support SPI and sequence number fields of
ESP/AH header to be hashed for RSS. By default
ESP/AH fields are not considered for RSS and
needs to be set explicitly as below:
ethtool -U eth0 rx-flow-hash esp4 sdfn
or
ethtool -U eth0 rx-flow-hash ah4 sdfn
or
ethtool -U eth0 rx-flow-hash esp6 sdfn
or
ethtool -U eth0 rx-flow-hash ah6 sdfn

To disable hashing of ESP fields:
ethtool -U eth0 rx-flow-hash esp4 sd
or
ethtool -U eth0 rx-flow-hash ah4 sd
or
ethtool -U eth0 rx-flow-hash esp6 sd
or
ethtool -U eth0 rx-flow-hash ah6 sd

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 27 ++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 37 +++++++++++++++++++++-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f919283..89e93eb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -717,6 +717,8 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC BIT(17)
 #define NIX_FLOW_KEY_TYPE_VLAN		BIT(20)
 #define NIX_FLOW_KEY_TYPE_IPV4_PROTO	BIT(21)
+#define NIX_FLOW_KEY_TYPE_AH		BIT(22)
+#define NIX_FLOW_KEY_TYPE_ESP		BIT(23)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index a8dfbb6..b54753e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2580,6 +2580,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	struct nix_rx_flowkey_alg *field;
 	struct nix_rx_flowkey_alg tmp;
 	u32 key_type, valid_key;
+	int l4_key_offset;
 
 	if (!alg)
 		return -EINVAL;
@@ -2712,6 +2713,12 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 				field_marker = false;
 				keyoff_marker = false;
 			}
+
+			/* TCP/UDP/SCTP and ESP/AH falls at same offset so
+			 * remember the TCP key offset of 40 byte hash key.
+			 */
+			if (key_type == NIX_FLOW_KEY_TYPE_TCP)
+				l4_key_offset = key_off;
 			break;
 		case NIX_FLOW_KEY_TYPE_NVGRE:
 			field->lid = NPC_LID_LD;
@@ -2783,11 +2790,31 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			field->ltype_mask = 0xF;
 			field->fn_mask = 1; /* Mask out the first nibble */
 			break;
+		case NIX_FLOW_KEY_TYPE_AH:
+		case NIX_FLOW_KEY_TYPE_ESP:
+			field->hdr_offset = 0;
+			field->bytesm1 = 7; /* SPI + sequence number */
+			field->ltype_mask = 0xF;
+			field->lid = NPC_LID_LE;
+			field->ltype_match = NPC_LT_LE_ESP;
+			if (key_type == NIX_FLOW_KEY_TYPE_AH) {
+				field->lid = NPC_LID_LD;
+				field->ltype_match = NPC_LT_LD_AH;
+				field->hdr_offset = 4;
+				keyoff_marker = false;
+			}
+			break;
 		}
 		field->ena = 1;
 
 		/* Found a valid flow key type */
 		if (valid_key) {
+			/* Use the key offset of TCP/UDP/SCTP fields
+			 * for ESP/AH fields.
+			 */
+			if (key_type == NIX_FLOW_KEY_TYPE_ESP ||
+			    key_type == NIX_FLOW_KEY_TYPE_AH)
+				key_off = l4_key_offset;
 			field->key_offset = key_off;
 			memcpy(&alg[nr_field], field, sizeof(*field));
 			max_key_off = max(max_key_off, field->bytesm1 + 1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index aaba045..e0199f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -448,10 +448,14 @@ static int otx2_get_rss_hash_opts(struct otx2_nic *pfvf,
 			nfc->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
 		break;
 	case AH_ESP_V4_FLOW:
+	case AH_ESP_V6_FLOW:
+		if (rss->flowkey_cfg & NIX_FLOW_KEY_TYPE_ESP)
+			nfc->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
 	case AH_V4_FLOW:
 	case ESP_V4_FLOW:
 	case IPV4_FLOW:
-	case AH_ESP_V6_FLOW:
+		break;
 	case AH_V6_FLOW:
 	case ESP_V6_FLOW:
 	case IPV6_FLOW:
@@ -459,6 +463,7 @@ static int otx2_get_rss_hash_opts(struct otx2_nic *pfvf,
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
 }
 
@@ -527,6 +532,36 @@ static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
 			return -EINVAL;
 		}
 		break;
+	case AH_ESP_V4_FLOW:
+	case AH_ESP_V6_FLOW:
+		switch (nfc->data & rxh_l4) {
+		case 0:
+			rss_cfg &= ~(NIX_FLOW_KEY_TYPE_ESP |
+				     NIX_FLOW_KEY_TYPE_AH);
+			rss_cfg |= NIX_FLOW_KEY_TYPE_VLAN |
+				   NIX_FLOW_KEY_TYPE_IPV4_PROTO;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			/* If VLAN hashing is also requested for ESP then do not
+			 * allow because of hardware 40 bytes flow key limit.
+			 */
+			if (rss_cfg & NIX_FLOW_KEY_TYPE_VLAN) {
+				netdev_err(pfvf->netdev,
+					   "RSS hash of ESP or AH with VLAN is not supported\n");
+				return -EOPNOTSUPP;
+			}
+
+			rss_cfg |= NIX_FLOW_KEY_TYPE_ESP | NIX_FLOW_KEY_TYPE_AH;
+			/* Disable IPv4 proto hashing since IPv6 SA+DA(32 bytes)
+			 * and ESP SPI+sequence(8 bytes) uses hardware maximum
+			 * limit of 40 byte flow key.
+			 */
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_IPV4_PROTO;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
 	case IPV4_FLOW:
 	case IPV6_FLOW:
 		rss_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6;
-- 
2.7.4

