Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8182D2A1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfE2AAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:00:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727254AbfE1X77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:59:59 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4SNqYrY011072
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Jyo2xa/3v/cVoaeFDHmBew1VMTWLlZb5soyKjCX///U=;
 b=pUY/fmxp0tB+pBWwA3Sf/YuSg0/FGzZwgrhlMETDgg1XpmLzBUHjLR/TwtFf6Z/lB8YS
 u0bEH1hx9S7D6qOf/0C/7TrDpGqrZR5WpSka5csmqQvqPe8rdhVKRh6kN4wk8l9q1Bzt
 qHPWJQq44LEbJRV7gxn0JkhBP9X14UrCe9Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ss7tv1nnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 16:59:57 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id E09705AE2482; Tue, 28 May 2019 16:59:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 5/6] bpf: Add cn support to hbm_out_kern.c
Date:   Tue, 28 May 2019 16:59:39 -0700
Message-ID: <20190528235940.1452963-6-brakmo@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235940.1452963-1-brakmo@fb.com>
References: <20190528235940.1452963-1-brakmo@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update hbm_out_kern.c to support returning cn notifications.
Also updates relevant files to allow disabling cn notifications.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
---
 samples/bpf/do_hbm_test.sh | 10 +++++++---
 samples/bpf/hbm.c          | 18 +++++++++++++++---
 samples/bpf/hbm.h          |  3 ++-
 samples/bpf/hbm_out_kern.c | 26 +++++++++++++++++++++-----
 4 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/do_hbm_test.sh b/samples/bpf/do_hbm_test.sh
index 56c8b4115c95..e48b047d4646 100755
--- a/samples/bpf/do_hbm_test.sh
+++ b/samples/bpf/do_hbm_test.sh
@@ -13,10 +13,10 @@ Usage() {
   echo "egress or ingress bandwidht. It then uses iperf3 or netperf to create"
   echo "loads. The output is the goodput in Mbps (unless -D was used)."
   echo ""
-  echo "USAGE: $name [out] [-b=<prog>|--bpf=<prog>] [-c=<cc>|--cc=<cc>] [-D]"
-  echo "             [-d=<delay>|--delay=<delay>] [--debug] [-E]"
+  echo "USAGE: $name [out] [-b=<prog>|--bpf=<prog>] [-c=<cc>|--cc=<cc>]"
+  echo "             [-D] [-d=<delay>|--delay=<delay>] [--debug] [-E]"
   echo "             [-f=<#flows>|--flows=<#flows>] [-h] [-i=<id>|--id=<id >]"
-  echo "             [-l] [-N] [-p=<port>|--port=<port>] [-P]"
+  echo "             [-l] [-N] [--no_cn] [-p=<port>|--port=<port>] [-P]"
   echo "             [-q=<qdisc>] [-R] [-s=<server>|--server=<server]"
   echo "             [-S|--stats] -t=<time>|--time=<time>] [-w] [cubic|dctcp]"
   echo "  Where:"
@@ -33,6 +33,7 @@ Usage() {
   echo "    -f or --flows     number of concurrent flows (default=1)"
   echo "    -i or --id        cgroup id (an integer, default is 1)"
   echo "    -N                use netperf instead of iperf3"
+  echo "    --no_cn           Do not return CN notifications"
   echo "    -l                do not limit flows using loopback"
   echo "    -h                Help"
   echo "    -p or --port      iperf3 port (default is 5201)"
@@ -115,6 +116,9 @@ processArgs () {
     -c=*|--cc=*)
       cc="${i#*=}"
       ;;
+    --no_cn)
+      flags="$flags --no_cn"
+      ;;
     --debug)
       flags="$flags -d"
       debug_flag=1
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index a79828ab273f..c5629bae67ab 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -16,6 +16,7 @@
  *    -l	Also limit flows doing loopback
  *    -n <#>	To create cgroup \"/hbm#\" and attach prog
  *		Default is /hbm1
+ *    --no_cn   Do not return cn notifications
  *    -r <rate>	Rate limit in Mbps
  *    -s	Get HBM stats (marked, dropped, etc.)
  *    -t <time>	Exit after specified seconds (default is 0)
@@ -42,6 +43,7 @@
 
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
+#include <getopt.h>
 
 #include "bpf_load.h"
 #include "bpf_rlimit.h"
@@ -59,6 +61,7 @@ bool stats_flag;
 bool loopback_flag;
 bool debugFlag;
 bool work_conserving_flag;
+bool no_cn_flag;
 
 static void Usage(void);
 static void read_trace_pipe2(void);
@@ -185,6 +188,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 	qstats.rate = rate;
 	qstats.stats = stats_flag ? 1 : 0;
 	qstats.loopback = loopback_flag ? 1 : 0;
+	qstats.no_cn = no_cn_flag ? 1 : 0;
 	if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY)) {
 		printf("ERROR: Could not update map element\n");
 		goto err;
@@ -366,14 +370,15 @@ static void Usage(void)
 {
 	printf("This program loads a cgroup skb BPF program to enforce\n"
 	       "cgroup output (egress) bandwidth limits.\n\n"
-	       "USAGE: hbm [-o] [-d]  [-l] [-n <id>] [-r <rate>] [-s]\n"
-	       "           [-t <secs>] [-w] [-h] [prog]\n"
+	       "USAGE: hbm [-o] [-d]  [-l] [-n <id>] [--no_cn] [-r <rate>]\n"
+	       "           [-s] [-t <secs>] [-w] [-h] [prog]\n"
 	       "  Where:\n"
 	       "    -o         indicates egress direction (default)\n"
 	       "    -d         print BPF trace debug buffer\n"
 	       "    -l         also limit flows using loopback\n"
 	       "    -n <#>     to create cgroup \"/hbm#\" and attach prog\n"
 	       "               Default is /hbm1\n"
+	       "    --no_cn    disable CN notifcations\n"
 	       "    -r <rate>  Rate in Mbps\n"
 	       "    -s         Update HBM stats\n"
 	       "    -t <time>  Exit after specified seconds (default is 0)\n"
@@ -393,9 +398,16 @@ int main(int argc, char **argv)
 	int  k;
 	int cg_id = 1;
 	char *optstring = "iodln:r:st:wh";
+	struct option loptions[] = {
+		{"no_cn", 0, NULL, 1},
+		{NULL, 0, NULL, 0}
+	};
 
-	while ((k = getopt(argc, argv, optstring)) != -1) {
+	while ((k = getopt_long(argc, argv, optstring, loptions, NULL)) != -1) {
 		switch (k) {
+		case 1:
+			no_cn_flag = true;
+			break;
 		case'o':
 			break;
 		case 'd':
diff --git a/samples/bpf/hbm.h b/samples/bpf/hbm.h
index 518e8147d084..c08247cec2a7 100644
--- a/samples/bpf/hbm.h
+++ b/samples/bpf/hbm.h
@@ -19,7 +19,8 @@ struct hbm_vqueue {
 struct hbm_queue_stats {
 	unsigned long rate;		/* in Mbps*/
 	unsigned long stats:1,		/* get HBM stats (marked, dropped,..) */
-		loopback:1;		/* also limit flows using loopback */
+		loopback:1,		/* also limit flows using loopback */
+		no_cn:1;		/* do not use cn flags */
 	unsigned long long pkts_marked;
 	unsigned long long bytes_marked;
 	unsigned long long pkts_dropped;
diff --git a/samples/bpf/hbm_out_kern.c b/samples/bpf/hbm_out_kern.c
index f806863d0b79..fa3ea92e1564 100644
--- a/samples/bpf/hbm_out_kern.c
+++ b/samples/bpf/hbm_out_kern.c
@@ -119,13 +119,16 @@ int _hbm_out_cg(struct __sk_buff *skb)
 	// Set flags (drop, congestion, cwr)
 	// Dropping => we are congested, so ignore congestion flag
 	if (credit < -DROP_THRESH ||
-	    (len > LARGE_PKT_THRESH &&
-	     credit < -LARGE_PKT_DROP_THRESH)) {
-		// Very congested, set drop flag
+	    (len > LARGE_PKT_THRESH && credit < -LARGE_PKT_DROP_THRESH)) {
+		// Very congested, set drop packet
 		drop_flag = true;
+		if (pkti.ecn)
+			congestion_flag = true;
+		else if (pkti.is_tcp)
+			cwr_flag = true;
 	} else if (credit < 0) {
 		// Congested, set congestion flag
-		if (pkti.ecn) {
+		if (pkti.ecn || pkti.is_tcp) {
 			if (credit < -MARK_THRESH)
 				congestion_flag = true;
 			else
@@ -137,7 +140,15 @@ int _hbm_out_cg(struct __sk_buff *skb)
 
 	if (congestion_flag) {
 		if (!bpf_skb_ecn_set_ce(skb)) {
-			if (len > LARGE_PKT_THRESH) {
+			if (pkti.is_tcp) {
+				unsigned int rand = bpf_get_prandom_u32();
+
+				if (-credit >= MARK_THRESH +
+				    (rand % MARK_REGION_SIZE)) {
+					// Do congestion control
+					cwr_flag = true;
+				}
+			} else if (len > LARGE_PKT_THRESH) {
 				// Problem if too many small packets?
 				drop_flag = true;
 			}
@@ -146,12 +157,17 @@ int _hbm_out_cg(struct __sk_buff *skb)
 
 	if (drop_flag)
 		rv = DROP_PKT;
+	if (qsp != NULL)
+		if (qsp->no_cn)
+			cwr_flag = false;
 
 	hbm_update_stats(qsp, len, curtime, congestion_flag, drop_flag);
 
 	if (rv == DROP_PKT)
 		__sync_add_and_fetch(&(qdp->credit), len);
 
+	if (cwr_flag)
+		rv |= 2;
 	return rv;
 }
 char _license[] SEC("license") = "GPL";
-- 
2.17.1

