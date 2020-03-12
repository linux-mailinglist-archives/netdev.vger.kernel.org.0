Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56787183D69
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgCLXhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:37:00 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:33979 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgCLXg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:59 -0400
Received: by mail-pf1-f180.google.com with SMTP id 23so4067232pfj.1;
        Thu, 12 Mar 2020 16:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4SVXg9kxbC2Fg+hUIeLmO2FkLEfBDSulEoa9VNOcUUM=;
        b=V4zxHVBUbC3CX2AHrHwD3moMDgg1UXxwWMeh5p5iy4i1NTAb2MfGzkbf2JjBs4MFHZ
         j1fefkHDI/l4EfoR672OJ1YgT1DgyYbQC3BQUY4dxkWnjW6sk7KER4ZHGCsrccFTdjvP
         Lsr07/V0KXLvSFcsjSxn87HsjHovYR389sAhpzDlWTXZ1W5NtG7auvdutYkNO0LonoxS
         yM/nbqInqCHwDuBAmounpaai/PdnTHLJTNnT1jbBkfy56tF9270XawXCHxNdzI6gT9oN
         SWwU5UFOI3OWJvr2Ij2EkavEGI484LHeQf372gb6ahx1hPTMjsyGPxXt9kP4+3zpD84s
         7JtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=4SVXg9kxbC2Fg+hUIeLmO2FkLEfBDSulEoa9VNOcUUM=;
        b=Q51oTDzOm1bgK+6FZ3x2awDeuArAEyIZuMZBXbBELAge+YBwVFXdirxQuQpJ+PDaBH
         IAdM5q7ppvedP9o4p/JXGz1BQ0I42ykzT+6iLcFgD9Fmm4LqbX4yxdp2mGq4BvPr2Du1
         EAnqxsxGVgRTeC3WhQig25A3Xpa3J9yK9iEV0f6WKl4pG6txXJGYxi0yBABGucNZYOgd
         njKbWP6ArMqvI9gmZa2VlKIMCmnwvFtw5c92ytD3v+pFyLWy4jAAwdzkzxSo1iO5qJSS
         x4QrdJ3bY4s4cqfMdFb6zW8sjCRZmsCqtTFDqESMWf+nbm2x5moOQWU6p4jkACHFOojP
         CxEw==
X-Gm-Message-State: ANhLgQ2Ibc/7YLO3ZtmTF3PRdMXbISVlTotymAxvFVoW7EnLxhgTopH6
        XhKS5EOFLanQaYA2SpvdTKlVBfcW
X-Google-Smtp-Source: ADFU+vt0lm69YdgTi88z5Pu6HCemDOMeMdGF16ntw0Tid3JAskuSEOEAViTee1P2PwG2a5hbvM6eZg==
X-Received: by 2002:a62:2ca:: with SMTP id 193mr10581862pfc.95.1584056217346;
        Thu, 12 Mar 2020 16:36:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:56 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, eric.dumazet@gmail.com
Subject: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
Date:   Thu, 12 Mar 2020 16:36:46 -0700
Message-Id: <20200312233648.1767-6-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

Attach a tc direct-action classifier to lo in a fresh network
namespace, and rewrite all connection attempts to localhost:4321
to localhost:1234.

Keep in mind that both client to server and server to client traffic
passes the classifier.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
 tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
 tools/testing/selftests/bpf/test_sk_assign.sh |  19 ++
 5 files changed, 325 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/test_sk_assign.c
 create mode 100755 tools/testing/selftests/bpf/test_sk_assign.sh

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index ec464859c6b6..e9c185899def 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -28,6 +28,7 @@ test_netcnt
 test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
+test_sk_assign
 test_sysctl
 test_hashmap
 test_btf_dump
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ee4ad34adb4a..503fd9dc8cf6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -58,6 +58,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_vlan_mode_generic.sh \
 	test_xdp_vlan_mode_native.sh \
 	test_lwt_ip_encap.sh \
+	test_sk_assign.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
@@ -74,7 +75,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping test_cpp runqslower
+	test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign
 
 TEST_CUSTOM_PROGS = urandom_read
 
diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
new file mode 100644
index 000000000000..7de30ad3f594
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Cloudflare Ltd.
+
+#include <stddef.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/tcp.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
+
+/* Fill 'tuple' with L3 info, and attempt to find L4. On fail, return NULL. */
+static struct bpf_sock_tuple *get_tuple(void *data, __u64 nh_off,
+					void *data_end, __u16 eth_proto,
+					bool *ipv4)
+{
+	struct bpf_sock_tuple *result;
+	__u8 proto = 0;
+	__u64 ihl_len;
+
+	if (eth_proto == bpf_htons(ETH_P_IP)) {
+		struct iphdr *iph = (struct iphdr *)(data + nh_off);
+
+		if (iph + 1 > data_end)
+			return NULL;
+		if (iph->ihl != 5)
+			/* Options are not supported */
+			return NULL;
+		ihl_len = iph->ihl * 4;
+		proto = iph->protocol;
+		*ipv4 = true;
+		result = (struct bpf_sock_tuple *)&iph->saddr;
+	} else if (eth_proto == bpf_htons(ETH_P_IPV6)) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)(data + nh_off);
+
+		if (ip6h + 1 > data_end)
+			return NULL;
+		ihl_len = sizeof(*ip6h);
+		proto = ip6h->nexthdr;
+		*ipv4 = false;
+		result = (struct bpf_sock_tuple *)&ip6h->saddr;
+	} else {
+		return NULL;
+	}
+
+	if (result + 1 > data_end || proto != IPPROTO_TCP)
+		return NULL;
+
+	return result;
+}
+
+SEC("sk_assign_test")
+int bpf_sk_assign_test(struct __sk_buff *skb)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+	struct ethhdr *eth = (struct ethhdr *)(data);
+	struct bpf_sock_tuple *tuple, ln = {0};
+	struct bpf_sock *sk;
+	int tuple_len;
+	bool ipv4;
+	int ret;
+
+	if (eth + 1 > data_end)
+		return TC_ACT_SHOT;
+
+	tuple = get_tuple(data, sizeof(*eth), data_end, eth->h_proto, &ipv4);
+	if (!tuple)
+		return TC_ACT_SHOT;
+
+	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
+	sk = bpf_skc_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
+	if (sk) {
+		if (sk->state != BPF_TCP_LISTEN)
+			goto assign;
+
+		bpf_sk_release(sk);
+	}
+
+	if (ipv4) {
+		if (tuple->ipv4.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		ln.ipv4.daddr = bpf_htonl(0x7f000001);
+		ln.ipv4.dport = bpf_htons(1234);
+
+		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
+					BPF_F_CURRENT_NETNS, 0);
+	} else {
+		if (tuple->ipv6.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		/* Upper parts of daddr are already zero. */
+		ln.ipv6.daddr[3] = bpf_htonl(0x1);
+		ln.ipv6.dport = bpf_htons(1234);
+
+		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
+					BPF_F_CURRENT_NETNS, 0);
+	}
+
+	/* We can't do a single skc_lookup_tcp here, because then the compiler
+	 * will likely spill tuple_len to the stack. This makes it lose all
+	 * bounds information in the verifier, which then rejects the call as
+	 * unsafe.
+	 */
+	if (!sk)
+		return TC_ACT_SHOT;
+
+	if (sk->state != BPF_TCP_LISTEN) {
+		bpf_sk_release(sk);
+		return TC_ACT_SHOT;
+	}
+
+assign:
+	ret = bpf_sk_assign(skb, sk, 0);
+	bpf_sk_release(sk);
+	return ret == 0 ? TC_ACT_OK : TC_ACT_SHOT;
+}
diff --git a/tools/testing/selftests/bpf/test_sk_assign.c b/tools/testing/selftests/bpf/test_sk_assign.c
new file mode 100644
index 000000000000..cba5f8b2b7fd
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sk_assign.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Facebook
+// Copyright (c) 2019 Cloudflare
+
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+#include "cgroup_helpers.h"
+
+static int start_server(const struct sockaddr *addr, socklen_t len)
+{
+	int fd;
+
+	fd = socket(addr->sa_family, SOCK_STREAM, 0);
+	if (fd == -1) {
+		log_err("Failed to create server socket");
+		goto out;
+	}
+
+	if (bind(fd, addr, len) == -1) {
+		log_err("Failed to bind server socket");
+		goto close_out;
+	}
+
+	if (listen(fd, 128) == -1) {
+		log_err("Failed to listen on server socket");
+		goto close_out;
+	}
+
+	goto out;
+
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static int connect_to_server(const struct sockaddr *addr, socklen_t len)
+{
+	int fd = -1;
+
+	fd = socket(addr->sa_family, SOCK_STREAM, 0);
+	if (fd == -1) {
+		log_err("Failed to create client socket");
+		goto out;
+	}
+
+	if (connect(fd, addr, len) == -1) {
+		log_err("Fail to connect to server");
+		goto close_out;
+	}
+
+	goto out;
+
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static int run_test(int server_fd, const struct sockaddr *addr, socklen_t len)
+{
+	int client = -1, srv_client = -1;
+	struct sockaddr_storage name;
+	char buf[] = "testing";
+	in_port_t port;
+	int ret = 1;
+
+	client = connect_to_server(addr, len);
+	if (client == -1)
+		goto out;
+
+	srv_client = accept(server_fd, NULL, NULL);
+	if (srv_client == -1) {
+		log_err("Can't accept connection");
+		goto out;
+	}
+
+	if (write(client, buf, sizeof(buf)) != sizeof(buf)) {
+		log_err("Can't write on client");
+		goto out;
+	}
+
+	if (read(srv_client, buf, sizeof(buf)) != sizeof(buf)) {
+		log_err("Can't read on server");
+		goto out;
+	}
+
+	len = sizeof(name);
+	if (getsockname(srv_client, (struct sockaddr *)&name, &len)) {
+		log_err("Can't getsockname");
+		goto out;
+	}
+
+	switch (name.ss_family) {
+	case AF_INET:
+		port = ((struct sockaddr_in *)&name)->sin_port;
+		break;
+
+	case AF_INET6:
+		port = ((struct sockaddr_in6 *)&name)->sin6_port;
+		break;
+
+	default:
+		log_err("Invalid address family");
+		goto out;
+	}
+
+	if (port != htons(4321)) {
+		log_err("Expected port 4321, got %u", ntohs(port));
+		goto out;
+	}
+
+	ret = 0;
+out:
+	close(client);
+	close(srv_client);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	struct sockaddr_in addr4;
+	struct sockaddr_in6 addr6;
+	int server = -1;
+	int server_v6 = -1;
+	int err = 1;
+
+	memset(&addr4, 0, sizeof(addr4));
+	addr4.sin_family = AF_INET;
+	addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	addr4.sin_port = htons(1234);
+
+	memset(&addr6, 0, sizeof(addr6));
+	addr6.sin6_family = AF_INET6;
+	addr6.sin6_addr = in6addr_loopback;
+	addr6.sin6_port = htons(1234);
+
+	server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
+	if (server == -1)
+		goto out;
+
+	server_v6 = start_server((const struct sockaddr *)&addr6,
+				 sizeof(addr6));
+	if (server_v6 == -1)
+		goto out;
+
+	/* Connect to unbound ports */
+	addr4.sin_port = htons(4321);
+	addr6.sin6_port = htons(4321);
+
+	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
+		goto out;
+
+	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
+		goto out;
+
+	printf("ok\n");
+	err = 0;
+out:
+	close(server);
+	close(server_v6);
+	return err;
+}
diff --git a/tools/testing/selftests/bpf/test_sk_assign.sh b/tools/testing/selftests/bpf/test_sk_assign.sh
new file mode 100755
index 000000000000..62eae9255491
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sk_assign.sh
@@ -0,0 +1,19 @@
+#!/bin/bash -e
+# SPDX-License-Identifier: GPL-2.0
+
+if [[ $EUID -ne 0 ]]; then
+        echo "This script must be run as root"
+        echo "FAIL"
+        exit 1
+fi
+
+# Run the script in a dedicated network namespace.
+if [[ -z $(ip netns identify $$) ]]; then
+        exec ../net/in_netns.sh "$0" "$@"
+fi
+
+tc qdisc add dev lo clsact
+tc filter add dev lo ingress bpf direct-action object-file ./test_sk_assign.o \
+	section "sk_assign_test"
+
+exec ./test_sk_assign
-- 
2.20.1

