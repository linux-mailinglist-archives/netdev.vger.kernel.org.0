Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F73E350B55
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 02:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhDAAkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 20:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhDAAk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 20:40:27 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C55C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 17:40:27 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id bt20so2363809qvb.0
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P0P+EdM3uAh8Ve4ov7sZfhTKj0sj9n1drK6RAUd4IJs=;
        b=Mfb4kthe8L8/meZhA1vUbc3IdZ3VBaOq5NienvlSB/GhnvRA4AoGDkZ0rxN2ju0x13
         bgSm621nK+nOpGehhyd8KPfGX/R40l55IKW0qJsfD2SSgvBIg+DhmTgGc4ZexncecrzY
         neFvRrcL6ZodRpPh5XLqlMNAEnD5z9wzX1nUvbXb6YiYlD9AaioaFVmVWTRemPuB741k
         0fObeq1MH0OYFeGXgr0iI9EvJlIJOORrc5CET1BaEju0iY4v3EBOj0hvtwZxjgm5fO/y
         FYnRIwg5omaxaphDfVpGgokOMGYPUXj5skb669t/3upkCJ+VQ7FHkopOcbNJZgqnhYDH
         kogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P0P+EdM3uAh8Ve4ov7sZfhTKj0sj9n1drK6RAUd4IJs=;
        b=d6+ihxYW1Zjb9Bddsg44J11Ix4O+gr3XpmK8EW9DGHDJRobP1YoUORVEzsWNmyj8Yc
         lBZI50ioX8uemYBFh1tIXgYQDXkXa3h2zq5hE8Ah3YLXw8fnFrH3gd6sxw9wP+PlndIi
         01U5WeLUsirOqEDHdgmIyln6wPWaXvX95QBFwmynDOH8QC+bTcFvBXghq/EH7HkB4Vix
         tas0OlzD5/JR6j1c+Y/rZUvcBQhHfrfFga3usGaofkT6pPojsU8f/ZezdQcZiORTg64c
         YRtR3zetaYjOzQVZkYBCj3Bw0pAJh1C+Bp5sAFrpoZ3cFUQ7vKBqxUM0dYLlfm0eF1pp
         EX/w==
X-Gm-Message-State: AOAM53362hpxnGo0SHVIZOwwCblpWHPZjRLUCNShHfZeWQxyUinQbA/r
        O8pHabhaLVE61hUUKA1VycYML5xtWvzgJA==
X-Google-Smtp-Source: ABdhPJxlFRHJObLZ6+ikLU9NzHyrnfGCITEl+hOPvt+pbSquHeTXUmdVmBalgzcbOmyvx2IZisym/zgb2ohbrw==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:b1])
 (user=cmllamas job=sendgmr) by 2002:a0c:e1c7:: with SMTP id
 v7mr5843763qvl.30.1617237626612; Wed, 31 Mar 2021 17:40:26 -0700 (PDT)
Date:   Thu,  1 Apr 2021 00:40:20 +0000
Message-Id: <20210401004020.3523920-1-cmllamas@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH net-next] selftests/net: so_txtime multi-host support
From:   Carlos Llamas <cmllamas@google.com>
To:     willemb@google.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SO_TXTIME hardware offload requires testing across devices, either
between machines or separate network namespaces.

Split up SO_TXTIME test into tx and rx modes, so traffic can be
sent from one process to another. Create a veth-pair on different
namespaces and bind each process to an end point via [-S]ource and
[-D]estination parameters. Optional start [-t]ime parameter can be
passed to synchronize the test across the hosts (with synchorinzed
clocks).

Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c  | 247 +++++++++++++++++------
 tools/testing/selftests/net/so_txtime.sh |  97 +++++++--
 2 files changed, 259 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index b4cca382d125..59067f64b775 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -2,9 +2,12 @@
 /*
  * Test the SO_TXTIME API
  *
- * Takes two streams of { payload, delivery time }[], one input and one output.
- * Sends the input stream and verifies arrival matches the output stream.
- * The two streams can differ due to out-of-order delivery and drops.
+ * Takes a stream of { payload, delivery time }[], to be sent across two
+ * processes. Start this program on two separate network namespaces or
+ * connected hosts, one instance in transmit mode and the other in receive
+ * mode using the '-r' option. Receiver will compare arrival timestamps to
+ * the expected stream. Sender will read transmit timestamps from the error
+ * queue. The streams can differ due to out-of-order delivery and drops.
  */
 
 #define _GNU_SOURCE
@@ -28,14 +31,17 @@
 #include <sys/types.h>
 #include <time.h>
 #include <unistd.h>
+#include <poll.h>
 
 static int	cfg_clockid	= CLOCK_TAI;
-static bool	cfg_do_ipv4;
-static bool	cfg_do_ipv6;
 static uint16_t	cfg_port	= 8000;
 static int	cfg_variance_us	= 4000;
+static uint64_t	cfg_start_time_ns;
+static int	cfg_mark;
+static bool	cfg_rx;
 
 static uint64_t glob_tstart;
+static uint64_t tdeliver_max;
 
 /* encode one timed transmission (of a 1B payload) */
 struct timed_send {
@@ -44,18 +50,21 @@ struct timed_send {
 };
 
 #define MAX_NUM_PKT	8
-static struct timed_send cfg_in[MAX_NUM_PKT];
-static struct timed_send cfg_out[MAX_NUM_PKT];
+static struct timed_send cfg_buf[MAX_NUM_PKT];
 static int cfg_num_pkt;
 
 static int cfg_errq_level;
 static int cfg_errq_type;
 
-static uint64_t gettime_ns(void)
+static struct sockaddr_storage cfg_dst_addr;
+static struct sockaddr_storage cfg_src_addr;
+static socklen_t cfg_alen;
+
+static uint64_t gettime_ns(clockid_t clock)
 {
 	struct timespec ts;
 
-	if (clock_gettime(cfg_clockid, &ts))
+	if (clock_gettime(clock, &ts))
 		error(1, errno, "gettime");
 
 	return ts.tv_sec * (1000ULL * 1000 * 1000) + ts.tv_nsec;
@@ -75,6 +84,8 @@ static void do_send_one(int fdt, struct timed_send *ts)
 
 	msg.msg_iov = &iov;
 	msg.msg_iovlen = 1;
+	msg.msg_name = (struct sockaddr *)&cfg_dst_addr;
+	msg.msg_namelen = cfg_alen;
 
 	if (ts->delay_us >= 0) {
 		memset(control, 0, sizeof(control));
@@ -82,6 +93,8 @@ static void do_send_one(int fdt, struct timed_send *ts)
 		msg.msg_controllen = sizeof(control);
 
 		tdeliver = glob_tstart + ts->delay_us * 1000;
+		tdeliver_max = tdeliver_max > tdeliver ?
+			       tdeliver_max : tdeliver;
 
 		cm = CMSG_FIRSTHDR(&msg);
 		cm->cmsg_level = SOL_SOCKET;
@@ -98,7 +111,7 @@ static void do_send_one(int fdt, struct timed_send *ts)
 
 }
 
-static bool do_recv_one(int fdr, struct timed_send *ts)
+static void do_recv_one(int fdr, struct timed_send *ts)
 {
 	int64_t tstop, texpect;
 	char rbuf[2];
@@ -106,13 +119,13 @@ static bool do_recv_one(int fdr, struct timed_send *ts)
 
 	ret = recv(fdr, rbuf, sizeof(rbuf), 0);
 	if (ret == -1 && errno == EAGAIN)
-		return true;
+		error(1, EAGAIN, "recv: timeout");
 	if (ret == -1)
 		error(1, errno, "read");
 	if (ret != 1)
 		error(1, 0, "read: %dB", ret);
 
-	tstop = (gettime_ns() - glob_tstart) / 1000;
+	tstop = (gettime_ns(cfg_clockid) - glob_tstart) / 1000;
 	texpect = ts->delay_us >= 0 ? ts->delay_us : 0;
 
 	fprintf(stderr, "payload:%c delay:%lld expected:%lld (us)\n",
@@ -123,8 +136,6 @@ static bool do_recv_one(int fdr, struct timed_send *ts)
 
 	if (llabs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
-
-	return false;
 }
 
 static void do_recv_verify_empty(int fdr)
@@ -137,18 +148,18 @@ static void do_recv_verify_empty(int fdr)
 		error(1, 0, "recv: not empty as expected (%d, %d)", ret, errno);
 }
 
-static void do_recv_errqueue_timeout(int fdt)
+static int do_recv_errqueue_timeout(int fdt)
 {
 	char control[CMSG_SPACE(sizeof(struct sock_extended_err)) +
 		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
 	char data[sizeof(struct ethhdr) + sizeof(struct ipv6hdr) +
 		  sizeof(struct udphdr) + 1];
 	struct sock_extended_err *err;
+	int ret, num_tstamp = 0;
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	struct cmsghdr *cm;
 	int64_t tstamp = 0;
-	int ret;
 
 	iov.iov_base = data;
 	iov.iov_len = sizeof(data);
@@ -206,9 +217,47 @@ static void do_recv_errqueue_timeout(int fdt)
 
 		msg.msg_flags = 0;
 		msg.msg_controllen = sizeof(control);
+		num_tstamp++;
 	}
 
-	error(1, 0, "recv: timeout");
+	return num_tstamp;
+}
+
+static void recv_errqueue_msgs(int fdt)
+{
+	struct pollfd pfd = { .fd = fdt, .events = POLLERR };
+	const int timeout_ms = 10;
+	int ret, num_tstamp = 0;
+
+	do {
+		ret = poll(&pfd, 1, timeout_ms);
+		if (ret == -1)
+			error(1, errno, "poll");
+
+		if (ret && (pfd.revents & POLLERR))
+			num_tstamp += do_recv_errqueue_timeout(fdt);
+
+		if (num_tstamp == cfg_num_pkt)
+			break;
+
+	} while (gettime_ns(cfg_clockid) < tdeliver_max);
+}
+
+static void start_time_wait(void)
+{
+	uint64_t now;
+	int err;
+
+	if (!cfg_start_time_ns)
+		return;
+
+	now = gettime_ns(CLOCK_REALTIME);
+	if (cfg_start_time_ns < now)
+		return;
+
+	err = usleep((cfg_start_time_ns - now) / 1000);
+	if (err)
+		error(1, errno, "usleep");
 }
 
 static void setsockopt_txtime(int fd)
@@ -245,6 +294,10 @@ static int setup_tx(struct sockaddr *addr, socklen_t alen)
 
 	setsockopt_txtime(fd);
 
+	if (cfg_mark &&
+	    setsockopt(fd, SOL_SOCKET, SO_MARK, &cfg_mark, sizeof(cfg_mark)))
+		error(1, errno, "setsockopt mark");
+
 	return fd;
 }
 
@@ -266,31 +319,70 @@ static int setup_rx(struct sockaddr *addr, socklen_t alen)
 	return fd;
 }
 
-static void do_test(struct sockaddr *addr, socklen_t alen)
+static void do_test_tx(struct sockaddr *addr, socklen_t alen)
 {
-	int fdt, fdr, i;
+	int fdt, i;
 
 	fprintf(stderr, "\nSO_TXTIME ipv%c clock %s\n",
 			addr->sa_family == PF_INET ? '4' : '6',
 			cfg_clockid == CLOCK_TAI ? "tai" : "monotonic");
 
 	fdt = setup_tx(addr, alen);
-	fdr = setup_rx(addr, alen);
 
-	glob_tstart = gettime_ns();
+	start_time_wait();
+	glob_tstart = gettime_ns(cfg_clockid);
 
 	for (i = 0; i < cfg_num_pkt; i++)
-		do_send_one(fdt, &cfg_in[i]);
+		do_send_one(fdt, &cfg_buf[i]);
+
+	recv_errqueue_msgs(fdt);
+
+	if (close(fdt))
+		error(1, errno, "close t");
+}
+
+static void do_test_rx(struct sockaddr *addr, socklen_t alen)
+{
+	int fdr, i;
+
+	fdr = setup_rx(addr, alen);
+
+	start_time_wait();
+	glob_tstart = gettime_ns(cfg_clockid);
+
 	for (i = 0; i < cfg_num_pkt; i++)
-		if (do_recv_one(fdr, &cfg_out[i]))
-			do_recv_errqueue_timeout(fdt);
+		do_recv_one(fdr, &cfg_buf[i]);
 
 	do_recv_verify_empty(fdr);
 
 	if (close(fdr))
 		error(1, errno, "close r");
-	if (close(fdt))
-		error(1, errno, "close t");
+}
+
+static void setup_sockaddr(int domain, const char *str_addr,
+			   struct sockaddr_storage *sockaddr)
+{
+	struct sockaddr_in6 *addr6 = (void *) sockaddr;
+	struct sockaddr_in *addr4 = (void *) sockaddr;
+
+	switch (domain) {
+	case PF_INET:
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		if (str_addr &&
+		    inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", str_addr);
+		break;
+	case PF_INET6:
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		if (str_addr &&
+		    inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", str_addr);
+		break;
+	}
 }
 
 static int parse_io(const char *optarg, struct timed_send *array)
@@ -323,17 +415,46 @@ static int parse_io(const char *optarg, struct timed_send *array)
 	return aoff / 2;
 }
 
+static void usage(const char *progname)
+{
+	fprintf(stderr, "\nUsage: %s [options] <payload>\n"
+			"Options:\n"
+			"  -4            only IPv4\n"
+			"  -6            only IPv6\n"
+			"  -c <clock>    monotonic (default) or tai\n"
+			"  -D <addr>     destination IP address (server)\n"
+			"  -S <addr>     source IP address (client)\n"
+			"  -r            run rx mode\n"
+			"  -t <nsec>     start time (UTC nanoseconds)\n"
+			"  -m <mark>     socket mark\n"
+			"\n",
+			progname);
+	exit(1);
+}
+
 static void parse_opts(int argc, char **argv)
 {
-	int c, ilen, olen;
+	char *daddr = NULL, *saddr = NULL;
+	int domain = PF_UNSPEC;
+	int c;
 
-	while ((c = getopt(argc, argv, "46c:")) != -1) {
+	while ((c = getopt(argc, argv, "46c:S:D:rt:m:")) != -1) {
 		switch (c) {
 		case '4':
-			cfg_do_ipv4 = true;
+			if (domain != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			domain = PF_INET;
+			cfg_alen = sizeof(struct sockaddr_in);
+			cfg_errq_level = SOL_IP;
+			cfg_errq_type = IP_RECVERR;
 			break;
 		case '6':
-			cfg_do_ipv6 = true;
+			if (domain != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			domain = PF_INET6;
+			cfg_alen = sizeof(struct sockaddr_in6);
+			cfg_errq_level = SOL_IPV6;
+			cfg_errq_type = IPV6_RECVERR;
 			break;
 		case 'c':
 			if (!strcmp(optarg, "tai"))
@@ -344,50 +465,50 @@ static void parse_opts(int argc, char **argv)
 			else
 				error(1, 0, "unknown clock id %s", optarg);
 			break;
+		case 'S':
+			saddr = optarg;
+			break;
+		case 'D':
+			daddr = optarg;
+			break;
+		case 'r':
+			cfg_rx = true;
+			break;
+		case 't':
+			cfg_start_time_ns = strtol(optarg, NULL, 0);
+			break;
+		case 'm':
+			cfg_mark = strtol(optarg, NULL, 0);
+			break;
 		default:
-			error(1, 0, "parse error at %d", optind);
+			usage(argv[0]);
 		}
 	}
 
-	if (argc - optind != 2)
-		error(1, 0, "Usage: %s [-46] -c <clock> <in> <out>", argv[0]);
+	if (argc - optind != 1)
+		usage(argv[0]);
+
+	if (domain == PF_UNSPEC)
+		error(1, 0, "Pass one of -4 or -6");
+	if (!daddr)
+		error(1, 0, "-D <server addr> required\n");
+	if (!cfg_rx && !saddr)
+		error(1, 0, "-S <client addr> required\n");
 
-	ilen = parse_io(argv[optind], cfg_in);
-	olen = parse_io(argv[optind + 1], cfg_out);
-	if (ilen != olen)
-		error(1, 0, "i/o streams len mismatch (%d, %d)\n", ilen, olen);
-	cfg_num_pkt = ilen;
+	setup_sockaddr(domain, daddr, &cfg_dst_addr);
+	setup_sockaddr(domain, saddr, &cfg_src_addr);
+
+	cfg_num_pkt = parse_io(argv[optind], cfg_buf);
 }
 
 int main(int argc, char **argv)
 {
 	parse_opts(argc, argv);
 
-	if (cfg_do_ipv6) {
-		struct sockaddr_in6 addr6 = {0};
-
-		addr6.sin6_family = AF_INET6;
-		addr6.sin6_port = htons(cfg_port);
-		addr6.sin6_addr = in6addr_loopback;
-
-		cfg_errq_level = SOL_IPV6;
-		cfg_errq_type = IPV6_RECVERR;
-
-		do_test((void *)&addr6, sizeof(addr6));
-	}
-
-	if (cfg_do_ipv4) {
-		struct sockaddr_in addr4 = {0};
-
-		addr4.sin_family = AF_INET;
-		addr4.sin_port = htons(cfg_port);
-		addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
-
-		cfg_errq_level = SOL_IP;
-		cfg_errq_type = IP_RECVERR;
-
-		do_test((void *)&addr4, sizeof(addr4));
-	}
+	if (cfg_rx)
+		do_test_rx((void *)&cfg_dst_addr, cfg_alen);
+	else
+		do_test_tx((void *)&cfg_src_addr, cfg_alen);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/net/so_txtime.sh b/tools/testing/selftests/net/so_txtime.sh
index 3f7800eaecb1..3f06f4d286a9 100755
--- a/tools/testing/selftests/net/so_txtime.sh
+++ b/tools/testing/selftests/net/so_txtime.sh
@@ -3,32 +3,85 @@
 #
 # Regression tests for the SO_TXTIME interface
 
-# Run in network namespace
-if [[ $# -eq 0 ]]; then
-	if ! ./in_netns.sh $0 __subprocess; then
-		# test is time sensitive, can be flaky
-		echo "test failed: retry once"
-		./in_netns.sh $0 __subprocess
+set -e
+
+readonly DEV="veth0"
+readonly BIN="./so_txtime"
+
+readonly RAND="$(mktemp -u XXXXXX)"
+readonly NSPREFIX="ns-${RAND}"
+readonly NS1="${NSPREFIX}1"
+readonly NS2="${NSPREFIX}2"
+
+readonly SADDR4='192.168.1.1'
+readonly DADDR4='192.168.1.2'
+readonly SADDR6='fd::1'
+readonly DADDR6='fd::2'
+
+cleanup() {
+	ip netns del "${NS2}"
+	ip netns del "${NS1}"
+}
+
+trap cleanup EXIT
+
+# Create virtual ethernet pair between network namespaces
+ip netns add "${NS1}"
+ip netns add "${NS2}"
+
+ip link add "${DEV}" netns "${NS1}" type veth \
+  peer name "${DEV}" netns "${NS2}"
+
+# Bring the devices up
+ip -netns "${NS1}" link set "${DEV}" up
+ip -netns "${NS2}" link set "${DEV}" up
+
+# Set fixed MAC addresses on the devices
+ip -netns "${NS1}" link set dev "${DEV}" address 02:02:02:02:02:02
+ip -netns "${NS2}" link set dev "${DEV}" address 06:06:06:06:06:06
+
+# Add fixed IP addresses to the devices
+ip -netns "${NS1}" addr add 192.168.1.1/24 dev "${DEV}"
+ip -netns "${NS2}" addr add 192.168.1.2/24 dev "${DEV}"
+ip -netns "${NS1}" addr add       fd::1/64 dev "${DEV}" nodad
+ip -netns "${NS2}" addr add       fd::2/64 dev "${DEV}" nodad
+
+do_test() {
+	local readonly IP="$1"
+	local readonly CLOCK="$2"
+	local readonly TXARGS="$3"
+	local readonly RXARGS="$4"
+
+	if [[ "${IP}" == "4" ]]; then
+		local readonly SADDR="${SADDR4}"
+		local readonly DADDR="${DADDR4}"
+	elif [[ "${IP}" == "6" ]]; then
+		local readonly SADDR="${SADDR6}"
+		local readonly DADDR="${DADDR6}"
+	else
+		echo "Invalid IP version ${IP}"
+		exit 1
 	fi
 
-	exit $?
-fi
+	local readonly START="$(date +%s%N --date="+ 0.1 seconds")"
+	ip netns exec "${NS2}" "${BIN}" -"${IP}" -c "${CLOCK}" -t "${START}" -S "${SADDR}" -D "${DADDR}" "${RXARGS}" -r &
+	ip netns exec "${NS1}" "${BIN}" -"${IP}" -c "${CLOCK}" -t "${START}" -S "${SADDR}" -D "${DADDR}" "${TXARGS}"
+	wait "$!"
+}
 
-set -e
+ip netns exec "${NS1}" tc qdisc add dev "${DEV}" root fq
+do_test 4 mono a,-1 a,-1
+do_test 6 mono a,0 a,0
+do_test 6 mono a,10 a,10
+do_test 4 mono a,10,b,20 a,10,b,20
+do_test 6 mono a,20,b,10 b,20,a,20
 
-tc qdisc add dev lo root fq
-./so_txtime -4 -6 -c mono a,-1 a,-1
-./so_txtime -4 -6 -c mono a,0 a,0
-./so_txtime -4 -6 -c mono a,10 a,10
-./so_txtime -4 -6 -c mono a,10,b,20 a,10,b,20
-./so_txtime -4 -6 -c mono a,20,b,10 b,20,a,20
-
-if tc qdisc replace dev lo root etf clockid CLOCK_TAI delta 400000; then
-	! ./so_txtime -4 -6 -c tai a,-1 a,-1
-	! ./so_txtime -4 -6 -c tai a,0 a,0
-	./so_txtime -4 -6 -c tai a,10 a,10
-	./so_txtime -4 -6 -c tai a,10,b,20 a,10,b,20
-	./so_txtime -4 -6 -c tai a,20,b,10 b,10,a,20
+if ip netns exec "${NS1}" tc qdisc replace dev "${DEV}" root etf clockid CLOCK_TAI delta 400000; then
+	! do_test 4 tai a,-1 a,-1
+	! do_test 6 tai a,0 a,0
+	do_test 6 tai a,10 a,10
+	do_test 4 tai a,10,b,20 a,10,b,20
+	do_test 6 tai a,20,b,10 b,10,a,20
 else
 	echo "tc ($(tc -V)) does not support qdisc etf. skipping"
 fi
-- 
2.31.0.291.g576ba9dcdaf-goog

