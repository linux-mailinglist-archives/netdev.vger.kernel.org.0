Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051C92842E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfEWQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:45:10 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:54503 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730928AbfEWQpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:45:10 -0400
Received: by mail-qt1-f201.google.com with SMTP id l20so5842261qtq.21
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m4ho6aAoB3w7ayaHGzATCfcKtIGB2JYW3tBB7vEWfNs=;
        b=Wt0fVIQhLVR6QWV6zhYq4Oa/8AQlfD7ALHJ1TGTD5fHwwvq+rmOXJfktizFAl5SgOC
         1cngX68Kj3MMYiauZ4l5jOn7S76ORHh0lb4XN2+LT9LPhEaLbhkWSqQVP841/OZhj1cA
         IWrrOPwzISm1oMJ4h+axPz07hyiJu74UW+J1WST5xmrGRTJAvRwsl9V1FAqoICk5sYx0
         cdix6860b28zEziHLs+9HnrrnszU5pp8drIDCJygLcABPVs+rzuZll12c0uxgW0j3CJ3
         tBkR+Yi+VEKpi9kFuUmvnkDyioMqdZGmZUnoPXYgO/v7o3Kwjifq3rYnz+7M9vX9h5nq
         OjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m4ho6aAoB3w7ayaHGzATCfcKtIGB2JYW3tBB7vEWfNs=;
        b=YZW82USlucE3bvytSgk703lg4MCuB5unDn1VNWbpeN+B8oN+Ob99h80RRz8ESLAhH0
         hgz34PGuugGVQNr/Hc0E7cxJsc3zy284sfyhJE6bHQq5wFmURL9WDAC8J6eXQYfmFLu+
         BIdhEP55jT+u8ad2fOxkjtlhnMCRhSh6V0Va26c7TUAxXMtVXgMBvKA6+W2pZbIp/wL9
         Oco3QPZh6wp9THKajdaMon27PvuhyEIm/khKkTP+1eGSjLY/FFfsVDfWD18Wri1ruiv/
         zilgKicV4pVMoXfP0HnTG5MgVgNEEojWD4gXJbxBiZXSWB05uzEFfX5pd7pMbCAJGIPw
         /zNA==
X-Gm-Message-State: APjAAAW4IOG0x0dZ2nPud9oXpWK6UpC7Set4ixvqGBW9ohNkces8CFWy
        gKSjjaJ4DcmTEzOGMwLTDxf/dPs+FtytJmcXA/E1WWqWBhqQ4/E8J3FShclbCTSmdBlYTgbrrgm
        IPKlen4vjuRyo3rsAlitUICBv47+fU0dYLNxnlH05deM9VOaibvRXOwOD5n5LQwSB
X-Google-Smtp-Source: APXvYqxfeqXyNchC/mZtlbSF5hJIRP4+5JRJ62fIp8x1Sh/ESh1GkJgb1u5UWGd7Es7eeLUwSxgUkKCrzuYT
X-Received: by 2002:a37:a387:: with SMTP id m129mr76806167qke.39.1558629908992;
 Thu, 23 May 2019 09:45:08 -0700 (PDT)
Date:   Thu, 23 May 2019 12:45:07 -0400
Message-Id: <20190523164507.50208-1-willemb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net-next] selftests/net: SO_TXTIME with ETF and FQ
From:   Willem de Bruijn <willemb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        jesus.sanchez-palencia@intel.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SO_TXTIME API enables packet tranmission with delayed delivery.
This is currently supported by the ETF and FQ packet schedulers.

Evaluate the interface with both schedulers. Install the scheduler
and send a variety of packets streams: without delay, with one
delayed packet, with multiple ordered delays and with reordering.
Verify that packets are released by the scheduler in expected order.

The ETF qdisc requires a timestamp in the future on every packet. It
needs a delay on the qdisc else the packet is dropped on dequeue for
having a delivery time in the past. The test value is experimentally
derived. ETF requires clock_id CLOCK_TAI. It checks this base and
drops for non-conformance.

The FQ qdisc expects clock_id CLOCK_MONOTONIC, the base used by TCP
as of commit fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC").
Within a flow there is an expecation of ordered delivery, as shown by
delivery times of test 4. The FQ qdisc does not require all packets to
have timestamps and does not drop for non-conformance.

The large (msec) delays are chosen to avoid flakiness.

	Output:

	SO_TXTIME ipv6 clock monolithic
	payload:a delay:33 expected:0 (us)

	SO_TXTIME ipv4 clock monolithic
	payload:a delay:44 expected:0 (us)

	SO_TXTIME ipv6 clock monolithic
	payload:a delay:10049 expected:10000 (us)

	SO_TXTIME ipv4 clock monolithic
	payload:a delay:10105 expected:10000 (us)

	[.. etc ..]

	OK. All tests passed

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/.gitignore   |   1 +
 tools/testing/selftests/net/Makefile     |   3 +-
 tools/testing/selftests/net/config       |   2 +
 tools/testing/selftests/net/so_txtime.c  | 297 +++++++++++++++++++++++
 tools/testing/selftests/net/so_txtime.sh |  31 +++
 5 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/so_txtime.c
 create mode 100755 tools/testing/selftests/net/so_txtime.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 6f81130605d7d..27ef4d07ac915 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -17,3 +17,4 @@ tcp_inq
 tls
 txring_overwrite
 ip_defrag
+so_txtime
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 1e6d14d2825cc..8af7869e0f1c8 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -9,12 +9,13 @@ TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
-TEST_PROGS += test_vxlan_fdb_changelink.sh
+TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
+TEST_GEN_FILES += so_txtime
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 4740404486018..89f84b5118bfa 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -25,3 +25,5 @@ CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_CHAIN_NAT_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
+CONFIG_NET_SCH_FQ=m
+CONFIG_NET_SCH_ETF=m
diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
new file mode 100644
index 0000000000000..d5e9f6807be43
--- /dev/null
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the SO_TXTIME API
+ *
+ * Takes two streams of { payload, delivery time }[], one input and one output.
+ * Sends the input stream and verifies arrival matches the output stream.
+ * The two streams can differ due to out-of-order delivery and drops.
+ */
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <error.h>
+#include <errno.h>
+#include <linux/net_tstamp.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+static int	cfg_clockid	= CLOCK_TAI;
+static bool	cfg_do_ipv4;
+static bool	cfg_do_ipv6;
+static uint16_t	cfg_port	= 8000;
+static int	cfg_variance_us	= 2000;
+
+static uint64_t glob_tstart;
+
+/* encode one timed transmission (of a 1B payload) */
+struct timed_send {
+	char	data;
+	int64_t	delay_us;
+};
+
+#define MAX_NUM_PKT	8
+static struct timed_send cfg_in[MAX_NUM_PKT];
+static struct timed_send cfg_out[MAX_NUM_PKT];
+static int cfg_num_pkt;
+
+static uint64_t gettime_ns(void)
+{
+	struct timespec ts;
+
+	if (clock_gettime(cfg_clockid, &ts))
+		error(1, errno, "gettime");
+
+	return ts.tv_sec * (1000ULL * 1000 * 1000) + ts.tv_nsec;
+}
+
+static void do_send_one(int fdt, struct timed_send *ts)
+{
+	char control[CMSG_SPACE(sizeof(uint64_t))];
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	struct cmsghdr *cm;
+	uint64_t tdeliver;
+	int ret;
+
+	iov.iov_base = &ts->data;
+	iov.iov_len = 1;
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	if (ts->delay_us >= 0) {
+		memset(control, 0, sizeof(control));
+		msg.msg_control = &control;
+		msg.msg_controllen = sizeof(control);
+
+		tdeliver = glob_tstart + ts->delay_us * 1000;
+
+		cm = CMSG_FIRSTHDR(&msg);
+		cm->cmsg_level = SOL_SOCKET;
+		cm->cmsg_type = SCM_TXTIME;
+		cm->cmsg_len = CMSG_LEN(sizeof(tdeliver));
+		memcpy(CMSG_DATA(cm), &tdeliver, sizeof(tdeliver));
+	}
+
+	ret = sendmsg(fdt, &msg, 0);
+	if (ret == -1)
+		error(1, errno, "write");
+	if (ret == 0)
+		error(1, 0, "write: 0B");
+
+}
+
+static void do_recv_one(int fdr, struct timed_send *ts)
+{
+	int64_t tstop, texpect;
+	char rbuf[2];
+	int ret;
+
+	ret = recv(fdr, rbuf, sizeof(rbuf), 0);
+	if (ret == -1)
+		error(1, errno, "read");
+	if (ret != 1)
+		error(1, 0, "read: %dB", ret);
+
+	tstop = (gettime_ns() - glob_tstart) / 1000;
+	texpect = ts->delay_us >= 0 ? ts->delay_us : 0;
+
+	fprintf(stderr, "payload:%c delay:%ld expected:%ld (us)\n",
+			rbuf[0], tstop, texpect);
+
+	if (rbuf[0] != ts->data)
+		error(1, 0, "payload mismatch. expected %c", ts->data);
+
+	if (labs(tstop - texpect) > cfg_variance_us)
+		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
+}
+
+static void do_recv_verify_empty(int fdr)
+{
+	char rbuf[1];
+	int ret;
+
+	ret = recv(fdr, rbuf, sizeof(rbuf), 0);
+	if (ret != -1 || errno != EAGAIN)
+		error(1, 0, "recv: not empty as expected (%d, %d)", ret, errno);
+}
+
+static void setsockopt_txtime(int fd)
+{
+	struct sock_txtime so_txtime_val = { .clockid = cfg_clockid };
+	struct sock_txtime so_txtime_val_read = { 0 };
+	socklen_t vallen = sizeof(so_txtime_val);
+
+	if (setsockopt(fd, SOL_SOCKET, SO_TXTIME,
+		       &so_txtime_val, sizeof(so_txtime_val)))
+		error(1, errno, "setsockopt txtime");
+
+	if (getsockopt(fd, SOL_SOCKET, SO_TXTIME,
+		       &so_txtime_val_read, &vallen))
+		error(1, errno, "getsockopt txtime");
+
+	if (vallen != sizeof(so_txtime_val) ||
+	    memcmp(&so_txtime_val, &so_txtime_val_read, vallen))
+		error(1, 0, "getsockopt txtime: mismatch");
+}
+
+static int setup_tx(struct sockaddr *addr, socklen_t alen)
+{
+	int fd;
+
+	fd = socket(addr->sa_family, SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket t");
+
+	if (connect(fd, addr, alen))
+		error(1, errno, "connect");
+
+	setsockopt_txtime(fd);
+
+	return fd;
+}
+
+static int setup_rx(struct sockaddr *addr, socklen_t alen)
+{
+	struct timeval tv = { .tv_usec = 100 * 1000 };
+	int fd;
+
+	fd = socket(addr->sa_family, SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket r");
+
+	if (bind(fd, addr, alen))
+		error(1, errno, "bind");
+
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)))
+		error(1, errno, "setsockopt rcv timeout");
+
+	return fd;
+}
+
+static void do_test(struct sockaddr *addr, socklen_t alen)
+{
+	int fdt, fdr, i;
+
+	fprintf(stderr, "\nSO_TXTIME ipv%c clock %s\n",
+			addr->sa_family == PF_INET ? '4' : '6',
+			cfg_clockid == CLOCK_TAI ? "tai" : "monotonic");
+
+	fdt = setup_tx(addr, alen);
+	fdr = setup_rx(addr, alen);
+
+	glob_tstart = gettime_ns();
+
+	for (i = 0; i < cfg_num_pkt; i++)
+		do_send_one(fdt, &cfg_in[i]);
+	for (i = 0; i < cfg_num_pkt; i++)
+		do_recv_one(fdr, &cfg_out[i]);
+
+	do_recv_verify_empty(fdr);
+
+	if (close(fdr))
+		error(1, errno, "close r");
+	if (close(fdt))
+		error(1, errno, "close t");
+}
+
+static int parse_io(const char *optarg, struct timed_send *array)
+{
+	char *arg, *tok;
+	int aoff = 0;
+
+	arg = strdup(optarg);
+	if (!arg)
+		error(1, errno, "strdup");
+
+	while ((tok = strtok(arg, ","))) {
+		arg = NULL;	/* only pass non-zero on first call */
+
+		if (aoff / 2 == MAX_NUM_PKT)
+			error(1, 0, "exceeds max pkt count (%d)", MAX_NUM_PKT);
+
+		if (aoff & 1) {	/* parse delay */
+			array->delay_us = strtol(tok, NULL, 0) * 1000;
+			array++;
+		} else {	/* parse character */
+			array->data = tok[0];
+		}
+
+		aoff++;
+	}
+
+	free(arg);
+
+	return aoff / 2;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c, ilen, olen;
+
+	while ((c = getopt(argc, argv, "46c:")) != -1) {
+		switch (c) {
+		case '4':
+			cfg_do_ipv4 = true;
+			break;
+		case '6':
+			cfg_do_ipv6 = true;
+			break;
+		case 'c':
+			if (!strcmp(optarg, "tai"))
+				cfg_clockid = CLOCK_TAI;
+			else if (!strcmp(optarg, "monotonic") ||
+				 !strcmp(optarg, "mono"))
+				cfg_clockid = CLOCK_MONOTONIC;
+			else
+				error(1, 0, "unknown clock id %s", optarg);
+			break;
+		default:
+			error(1, 0, "parse error at %d", optind);
+		}
+	}
+
+	if (argc - optind != 2)
+		error(1, 0, "Usage: %s [-46] -c <clock> <in> <out>", argv[0]);
+
+	ilen = parse_io(argv[optind], cfg_in);
+	olen = parse_io(argv[optind + 1], cfg_out);
+	if (ilen != olen)
+		error(1, 0, "i/o streams len mismatch (%d, %d)\n", ilen, olen);
+	cfg_num_pkt = ilen;
+}
+
+int main(int argc, char **argv)
+{
+	parse_opts(argc, argv);
+
+	if (cfg_do_ipv6) {
+		struct sockaddr_in6 addr6 = {0};
+
+		addr6.sin6_family = AF_INET6;
+		addr6.sin6_port = htons(cfg_port);
+		addr6.sin6_addr = in6addr_loopback;
+		do_test((void *)&addr6, sizeof(addr6));
+	}
+
+	if (cfg_do_ipv4) {
+		struct sockaddr_in addr4 = {0};
+
+		addr4.sin_family = AF_INET;
+		addr4.sin_port = htons(cfg_port);
+		addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		do_test((void *)&addr4, sizeof(addr4));
+	}
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/net/so_txtime.sh b/tools/testing/selftests/net/so_txtime.sh
new file mode 100755
index 0000000000000..5aa519328a5b5
--- /dev/null
+++ b/tools/testing/selftests/net/so_txtime.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression tests for the SO_TXTIME interface
+
+# Run in network namespace
+if [[ $# -eq 0 ]]; then
+	./in_netns.sh $0 __subprocess
+	exit $?
+fi
+
+set -e
+
+tc qdisc add dev lo root fq
+./so_txtime -4 -6 -c mono a,-1 a,-1
+./so_txtime -4 -6 -c mono a,0 a,0
+./so_txtime -4 -6 -c mono a,10 a,10
+./so_txtime -4 -6 -c mono a,10,b,20 a,10,b,20
+./so_txtime -4 -6 -c mono a,20,b,10 b,20,a,20
+
+if tc qdisc replace dev lo root etf clockid CLOCK_TAI delta 200000; then
+	! ./so_txtime -4 -6 -c tai a,-1 a,-1
+	! ./so_txtime -4 -6 -c tai a,0 a,0
+	./so_txtime -4 -6 -c tai a,10 a,10
+	./so_txtime -4 -6 -c tai a,10,b,20 a,10,b,20
+	./so_txtime -4 -6 -c tai a,20,b,10 b,10,a,20
+else
+	echo "tc ($(tc -V)) does not support qdisc etf. skipping"
+fi
+
+echo OK. All tests passed
-- 
2.21.0.1020.gf2820cf01a-goog

