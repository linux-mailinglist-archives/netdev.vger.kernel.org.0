Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE214FB58
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 04:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBBDi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 22:38:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42011 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgBBDi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 22:38:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so5629504pfz.9;
        Sat, 01 Feb 2020 19:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d32kO5MNmp/RklBoxabba45xsh+0d41hE5SnVb1Zw90=;
        b=MV4IgFAcmz4XdEmDE1V6xh9oVQJAK2spyiKNboRNVS0OZEAs6eeV1MRvs1C8RJKpLE
         qPZFIzHlDlS/yBsIWxAH/zG2Khi7Iy9w/niOgdnrx4DhxaRqqX9SF2oavWRB3/Ws6Hzf
         8JizLS+Sp5GrJHB7Ub8Yu2IDPW0Z3+IlT8IZgh0f/vbcQG3QX+jlLDRST2KsNYs/wJWR
         KAHG8qGXZcmI2E8+nm6McwuV+f2946X1nzH2KjiAMV+v/3Dy33/5k52NA1Rnnj23SrEX
         W+/fhXpC2GT1q24+eNIJkSBgK7fyWW3VoWiqTZFNQLjQOty4AdXPf++NFZA6alJGKSOL
         5fXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d32kO5MNmp/RklBoxabba45xsh+0d41hE5SnVb1Zw90=;
        b=T42IUaU3L523mZN+T+tK7iZTql3Gnk/8Tam9r4HXfYDAKbxdmaKe3ZLEfu6CVRUeB2
         2b9VIguHT5TeSXqR3HV6ExaV7XW6Np9NI+M0Am6fX7UGGwl/1vjd0SKpci0Pv48wbfJc
         sO3UV67T61nPKPDbTvBmSoBMHJYguvPZ7MDfNXBvR5JoCYh8Ub2WOVo0wwud64JF68Av
         LQBn2O8pQE9TDaKvpebutYl7wyJtGeatKrHIGh28vPdxWJ4JedqYH8Wj6NXV2LExtjQQ
         5MdIOnJ+a7lxvoOtNCG2Nnc6FSYZTJ1GIyT6lKzA9Hid9pwQgTMAw/j4HLFS3aciPXkY
         Pxaw==
X-Gm-Message-State: APjAAAWYStObMMqmcHLEMNHACy92a669TfbDLS92lOk1DLqPOyJCO8m2
        f06Jr4cEIAhlgfVCps3+p+U=
X-Google-Smtp-Source: APXvYqw6gPQOqL/y0ye+tSAeIj6hgql//SeDyIxWHOQ904mqBVT8wII8dI8JXD539amJd2msyKj+rg==
X-Received: by 2002:a63:5f4e:: with SMTP id t75mr53722pgb.7.1580614736240;
        Sat, 01 Feb 2020 19:38:56 -0800 (PST)
Received: from localhost.localdomain ([116.84.110.10])
        by smtp.gmail.com with ESMTPSA id iq22sm15705334pjb.9.2020.02.01.19.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 19:38:55 -0800 (PST)
From:   sj38.park@gmail.com
To:     edumazet@google.com
Cc:     sj38.park@gmail.com, David.Laight@aculab.com, aams@amazon.com,
        davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        shuah@kernel.org, sjpark@amazon.de
Subject: [PATCH v3 2/2] selftests: net: Add FIN_ACK processing order related latency spike test
Date:   Sun,  2 Feb 2020 03:38:27 +0000
Message-Id: <20200202033827.16304-3-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200202033827.16304-1-sj38.park@gmail.com>
References: <20200202033827.16304-1-sj38.park@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This commit adds a test for FIN_ACK process races related reconnection
latency spike issues.  The issue has described and solved by the
previous commit ("tcp: Reduce SYN resend delay if a suspicous ACK is
received").

The test program is configured with a server and a client process.  The
server creates and binds a socket to a port that dynamically allocated,
listen on it, and start a infinite loop.  Inside the loop, it accepts
connection, reads 4 bytes from the socket, and closes the connection.
The client is constructed as an infinite loop.  Inside the loop, it
creates a socket with LINGER and NODELAY option, connect to the server,
send 4 bytes data, try read some data from server.  After the read()
returns, it measure the latency from the beginning of this loop to this
point and if the latency is larger than 1 second (spike), print a
message.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 tools/testing/selftests/net/.gitignore     |   1 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/fin_ack_lat.c  | 151 +++++++++++++++++++++
 tools/testing/selftests/net/fin_ack_lat.sh |  35 +++++
 4 files changed, 189 insertions(+)
 create mode 100644 tools/testing/selftests/net/fin_ack_lat.c
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 8aefd81fbc86..ecc52d4c034d 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -22,3 +22,4 @@ ipv6_flowlabel_mgr
 so_txtime
 tcp_fastopen_backup_key
 nettest
+fin_ack_lat
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index a8e04d665b69..b5694196430a 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,6 +11,7 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
+TEST_PROGS += fin_ack_lat.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
@@ -18,6 +19,7 @@ TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
 TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
 TEST_GEN_FILES += tcp_fastopen_backup_key
+TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/fin_ack_lat.c b/tools/testing/selftests/net/fin_ack_lat.c
new file mode 100644
index 000000000000..70187494b57a
--- /dev/null
+++ b/tools/testing/selftests/net/fin_ack_lat.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <unistd.h>
+
+static int child_pid;
+
+static unsigned long timediff(struct timeval s, struct timeval e)
+{
+	unsigned long s_us, e_us;
+
+	s_us = s.tv_sec * 1000000 + s.tv_usec;
+	e_us = e.tv_sec * 1000000 + e.tv_usec;
+	if (s_us > e_us)
+		return 0;
+	return e_us - s_us;
+}
+
+static void client(int port)
+{
+	int sock = 0;
+	struct sockaddr_in addr, laddr;
+	socklen_t len = sizeof(laddr);
+	struct linger sl;
+	int flag = 1;
+	int buffer;
+	struct timeval start, end;
+	unsigned long lat, sum_lat = 0, nr_lat = 0;
+
+	while (1) {
+		gettimeofday(&start, NULL);
+
+		sock = socket(AF_INET, SOCK_STREAM, 0);
+		if (sock < 0)
+			error(-1, errno, "socket creation");
+
+		sl.l_onoff = 1;
+		sl.l_linger = 0;
+		if (setsockopt(sock, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl)))
+			error(-1, errno, "setsockopt(linger)");
+
+		if (setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
+					&flag, sizeof(flag)))
+			error(-1, errno, "setsockopt(nodelay)");
+
+		addr.sin_family = AF_INET;
+		addr.sin_port = htons(port);
+
+		if (inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr) <= 0)
+			error(-1, errno, "inet_pton");
+
+		if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
+			error(-1, errno, "connect");
+
+		send(sock, &buffer, sizeof(buffer), 0);
+		if (read(sock, &buffer, sizeof(buffer)) == -1)
+			error(-1, errno, "waiting read");
+
+		gettimeofday(&end, NULL);
+		lat = timediff(start, end);
+		sum_lat += lat;
+		nr_lat++;
+		if (lat < 100000)
+			goto close;
+
+		if (getsockname(sock, (struct sockaddr *)&laddr, &len) == -1)
+			error(-1, errno, "getsockname");
+		printf("port: %d, lat: %lu, avg: %lu, nr: %lu\n",
+				ntohs(laddr.sin_port), lat,
+				sum_lat / nr_lat, nr_lat);
+close:
+		fflush(stdout);
+		close(sock);
+	}
+}
+
+static void server(int sock, struct sockaddr_in address)
+{
+	int accepted;
+	int addrlen = sizeof(address);
+	int buffer;
+
+	while (1) {
+		accepted = accept(sock, (struct sockaddr *)&address,
+				(socklen_t *)&addrlen);
+		if (accepted < 0)
+			error(-1, errno, "accept");
+
+		if (read(accepted, &buffer, sizeof(buffer)) == -1)
+			error(-1, errno, "read");
+		close(accepted);
+	}
+}
+
+static void sig_handler(int signum)
+{
+	kill(SIGTERM, child_pid);
+	exit(0);
+}
+
+int main(int argc, char const *argv[])
+{
+	int sock;
+	int opt = 1;
+	struct sockaddr_in address;
+	struct sockaddr_in laddr;
+	socklen_t len = sizeof(laddr);
+
+	if (signal(SIGTERM, sig_handler) == SIG_ERR)
+		error(-1, errno, "signal");
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock < 0)
+		error(-1, errno, "socket");
+
+	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
+				&opt, sizeof(opt)) == -1)
+		error(-1, errno, "setsockopt");
+
+	address.sin_family = AF_INET;
+	address.sin_addr.s_addr = INADDR_ANY;
+	/* dynamically allocate unused port */
+	address.sin_port = 0;
+
+	if (bind(sock, (struct sockaddr *)&address, sizeof(address)) < 0)
+		error(-1, errno, "bind");
+
+	if (listen(sock, 3) < 0)
+		error(-1, errno, "listen");
+
+	if (getsockname(sock, (struct sockaddr *)&laddr, &len) == -1)
+		error(-1, errno, "getsockname");
+
+	fprintf(stderr, "server port: %d\n", ntohs(laddr.sin_port));
+	child_pid = fork();
+	if (!child_pid)
+		client(ntohs(laddr.sin_port));
+	else
+		server(sock, laddr);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/net/fin_ack_lat.sh b/tools/testing/selftests/net/fin_ack_lat.sh
new file mode 100755
index 000000000000..a3ff6e0b2c7a
--- /dev/null
+++ b/tools/testing/selftests/net/fin_ack_lat.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test latency spikes caused by FIN/ACK handling race.
+
+set +x
+set -e
+
+tmpfile=$(mktemp /tmp/fin_ack_latency.XXXX.log)
+
+cleanup() {
+	kill $(pidof fin_ack_lat)
+	rm -f $tmpfile
+}
+
+trap cleanup EXIT
+
+do_test() {
+	RUNTIME=$1
+
+	./fin_ack_lat | tee $tmpfile &
+	PID=$!
+
+	sleep $RUNTIME
+	NR_SPIKES=$(wc -l $tmpfile | awk '{print $1}')
+	if [ $NR_SPIKES -gt 0 ]
+	then
+		echo "FAIL: $NR_SPIKES spikes detected"
+		return 1
+	fi
+	return 0
+}
+
+do_test "30"
+echo "test done"
-- 
2.17.1

