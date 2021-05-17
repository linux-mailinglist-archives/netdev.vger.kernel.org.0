Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C63839F3
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbhEQQdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbhEQQca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:32:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E42C061348
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:20:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so6818233wrw.8
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S/klcyBqqm71bSpUKDz2zGrTs0uU/rdx6Eemhomop5o=;
        b=Sh4q+pA0anjE9LuyM+Xx6hBQ6lQGjyYD95JzNXzVSOUkmqq+qYfEj4/gtda974R22E
         ua8gSppESDOQZxP+CtuFc4PBVpSewb12PU5WBH8DbY+WxYUWrvQPot+uQuPIDR8AqcQz
         HyOP3dDUMPNIeucKgU7x/VMZMFoHrZUgBxAeYkJuojIwWHG3Z6GU8bnk7RBjU+KWjh7E
         UuKsFFm8/MpDQaAIVDf2BO/3lGQ3vanX/heLUIIF+2eYbYgD+TA48JXYf9Z28d5EgnvM
         A8weLCcvGzql3NihpCPeo4WaI1zMG6WGyHxNP4BF6BHKlahLQqwnxqBph8lfbSth00dB
         LOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S/klcyBqqm71bSpUKDz2zGrTs0uU/rdx6Eemhomop5o=;
        b=uZQM7zCKbXJSQb+gHLwnnMVcuhcboSqeIG2esFtfH/6tssdEW0rjObS8MKj5qmTVKS
         NcGEYOEDvE05UXFHNS+KpkmBewqNKzq7WJuj7Q1t3dFlb28iqV8rZ6OV7lRWPea2SmcJ
         PXT3kcaGJOzHshH+yH6xtsEAlnL+AVJ/fsLKO0WBlFKD5Fr1iHKcSq5kcR3nOwXsErkh
         J2NXNHEh8aPxbQ8wh2jk0loGcj8KtYvOVEz5jxg954cfWWAtlVA99Pe5EZUP8hRdUyMm
         +XVXGrK4YtPKacoU9OZ000wRiIsg8nrR6ChfoMoL4lMrQe3kv8lQbTYVgQA45zh+xccH
         JElw==
X-Gm-Message-State: AOAM5326JG4JuxfjEM1Mw2HM9A3GA6SndDwfe0+YVU5dIEc5nExUPg2a
        56b5jeEb7nKFlwTG4ekoSFpBRLgIl8Pasw==
X-Google-Smtp-Source: ABdhPJx8uvLkYc+cEDY7Ih5JSJsTlKQeW/PDUuisK2vHx96s20CEbGX2hoj4u+V9mEhk1wtczfzXww==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr215057wrn.335.1621264856085;
        Mon, 17 May 2021 08:20:56 -0700 (PDT)
Received: from ubuntu.localdomain ([85.254.75.186])
        by smtp.googlemail.com with ESMTPSA id g66sm14745969wma.11.2021.05.17.08.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:20:55 -0700 (PDT)
From:   Toms Atteka <cpp.code.lv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Toms Atteka <cpp.code.lv@gmail.com>
Subject: [PATCH net-next v2] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Mon, 17 May 2021 08:20:51 -0700
Message-Id: <20210517152051.35233-1-cpp.code.lv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 extension headers carry optional internet layer information
and are placed between the fixed header and the upper-layer
protocol header.

This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
packets can be filtered using ipv6_ext flag.

Tested-at: https://github.com/TomCodeLV/ovs/actions/runs/504185214
Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
---
 include/uapi/linux/openvswitch.h |   1 +
 net/openvswitch/flow.c           | 141 +++++++++++++++++++++++++++++++
 net/openvswitch/flow.h           |  14 +++
 net/openvswitch/flow_netlink.c   |   5 +-
 4 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 8d16744edc31..a19812b6631a 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -420,6 +420,7 @@ struct ovs_key_ipv6 {
 	__u8   ipv6_tclass;
 	__u8   ipv6_hlimit;
 	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
+	__u16  ipv6_exthdr;
 };
 
 struct ovs_key_tcp {
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e586424d8b04..cfc5f395f82c 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -239,6 +239,145 @@ static bool icmphdr_ok(struct sk_buff *skb)
 				  sizeof(struct icmphdr));
 }
 
+/**
+ * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
+ *
+ * @skb: Buffer where extension header data starts in packet.
+ * @nh: IPv6 header.
+ * @ext_hdrs: Flags are stored here.
+ *
+ * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
+ * is unexpectedly encountered. (Two destination options headers may be
+ * expected and would not cause this bit to be set.)
+ *
+ * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
+ * preferred (but not required) by RFC 2460:
+ *
+ * When more than one extension header is used in the same packet, it is
+ * recommended that those headers appear in the following order:
+ *      IPv6 header
+ *      Hop-by-Hop Options header
+ *      Destination Options header
+ *      Routing header
+ *      Fragment header
+ *      Authentication header
+ *      Encapsulating Security Payload header
+ *      Destination Options header
+ *      upper-layer header
+ */
+static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16 *ext_hdrs)
+{
+	int next_type = nh->nexthdr;
+	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
+	int dest_options_header_count = 0;
+
+	*ext_hdrs = 0;
+
+	while (ipv6_ext_hdr(next_type)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		switch (next_type) {
+		case IPPROTO_NONE:
+			*ext_hdrs |= OFPIEH12_NONEXT;
+			/* stop parsing */
+			return;
+
+		case IPPROTO_ESP:
+			if (*ext_hdrs & OFPIEH12_ESP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_ROUTER |
+					   IPPROTO_FRAGMENT |
+					   OFPIEH12_AUTH |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2)
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			*ext_hdrs |= OFPIEH12_ESP;
+			break;
+
+		case IPPROTO_AH:
+			if (*ext_hdrs & OFPIEH12_AUTH)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_ROUTER |
+					   IPPROTO_FRAGMENT |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2)
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			*ext_hdrs |= OFPIEH12_AUTH;
+			break;
+
+		case IPPROTO_DSTOPTS:
+			if (dest_options_header_count == 0) {
+				if (*ext_hdrs & ~(OFPIEH12_HOP |
+						  OFPIEH12_UNREP))
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				*ext_hdrs |= OFPIEH12_DEST;
+			} else if (dest_options_header_count == 1) {
+				if (*ext_hdrs & ~(OFPIEH12_HOP |
+						  OFPIEH12_DEST |
+						  OFPIEH12_ROUTER |
+						  OFPIEH12_FRAG |
+						  OFPIEH12_AUTH |
+						  OFPIEH12_ESP |
+						  OFPIEH12_UNREP))
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+			} else {
+				*ext_hdrs |= OFPIEH12_UNREP;
+			}
+			dest_options_header_count++;
+			break;
+
+		case IPPROTO_FRAGMENT:
+			if (*ext_hdrs & OFPIEH12_FRAG)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_ROUTER |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2)
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			*ext_hdrs |= OFPIEH12_FRAG;
+			break;
+
+		case IPPROTO_ROUTING:
+			if (*ext_hdrs & OFPIEH12_ROUTER)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2)
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			*ext_hdrs |= OFPIEH12_ROUTER;
+			break;
+
+		case IPPROTO_HOPOPTS:
+			if (*ext_hdrs & OFPIEH12_HOP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			/* OFPIEH12_HOP is set to 1 if a hop-by-hop IPv6
+			 * extension header is present as the first extension
+			 * header in the pac	ket.
+			 */
+			if (*ext_hdrs == 0)
+				*ext_hdrs |= OFPIEH12_HOP;
+			else
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			break;
+
+		default:
+			return;
+		}
+
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			break;
+		next_type = hp->nexthdr;
+		start += ipv6_optlen(hp);
+	}
+}
+
 static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	unsigned short frag_off;
@@ -254,6 +393,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nh = ipv6_hdr(skb);
 
+	get_ipv6_ext_hdrs(skb, nh, &key->ipv6.exthdrs);
+
 	key->ip.proto = NEXTHDR_NONE;
 	key->ip.tos = ipv6_get_dsfield(nh);
 	key->ip.ttl = nh->hop_limit;
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 758a8c77f736..e7a8eafae272 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -32,6 +32,19 @@ enum sw_flow_mac_proto {
 #define SW_FLOW_KEY_INVALID	0x80
 #define MPLS_LABEL_DEPTH       3
 
+/* Bit definitions for IPv6 Extension Header pseudo-field. */
+enum ofp12_ipv6exthdr_flags {
+	OFPIEH12_NONEXT = 1 << 0,   /* "No next header" encountered. */
+	OFPIEH12_ESP    = 1 << 1,   /* Encrypted Sec Payload header present. */
+	OFPIEH12_AUTH   = 1 << 2,   /* Authentication header present. */
+	OFPIEH12_DEST   = 1 << 3,   /* 1 or 2 dest headers present. */
+	OFPIEH12_FRAG   = 1 << 4,   /* Fragment header present. */
+	OFPIEH12_ROUTER = 1 << 5,   /* Router header present. */
+	OFPIEH12_HOP    = 1 << 6,   /* Hop-by-hop header present. */
+	OFPIEH12_UNREP  = 1 << 7,   /* Unexpected repeats encountered. */
+	OFPIEH12_UNSEQ  = 1 << 8    /* Unexpected sequencing encountered. */
+};
+
 /* Store options at the end of the array if they are less than the
  * maximum size. This allows us to get the benefits of variable length
  * matching for small options.
@@ -121,6 +134,7 @@ struct sw_flow_key {
 				struct in6_addr dst;	/* IPv6 destination address. */
 			} addr;
 			__be32 label;			/* IPv6 flow label. */
+			u16 exthdrs;			/* IPv6 extension header flags */
 			union {
 				struct {
 					struct in6_addr src;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fd1f809e9bc1..681cd9ddda4a 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -367,7 +367,7 @@ size_t ovs_key_attr_size(void)
 		+ nla_total_size(4)   /* OVS_KEY_ATTR_VLAN */
 		+ nla_total_size(0)   /* OVS_KEY_ATTR_ENCAP */
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ETHERTYPE */
-		+ nla_total_size(40)  /* OVS_KEY_ATTR_IPV6 */
+		+ nla_total_size(42)  /* OVS_KEY_ATTR_IPV6 */
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ICMPV6 */
 		+ nla_total_size(28); /* OVS_KEY_ATTR_ND */
 }
@@ -1585,6 +1585,8 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 				ipv6_key->ipv6_hlimit, is_mask);
 		SW_FLOW_KEY_PUT(match, ip.frag,
 				ipv6_key->ipv6_frag, is_mask);
+		SW_FLOW_KEY_PUT(match, ipv6.exthdrs,
+				ipv6_key->ipv6_exthdr, is_mask);
 		SW_FLOW_KEY_MEMCPY(match, ipv6.addr.src,
 				ipv6_key->ipv6_src,
 				sizeof(match->key->ipv6.addr.src),
@@ -2113,6 +2115,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv6_key->ipv6_tclass = output->ip.tos;
 		ipv6_key->ipv6_hlimit = output->ip.ttl;
 		ipv6_key->ipv6_frag = output->ip.frag;
+		ipv6_key->ipv6_exthdr = output->ipv6.exthdrs;
 	} else if (swkey->eth.type == htons(ETH_P_NSH)) {
 		if (nsh_key_to_nlattr(&output->nsh, is_mask, skb))
 			goto nla_put_failure;

base-commit: 5d869070569a23aa909c6e7e9d010fc438a492ef
-- 
2.25.1

