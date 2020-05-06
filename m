Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C1B1C7699
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgEFQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:35:45 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46990 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbgEFQfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:35:42 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GZdet026733;
        Wed, 6 May 2020 11:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782939;
        bh=nmEZ4pVhYsJX4wbJGkNDX2MJ4Binj2UCBLHiwfYIqMw=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=G7+BXn9/EnqAhbWMGtyOT1zbKUulIJ2iJ0s1wcUQgt5QpTzLYqg5pDJCUWbDsSbwX
         BcR/zU69CkqmLmfPZCoNuPJWX45+Rr/tt15j4Cd9+SZ3WcDYKixN5pz+bEEClxnrhQ
         WmC85WA3R/lfXraP4451Oa5dZmCSfE/13W31HJeQ=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GZdE5110814;
        Wed, 6 May 2020 11:35:39 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:35:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:35:38 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GZbQH128992;
        Wed, 6 May 2020 11:35:38 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 1/2] add support for PRP similar to HSR
Date:   Wed, 6 May 2020 12:35:36 -0400
Message-ID: <20200506163537.3958-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163537.3958-1-m-karicheri2@ti.com>
References: <20200506163537.3958-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PRP protocol is similar to HSR in many aspects and this patch add a
command type prp to create prp interface using two slave interfaces
similar to HSR

HSR and PRP interfaces are setup in a similar way in kernel as
the protocols shares many similar attributes. So restructure
the code to avoid duplication and use a unified netlink
interface for both HSR and PRP

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 include/uapi/linux/if_link.h |  16 ++++-
 ip/Makefile                  |   5 +-
 ip/iplink_hsr.c              | 111 +++-------------------------------
 ip/iplink_hsr_prp_common.c   | 114 +++++++++++++++++++++++++++++++++++
 ip/iplink_hsr_prp_common.h   |  24 ++++++++
 ip/iplink_prp.c              |  60 ++++++++++++++++++
 6 files changed, 223 insertions(+), 107 deletions(-)
 create mode 100644 ip/iplink_hsr_prp_common.c
 create mode 100644 ip/iplink_hsr_prp_common.h
 create mode 100644 ip/iplink_prp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 978f98c76be1..30d9d2c9c12f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -904,7 +904,6 @@ enum {
 
 
 /* HSR section */
-
 enum {
 	IFLA_HSR_UNSPEC,
 	IFLA_HSR_SLAVE1,
@@ -915,7 +914,6 @@ enum {
 	IFLA_HSR_VERSION,		/* HSR version */
 	__IFLA_HSR_MAX,
 };
-
 #define IFLA_HSR_MAX (__IFLA_HSR_MAX - 1)
 
 /* STATS section */
@@ -1052,4 +1050,18 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* HSR-PRP section */
+enum {
+	IFLA_HSR_PRP_UNSPEC,
+	IFLA_HSR_PRP_SLAVE1,
+	IFLA_HSR_PRP_SLAVE2,
+	IFLA_HSR_PRP_SF_MC_ADDR_LSB,	/* Last byte of supervision addr */
+	IFLA_HSR_PRP_SF_MC_ADDR,	/* Supervision frame multicast addr */
+	IFLA_HSR_PRP_SEQ_NR,
+	IFLA_HSR_PRP_VERSION,		/* HSR version */
+	__IFLA_HSR_PRP_MAX,
+};
+
+#define IFLA_HSR_PRP_MAX (__IFLA_HSR_PRP_MAX - 1)
+
 #endif /* _LINUX_IF_LINK_H */
diff --git a/ip/Makefile b/ip/Makefile
index 5ab78d7d3b84..8dc72fbfb2b1 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -7,8 +7,9 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_vlan.o link_veth.o link_gre.o iplink_can.o iplink_xdp.o \
     iplink_macvlan.o ipl2tp.o link_vti.o link_vti6.o link_xfrm.o \
     iplink_vxlan.o tcp_metrics.o iplink_ipoib.o ipnetconf.o link_ip6tnl.o \
-    link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o iplink_hsr.o \
-    iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
+    link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o \
+    iplink_hsr_prp_common.o iplink_hsr.o iplink_prp.o iplink_bridge.o \
+    iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o
diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index 7d9167d4e6a3..d8a7f9a52267 100644
--- a/ip/iplink_hsr.c
+++ b/ip/iplink_hsr.c
@@ -11,15 +11,7 @@
  *		Based on iplink_vlan.c by Patrick McHardy <kaber@trash.net>
  */
 
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/socket.h>  /* Needed by linux/if.h for some reason */
-#include <linux/if.h>
-#include <linux/if_arp.h>
-#include "rt_names.h"
-#include "utils.h"
-#include "ip_common.h"
+#include "iplink_hsr_prp_common.h"
 
 static void print_usage(FILE *f)
 {
@@ -46,100 +38,13 @@ static void usage(void)
 static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
 			 struct nlmsghdr *n)
 {
-	int ifindex;
-	unsigned char multicast_spec;
-	unsigned char protocol_version;
+	int ret;
 
-	while (argc > 0) {
-		if (matches(*argv, "supervision") == 0) {
-			NEXT_ARG();
-			if (get_u8(&multicast_spec, *argv, 0))
-				invarg("ADDR-BYTE is invalid", *argv);
-			addattr_l(n, 1024, IFLA_HSR_MULTICAST_SPEC,
-				  &multicast_spec, 1);
-		} else if (matches(*argv, "version") == 0) {
-			NEXT_ARG();
-			if (!(get_u8(&protocol_version, *argv, 0) == 0 ||
-			      get_u8(&protocol_version, *argv, 0) == 1))
-				invarg("version is invalid", *argv);
-			addattr_l(n, 1024, IFLA_HSR_VERSION,
-				  &protocol_version, 1);
-		} else if (matches(*argv, "slave1") == 0) {
-			NEXT_ARG();
-			ifindex = ll_name_to_index(*argv);
-			if (ifindex == 0)
-				invarg("No such interface", *argv);
-			addattr_l(n, 1024, IFLA_HSR_SLAVE1, &ifindex, 4);
-		} else if (matches(*argv, "slave2") == 0) {
-			NEXT_ARG();
-			ifindex = ll_name_to_index(*argv);
-			if (ifindex == 0)
-				invarg("No such interface", *argv);
-			addattr_l(n, 1024, IFLA_HSR_SLAVE2, &ifindex, 4);
-		} else if (matches(*argv, "help") == 0) {
-			usage();
-			return -1;
-		} else {
-			fprintf(stderr, "hsr: what is \"%s\"?\n", *argv);
-			usage();
-			return -1;
-		}
-		argc--, argv++;
-	}
+	ret = hsr_prp_parse_opt(true, lu, argc, argv, n);
+	if (ret < 0)
+		usage();
 
-	return 0;
-}
-
-static void hsr_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
-{
-	SPRINT_BUF(b1);
-
-	if (!tb)
-		return;
-
-	if (tb[IFLA_HSR_SLAVE1] &&
-	    RTA_PAYLOAD(tb[IFLA_HSR_SLAVE1]) < sizeof(__u32))
-		return;
-	if (tb[IFLA_HSR_SLAVE2] &&
-	    RTA_PAYLOAD(tb[IFLA_HSR_SLAVE2]) < sizeof(__u32))
-		return;
-	if (tb[IFLA_HSR_SEQ_NR] &&
-	    RTA_PAYLOAD(tb[IFLA_HSR_SEQ_NR]) < sizeof(__u16))
-		return;
-	if (tb[IFLA_HSR_SUPERVISION_ADDR] &&
-	    RTA_PAYLOAD(tb[IFLA_HSR_SUPERVISION_ADDR]) < ETH_ALEN)
-		return;
-
-	if (tb[IFLA_HSR_SLAVE1])
-		print_string(PRINT_ANY,
-			     "slave1",
-			     "slave1 %s ",
-			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_SLAVE1])));
-	else
-		print_null(PRINT_ANY, "slave1", "slave1 %s ", "<none>");
-
-	if (tb[IFLA_HSR_SLAVE2])
-		print_string(PRINT_ANY,
-			     "slave2",
-			     "slave2 %s ",
-			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_SLAVE2])));
-	else
-		print_null(PRINT_ANY, "slave2", "slave2 %s ", "<none>");
-
-	if (tb[IFLA_HSR_SEQ_NR])
-		print_int(PRINT_ANY,
-			  "seq_nr",
-			  "sequence %d ",
-			  rta_getattr_u16(tb[IFLA_HSR_SEQ_NR]));
-
-	if (tb[IFLA_HSR_SUPERVISION_ADDR])
-		print_string(PRINT_ANY,
-			     "supervision_addr",
-			     "supervision %s ",
-			     ll_addr_n2a(RTA_DATA(tb[IFLA_HSR_SUPERVISION_ADDR]),
-					 RTA_PAYLOAD(tb[IFLA_HSR_SUPERVISION_ADDR]),
-					 ARPHRD_VOID,
-					 b1, sizeof(b1)));
+	return ret;
 }
 
 static void hsr_print_help(struct link_util *lu, int argc, char **argv,
@@ -150,8 +55,8 @@ static void hsr_print_help(struct link_util *lu, int argc, char **argv,
 
 struct link_util hsr_link_util = {
 	.id		= "hsr",
-	.maxattr	= IFLA_HSR_MAX,
+	.maxattr	= IFLA_HSR_PRP_MAX,
 	.parse_opt	= hsr_parse_opt,
-	.print_opt	= hsr_print_opt,
+	.print_opt	= hsr_prp_print_opt,
 	.print_help	= hsr_print_help,
 };
diff --git a/ip/iplink_hsr_prp_common.c b/ip/iplink_hsr_prp_common.c
new file mode 100644
index 000000000000..780c1cbb6a05
--- /dev/null
+++ b/ip/iplink_hsr_prp_common.c
@@ -0,0 +1,114 @@
+/*
+ * iplink_hsr_prp_common.c  Common utilities for hsr and prp
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Murali Karicheri <m-karicheri2@ti.com>
+ *
+ *
+ */
+
+#include "iplink_hsr_prp_common.h"
+
+int hsr_prp_parse_opt(bool hsr, struct link_util *lu, int argc, char **argv,
+		      struct nlmsghdr *n)
+{
+	int ifindex;
+	unsigned char multicast_spec;
+	unsigned char protocol_version;
+
+	while (argc > 0) {
+		if (matches(*argv, "supervision") == 0) {
+			NEXT_ARG();
+			if (get_u8(&multicast_spec, *argv, 0))
+				invarg("ADDR-BYTE is invalid", *argv);
+			addattr_l(n, 1024, IFLA_HSR_PRP_SF_MC_ADDR_LSB,
+				  &multicast_spec, 1);
+		} else if (hsr && matches(*argv, "version") == 0) {
+			NEXT_ARG();
+			if (!(get_u8(&protocol_version, *argv, 0) == 0 ||
+			      get_u8(&protocol_version, *argv, 0) == 1))
+				invarg("version is invalid", *argv);
+			addattr_l(n, 1024, IFLA_HSR_PRP_VERSION,
+				  &protocol_version, 1);
+		} else if (matches(*argv, "slave1") == 0) {
+			NEXT_ARG();
+			ifindex = ll_name_to_index(*argv);
+			if (ifindex == 0)
+				invarg("No such interface", *argv);
+			addattr_l(n, 1024, IFLA_HSR_PRP_SLAVE1, &ifindex, 4);
+		} else if (matches(*argv, "slave2") == 0) {
+			NEXT_ARG();
+			ifindex = ll_name_to_index(*argv);
+			if (ifindex == 0)
+				invarg("No such interface", *argv);
+			addattr_l(n, 1024, IFLA_HSR_PRP_SLAVE2, &ifindex, 4);
+		} else if (matches(*argv, "help") == 0) {
+			return -1;
+		} else {
+			if (hsr)
+				fprintf(stderr, "hsr: what is \"%s\"?\n", *argv);
+			else
+				fprintf(stderr, "prp: what is \"%s\"?\n", *argv);
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	return 0;
+}
+
+void hsr_prp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+	SPRINT_BUF(b1);
+
+	if (!tb)
+		return;
+
+	if (tb[IFLA_HSR_PRP_SLAVE1] &&
+	    RTA_PAYLOAD(tb[IFLA_HSR_PRP_SLAVE1]) < sizeof(__u32))
+		return;
+	if (tb[IFLA_HSR_PRP_SLAVE2] &&
+	    RTA_PAYLOAD(tb[IFLA_HSR_PRP_SLAVE2]) < sizeof(__u32))
+		return;
+	if (tb[IFLA_HSR_PRP_SEQ_NR] &&
+	    RTA_PAYLOAD(tb[IFLA_HSR_PRP_SEQ_NR]) < sizeof(__u16))
+		return;
+	if (tb[IFLA_HSR_PRP_SF_MC_ADDR] &&
+	    RTA_PAYLOAD(tb[IFLA_HSR_PRP_SF_MC_ADDR]) < ETH_ALEN)
+		return;
+
+	if (tb[IFLA_HSR_PRP_SLAVE1])
+		print_string(PRINT_ANY,
+			     "slave1",
+			     "slave1 %s ",
+			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_PRP_SLAVE1])));
+	else
+		print_null(PRINT_ANY, "slave1", "slave1 %s ", "<none>");
+
+	if (tb[IFLA_HSR_PRP_SLAVE2])
+		print_string(PRINT_ANY,
+			     "slave2",
+			     "slave2 %s ",
+			     ll_index_to_name(rta_getattr_u32(tb[IFLA_HSR_PRP_SLAVE2])));
+	else
+		print_null(PRINT_ANY, "slave2", "slave2 %s ", "<none>");
+
+	if (tb[IFLA_HSR_PRP_SEQ_NR])
+		print_int(PRINT_ANY,
+			  "seq_nr",
+			  "sequence %d ",
+			  rta_getattr_u16(tb[IFLA_HSR_PRP_SEQ_NR]));
+
+	if (tb[IFLA_HSR_PRP_SF_MC_ADDR])
+		print_string(PRINT_ANY,
+			     "supervision_addr",
+			     "supervision %s ",
+			     ll_addr_n2a(RTA_DATA(tb[IFLA_HSR_PRP_SF_MC_ADDR]),
+					 RTA_PAYLOAD(tb[IFLA_HSR_PRP_SF_MC_ADDR]),
+					 ARPHRD_VOID,
+					 b1, sizeof(b1)));
+}
diff --git a/ip/iplink_hsr_prp_common.h b/ip/iplink_hsr_prp_common.h
new file mode 100644
index 000000000000..a50bd7e532ee
--- /dev/null
+++ b/ip/iplink_hsr_prp_common.h
@@ -0,0 +1,24 @@
+/*
+ * iplink_hsr_prp_common.h	HSR/PRP common header file
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Murali Karicheri <m-karicheri2@ti.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>  /* Needed by linux/if.h for some reason */
+#include <linux/if.h>
+#include <linux/if_arp.h>
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+int hsr_prp_parse_opt(bool hsr, struct link_util *lu, int argc, char **argv,
+		      struct nlmsghdr *n);
+void hsr_prp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[]);
diff --git a/ip/iplink_prp.c b/ip/iplink_prp.c
new file mode 100644
index 000000000000..eff8a0d215fa
--- /dev/null
+++ b/ip/iplink_prp.c
@@ -0,0 +1,60 @@
+/*
+ * iplink_prp.c	PRP device support
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Murali Karicheri <m-karicheri2@ti.com>
+ *
+ *		Based on iplink_hsr.c by Arvid Brodin <arvid.brodin@alten.se>
+ */
+
+#include "iplink_hsr_prp_common.h"
+
+static void print_usage(FILE *f)
+{
+	fprintf(f,
+"Usage:\tip link add name NAME type prp slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
+"\t[ supervision ADDR-BYTE ]\n"
+"\n"
+"NAME\n"
+"	name of new prp device (e.g. prp0)\n"
+"SLAVE1-IF, SLAVE2-IF\n"
+"	the two slave devices bound to the PRP device\n"
+"ADDR-BYTE\n"
+"	0-255; the last byte of the multicast address used for PRP supervision\n"
+"	frames (default = 0)\n");
+}
+
+static void usage(void)
+{
+	print_usage(stderr);
+}
+
+static int prp_parse_opt(struct link_util *lu, int argc, char **argv,
+			 struct nlmsghdr *n)
+{
+	int ret;
+
+	ret = hsr_prp_parse_opt(false, lu, argc, argv, n);
+	if (ret < 0)
+		usage();
+
+	return ret;
+}
+
+static void prp_print_help(struct link_util *lu, int argc, char **argv,
+	FILE *f)
+{
+	print_usage(f);
+}
+
+struct link_util prp_link_util = {
+	.id		= "prp",
+	.maxattr	= IFLA_HSR_PRP_MAX,
+	.parse_opt	= prp_parse_opt,
+	.print_opt	= hsr_prp_print_opt,
+	.print_help	= prp_print_help,
+};
-- 
2.17.1

