Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EBA1F3DA5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgFIOKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgFIOJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:46 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E882C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:45 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fc4so10137236qvb.1
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uB2kcDcObXzwEG33hEUMjL0mxj4fwUyzdrYG3GdeEwc=;
        b=W7cdEpr39EEPephPUMvFL2qj/FtrNiisJuc+Bi31+3C7vta4dggvMffHR04g6QGpvz
         8bs9OYCuYdJVZbi603COf4ByDA0imPb47PkSRUJxQ7vM74GKRMxzhSMI31d2Q0LxO9VO
         jnxpSESigXnpRlNSfmvgheZkAkToouzhBak1QtcSmHBVzS88Lq79Bb6LnoYtYlcIb6um
         Hr3lfnTRCk78ywk5tzA0yPhPBziJFjMVfsePhBQZxwA6ck0iMsYwDvgaH7h8ZHTm6hbs
         xjt/LYnWhe2uiM7QmIojggqR+T0PxW2dkU/nLiDvGrlCXF1Ox41Q/krmRTn0euJ/zKye
         kTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uB2kcDcObXzwEG33hEUMjL0mxj4fwUyzdrYG3GdeEwc=;
        b=L+UmfTXFHhsaneIva+b0tQiULliYAo/d8ScXCOAjVAWHJqj9PU92oncn2R8qQRo9Xj
         VmZRVUwcf2XU36Hbt+regL03D/4ot13Gv7AMiSZpj6fOkFJuu3qoJQ0yEphTpDrJBdtS
         7Z9GnEGVnOY5zcWqbwHSVbR4OmvVI4inikuA4p/gUL2INWaPhAOW54XcYdodvc3eVZj6
         487AwphV2l77HZX6u6R/tGpdNUUsfuWcjWJucQJlm4gSQC72XysOVcczcRJmVRTloZSX
         rd3PqpgtupjIBGF3ub6V7wcb+7iGJOn8aSbxaRom+hROFT4c/G+wMI8pKoNeV60ruTFc
         1hVA==
X-Gm-Message-State: AOAM531iIuboTekiwb9m/POL1SHp8+A2YRJfBS4BVHpxpimIHmJpBI9R
        dsY0PA7cEtCtHHHlnqWgwMIeJmod
X-Google-Smtp-Source: ABdhPJzszAfKOKc0Lb5qVQm/jkPzVdbSG683zBeHLLF+++NxiQdCCLewzTeJBZcWSsTNLXNIWe2yNg==
X-Received: by 2002:a0c:f888:: with SMTP id u8mr4100102qvn.130.1591711784017;
        Tue, 09 Jun 2020 07:09:44 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:42 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 5/6] selftests/net: so_txtime: add gso and multi release pacing
Date:   Tue,  9 Jun 2020 10:09:33 -0400
Message-Id: <20200609140934.110785-6-willemdebruijn.kernel@gmail.com>
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

Support sending more than 1B payload and passing segment size.

- add option '-s' to send more than 1B payload
- add option '-m' to configure mss

If size exceeds mss, enable UDP_SEGMENT.

Optionally also allow configuring multi release time.

- add option '-M' to set release interval (msec)
- add option '-N' to set release segment count

Both options have to be specified, or neither.

Add a testcase to so_txtime.sh over loopback.
Add a testscript so_txtime_multi.sh that operates over veth using
txonly/rxonly mode.

Also fix a small sock_extended_err parsing bug, mixing up
ee_code and ee_errno

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c       | 80 +++++++++++++++----
 tools/testing/selftests/net/so_txtime.sh      |  7 ++
 .../testing/selftests/net/so_txtime_multi.sh  | 68 ++++++++++++++++
 3 files changed, 141 insertions(+), 14 deletions(-)
 create mode 100755 tools/testing/selftests/net/so_txtime_multi.sh

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index fa748e4209c0..da4ef411693c 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -17,6 +17,7 @@
 #include <linux/errqueue.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
+#include <netinet/udp.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -32,7 +33,11 @@ static const char *cfg_addr;
 static int	cfg_clockid	= CLOCK_TAI;
 static bool	cfg_do_ipv4;
 static bool	cfg_do_ipv6;
+static uint8_t	cfg_mr_num;
+static uint8_t	cfg_mr_ival;
+static int	cfg_mss		= 1400;
 static bool	cfg_rxonly;
+static uint16_t	cfg_size	= 1;
 static int	cfg_timeout_sec;
 static bool	cfg_txonly;
 static uint16_t	cfg_port	= 8000;
@@ -66,6 +71,7 @@ static uint64_t gettime_ns(void)
 
 static void do_send_one(int fdt, struct timed_send *ts)
 {
+	static char buf[1 << 16];
 	char control[CMSG_SPACE(sizeof(uint64_t))];
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
@@ -73,8 +79,10 @@ static void do_send_one(int fdt, struct timed_send *ts)
 	uint64_t tdeliver;
 	int ret;
 
-	iov.iov_base = &ts->data;
-	iov.iov_len = 1;
+	memset(buf, ts->data, cfg_size);
+
+	iov.iov_base = buf;
+	iov.iov_len = cfg_size;
 
 	msg.msg_iov = &iov;
 	msg.msg_iovlen = 1;
@@ -85,6 +93,11 @@ static void do_send_one(int fdt, struct timed_send *ts)
 		msg.msg_controllen = sizeof(control);
 
 		tdeliver = glob_tstart + ts->delay_us * 1000;
+		if (cfg_mr_ival) {
+			tdeliver &= ~0xFF;
+			tdeliver |= cfg_mr_ival << 4;
+			tdeliver |= cfg_mr_num;
+		}
 
 		cm = CMSG_FIRSTHDR(&msg);
 		cm->cmsg_level = SOL_SOCKET;
@@ -104,30 +117,41 @@ static void do_send_one(int fdt, struct timed_send *ts)
 static bool do_recv_one(int fdr, struct timed_send *ts)
 {
 	int64_t tstop, texpect;
+	int total = 0;
 	char rbuf[2];
 	int ret;
 
-	ret = recv(fdr, rbuf, sizeof(rbuf), 0);
+read_again:
+	ret = recv(fdr, rbuf, sizeof(rbuf), MSG_TRUNC);
 	if (ret == -1 && errno == EAGAIN)
-		return true;
+		goto timedout;
 	if (ret == -1)
 		error(1, errno, "read");
-	if (ret != 1)
-		error(1, 0, "read: %dB", ret);
 
 	tstop = (gettime_ns() - glob_tstart) / 1000;
 	texpect = ts->delay_us >= 0 ? ts->delay_us : 0;
 
-	fprintf(stderr, "payload:%c delay:%lld expected:%lld (us)\n",
-			rbuf[0], (long long)tstop, (long long)texpect);
+	fprintf(stderr, "payload:%c delay:%lld expected:%lld (us) -- read=%d,len=%d,total=%d\n",
+			rbuf[0], (long long)tstop, (long long)texpect,
+			total, ret, cfg_size);
 
 	if (rbuf[0] != ts->data)
 		error(1, 0, "payload mismatch. expected %c", ts->data);
 
-	if (labs(tstop - texpect) > cfg_variance_us)
+	total += ret;
+	if (total < cfg_size)
+		goto read_again;
+
+	/* measure latency if all data arrives in a single datagram (not GSO) */
+	if (ret == cfg_size && labs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
 
 	return false;
+
+timedout:
+	if (total != 0 && total != cfg_size)
+		error(1, 0, "timeout mid-read");
+	return true;
 }
 
 static void do_recv_verify_empty(int fdr)
@@ -168,7 +192,9 @@ static void do_recv_errqueue_timeout(int fdt)
 			break;
 		if (ret == -1)
 			error(1, errno, "errqueue");
-		if (msg.msg_flags != MSG_ERRQUEUE)
+		if (ret != sizeof(data))
+			error(1, errno, "insufficient data");
+		if (msg.msg_flags & ~(MSG_ERRQUEUE | MSG_TRUNC))
 			error(1, 0, "errqueue: flags 0x%x\n", msg.msg_flags);
 
 		cm = CMSG_FIRSTHDR(&msg);
@@ -180,7 +206,9 @@ static void do_recv_errqueue_timeout(int fdt)
 		err = (struct sock_extended_err *)CMSG_DATA(cm);
 		if (err->ee_origin != SO_EE_ORIGIN_TXTIME)
 			error(1, 0, "errqueue: origin 0x%x\n", err->ee_origin);
-		if (err->ee_code != ECANCELED)
+		if (err->ee_errno != ECANCELED)
+			error(1, 0, "errqueue: errno 0x%x\n", err->ee_errno);
+		if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
 			error(1, 0, "errqueue: code 0x%x\n", err->ee_code);
 
 		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
@@ -202,7 +230,7 @@ static void setsockopt_txtime(int fd)
 	struct sock_txtime so_txtime_val_read = { 0 };
 	socklen_t vallen = sizeof(so_txtime_val);
 
-	so_txtime_val.flags = SOF_TXTIME_REPORT_ERRORS;
+	so_txtime_val.flags = SOF_TXTIME_REPORT_ERRORS | SOF_TXTIME_MULTI_RELEASE;
 
 	if (setsockopt(fd, SOL_SOCKET, SO_TXTIME,
 		       &so_txtime_val, sizeof(so_txtime_val)))
@@ -230,6 +258,12 @@ static int setup_tx(struct sockaddr *addr, socklen_t alen)
 
 	setsockopt_txtime(fd);
 
+	if (cfg_size > cfg_mss) {
+		if (setsockopt(fd, SOL_UDP, UDP_SEGMENT,
+			       &cfg_mss, sizeof(cfg_mss)))
+			error(1, errno, "setsockopt udp segment");
+	}
+
 	return fd;
 }
 
@@ -321,7 +355,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c, ilen, olen;
 
-	while ((c = getopt(argc, argv, "46A:c:rtT:")) != -1) {
+	while ((c = getopt(argc, argv, "46A:c:m:M:N:rs:tT:")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_do_ipv4 = true;
@@ -341,9 +375,25 @@ static void parse_opts(int argc, char **argv)
 			else
 				error(1, 0, "unknown clock id %s", optarg);
 			break;
+		case 'm':
+			cfg_mss = strtol(optarg, NULL, 0);
+			break;
+		case 'M':
+			cfg_mr_ival = atoi(optarg);
+			if (cfg_mr_ival > 0xF)
+				error(1, 0, "multi release ival exceeds max");
+			break;
+		case 'N':
+			cfg_mr_num = atoi(optarg);
+			if (cfg_mr_num > 0xF)
+				error(1, 0, "multi release count exceeds max");
+			break;
 		case 'r':
 			cfg_rxonly = true;
 			break;
+		case 's':
+			cfg_size = atoi(optarg);
+			break;
 		case 't':
 			cfg_txonly = true;
 			break;
@@ -356,12 +406,14 @@ static void parse_opts(int argc, char **argv)
 	}
 
 	if (argc - optind != 2)
-		error(1, 0, "Usage: %s [-46rt] [-A addr] [-c clock] [-T timeout] <in> <out>", argv[0]);
+		error(1, 0, "Usage: %s [-46rt] [-A addr] [-c clock] [-m mtu] [-M ival] [-N num] [-s size] [-T timeout] <in> <out>", argv[0]);
 
 	if (cfg_rxonly && cfg_txonly)
 		error(1, 0, "Select rx-only or tx-only, not both");
 	if (cfg_addr && cfg_do_ipv4 && cfg_do_ipv6)
 		error(1, 0, "Cannot run both IPv4 and IPv6 when passing address");
+	if (!!cfg_mr_ival ^ !!cfg_mr_num)
+		error(1, 0, "Multi release pacing requires both -M and -N");
 
 	ilen = parse_io(argv[optind], cfg_in);
 	olen = parse_io(argv[optind + 1], cfg_out);
diff --git a/tools/testing/selftests/net/so_txtime.sh b/tools/testing/selftests/net/so_txtime.sh
index 3f7800eaecb1..7c60c11717e4 100755
--- a/tools/testing/selftests/net/so_txtime.sh
+++ b/tools/testing/selftests/net/so_txtime.sh
@@ -16,13 +16,20 @@ fi
 
 set -e
 
+ip link set dev lo mtu 1500
 tc qdisc add dev lo root fq
+
 ./so_txtime -4 -6 -c mono a,-1 a,-1
 ./so_txtime -4 -6 -c mono a,0 a,0
 ./so_txtime -4 -6 -c mono a,10 a,10
 ./so_txtime -4 -6 -c mono a,10,b,20 a,10,b,20
 ./so_txtime -4 -6 -c mono a,20,b,10 b,20,a,20
 
+# test gso
+./so_txtime -4 -6 -m 1000 -s 3500 -c mono a,50,b,100 a,50,b,100
+./so_txtime -4 -6 -m 1000 -s 3500 -M 5 -N 1 -c mono a,50,b,100 a,50,b,100
+./so_txtime -4 -6 -m 1000 -s 3500 -M 5 -N 2 -c mono a,50,b,100 a,50,b,100
+
 if tc qdisc replace dev lo root etf clockid CLOCK_TAI delta 400000; then
 	! ./so_txtime -4 -6 -c tai a,-1 a,-1
 	! ./so_txtime -4 -6 -c tai a,0 a,0
diff --git a/tools/testing/selftests/net/so_txtime_multi.sh b/tools/testing/selftests/net/so_txtime_multi.sh
new file mode 100755
index 000000000000..4e5ab06fd178
--- /dev/null
+++ b/tools/testing/selftests/net/so_txtime_multi.sh
@@ -0,0 +1,68 @@
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
+	ip netns exec "${ns2}" ./so_txtime -r -T 1 $@ &
+	sleep 0.1
+	ip netns exec "${ns1}" ./so_txtime -t $@
+	wait
+}
+
+run_test_46() {
+	run_test -4 -A "${ns2_v4}" $@
+	run_test -6 -A "${ns2_v6}" $@
+}
+
+trap cleanup EXIT
+setup
+
+echo "pacing"
+TEST_ARGS="-c mono a,10 a,10"
+run_test_46 ${TEST_ARGS}
+
+echo "gso + pacing"
+TEST_ARGS_GSO="-m 1000 -s 4500 ${TEST_ARGS}"
+run_test_46 ${TEST_ARGS_GSO}
+
+echo "gso + multi release pacing"
+run_test_46 -M 5 -N 1 ${TEST_ARGS_GSO}
+run_test_46 -M 5 -N 2 ${TEST_ARGS_GSO}
+
+# Does not validate pacing delay yet. Check manually.
+echo "Ok. Executed tests."
-- 
2.27.0.278.ge193c7cf3a9-goog

