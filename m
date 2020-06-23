Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4B205FAB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391565AbgFWUet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:49 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:39832 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgFWUeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:46 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYhn2019531;
        Tue, 23 Jun 2020 13:34:44 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 04/12] cxgb4: parse TC-U32 key values and masks natively
Date:   Wed, 24 Jun 2020 01:51:34 +0530
Message-Id: <c261e5bd334aca39ae7418ac215c1a0056833840.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC-U32 passes all keys values and masks in __be32 format. The parser
already expects this and hence pass the value and masks in __be32
natively to the parser.

Fixes following sparse warnings in several places:
cxgb4_tc_u32.c:57:21: warning: incorrect type in assignment (different base
types)
cxgb4_tc_u32.c:57:21:    expected unsigned int [usertype] val
cxgb4_tc_u32.c:57:21:    got restricted __be32 [usertype] val
cxgb4_tc_u32_parse.h:48:24: warning: cast to restricted __be32

Fixes: 2e8aad7bf203 ("cxgb4: add parser to translate u32 filters to internal spec")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  18 +--
 .../chelsio/cxgb4/cxgb4_tc_u32_parse.h        | 122 ++++++++++++------
 2 files changed, 91 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index 3f3c11e54d97..dede02505ceb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -48,7 +48,7 @@ static int fill_match_fields(struct adapter *adap,
 			     bool next_header)
 {
 	unsigned int i, j;
-	u32 val, mask;
+	__be32 val, mask;
 	int off, err;
 	bool found;
 
@@ -228,7 +228,7 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 		const struct cxgb4_next_header *next;
 		bool found = false;
 		unsigned int i, j;
-		u32 val, mask;
+		__be32 val, mask;
 		int off;
 
 		if (t->table[link_uhtid - 1].link_handle) {
@@ -242,10 +242,10 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 
 		/* Try to find matches that allow jumps to next header. */
 		for (i = 0; next[i].jump; i++) {
-			if (next[i].offoff != cls->knode.sel->offoff ||
-			    next[i].shift != cls->knode.sel->offshift ||
-			    next[i].mask != cls->knode.sel->offmask ||
-			    next[i].offset != cls->knode.sel->off)
+			if (next[i].sel.offoff != cls->knode.sel->offoff ||
+			    next[i].sel.offshift != cls->knode.sel->offshift ||
+			    next[i].sel.offmask != cls->knode.sel->offmask ||
+			    next[i].sel.off != cls->knode.sel->off)
 				continue;
 
 			/* Found a possible candidate.  Find a key that
@@ -257,9 +257,9 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 				val = cls->knode.sel->keys[j].val;
 				mask = cls->knode.sel->keys[j].mask;
 
-				if (next[i].match_off == off &&
-				    next[i].match_val == val &&
-				    next[i].match_mask == mask) {
+				if (next[i].key.off == off &&
+				    next[i].key.val == val &&
+				    next[i].key.mask == mask) {
 					found = true;
 					break;
 				}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
index 125868c6770a..f59dd4b2ae6f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
@@ -38,12 +38,12 @@
 struct cxgb4_match_field {
 	int off; /* Offset from the beginning of the header to match */
 	/* Fill the value/mask pair in the spec if matched */
-	int (*val)(struct ch_filter_specification *f, u32 val, u32 mask);
+	int (*val)(struct ch_filter_specification *f, __be32 val, __be32 mask);
 };
 
 /* IPv4 match fields */
 static inline int cxgb4_fill_ipv4_tos(struct ch_filter_specification *f,
-				      u32 val, u32 mask)
+				      __be32 val, __be32 mask)
 {
 	f->val.tos  = (ntohl(val)  >> 16) & 0x000000FF;
 	f->mask.tos = (ntohl(mask) >> 16) & 0x000000FF;
@@ -52,7 +52,7 @@ static inline int cxgb4_fill_ipv4_tos(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv4_frag(struct ch_filter_specification *f,
-				       u32 val, u32 mask)
+				       __be32 val, __be32 mask)
 {
 	u32 mask_val;
 	u8 frag_val;
@@ -74,7 +74,7 @@ static inline int cxgb4_fill_ipv4_frag(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv4_proto(struct ch_filter_specification *f,
-					u32 val, u32 mask)
+					__be32 val, __be32 mask)
 {
 	f->val.proto  = (ntohl(val)  >> 16) & 0x000000FF;
 	f->mask.proto = (ntohl(mask) >> 16) & 0x000000FF;
@@ -83,7 +83,7 @@ static inline int cxgb4_fill_ipv4_proto(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv4_src_ip(struct ch_filter_specification *f,
-					 u32 val, u32 mask)
+					 __be32 val, __be32 mask)
 {
 	memcpy(&f->val.fip[0],  &val,  sizeof(u32));
 	memcpy(&f->mask.fip[0], &mask, sizeof(u32));
@@ -92,7 +92,7 @@ static inline int cxgb4_fill_ipv4_src_ip(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv4_dst_ip(struct ch_filter_specification *f,
-					 u32 val, u32 mask)
+					 __be32 val, __be32 mask)
 {
 	memcpy(&f->val.lip[0],  &val,  sizeof(u32));
 	memcpy(&f->mask.lip[0], &mask, sizeof(u32));
@@ -111,7 +111,7 @@ static const struct cxgb4_match_field cxgb4_ipv4_fields[] = {
 
 /* IPv6 match fields */
 static inline int cxgb4_fill_ipv6_tos(struct ch_filter_specification *f,
-				      u32 val, u32 mask)
+				      __be32 val, __be32 mask)
 {
 	f->val.tos  = (ntohl(val)  >> 20) & 0x000000FF;
 	f->mask.tos = (ntohl(mask) >> 20) & 0x000000FF;
@@ -120,7 +120,7 @@ static inline int cxgb4_fill_ipv6_tos(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_proto(struct ch_filter_specification *f,
-					u32 val, u32 mask)
+					__be32 val, __be32 mask)
 {
 	f->val.proto  = (ntohl(val)  >> 8) & 0x000000FF;
 	f->mask.proto = (ntohl(mask) >> 8) & 0x000000FF;
@@ -129,7 +129,7 @@ static inline int cxgb4_fill_ipv6_proto(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_src_ip0(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.fip[0],  &val,  sizeof(u32));
 	memcpy(&f->mask.fip[0], &mask, sizeof(u32));
@@ -138,7 +138,7 @@ static inline int cxgb4_fill_ipv6_src_ip0(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_src_ip1(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.fip[4],  &val,  sizeof(u32));
 	memcpy(&f->mask.fip[4], &mask, sizeof(u32));
@@ -147,7 +147,7 @@ static inline int cxgb4_fill_ipv6_src_ip1(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_src_ip2(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.fip[8],  &val,  sizeof(u32));
 	memcpy(&f->mask.fip[8], &mask, sizeof(u32));
@@ -156,7 +156,7 @@ static inline int cxgb4_fill_ipv6_src_ip2(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_src_ip3(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.fip[12],  &val,  sizeof(u32));
 	memcpy(&f->mask.fip[12], &mask, sizeof(u32));
@@ -165,7 +165,7 @@ static inline int cxgb4_fill_ipv6_src_ip3(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_dst_ip0(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.lip[0],  &val,  sizeof(u32));
 	memcpy(&f->mask.lip[0], &mask, sizeof(u32));
@@ -174,7 +174,7 @@ static inline int cxgb4_fill_ipv6_dst_ip0(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_dst_ip1(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.lip[4],  &val,  sizeof(u32));
 	memcpy(&f->mask.lip[4], &mask, sizeof(u32));
@@ -183,7 +183,7 @@ static inline int cxgb4_fill_ipv6_dst_ip1(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_dst_ip2(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.lip[8],  &val,  sizeof(u32));
 	memcpy(&f->mask.lip[8], &mask, sizeof(u32));
@@ -192,7 +192,7 @@ static inline int cxgb4_fill_ipv6_dst_ip2(struct ch_filter_specification *f,
 }
 
 static inline int cxgb4_fill_ipv6_dst_ip3(struct ch_filter_specification *f,
-					  u32 val, u32 mask)
+					  __be32 val, __be32 mask)
 {
 	memcpy(&f->val.lip[12],  &val,  sizeof(u32));
 	memcpy(&f->mask.lip[12], &mask, sizeof(u32));
@@ -216,7 +216,7 @@ static const struct cxgb4_match_field cxgb4_ipv6_fields[] = {
 
 /* TCP/UDP match */
 static inline int cxgb4_fill_l4_ports(struct ch_filter_specification *f,
-				      u32 val, u32 mask)
+				      __be32 val, __be32 mask)
 {
 	f->val.fport  = ntohl(val)  >> 16;
 	f->mask.fport = ntohl(mask) >> 16;
@@ -237,19 +237,13 @@ static const struct cxgb4_match_field cxgb4_udp_fields[] = {
 };
 
 struct cxgb4_next_header {
-	unsigned int offset; /* Offset to next header */
-	/* offset, shift, and mask added to offset above
+	/* Offset, shift, and mask added to beginning of the header
 	 * to get to next header.  Useful when using a header
 	 * field's value to jump to next header such as IHL field
 	 * in IPv4 header.
 	 */
-	unsigned int offoff;
-	u32 shift;
-	u32 mask;
-	/* match criteria to make this jump */
-	unsigned int match_off;
-	u32 match_val;
-	u32 match_mask;
+	struct tc_u32_sel sel;
+	struct tc_u32_key key;
 	/* location of jump to make */
 	const struct cxgb4_match_field *jump;
 };
@@ -258,26 +252,74 @@ struct cxgb4_next_header {
  * IPv4 header.
  */
 static const struct cxgb4_next_header cxgb4_ipv4_jumps[] = {
-	{ .offset = 0, .offoff = 0, .shift = 6, .mask = 0xF,
-	  .match_off = 8, .match_val = 0x600, .match_mask = 0xFF00,
-	  .jump = cxgb4_tcp_fields },
-	{ .offset = 0, .offoff = 0, .shift = 6, .mask = 0xF,
-	  .match_off = 8, .match_val = 0x1100, .match_mask = 0xFF00,
-	  .jump = cxgb4_udp_fields },
-	{ .jump = NULL }
+	{
+		/* TCP Jump */
+		.sel = {
+			.off = 0,
+			.offoff = 0,
+			.offshift = 6,
+			.offmask = cpu_to_be16(0x0f00),
+		},
+		.key = {
+			.off = 8,
+			.val = cpu_to_be32(0x00060000),
+			.mask = cpu_to_be32(0x00ff0000),
+		},
+		.jump = cxgb4_tcp_fields,
+	},
+	{
+		/* UDP Jump */
+		.sel = {
+			.off = 0,
+			.offoff = 0,
+			.offshift = 6,
+			.offmask = cpu_to_be16(0x0f00),
+		},
+		.key = {
+			.off = 8,
+			.val = cpu_to_be32(0x00110000),
+			.mask = cpu_to_be32(0x00ff0000),
+		},
+		.jump = cxgb4_udp_fields,
+	},
+	{ .jump = NULL },
 };
 
 /* Accept a rule with a jump directly past the 40 Bytes of IPv6 fixed header
  * to get to transport layer header.
  */
 static const struct cxgb4_next_header cxgb4_ipv6_jumps[] = {
-	{ .offset = 0x28, .offoff = 0, .shift = 0, .mask = 0,
-	  .match_off = 4, .match_val = 0x60000, .match_mask = 0xFF0000,
-	  .jump = cxgb4_tcp_fields },
-	{ .offset = 0x28, .offoff = 0, .shift = 0, .mask = 0,
-	  .match_off = 4, .match_val = 0x110000, .match_mask = 0xFF0000,
-	  .jump = cxgb4_udp_fields },
-	{ .jump = NULL }
+	{
+		/* TCP Jump */
+		.sel = {
+			.off = 40,
+			.offoff = 0,
+			.offshift = 0,
+			.offmask = 0,
+		},
+		.key = {
+			.off = 4,
+			.val = cpu_to_be32(0x00000600),
+			.mask = cpu_to_be32(0x0000ff00),
+		},
+		.jump = cxgb4_tcp_fields,
+	},
+	{
+		/* UDP Jump */
+		.sel = {
+			.off = 40,
+			.offoff = 0,
+			.offshift = 0,
+			.offmask = 0,
+		},
+		.key = {
+			.off = 4,
+			.val = cpu_to_be32(0x00001100),
+			.mask = cpu_to_be32(0x0000ff00),
+		},
+		.jump = cxgb4_udp_fields,
+	},
+	{ .jump = NULL },
 };
 
 struct cxgb4_link {
-- 
2.24.0

