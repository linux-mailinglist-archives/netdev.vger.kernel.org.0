Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288FF54741E
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 13:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiFKLIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 07:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiFKLIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 07:08:09 -0400
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Jun 2022 04:08:07 PDT
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEF326E
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 04:08:05 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25BB6rpw007814
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Jun 2022 13:06:53 +0200
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [iproute2-next v1] seg6: add support for flavors in SRv6 End* behaviors
Date:   Sat, 11 Jun 2022 13:06:45 +0200
Message-Id: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As described in RFC 8986 [1], processing operations carried out by SRv6
End, End.X and End.T (End* for short) behaviors can be modified or
extended using the "flavors" mechanism. This patch adds the support for
PSP,USP,USD flavors (defined in [1]) and for NEXT-C-SID flavor (defined
in [2]) in SRv6 End* behaviors. Specifically, we add a new optional
attribute named "flavors" that can be leveraged by the user to enable
specific flavors while creating an SRv6 End* behavior instance.
Multiple flavors can be specified together by separating them using
commas.

If a specific flavor (or a combination of flavors) is not supported by the
underlying Linux kernel, an error message is reported to the user and the
creation of the specific behavior instance is aborted.

When the flavors attribute is omitted, the regular SRv6 End* behavior is
performed.

Flavors such as PSP, USP and USD do not accept additional configuration
attributes. Conversely, the NEXT-C-SID flavor can be configured to support
user-provided Locator-Block and Locator-Node Function lengths using,
respectively, the lblen and the nflen attributes.

Both lblen and nflen values must be evenly divisible by 8 and their sum
must not exceed 128 bit (i.e. the C-SID container size).

If the lblen attribute is omitted, the default value chosen by the Linux
kernel is 32-bit. If the nflen attribute is omitted, the default value
chosen by the Linux kernel is 16-bit.

Some examples:
ip -6 route add 2001:db8::1 encap seg6local action End flavors next-csid dev eth0
ip -6 route add 2001:db8::2 encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0

Standard Output:
ip -6 route show 2001:db8::2
2001:db8::2  encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0 metric 1024 pref medium

JSON Output:
ip -6 -j -p route show 2001:db8::2
[ {
        "dst": "2001:db8::2",
        "encap": "seg6local",
        "action": "End",
        "flavors": [ "next-csid" ],
        "lblen": 48,
        "nflen": 16,
        "dev": "eth0",
        "metric": 1024,
        "flags": [ ],
        "pref": "medium"
} ]

[1] - https://datatracker.ietf.org/doc/html/rfc8986
[2] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  24 ++++
 ip/iproute_lwtunnel.c           | 188 +++++++++++++++++++++++++++++++-
 man/man8/ip-route.8.in          |  71 +++++++++++-
 3 files changed, 280 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index ab724498..12f76829 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -28,6 +28,7 @@ enum {
 	SEG6_LOCAL_BPF,
 	SEG6_LOCAL_VRFTABLE,
 	SEG6_LOCAL_COUNTERS,
+	SEG6_LOCAL_FLAVORS,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
@@ -110,4 +111,27 @@ enum {
 
 #define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
 
+/* SRv6 End* Flavor attributes */
+enum {
+	SEG6_LOCAL_FLV_UNSPEC,
+	SEG6_LOCAL_FLV_OPERATION,
+	SEG6_LOCAL_FLV_LCBLOCK_LEN,
+	SEG6_LOCAL_FLV_LCNODE_FN_LEN,
+	__SEG6_LOCAL_FLV_MAX,
+};
+
+#define SEG6_LOCAL_FLV_MAX (__SEG6_LOCAL_FLV_MAX - 1)
+
+/* Designed flavor operations for SRv6 End* Behavior */
+enum {
+	SEG6_LOCAL_FLV_OP_UNSPEC,
+	SEG6_LOCAL_FLV_OP_PSP,
+	SEG6_LOCAL_FLV_OP_USP,
+	SEG6_LOCAL_FLV_OP_USD,
+	SEG6_LOCAL_FLV_OP_NEXT_CSID,
+	__SEG6_LOCAL_FLV_OP_MAX
+};
+
+#define SEG6_LOCAL_FLV_OP_MAX (__SEG6_LOCAL_FLV_OP_MAX - 1)
+
 #endif
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index f4192229..112846cc 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -157,6 +157,102 @@ static int read_seg6mode_type(const char *mode)
 	return -1;
 }
 
+static const char *seg6_flavor_names[SEG6_LOCAL_FLV_OP_MAX + 1] = {
+	[SEG6_LOCAL_FLV_OP_PSP]		= "psp",
+	[SEG6_LOCAL_FLV_OP_USP]		= "usp",
+	[SEG6_LOCAL_FLV_OP_USD]		= "usd",
+	[SEG6_LOCAL_FLV_OP_NEXT_CSID]	= "next-csid"
+};
+
+static int read_seg6_local_flv_type(const char *name)
+{
+	int i;
+
+	for (i = 1; i < SEG6_LOCAL_FLV_OP_MAX + 1; ++i) {
+		if (!seg6_flavor_names[i])
+			continue;
+
+		if (strcasecmp(seg6_flavor_names[i], name) == 0)
+			return i;
+	}
+
+	return -1;
+}
+
+#define SEG6_LOCAL_FLV_BUF_SIZE 32
+static int parse_seg6local_flavors(const char *buf, __u32 *flv_mask)
+{
+	unsigned char flavor_ok[SEG6_LOCAL_FLV_OP_MAX + 1] = { 0, };
+	char wbuf[SEG6_LOCAL_FLV_BUF_SIZE];
+	__u32 mask = 0;
+	int index;
+	char *s;
+
+	/* strtok changes first parameter, so we need to make a local copy */
+	strlcpy(wbuf, buf, SEG6_LOCAL_FLV_BUF_SIZE);
+	wbuf[SEG6_LOCAL_FLV_BUF_SIZE - 1] = 0;
+
+	if (strlen(wbuf) == 0)
+		return -1;
+
+	for (s = strtok((char *) wbuf, ","); s; s = strtok(NULL, ",")) {
+		index = read_seg6_local_flv_type(s);
+		if (index < 0 || index > SEG6_LOCAL_FLV_OP_MAX)
+			return -1;
+		/* we check for duplicates */
+		if (flavor_ok[index]++)
+			return -1;
+
+		mask |= (1 << index);
+	}
+
+	*flv_mask = mask;
+	return 0;
+}
+
+static void print_flavors(FILE *fp, __u32 flavors)
+{
+	int i, fnumber = 0;
+	char *flv_name;
+
+	if (is_json_context())
+		open_json_array(PRINT_JSON, "flavors");
+	else
+		fprintf(fp, "flavors ");
+
+	for (i = 0; i < SEG6_LOCAL_FLV_OP_MAX + 1; ++i) {
+		if (flavors & (1 << i)) {
+			flv_name = (char *) seg6_flavor_names[i];
+			if (!flv_name)
+				continue;
+
+			if (is_json_context())
+				print_string(PRINT_JSON, NULL, NULL, flv_name);
+			else {
+				if (fnumber++ == 0)
+					fprintf(fp, "%s", flv_name);
+				else
+					fprintf(fp, ",%s", flv_name);
+			}
+		}
+	}
+
+	if (is_json_context())
+		close_json_array(PRINT_JSON, NULL);
+	else
+		fprintf(fp, " ");
+}
+
+static void print_flavors_attr(FILE *fp, const char *key, __u32 value)
+{
+	if (is_json_context()) {
+		print_u64(PRINT_JSON, key, NULL, value);
+	} else {
+		print_string(PRINT_FP, NULL, "%s ", key);
+		print_num(fp, 1, value);
+	}
+}
+
 static void print_encap_seg6(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[SEG6_IPTUNNEL_MAX+1];
@@ -374,6 +470,30 @@ static void print_seg6_local_counters(FILE *fp, struct rtattr *encap)
 	}
 }
 
+static void print_seg6_local_flavors(FILE *fp, struct rtattr *encap)
+{
+	struct rtattr *tb[SEG6_LOCAL_FLV_MAX + 1];
+	__u8 lbl = 0, nfl = 0;
+	__u32 flavors = 0;
+
+	parse_rtattr_nested(tb, SEG6_LOCAL_FLV_MAX, encap);
+
+	if (tb[SEG6_LOCAL_FLV_OPERATION]) {
+		flavors = rta_getattr_u32(tb[SEG6_LOCAL_FLV_OPERATION]);
+		print_flavors(fp, flavors);
+	}
+
+	if (tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]) {
+		lbl = rta_getattr_u8(tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]);
+		print_flavors_attr(fp, "lblen", lbl);
+	}
+
+	if (tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]) {
+		nfl = rta_getattr_u8(tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]);
+		print_flavors_attr(fp, "nflen", nfl);
+	}
+}
+
 static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[SEG6_LOCAL_MAX + 1];
@@ -436,6 +556,9 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 
 	if (tb[SEG6_LOCAL_COUNTERS] && show_stats)
 		print_seg6_local_counters(fp, tb[SEG6_LOCAL_COUNTERS]);
+
+	if (tb[SEG6_LOCAL_FLAVORS])
+		print_seg6_local_flavors(fp, tb[SEG6_LOCAL_FLAVORS]);
 }
 
 static void print_encap_mpls(FILE *fp, struct rtattr *encap)
@@ -1175,12 +1298,66 @@ static int seg6local_fill_counters(struct rtattr *rta, size_t len, int attr)
 	return 0;
 }
 
+static int seg6local_parse_flavors(struct rtattr *rta, size_t len,
+			 int *argcp, char ***argvp, int attr)
+{
+	int lbl_ok = 0, nfl_ok = 0;
+	__u8 lbl = 0, nfl = 0;
+	struct rtattr *nest;
+	__u32 flavors = 0;
+	int ret;
+
+	char **argv = *argvp;
+	int argc = *argcp;
+
+	nest = rta_nest(rta, len, attr);
+
+	ret = parse_seg6local_flavors(*argv, &flavors);
+	if (ret < 0)
+		return ret;
+
+	ret = rta_addattr32(rta, len, SEG6_LOCAL_FLV_OPERATION, flavors);
+	if (ret < 0)
+		return ret;
+
+	if (flavors & (1 << SEG6_LOCAL_FLV_OP_NEXT_CSID)) {
+		NEXT_ARG_FWD();
+		if (strcmp(*argv, "lblen") == 0){
+			NEXT_ARG();
+			if (lbl_ok++)
+				duparg2("lblen", *argv);
+			if (get_u8(&lbl, *argv, 0))
+				invarg("\"locator-block length\" value is invalid\n", *argv);
+			ret = rta_addattr8(rta, len, SEG6_LOCAL_FLV_LCBLOCK_LEN, lbl);
+			NEXT_ARG_FWD();
+		}
+
+		if (strcmp(*argv, "nflen") == 0){
+			NEXT_ARG();
+			if (nfl_ok++)
+				duparg2("nflen", *argv);
+			if (get_u8(&nfl, *argv, 0))
+				invarg("\"locator-node function length\" value is invalid\n", *argv);
+			ret = rta_addattr8(rta, len, SEG6_LOCAL_FLV_LCNODE_FN_LEN, nfl);
+			NEXT_ARG_FWD();
+		}
+		PREV_ARG();
+	}
+
+	rta_nest_end(rta, nest);
+
+	*argcp = argc;
+	*argvp = argv;
+
+	return 0;
+}
+
 static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				 char ***argvp)
 {
+	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0, flavors_ok = 0;
 	int segs_ok = 0, hmac_ok = 0, table_ok = 0, vrftable_ok = 0;
 	int action_ok = 0, srh_ok = 0, bpf_ok = 0, counters_ok = 0;
-	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0;
 	__u32 action = 0, table, vrftable, iif, oif;
 	struct ipv6_sr_hdr *srh;
 	char **argv = *argvp;
@@ -1250,6 +1427,15 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				duparg2("count", *argv);
 			ret = seg6local_fill_counters(rta, len,
 						      SEG6_LOCAL_COUNTERS);
+		} else if (strcmp(*argv, "flavors") == 0) {
+			NEXT_ARG();
+			if (flavors_ok++)
+				duparg2("flavors", *argv);
+
+			if (seg6local_parse_flavors(rta, len, &argc, &argv,
+						    SEG6_LOCAL_FLAVORS))
+				invarg("invalid \"flavors\" attribute\n",
+					*argv);
 		} else if (strcmp(*argv, "srh") == 0) {
 			NEXT_ARG();
 			if (srh_ok++)
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index 462ff269..3364815c 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -834,10 +834,14 @@ related to an action use the \fB-s\fR flag in the \fBshow\fR command.
 The following actions are currently supported (\fBLinux 4.14+ only\fR).
 .in +2
 
-.B End
+.BR End " [ " flavors
+.IR FLAVORS " ] "
 - Regular SRv6 processing as intermediate segment endpoint.
 This action only accepts packets with a non-zero Segments Left
-value. Other matching packets are dropped.
+value. Other matching packets are dropped. The presence of flavors
+can change the regular processing of an End behavior according to
+the user-provided Flavor operations and information carried in the packet.
+See \fBFlavors parameters\fR section.
 
 .B End.X nh6
 .I NEXTHOP
@@ -917,8 +921,61 @@ Additionally, encapsulate the matching packet within an outer IPv6 header
 followed by the specified SRH. The destination address of the outer IPv6
 header is set to the first segment of the new SRH. The source
 address is set as described in \fBip-sr\fR(8).
+
+.B Flavors parameters
+
+The flavors represent additional operations that can modify or extend a
+subset of the existing behaviors.
+.in +2
+
+.B flavors
+.IR OPERATION "[," OPERATION "] [" ATTRIBUTES "]"
+.in +2
+
+.IR OPERATION " := { "
+.BR psp " | "
+.BR usp " | "
+.BR usd " | "
+.BR next-csid " }"
+
+.IR ATTRIBUTES " := {"
+.IR "KEY VALUE" " } ["
+.IR ATTRIBUTES " ]"
+
+.IR KEY " := { "
+.BR lblen " | "
+.BR nflen " } "
 .in -2
 
+.B psp
+- Penultimate Segment Pop of the SRH (not yet supported in kernel)
+
+.B usp
+- Ultimate Segment Pop of the SRH (not yet supported in kernel)
+
+.B usd
+- Ultimate Segment Decapsulation (not yet supported in kernel)
+
+.B next-csid
+- The NEXT-C-SID mechanism offers the possibility of encoding
+several SRv6 segments within a single 128 bit SID address. The NEXT-C-SID
+flavor can be configured to support user-provided Locator-Block and
+Locator-Node Function lengths. If Locator-Block and/or Locator-Node Function
+lengths are not provided by the user during configuration of an SRv6 End
+behavior instance with NEXT-C-SID flavor, the default value is 32-bit for
+Locator-Block and 16-bit for Locator-Node Function.
+
+.BI lblen " VALUE "
+- defines the Locator-Block length for NEXT-C-SID flavor.
+The Locator Block length must be evenly divisible by 8. This attribute
+can be used only with NEXT-C-SID flavor.
+
+.BI nflen " VALUE "
+- defines the Locator-Node Function length for NEXT-C-SID
+flavors. The Locator-Node Function length must be evenly divisible
+by 8. This attribute can be used only with NEXT-C-SID flavor.
+.in -4
+
 .B ioam6
 .in +2
 .B freq K/N
@@ -1279,6 +1336,16 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
 Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
 .RE
 .PP
+ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors next-csid dev eth0
+.RS 4
+Adds an IPv6 route with SRv6 End behavior with next-csid flavor enabled.
+.RE
+.PP
+ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0
+.RS 4
+Adds an IPv6 route with SRv6 End behavior with next-csid flavor enabled and user-provided Locator-Block and Locator-Node Function lengths.
+.RE
+.PP
 ip -6 route add 2001:db8:1::/64 encap ioam6 freq 2/5 mode encap tundst 2001:db8:42::1 trace prealloc type 0x800000 ns 1 size 12 dev eth0
 .RS 4
 Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation (ip6ip6) that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets (will be injected in 2 packets every 5 packets).
-- 
2.20.1

