Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6A14F700
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBAHTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:19:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53756 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBAHTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 02:19:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so10412656wmh.3;
        Fri, 31 Jan 2020 23:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nDZJNHL4OU1XJak71OF6dD4WMDbmOF9lFtCNCpKc/e8=;
        b=IAi3WeVlKLwte/E78lO66JOZivCR38Wl6LWf2u4gfCfn9gfobuLieY1ddOhY4TdE3+
         MzgFWDbq2jeAxsR7i8gq/6l+7+dnQfvMe8snmtU3nIkERAAXH4450BA5WbjsrZnwJ+Pc
         bDJ167M+Imi13+Fv3s3/XPDd3D+2hU8NlRwAr8JfWKZlZe6QHyc6AR3c1NvM54uciRjh
         2CBe2b1WfOK04DGTJhIWS2dWr5ane1p0w++JQ8FKK23hSFs/L8N5XdLySy5e/zvvPNZi
         GccxntdzwylAvh3lM0xtMOzWWEgnuy6c3JXJ5Qw88vvSFckqHofNfZ3+PlYD4sAaOD+0
         x/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nDZJNHL4OU1XJak71OF6dD4WMDbmOF9lFtCNCpKc/e8=;
        b=ezefN1FI09IqUU/mmEshdnjqhUX6m9FBHk4xEy9DIQdvxoNH/dfIXRbK9QVjUShj+f
         bJEXcqN7jQPzMnJCCKDgmdIjZGHkfMU+/yIcdRSrdjVdL3h1uaAze2RjF3746etJcbUd
         +5K7wfTvSgqa/X5JXmsEQLlAXks2O43pwIu1S5lQjBP1fmUj7Er+xvVTItNml683r/2N
         lEvOSM19HjX6Tc1Y6CLK7ZubodAjh7GN2sIsrfrdwkuQBXfvsGwjnnVjNBmZ+KsuxCMp
         xbB7IyNG7T9OK/KGItjt8dqr+xdVtjGciBaizcGxGX9y/PQqrqNvwWcYX045w0A0FeB8
         E20Q==
X-Gm-Message-State: APjAAAU3sXeK4Q2EuxxYnVfWvTU2Wlh4oX2wbF/p/IqFNFE9pefZblbr
        oWZMVgU2nHRtMxFGJHbuH7I=
X-Google-Smtp-Source: APXvYqxAsNmIf2xl11xa2UqkdsG5huZwSHeTF//OsXgsBjeac4Tga45bN952Ni8T/h7yPy4RLZTagw==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr17390997wmk.50.1580541553626;
        Fri, 31 Jan 2020 23:19:13 -0800 (PST)
Received: from localhost.localdomain (cable-158-181-93-24.cust.telecolumbus.net. [158.181.93.24])
        by smtp.gmail.com with ESMTPSA id o4sm664286wrw.15.2020.01.31.23.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 23:19:12 -0800 (PST)
From:   sj38.park@gmail.com
To:     eric.dumazet@gmail.com, edumazet@google.com
Cc:     davem@davemloft.net, aams@amazon.com, ncardwell@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org, ycheng@google.com,
        David.Laight@ACULAB.COM, sj38.park@gmail.com,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH v2 2/2] selftests: net: Add FIN_ACK processing order related latency spike test
Date:   Sat,  1 Feb 2020 07:18:59 +0000
Message-Id: <20200201071859.4231-3-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200201071859.4231-1-sj38.park@gmail.com>
References: <20200201071859.4231-1-sj38.park@gmail.com>
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

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 tools/testing/selftests/net/.gitignore     |   2 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/fin_ack_lat.c  | 151 +++++++++++++++++++++
 tools/testing/selftests/net/fin_ack_lat.sh |  35 +++++
 4 files changed, 190 insertions(+)
 create mode 100644 tools/testing/selftests/net/fin_ack_lat.c
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 8aefd81fbc86..1bcf7b5498dd 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -22,3 +22,5 @@ ipv6_flowlabel_mgr
 so_txtime
 tcp_fastopen_backup_key
 nettest
+fin_ack_lat_accept
+fin_ack_lat_connect
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

