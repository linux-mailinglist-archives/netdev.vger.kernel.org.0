Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B221CB4F
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgGLU2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 16:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLU2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 16:28:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF7EC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 13:28:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1juiaT-0002jn-Sb; Sun, 12 Jul 2020 22:28:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     aconole@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH iproute2] iplink_vxlan, geneve: Add PMTUDISC configuration
Date:   Sun, 12 Jul 2020 22:28:20 +0200
Message-Id: <20200712202820.11334-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to turn off route exception creation for the encapsulation
socket.  This is mainly useful if a vxlan interface is part of a bridge
to prevent a bogus icmp error from shutting down the vxlan port:

In a bridged environment, the sender is unaware of the icmp error
(it is only addressed to the bridge as its in response to the
outer/encap packet).  IP output path would then fetch the mtu of the
socket instead of the interface which prevents any packet large enough
(but still fitting interface mtu) from getting sent out.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: There is copy-paste between vxlan and geneve.
 If you'd like a helper please also hint where the helper function
 should be placed.  Thanks!

 include/uapi/linux/if_link.h |  2 ++
 ip/iplink_geneve.c           | 55 ++++++++++++++++++++++++++++++++----
 ip/iplink_vxlan.c            | 42 +++++++++++++++++++++++++++
 man/man8/ip-link.8.in        | 27 ++++++++++++++++++
 4 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a8901a39a345..35a44b2e88ce 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -546,6 +546,7 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_PMTUDISC,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
@@ -579,6 +580,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_PMTUDISC,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index 9299236cbd33..eedb50889e6e 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -31,13 +31,15 @@ static void print_explain(FILE *f)
 		"		[ [no]udpcsum ]\n"
 		"		[ [no]udp6zerocsumtx ]\n"
 		"		[ [no]udp6zerocsumrx ]\n"
+		"		[ pmtudisc PMTUDISC ]\n"
 		"\n"
-		"Where:	VNI   := 0-16777215\n"
-		"	ADDR  := IP_ADDRESS\n"
-		"	TOS   := { NUMBER | inherit }\n"
-		"	TTL   := { 1..255 | auto | inherit }\n"
-		"	DF    := { unset | set | inherit }\n"
-		"	LABEL := 0-1048575\n"
+		"Where:	VNI      := 0-16777215\n"
+		"	ADDR     := IP_ADDRESS\n"
+		"	TOS      := { NUMBER | inherit }\n"
+		"	TTL      := { 1..255 | auto | inherit }\n"
+		"	DF       := { unset | set | inherit }\n"
+		"       PMTUDISC := { dont | want | do | probe | interface | omit }\n"
+		"	LABEL    := 0-1048575\n"
 	);
 }
 
@@ -133,6 +135,28 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr8(n, 1024, IFLA_GENEVE_DF, df);
+		} else if (!matches(*argv, "pmtudisc")) {
+			__u8 pmtud;
+
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_GENEVE_PMTUDISC, "pmtudisc", *argv);
+			if (strcmp(*argv, "dont") == 0)
+				pmtud = IP_PMTUDISC_DONT;
+			else if (strcmp(*argv, "want") == 0)
+				pmtud = IP_PMTUDISC_WANT;
+			else if (strcmp(*argv, "do") == 0)
+				pmtud = IP_PMTUDISC_DO;
+			else if (strcmp(*argv, "probe") == 0)
+				pmtud = IP_PMTUDISC_PROBE;
+			else if (strcmp(*argv, "interface") == 0)
+				pmtud = IP_PMTUDISC_INTERFACE;
+			else if (strcmp(*argv, "omit") == 0)
+				pmtud = IP_PMTUDISC_OMIT;
+			else
+				invarg("pmtudisc must be 'dont', 'want', 'do', 'probe', 'interface' or 'omit'}",
+				       *argv);
+
+			addattr8(n, 1024, IFLA_GENEVE_PMTUDISC, pmtud);
 		} else if (!matches(*argv, "label") ||
 			   !matches(*argv, "flowlabel")) {
 			__u32 uval;
@@ -316,6 +340,25 @@ static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_string(PRINT_ANY, "df", "df %s ", "inherit");
 	}
 
+	if (tb[IFLA_GENEVE_PMTUDISC]) {
+		__u8 pmtud = rta_getattr_u8(tb[IFLA_GENEVE_PMTUDISC]);
+		const char *str = NULL;
+
+		switch (pmtud) {
+		case IP_PMTUDISC_DONT: str = "dont"; break;
+		case IP_PMTUDISC_WANT: str = "want"; break;
+		case IP_PMTUDISC_DO: str = "do"; break;
+		case IP_PMTUDISC_PROBE: str = "probe"; break;
+		case IP_PMTUDISC_INTERFACE: str = "interface"; break;
+		case IP_PMTUDISC_OMIT: str = "omit"; break;
+		}
+
+		if (str)
+			print_string(PRINT_ANY, "pmtudisc", "pmtudisc %s ", str);
+		else
+			print_uint(PRINT_ANY,  "pmtudisc", "pmtudisc %u ", pmtud);
+	}
+
 	if (tb[IFLA_GENEVE_LABEL]) {
 		__u32 label = rta_getattr_u32(tb[IFLA_GENEVE_LABEL]);
 
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index bae9d99436e5..505b3142cd2a 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -41,6 +41,7 @@ static void print_explain(FILE *f)
 		"		[ [no]rsc ]\n"
 		"		[ [no]l2miss ]\n"
 		"		[ [no]l3miss ]\n"
+		"		[ pmtudisc PMTUDISC ]\n"
 		"		[ ageing SECONDS ]\n"
 		"		[ maxaddress NUMBER ]\n"
 		"		[ [no]udpcsum ]\n"
@@ -54,6 +55,7 @@ static void print_explain(FILE *f)
 		"	TOS	:= { NUMBER | inherit }\n"
 		"	TTL	:= { 1..255 | auto | inherit }\n"
 		"	DF	:= { unset | set | inherit }\n"
+		"	PMTUDISC:= { dont | want | do | probe | interface | omit }\n"
 		"	LABEL := 0-1048575\n"
 	);
 }
@@ -188,6 +190,28 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr8(n, 1024, IFLA_VXLAN_DF, df);
+		} else if (!matches(*argv, "pmtudisc")) {
+			__u8 pmtud;
+
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_VXLAN_PMTUDISC, "pmtudisc", *argv);
+			if (strcmp(*argv, "dont") == 0)
+				pmtud = IP_PMTUDISC_DONT;
+			else if (strcmp(*argv, "want") == 0)
+				pmtud = IP_PMTUDISC_WANT;
+			else if (strcmp(*argv, "do") == 0)
+				pmtud = IP_PMTUDISC_DO;
+			else if (strcmp(*argv, "probe") == 0)
+				pmtud = IP_PMTUDISC_PROBE;
+			else if (strcmp(*argv, "interface") == 0)
+				pmtud = IP_PMTUDISC_INTERFACE;
+			else if (strcmp(*argv, "omit") == 0)
+				pmtud = IP_PMTUDISC_OMIT;
+			else
+				invarg("pmtudisc must be 'dont', 'want', 'do', 'probe', 'interface' or 'omit'}",
+				       *argv);
+
+			addattr8(n, 1024, IFLA_VXLAN_PMTUDISC, pmtud);
 		} else if (!matches(*argv, "label") ||
 			   !matches(*argv, "flowlabel")) {
 			__u32 uval;
@@ -567,6 +591,24 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_string(PRINT_ANY, "df", "df %s ", "inherit");
 	}
 
+	if (tb[IFLA_VXLAN_PMTUDISC]) {
+		__u8 pmtud = rta_getattr_u8(tb[IFLA_VXLAN_PMTUDISC]);
+		const char *str = NULL;
+
+		switch (pmtud) {
+		case IP_PMTUDISC_DONT: str = "dont"; break;
+		case IP_PMTUDISC_WANT: str = "want"; break;
+		case IP_PMTUDISC_DO: str = "do"; break;
+		case IP_PMTUDISC_PROBE: str = "probe"; break;
+		case IP_PMTUDISC_INTERFACE: str = "interface"; break;
+		case IP_PMTUDISC_OMIT: str = "omit"; break;
+		}
+
+		if (str)
+			print_string(PRINT_ANY, "pmtudisc", "pmtudisc %s ", str);
+		else
+			print_uint(PRINT_ANY,  "pmtudisc", "pmtudisc %u ", pmtud);
+	}
 	if (tb[IFLA_VXLAN_LABEL]) {
 		__u32 label = rta_getattr_u32(tb[IFLA_VXLAN_LABEL]);
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index e8a25451f7cd..e2a78c0ef891 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -532,6 +532,8 @@ the following additional arguments are supported:
 ] [
 .BI df " DF "
 ] [
+.BI pmtudisc " PMTUDISC "
+] [
 .BI flowlabel " FLOWLABEL "
 ] [
 .BI dstport " PORT "
@@ -613,6 +615,25 @@ and
 cause the bit to be always unset or always set, respectively. By default, the
 bit is not set.
 
+.sp
+.BI pmtudisc " PMTUDISC"
+- specifies the path mtu update setting of the encapsulation socket.
+This can be used to ignore updates and always use the link mtu.
+Options are the ones described in
+.BR ip "(7)":
+.B want
+.B dont
+.B do
+.B probe
+.B interface
+and
+.B omit.
+
+The default is to use the value specified in
+.I /proc/sys/net/ipv4/ip_no_pmtu_disc.
+This should only be changed when the vxlan interface is configured
+as a bridge port and only to work around erroneous path mtu updates.
+
 .sp
 .BI flowlabel " FLOWLABEL"
 - specifies the flow label to use in outgoing packets.
@@ -1217,6 +1238,8 @@ the following additional arguments are supported:
 ] [
 .BI df " DF "
 ] [
+.BI pmtudisc " PMTUDISC "
+] [
 .BI flowlabel " FLOWLABEL "
 ] [
 .BI dstport " PORT"
@@ -1261,6 +1284,10 @@ and
 cause the bit to be always unset or always set, respectively. By default, the
 bit is not set.
 
+.sp
+.BI pmtudisc " PMTUDISC"
+See the VXLAN section, the options are identical.
+
 .sp
 .BI flowlabel " FLOWLABEL"
 - specifies the flow label to use in outgoing packets.
-- 
2.26.2

