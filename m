Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8199914EC73
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgAaMZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:25:03 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:18569 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgAaMZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580473502; x=1612009502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=eRB/ftryms8SbjXF4iCqjGPRzeoxvd6GBWw9lqbtxB0=;
  b=nQKRHryKLJTFcb+57IaviVMdb2qPECQXko9UubgfQWvYGkktseAKrRGv
   8zjjRABXK24DImgyYC8votSkIc63bJpPi2RvM3f/EEoOE7Qz+Q2WWWTtl
   7ZKEBEncQsN+PbH3DNsLjqyuOLPpRR4P/cKr8USFutdA2M3nGdRsIVWco
   4=;
IronPort-SDR: FjtJcV8W/7QMEyRqX73rrKYPGUu1l5ipxU5Wqi/KNdrAmwIT9DzgOkbgj4ecX+WVJjdtpLd8Eo
 Hj7woZy7te9w==
X-IronPort-AV: E=Sophos;i="5.70,385,1574121600"; 
   d="scan'208";a="14174527"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Jan 2020 12:25:00 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 3822CC5CEB;
        Fri, 31 Jan 2020 12:24:57 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 12:24:57 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.50) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 12:24:52 +0000
From:   <sjpark@amazon.com>
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sj38.park@gmail.com>, <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH 3/3] selftests: net: Add FIN_ACK processing order related latency spike test
Date:   Fri, 31 Jan 2020 13:24:21 +0100
Message-ID: <20200131122421.23286-4-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131122421.23286-1-sjpark@amazon.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This commit adds a test for FIN_ACK process races related reconnection
latency spike issues.  The issue has described and solved by the
previous commit ("tcp: Reduce SYN resend delay if a suspicous ACK is
received").

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 tools/testing/selftests/net/.gitignore        |  2 +
 tools/testing/selftests/net/Makefile          |  2 +
 tools/testing/selftests/net/fin_ack_lat.sh    | 42 ++++++++++
 .../selftests/net/fin_ack_lat_accept.c        | 49 +++++++++++
 .../selftests/net/fin_ack_lat_connect.c       | 81 +++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh
 create mode 100644 tools/testing/selftests/net/fin_ack_lat_accept.c
 create mode 100644 tools/testing/selftests/net/fin_ack_lat_connect.c

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
index a8e04d665b69..e4938c26ce3f 100644
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
+TEST_GEN_FILES += fin_ack_lat_accept fin_ack_lat_connect
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/fin_ack_lat.sh b/tools/testing/selftests/net/fin_ack_lat.sh
new file mode 100755
index 000000000000..0a398c837b7a
--- /dev/null
+++ b/tools/testing/selftests/net/fin_ack_lat.sh
@@ -0,0 +1,42 @@
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
+kill_accept() {
+	kill $ACCEPT_PID
+}
+
+cleanup() {
+	kill_accept
+	rm -f $tmpfile
+}
+
+trap cleanup EXIT
+
+do_test() {
+	RUNTIME=$1
+
+	./fin_ack_lat_accept &
+	ACCEPT_PID=$!
+	sleep 1
+
+	./fin_ack_lat_connect | tee $tmpfile &
+	sleep $RUNTIME
+	NR_SPIKES=$(wc -l $tmpfile | awk '{print $1}')
+	rm $tmpfile
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
diff --git a/tools/testing/selftests/net/fin_ack_lat_accept.c b/tools/testing/selftests/net/fin_ack_lat_accept.c
new file mode 100644
index 000000000000..a0f0210f12b4
--- /dev/null
+++ b/tools/testing/selftests/net/fin_ack_lat_accept.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <error.h>
+#include <netinet/in.h>
+#include <stdio.h>
+#include <sys/socket.h>
+#include <unistd.h>
+
+int main(int argc, char const *argv[])
+{
+	int sock, new_sock;
+	int opt = 1;
+	struct sockaddr_in address;
+	int addrlen = sizeof(address);
+	int buffer;
+	int rc;
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+	if (!sock)
+		error(-1, -1, "socket");
+
+	rc = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
+			&opt, sizeof(opt));
+	if (rc == -1)
+		error(-1, -1, "setsockopt");
+
+	address.sin_family = AF_INET;
+	address.sin_addr.s_addr = INADDR_ANY;
+	address.sin_port = htons(4242);
+
+	rc = bind(sock, (struct sockaddr *)&address, sizeof(address));
+	if (rc < 0)
+		error(-1, -1, "bind");
+
+	rc = listen(sock, 3);
+	if (rc < 0)
+		error(-1, -1, "listen");
+
+	while (1) {
+		new_sock = accept(sock, (struct sockaddr *)&address,
+				(socklen_t *)&addrlen);
+		if (new_sock < 0)
+			error(-1, -1, "accept");
+
+		rc = read(new_sock, &buffer, sizeof(buffer));
+		close(new_sock);
+	}
+	return 0;
+}
diff --git a/tools/testing/selftests/net/fin_ack_lat_connect.c b/tools/testing/selftests/net/fin_ack_lat_connect.c
new file mode 100644
index 000000000000..abfdd79f2e17
--- /dev/null
+++ b/tools/testing/selftests/net/fin_ack_lat_connect.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <arpa/inet.h>
+#include <error.h>
+#include <netinet/tcp.h>
+#include <stdio.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <unistd.h>
+
+static unsigned long timediff(struct timeval s, struct timeval e)
+{
+	if (s.tv_sec > e.tv_sec)
+		return 0;
+	return (e.tv_sec - s.tv_sec) * 1000000 + e.tv_usec - s.tv_usec;
+}
+
+int main(int argc, char const *argv[])
+{
+	int sock = 0;
+	struct sockaddr_in addr, laddr;
+	socklen_t len = sizeof(laddr);
+	struct linger sl;
+	int flag = 1;
+	int buffer;
+	int rc;
+	struct timeval start, end;
+	unsigned long lat, sum_lat = 0, nr_lat = 0;
+
+	while (1) {
+		gettimeofday(&start, NULL);
+
+		sock = socket(AF_INET, SOCK_STREAM, 0);
+		if (sock < 0)
+			error(-1, -1, "socket creation");
+
+		sl.l_onoff = 1;
+		sl.l_linger = 0;
+		if (setsockopt(sock, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl)))
+			error(-1, -1, "setsockopt(linger)");
+
+		if (setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
+					&flag, sizeof(flag)))
+			error(-1, -1, "setsockopt(nodelay)");
+
+		addr.sin_family = AF_INET;
+		addr.sin_port = htons(4242);
+
+		rc = inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
+		if (rc <= 0)
+			error(-1, -1, "inet_pton");
+
+		rc = connect(sock, (struct sockaddr *)&addr, sizeof(addr));
+		if (rc < 0)
+			error(-1, -1, "connect");
+
+		send(sock, &buffer, sizeof(buffer), 0);
+
+		rc = read(sock, &buffer, sizeof(buffer));
+
+		gettimeofday(&end, NULL);
+		lat = timediff(start, end);
+		sum_lat += lat;
+		nr_lat++;
+		if (lat > 100000) {
+			rc = getsockname(sock, (struct sockaddr *)&laddr, &len);
+			if (rc == -1)
+				error(-1, -1, "getsockname");
+			printf("port: %d, lat: %lu, avg: %lu, nr: %lu\n",
+					ntohs(laddr.sin_port), lat,
+					sum_lat / nr_lat, nr_lat);
+		}
+
+		if (nr_lat % 1000 == 0)
+			fflush(stdout);
+
+
+		close(sock);
+	}
+	return 0;
+}
-- 
2.17.1

