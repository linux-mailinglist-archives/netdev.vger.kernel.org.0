Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E20E400722
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhICUyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhICUyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:54:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00A3C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 13:53:38 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v10so425550wrd.4
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 13:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gABJiwqOj3wciisKz24pKKIiOBSMtCJM8gS02OlZ8oQ=;
        b=k+siu5B3S87wWmrPJlXPW1uj3sBPv0aecZT8ppAD3mkbBmbIQDEf8o2FVUbJzu0Wh9
         4NlOxvPLEqA5SUskqAY+gnd/Z4G8M/k1eRlm0Yxk5lxrtp+JioBSk0AHGMp1OR2yRDTm
         3z0f0r+6T3IONfzFMuaVDUzhCPxl+sA8p47hj2cMeStQ5R4oiq0TlAv40Pk8hIpClBnx
         feGvOJtTRs5Uv7VzOJOIQ3P/wQ4DuoHJ+65EFGPnJfRCX7CAkkZoN6iuRwrvUy67k8Dc
         q6Tc43GUySCKOX4S+qqviW7rhseJKIgr3NT5Sz1tN/Gh/ynmIlZi0+0pZfBC1fhfCHHt
         nRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gABJiwqOj3wciisKz24pKKIiOBSMtCJM8gS02OlZ8oQ=;
        b=FxhFZyPLefgXGEwfY21nyNmV/8vKTqhJeaH7t73f1RVtmztJHG2YEzmcIBcXdckEn6
         VxYEcnqznYBDSPvvDi1ZHb+Js++01PrtO6qvMtzCic1+yxGwHGRVzjIA9Eb0WiszpmoV
         QyFgSvhpATgoniyLHg11YXVx4ZycQBYyEn6zZVyW9W2/CAOvRWBs96Wqp8ziE3Yf9dTm
         qnqQ1/73E8spcC3d2/wRd04ZX6/O4XOtA2syAW+qrY11/FWP8wmaD0WMywyK2EQMbqmQ
         ZDZf0UD5sdObmT5gRTAk4AKkkaBaUpNhT4giNAIKgcPVOHdtWYg7Btn7cdWITqDPHXMg
         juvQ==
X-Gm-Message-State: AOAM532e3xSWxXDS+3/Ota0L5+4Tq6aEK4y/LFMS4My09iY0aMAmVCbC
        nCgZDdOdnahWzLKvEVQgsfHMxHqtyRw=
X-Google-Smtp-Source: ABdhPJwlcYDtyhoPkbBceaAYYkaVgXsWE4H/t8QooKiGCJFCze1X6Hnq/l5Q5OJ5liDE/L9jmzS/rw==
X-Received: by 2002:a5d:6b8a:: with SMTP id n10mr911340wrx.276.1630702417239;
        Fri, 03 Sep 2021 13:53:37 -0700 (PDT)
Received: from ubuntu.localdomain ([213.226.141.159])
        by smtp.googlemail.com with ESMTPSA id c14sm287722wrr.58.2021.09.03.13.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:53:36 -0700 (PDT)
From:   Toms Atteka <cpp.code.lv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Toms Atteka <cpp.code.lv@gmail.com>
Subject: [PATCH net-next v3] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Fri,  3 Sep 2021 13:53:32 -0700
Message-Id: <20210903205332.707905-1-cpp.code.lv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
packets can be filtered using ipv6_ext flag.

Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
---
 include/uapi/linux/openvswitch.h |  12 +++
 net/openvswitch/flow.c           | 139 +++++++++++++++++++++++++++++++
 net/openvswitch/flow.h           |  14 ++++
 net/openvswitch/flow_netlink.c   |  24 +++++-
 4 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44cd5590..dc6eb5f6399f 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -346,6 +346,13 @@ enum ovs_key_attr {
 #ifdef __KERNEL__
 	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
 #endif
+
+#ifndef __KERNEL__
+	PADDING,  /* Padding so kernel and non kernel field count would match */
+#endif
+
+	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
+
 	__OVS_KEY_ATTR_MAX
 };
 
@@ -421,6 +428,11 @@ struct ovs_key_ipv6 {
 	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
 };
 
+/* separate structure to support backward compatibility with older user space */
+struct ovs_key_ipv6_exthdrs {
+	__u16  hdrs;
+};
+
 struct ovs_key_tcp {
 	__be16 tcp_src;
 	__be16 tcp_dst;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9d375e74b607..8bad54521343 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -239,6 +239,143 @@ static bool icmphdr_ok(struct sk_buff *skb)
 				  sizeof(struct icmphdr));
 }
 
+/**
+ * Parses packet and sets IPv6 extension header flags.
+ *
+ * skb          buffer where extension header data starts in packet
+ * nh           ipv6 header
+ * ext_hdrs     flags are stored here
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
+void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16 *ext_hdrs)
+{
+	u8 next_type = nh->nexthdr;
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
+			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
+					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ESP;
+			break;
+
+		case IPPROTO_AH:
+			if (*ext_hdrs & OFPIEH12_AUTH)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs &
+			     ~(OFPIEH12_HOP | OFPIEH12_DEST | OFPIEH12_ROUTER |
+			       IPPROTO_FRAGMENT | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_AUTH;
+			break;
+
+		case IPPROTO_DSTOPTS:
+			if (dest_options_header_count == 0) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_UNREP))
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				*ext_hdrs |= OFPIEH12_DEST;
+			} else if (dest_options_header_count == 1) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_DEST |
+				      OFPIEH12_ROUTER | OFPIEH12_FRAG |
+				      OFPIEH12_AUTH | OFPIEH12_ESP |
+				      OFPIEH12_UNREP)) {
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				}
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
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_FRAG;
+			break;
+
+		case IPPROTO_ROUTING:
+			if (*ext_hdrs & OFPIEH12_ROUTER)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ROUTER;
+			break;
+
+		case IPPROTO_HOPOPTS:
+			if (*ext_hdrs & OFPIEH12_HOP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			/* OFPIEH12_HOP is set to 1 if a hop-by-hop IPv6
+			 * extension header is present as the first
+			 * extension header in the packet.
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
+	};
+}
+
 static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	unsigned short frag_off;
@@ -254,6 +391,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nh = ipv6_hdr(skb);
 
+	get_ipv6_ext_hdrs(skb, nh, &key->ipv6.exthdrs);
+
 	key->ip.proto = NEXTHDR_NONE;
 	key->ip.tos = ipv6_get_dsfield(nh);
 	key->ip.ttl = nh->hop_limit;
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 758a8c77f736..073ab73ffeaa 100644
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
+			u16 exthdrs;	/* IPv6 extension header flags */
 			union {
 				struct {
 					struct in6_addr src;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e3458ff5..2fbf324fcfff 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -367,7 +367,8 @@ size_t ovs_key_attr_size(void)
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ETHERTYPE */
 		+ nla_total_size(40)  /* OVS_KEY_ATTR_IPV6 */
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ICMPV6 */
-		+ nla_total_size(28); /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(28)  /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(2);  /* OVS_KEY_ATTR_IPV6_EXTHDRS */
 }
 
 static const struct ovs_len_tbl ovs_vxlan_ext_key_lens[OVS_VXLAN_EXT_MAX + 1] = {
@@ -435,6 +436,8 @@ static const struct ovs_len_tbl ovs_key_lens[OVS_KEY_ATTR_MAX + 1] = {
 		.len = sizeof(struct ovs_key_ct_tuple_ipv6) },
 	[OVS_KEY_ATTR_NSH]       = { .len = OVS_ATTR_NESTED,
 				     .next = ovs_nsh_key_attr_lens, },
+	[OVS_KEY_ATTR_IPV6_EXTHDRS] = {
+		.len = sizeof(struct ovs_key_ipv6_exthdrs) },
 };
 
 static bool check_attr_len(unsigned int attr_len, unsigned int expected_len)
@@ -1595,6 +1598,17 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 		attrs &= ~(1 << OVS_KEY_ATTR_IPV6);
 	}
 
+	if (attrs & (1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS)) {
+		const struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
+
+		ipv6_exthdrs_key = nla_data(a[OVS_KEY_ATTR_IPV6_EXTHDRS]);
+
+		SW_FLOW_KEY_PUT(match, ipv6.exthdrs,
+				ipv6_exthdrs_key->hdrs, is_mask);
+
+		attrs &= ~(1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS);
+	}
+
 	if (attrs & (1 << OVS_KEY_ATTR_ARP)) {
 		const struct ovs_key_arp *arp_key;
 
@@ -2097,6 +2111,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv4_key->ipv4_frag = output->ip.frag;
 	} else if (swkey->eth.type == htons(ETH_P_IPV6)) {
 		struct ovs_key_ipv6 *ipv6_key;
+		struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
 
 		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6, sizeof(*ipv6_key));
 		if (!nla)
@@ -2111,6 +2126,13 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv6_key->ipv6_tclass = output->ip.tos;
 		ipv6_key->ipv6_hlimit = output->ip.ttl;
 		ipv6_key->ipv6_frag = output->ip.frag;
+
+		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6_EXTHDRS,
+				  sizeof(*ipv6_exthdrs_key));
+		if (!nla)
+			goto nla_put_failure;
+		ipv6_exthdrs_key = nla_data(nla);
+		ipv6_exthdrs_key->hdrs = output->ipv6.exthdrs;
 	} else if (swkey->eth.type == htons(ETH_P_NSH)) {
 		if (nsh_key_to_nlattr(&output->nsh, is_mask, skb))
 			goto nla_put_failure;
-- 
2.25.1

