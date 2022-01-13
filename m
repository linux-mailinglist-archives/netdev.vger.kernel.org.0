Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693D148D01B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 02:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiAMBYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 20:24:14 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:22112 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiAMBYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 20:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1642037051; x=1673573051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iWCXlXyuMmPjYSfigyIyX2IYPfl2A7uP/vsSgT71UJI=;
  b=qP0MQe7ndWkS7x4TSNe0UmrBVjAXNv1sOv9YnBhQRe0VePO28kD3GXkO
   9FU1Y1eXKj4iHXaDNSkzrmashzUL55HAk02MQ+xQ9zeQ59iojbXGbomTi
   vHyuQlLsSsnPd6PkmfthhVymIh+0tXole0PxkPlU5vNLbpktNQmuEqdSj
   I=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 12 Jan 2022 17:24:10 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-sd-u20-a-1.qualcomm.com) ([10.47.235.107])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 12 Jan 2022 17:24:10 -0800
Received: by hu-devc-sd-u20-a-1.qualcomm.com (Postfix, from userid 202676)
        id 40AA95DA; Wed, 12 Jan 2022 17:23:50 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        daniel@iogearbox.net, song@kernel.org,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH bpf-next v7 2/2] selftests/bpf: CGROUP_SKB test for skb_store_bytes()
Date:   Wed, 12 Jan 2022 17:23:34 -0800
Message-Id: <20220113012334.558689-2-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220113012334.558689-1-quic_twear@quicinc.com>
References: <20220113012334.558689-1-quic_twear@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that the source port of an egress packet is changed
via skb_store_bytes() for a BPF_PROG_TYPE_CGROUP_SKB prog.

Test creates a client and server and checks that the packet
received on the server has the updated source IP and Port
that the bpf program modifies.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 .../bpf/prog_tests/cgroup_store_bytes.c       | 70 +++++++++++++++++++
 .../selftests/bpf/progs/cgroup_store_bytes.c  | 49 +++++++++++++
 2 files changed, 119 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
new file mode 100644
index 000000000000..c6cabc19849e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include "cgroup_store_bytes.skel.h"
+
+void test_cgroup_store_bytes(void)
+{
+	int server_fd, cgroup_fd, client_fd, err, bytes;
+	struct sockaddr server_addr;
+	socklen_t addrlen = sizeof(server_addr);
+	char buf[] = "testing";
+	struct sockaddr_storage ss;
+	socklen_t slen = sizeof(ss);
+	char recv_buf[BUFSIZ];
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
+
+	skel->links.cgroup_store_bytes = bpf_program__attach_cgroup(
+			skel->progs.cgroup_store_bytes, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.cgroup_store_bytes , "cgroup_store_bytes"))
+		goto close_skeleton;
+
+	server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (!ASSERT_GE(server_fd, 0, "server_fd"))
+		goto close_skeleton;
+
+	client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
+	if (!ASSERT_GE(client_fd, 0, "client_fd"))
+		goto close_server_fd;
+
+	err = getsockname(server_fd, &server_addr, &addrlen);
+	if (!ASSERT_OK(err, "getsockname"))
+		goto close_client_fd;
+
+	bytes = sendto(client_fd, buf, sizeof(buf), 0, &server_addr,
+			sizeof(server_addr));
+	if (!ASSERT_EQ(bytes, sizeof(buf), "sendto"))
+		goto close_client_fd;
+
+	bytes = recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0,
+			(struct sockaddr *)&ss, &slen);
+	if (!ASSERT_GE(bytes, 0, "recvfrom"))
+		goto close_client_fd;
+
+	addr = ((struct sockaddr_in *)&ss)->sin_addr;
+
+	ASSERT_EQ(skel->bss->test_result, 1, "bpf program returned failure");
+	port = ((struct sockaddr_in *)&ss)->sin_port;
+	ASSERT_EQ(port, 5555, "bpf program failed to change port");
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
index 000000000000..4608083e18b7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
@@ -0,0 +1,49 @@
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
+int test_result = 0;
+
+SEC("cgroup_skb/egress")
+int cgroup_store_bytes(struct __sk_buff *skb)
+{
+	struct ethhdr eth;
+	struct iphdr iph;
+	struct udphdr udph;
+
+	__u32 map_key = 0;
+	__u16 new_port = 5555;
+	__u16 old_port;
+	__u32 old_ip;
+
+	if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph), BPF_HDR_START_NET))
+		goto fail;
+
+	if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph), BPF_HDR_START_NET))
+		goto fail;
+
+	old_port = udph.source;
+	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port,
+						IS_PSEUDO | sizeof(new_port));
+	if (bpf_skb_store_bytes(skb, UDP_SPORT_OFF, &new_port, sizeof(new_port), 0) < 0)
+		goto fail;
+
+	test_result = 1;
+
+fail:
+	return 1;
+}
-- 
2.25.1

