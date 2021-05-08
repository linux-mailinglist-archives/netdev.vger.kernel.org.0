Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04063772B4
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhEHPqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:46:20 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:41410 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhEHPqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 11:46:20 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 148Fj61v002205
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 8 May 2021 17:45:06 +0200
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [iproute2-next v2] seg6: add counters support for SRv6 Behaviors
Date:   Sat,  8 May 2021 17:44:58 +0200
Message-Id: <20210508154458.3127-1-paolo.lungaroni@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce the "count" optional attribute for supporting counters in SRv6
Behaviors as defined in [1], section 6. For each SRv6 Behavior instance,
counters defined in [1] are:

 - the total number of packets that have been correctly processed;
 - the total amount of traffic in bytes of all packets that have been
   correctly processed;

In addition, we introduce a new counter that counts the number of packets
that have NOT been properly processed (i.e. errors) by an SRv6 Behavior
instance.

Each SRv6 Behavior instance can be configured, at the time of its creation,
to make use of counters specifing the "count" attribute as follows:

 $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0

per-behavior counters can be shown by adding "-s" to the iproute2 command
line, i.e.:

 $ ip -s -6 route show 2001:db8::1
 2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters

v2:
 - add help and route.8 man page updates

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
---
 include/uapi/linux/seg6_local.h | 30 ++++++++++++++
 ip/iproute.c                    |  9 ++++-
 ip/iproute_lwtunnel.c           | 72 ++++++++++++++++++++++++++++++++-
 man/man8/ip-route.8.in          | 13 ++++--
 4 files changed, 119 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index bb5c8ddf..85955514 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -27,6 +27,7 @@ enum {
 	SEG6_LOCAL_OIF,
 	SEG6_LOCAL_BPF,
 	SEG6_LOCAL_VRFTABLE,
+	SEG6_LOCAL_COUNTERS,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
@@ -78,4 +79,33 @@ enum {
 
 #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
 
+/* SRv6 Behavior counters are encoded as netlink attributes guaranteeing the
+ * correct alignment.
+ * Each counter is identified by a different attribute type (i.e.
+ * SEG6_LOCAL_CNT_PACKETS).
+ *
+ * - SEG6_LOCAL_CNT_PACKETS: identifies a counter that counts the number of
+ *   packets that have been CORRECTLY processed by an SRv6 Behavior instance
+ *   (i.e., packets that generate errors or are dropped are NOT counted).
+ *
+ * - SEG6_LOCAL_CNT_BYTES: identifies a counter that counts the total amount
+ *   of traffic in bytes of all packets that have been CORRECTLY processed by
+ *   an SRv6 Behavior instance (i.e., packets that generate errors or are
+ *   dropped are NOT counted).
+ *
+ * - SEG6_LOCAL_CNT_ERRORS: identifies a counter that counts the number of
+ *   packets that have NOT been properly processed by an SRv6 Behavior instance
+ *   (i.e., packets that generate errors or are dropped).
+ */
+enum {
+	SEG6_LOCAL_CNT_UNSPEC,
+	SEG6_LOCAL_CNT_PAD,		/* pad for 64 bits values */
+	SEG6_LOCAL_CNT_PACKETS,
+	SEG6_LOCAL_CNT_BYTES,
+	SEG6_LOCAL_CNT_ERRORS,
+	__SEG6_LOCAL_CNT_MAX,
+};
+
+#define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
+
 #endif
diff --git a/ip/iproute.c b/ip/iproute.c
index 5853f026..c6d87e58 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -102,9 +102,16 @@ static void usage(void)
 		"BOOL := [1|0]\n"
 		"FEATURES := ecn\n"
 		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl ]\n"
-		"ENCAPHDR := [ MPLSLABEL | SEG6HDR ]\n"
+		"ENCAPHDR := [ MPLSLABEL | SEG6HDR | SEG6LOCAL ]\n"
 		"SEG6HDR := [ mode SEGMODE ] segs ADDR1,ADDRi,ADDRn [hmac HMACKEYID] [cleanup]\n"
 		"SEGMODE := [ encap | inline ]\n"
+		"SEG6LOCAL := action ACTION [ OPTIONS ] [ count ]\n"
+		"ACTION := { End | End.X | End.T | End.DX2 | End.DX6 | End.DX4 |\n"
+		"            End.DT6 | End.DT4 | End.B6 | End.B6.Encaps | End.BM |\n"
+		"            End.S | End.AS | End.AM | End.BPF }\n"
+		"OPTIONS := OPTION [ OPTIONS ]\n"
+		"OPTION := { srh SEG6HDR | nh4 ADDR | nh6 ADDR | iif DEV | oif DEV |\n"
+		"            table TABLEID | vrftable TABLEID | endpoint PROGNAME }\n"
 		"ROUTE_GET_FLAGS := [ fibmatch ]\n");
 	exit(-1);
 }
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 566fc7ea..ebc688e2 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -266,6 +266,42 @@ static void print_encap_bpf_prog(FILE *fp, struct rtattr *encap,
 	}
 }
 
+static void print_seg6_local_counters(FILE *fp, struct rtattr *encap)
+{
+	struct rtattr *tb[SEG6_LOCAL_CNT_MAX + 1];
+	__u64 packets = 0, bytes = 0, errors = 0;
+
+	parse_rtattr_nested(tb, SEG6_LOCAL_CNT_MAX, encap);
+
+	if (tb[SEG6_LOCAL_CNT_PACKETS])
+		packets = rta_getattr_u64(tb[SEG6_LOCAL_CNT_PACKETS]);
+
+	if (tb[SEG6_LOCAL_CNT_BYTES])
+		bytes = rta_getattr_u64(tb[SEG6_LOCAL_CNT_BYTES]);
+
+	if (tb[SEG6_LOCAL_CNT_ERRORS])
+		errors = rta_getattr_u64(tb[SEG6_LOCAL_CNT_ERRORS]);
+
+	if (is_json_context()) {
+		open_json_object("stats64");
+
+		print_u64(PRINT_JSON, "packets", NULL, packets);
+		print_u64(PRINT_JSON, "bytes", NULL, bytes);
+		print_u64(PRINT_JSON, "errors", NULL, errors);
+
+		close_json_object();
+	} else {
+		print_string(PRINT_FP, NULL, "%s ", "packets");
+		print_num(fp, 1, packets);
+
+		print_string(PRINT_FP, NULL, "%s ", "bytes");
+		print_num(fp, 1, bytes);
+
+		print_string(PRINT_FP, NULL, "%s ", "errors");
+		print_num(fp, 1, errors);
+	}
+}
+
 static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[SEG6_LOCAL_MAX + 1];
@@ -325,6 +361,9 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 
 	if (tb[SEG6_LOCAL_BPF])
 		print_encap_bpf_prog(fp, tb[SEG6_LOCAL_BPF], "endpoint");
+
+	if (tb[SEG6_LOCAL_COUNTERS] && show_stats)
+		print_seg6_local_counters(fp, tb[SEG6_LOCAL_COUNTERS]);
 }
 
 static void print_encap_mpls(FILE *fp, struct rtattr *encap)
@@ -862,13 +901,39 @@ static int lwt_parse_bpf(struct rtattr *rta, size_t len,
 	return 0;
 }
 
+/* for the moment, counters are always initialized to zero by the kernel; so we
+ * do not expect to parse any argument here.
+ */
+static int seg6local_fill_counters(struct rtattr *rta, size_t len, int attr)
+{
+	struct rtattr *nest;
+	int ret;
+
+	nest = rta_nest(rta, len, attr);
+
+	ret = rta_addattr64(rta, len, SEG6_LOCAL_CNT_PACKETS, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = rta_addattr64(rta, len, SEG6_LOCAL_CNT_BYTES, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = rta_addattr64(rta, len, SEG6_LOCAL_CNT_ERRORS, 0);
+	if (ret < 0)
+		return ret;
+
+	rta_nest_end(rta, nest);
+	return 0;
+}
+
 static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				 char ***argvp)
 {
 	int segs_ok = 0, hmac_ok = 0, table_ok = 0, vrftable_ok = 0;
+	int action_ok = 0, srh_ok = 0, bpf_ok = 0, counters_ok = 0;
 	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0;
 	__u32 action = 0, table, vrftable, iif, oif;
-	int action_ok = 0, srh_ok = 0, bpf_ok = 0;
 	struct ipv6_sr_hdr *srh;
 	char **argv = *argvp;
 	int argc = *argcp;
@@ -932,6 +997,11 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 			if (!oif)
 				exit(nodev(*argv));
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_OIF, oif);
+		} else if (strcmp(*argv, "count") == 0) {
+			if (counters_ok++)
+				duparg2("count", *argv);
+			ret = seg6local_fill_counters(rta, len,
+						      SEG6_LOCAL_COUNTERS);
 		} else if (strcmp(*argv, "srh") == 0) {
 			NEXT_ARG();
 			if (srh_ok++)
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index 34763cc3..2978bc0e 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -240,7 +240,8 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 .B seg6local
 .BR action
 .IR SEG6_ACTION " [ "
-.IR SEG6_ACTION_PARAM " ] "
+.IR SEG6_ACTION_PARAM " ] [ "
+.BR count " ] "
 
 .ti -8
 .IR ROUTE_GET_FLAGS " := "
@@ -801,8 +802,14 @@ is a set of encapsulation attributes specific to the
 .B seg6local
 .in +2
 .IR SEG6_ACTION " [ "
-.IR SEG6_ACTION_PARAM " ] "
-- Operation to perform on matching packets.
+.IR SEG6_ACTION_PARAM " ] [ "
+.BR count " ] "
+- Operation to perform on matching packets. The optional \fBcount\fR
+attribute is used to collect statistics on the processing of actions.
+Three counters are implemented: 1) packets correctly processed;
+2) bytes correctly processed; 3) packets that cause a processing error
+(i.e., missing SID List, wrong SID List, etc). To retrieve the counters
+related to an action use the \fB-s\fR flag in the \fBshow\fR command.
 The following actions are currently supported (\fBLinux 4.14+ only\fR).
 .in +2
 
-- 
2.20.1

