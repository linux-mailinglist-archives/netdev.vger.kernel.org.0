Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD00C28D725
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgJMXqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:46:15 -0400
Received: from correo.us.es ([193.147.175.20]:59888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729991AbgJMXqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:46:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5077AE4B99
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B412DA791
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 30CD5DA730; Wed, 14 Oct 2020 01:46:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73988DA730;
        Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4902342EFB80;
        Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/4] selftests: netfilter: extend nfqueue test case
Date:   Wed, 14 Oct 2020 01:45:56 +0200
Message-Id: <20201013234559.15113-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201013234559.15113-1-pablo@netfilter.org>
References: <20201013234559.15113-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

add a test with re-queueing: usespace doesn't pass accept verdict,
but tells to re-queue to another nf_queue instance.

Also, make the second nf-queue program use non-gso mode, kernel will
have to perform software segmentation.

Lastly, do not queue every packet, just one per second, and add delay
when re-injecting the packet to the kernel.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nf-queue.c  | 61 +++++++++++++---
 .../testing/selftests/netfilter/nft_queue.sh  | 70 +++++++++++++++----
 2 files changed, 109 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nf-queue.c b/tools/testing/selftests/netfilter/nf-queue.c
index 29c73bce38fa..9e56b9d47037 100644
--- a/tools/testing/selftests/netfilter/nf-queue.c
+++ b/tools/testing/selftests/netfilter/nf-queue.c
@@ -17,9 +17,12 @@
 
 struct options {
 	bool count_packets;
+	bool gso_enabled;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
+	uint32_t verdict;
+	uint32_t delay_ms;
 };
 
 static unsigned int queue_stats[5];
@@ -27,7 +30,7 @@ static struct options opts;
 
 static void help(const char *p)
 {
-	printf("Usage: %s [-c|-v [-vv] ] [-t timeout] [-q queue_num]\n", p);
+	printf("Usage: %s [-c|-v [-vv] ] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -162,7 +165,7 @@ nfq_build_cfg_params(char *buf, uint8_t mode, int range, int queue_num)
 }
 
 static struct nlmsghdr *
-nfq_build_verdict(char *buf, int id, int queue_num, int verd)
+nfq_build_verdict(char *buf, int id, int queue_num, uint32_t verd)
 {
 	struct nfqnl_msg_verdict_hdr vh = {
 		.verdict = htonl(verd),
@@ -189,9 +192,6 @@ static void print_stats(void)
 	unsigned int last, total;
 	int i;
 
-	if (!opts.count_packets)
-		return;
-
 	total = 0;
 	last = queue_stats[0];
 
@@ -234,7 +234,8 @@ struct mnl_socket *open_queue(void)
 
 	nlh = nfq_build_cfg_params(buf, NFQNL_COPY_PACKET, 0xFFFF, queue_num);
 
-	flags = NFQA_CFG_F_GSO | NFQA_CFG_F_UID_GID;
+	flags = opts.gso_enabled ? NFQA_CFG_F_GSO : 0;
+	flags |= NFQA_CFG_F_UID_GID;
 	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
 	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
 
@@ -255,6 +256,17 @@ struct mnl_socket *open_queue(void)
 	return nl;
 }
 
+static void sleep_ms(uint32_t delay)
+{
+	struct timespec ts = { .tv_sec = delay / 1000 };
+
+	delay %= 1000;
+
+	ts.tv_nsec = delay * 1000llu * 1000llu;
+
+	nanosleep(&ts, NULL);
+}
+
 static int mainloop(void)
 {
 	unsigned int buflen = 64 * 1024 + MNL_SOCKET_BUFFER_SIZE;
@@ -278,7 +290,7 @@ static int mainloop(void)
 
 		ret = mnl_socket_recvfrom(nl, buf, buflen);
 		if (ret == -1) {
-			if (errno == ENOBUFS)
+			if (errno == ENOBUFS || errno == EINTR)
 				continue;
 
 			if (errno == EAGAIN) {
@@ -298,7 +310,10 @@ static int mainloop(void)
 		}
 
 		id = ret - MNL_CB_OK;
-		nlh = nfq_build_verdict(buf, id, opts.queue_num, NF_ACCEPT);
+		if (opts.delay_ms)
+			sleep_ms(opts.delay_ms);
+
+		nlh = nfq_build_verdict(buf, id, opts.queue_num, opts.verdict);
 		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
 			perror("mnl_socket_sendto");
 			exit(EXIT_FAILURE);
@@ -314,7 +329,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvt:q:")) != -1) {
+	while ((c = getopt(argc, argv, "chvt:q:Q:d:G")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -328,20 +343,48 @@ static void parse_opts(int argc, char **argv)
 			if (opts.queue_num > 0xffff)
 				opts.queue_num = 0;
 			break;
+		case 'Q':
+			opts.verdict = atoi(optarg);
+			if (opts.verdict > 0xffff) {
+				fprintf(stderr, "Expected destination queue number\n");
+				exit(1);
+			}
+
+			opts.verdict <<= 16;
+			opts.verdict |= NF_QUEUE;
+			break;
+		case 'd':
+			opts.delay_ms = atoi(optarg);
+			if (opts.delay_ms == 0) {
+				fprintf(stderr, "Expected nonzero delay (in milliseconds)\n");
+				exit(1);
+			}
+			break;
 		case 't':
 			opts.timeout = atoi(optarg);
 			break;
+		case 'G':
+			opts.gso_enabled = false;
+			break;
 		case 'v':
 			opts.verbose++;
 			break;
 		}
 	}
+
+	if (opts.verdict != NF_ACCEPT && (opts.verdict >> 16 == opts.queue_num)) {
+		fprintf(stderr, "Cannot use same destination and source queue\n");
+		exit(1);
+	}
 }
 
 int main(int argc, char *argv[])
 {
 	int ret;
 
+	opts.verdict = NF_ACCEPT;
+	opts.gso_enabled = true;
+
 	parse_opts(argc, argv);
 
 	ret = mainloop();
diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
index 6898448b4266..3d202b90b33d 100755
--- a/tools/testing/selftests/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -12,6 +12,7 @@ sfx=$(mktemp -u "XXXXXXXX")
 ns1="ns1-$sfx"
 ns2="ns2-$sfx"
 nsrouter="nsrouter-$sfx"
+timeout=4
 
 cleanup()
 {
@@ -20,6 +21,7 @@ cleanup()
 	ip netns del ${nsrouter}
 	rm -f "$TMPFILE0"
 	rm -f "$TMPFILE1"
+	rm -f "$TMPFILE2" "$TMPFILE3"
 }
 
 nft --version > /dev/null 2>&1
@@ -42,6 +44,8 @@ fi
 
 TMPFILE0=$(mktemp)
 TMPFILE1=$(mktemp)
+TMPFILE2=$(mktemp)
+TMPFILE3=$(mktemp)
 trap cleanup EXIT
 
 ip netns add ${ns1}
@@ -83,7 +87,7 @@ load_ruleset() {
 	local name=$1
 	local prio=$2
 
-ip netns exec ${nsrouter} nft -f - <<EOF
+ip netns exec ${nsrouter} nft -f /dev/stdin <<EOF
 table inet $name {
 	chain nfq {
 		ip protocol icmp queue bypass
@@ -118,7 +122,7 @@ EOF
 load_counter_ruleset() {
 	local prio=$1
 
-ip netns exec ${nsrouter} nft -f - <<EOF
+ip netns exec ${nsrouter} nft -f /dev/stdin <<EOF
 table inet countrules {
 	chain pre {
 		type filter hook prerouting priority $prio; policy accept;
@@ -175,7 +179,7 @@ test_ping_router() {
 test_queue_blackhole() {
 	local proto=$1
 
-ip netns exec ${nsrouter} nft -f - <<EOF
+ip netns exec ${nsrouter} nft -f /dev/stdin <<EOF
 table $proto blackh {
 	chain forward {
 	type filter hook forward priority 0; policy accept;
@@ -184,10 +188,10 @@ table $proto blackh {
 }
 EOF
 	if [ $proto = "ip" ] ;then
-		ip netns exec ${ns1} ping -c 1 -q 10.0.2.99 > /dev/null
+		ip netns exec ${ns1} ping -W 2 -c 1 -q 10.0.2.99 > /dev/null
 		lret=$?
 	elif [ $proto = "ip6" ]; then
-		ip netns exec ${ns1} ping -c 1 -q dead:2::99 > /dev/null
+		ip netns exec ${ns1} ping -W 2 -c 1 -q dead:2::99 > /dev/null
 		lret=$?
 	else
 		lret=111
@@ -214,8 +218,8 @@ test_queue()
 	local last=""
 
 	# spawn nf-queue listeners
-	ip netns exec ${nsrouter} ./nf-queue -c -q 0 -t 3 > "$TMPFILE0" &
-	ip netns exec ${nsrouter} ./nf-queue -c -q 1 -t 3 > "$TMPFILE1" &
+	ip netns exec ${nsrouter} ./nf-queue -c -q 0 -t $timeout > "$TMPFILE0" &
+	ip netns exec ${nsrouter} ./nf-queue -c -q 1 -t $timeout > "$TMPFILE1" &
 	sleep 1
 	test_ping
 	ret=$?
@@ -250,11 +254,11 @@ test_queue()
 
 test_tcp_forward()
 {
-	ip netns exec ${nsrouter} ./nf-queue -q 2 -t 10 &
+	ip netns exec ${nsrouter} ./nf-queue -q 2 -t $timeout &
 	local nfqpid=$!
 
 	tmpfile=$(mktemp) || exit 1
-	dd conv=sparse status=none if=/dev/zero bs=1M count=100 of=$tmpfile
+	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
 	ip netns exec ${ns2} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
 	local rpid=$!
 
@@ -270,15 +274,13 @@ test_tcp_forward()
 
 test_tcp_localhost()
 {
-	tc -net "${nsrouter}" qdisc add dev lo root netem loss random 1%
-
 	tmpfile=$(mktemp) || exit 1
 
-	dd conv=sparse status=none if=/dev/zero bs=1M count=900 of=$tmpfile
+	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
 	ip netns exec ${nsrouter} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
 	local rpid=$!
 
-	ip netns exec ${nsrouter} ./nf-queue -q 3 -t 30 &
+	ip netns exec ${nsrouter} ./nf-queue -q 3 -t $timeout &
 	local nfqpid=$!
 
 	sleep 1
@@ -287,6 +289,47 @@ test_tcp_localhost()
 
 	wait $rpid
 	[ $? -eq 0 ] && echo "PASS: tcp via loopback"
+	wait 2>/dev/null
+}
+
+test_tcp_localhost_requeue()
+{
+ip netns exec ${nsrouter} nft -f /dev/stdin <<EOF
+flush ruleset
+table inet filter {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		tcp dport 12345 limit rate 1/second burst 1 packets counter queue num 0
+	}
+	chain post {
+		type filter hook postrouting priority 0; policy accept;
+		tcp dport 12345 limit rate 1/second burst 1 packets counter queue num 0
+	}
+}
+EOF
+	tmpfile=$(mktemp) || exit 1
+	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
+	ip netns exec ${nsrouter} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	local rpid=$!
+
+	ip netns exec ${nsrouter} ./nf-queue -c -q 1 -t $timeout > "$TMPFILE2" &
+
+	# nfqueue 1 will be called via output hook.  But this time,
+        # re-queue the packet to nfqueue program on queue 2.
+	ip netns exec ${nsrouter} ./nf-queue -G -d 150 -c -q 0 -Q 1 -t $timeout > "$TMPFILE3" &
+
+	sleep 1
+	ip netns exec ${nsrouter} nc -w 5 127.0.0.1 12345 <"$tmpfile" > /dev/null
+	rm -f "$tmpfile"
+
+	wait
+
+	if ! diff -u "$TMPFILE2" "$TMPFILE3" ; then
+		echo "FAIL: lost packets during requeue?!" 1>&2
+		return
+	fi
+
+	echo "PASS: tcp via loopback and re-queueing"
 }
 
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -328,5 +371,6 @@ test_queue 20
 
 test_tcp_forward
 test_tcp_localhost
+test_tcp_localhost_requeue
 
 exit $ret
-- 
2.20.1

