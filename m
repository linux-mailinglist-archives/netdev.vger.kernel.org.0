Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA97F9346
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfKLOw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:52:28 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44342 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727683AbfKLOw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:52:27 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 16:52:21 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACEqKxD020273;
        Tue, 12 Nov 2019 16:52:21 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 8/8] tc: flower: support masked port destination and source match
Date:   Tue, 12 Nov 2019 16:51:54 +0200
Message-Id: <20191112145154.145289-9-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191112145154.145289-1-roid@mellanox.com>
References: <20191112145154.145289-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Extend destination and source port match to support masks, accepting
both decimal and hexadecimal formats.
Also add missing documentation to synopsis in manpage.

$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 protocol ip parent ffff: prio 1 flower skip_hw \
      ip_proto tcp dst_port 1234/0xff00 action drop

$ tc -s filter show dev eth0 parent ffff:
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  dst_port 1234/0xff00
  skip_hw
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 26 sec used 26 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

$ tc -p -j filter show dev eth0 parent ffff:
        "options": {
            "keys": {
                "dst_port": 1234,
                "dst_port_mask": 65280
                ...

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 man/man8/tc-flower.8 | 13 ++++++-----
 tc/f_flower.c        | 64 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 04ee194764e1..eb9eb5f0b19c 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -57,7 +57,7 @@ flower \- flow based traffic control filter
 .BR dst_ip " | " src_ip " } "
 .IR PREFIX " | { "
 .BR dst_port " | " src_port " } { "
-.IR port_number " | "
+.IR MASKED_NUMBER " | "
 .IR min_port_number-max_port_number " } | "
 .B tcp_flags
 .IR MASKED_TCP_FLAGS " | "
@@ -221,12 +221,13 @@ must be a valid IPv4 or IPv6 address, depending on the \fBprotocol\fR
 option to tc filter, optionally followed by a slash and the prefix length.
 If the prefix is missing, \fBtc\fR assumes a full-length host match.
 .TP
-.IR \fBdst_port " { "  NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
+.IR \fBdst_port " { "  MASKED_NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
 .TQ
-.IR \fBsrc_port " { "  NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
-Match on layer 4 protocol source or destination port number. Alternatively, the
-mininum and maximum values can be specified to match on a range of layer 4
-protocol source or destination port numbers. Only available for
+.IR \fBsrc_port " { "  MASKED_NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
+Match on layer 4 protocol source or destination port number, with an
+optional mask. Alternatively, the mininum and maximum values can be
+specified to match on a range of layer 4 protocol source or destination
+port numbers. Only available for
 .BR ip_proto " values " udp ", " tcp  " and " sctp
 which have to be specified in beforehand.
 .TP
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 69de6a80735b..a193c0eca22a 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -637,6 +637,27 @@ static int flower_port_attr_type(__u8 ip_proto, enum flower_endpoint endpoint)
 		return -1;
 }
 
+static int flower_port_attr_mask_type(__u8 ip_proto,
+				      enum flower_endpoint endpoint)
+{
+	switch (ip_proto) {
+	case IPPROTO_TCP:
+		return endpoint == FLOWER_ENDPOINT_SRC ?
+			TCA_FLOWER_KEY_TCP_SRC_MASK :
+			TCA_FLOWER_KEY_TCP_DST_MASK;
+	case IPPROTO_UDP:
+		return endpoint == FLOWER_ENDPOINT_SRC ?
+			TCA_FLOWER_KEY_UDP_SRC_MASK :
+			TCA_FLOWER_KEY_UDP_DST_MASK;
+	case IPPROTO_SCTP:
+		return endpoint == FLOWER_ENDPOINT_SRC ?
+			TCA_FLOWER_KEY_SCTP_SRC_MASK :
+			TCA_FLOWER_KEY_SCTP_DST_MASK;
+	default:
+		return -1;
+	}
+}
+
 static int flower_port_range_attr_type(__u8 ip_proto, enum flower_endpoint type,
 				       __be16 *min_port_type,
 				       __be16 *max_port_type)
@@ -681,13 +702,17 @@ static int flower_parse_port(char *str, __u8 ip_proto,
 			     enum flower_endpoint endpoint,
 			     struct nlmsghdr *n)
 {
+	char *slash = NULL;
 	__be16 min = 0;
 	__be16 max = 0;
 	int ret;
 
 	ret = parse_range(str, &min, &max);
-	if (ret)
-		return -1;
+	if (ret) {
+		slash = strchr(str, '/');
+		if (!slash)
+			return -1;
+	}
 
 	if (min && max) {
 		__be16 min_port_type, max_port_type;
@@ -702,13 +727,24 @@ static int flower_parse_port(char *str, __u8 ip_proto,
 
 		addattr16(n, MAX_MSG, min_port_type, min);
 		addattr16(n, MAX_MSG, max_port_type, max);
-	} else if (min && !max) {
+	} else if (slash || (min && !max)) {
 		int type;
 
 		type = flower_port_attr_type(ip_proto, endpoint);
 		if (type < 0)
 			return -1;
-		addattr16(n, MAX_MSG, type, min);
+
+		if (!slash) {
+			addattr16(n, MAX_MSG, type, min);
+		} else {
+			int mask_type;
+
+			mask_type = flower_port_attr_mask_type(ip_proto,
+							       endpoint);
+			if (mask_type < 0)
+				return -1;
+			return flower_parse_u16(str, type, mask_type, n, true);
+		}
 	} else {
 		return -1;
 	}
@@ -1715,15 +1751,10 @@ static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
 				    addr_attr, mask_attr, 0, 0);
 }
 
-static void flower_print_port(char *name, struct rtattr *attr)
+static void flower_print_port(char *name, struct rtattr *attr,
+			      struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
-
-	if (!attr)
-		return;
-
-	sprintf(namefrm,"\n  %s %%u", name);
-	print_hu(PRINT_ANY, name, namefrm, rta_getattr_be16(attr));
+	print_masked_be16(name, attr, mask_attr, true);
 }
 
 static void flower_print_port_range(char *name, struct rtattr *min_attr,
@@ -2129,11 +2160,13 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 			     tb[TCA_FLOWER_KEY_IPV6_SRC_MASK]);
 
 	nl_type = flower_port_attr_type(ip_proto, FLOWER_ENDPOINT_DST);
+	nl_mask_type = flower_port_attr_mask_type(ip_proto, FLOWER_ENDPOINT_DST);
 	if (nl_type >= 0)
-		flower_print_port("dst_port", tb[nl_type]);
+		flower_print_port("dst_port", tb[nl_type], tb[nl_mask_type]);
 	nl_type = flower_port_attr_type(ip_proto, FLOWER_ENDPOINT_SRC);
+	nl_mask_type = flower_port_attr_mask_type(ip_proto, FLOWER_ENDPOINT_SRC);
 	if (nl_type >= 0)
-		flower_print_port("src_port", tb[nl_type]);
+		flower_print_port("src_port", tb[nl_type], tb[nl_mask_type]);
 
 	if (!flower_port_range_attr_type(ip_proto, FLOWER_ENDPOINT_DST,
 					 &min_port_type, &max_port_type))
@@ -2193,7 +2226,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 
 	flower_print_key_id("enc_key_id", tb[TCA_FLOWER_KEY_ENC_KEY_ID]);
 
-	flower_print_port("enc_dst_port", tb[TCA_FLOWER_KEY_ENC_UDP_DST_PORT]);
+	flower_print_port("enc_dst_port", tb[TCA_FLOWER_KEY_ENC_UDP_DST_PORT],
+			  tb[TCA_FLOWER_KEY_ENC_UDP_DST_PORT_MASK]);
 
 	flower_print_ip_attr("enc_tos", tb[TCA_FLOWER_KEY_ENC_IP_TOS],
 			    tb[TCA_FLOWER_KEY_ENC_IP_TOS_MASK]);
-- 
2.8.4

