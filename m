Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE66420CF9
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhJDNKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:10:45 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45346 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbhJDNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 09:09:06 -0400
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 43E00200E2B0;
        Mon,  4 Oct 2021 15:07:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 43E00200E2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633352835;
        bh=p5KAnNB84VUlJCXJo12oJp37F67sajSALjzgCqrDbNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LsBbJcXmFM1JfqK+A91OKjdVjalVS/dF5qtBWS9IVjHwb0qo+2FMlqUDYTPl/bAg
         oQ/CPSWNna/RHlir/MGDfaNCTlwJXLK/3J7YPaKd/JJai1oTq6LyuIsxmS5NZini65
         d0xs4Ds8GnpN6eBUdSveIaiZgok7vJaYWqzT7O7mRJwVerQZ2QJIOVjVbob/M3zMRe
         jH1ubgdX7BN0nZHrJ8jKGyZ4S3IKHYl7OeuW76RHPHBM5BLmZduu0DD32TJFl/CfTP
         5Vx3QB3Y9UhiOMHLnsI2OC3tajn6FNrZvEYKPmE7i8+XQAyZpSydpYWSwgCm9bAxB1
         meeiLeO+7sIXw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next 1/2] Add support for IOAM encap modes
Date:   Mon,  4 Oct 2021 15:06:50 +0200
Message-Id: <20211004130651.13571-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004130651.13571-1-justin.iurman@uliege.be>
References: <20211004130651.13571-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the three IOAM encap modes that were introduced:
inline, encap and auto.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/ioam6_iptunnel.h |  29 ++++++
 ip/iproute_lwtunnel.c               | 142 ++++++++++++++++++++--------
 2 files changed, 129 insertions(+), 42 deletions(-)

diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
index fdf52e66..7bd20212 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -9,9 +9,38 @@
 #ifndef _LINUX_IOAM6_IPTUNNEL_H
 #define _LINUX_IOAM6_IPTUNNEL_H
 
+/* Encap modes:
+ *  - inline: direct insertion
+ *  - encap: ip6ip6 encapsulation
+ *  - auto: inline for local packets, encap for in-transit packets
+ */
+enum {
+	__IOAM6_IPTUNNEL_MODE_MIN,
+
+	IOAM6_IPTUNNEL_MODE_INLINE,
+	IOAM6_IPTUNNEL_MODE_ENCAP,
+	IOAM6_IPTUNNEL_MODE_AUTO,
+
+	__IOAM6_IPTUNNEL_MODE_MAX,
+};
+
+#define IOAM6_IPTUNNEL_MODE_MIN (__IOAM6_IPTUNNEL_MODE_MIN + 1)
+#define IOAM6_IPTUNNEL_MODE_MAX (__IOAM6_IPTUNNEL_MODE_MAX - 1)
+
 enum {
 	IOAM6_IPTUNNEL_UNSPEC,
+
+	/* Encap mode */
+	IOAM6_IPTUNNEL_MODE,		/* u8 */
+
+	/* Tunnel dst address.
+	 * For encap,auto modes.
+	 */
+	IOAM6_IPTUNNEL_DST,		/* struct in6_addr */
+
+	/* IOAM Trace Header */
 	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
+
 	__IOAM6_IPTUNNEL_MAX,
 };
 
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 218d5086..3641f9ef 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -210,16 +210,54 @@ static void print_encap_rpl(FILE *fp, struct rtattr *encap)
 	print_rpl_srh(fp, srh);
 }
 
+static const char *ioam6_mode_types[] = {
+	[IOAM6_IPTUNNEL_MODE_INLINE]	= "inline",
+	[IOAM6_IPTUNNEL_MODE_ENCAP]	= "encap",
+	[IOAM6_IPTUNNEL_MODE_AUTO]	= "auto",
+};
+
+static const char *format_ioam6mode_type(int mode)
+{
+	if (mode < IOAM6_IPTUNNEL_MODE_MIN ||
+	    mode > IOAM6_IPTUNNEL_MODE_MAX ||
+	    !ioam6_mode_types[mode])
+		return "<unknown>";
+
+	return ioam6_mode_types[mode];
+}
+
+static __u8 read_ioam6mode_type(const char *mode)
+{
+	__u8 i;
+
+	for (i = IOAM6_IPTUNNEL_MODE_MIN; i <= IOAM6_IPTUNNEL_MODE_MAX; i++) {
+		if (ioam6_mode_types[i] && !strcmp(mode, ioam6_mode_types[i]))
+			return i;
+	}
+
+	return 0;
+}
+
 static void print_encap_ioam6(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[IOAM6_IPTUNNEL_MAX + 1];
 	struct ioam6_trace_hdr *trace;
+	__u8 mode;
 
 	parse_rtattr_nested(tb, IOAM6_IPTUNNEL_MAX, encap);
+	if (!tb[IOAM6_IPTUNNEL_MODE] || !tb[IOAM6_IPTUNNEL_TRACE])
+		return;
 
-	if (!tb[IOAM6_IPTUNNEL_TRACE])
+	mode = rta_getattr_u8(tb[IOAM6_IPTUNNEL_MODE]);
+	if (!tb[IOAM6_IPTUNNEL_DST] && mode != IOAM6_IPTUNNEL_MODE_INLINE)
 		return;
 
+	print_string(PRINT_ANY, "mode", "mode %s ", format_ioam6mode_type(mode));
+
+	if (mode != IOAM6_IPTUNNEL_MODE_INLINE)
+		print_string(PRINT_ANY, "tundst", "tundst %s ",
+			     rt_addr_n2a_rta(AF_INET6, tb[IOAM6_IPTUNNEL_DST]));
+
 	trace = RTA_DATA(tb[IOAM6_IPTUNNEL_TRACE]);
 
 	print_null(PRINT_ANY, "trace", "trace ", NULL);
@@ -884,23 +922,48 @@ out:
 static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
 			     char ***argvp)
 {
+	int ns_found = 0, argc = *argcp;
+	__u16 trace_ns, trace_size = 0;
 	struct ioam6_trace_hdr *trace;
 	char **argv = *argvp;
-	int argc = *argcp;
-	int ns_found = 0;
-	__u16 size = 0;
-	__u32 type = 0;
-	__u16 ns;
+	__u32 trace_type = 0;
+	inet_prefix addr;
+	__u8 mode;
 
-	trace = calloc(1, sizeof(*trace));
-	if (!trace)
-		return -1;
+	if (strcmp(*argv, "mode") != 0) {
+		mode = IOAM6_IPTUNNEL_MODE_INLINE;
+	} else {
+		NEXT_ARG();
 
-	if (strcmp(*argv, "trace"))
+		mode = read_ioam6mode_type(*argv);
+		if (!mode)
+			invarg("Invalid mode", *argv);
+
+		NEXT_ARG();
+	}
+
+	if (strcmp(*argv, "tundst") != 0) {
+		if (mode != IOAM6_IPTUNNEL_MODE_INLINE)
+			missarg("tundst");
+	} else {
+		if (mode == IOAM6_IPTUNNEL_MODE_INLINE)
+			invarg("Inline mode does not need tundst", *argv);
+
+		NEXT_ARG();
+
+		get_addr(&addr, *argv, AF_INET6);
+		if (addr.family != AF_INET6 || addr.bytelen != 16)
+			invarg("Invalid IPv6 address for tundst", *argv);
+
+		NEXT_ARG();
+	}
+
+	if (strcmp(*argv, "trace") != 0)
 		missarg("trace");
 
 	NEXT_ARG();
-	if (strcmp(*argv, "prealloc"))
+
+	if (strcmp(*argv, "prealloc") != 0)
 		missarg("prealloc");
 
 	while (NEXT_ARG_OK()) {
@@ -909,63 +972,58 @@ static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
 		if (strcmp(*argv, "type") == 0) {
 			NEXT_ARG();
 
-			if (type)
+			if (trace_type)
 				duparg2("type", *argv);
 
-			if (get_u32(&type, *argv, 0) || !type)
-				invarg("Invalid type", *argv);
-
-			trace->type_be32 = htonl(type << 8);
-
+			if (get_u32(&trace_type, *argv, 0) || !trace_type)
+				invarg("Invalid trace type", *argv);
 		} else if (strcmp(*argv, "ns") == 0) {
 			NEXT_ARG();
 
 			if (ns_found++)
 				duparg2("ns", *argv);
 
-			if (!type)
-				missarg("type");
-
-			if (get_u16(&ns, *argv, 0))
+			if (get_u16(&trace_ns, *argv, 0))
 				invarg("Invalid namespace ID", *argv);
-
-			trace->namespace_id = htons(ns);
-
 		} else if (strcmp(*argv, "size") == 0) {
 			NEXT_ARG();
 
-			if (size)
+			if (trace_size)
 				duparg2("size", *argv);
 
-			if (!type)
-				missarg("type");
-			if (!ns_found)
-				missarg("ns");
+			if (get_u16(&trace_size, *argv, 0) || !trace_size)
+				invarg("Invalid trace size", *argv);
 
-			if (get_u16(&size, *argv, 0) || !size)
-				invarg("Invalid size", *argv);
-
-			if (size % 4)
-				invarg("Size must be a 4-octet multiple", *argv);
-			if (size > IOAM6_TRACE_DATA_SIZE_MAX)
-				invarg("Size too big", *argv);
-
-			trace->remlen = (__u8)(size / 4);
+			if (trace_size % 4)
+				invarg("Trace size must be a 4-octet multiple",
+				       *argv);
 
+			if (trace_size > IOAM6_TRACE_DATA_SIZE_MAX)
+				invarg("Trace size is too big", *argv);
 		} else {
 			break;
 		}
 	}
 
-	if (!type)
+	if (!trace_type)
 		missarg("type");
 	if (!ns_found)
 		missarg("ns");
-	if (!size)
+	if (!trace_size)
 		missarg("size");
 
-	if (rta_addattr_l(rta, len, IOAM6_IPTUNNEL_TRACE, trace,
-			  sizeof(*trace))) {
+	trace = calloc(1, sizeof(*trace));
+	if (!trace)
+		return -1;
+
+	trace->type_be32 = htonl(trace_type << 8);
+	trace->namespace_id = htons(trace_ns);
+	trace->remlen = (__u8)(trace_size / 4);
+
+	if (rta_addattr8(rta, len, IOAM6_IPTUNNEL_MODE, mode) ||
+	    (mode != IOAM6_IPTUNNEL_MODE_INLINE &&
+	     rta_addattr_l(rta, len, IOAM6_IPTUNNEL_DST, &addr.data, addr.bytelen)) ||
+	    rta_addattr_l(rta, len, IOAM6_IPTUNNEL_TRACE, trace, sizeof(*trace))) {
 		free(trace);
 		return -1;
 	}
-- 
2.25.1

