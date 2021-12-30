Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9D8481924
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhL3D6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhL3D6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836724; x=1672372724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u1ELHxpyNCf1RCbpTw6DNfBEVTDxwJX+shCST/j92XQ=;
  b=eefPB+ZKohEVNklsUy69AEGFvoWIMrLMGgbX11SzvCNqX5FLhLylxItX
   X2TLjSnPxhgZXfiGf5bOL+/vXg0K0lNOtw6cHh1Moln3U0b1g4B7zeD3G
   wkLIlQnFB4gENAjpb+IkMCKwxvw5stIWrLSLI2IDWYr0nN4pkVEdn8Tik
   U4gbgYDra1wK4KBYk+i7CvX9P4tDKzeZtsO9VqMMfUJd7OrVFDW1XBnX5
   tu6EuRS5rPlrRWW59J/RMwfUrWFA6NvlVZlgMKRXQu9CDfqaNOwIezvj0
   1DqxPn6qJHq1z6BHiGTZWZ3pK/QiDf80xYIdQvyog0M8cX51yatolbDeu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154640"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154640"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801547"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:40 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next v2 5/7] samples/bpf: xdpsock: add sched policy and priority support
Date:   Thu, 30 Dec 2021 11:54:45 +0800
Message-Id: <20211230035447.523177-6-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, TX schedule policy is SCHED_OTHER (round-robin time-sharing).
To improve TX cyclic scheduling, we add SCHED_FIFO policy and its priority
by using -W FIFO or --policy=FIFO and -U <PRIO> or --schpri=<PRIO>.

A) From xdpsock --app-stats, for SCHED_OTHER policy:
   $ xdpsock -i eth0 -t -N -z -T 1000 -b 16 -C 100000 -a

                      period     min        ave        max        cycle
   Cyclic TX          1000000    53507      75334      712642     6250

B) For SCHED_FIFO policy and schpri=50:
   $ xdpsock -i eth0 -t -N -z -T 1000 -b 16 -C 100000 -a -W FIFO -U 50

                      period     min        ave        max        cycle
   Cyclic TX          1000000    3699       24859      54397      6250

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 61 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index a2a42ec4b0e..b7d0f536f97 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -31,6 +31,7 @@
 #include <sys/un.h>
 #include <time.h>
 #include <unistd.h>
+#include <sched.h>
 
 #include <bpf/libbpf.h>
 #include <bpf/xsk.h>
@@ -66,6 +67,8 @@
 #define NSEC_PER_SEC		1000000000UL
 #define NSEC_PER_USEC		1000
 
+#define SCHED_PRI__DEFAULT	0
+
 typedef __u64 u64;
 typedef __u32 u32;
 typedef __u16 u16;
@@ -123,6 +126,8 @@ static bool opt_busy_poll;
 static bool opt_reduced_cap;
 static clockid_t opt_clock = CLOCK_MONOTONIC;
 static unsigned long opt_tx_cycle_ns;
+static int opt_schpolicy = SCHED_OTHER;
+static int opt_schprio = SCHED_PRI__DEFAULT;
 
 struct vlan_ethhdr {
 	unsigned char h_dest[6];
@@ -198,6 +203,15 @@ static const struct clockid_map {
 	{ NULL }
 };
 
+static const struct sched_map {
+	const char *name;
+	int policy;
+} schmap[] = {
+	{ "OTHER", SCHED_OTHER },
+	{ "FIFO", SCHED_FIFO },
+	{ NULL }
+};
+
 static int num_socks;
 struct xsk_socket_info *xsks[MAX_SOCKS];
 int sock;
@@ -216,6 +230,20 @@ static int get_clockid(clockid_t *id, const char *name)
 	return -1;
 }
 
+static int get_schpolicy(int *policy, const char *name)
+{
+	const struct sched_map *sch;
+
+	for (sch = schmap; sch->name; sch++) {
+		if (strcasecmp(sch->name, name) == 0) {
+			*policy = sch->policy;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
 static unsigned long get_nsecs(void)
 {
 	struct timespec ts;
@@ -1019,6 +1047,8 @@ static struct option long_options[] = {
 	{"tx-dmac", required_argument, 0, 'G'},
 	{"tx-smac", required_argument, 0, 'H'},
 	{"tx-cycle", required_argument, 0, 'T'},
+	{"policy", required_argument, 0, 'W'},
+	{"schpri", required_argument, 0, 'U'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -1066,6 +1096,8 @@ static void usage(const char *prog)
 		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -T, --tx-cycle=n     Tx cycle time in micro-seconds (For -t|--txonly).\n"
+		"  -W, --policy=POLICY  Schedule policy. Default: SCHED_OTHER\n"
+		"  -U, --schpri=n       Schedule priority. Default: %d\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -1076,7 +1108,8 @@ static void usage(const char *prog)
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
 		XSK_UMEM__DEFAULT_FRAME_SIZE, opt_pkt_fill_pattern,
-		VLAN_VID__DEFAULT, VLAN_PRI__DEFAULT);
+		VLAN_VID__DEFAULT, VLAN_PRI__DEFAULT,
+		SCHED_PRI__DEFAULT);
 
 	exit(EXIT_FAILURE);
 }
@@ -1088,7 +1121,8 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:T:xQaI:BR",
+		c = getopt_long(argc, argv,
+				"Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:T:W:U:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1206,6 +1240,17 @@ static void parse_command_line(int argc, char **argv)
 			opt_tx_cycle_ns = atoi(optarg);
 			opt_tx_cycle_ns *= NSEC_PER_USEC;
 			break;
+		case 'W':
+			if (get_schpolicy(&opt_schpolicy, optarg)) {
+				fprintf(stderr,
+					"ERROR: Invalid policy %s. Default to SCHED_OTHER.\n",
+					optarg);
+				opt_schpolicy = SCHED_OTHER;
+			}
+			break;
+		case 'U':
+			opt_schprio = atoi(optarg);
+			break;
 		case 'x':
 			opt_extra_stats = 1;
 			break;
@@ -1780,6 +1825,7 @@ int main(int argc, char **argv)
 	struct __user_cap_data_struct data[2] = { { 0 } };
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx = false, tx = false;
+	struct sched_param schparam;
 	struct xsk_umem_info *umem;
 	struct bpf_object *obj;
 	int xsks_map_fd = 0;
@@ -1881,6 +1927,16 @@ int main(int argc, char **argv)
 	prev_time = get_nsecs();
 	start_time = prev_time;
 
+	/* Configure sched priority for better wake-up accuracy */
+	memset(&schparam, 0, sizeof(schparam));
+	schparam.sched_priority = opt_schprio;
+	ret = sched_setscheduler(0, opt_schpolicy, &schparam);
+	if (ret) {
+		fprintf(stderr, "Error(%d) in setting priority(%d): %s\n",
+			errno, opt_schprio, strerror(errno));
+		goto out;
+	}
+
 	if (opt_bench == BENCH_RXDROP)
 		rx_drop_all();
 	else if (opt_bench == BENCH_TXONLY)
@@ -1888,6 +1944,7 @@ int main(int argc, char **argv)
 	else
 		l2fwd_all();
 
+out:
 	benchmark_done = true;
 
 	if (!opt_quiet)
-- 
2.25.1

