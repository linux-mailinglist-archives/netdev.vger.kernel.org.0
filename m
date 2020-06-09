Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B043F1F3DA3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgFIOJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgFIOJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:49 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6A0C08C5C4
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:46 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i16so17641491qtr.7
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xexHMXVgzOIx9WOc6t4fmgvCC/iI4Sqfb6vI5QhhmYY=;
        b=j4qxx01mvqOJf6wpGsFioN4UH2p99MHQpMoBxfgYg5IdfibKRbyq1n2hZjUTPoQO4M
         ufZdA4C8RBbKGbOzBB1WhtQiknC8XS5f3ZgqgMOcLdTA6EHGmUqXEAajq71v17TXHABm
         deorRmlEey/LO8H8wnCe4HFiaZ+t/Nt6nu5aCCJslTH1+SWtuk7K41sgCerPYZWJtA/4
         zCXmQW4w4GBJnNnl8pE09DCx40waeZfOsfk4v2ob5ZznTYsyKzYWY2GQfVD6xMPOT1lS
         ciL6C0I+7USo1Q+rngfGlnzKQIP2ARkiCzKoY1qKCSF1EVpUC5B/yzHNgIKO5bqhoYUp
         quqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xexHMXVgzOIx9WOc6t4fmgvCC/iI4Sqfb6vI5QhhmYY=;
        b=TLBCjudx0rXtjFkfj2S1xJd/3kpoq2YqUZgci6AM7CMCYTQ6Gr7Hp2ZqvrWObW3YhT
         Pa0WbLR9bUVAIF6xbluk2A4YMtga5yWNcu7UyrzDAyj5Qzv/zvCNwU5RMsBaehwFcM89
         QDBEmu6VUM8Gxut8rBml1kQagh2sE2UYsHVVqfhePvLoBWMWNl+sfT0IGRLTHQWnF90C
         16rrSmFc+2ue/co1lYpicCCgCPJjc84uFCaR0/E0n17+SyuzKgqtjL8KbmEpJpu8OeKK
         vvFIhw8Yjx2NgFsb3gcEPQiIUhk0snwcMTQFUDurb4+Rm7BSKQIozWmJYgXdmKe/EdZd
         S+3g==
X-Gm-Message-State: AOAM531/sAQajMdzkDOOOhDHk3lW3516Hu85b0im93SAMwvL6vbyYBLH
        9Xo7eMGpVE7q4ZDd/LeRaQoJTaIt
X-Google-Smtp-Source: ABdhPJwhdSOvJzzGNssa5VmvGF/R/sM/rLyzOZ2lp21VGTCrsTcXI5JqhSibxA1nMbMk4WtKK/3Hrg==
X-Received: by 2002:ac8:2bc4:: with SMTP id n4mr28783535qtn.222.1591711784877;
        Tue, 09 Jun 2020 07:09:44 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:44 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 6/6] selftests/net: upgso bench: add pacing with SO_TXTIME
Date:   Tue,  9 Jun 2020 10:09:34 -0400
Message-Id: <20200609140934.110785-7-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Enable passing an SCM_TXTIME ('-x'), optionally configured to use
multi release (SOF_TXTIME_MULTI_RELEASE) ('-X').

With multi release, the segments that make up a single udp gso packet
can be released over time, as opposed to burst at once.

Repurpose the lower 8 bits of the 64 bit timestamp for this purpose.
- bits 4..7: delay between transmit periods in msec
- bits 0..3: number of segments sent per period

Also add an optional delay in usec between sendmsg calls ('-d'). To
reduce throughput sufficiently to observe pacing delay introduced.

Added udpgso_bench_multi.sh, derived from so_txtime_multi.sh, to run
tests over veth.

Also fix up a minor issue where sizeof the wrong field was used
(mss, instead of gso_size). They happen to both be uint16_t.

Tested:
    ./udpgso_bench_multi.sh

    or manually ran across two hosts:

    # sender
    #
    # -S 6000 -s 1400:  6000B buffer encoding 1400B datagrams
    # -d 200000:        200 msec delay between sendmsg
    # -x 0x989611:      ~1000000 nsec first delay + 1 MSS every 1 msec

    ./udpgso_bench_tx -6 -D fd00::1 \
        -l 1 -s 6000 -S 1400 -v
        -d 200000 -x 0x989611 -X

    # receiver

    tcpdump -n -i eth1 -c 100 udp and port 8000 &
    sleep 0.2
    ./udpgso_bench_rx

    16:29:45.146855 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.147798 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.148797 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.149797 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.150796 IP6 host1.40803 > host2.8000: UDP, length 400
    16:29:45.347056 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.348000 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.349000 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.349999 IP6 host1.40803 > host2.8000: UDP, length 1400
    16:29:45.350999 IP6 host1.40803 > host2.8000: UDP, length 400

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 .../selftests/net/udpgso_bench_multi.sh       | 65 +++++++++++++++++
 tools/testing/selftests/net/udpgso_bench_tx.c | 72 +++++++++++++++++--
 2 files changed, 133 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/net/udpgso_bench_multi.sh

diff --git a/tools/testing/selftests/net/udpgso_bench_multi.sh b/tools/testing/selftests/net/udpgso_bench_multi.sh
new file mode 100755
index 000000000000..c29f75aec759
--- /dev/null
+++ b/tools/testing/selftests/net/udpgso_bench_multi.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression tests for the SO_TXTIME interface
+
+readonly ns_prefix="ns-sotxtime-"
+readonly ns1="${ns_prefix}1"
+readonly ns2="${ns_prefix}2"
+
+readonly ns1_v4=192.168.1.1
+readonly ns2_v4=192.168.1.2
+readonly ns1_v6=fd::1
+readonly ns2_v6=fd::2
+
+set -eu
+
+cleanup() {
+	ip netns del "${ns2}"
+	ip netns del "${ns1}"
+}
+
+setup() {
+	ip netns add "${ns1}"
+	ip netns add "${ns2}"
+
+	ip link add dev veth1 mtu 1500 netns "${ns1}" type veth \
+	      peer name veth2 mtu 1500 netns "${ns2}"
+
+	ip -netns "${ns1}" link set veth1 up
+	ip -netns "${ns2}" link set veth2 up
+
+	ip -netns "${ns1}" -4 addr add "${ns1_v4}/24" dev veth1
+	ip -netns "${ns2}" -4 addr add "${ns2_v4}/24" dev veth2
+	ip -netns "${ns1}" -6 addr add "${ns1_v6}/64" dev veth1 nodad
+	ip -netns "${ns2}" -6 addr add "${ns2_v6}/64" dev veth2 nodad
+
+	ip netns exec "${ns1}" tc qdisc add dev veth1 root fq
+}
+
+run_test() {
+	ip netns exec "${ns2}" tcpdump -q -n -i veth2 udp &
+	ip netns exec "${ns2}" ./udpgso_bench_rx &
+	sleep 0.1
+	ip netns exec "${ns1}" ./udpgso_bench_tx $@
+	pkill -P $$
+}
+
+run_test_46() {
+	run_test -4 -D "${ns2_v4}" $@
+	run_test -6 -D "${ns2_v6}" $@
+}
+
+trap cleanup EXIT
+setup
+
+echo "gso + pacing"
+TEST_ARGS="-l 1 -s 3500 -S 1000 -v -d 200000 -x 1000000"
+run_test_46 ${TEST_ARGS} -x 1000000
+
+echo "gso + multi release pacing"
+run_test_46 ${TEST_ARGS} -X -x 0x989611
+run_test_46 ${TEST_ARGS} -X -x 0x9896A2
+
+# Does not validate pacing delay yet. Check manually.
+echo "Ok. Executed tests."
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 17512a43885e..264222c2b94e 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -23,6 +23,7 @@
 #include <sys/time.h>
 #include <sys/poll.h>
 #include <sys/types.h>
+#include <time.h>
 #include <unistd.h>
 
 #include "../kselftest.h"
@@ -56,6 +57,7 @@
 static bool	cfg_cache_trash;
 static int	cfg_cpu		= -1;
 static int	cfg_connected	= true;
+static int	cfg_delay_us;
 static int	cfg_family	= PF_UNSPEC;
 static uint16_t	cfg_mss;
 static int	cfg_payload_len	= (1472 * 42);
@@ -65,6 +67,8 @@ static bool	cfg_poll;
 static bool	cfg_segment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
+static uint64_t	cfg_txtime;
+static bool	cfg_txtime_multi;
 static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
 static bool	cfg_tx_tstamp;
 static bool	cfg_audit;
@@ -306,6 +310,34 @@ static void send_ts_cmsg(struct cmsghdr *cm)
 	*valp = cfg_tx_ts;
 }
 
+static uint64_t gettime_ns(void)
+{
+	struct timespec ts;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &ts))
+		error(1, errno, "gettime");
+
+	return ts.tv_sec * (1000ULL * 1000 * 1000) + ts.tv_nsec;
+}
+
+static void send_txtime_cmsg(struct cmsghdr *cm)
+{
+	uint64_t tdeliver, *valp;
+
+	tdeliver = gettime_ns() + cfg_txtime;
+
+	if (cfg_txtime_multi) {
+		tdeliver &= ~0xFF;
+		tdeliver |= cfg_txtime & 0xFF;
+	}
+
+	cm->cmsg_level = SOL_SOCKET;
+	cm->cmsg_type = SCM_TXTIME;
+	cm->cmsg_len = CMSG_LEN(sizeof(cfg_txtime));
+	valp = (void *)CMSG_DATA(cm);
+	*valp = tdeliver;
+}
+
 static int send_udp_sendmmsg(int fd, char *data)
 {
 	char control[CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
@@ -373,7 +405,8 @@ static void send_udp_segment_cmsg(struct cmsghdr *cm)
 static int send_udp_segment(int fd, char *data)
 {
 	char control[CMSG_SPACE(sizeof(cfg_gso_size)) +
-		     CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
+		     CMSG_SPACE(sizeof(cfg_tx_ts)) +
+		     CMSG_SPACE(sizeof(uint64_t))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	size_t msg_controllen;
@@ -390,12 +423,17 @@ static int send_udp_segment(int fd, char *data)
 	msg.msg_controllen = sizeof(control);
 	cmsg = CMSG_FIRSTHDR(&msg);
 	send_udp_segment_cmsg(cmsg);
-	msg_controllen = CMSG_SPACE(sizeof(cfg_mss));
+	msg_controllen = CMSG_SPACE(sizeof(cfg_gso_size));
 	if (cfg_tx_tstamp) {
 		cmsg = CMSG_NXTHDR(&msg, cmsg);
 		send_ts_cmsg(cmsg);
 		msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
 	}
+	if (cfg_txtime) {
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+		send_txtime_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_txtime));
+	}
 
 	msg.msg_controllen = msg_controllen;
 	msg.msg_name = (void *)&cfg_dst_addr;
@@ -413,7 +451,7 @@ static int send_udp_segment(int fd, char *data)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
+	error(1, 0, "Usage: %s [-46acmHPtTuvXz] [-C cpu] [-d delay] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize] [-x time]",
 		    filepath);
 }
 
@@ -422,7 +460,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:PS:tTuvz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:d:D:Hl:mM:p:s:PS:tTuvx:Xz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -445,6 +483,9 @@ static void parse_opts(int argc, char **argv)
 		case 'C':
 			cfg_cpu = strtol(optarg, NULL, 0);
 			break;
+		case 'd':
+			cfg_delay_us = strtol(optarg, NULL, 0);
+			break;
 		case 'D':
 			setup_sockaddr(cfg_family, optarg, &cfg_dst_addr);
 			break;
@@ -486,6 +527,12 @@ static void parse_opts(int argc, char **argv)
 		case 'v':
 			cfg_verbose = true;
 			break;
+		case 'x':
+			cfg_txtime = strtoull(optarg, NULL, 0);
+			break;
+		case 'X':
+			cfg_txtime_multi = true;
+			break;
 		case 'z':
 			cfg_zerocopy = true;
 			break;
@@ -551,6 +598,17 @@ static void set_tx_timestamping(int fd)
 		error(1, errno, "setsockopt tx timestamping");
 }
 
+static void set_txtime(int fd)
+{
+	struct sock_txtime txt = { .clockid = CLOCK_MONOTONIC };
+
+	if (cfg_txtime_multi)
+		txt.flags = SOF_TXTIME_MULTI_RELEASE;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_TXTIME, &txt, sizeof(txt)))
+		error(1, errno, "setsockopt txtime");
+}
+
 static void print_audit_report(unsigned long num_msgs, unsigned long num_sends)
 {
 	unsigned long tdelta;
@@ -652,6 +710,9 @@ int main(int argc, char **argv)
 	if (cfg_tx_tstamp)
 		set_tx_timestamping(fd);
 
+	if (cfg_txtime)
+		set_txtime(fd);
+
 	num_msgs = num_sends = 0;
 	tnow = gettimeofday_ms();
 	tstart = tnow;
@@ -687,6 +748,9 @@ int main(int argc, char **argv)
 		if (cfg_cache_trash)
 			i = ++i < NUM_PKT ? i : 0;
 
+		if (cfg_delay_us)
+			usleep(cfg_delay_us);
+
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
 	if (cfg_zerocopy || cfg_tx_tstamp)
-- 
2.27.0.278.ge193c7cf3a9-goog

