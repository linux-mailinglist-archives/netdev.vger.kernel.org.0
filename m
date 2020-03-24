Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5C191CB5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgCXWch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:32:37 -0400
Received: from correo.us.es ([193.147.175.20]:34630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgCXWcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2AF47FB38A
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C080DA840
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:31:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11680DA7B2; Tue, 24 Mar 2020 23:31:56 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92D76DA7B6;
        Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6C10442EF42B;
        Tue, 24 Mar 2020 23:31:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/7] selftests: netfilter: add nfqueue test case
Date:   Tue, 24 Mar 2020 23:32:20 +0100
Message-Id: <20200324223220.12119-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add a test case to check nf queue infrastructure.
Could be extended in the future to also cover serialization of
conntrack, uid and secctx attributes in nfqueue.

For now, this checks that 'queue bypass' works, that a queue rule with
no bypass option blocks traffic and that userspace receives the expected
number of packets.
For this we add two queues and hook all of
prerouting/input/forward/output/postrouting.

Packets get queued twice with a dummy base chain in between:
This passes with current nf tree, but reverting
commit 946c0d8e6ed4 ("netfilter: nf_queue: fix reinject verdict handling")
makes this trip (it processes 30 instead of expected 20 packets).

v2: update config file with queue and other options missing/needed for
other tests.
v3: also test with tcp, this reveals problem with commit
28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING"), due to
skb->dev pointing at another skb in the retransmit rbtree (skb->dev
aliases to rbnode child).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile     |   6 +-
 tools/testing/selftests/netfilter/config       |   6 +
 tools/testing/selftests/netfilter/nf-queue.c   | 352 +++++++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_queue.sh | 332 +++++++++++++++++++++++
 4 files changed, 695 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/netfilter/nf-queue.c
 create mode 100755 tools/testing/selftests/netfilter/nft_queue.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 08194aa44006..9c0f758310fe 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -3,6 +3,10 @@
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
-	nft_concat_range.sh
+	nft_concat_range.sh \
+	nft_queue.sh
+
+LDLIBS = -lmnl
+TEST_GEN_FILES =  nf-queue
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/config b/tools/testing/selftests/netfilter/config
index 59caa8f71cd8..4faf2ce021d9 100644
--- a/tools/testing/selftests/netfilter/config
+++ b/tools/testing/selftests/netfilter/config
@@ -1,2 +1,8 @@
 CONFIG_NET_NS=y
 CONFIG_NF_TABLES_INET=y
+CONFIG_NFT_QUEUE=m
+CONFIG_NFT_NAT=m
+CONFIG_NFT_REDIR=m
+CONFIG_NFT_MASQ=m
+CONFIG_NFT_FLOW_OFFLOAD=m
+CONFIG_NF_CT_NETLINK=m
diff --git a/tools/testing/selftests/netfilter/nf-queue.c b/tools/testing/selftests/netfilter/nf-queue.c
new file mode 100644
index 000000000000..29c73bce38fa
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nf-queue.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+#include <arpa/inet.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+
+struct options {
+	bool count_packets;
+	int verbose;
+	unsigned int queue_num;
+	unsigned int timeout;
+};
+
+static unsigned int queue_stats[5];
+static struct options opts;
+
+static void help(const char *p)
+{
+	printf("Usage: %s [-c|-v [-vv] ] [-t timeout] [-q queue_num]\n", p);
+}
+
+static int parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	/* skip unsupported attribute in user-space */
+	if (mnl_attr_type_valid(attr, NFQA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFQA_MARK:
+	case NFQA_IFINDEX_INDEV:
+	case NFQA_IFINDEX_OUTDEV:
+	case NFQA_IFINDEX_PHYSINDEV:
+	case NFQA_IFINDEX_PHYSOUTDEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_TIMESTAMP:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfqnl_msg_packet_timestamp)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_HWADDR:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfqnl_msg_packet_hw)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_PAYLOAD:
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int queue_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[NFQA_MAX+1] = { 0 };
+	struct nfqnl_msg_packet_hdr *ph = NULL;
+	uint32_t id = 0;
+
+	(void)data;
+
+	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, tb);
+	if (tb[NFQA_PACKET_HDR]) {
+		ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
+		id = ntohl(ph->packet_id);
+
+		if (opts.verbose > 0)
+			printf("packet hook=%u, hwproto 0x%x",
+				ntohs(ph->hw_protocol), ph->hook);
+
+		if (ph->hook >= 5) {
+			fprintf(stderr, "Unknown hook %d\n", ph->hook);
+			return MNL_CB_ERROR;
+		}
+
+		if (opts.verbose > 0) {
+			uint32_t skbinfo = 0;
+
+			if (tb[NFQA_SKB_INFO])
+				skbinfo = ntohl(mnl_attr_get_u32(tb[NFQA_SKB_INFO]));
+			if (skbinfo & NFQA_SKB_CSUMNOTREADY)
+				printf(" csumnotready");
+			if (skbinfo & NFQA_SKB_GSO)
+				printf(" gso");
+			if (skbinfo & NFQA_SKB_CSUM_NOTVERIFIED)
+				printf(" csumnotverified");
+			puts("");
+		}
+
+		if (opts.count_packets)
+			queue_stats[ph->hook]++;
+	}
+
+	return MNL_CB_OK + id;
+}
+
+static struct nlmsghdr *
+nfq_build_cfg_request(char *buf, uint8_t command, int queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	struct nfqnl_msg_config_cmd cmd = {
+		.command = command,
+		.pf = htons(AF_INET),
+	};
+	struct nfgenmsg *nfg;
+
+	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nfq_build_cfg_params(char *buf, uint8_t mode, int range, int queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	struct nfqnl_msg_config_params params = {
+		.copy_range = htonl(range),
+		.copy_mode = mode,
+	};
+	struct nfgenmsg *nfg;
+
+	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nfq_build_verdict(char *buf, int id, int queue_num, int verd)
+{
+	struct nfqnl_msg_verdict_hdr vh = {
+		.verdict = htonl(verd),
+		.id = htonl(id),
+	};
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
+
+	return nlh;
+}
+
+static void print_stats(void)
+{
+	unsigned int last, total;
+	int i;
+
+	if (!opts.count_packets)
+		return;
+
+	total = 0;
+	last = queue_stats[0];
+
+	for (i = 0; i < 5; i++) {
+		printf("hook %d packets %08u\n", i, queue_stats[i]);
+		last = queue_stats[i];
+		total += last;
+	}
+
+	printf("%u packets total\n", total);
+}
+
+struct mnl_socket *open_queue(void)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	unsigned int queue_num;
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	struct timeval tv;
+	uint32_t flags;
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+
+	queue_num = opts.queue_num;
+	nlh = nfq_build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nfq_build_cfg_params(buf, NFQNL_COPY_PACKET, 0xFFFF, queue_num);
+
+	flags = NFQA_CFG_F_GSO | NFQA_CFG_F_UID_GID;
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&tv, 0, sizeof(tv));
+	tv.tv_sec = opts.timeout;
+	if (opts.timeout && setsockopt(mnl_socket_get_fd(nl),
+				       SOL_SOCKET, SO_RCVTIMEO,
+				       &tv, sizeof(tv))) {
+		perror("setsockopt(SO_RCVTIMEO)");
+		exit(EXIT_FAILURE);
+	}
+
+	return nl;
+}
+
+static int mainloop(void)
+{
+	unsigned int buflen = 64 * 1024 + MNL_SOCKET_BUFFER_SIZE;
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	unsigned int portid;
+	char *buf;
+	int ret;
+
+	buf = malloc(buflen);
+	if (!buf) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	nl = open_queue();
+	portid = mnl_socket_get_portid(nl);
+
+	for (;;) {
+		uint32_t id;
+
+		ret = mnl_socket_recvfrom(nl, buf, buflen);
+		if (ret == -1) {
+			if (errno == ENOBUFS)
+				continue;
+
+			if (errno == EAGAIN) {
+				errno = 0;
+				ret = 0;
+				break;
+			}
+
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
+		if (ret < 0) {
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		}
+
+		id = ret - MNL_CB_OK;
+		nlh = nfq_build_verdict(buf, id, opts.queue_num, NF_ACCEPT);
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_sendto");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	mnl_socket_close(nl);
+
+	return ret;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "chvt:q:")) != -1) {
+		switch (c) {
+		case 'c':
+			opts.count_packets = true;
+			break;
+		case 'h':
+			help(argv[0]);
+			exit(0);
+			break;
+		case 'q':
+			opts.queue_num = atoi(optarg);
+			if (opts.queue_num > 0xffff)
+				opts.queue_num = 0;
+			break;
+		case 't':
+			opts.timeout = atoi(optarg);
+			break;
+		case 'v':
+			opts.verbose++;
+			break;
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	parse_opts(argc, argv);
+
+	ret = mainloop();
+	if (opts.count_packets)
+		print_stats();
+
+	return ret;
+}
diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
new file mode 100755
index 000000000000..6898448b4266
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -0,0 +1,332 @@
+#!/bin/bash
+#
+# This tests nf_queue:
+# 1. can process packets from all hooks
+# 2. support running nfqueue from more than one base chain
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+nsrouter="nsrouter-$sfx"
+
+cleanup()
+{
+	ip netns del ${ns1}
+	ip netns del ${ns2}
+	ip netns del ${nsrouter}
+	rm -f "$TMPFILE0"
+	rm -f "$TMPFILE1"
+}
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ip netns add ${nsrouter}
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace"
+	exit $ksft_skip
+fi
+
+TMPFILE0=$(mktemp)
+TMPFILE1=$(mktemp)
+trap cleanup EXIT
+
+ip netns add ${ns1}
+ip netns add ${ns2}
+
+ip link add veth0 netns ${nsrouter} type veth peer name eth0 netns ${ns1} > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns ${nsrouter} type veth peer name eth0 netns ${ns2}
+
+ip -net ${nsrouter} link set lo up
+ip -net ${nsrouter} link set veth0 up
+ip -net ${nsrouter} addr add 10.0.1.1/24 dev veth0
+ip -net ${nsrouter} addr add dead:1::1/64 dev veth0
+
+ip -net ${nsrouter} link set veth1 up
+ip -net ${nsrouter} addr add 10.0.2.1/24 dev veth1
+ip -net ${nsrouter} addr add dead:2::1/64 dev veth1
+
+ip -net ${ns1} link set lo up
+ip -net ${ns1} link set eth0 up
+
+ip -net ${ns2} link set lo up
+ip -net ${ns2} link set eth0 up
+
+ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0
+ip -net ${ns1} route add default via 10.0.1.1
+ip -net ${ns1} route add default via dead:1::1
+
+ip -net ${ns2} addr add 10.0.2.99/24 dev eth0
+ip -net ${ns2} addr add dead:2::99/64 dev eth0
+ip -net ${ns2} route add default via 10.0.2.1
+ip -net ${ns2} route add default via dead:2::1
+
+load_ruleset() {
+	local name=$1
+	local prio=$2
+
+ip netns exec ${nsrouter} nft -f - <<EOF
+table inet $name {
+	chain nfq {
+		ip protocol icmp queue bypass
+		icmpv6 type { "echo-request", "echo-reply" } queue num 1 bypass
+	}
+	chain pre {
+		type filter hook prerouting priority $prio; policy accept;
+		jump nfq
+	}
+	chain input {
+		type filter hook input priority $prio; policy accept;
+		jump nfq
+	}
+	chain forward {
+		type filter hook forward priority $prio; policy accept;
+		tcp dport 12345 queue num 2
+		jump nfq
+	}
+	chain output {
+		type filter hook output priority $prio; policy accept;
+		tcp dport 12345 queue num 3
+		jump nfq
+	}
+	chain post {
+		type filter hook postrouting priority $prio; policy accept;
+		jump nfq
+	}
+}
+EOF
+}
+
+load_counter_ruleset() {
+	local prio=$1
+
+ip netns exec ${nsrouter} nft -f - <<EOF
+table inet countrules {
+	chain pre {
+		type filter hook prerouting priority $prio; policy accept;
+		counter
+	}
+	chain input {
+		type filter hook input priority $prio; policy accept;
+		counter
+	}
+	chain forward {
+		type filter hook forward priority $prio; policy accept;
+		counter
+	}
+	chain output {
+		type filter hook output priority $prio; policy accept;
+		counter
+	}
+	chain post {
+		type filter hook postrouting priority $prio; policy accept;
+		counter
+	}
+}
+EOF
+}
+
+test_ping() {
+  ip netns exec ${ns1} ping -c 1 -q 10.0.2.99 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  ip netns exec ${ns1} ping -c 1 -q dead:2::99 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  return 0
+}
+
+test_ping_router() {
+  ip netns exec ${ns1} ping -c 1 -q 10.0.2.1 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  ip netns exec ${ns1} ping -c 1 -q dead:2::1 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  return 0
+}
+
+test_queue_blackhole() {
+	local proto=$1
+
+ip netns exec ${nsrouter} nft -f - <<EOF
+table $proto blackh {
+	chain forward {
+	type filter hook forward priority 0; policy accept;
+		queue num 600
+	}
+}
+EOF
+	if [ $proto = "ip" ] ;then
+		ip netns exec ${ns1} ping -c 1 -q 10.0.2.99 > /dev/null
+		lret=$?
+	elif [ $proto = "ip6" ]; then
+		ip netns exec ${ns1} ping -c 1 -q dead:2::99 > /dev/null
+		lret=$?
+	else
+		lret=111
+	fi
+
+	# queue without bypass keyword should drop traffic if no listener exists.
+	if [ $lret -eq 0 ];then
+		echo "FAIL: $proto expected failure, got $lret" 1>&2
+		exit 1
+	fi
+
+	ip netns exec ${nsrouter} nft delete table $proto blackh
+	if [ $? -ne 0 ] ;then
+	        echo "FAIL: $proto: Could not delete blackh table"
+	        exit 1
+	fi
+
+        echo "PASS: $proto: statement with no listener results in packet drop"
+}
+
+test_queue()
+{
+	local expected=$1
+	local last=""
+
+	# spawn nf-queue listeners
+	ip netns exec ${nsrouter} ./nf-queue -c -q 0 -t 3 > "$TMPFILE0" &
+	ip netns exec ${nsrouter} ./nf-queue -c -q 1 -t 3 > "$TMPFILE1" &
+	sleep 1
+	test_ping
+	ret=$?
+	if [ $ret -ne 0 ];then
+		echo "FAIL: netns routing/connectivity with active listener on queue $queue: $ret" 1>&2
+		exit $ret
+	fi
+
+	test_ping_router
+	ret=$?
+	if [ $ret -ne 0 ];then
+		echo "FAIL: netns router unreachable listener on queue $queue: $ret" 1>&2
+		exit $ret
+	fi
+
+	wait
+	ret=$?
+
+	for file in $TMPFILE0 $TMPFILE1; do
+		last=$(tail -n1 "$file")
+		if [ x"$last" != x"$expected packets total" ]; then
+			echo "FAIL: Expected $expected packets total, but got $last" 1>&2
+			cat "$file" 1>&2
+
+			ip netns exec ${nsrouter} nft list ruleset
+			exit 1
+		fi
+	done
+
+	echo "PASS: Expected and received $last"
+}
+
+test_tcp_forward()
+{
+	ip netns exec ${nsrouter} ./nf-queue -q 2 -t 10 &
+	local nfqpid=$!
+
+	tmpfile=$(mktemp) || exit 1
+	dd conv=sparse status=none if=/dev/zero bs=1M count=100 of=$tmpfile
+	ip netns exec ${ns2} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	local rpid=$!
+
+	sleep 1
+	ip netns exec ${ns1} nc -w 5 10.0.2.99 12345 <"$tmpfile" >/dev/null &
+
+	rm -f "$tmpfile"
+
+	wait $rpid
+	wait $lpid
+	[ $? -eq 0 ] && echo "PASS: tcp and nfqueue in forward chain"
+}
+
+test_tcp_localhost()
+{
+	tc -net "${nsrouter}" qdisc add dev lo root netem loss random 1%
+
+	tmpfile=$(mktemp) || exit 1
+
+	dd conv=sparse status=none if=/dev/zero bs=1M count=900 of=$tmpfile
+	ip netns exec ${nsrouter} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	local rpid=$!
+
+	ip netns exec ${nsrouter} ./nf-queue -q 3 -t 30 &
+	local nfqpid=$!
+
+	sleep 1
+	ip netns exec ${nsrouter} nc -w 5 127.0.0.1 12345 <"$tmpfile" > /dev/null
+	rm -f "$tmpfile"
+
+	wait $rpid
+	[ $? -eq 0 ] && echo "PASS: tcp via loopback"
+}
+
+ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+load_ruleset "filter" 0
+
+sleep 3
+
+test_ping
+ret=$?
+if [ $ret -eq 0 ];then
+	# queue bypass works (rules were skipped, no listener)
+	echo "PASS: ${ns1} can reach ${ns2}"
+else
+	echo "FAIL: ${ns1} cannot reach ${ns2}: $ret" 1>&2
+	exit $ret
+fi
+
+test_queue_blackhole ip
+test_queue_blackhole ip6
+
+# dummy ruleset to add base chains between the
+# queueing rules.  We don't want the second reinject
+# to re-execute the old hooks.
+load_counter_ruleset 10
+
+# we are hooking all: prerouting/input/forward/output/postrouting.
+# we ping ${ns2} from ${ns1} via ${nsrouter} using ipv4 and ipv6, so:
+# 1x icmp prerouting,forward,postrouting -> 3 queue events (6 incl. reply).
+# 1x icmp prerouting,input,output postrouting -> 4 queue events incl. reply.
+# so we expect that userspace program receives 10 packets.
+test_queue 10
+
+# same.  We queue to a second program as well.
+load_ruleset "filter2" 20
+test_queue 20
+
+test_tcp_forward
+test_tcp_localhost
+
+exit $ret
-- 
2.11.0

