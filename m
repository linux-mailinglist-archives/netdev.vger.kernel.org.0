Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E629D5746B5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiGNI1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiGNI1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:27:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A323AE40
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657787250; x=1689323250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HSLULb0oinDjbg4u3V9VTIfMhrGxmz3NhTaHxTLSBzo=;
  b=fpA+GvIIaktFqyCvxEwCMmF/96oRbmXTTBLTACpHLf0MBVAwrHMgLShK
   kILlv8pdvy2dDfYOe1DCZpiBwnou2sV11UATsVc49VyWmdRSRSqb2AGfN
   tOSZdIHbnEEovyqn6P1fYg84iKQrzzzTKy8+yJEtr3Bv9LfvGbMDm9SAr
   OqXfcVakldCc8/IVpWc5FYSjxxP3EE91xtI4GjX02yEK5yql6p+T14xfF
   0UmNY2LeGeubjc6RqEEaKrGjpPj9AS9yf72S69WbKsil/x70MR8kaTn/g
   F1RX3rpgfut0ABc7msGiTGDb3gXtpqsk7lAe+5KDMbUlDGlvNg2dh1UGo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="349420054"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="349420054"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 01:27:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="663701013"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2022 01:27:28 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26E8RQl8029602;
        Thu, 14 Jul 2022 09:27:27 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next 2/2] f_flower: Introduce PPPoE support
Date:   Thu, 14 Jul 2022 10:25:22 +0200
Message-Id: <20220714082522.54913-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220714082522.54913-1-wojciech.drewek@intel.com>
References: <20220714082522.54913-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 include/uapi/linux/pkt_cls.h |  3 ++
 man/man8/tc-flower.8         | 17 ++++++++++-
 tc/f_flower.c                | 56 ++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 1 deletion(-)

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
index 622ec321f310..be7446f1014b 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -20,6 +20,7 @@
 #include <linux/ip.h>
 #include <linux/tc_act/tc_vlan.h>
 #include <linux/mpls.h>
+#include <linux/ppp_defs.h>
 
 #include "utils.h"
 #include "tc_util.h"
@@ -1887,6 +1888,43 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
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
+			if (ret < 0 || sid == 0xffff) {
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
@@ -2851,6 +2889,24 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
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

