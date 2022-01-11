Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CC748A419
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 01:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345810AbiAKAAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 19:00:21 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:34264 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345809AbiAKAAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 19:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1641859221; x=1673395221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0KLM3x3cXDlFBExSyfAFV7jH+7olvxwAXg/WCdKRx0=;
  b=pck6qAzptWrzRXe29MfEqnwzGWp635Yf6Ew03tfEpyFcw8NSd6BAv5yC
   1GabX/NjXGqdKJlfranTcxsVBEA9pCbOAOsiO5XmpyD4kljRYSQjvyvL9
   dkkaP1Uj0/F+HrHclPB2kphmoxgMhXI5Ait8QMvCR+4hQvFlcfGx4gy85
   E=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 10 Jan 2022 16:00:21 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-sd-u20-a-1.qualcomm.com) ([10.47.235.107])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 10 Jan 2022 16:00:20 -0800
Received: by hu-devc-sd-u20-a-1.qualcomm.com (Postfix, from userid 202676)
        id 55ED15DC; Mon, 10 Jan 2022 16:00:20 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        daniel@iogearbox.net, song@kernel.org,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH bpf-next v5 2/2] selftests/bpf: CGROUP_SKB test for skb_store_bytes()
Date:   Mon, 10 Jan 2022 16:00:01 -0800
Message-Id: <20220111000001.3118189-2-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220111000001.3118189-1-quic_twear@quicinc.com>
References: <20220111000001.3118189-1-quic_twear@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch adds a test case to check that the source IP and Port of
packet are correctly changed for BPF_PROG_TYPE_CGROUP_SKB via
skb_store_bytes().

Test creates a client and server and checks that the packet
received on the server has the updated source IP and Port
that the bpf program modifies.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 .../bpf/prog_tests/cgroup_store_bytes.c       | 81 +++++++++++++++++++
 .../selftests/bpf/progs/cgroup_store_bytes.c  | 63 +++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
new file mode 100644
index 000000000000..f492fdb2f31b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include "cgroup_store_bytes.skel.h"
+
+static int duration;
+
+void test_cgroup_store_bytes(void)
+{
+	int server_fd, cgroup_fd, client_fd;
+	struct sockaddr server_addr;
+	socklen_t addrlen = sizeof(server_addr);
+	char buf[] = "testing";
+	struct sockaddr_storage ss;
+	char recv_buf[BUFSIZ];
+	socklen_t slen;
+	struct in_addr addr;
+	unsigned short port;
+	struct cgroup_store_bytes *skel;
+
+	cgroup_fd = test__join_cgroup("/cgroup_store_bytes");
+	if (!ASSERT_GE(cgroup_fd, 0, "cgroup_fd"))
+		return;
+
+	skel = cgroup_store_bytes__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		goto close_cgroup_fd;
+	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
+		goto close_cgroup_fd;
+
+	skel->links.cgroup_store_bytes = bpf_program__attach_cgroup(
+			skel->progs.cgroup_store_bytes, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel, "cgroup_store_bytes"))
+		goto close_skeleton;
+
+	server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (!ASSERT_GE(server_fd, 0, "server_fd"))
+		goto close_cgroup_fd;
+
+	client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (!ASSERT_GE(client_fd, 0, "client_fd"))
+		goto close_server_fd;
+
+	if (getsockname(server_fd, &server_addr, &addrlen)) {
+		perror("Failed to get server addr");
+		goto close_client_fd;
+	}
+
+	if (CHECK_FAIL(sendto(client_fd, buf, sizeof(buf), 0, &server_addr,
+			sizeof(server_addr)) != sizeof(buf))) {
+		perror("Can't write on client");
+		goto close_client_fd;
+	}
+
+	if (recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0,
+			(struct sockaddr *)&ss, &slen) <= 0) {
+		perror("Recvfrom received no packets");
+		goto close_client_fd;
+	}
+
+	addr = ((struct sockaddr_in *)&ss)->sin_addr;
+
+	CHECK(addr.s_addr != 0xac100164, "bpf", "bpf program failed to change saddr");
+
+	port = ((struct sockaddr_in *)&ss)->sin_port;
+
+	CHECK(port != htons(5555), "bpf", "bpf program failed to change port");
+
+	CHECK(skel->bss->test_result != 1, "bpf", "bpf program returned failure");
+
+close_client_fd:
+	close(client_fd);
+close_server_fd:
+	close(server_fd);
+close_skeleton:
+	cgroup_store_bytes__destroy(skel);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
new file mode 100644
index 000000000000..d81d39281526
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
@@ -0,0 +1,63 @@
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
+#define UDP_SPORT_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, source))
+
+#define IS_PSEUDO 0x10
+
+#define UDP_CSUM_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, check))
+#define IP_CSUM_OFF offsetof(struct iphdr, check)
+
+int test_result;
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
+	if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph),
+									BPF_HDR_START_NET))
+		goto fail;
+
+	if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph),
+									BPF_HDR_START_NET))
+		goto fail;
+
+	__u32 old_ip = htonl(iph.saddr);
+	__u32 new_ip = 0xac100164; //172.16.1.100
+
+	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_ip, new_ip,
+						IS_PSEUDO | sizeof(new_ip));
+	bpf_l3_csum_replace(skb, IP_CSUM_OFF, old_ip, new_ip, sizeof(new_ip));
+	if (bpf_skb_store_bytes(skb, IP_SRC_OFF, &new_ip, sizeof(new_ip), 0) < 0)
+		goto fail;
+
+	__u16 old_port = udph.source;
+	__u16 new_port = 5555;
+
+	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port,
+						IS_PSEUDO | sizeof(new_port));
+	if (bpf_skb_store_bytes(skb, UDP_SPORT_OFF, &new_port, sizeof(new_port),
+							0) < 0)
+		goto fail;
+
+	test_passed = 1;
+
+fail:
+	test_result = test_passed;
+
+	return 1;
+}
-- 
2.25.1

