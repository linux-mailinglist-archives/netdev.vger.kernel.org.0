Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9D485D6E
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiAFAo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:44:58 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:51216 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343936AbiAFAoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:44:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1641429862; x=1672965862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Rz5PvVfZbv748AWmS2fFlrQBqLr5EJy3zvJ1hILAXbo=;
  b=WiXRH16FntlU43N/ay4ijmoPJm0KhWmzTClhpwdvHndV0a3woJKQi4Ql
   wZ9i6aDrcGNZvFUrNEIaiwSze/4OIRD85tUfZ9+RfMFt88JZ5V9KIMD+U
   6hYMscK10UPJWXKsS25dsrhio6Pgv7gqOcn6OemxC+kwuO3mTqLNeBlH2
   8=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 05 Jan 2022 16:44:20 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-sd-u20-a-1.qualcomm.com) ([10.47.235.107])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 05 Jan 2022 16:44:20 -0800
Received: by hu-devc-sd-u20-a-1.qualcomm.com (Postfix, from userid 202676)
        id 51B5E5D9; Wed,  5 Jan 2022 16:44:00 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        Tyler Wear <quic_twear@quicinc.org>,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH bpf-next v3] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Date:   Wed,  5 Jan 2022 16:43:40 -0800
Message-Id: <20220106004340.2317542-1-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tyler Wear <quic_twear@quicinc.org>

Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
Instead of adding generic function for just modifying the ds field,
add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
This allows other fields in the network and transport header to be
modified in the future.

Checksum API's also need to be added for completeness.

It is not possible to use CGROUP_(SET|GET)SOCKOPT since
the policy may change during runtime and would result
in a large number of entries with wildcards.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 net/core/filter.c                             | 10 ++
 .../bpf/prog_tests/cgroup_store_bytes.c       | 97 +++++++++++++++++++
 .../selftests/bpf/progs/cgroup_store_bytes.c  | 64 ++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c

diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..ce01a8036361 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7299,6 +7299,16 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_delete_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+	case BPF_FUNC_skb_store_bytes:
+		return &bpf_skb_store_bytes_proto;
+	case BPF_FUNC_csum_update:
+		return &bpf_csum_update_proto;
+	case BPF_FUNC_csum_level:
+		return &bpf_csum_level_proto;
+	case BPF_FUNC_l3_csum_replace:
+		return &bpf_l3_csum_replace_proto;
+	case BPF_FUNC_l4_csum_replace:
+		return &bpf_l4_csum_replace_proto;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
new file mode 100644
index 000000000000..4bbc43775f45
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_cgroup_store_bytes(void)
+{
+	int server_fd, cgroup_fd, prog_fd, map_fd, client_fd;
+	int err;
+	struct bpf_object *obj;
+	struct bpf_program *prog;
+	struct bpf_map *test_result;
+	__u32 duration = 0;
+
+	__u32 map_key = 0;
+	__u32 map_value = 0;
+
+	cgroup_fd = test__join_cgroup("/cgroup_store_bytes");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+
+	err = bpf_prog_load("./cgroup_store_bytes.o", BPF_PROG_TYPE_CGROUP_SKB,
+														&obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		goto close_server_fd;
+
+	test_result = bpf_object__find_map_by_name(obj, "test_result");
+	if (CHECK_FAIL(!test_result))
+		goto close_bpf_object;
+
+	map_fd = bpf_map__fd(test_result);
+	if (map_fd < 0)
+		goto close_bpf_object;
+
+	prog = bpf_object__find_program_by_name(obj, "cgroup_store_bytes");
+	if (CHECK_FAIL(!prog))
+		goto close_bpf_object;
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS,
+														BPF_F_ALLOW_MULTI);
+	if (CHECK_FAIL(err))
+		goto close_bpf_object;
+
+	//client_fd = connect_to_fd(server_fd, 0);
+	client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (CHECK_FAIL(client_fd < 0))
+		goto close_bpf_object;
+
+	struct sockaddr server_addr;
+	socklen_t addrlen = sizeof(server_addr);
+	if (getsockname(server_fd, &server_addr, &addrlen)) {
+		perror("Failed to get server addr");
+		return -1;
+	}
+
+	char buf[] = "testing";
+	if (CHECK_FAIL(sendto(client_fd, buf, sizeof(buf), 0, &server_addr, sizeof(server_addr)) != sizeof(buf))) {
+		perror("Can't write on client");
+		goto close_client_fd;
+	}
+
+	struct sockaddr_storage ss;
+	char recv_buf[BUFSIZ];
+	socklen_t slen;
+	if (recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0, (struct sockaddr *)&ss, &slen) <= 0) {
+		perror("Recvfrom recieved no packets");
+		goto close_client_fd;
+	}
+
+	struct in_addr addr = ((struct sockaddr_in *)&ss)->sin_addr;
+	CHECK(addr.s_addr != 0xac100164, "bpf", "bpf program failed to change saddr");
+
+	unsigned short port = ((struct sockaddr_in *)&ss)->sin_port;
+	CHECK(port != htons(5556), "bpf", "bpf program failed to change port");
+	
+	err = bpf_map_lookup_elem(map_fd, &map_key, &map_value);
+	if (CHECK_FAIL(err))
+		goto close_client_fd;
+
+	CHECK(map_value != 1, "bpf", "bpf program returned failure");
+
+close_client_fd:
+	close(client_fd);
+
+close_bpf_object:
+	bpf_object__close(obj);
+
+close_server_fd:
+	close(server_fd);
+
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
new file mode 100644
index 000000000000..7e5bf61fcfb7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <errno.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <netinet/in.h>
+#include <netinet/udp.h>
+#include <bpf/bpf_helpers.h>
+
+#define IP_SRC_OFF offsetof(struct iphdr, saddr)
+#define UDP_PORT_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, source))
+
+#define IS_PSEUDO 0x10
+
+#define UDP_CSUM_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, check))
+#define IP_CSUM_OFF offsetof(struct iphdr, check)
+#define TOS_OFF offsetof(struct iphdr, tos)
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} test_result SEC(".maps");
+
+SEC("cgroup_skb/egress")
+int cgroup_store_bytes(struct __sk_buff *skb)
+{
+	struct ethhdr eth;
+	struct iphdr iph;
+	struct udphdr udph;
+
+	__u32 map_key = 0;
+	__u32 test_passed = 0;
+
+	if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph), //ETH_HLEN
+					BPF_HDR_START_NET))
+		goto fail;
+		
+	if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph),
+					BPF_HDR_START_NET))
+		goto fail;
+
+	__u32 old_ip = htonl(iph.saddr);
+	__u32 new_ip = 0xac100164; //172.16.1.100
+	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_ip, new_ip, IS_PSEUDO | sizeof(new_ip));
+	bpf_l3_csum_replace(skb, IP_CSUM_OFF, old_ip, new_ip, sizeof(new_ip));
+	if (bpf_skb_store_bytes(skb, IP_SRC_OFF, &new_ip, sizeof(new_ip), 0) < 0)
+		goto fail;
+	
+	__u16 old_port = udph.source;
+	__u16 new_port = 5555;
+	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port, IS_PSEUDO | sizeof(new_port));
+	if (bpf_skb_store_bytes(skb, UDP_PORT_OFF, &new_port, sizeof(new_port), 0) < 0)
+		goto fail;
+
+	test_passed = 1;
+
+fail:
+	bpf_map_update_elem(&test_result, &map_key, &test_passed, BPF_ANY);
+
+	return 1;
+}
-- 
2.25.1

