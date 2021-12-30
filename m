Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F11481920
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhL3D6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235614AbhL3D6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836716; x=1672372716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eh+J1EjCWOTZPgw04DeLPj6g1rFzAGHOPJpfkrqdhAQ=;
  b=DxZ4bXzVz56+ZZnw/eEs0nEB9yslFMA8ery1wn9ujC4A/Q6IySWs9KCD
   5ZmKhWTnzEoolY5jk+6Pfas2cQ/AuhnR7BDEdaJdugusDtKmCyGedbJ89
   xC7Fn2+DnZ8LPW1DIKU0UWj1ngHBlSSg4CliKUQ7x8B+qXfSI4eATBBIp
   qmghJSPDG2sNsEcaW+b4Xbd79B/0BlWRjUxZKHsctiqtFT32VYdAyYUd7
   H1u40ajr4em3lH7fJ4cvy6+DFzqUPcOeGx+MyRPGUQgjr9RqU7XJDfNLl
   DEUm3Jb+IVDoWDNL7E66Ga6JF8zAYNxDCcREZcGWPMl0GR5cvA9dFViY1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154629"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154629"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801538"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:32 -0800
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
Subject: [PATCH bpf-next v2 3/7] samples/bpf: xdpsock: add clockid selection support
Date:   Thu, 30 Dec 2021 11:54:43 +0800
Message-Id: <20211230035447.523177-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User specifies the clock selection by using -w CLOCK or --clock=CLOCK
where CLOCK=[REALTIME, TAI, BOOTTIME, MONOTONIC].

The default CLOCK selection is MONOTONIC.

The implementation of clock selection parsing is borrowed from
iproute2/tc/q_taprio.c

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 40 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index c9a8748a460..e6e9a20375c 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -114,6 +114,7 @@ static u32 opt_num_xsks = 1;
 static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
+static clockid_t opt_clock = CLOCK_MONOTONIC;
 
 struct vlan_ethhdr {
 	unsigned char h_dest[6];
@@ -178,15 +179,40 @@ struct xsk_socket_info {
 	u32 outstanding_tx;
 };
 
+static const struct clockid_map {
+	const char *name;
+	clockid_t clockid;
+} clockids_map[] = {
+	{ "REALTIME", CLOCK_REALTIME },
+	{ "TAI", CLOCK_TAI },
+	{ "BOOTTIME", CLOCK_BOOTTIME },
+	{ "MONOTONIC", CLOCK_MONOTONIC },
+	{ NULL }
+};
+
 static int num_socks;
 struct xsk_socket_info *xsks[MAX_SOCKS];
 int sock;
 
+static int get_clockid(clockid_t *id, const char *name)
+{
+	const struct clockid_map *clk;
+
+	for (clk = clockids_map; clk->name; clk++) {
+		if (strcasecmp(clk->name, name) == 0) {
+			*id = clk->clockid;
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
 
-	clock_gettime(CLOCK_MONOTONIC, &ts);
+	clock_gettime(opt_clock, &ts);
 	return ts.tv_sec * 1000000000UL + ts.tv_nsec;
 }
 
@@ -965,6 +991,7 @@ static struct option long_options[] = {
 	{"shared-umem", no_argument, 0, 'M'},
 	{"force", no_argument, 0, 'F'},
 	{"duration", required_argument, 0, 'd'},
+	{"clock", required_argument, 0, 'w'},
 	{"batch-size", required_argument, 0, 'b'},
 	{"tx-pkt-count", required_argument, 0, 'C'},
 	{"tx-pkt-size", required_argument, 0, 's'},
@@ -1006,6 +1033,7 @@ static void usage(const char *prog)
 		"  -F, --force		Force loading the XDP prog\n"
 		"  -d, --duration=n	Duration in secs to run command.\n"
 		"			Default: forever.\n"
+		"  -w, --clock=CLOCK	Clock NAME (default MONOTONIC).\n"
 		"  -b, --batch-size=n	Batch size for sending or receiving\n"
 		"			packets. Default: %d\n"
 		"  -C, --tx-pkt-count=n	Number of packets to send.\n"
@@ -1041,7 +1069,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1075,6 +1103,14 @@ static void parse_command_line(int argc, char **argv)
 		case 'n':
 			opt_interval = atoi(optarg);
 			break;
+		case 'w':
+			if (get_clockid(&opt_clock, optarg)) {
+				fprintf(stderr,
+					"ERROR: Invalid clock %s. Default to CLOCK_MONOTONIC.\n",
+					optarg);
+				opt_clock = CLOCK_MONOTONIC;
+			}
+			break;
 		case 'z':
 			opt_xdp_bind_flags |= XDP_ZEROCOPY;
 			break;
-- 
2.25.1

