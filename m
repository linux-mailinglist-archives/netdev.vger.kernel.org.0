Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F88B35741A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355183AbhDGSUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:20:53 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:33222 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355179AbhDGSUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:20:45 -0400
X-Greylist: delayed 784 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 14:20:45 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 137I7OSE014812
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 7 Apr 2021 20:07:25 +0200
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [RFC iproute2-next] seg6: add counters support for SRv6 Behaviors
Date:   Wed,  7 Apr 2021 20:07:04 +0200
Message-Id: <20210407180704.13511-1-paolo.lungaroni@uniroma2.it>
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

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  8 ++++++++
 ip/iproute_lwtunnel.c           | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index bb5c8ddf..a243bb7b 100644
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
@@ -78,4 +79,11 @@ enum {
 
 #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
 
+/* SRv6 Behavior counters */
+struct seg6_local_counters {
+	__u64 rx_packets;
+	__u64 rx_bytes;
+	__u64 rx_errors;
+};
+
 #endif
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 566fc7ea..2fe5062e 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -125,6 +125,27 @@ static void print_srh(FILE *fp, struct ipv6_sr_hdr *srh)
 	}
 }
 
+static void print_seg6_local_counters(FILE *fp,
+				      struct seg6_local_counters *lcounts)
+{
+	if (is_json_context()) {
+		open_json_object("stats64");
+
+		print_u64(PRINT_JSON, "packets", NULL, lcounts->rx_packets);
+		print_u64(PRINT_JSON, "bytes", NULL, lcounts->rx_bytes);
+		print_u64(PRINT_JSON, "errors", NULL, lcounts->rx_errors);
+
+		close_json_object();
+	} else {
+		print_string(PRINT_FP, NULL, "%s ", "packets");
+		print_num(fp, 1, lcounts->rx_packets);
+		print_string(PRINT_FP, NULL, "%s ", "bytes");
+		print_num(fp, 1, lcounts->rx_bytes);
+		print_string(PRINT_FP, NULL, "%s ", "errors");
+		print_num(fp, 1, lcounts->rx_errors);
+	}
+}
+
 static const char *seg6_mode_types[] = {
 	[SEG6_IPTUN_MODE_INLINE]	= "inline",
 	[SEG6_IPTUN_MODE_ENCAP]		= "encap",
@@ -325,6 +346,9 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 
 	if (tb[SEG6_LOCAL_BPF])
 		print_encap_bpf_prog(fp, tb[SEG6_LOCAL_BPF], "endpoint");
+
+	if (tb[SEG6_LOCAL_COUNTERS] && show_stats)
+		print_seg6_local_counters(fp, RTA_DATA(tb[SEG6_LOCAL_COUNTERS]));
 }
 
 static void print_encap_mpls(FILE *fp, struct rtattr *encap)
@@ -866,9 +890,10 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 				 char ***argvp)
 {
 	int segs_ok = 0, hmac_ok = 0, table_ok = 0, vrftable_ok = 0;
+	int action_ok = 0, srh_ok = 0, bpf_ok = 0, counters_ok = 0;
 	int nh4_ok = 0, nh6_ok = 0, iif_ok = 0, oif_ok = 0;
+	struct seg6_local_counters counters = { 0, 0, 0 };
 	__u32 action = 0, table, vrftable, iif, oif;
-	int action_ok = 0, srh_ok = 0, bpf_ok = 0;
 	struct ipv6_sr_hdr *srh;
 	char **argv = *argvp;
 	int argc = *argcp;
@@ -932,6 +957,11 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 			if (!oif)
 				exit(nodev(*argv));
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_OIF, oif);
+		} else if (strcmp(*argv, "count") == 0) {
+			if (counters_ok++)
+				duparg2("count", *argv);
+			ret = rta_addattr_l(rta, len, SEG6_LOCAL_COUNTERS,
+					    &counters, sizeof(counters));
 		} else if (strcmp(*argv, "srh") == 0) {
 			NEXT_ARG();
 			if (srh_ok++)
-- 
2.20.1

