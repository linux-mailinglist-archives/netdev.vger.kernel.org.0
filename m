Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C65EBD37
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiI0I1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiI0I1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:27:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1177A4B9C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664267223; x=1695803223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VXhbykHihPAUBFCrh0oJNgEZ3P3H6jJ85FST6uFnx4s=;
  b=YkZrMmzB749dJDIJX5WUblVCac/yXAJS6rGj6Kt/lywmnvoxjvv+0KQx
   CpfGbK57lz1bv/QhEya+aLn4xehvy6wwv/KSxYFCMrw7P/9XZpYfX8T1Q
   IrwwcsIaYlQVkOdn1KcZPQWIJhuXC6JTw+5Pkv8BQ3Idnj2g2XG5ffGOF
   iMz17lgS2BpYY1al65YTuCfwcHLlqXP9ljhEr+MY58sRscH2g/NjkKdik
   WxUDRRE3l0JA4mpXkVCnfsLC8LYTD6bLl8Frt72J4JRdpTF1UXl7hfWVz
   /LnEWl9J7DO9szobdjQKhdTQI02fNChu2j1V9pdn2BbGJPNZic/Tw90lb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327612361"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327612361"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 01:27:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652199940"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652199940"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2022 01:27:02 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28R8QxxM023862;
        Tue, 27 Sep 2022 09:27:01 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
Date:   Tue, 27 Sep 2022 10:23:18 +0200
Message-Id: <20220927082318.289252-4-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927082318.289252-1-wojciech.drewek@intel.com>
References: <20220927082318.289252-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 man/man8/tc-flower.8 | 11 +++++++++--
 tc/f_flower.c        | 45 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 5e486ea31d37..4de823e4ef3e 100644
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
+Match on L2TPv3 session id field transported over IP or IPv6.
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
index 069896a48f33..cf19009c63e1 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -60,7 +60,7 @@ static void explain(void)
 		"			ppp_proto [ ipv4 | ipv6 | mpls_uc | mpls_mc | PPP_PROTO ]"
 		"			dst_mac MASKED-LLADDR |\n"
 		"			src_mac MASKED-LLADDR |\n"
-		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
+		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | l2tp | IP-PROTO ] |\n"
 		"			ip_tos MASKED-IP_TOS |\n"
 		"			ip_ttl MASKED-IP_TTL |\n"
 		"			mpls LSE-LIST |\n"
@@ -68,6 +68,7 @@ static void explain(void)
 		"			mpls_tc TC |\n"
 		"			mpls_bos BOS |\n"
 		"			mpls_ttl TTL |\n"
+		"			l2tpv3_sid LSID |\n"
 		"			dst_ip PREFIX |\n"
 		"			src_ip PREFIX |\n"
 		"			dst_port PORT-NUMBER |\n"
@@ -428,6 +429,11 @@ static int flower_parse_ip_proto(char *str, __be16 eth_type, int type,
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
@@ -646,6 +652,28 @@ static int flower_parse_icmp(char *str, __u16 eth_type, __u8 ip_proto,
 	return flower_parse_u8(str, value_type, mask_type, NULL, NULL, n);
 }
 
+static int flower_parse_l2tpv3(char *str, __be16 eth_type, __u8 ip_proto,
+			       struct nlmsghdr *n)
+{
+	__be32 sid;
+	int ret;
+
+	if ((eth_type != htons(ETH_P_IP) && eth_type != htons(ETH_P_IPV6)) ||
+	    ip_proto != IPPROTO_L2TP) {
+		fprintf(stderr,
+			"Can't set \"l2tpv3_sid\" if ethertype isn't IP and IPv6 or ip_proto isn't l2tp\n");
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
@@ -1840,6 +1868,11 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"icmp code\"\n");
 				return -1;
 			}
+		} else if (!strcmp(*argv, "l2tpv3_sid")) {
+			NEXT_ARG();
+			ret = flower_parse_l2tpv3(*argv, eth_type, ip_proto, n);
+			if (ret < 0)
+				return -1;
 		} else if (matches(*argv, "arp_tip") == 0) {
 			NEXT_ARG();
 			ret = flower_parse_arp_ip_addr(*argv, eth_type,
@@ -2153,6 +2186,8 @@ static void flower_print_ip_proto(__u8 *p_ip_proto,
 		sprintf(out, "icmp");
 	else if (ip_proto == IPPROTO_ICMPV6)
 		sprintf(out, "icmpv6");
+	else if (ip_proto == IPPROTO_L2TP)
+		sprintf(out, "l2tp");
 	else
 		sprintf(out, "%02x", ip_proto);
 
@@ -2880,6 +2915,14 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
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

