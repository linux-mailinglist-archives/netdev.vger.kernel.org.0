Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00F13222C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgAGJWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:22:25 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44132 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726327AbgAGJWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:22:25 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jan 2020 11:22:16 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0079MGmc027378;
        Tue, 7 Jan 2020 11:22:16 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2] tc: flower: fix print with oneline option
Date:   Tue,  7 Jan 2020 11:22:10 +0200
Message-Id: <20200107092210.1562-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fix all location in flower to use _SL_ instead of \n for
newline to allow support for oneline option.

Example before this commit:

filter protocol ip pref 2 flower chain 0 handle 0x1
  indev ens1f0
  dst_mac 11:22:33:44:55:66
  eth_type ipv4
  ip_proto tcp
  src_ip 2.2.2.2
  src_port 99
  dst_port 1-10\  tcp_flags 0x5/5
  ip_flags frag
  ct_state -trk\  ct_zone 4\  ct_mark 255
  ct_label 00000000000000000000000000000000
  skip_hw
  not_in_hw\    action order 1: ct zone 5 pipe
         index 1 ref 1 bind 1 installed 287 sec used 287 sec
        Action statistics:\     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0\

Example output after this commit:

filter protocol ip pref 2 flower chain 0 handle 0x1 \  indev ens1f0\  dst_mac 11:22:33:44:55:66\  eth_type ipv4\  ip_proto tcp\  src_ip 2.2.2.2\  src_port 99\  dst_port 1-10\  tcp_flags 0x5/5\  ip_flags frag\  ct_state -trk\  ct_zone 4\  ct_mark 255\  ct_label 00000000000000000000000000000000\  skip_hw\  not_in_hw\action order 1: ct zone 5 pipe
         index 1 ref 1 bind 1 installed 346 sec used 346 sec
        Action statistics:\     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0\

Signed-off-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/f_flower.c | 83 ++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index a193c0eca22a..2d7a4ffe409e 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1599,7 +1599,8 @@ static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
 			sprintf(out + done, "/%d", bits);
 	}
 
-	sprintf(namefrm, "\n  %s %%s", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
@@ -1624,7 +1625,8 @@ static void flower_print_eth_type(__be16 *p_eth_type,
 	else
 		sprintf(out, "%04x", ntohs(eth_type));
 
-	print_string(PRINT_ANY, "eth_type", "\n  eth_type %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "eth_type", "  eth_type %s", out);
 	*p_eth_type = eth_type;
 }
 
@@ -1651,7 +1653,8 @@ static void flower_print_ip_proto(__u8 *p_ip_proto,
 	else
 		sprintf(out, "%02x", ip_proto);
 
-	print_string(PRINT_ANY, "ip_proto", "\n  ip_proto %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ip_proto", "  ip_proto %s", out);
 	*p_ip_proto = ip_proto;
 }
 
@@ -1682,7 +1685,8 @@ static void flower_print_matching_flags(char *name,
 			continue;
 		if (mtf_mask & flags_str[i].flag) {
 			if (++count == 1) {
-				print_string(PRINT_FP, NULL, "\n  %s ", name);
+				print_nl();
+				print_string(PRINT_FP, NULL, "  %s ", name);
 				open_json_object(name);
 			} else {
 				print_string(PRINT_FP, NULL, "/", NULL);
@@ -1741,7 +1745,8 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 	else if (bits < len * 8)
 		sprintf(out + done, "/%d", bits);
 
-	sprintf(namefrm, "\n  %s %%s", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
@@ -1775,7 +1780,8 @@ static void flower_print_port_range(char *name, struct rtattr *min_attr,
 
 		done = sprintf(out, "%u", rta_getattr_be16(min_attr));
 		sprintf(out + done, "-%u", rta_getattr_be16(max_attr));
-		sprintf(namefrm, "\n  %s %%s", name);
+		print_nl();
+		sprintf(namefrm, "  %s %%s", name);
 		print_string(PRINT_ANY, name, namefrm, out);
 	}
 }
@@ -1794,8 +1800,8 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 	if (mask_attr)
 		sprintf(out + done, "/%x", rta_getattr_be16(mask_attr));
 
-	print_string(PRINT_FP, NULL, "%s  ", _SL_);
-	sprintf(namefrm, "%s %%s", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
@@ -1829,7 +1835,8 @@ static void flower_print_ct_state(struct rtattr *flags_attr,
 					flower_ct_states[i].str);
 	}
 
-	print_string(PRINT_ANY, "ct_state", "\n  ct_state %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ct_state", "  ct_state %s", out);
 }
 
 static void flower_print_ct_label(struct rtattr *attr,
@@ -1864,7 +1871,8 @@ static void flower_print_ct_label(struct rtattr *attr,
 	}
 	*p = '\0';
 
-	print_string(PRINT_ANY, "ct_label", "\n  ct_label %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ct_label", "  ct_label %s", out);
 }
 
 static void flower_print_ct_zone(struct rtattr *attr,
@@ -1886,7 +1894,8 @@ static void flower_print_key_id(const char *name, struct rtattr *attr)
 	if (!attr)
 		return;
 
-	sprintf(namefrm,"\n  %s %%u", name);
+	print_nl();
+	sprintf(namefrm,"  %s %%u", name);
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_be32(attr));
 }
 
@@ -1934,7 +1943,7 @@ static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
 static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
 				      char *key, char *mask)
 {
-	char *namefrm = "\n  geneve_opt %s";
+	char *namefrm = "  geneve_opt %s";
 	char *key_token, *mask_token, *out;
 	int len;
 
@@ -1952,6 +1961,7 @@ static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
 	}
 
 	out[len - 1] = '\0';
+	print_nl();
 	print_string(PRINT_FP, name, namefrm, out);
 	free(out);
 }
@@ -2015,7 +2025,8 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 	if (mask != UINT8_MAX)
 		sprintf(out + done, "/%d", mask);
 
-	sprintf(namefrm,"\n  %s %%s", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
@@ -2031,7 +2042,8 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	if (!attr)
 		return;
 
-	sprintf(namefrm,"\n  %s %%u", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%u", name);
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
@@ -2077,7 +2089,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_INDEV]) {
 		struct rtattr *attr = tb[TCA_FLOWER_INDEV];
 
-		print_string(PRINT_ANY, "indev", "\n  indev %s",
+		print_nl();
+		print_string(PRINT_ANY, "indev", "  indev %s",
 			     rta_getattr_str(attr));
 	}
 
@@ -2086,14 +2099,16 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_KEY_VLAN_ID]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_ID];
 
-		print_uint(PRINT_ANY, "vlan_id", "\n  vlan_id %u",
+		print_nl();
+		print_uint(PRINT_ANY, "vlan_id", "  vlan_id %u",
 			   rta_getattr_u16(attr));
 	}
 
 	if (tb[TCA_FLOWER_KEY_VLAN_PRIO]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_PRIO];
 
-		print_uint(PRINT_ANY, "vlan_prio", "\n  vlan_prio %d",
+		print_nl();
+		print_uint(PRINT_ANY, "vlan_prio", "  vlan_prio %d",
 			   rta_getattr_u8(attr));
 	}
 
@@ -2101,7 +2116,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 		SPRINT_BUF(buf);
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE];
 
-		print_string(PRINT_ANY, "vlan_ethtype", "\n  vlan_ethtype %s",
+		print_nl();
+		print_string(PRINT_ANY, "vlan_ethtype", "  vlan_ethtype %s",
 			     ll_proto_n2a(rta_getattr_u16(attr),
 			     buf, sizeof(buf)));
 	}
@@ -2109,14 +2125,16 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_KEY_CVLAN_ID]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_ID];
 
-		print_uint(PRINT_ANY, "cvlan_id", "\n  cvlan_id %u",
+		print_nl();
+		print_uint(PRINT_ANY, "cvlan_id", "  cvlan_id %u",
 			   rta_getattr_u16(attr));
 	}
 
 	if (tb[TCA_FLOWER_KEY_CVLAN_PRIO]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_PRIO];
 
-		print_uint(PRINT_ANY, "cvlan_prio", "\n  cvlan_prio %d",
+		print_nl();
+		print_uint(PRINT_ANY, "cvlan_prio", " cvlan_prio %d",
 			   rta_getattr_u8(attr));
 	}
 
@@ -2124,7 +2142,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 		SPRINT_BUF(buf);
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_ETH_TYPE];
 
-		print_string(PRINT_ANY, "cvlan_ethtype", "\n  cvlan_ethtype %s",
+		print_nl();
+		print_string(PRINT_ANY, "cvlan_ethtype", "  cvlan_ethtype %s",
 			     ll_proto_n2a(rta_getattr_u16(attr),
 			     buf, sizeof(buf)));
 	}
@@ -2254,13 +2273,17 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_FLAGS]) {
 		__u32 flags = rta_getattr_u32(tb[TCA_FLOWER_FLAGS]);
 
-		if (flags & TCA_CLS_FLAGS_SKIP_HW)
-			print_bool(PRINT_ANY, "skip_hw", "\n  skip_hw", true);
-		if (flags & TCA_CLS_FLAGS_SKIP_SW)
-			print_bool(PRINT_ANY, "skip_sw", "\n  skip_sw", true);
-
+		if (flags & TCA_CLS_FLAGS_SKIP_HW) {
+			print_nl();
+			print_bool(PRINT_ANY, "skip_hw", "  skip_hw", true);
+		}
+		if (flags & TCA_CLS_FLAGS_SKIP_SW) {
+			print_nl();
+			print_bool(PRINT_ANY, "skip_sw", "  skip_sw", true);
+		}
 		if (flags & TCA_CLS_FLAGS_IN_HW) {
-			print_bool(PRINT_ANY, "in_hw", "\n  in_hw", true);
+			print_nl();
+			print_bool(PRINT_ANY, "in_hw", "  in_hw", true);
 
 			if (tb[TCA_FLOWER_IN_HW_COUNT]) {
 				__u32 count = rta_getattr_u32(tb[TCA_FLOWER_IN_HW_COUNT]);
@@ -2269,8 +2292,10 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 					   " in_hw_count %u", count);
 			}
 		}
-		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
-			print_bool(PRINT_ANY, "not_in_hw", "\n  not_in_hw", true);
+		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {
+			print_nl();
+			print_bool(PRINT_ANY, "not_in_hw", "  not_in_hw", true);
+		}
 	}
 
 	if (tb[TCA_FLOWER_ACT])
-- 
2.8.4

