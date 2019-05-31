Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FADA31420
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEaRsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:48:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51136 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfEaRsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:48:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VHd8XK099075;
        Fri, 31 May 2019 17:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=TYsNgD+8v8DbhvYQUarwmzQz+TlBLMAkbaKMREd2OF4=;
 b=0ne8wdBgqsB/i07dK7TJeWr0pOxn9lvrUq/1INPRbkSRkoIW7RZYI3l04M6u/Q0egSaW
 yeo7pN85MquOb/yl8QPeaFPIuFwpOdiWzRUkNZ17RMRrK6jHnu8mKlw8Aw0egM7q8HrP
 iAv20qUAMojkT38FgjNuIyhw/I28O4UBLKk1Vs4DlvHrw2+TVAMyfv/XTs6+BAvJQ4jq
 P12JeMNKWzfm7TqVNDO7/kL1l3jRRX6I9U6i9OuSmVfTxyEhVuqUlXTdR2FJsSZT/g1T
 ZELfm3O5KX9j0lmivZI+xuPuL3HzZUskS9xfJ1lYYceuuuEENF5efbsuAs9YBB64RgCj Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2spu7e04gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 17:47:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VHk7BH072191;
        Fri, 31 May 2019 17:47:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sr31wjtka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 17:47:25 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4VHlMJp001843;
        Fri, 31 May 2019 17:47:22 GMT
Received: from dhcp-10-175-206-186.vpn.oracle.com (/10.175.206.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 May 2019 10:47:22 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        songliubraving@fb.com
Cc:     shuah@kernel.org, kafai@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next v5] selftests/bpf: measure RTT from xdp using xdping
Date:   Fri, 31 May 2019 18:47:14 +0100
Message-Id: <1559324834-30570-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905310108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905310108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdping allows us to get latency estimates from XDP.  Output looks
like this:

./xdping -I eth4 192.168.55.8
Setting up XDP for eth4, please wait...
XDP setup disrupts network connectivity, hit Ctrl+C to quit

Normal ping RTT data
[Ignore final RTT; it is distorted by XDP using the reply]
PING 192.168.55.8 (192.168.55.8) from 192.168.55.7 eth4: 56(84) bytes of data.
64 bytes from 192.168.55.8: icmp_seq=1 ttl=64 time=0.302 ms
64 bytes from 192.168.55.8: icmp_seq=2 ttl=64 time=0.208 ms
64 bytes from 192.168.55.8: icmp_seq=3 ttl=64 time=0.163 ms
64 bytes from 192.168.55.8: icmp_seq=8 ttl=64 time=0.275 ms

4 packets transmitted, 4 received, 0% packet loss, time 3079ms
rtt min/avg/max/mdev = 0.163/0.237/0.302/0.054 ms

XDP RTT data:
64 bytes from 192.168.55.8: icmp_seq=5 ttl=64 time=0.02808 ms
64 bytes from 192.168.55.8: icmp_seq=6 ttl=64 time=0.02804 ms
64 bytes from 192.168.55.8: icmp_seq=7 ttl=64 time=0.02815 ms
64 bytes from 192.168.55.8: icmp_seq=8 ttl=64 time=0.02805 ms

The xdping program loads the associated xdping_kern.o BPF program
and attaches it to the specified interface.  If run in client
mode (the default), it will add a map entry keyed by the
target IP address; this map will store RTT measurements, current
sequence number etc.  Finally in client mode the ping command
is executed, and the xdping BPF program will use the last ICMP
reply, reformulate it as an ICMP request with the next sequence
number and XDP_TX it.  After the reply to that request is received
we can measure RTT and repeat until the desired number of
measurements is made.  This is why the sequence numbers in the
normal ping are 1, 2, 3 and 8.  We XDP_TX a modified version
of ICMP reply 4 and keep doing this until we get the 4 replies
we need; hence the networking stack only sees reply 8, where
we have XDP_PASSed it upstream since we are done.

In server mode (-s), xdping simply takes ICMP requests and replies
to them in XDP rather than passing the request up to the networking
stack.  No map entry is required.

xdping can be run in native XDP mode (the default, or specified
via -N) or in skb mode (-S).

A test program test_xdping.sh exercises some of these options.

Note that native XDP does not seem to XDP_TX for veths, hence -N
is not tested.  Looking at the code, it looks like XDP_TX is
supported so I'm not sure if that's expected.  Running xdping in
native mode for ixgbe as both client and server works fine.

Changes since v4

- close fds on cleanup (Song Liu)

Changes since v3

- fixed seq to be __be16 (Song Liu)
- fixed fd checks in xdping.c (Song Liu)

Changes since v2

- updated commit message to explain why seq number of last
  ICMP reply is 8 not 4 (Song Liu)
- updated types of seq number, raddr and eliminated csum variable
  in xdpclient/xdpserver functions as it was not needed (Song Liu)
- added XDPING_DEFAULT_COUNT definition and usage specification of
  default/max counts (Song Liu)

Changes since v1
 - moved from RFC to PATCH
 - removed unused variable in ipv4_csum() (Song Liu)
 - refactored ICMP checks into icmp_check() function called by client
   and server programs and reworked client and server programs due
   to lack of shared code (Song Liu)
 - added checks to ensure that SKB and native mode are not requested
   together (Song Liu)

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/.gitignore          |   1 +
 tools/testing/selftests/bpf/Makefile            |   5 +-
 tools/testing/selftests/bpf/progs/xdping_kern.c | 184 +++++++++++++++++
 tools/testing/selftests/bpf/test_xdping.sh      |  99 +++++++++
 tools/testing/selftests/bpf/xdping.c            | 258 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xdping.h            |  13 ++
 6 files changed, 558 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdping_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdping.sh
 create mode 100644 tools/testing/selftests/bpf/xdping.c
 create mode 100644 tools/testing/selftests/bpf/xdping.h

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index b2a9902..7470327 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -38,3 +38,4 @@ libbpf.pc
 libbpf.so.*
 test_hashmap
 test_btf_dump
+xdping
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 9b21391..2b426ae 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach
+	test_btf_dump test_cgroup_attach xdping
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -57,7 +57,8 @@ TEST_PROGS := test_kmod.sh \
 	test_lwt_ip_encap.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
-	test_tc_edt.sh
+	test_tc_edt.sh \
+	test_xdping.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/progs/xdping_kern.c b/tools/testing/selftests/bpf/progs/xdping_kern.c
new file mode 100644
index 0000000..87393e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdping_kern.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#define KBUILD_MODNAME "foo"
+#include <stddef.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/icmp.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+
+#include "bpf_helpers.h"
+#include "bpf_endian.h"
+
+#include "xdping.h"
+
+struct bpf_map_def SEC("maps") ping_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(struct pinginfo),
+	.max_entries = 256,
+};
+
+static __always_inline void swap_src_dst_mac(void *data)
+{
+	unsigned short *p = data;
+	unsigned short dst[3];
+
+	dst[0] = p[0];
+	dst[1] = p[1];
+	dst[2] = p[2];
+	p[0] = p[3];
+	p[1] = p[4];
+	p[2] = p[5];
+	p[3] = dst[0];
+	p[4] = dst[1];
+	p[5] = dst[2];
+}
+
+static __always_inline __u16 csum_fold_helper(__wsum sum)
+{
+	sum = (sum & 0xffff) + (sum >> 16);
+	return ~((sum & 0xffff) + (sum >> 16));
+}
+
+static __always_inline __u16 ipv4_csum(void *data_start, int data_size)
+{
+	__wsum sum;
+
+	sum = bpf_csum_diff(0, 0, data_start, data_size, 0);
+	return csum_fold_helper(sum);
+}
+
+#define ICMP_ECHO_LEN		64
+
+static __always_inline int icmp_check(struct xdp_md *ctx, int type)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+
+	if (data + sizeof(*eth) + sizeof(*iph) + ICMP_ECHO_LEN > data_end)
+		return XDP_PASS;
+
+	if (eth->h_proto != bpf_htons(ETH_P_IP))
+		return XDP_PASS;
+
+	iph = data + sizeof(*eth);
+
+	if (iph->protocol != IPPROTO_ICMP)
+		return XDP_PASS;
+
+	if (bpf_ntohs(iph->tot_len) - sizeof(*iph) != ICMP_ECHO_LEN)
+		return XDP_PASS;
+
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+
+	if (icmph->type != type)
+		return XDP_PASS;
+
+	return XDP_TX;
+}
+
+SEC("xdpclient")
+int xdping_client(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct pinginfo *pinginfo = NULL;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+	__u64 recvtime;
+	__be32 raddr;
+	__be16 seq;
+	int ret;
+	__u8 i;
+
+	ret = icmp_check(ctx, ICMP_ECHOREPLY);
+
+	if (ret != XDP_TX)
+		return ret;
+
+	iph = data + sizeof(*eth);
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+	raddr = iph->saddr;
+
+	/* Record time reply received. */
+	recvtime = bpf_ktime_get_ns();
+	pinginfo = bpf_map_lookup_elem(&ping_map, &raddr);
+	if (!pinginfo || pinginfo->seq != icmph->un.echo.sequence)
+		return XDP_PASS;
+
+	if (pinginfo->start) {
+#pragma clang loop unroll(full)
+		for (i = 0; i < XDPING_MAX_COUNT; i++) {
+			if (pinginfo->times[i] == 0)
+				break;
+		}
+		/* verifier is fussy here... */
+		if (i < XDPING_MAX_COUNT) {
+			pinginfo->times[i] = recvtime -
+					     pinginfo->start;
+			pinginfo->start = 0;
+			i++;
+		}
+		/* No more space for values? */
+		if (i == pinginfo->count || i == XDPING_MAX_COUNT)
+			return XDP_PASS;
+	}
+
+	/* Now convert reply back into echo request. */
+	swap_src_dst_mac(data);
+	iph->saddr = iph->daddr;
+	iph->daddr = raddr;
+	icmph->type = ICMP_ECHO;
+	seq = bpf_htons(bpf_ntohs(icmph->un.echo.sequence) + 1);
+	icmph->un.echo.sequence = seq;
+	icmph->checksum = 0;
+	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
+
+	pinginfo->seq = seq;
+	pinginfo->start = bpf_ktime_get_ns();
+
+	return XDP_TX;
+}
+
+SEC("xdpserver")
+int xdping_server(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+	__be32 raddr;
+	int ret;
+
+	ret = icmp_check(ctx, ICMP_ECHO);
+
+	if (ret != XDP_TX)
+		return ret;
+
+	iph = data + sizeof(*eth);
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+	raddr = iph->saddr;
+
+	/* Now convert request into echo reply. */
+	swap_src_dst_mac(data);
+	iph->saddr = iph->daddr;
+	iph->daddr = raddr;
+	icmph->type = ICMP_ECHOREPLY;
+	icmph->checksum = 0;
+	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
+
+	return XDP_TX;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/selftests/bpf/test_xdping.sh
new file mode 100755
index 0000000..c2f0ddb
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdping.sh
@@ -0,0 +1,99 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# xdping tests
+#   Here we setup and teardown configuration required to run
+#   xdping, exercising its options.
+#
+#   Setup is similar to test_tunnel tests but without the tunnel.
+#
+# Topology:
+# ---------
+#     root namespace   |     tc_ns0 namespace
+#                      |
+#      ----------      |     ----------
+#      |  veth1  | --------- |  veth0  |
+#      ----------    peer    ----------
+#
+# Device Configuration
+# --------------------
+# Root namespace with BPF
+# Device names and addresses:
+#	veth1 IP: 10.1.1.200
+#	xdp added to veth1, xdpings originate from here.
+#
+# Namespace tc_ns0 with BPF
+# Device names and addresses:
+#       veth0 IPv4: 10.1.1.100
+#	For some tests xdping run in server mode here.
+#
+
+readonly TARGET_IP="10.1.1.100"
+readonly TARGET_NS="xdp_ns0"
+
+readonly LOCAL_IP="10.1.1.200"
+
+setup()
+{
+	ip netns add $TARGET_NS
+	ip link add veth0 type veth peer name veth1
+	ip link set veth0 netns $TARGET_NS
+	ip netns exec $TARGET_NS ip addr add ${TARGET_IP}/24 dev veth0
+	ip addr add ${LOCAL_IP}/24 dev veth1
+	ip netns exec $TARGET_NS ip link set veth0 up
+	ip link set veth1 up
+}
+
+cleanup()
+{
+	set +e
+	ip netns delete $TARGET_NS 2>/dev/null
+	ip link del veth1 2>/dev/null
+	if [[ $server_pid -ne 0 ]]; then
+		kill -TERM $server_pid
+	fi
+}
+
+test()
+{
+	client_args="$1"
+	server_args="$2"
+
+	echo "Test client args '$client_args'; server args '$server_args'"
+
+	server_pid=0
+	if [[ -n "$server_args" ]]; then
+		ip netns exec $TARGET_NS ./xdping $server_args &
+		server_pid=$!
+		sleep 10
+	fi
+	./xdping $client_args $TARGET_IP
+
+	if [[ $server_pid -ne 0 ]]; then
+		kill -TERM $server_pid
+		server_pid=0
+	fi
+
+	echo "Test client args '$client_args'; server args '$server_args': PASS"
+}
+
+set -e
+
+server_pid=0
+
+trap cleanup EXIT
+
+setup
+
+for server_args in "" "-I veth0 -s -S" ; do
+	# client in skb mode
+	client_args="-I veth1 -S"
+	test "$client_args" "$server_args"
+
+	# client with count of 10 RTT measurements.
+	client_args="-I veth1 -S -c 10"
+	test "$client_args" "$server_args"
+done
+
+echo "OK. All tests passed"
+exit 0
diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
new file mode 100644
index 0000000..d60a343
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <arpa/inet.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+#include <net/if.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netdb.h>
+
+#include "bpf/bpf.h"
+#include "bpf/libbpf.h"
+
+#include "xdping.h"
+
+static int ifindex;
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+static void cleanup(int sig)
+{
+	bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+	if (sig)
+		exit(1);
+}
+
+static int get_stats(int fd, __u16 count, __u32 raddr)
+{
+	struct pinginfo pinginfo = { 0 };
+	char inaddrbuf[INET_ADDRSTRLEN];
+	struct in_addr inaddr;
+	__u16 i;
+
+	inaddr.s_addr = raddr;
+
+	printf("\nXDP RTT data:\n");
+
+	if (bpf_map_lookup_elem(fd, &raddr, &pinginfo)) {
+		perror("bpf_map_lookup elem: ");
+		return 1;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (pinginfo.times[i] == 0)
+			break;
+
+		printf("64 bytes from %s: icmp_seq=%d ttl=64 time=%#.5f ms\n",
+		       inet_ntop(AF_INET, &inaddr, inaddrbuf,
+				 sizeof(inaddrbuf)),
+		       count + i + 1,
+		       (double)pinginfo.times[i]/1000000);
+	}
+
+	if (i < count) {
+		fprintf(stderr, "Expected %d samples, got %d.\n", count, i);
+		return 1;
+	}
+
+	bpf_map_delete_elem(fd, &raddr);
+
+	return 0;
+}
+
+static void show_usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] -I interface destination\n\n"
+		"OPTS:\n"
+		"    -c count		Stop after sending count requests\n"
+		"			(default %d, max %d)\n"
+		"    -I interface	interface name\n"
+		"    -N			Run in driver mode\n"
+		"    -s			Server mode\n"
+		"    -S			Run in skb mode\n",
+		prog, XDPING_DEFAULT_COUNT, XDPING_MAX_COUNT);
+}
+
+int main(int argc, char **argv)
+{
+	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
+	struct addrinfo *a, hints = { .ai_family = AF_INET };
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	__u16 count = XDPING_DEFAULT_COUNT;
+	struct pinginfo pinginfo = { 0 };
+	const char *optstr = "c:I:NsS";
+	struct bpf_program *main_prog;
+	int prog_fd = -1, map_fd = -1;
+	struct sockaddr_in rin;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	char *ifname = NULL;
+	char filename[256];
+	int opt, ret = 1;
+	__u32 raddr = 0;
+	int server = 0;
+	char cmd[256];
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		case 'c':
+			count = atoi(optarg);
+			if (count < 1 || count > XDPING_MAX_COUNT) {
+				fprintf(stderr,
+					"min count is 1, max count is %d\n",
+					XDPING_MAX_COUNT);
+				return 1;
+			}
+			break;
+		case 'I':
+			ifname = optarg;
+			ifindex = if_nametoindex(ifname);
+			if (!ifindex) {
+				fprintf(stderr, "Could not get interface %s\n",
+					ifname);
+				return 1;
+			}
+			break;
+		case 'N':
+			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			break;
+		case 's':
+			/* use server program */
+			server = 1;
+			break;
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		default:
+			show_usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!ifname) {
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+	if (!server && optind == argc) {
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+
+	if ((xdp_flags & mode_flags) == mode_flags) {
+		fprintf(stderr, "-N or -S can be specified, not both.\n");
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+
+	if (!server) {
+		/* Only supports IPv4; see hints initiailization above. */
+		if (getaddrinfo(argv[optind], NULL, &hints, &a) || !a) {
+			fprintf(stderr, "Could not resolve %s\n", argv[optind]);
+			return 1;
+		}
+		memcpy(&rin, a->ai_addr, sizeof(rin));
+		raddr = rin.sin_addr.s_addr;
+		freeaddrinfo(a);
+	}
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+
+	if (bpf_prog_load(filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd)) {
+		fprintf(stderr, "load of %s failed\n", filename);
+		return 1;
+	}
+
+	main_prog = bpf_object__find_program_by_title(obj,
+						      server ? "xdpserver" :
+							       "xdpclient");
+	if (main_prog)
+		prog_fd = bpf_program__fd(main_prog);
+	if (!main_prog || prog_fd < 0) {
+		fprintf(stderr, "could not find xdping program");
+		return 1;
+	}
+
+	map = bpf_map__next(NULL, obj);
+	if (map)
+		map_fd = bpf_map__fd(map);
+	if (!map || map_fd < 0) {
+		fprintf(stderr, "Could not find ping map");
+		goto done;
+	}
+
+	signal(SIGINT, cleanup);
+	signal(SIGTERM, cleanup);
+
+	printf("Setting up XDP for %s, please wait...\n", ifname);
+
+	printf("XDP setup disrupts network connectivity, hit Ctrl+C to quit\n");
+
+	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+		fprintf(stderr, "Link set xdp fd failed for %s\n", ifname);
+		goto done;
+	}
+
+	if (server) {
+		close(prog_fd);
+		close(map_fd);
+		printf("Running server on %s; press Ctrl+C to exit...\n",
+		       ifname);
+		do { } while (1);
+	}
+
+	/* Start xdping-ing from last regular ping reply, e.g. for a count
+	 * of 10 ICMP requests, we start xdping-ing using reply with seq number
+	 * 10.  The reason the last "real" ping RTT is much higher is that
+	 * the ping program sees the ICMP reply associated with the last
+	 * XDP-generated packet, so ping doesn't get a reply until XDP is done.
+	 */
+	pinginfo.seq = htons(count);
+	pinginfo.count = count;
+
+	if (bpf_map_update_elem(map_fd, &raddr, &pinginfo, BPF_ANY)) {
+		fprintf(stderr, "could not communicate with BPF map: %s\n",
+			strerror(errno));
+		cleanup(0);
+		goto done;
+	}
+
+	/* We need to wait for XDP setup to complete. */
+	sleep(10);
+
+	snprintf(cmd, sizeof(cmd), "ping -c %d -I %s %s",
+		 count, ifname, argv[optind]);
+
+	printf("\nNormal ping RTT data\n");
+	printf("[Ignore final RTT; it is distorted by XDP using the reply]\n");
+
+	ret = system(cmd);
+
+	if (!ret)
+		ret = get_stats(map_fd, count, raddr);
+
+	cleanup(0);
+
+done:
+	if (prog_fd > 0)
+		close(prog_fd);
+	if (map_fd > 0)
+		close(map_fd);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/bpf/xdping.h b/tools/testing/selftests/bpf/xdping.h
new file mode 100644
index 0000000..afc578d
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdping.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#define	XDPING_MAX_COUNT	10
+#define	XDPING_DEFAULT_COUNT	4
+
+struct pinginfo {
+	__u64	start;
+	__be16	seq;
+	__u16	count;
+	__u32	pad;
+	__u64	times[XDPING_MAX_COUNT];
+};
-- 
1.8.3.1

