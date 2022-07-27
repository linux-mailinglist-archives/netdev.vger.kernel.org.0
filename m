Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C79C5821B0
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiG0IBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiG0IBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:01:14 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1A9422E8;
        Wed, 27 Jul 2022 01:01:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VKa60au_1658908862;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VKa60au_1658908862)
          by smtp.aliyun-inc.com;
          Wed, 27 Jul 2022 16:01:02 +0800
Date:   Wed, 27 Jul 2022 16:01:01 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v5 27/27] selftests/io_uring: test zerocopy send
Message-ID: <20220727080101.GA14576@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <cover.1657643355.git.asml.silence@gmail.com>
 <03d5ec78061cf52db420f88ed0b48eb8f47ce9f7.1657643355.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03d5ec78061cf52db420f88ed0b48eb8f47ce9f7.1657643355.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:52:51PM +0100, Pavel Begunkov wrote:
>Add selftests for io_uring zerocopy sends and io_uring's notification
>infrastructure. It's largely influenced by msg_zerocopy and uses it on
>the receive side.
>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>---
> tools/testing/selftests/net/Makefile          |   1 +
> .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
> .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
> 3 files changed, 737 insertions(+)
> create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
> create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh
>
>diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
>index 7ea54af55490..51261483744e 100644
>--- a/tools/testing/selftests/net/Makefile
>+++ b/tools/testing/selftests/net/Makefile
>@@ -59,6 +59,7 @@ TEST_GEN_FILES += toeplitz
> TEST_GEN_FILES += cmsg_sender
> TEST_GEN_FILES += stress_reuseport_listen
> TEST_PROGS += test_vxlan_vnifiltering.sh
>+TEST_GEN_FILES += io_uring_zerocopy_tx
> 
> TEST_FILES := settings
> 
>diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
>new file mode 100644
>index 000000000000..9d64c560a2d6
>--- /dev/null
>+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
>@@ -0,0 +1,605 @@
>+/* SPDX-License-Identifier: MIT */
>+/* based on linux-kernel/tools/testing/selftests/net/msg_zerocopy.c */
>+#include <assert.h>
>+#include <errno.h>
>+#include <error.h>
>+#include <fcntl.h>
>+#include <limits.h>
>+#include <stdbool.h>
>+#include <stdint.h>
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <unistd.h>
>+
>+#include <arpa/inet.h>
>+#include <linux/errqueue.h>
>+#include <linux/if_packet.h>
>+#include <linux/io_uring.h>
>+#include <linux/ipv6.h>
>+#include <linux/socket.h>
>+#include <linux/sockios.h>
>+#include <net/ethernet.h>
>+#include <net/if.h>
>+#include <netinet/in.h>
>+#include <netinet/ip.h>
>+#include <netinet/ip6.h>
>+#include <netinet/tcp.h>
>+#include <netinet/udp.h>
>+#include <sys/ioctl.h>
>+#include <sys/mman.h>
>+#include <sys/resource.h>
>+#include <sys/socket.h>
>+#include <sys/stat.h>
>+#include <sys/time.h>
>+#include <sys/types.h>
>+#include <sys/un.h>
>+#include <sys/wait.h>
>+
>+#define NOTIF_TAG 0xfffffffULL
>+#define NONZC_TAG 0
>+#define ZC_TAG 1
>+

<...>

>+static void do_test(int domain, int type, int protocol)
>+{
>+	int i;
>+
>+	for (i = 0; i < IP_MAXPACKET; i++)
>+		payload[i] = 'a' + (i % 26);
>+	do_tx(domain, type, protocol);
>+}
>+
>+static void usage(const char *filepath)
>+{
>+	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
>+		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);

A small flaw, the usage here doesn't match the real options in parse_opts().

Thanks

>+}
>+
>+static void parse_opts(int argc, char **argv)
>+{
>+	const int max_payload_len = sizeof(payload) -
>+				    sizeof(struct ipv6hdr) -
>+				    sizeof(struct tcphdr) -
>+				    40 /* max tcp options */;
>+	struct sockaddr_in6 *addr6 = (void *) &cfg_dst_addr;
>+	struct sockaddr_in *addr4 = (void *) &cfg_dst_addr;
>+	char *daddr = NULL;
>+	int c;
>+
>+	if (argc <= 1)
>+		usage(argv[0]);
>+	cfg_payload_len = max_payload_len;
>+
>+	while ((c = getopt(argc, argv, "46D:p:s:t:n:fc:m:")) != -1) {
>+		switch (c) {
>+		case '4':
>+			if (cfg_family != PF_UNSPEC)
>+				error(1, 0, "Pass one of -4 or -6");
>+			cfg_family = PF_INET;
>+			cfg_alen = sizeof(struct sockaddr_in);
>+			break;
>+		case '6':
>+			if (cfg_family != PF_UNSPEC)
>+				error(1, 0, "Pass one of -4 or -6");
>+			cfg_family = PF_INET6;
>+			cfg_alen = sizeof(struct sockaddr_in6);
>+			break;
>+		case 'D':
>+			daddr = optarg;
>+			break;
>+		case 'p':
>+			cfg_port = strtoul(optarg, NULL, 0);
>+			break;
>+		case 's':
>+			cfg_payload_len = strtoul(optarg, NULL, 0);
>+			break;
>+		case 't':
>+			cfg_runtime_ms = 200 + strtoul(optarg, NULL, 10) * 1000;
>+			break;
>+		case 'n':
>+			cfg_nr_reqs = strtoul(optarg, NULL, 0);
>+			break;
>+		case 'f':
>+			cfg_flush = 1;
>+			break;
>+		case 'c':
>+			cfg_cork = strtol(optarg, NULL, 0);
>+			break;
>+		case 'm':
>+			cfg_mode = strtol(optarg, NULL, 0);
>+			break;
>+		}
>+	}
>+
>+	switch (cfg_family) {
>+	case PF_INET:
>+		memset(addr4, 0, sizeof(*addr4));
>+		addr4->sin_family = AF_INET;
>+		addr4->sin_port = htons(cfg_port);
>+		if (daddr &&
>+		    inet_pton(AF_INET, daddr, &(addr4->sin_addr)) != 1)
>+			error(1, 0, "ipv4 parse error: %s", daddr);
>+		break;
>+	case PF_INET6:
>+		memset(addr6, 0, sizeof(*addr6));
>+		addr6->sin6_family = AF_INET6;
>+		addr6->sin6_port = htons(cfg_port);
>+		if (daddr &&
>+		    inet_pton(AF_INET6, daddr, &(addr6->sin6_addr)) != 1)
>+			error(1, 0, "ipv6 parse error: %s", daddr);
>+		break;
>+	default:
>+		error(1, 0, "illegal domain");
>+	}
>+
>+	if (cfg_payload_len > max_payload_len)
>+		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
>+	if (cfg_mode == MODE_NONZC && cfg_flush)
>+		error(1, 0, "-f: only zerocopy modes support notifications");
>+	if (optind != argc - 1)
>+		usage(argv[0]);
>+}
>+
>+int main(int argc, char **argv)
>+{
>+	const char *cfg_test = argv[argc - 1];
>+
>+	parse_opts(argc, argv);
>+
>+	if (!strcmp(cfg_test, "tcp"))
>+		do_test(cfg_family, SOCK_STREAM, 0);
>+	else if (!strcmp(cfg_test, "udp"))
>+		do_test(cfg_family, SOCK_DGRAM, 0);
>+	else
>+		error(1, 0, "unknown cfg_test %s", cfg_test);
>+	return 0;
>+}
>diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
>new file mode 100755
>index 000000000000..6a65e4437640
>--- /dev/null
>+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
>@@ -0,0 +1,131 @@
>+#!/bin/bash
>+#
>+# Send data between two processes across namespaces
>+# Run twice: once without and once with zerocopy
>+
>+set -e
>+
>+readonly DEV="veth0"
>+readonly DEV_MTU=65535
>+readonly BIN_TX="./io_uring_zerocopy_tx"
>+readonly BIN_RX="./msg_zerocopy"
>+
>+readonly RAND="$(mktemp -u XXXXXX)"
>+readonly NSPREFIX="ns-${RAND}"
>+readonly NS1="${NSPREFIX}1"
>+readonly NS2="${NSPREFIX}2"
>+
>+readonly SADDR4='192.168.1.1'
>+readonly DADDR4='192.168.1.2'
>+readonly SADDR6='fd::1'
>+readonly DADDR6='fd::2'
>+
>+readonly path_sysctl_mem="net.core.optmem_max"
>+
>+# No arguments: automated test
>+if [[ "$#" -eq "0" ]]; then
>+	IPs=( "4" "6" )
>+	protocols=( "tcp" "udp" )
>+
>+	for IP in "${IPs[@]}"; do
>+		for proto in "${protocols[@]}"; do
>+			for mode in $(seq 1 3); do
>+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32
>+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -f
>+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -c -f
>+			done
>+		done
>+	done
>+
>+	echo "OK. All tests passed"
>+	exit 0
>+fi
>+
>+# Argument parsing
>+if [[ "$#" -lt "2" ]]; then
>+	echo "Usage: $0 [4|6] [tcp|udp|raw|raw_hdrincl|packet|packet_dgram] <args>"
>+	exit 1
>+fi
>+
>+readonly IP="$1"
>+shift
>+readonly TXMODE="$1"
>+shift
>+readonly EXTRA_ARGS="$@"
>+
>+# Argument parsing: configure addresses
>+if [[ "${IP}" == "4" ]]; then
>+	readonly SADDR="${SADDR4}"
>+	readonly DADDR="${DADDR4}"
>+elif [[ "${IP}" == "6" ]]; then
>+	readonly SADDR="${SADDR6}"
>+	readonly DADDR="${DADDR6}"
>+else
>+	echo "Invalid IP version ${IP}"
>+	exit 1
>+fi
>+
>+# Argument parsing: select receive mode
>+#
>+# This differs from send mode for
>+# - packet:	use raw recv, because packet receives skb clones
>+# - raw_hdrinc: use raw recv, because hdrincl is a tx-only option
>+case "${TXMODE}" in
>+'packet' | 'packet_dgram' | 'raw_hdrincl')
>+	RXMODE='raw'
>+	;;
>+*)
>+	RXMODE="${TXMODE}"
>+	;;
>+esac
>+
>+# Start of state changes: install cleanup handler
>+save_sysctl_mem="$(sysctl -n ${path_sysctl_mem})"
>+
>+cleanup() {
>+	ip netns del "${NS2}"
>+	ip netns del "${NS1}"
>+	sysctl -w -q "${path_sysctl_mem}=${save_sysctl_mem}"
>+}
>+
>+trap cleanup EXIT
>+
>+# Configure system settings
>+sysctl -w -q "${path_sysctl_mem}=1000000"
>+
>+# Create virtual ethernet pair between network namespaces
>+ip netns add "${NS1}"
>+ip netns add "${NS2}"
>+
>+ip link add "${DEV}" mtu "${DEV_MTU}" netns "${NS1}" type veth \
>+  peer name "${DEV}" mtu "${DEV_MTU}" netns "${NS2}"
>+
>+# Bring the devices up
>+ip -netns "${NS1}" link set "${DEV}" up
>+ip -netns "${NS2}" link set "${DEV}" up
>+
>+# Set fixed MAC addresses on the devices
>+ip -netns "${NS1}" link set dev "${DEV}" address 02:02:02:02:02:02
>+ip -netns "${NS2}" link set dev "${DEV}" address 06:06:06:06:06:06
>+
>+# Add fixed IP addresses to the devices
>+ip -netns "${NS1}" addr add 192.168.1.1/24 dev "${DEV}"
>+ip -netns "${NS2}" addr add 192.168.1.2/24 dev "${DEV}"
>+ip -netns "${NS1}" addr add       fd::1/64 dev "${DEV}" nodad
>+ip -netns "${NS2}" addr add       fd::2/64 dev "${DEV}" nodad
>+
>+# Optionally disable sg or csum offload to test edge cases
>+# ip netns exec "${NS1}" ethtool -K "${DEV}" sg off
>+
>+do_test() {
>+	local readonly ARGS="$1"
>+
>+	echo "ipv${IP} ${TXMODE} ${ARGS}"
>+	ip netns exec "${NS2}" "${BIN_RX}" "-${IP}" -t 2 -C 2 -S "${SADDR}" -D "${DADDR}" -r "${RXMODE}" &
>+	sleep 0.2
>+	ip netns exec "${NS1}" "${BIN_TX}" "-${IP}" -t 1 -D "${DADDR}" ${ARGS} "${TXMODE}"
>+	wait
>+}
>+
>+do_test "${EXTRA_ARGS}"
>+echo ok
>-- 
>2.37.0
