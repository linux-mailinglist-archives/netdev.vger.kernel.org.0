Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8226583CC7
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiG1LDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiG1LDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:03:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE4566133
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659006194; x=1690542194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MivkN7o7RjWX4FSBa2M87yeUW25x+JEFoAjWht/x4/A=;
  b=eSv+HDzXheuk7YIDH+NyQHFHwC8mKF46lod8huEQRBReyBGfzeiVndp6
   pZ1doLXTqOHXSc+VOpIdrDxcS3oJmzK1i0qoQf48xbQK4gDPkpmm2rcO2
   epau1cM2wfZcLWwRwlZcpDeZZvZFcJ641OwkRP2ur/aZ3O5xBq0/WVJw+
   nBP8QBJzUq0/JQljNEhEB1ZFQmqR+7tH4PF/Tp/hhu/PInxDbG8lPVYR0
   RYvXN1NdjPkaUQLf/G7hPg1LNMDQQBxBZDeHLcDZ3D+b2dhq7ZI22Gnpl
   yH0BwzQggCkllaApXhBSjYF5i1Lu03l4qrRaO93kEbgRuUXNIoo7RwLDo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="268865110"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="268865110"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 04:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="690258062"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2022 04:03:13 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26SB3BbM019284;
        Thu, 28 Jul 2022 12:03:12 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v3 3/3] f_flower: Introduce PPPoE support
Date:   Thu, 28 Jul 2022 13:01:17 +0200
Message-Id: <20220728110117.492855-4-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220728110117.492855-1-wojciech.drewek@intel.com>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce PPPoE specific fields in tc-flower:
- session id (16 bits)
- ppp protocol (16 bits)
Those fields can be provided only when protocol was set to
ETH_P_PPP_SES. ppp_proto works similar to vlan_ethtype, i.e.
ppp_proto overwrites eth_type. Thanks to that, fields from
encapsulated protocols (such as src_ip) can be specified.

e.g.
  # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
      flower \
        pppoe_sid 1234 \
        ppp_proto ip \
        dst_ip 127.0.0.1 \
        src_ip 127.0.0.2 \
      action drop

Vlan and cvlan is also supported, in this case cvlan_ethtype
or vlan_ethtype has to be set to ETH_P_PPP_SES.

e.g.
  # tc filter add dev ens6f0 ingress prio 1 protocol 802.1Q \
      flower \
        vlan_id 2 \
        vlan_ethtype ppp_ses \
        pppoe_sid 1234 \
        ppp_proto ip \
        dst_ip 127.0.0.1 \
        src_ip 127.0.0.2 \
      action drop

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v3: don't reject 0xffff session ID
---
 include/uapi/linux/pkt_cls.h |  3 ++
 man/man8/tc-flower.8         | 17 ++++++++++-
 tc/f_flower.c                | 58 ++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 9a2ee1e39fad..a67dcd8294c9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -589,6 +589,9 @@ enum {
 
 	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
 
+	TCA_FLOWER_KEY_PPPOE_SID,	/* u16 */
+	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 523935242ccf..5e486ea31d37 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -40,6 +40,10 @@ flower \- flow based traffic control filter
 .IR PRIORITY " | "
 .BR cvlan_ethtype " { " ipv4 " | " ipv6 " | "
 .IR ETH_TYPE " } | "
+.B pppoe_sid
+.IR PSID " | "
+.BR ppp_proto " { " ip " | " ipv6 " | " mpls_uc " | " mpls_mc " | "
+.IR PPP_PROTO " } | "
 .B mpls
 .IR LSE_LIST " | "
 .B mpls_label
@@ -202,7 +206,18 @@ Match on QinQ layer three protocol.
 may be either
 .BR ipv4 ", " ipv6
 or an unsigned 16bit value in hexadecimal format.
-
+.TP
+.BI pppoe_sid " PSID"
+Match on PPPoE session id.
+.I PSID
+is an unsigned 16bit value in decimal format.
+.TP
+.BI ppp_proto " PPP_PROTO"
+Match on PPP layer three protocol.
+.I PPP_PROTO
+may be either
+.BR ip ", " ipv6 ", " mpls_uc ", " mpls_mc
+or an unsigned 16bit value in hexadecimal format.
 .TP
 .BI mpls " LSE_LIST"
 Match on the MPLS label stack.
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 622ec321f310..069896a48f33 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -20,6 +20,7 @@
 #include <linux/ip.h>
 #include <linux/tc_act/tc_vlan.h>
 #include <linux/mpls.h>
+#include <linux/ppp_defs.h>
 
 #include "utils.h"
 #include "tc_util.h"
@@ -55,6 +56,8 @@ static void explain(void)
 		"			cvlan_id VID |\n"
 		"			cvlan_prio PRIORITY |\n"
 		"			cvlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
+		"			pppoe_sid PSID |\n"
+		"			ppp_proto [ ipv4 | ipv6 | mpls_uc | mpls_mc | PPP_PROTO ]"
 		"			dst_mac MASKED-LLADDR |\n"
 		"			src_mac MASKED-LLADDR |\n"
 		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
@@ -1887,6 +1890,43 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"arp_sha\"\n");
 				return -1;
 			}
+
+		} else if (!strcmp(*argv, "pppoe_sid")) {
+			__be16 sid;
+
+			NEXT_ARG();
+			if (eth_type != htons(ETH_P_PPP_SES)) {
+				fprintf(stderr,
+					"Can't set \"pppoe_sid\" if ethertype isn't PPPoE session\n");
+				return -1;
+			}
+			ret = get_be16(&sid, *argv, 10);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"pppoe_sid\"\n");
+				return -1;
+			}
+			addattr16(n, MAX_MSG, TCA_FLOWER_KEY_PPPOE_SID, sid);
+		} else if (!strcmp(*argv, "ppp_proto")) {
+			__be16 proto;
+
+			NEXT_ARG();
+			if (eth_type != htons(ETH_P_PPP_SES)) {
+				fprintf(stderr,
+					"Can't set \"ppp_proto\" if ethertype isn't PPPoE session\n");
+				return -1;
+			}
+			if (ppp_proto_a2n(&proto, *argv))
+				invarg("invalid ppp_proto", *argv);
+			/* get new ethtype for later parsing  */
+			if (proto == htons(PPP_IP))
+				eth_type = htons(ETH_P_IP);
+			else if (proto == htons(PPP_IPV6))
+				eth_type = htons(ETH_P_IPV6);
+			else if (proto == htons(PPP_MPLS_UC))
+				eth_type = htons(ETH_P_MPLS_UC);
+			else if (proto == htons(PPP_MPLS_MC))
+				eth_type = htons(ETH_P_MPLS_MC);
+			addattr16(n, MAX_MSG, TCA_FLOWER_KEY_PPP_PROTO, proto);
 		} else if (matches(*argv, "enc_dst_ip") == 0) {
 			NEXT_ARG();
 			ret = flower_parse_ip_addr(*argv, 0,
@@ -2851,6 +2891,24 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_eth_addr("arp_tha", tb[TCA_FLOWER_KEY_ARP_THA],
 			      tb[TCA_FLOWER_KEY_ARP_THA_MASK]);
 
+	if (tb[TCA_FLOWER_KEY_PPPOE_SID]) {
+		struct rtattr *attr = tb[TCA_FLOWER_KEY_PPPOE_SID];
+
+		print_nl();
+		print_uint(PRINT_ANY, "pppoe_sid", "  pppoe_sid %u",
+			   rta_getattr_be16(attr));
+	}
+
+	if (tb[TCA_FLOWER_KEY_PPP_PROTO]) {
+		SPRINT_BUF(buf);
+		struct rtattr *attr = tb[TCA_FLOWER_KEY_PPP_PROTO];
+
+		print_nl();
+		print_string(PRINT_ANY, "ppp_proto", "  ppp_proto %s",
+			     ppp_proto_n2a(rta_getattr_u16(attr),
+			     buf, sizeof(buf)));
+	}
+
 	flower_print_ip_addr("enc_dst_ip",
 			     tb[TCA_FLOWER_KEY_ENC_IPV4_DST_MASK] ?
 			     htons(ETH_P_IP) : htons(ETH_P_IPV6),
-- 
2.31.1

