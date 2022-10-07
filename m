Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AECC5F74F3
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJGHzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJGHz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:55:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84694A3F59
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665129323; x=1696665323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7BrrR5uVSi4Ez6xHzXabq5pNN+auToIPAm0VNZE8+Ns=;
  b=H/fqbfQXC6ZUGhwA6Y853mofyO4lJ+S1jb9kZo8aHTSQS6Ir3+R5ZZ+M
   SsKlXM3N9gxn4Kf3L4oib3s1sUnuCtxAc+80XDWlKQDOe/AeLbCFZ/Nqv
   OlH/1QipwbjmTDa4kaZ2t3WPg8vgtDNfzkNDLSCrwbXAvThWQX2vXm6xa
   QKANgj4xJNqTG7U1YkmWWgo9pN4J+R+cxm3ks5WGfn/JFYMdtLhjixlA0
   nXXOkP1F2TUUn2C9Vj6pyBuEWHPM6Gkxv4CmCek6tP822FEBu8JPTOcmv
   K9pYZOs7BkgNCu7BM43YgAPyBSotPQ/NtIgXwhIowdh3uvKI+8n/hWwnf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="284047142"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="284047142"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 00:55:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="576150638"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="576150638"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 07 Oct 2022 00:55:03 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2977t2GX024390;
        Fri, 7 Oct 2022 08:55:02 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next v3] f_flower: Introduce L2TPv3 support
Date:   Fri,  7 Oct 2022 09:51:01 +0200
Message-Id: <20221007075101.478055-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for matching on L2TPv3 session ID.
Session ID can be specified only when ip proto was
set to IPPROTO_L2TP.

L2TPv3 might be transported over IP or over UDP,
this implementation is only about L2TPv3 over IP.
IPv6 is also supported, in this case next header
is set to IPPROTO_L2TP.

Example filter:
  # tc filter add dev eth0 ingress prio 1 protocol ip \
      flower \
        ip_proto l2tp \
        l2tpv3_sid 1234 \
        skip_sw \
      action drop

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: workaround for IPPROTO_L2TP definition in f_flower.c
v3: remove eth_type check from flower_parse_l2tpv3,
    fix man
---
 man/man8/tc-flower.8 | 11 ++++++++--
 tc/f_flower.c        | 48 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 5e486ea31d37..fc73da93c5c3 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -54,7 +54,9 @@ flower \- flow based traffic control filter
 .IR BOS " | "
 .B mpls_ttl
 .IR TTL " | "
-.BR ip_proto " { " tcp " | " udp " | " sctp " | " icmp " | " icmpv6 " | "
+.B l2tpv3_sid
+.IR LSID " | "
+.BR ip_proto " { " tcp " | " udp " | " sctp " | " icmp " | " icmpv6 " | " l2tp " | "
 .IR IP_PROTO " } | "
 .B ip_tos
 .IR MASKED_IP_TOS " | "
@@ -291,11 +293,16 @@ entry.
 .I TTL
 is an unsigned 8 bit value in decimal format.
 .TP
+.BI l2tpv3_sid " LSID"
+Match on L2TPv3 session id field transported over IPv4 or IPv6.
+.I LSID
+is an unsigned 32 bit value in decimal format.
+.TP
 .BI ip_proto " IP_PROTO"
 Match on layer four protocol.
 .I IP_PROTO
 may be
-.BR tcp ", " udp ", " sctp ", " icmp ", " icmpv6
+.BR tcp ", " udp ", " sctp ", " icmp ", " icmpv6 ", " l2tp
 or an unsigned 8bit value in hexadecimal format.
 .TP
 .BI ip_tos " MASKED_IP_TOS"
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 069896a48f33..4c0a194836f5 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -26,6 +26,10 @@
 #include "tc_util.h"
 #include "rt_names.h"
 
+#ifndef IPPROTO_L2TP
+#define IPPROTO_L2TP 115
+#endif
+
 enum flower_matching_flags {
 	FLOWER_IP_FLAGS,
 };
@@ -60,7 +64,7 @@ static void explain(void)
 		"			ppp_proto [ ipv4 | ipv6 | mpls_uc | mpls_mc | PPP_PROTO ]"
 		"			dst_mac MASKED-LLADDR |\n"
 		"			src_mac MASKED-LLADDR |\n"
-		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
+		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | l2tp | IP-PROTO ] |\n"
 		"			ip_tos MASKED-IP_TOS |\n"
 		"			ip_ttl MASKED-IP_TTL |\n"
 		"			mpls LSE-LIST |\n"
@@ -68,6 +72,7 @@ static void explain(void)
 		"			mpls_tc TC |\n"
 		"			mpls_bos BOS |\n"
 		"			mpls_ttl TTL |\n"
+		"			l2tpv3_sid LSID |\n"
 		"			dst_ip PREFIX |\n"
 		"			src_ip PREFIX |\n"
 		"			dst_port PORT-NUMBER |\n"
@@ -428,6 +433,11 @@ static int flower_parse_ip_proto(char *str, __be16 eth_type, int type,
 		if (eth_type != htons(ETH_P_IPV6))
 			goto err;
 		ip_proto = IPPROTO_ICMPV6;
+	} else if (!strcmp(str, "l2tp")) {
+		if (eth_type != htons(ETH_P_IP) &&
+		    eth_type != htons(ETH_P_IPV6))
+			goto err;
+		ip_proto = IPPROTO_L2TP;
 	} else {
 		ret = get_u8(&ip_proto, str, 16);
 		if (ret)
@@ -646,6 +656,27 @@ static int flower_parse_icmp(char *str, __u16 eth_type, __u8 ip_proto,
 	return flower_parse_u8(str, value_type, mask_type, NULL, NULL, n);
 }
 
+static int flower_parse_l2tpv3(char *str, __u8 ip_proto,
+			       struct nlmsghdr *n)
+{
+	__be32 sid;
+	int ret;
+
+	if (ip_proto != IPPROTO_L2TP) {
+		fprintf(stderr,
+			"Can't set \"l2tpv3_sid\" if ip_proto isn't l2tp\n");
+		return -1;
+	}
+	ret = get_be32(&sid, str, 10);
+	if (ret < 0) {
+		fprintf(stderr, "Illegal \"l2tpv3 session id\"\n");
+		return -1;
+	}
+	addattr32(n, MAX_MSG, TCA_FLOWER_KEY_L2TPV3_SID, sid);
+
+	return 0;
+}
+
 static int flower_port_attr_type(__u8 ip_proto, enum flower_endpoint endpoint)
 {
 	if (ip_proto == IPPROTO_TCP)
@@ -1840,6 +1871,11 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"icmp code\"\n");
 				return -1;
 			}
+		} else if (!strcmp(*argv, "l2tpv3_sid")) {
+			NEXT_ARG();
+			ret = flower_parse_l2tpv3(*argv, ip_proto, n);
+			if (ret < 0)
+				return -1;
 		} else if (matches(*argv, "arp_tip") == 0) {
 			NEXT_ARG();
 			ret = flower_parse_arp_ip_addr(*argv, eth_type,
@@ -2153,6 +2189,8 @@ static void flower_print_ip_proto(__u8 *p_ip_proto,
 		sprintf(out, "icmp");
 	else if (ip_proto == IPPROTO_ICMPV6)
 		sprintf(out, "icmpv6");
+	else if (ip_proto == IPPROTO_L2TP)
+		sprintf(out, "l2tp");
 	else
 		sprintf(out, "%02x", ip_proto);
 
@@ -2880,6 +2918,14 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 		flower_print_masked_u8("icmp_code", tb[nl_type],
 				       tb[nl_mask_type], NULL);
 
+	if (tb[TCA_FLOWER_KEY_L2TPV3_SID]) {
+		struct rtattr *attr = tb[TCA_FLOWER_KEY_L2TPV3_SID];
+
+		print_nl();
+		print_uint(PRINT_ANY, "l2tpv3_sid", "  l2tpv3_sid %u",
+			   rta_getattr_be32(attr));
+	}
+
 	flower_print_ip4_addr("arp_sip", tb[TCA_FLOWER_KEY_ARP_SIP],
 			     tb[TCA_FLOWER_KEY_ARP_SIP_MASK]);
 	flower_print_ip4_addr("arp_tip", tb[TCA_FLOWER_KEY_ARP_TIP],
-- 
2.31.1

