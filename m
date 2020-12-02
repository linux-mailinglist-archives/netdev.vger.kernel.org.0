Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A5D2CBE25
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgLBNZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:25:15 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:40528 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgLBNZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 08:25:15 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 08:25:14 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0B2DG0ID016134
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 2 Dec 2020 14:16:01 +0100
From:   Paolo Lungaroni <paolo.lungaroni@cnit.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: [iproute2-next v2] seg6: add support for vrftable attribute in SRv6 End.DT4/DT6 behaviors
Date:   Wed,  2 Dec 2020 14:15:51 +0100
Message-Id: <20201202131551.19628-1-paolo.lungaroni@cnit.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce the "vrftable" attribute for supporting the SRv6 End.DT4 and
End.DT6 behaviors in iproute2.
The "vrftable" attribute indicates the routing table associated with
the VRF device used by SRv6 End.DT4/DT6 for routing IPv4/IPv6 packets.

The SRv6 End.DT4/DT6 is used to implement IPv4/IPv6 L3 VPNs based on Segment
Routing over IPv6 networks in multi-tenants environments.
It decapsulates the received packets and it performs the IPv4/IPv6 routing
lookup in the routing table of the tenant.

The SRv6 End.DT4/DT6 leverages a VRF device in order to force the routing
lookup into the associated routing table using the "vrftable" attribute.

Some examples:
 $ ip -6 route add 2001:db8::1 encap seg6local action End.DT4 vrftable 100 dev eth0
 $ ip -6 route add 2001:db8::2 encap seg6local action End.DT6 vrftable 200 dev eth0

Standard Output:
 $ ip -6 route show 2001:db8::1
 2001:db8::1  encap seg6local action End.DT4 vrftable 100 dev eth0 metric 1024 pref medium

JSON Output:
$ ip -6 -j -p route show 2001:db8::2
[ {
        "dst": "2001:db8::2",
        "encap": "seg6local",
        "action": "End.DT6",
        "vrftable": 200,
        "dev": "eth0",
        "metric": 1024,
        "flags": [ ],
        "pref": "medium"
} ]

v2:
 - no changes made: resubmit after pulling out this patch from the kernel
   patchset.

v1:
 - mixing this patch with the kernel patchset confused patckwork.

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  1 +
 ip/iproute_lwtunnel.c           | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 5312de80..bb5c8ddf 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -26,6 +26,7 @@ enum {
 	SEG6_LOCAL_IIF,
 	SEG6_LOCAL_OIF,
 	SEG6_LOCAL_BPF,
+	SEG6_LOCAL_VRFTABLE,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 9b4f0885..1ab95cd2 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -294,6 +294,11 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 			     rtnl_rttable_n2a(rta_getattr_u32(tb[SEG6_LOCAL_TABLE]),
 			     b1, sizeof(b1)));
 
+	if (tb[SEG6_LOCAL_VRFTABLE])
+		print_string(PRINT_ANY, "vrftable", "vrftable %s ",
+			     rtnl_rttable_n2a(rta_getattr_u32(tb[SEG6_LOCAL_VRFTABLE]),
+			     b1, sizeof(b1)));
+
 	if (tb[SEG6_LOCAL_NH4]) {
 		print_string(PRINT_ANY, "nh4",
 			     "nh4 %s ", rt_addr_n2a_rta(AF_INET, tb[SEG6_LOCAL_NH4]));
@@ -860,9 +865,10 @@ static int lwt_parse_bpf(struct rtattr *rta, size_t len,
 static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				 char ***argvp)
 {
-	int segs_ok = 0, hmac_ok = 0, table_ok = 0, nh4_ok = 0, nh6_ok = 0;
-	int iif_ok = 0, oif_ok = 0, action_ok = 0, srh_ok = 0, bpf_ok = 0;
-	__u32 action = 0, table, iif, oif;
+	int segs_ok = 0, hmac_ok = 0, table_ok = 0, vrftable_ok = 0;
+	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0;
+	__u32 action = 0, table, vrftable, iif, oif;
+	int action_ok = 0, srh_ok = 0, bpf_ok = 0;
 	struct ipv6_sr_hdr *srh;
 	char **argv = *argvp;
 	int argc = *argcp;
@@ -887,6 +893,13 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				duparg2("table", *argv);
 			rtnl_rttable_a2n(&table, *argv);
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_TABLE, table);
+		} else if (strcmp(*argv, "vrftable") == 0) {
+			NEXT_ARG();
+			if (vrftable_ok++)
+				duparg2("vrftable", *argv);
+			rtnl_rttable_a2n(&vrftable, *argv);
+			ret = rta_addattr32(rta, len, SEG6_LOCAL_VRFTABLE,
+					    vrftable);
 		} else if (strcmp(*argv, "nh4") == 0) {
 			NEXT_ARG();
 			if (nh4_ok++)
-- 
2.20.1

