Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6313618EFF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiKDD12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiKDD0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABC71C6
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m200-20020a25d4d1000000b006cb7e26b93cso3872345ybf.1
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/t++ZB8ZRdYiQRs6vAeOu+SLWVF7zSJIpQ41KNcjWI=;
        b=s2IFIAUGsd7AqXXaPe0BwDT02/NUuVMTeNoFYo1LIVu9d6Nv0/LWf8wswVPACXBqiv
         sCN2FlCrP52JzCBzev0HSKXKkgaKiNypcojn1PbwSnhxmvFwxrVu/LkYNWfZ+1HIPFKz
         3BZ2qjwlSc1LIdd0E2XE/LUZbgYlEzvbSkYQiKqLMlJDhudEWXSdyUH4oiq+V72e9ncb
         8B3F1C4whOOusBfDnjCKWDKqEl93zWp9vFRl3vcuQ9NcJ9YkP2DO8Z9eskoJMKpPBphD
         hGS+S60rY+b9y2E+UQax8B44c4A7U6Z/4OJypIVo50h2spvHWIn3EUSB3Epydl44zK4r
         qgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/t++ZB8ZRdYiQRs6vAeOu+SLWVF7zSJIpQ41KNcjWI=;
        b=OeJFFOgW2zaHp4srpanECc5aMF68eyZcFfHH5YRsGh+NhplQQD1Xn15nywchG+dbtl
         WnKaFNJh5dWCsf8mc1NL4Ycov+S/A9aVJqKRv23VBvntr1Sj5uuqEUfod/4TWnYeIyn5
         RRN2AGlj3YkLWdWQJTpmJhMsQkiCJirQH0bGj9ppaxm/r4pXlabxqBj+m2r9LvPLNwgZ
         GxIorpJwm7EvaWzb9St+H0cQnL2QO+B3lhRjGMQwC/nd8s2kUg0zHGqr9Dn9gHSrDdE7
         lPwtZsOT84+HHfUOMV/VGDFKTVweBvYE8UQ+rXaQbXHQj9veCj78J3pJu8CaMu/JTcaN
         ZurQ==
X-Gm-Message-State: ACrzQf1IW3PFaG7ghkA3UHbIJ/IdcSYMgUowOWuJmuKXtRipTjDnDKDZ
        GXZ0r3bXf6MGFAkZnzeBKrgZuRI=
X-Google-Smtp-Source: AMsMyM5iduaYSsmx19j/VB+33xf9Aec8ANpssw93644z06Z3Jd66rvbBQNSce3CFv+xr1U/1gocobdw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a0d:db08:0:b0:36d:a4e7:4c03 with SMTP id
 d8-20020a0ddb08000000b0036da4e74c03mr32064645ywe.169.1667532342458; Thu, 03
 Nov 2022 20:25:42 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:23 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-6-sdf@google.com>
Subject: [RFC bpf-next v2 05/14] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- create new netns
- create veth pair (veTX+veRX)
- setup AF_XDP socket for both interfaces
- attach bpf to veRX
- send packet via veTX
- verify the packet has expected metadata at veRX

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 302 ++++++++++++++++++
 .../selftests/bpf/progs/xdp_metadata.c        |  50 +++
 3 files changed, 353 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 79edef1dbda4..815bfd6b80cc 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -522,7 +522,7 @@ TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 btf_helpers.c flow_dissector_load.h		\
-			 cap_helpers.c
+			 cap_helpers.c xsk.c
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
 		       $(OUTPUT)/liburandom_read.so			\
 		       $(OUTPUT)/xdp_synproxy				\
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
new file mode 100644
index 000000000000..bb06e25fb2bb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "xdp_metadata.skel.h"
+#include "xsk.h"
+
+#include <linux/errqueue.h>
+#include <linux/if_link.h>
+#include <linux/net_tstamp.h>
+#include <linux/udp.h>
+#include <sys/mman.h>
+#include <net/if.h>
+#include <poll.h>
+
+#define TX_NAME "veTX"
+#define RX_NAME "veRX"
+
+#define UDP_PAYLOAD_BYTES 4
+
+#define AF_XDP_SOURCE_PORT 1234
+#define AF_XDP_CONSUMER_PORT 8080
+
+#define UMEM_NUM 16
+#define UMEM_FRAME_SIZE XSK_UMEM__DEFAULT_FRAME_SIZE
+#define UMEM_SIZE (UMEM_FRAME_SIZE * UMEM_NUM)
+#define XDP_FLAGS XDP_FLAGS_DRV_MODE
+#define QUEUE_ID 0
+
+#define TX_ADDR "10.0.0.1"
+#define RX_ADDR "10.0.0.2"
+#define PREFIX_LEN "8"
+#define FAMILY AF_INET
+
+#define SYS(cmd) ({ \
+	if (!ASSERT_OK(system(cmd), (cmd))) \
+		goto out; \
+})
+
+struct xsk {
+	void *umem_area;
+	struct xsk_umem *umem;
+	struct xsk_ring_prod fill;
+	struct xsk_ring_cons comp;
+	struct xsk_ring_prod tx;
+	struct xsk_ring_cons rx;
+	struct xsk_socket *socket;
+	int next_tx;
+};
+
+int open_xsk(const char *ifname, struct xsk *xsk)
+{
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	const struct xsk_socket_config socket_config = {
+		.rx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD,
+		.xdp_flags = XDP_FLAGS,
+		.bind_flags = XDP_COPY,
+	};
+	u64 addr;
+	int ret;
+	int i;
+
+	xsk->umem_area = mmap(NULL, UMEM_SIZE, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+	if (!ASSERT_NEQ(xsk->umem_area, MAP_FAILED, "mmap"))
+		return -1;
+
+	ret = xsk_umem__create(&xsk->umem,
+			       xsk->umem_area, UMEM_SIZE,
+			       &xsk->fill,
+			       &xsk->comp,
+			       NULL);
+	if (!ASSERT_OK(ret, "xsk_umem__create"))
+		return ret;
+
+	ret = xsk_socket__create(&xsk->socket, ifname, QUEUE_ID,
+				 xsk->umem,
+				 &xsk->rx,
+				 &xsk->tx,
+				 &socket_config);
+	if (!ASSERT_OK(ret, "xsk_socket__create"))
+		return ret;
+
+	/* First half of umem is for TX. This way address matches 1-to-1
+	 * to the completion queue index.
+	 */
+
+	xsk->next_tx = 0;
+
+	/* Second half of umem is for RX. */
+
+	__u32 idx;
+	ret = xsk_ring_prod__reserve(&xsk->fill, UMEM_NUM / 2, &idx);
+	if (!ASSERT_EQ(UMEM_NUM / 2, ret, "xsk_ring_prod__reserve"))
+		return ret;
+	if (!ASSERT_EQ(idx, 0, "fill idx != 0"))
+		return -1;
+
+	for (i = 0; i < UMEM_NUM / 2; i++) {
+		addr = (UMEM_NUM / 2 + i) * UMEM_FRAME_SIZE;
+		*xsk_ring_prod__fill_addr(&xsk->fill, i) = addr;
+	}
+	xsk_ring_prod__submit(&xsk->fill, ret);
+
+	return 0;
+}
+
+void close_xsk(struct xsk *xsk)
+{
+	if (xsk->umem)
+		xsk_umem__delete(xsk->umem);
+	if (xsk->socket)
+		xsk_socket__delete(xsk->socket);
+	munmap(xsk->umem, UMEM_SIZE);
+}
+
+static void ip_csum(struct iphdr *iph)
+{
+	__u32 sum = 0;
+	__u16 *p;
+	int i;
+
+	iph->check = 0;
+	p = (void *)iph;
+	for (i = 0; i < sizeof(*iph) / sizeof(*p); i++)
+		sum += p[i];
+
+	while (sum >> 16)
+		sum = (sum & 0xffff) + (sum >> 16);
+
+	iph->check = ~sum;
+}
+
+int generate_packet(struct xsk *xsk, __u16 dst_port)
+{
+	struct xdp_desc *tx_desc;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	void *data;
+	__u32 idx;
+	int ret;
+
+	ret = xsk_ring_prod__reserve(&xsk->tx, 1, &idx);
+	if (!ASSERT_EQ(ret, 1, "xsk_ring_prod__reserve"))
+		return -1;
+
+	tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx);
+	tx_desc->addr = xsk->next_tx++ % (UMEM_NUM / 2);
+	data = xsk_umem__get_data(xsk->umem_area, tx_desc->addr);
+
+	eth = data;
+	iph = (void *)(eth + 1);
+	udph = (void *)(iph + 1);
+
+	memcpy(eth->h_dest, "\x00\x00\x00\x00\x00\x02", ETH_ALEN);
+	memcpy(eth->h_source, "\x00\x00\x00\x00\x00\x01", ETH_ALEN);
+	eth->h_proto = htons(ETH_P_IP);
+
+	iph->version = 0x4;
+	iph->ihl = 0x5;
+	iph->tos = 0x9;
+	iph->tot_len = htons(sizeof(*iph) + sizeof(*udph) + UDP_PAYLOAD_BYTES);
+	iph->id = 0;
+	iph->frag_off = 0;
+	iph->ttl = 0;
+	iph->protocol = IPPROTO_UDP;
+	ASSERT_EQ(inet_pton(FAMILY, TX_ADDR, &iph->saddr), 1, "inet_pton(TX_ADDR)");
+	ASSERT_EQ(inet_pton(FAMILY, RX_ADDR, &iph->daddr), 1, "inet_pton(RX_ADDR)");
+	ip_csum(iph);
+
+	udph->source = htons(AF_XDP_SOURCE_PORT);
+	udph->dest = htons(dst_port);
+	udph->len = htons(sizeof(*udph) + UDP_PAYLOAD_BYTES);
+	udph->check = 0;
+
+	memset(udph + 1, 0xAA, UDP_PAYLOAD_BYTES);
+
+	tx_desc->len = sizeof(*eth) + sizeof(*iph) + sizeof(*udph) + UDP_PAYLOAD_BYTES;
+	xsk_ring_prod__submit(&xsk->tx, 1);
+
+	ret = sendto(xsk_socket__fd(xsk->socket), NULL, 0, MSG_DONTWAIT, NULL, 0);
+	if (!ASSERT_GE(ret, 0, "sendto"))
+		return ret;
+
+	return 0;
+}
+
+int verify_xsk_metadata(struct xsk *xsk)
+{
+	const struct xdp_desc *rx_desc;
+	struct pollfd fds = {};
+	void *data_meta;
+	void *data;
+	__u32 idx;
+	int ret;
+
+	ret = recvfrom(xsk_socket__fd(xsk->socket), NULL, 0, MSG_DONTWAIT, NULL, NULL);
+	if (!ASSERT_EQ(ret, 0, "recvfrom"))
+		return -1;
+
+	fds.fd = xsk_socket__fd(xsk->socket);
+	fds.events = POLLIN;
+
+	ret = poll(&fds, 1, 1000);
+	if (!ASSERT_GT(ret, 0, "poll"))
+		return -1;
+
+	ret = xsk_ring_cons__peek(&xsk->rx, 1, &idx);
+	if (!ASSERT_EQ(ret, 1, "xsk_ring_cons__peek"))
+		return -2;
+
+	rx_desc = xsk_ring_cons__rx_desc(&xsk->rx, idx++);
+	data = xsk_umem__get_data(xsk->umem_area, rx_desc->addr);
+
+	data_meta = data - 8; /* oh boy, this seems wrong! */
+
+	if (*(__u32 *)data_meta == 0)
+		return -1;
+
+	return 0;
+}
+
+void test_xdp_metadata(void)
+{
+	struct xdp_metadata *bpf_obj = NULL;
+	struct nstoken *tok = NULL;
+	struct bpf_program *prog;
+	struct xsk tx_xsk = {};
+	struct xsk rx_xsk = {};
+	int rx_ifindex;
+	int ret;
+
+	/* Setup new networking namespace, with a veth pair. */
+
+	SYS("ip netns add xdp_metadata");
+	tok = open_netns("xdp_metadata");
+	SYS("ip link add numtxqueues 1 numrxqueues 1 " TX_NAME " type veth "
+	    "peer " RX_NAME " numtxqueues 1 numrxqueues 1");
+	SYS("ip link set dev " TX_NAME " address 00:00:00:00:00:01");
+	SYS("ip link set dev " RX_NAME " address 00:00:00:00:00:02");
+	SYS("ip link set dev " TX_NAME " up");
+	SYS("ip link set dev " RX_NAME " up");
+	SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
+	SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
+
+	rx_ifindex = if_nametoindex(RX_NAME);
+
+	/* Setup separate AF_XDP for TX and RX interfaces. */
+
+	ret = open_xsk(TX_NAME, &tx_xsk);
+	if (!ASSERT_OK(ret, "open_xsk(TX_NAME)"))
+		goto out;
+
+	ret = open_xsk(RX_NAME, &rx_xsk);
+	if (!ASSERT_OK(ret, "open_xsk(RX_NAME)"))
+		goto out;
+
+	/* Attach BPF program to RX interface. */
+
+	bpf_obj = xdp_metadata__open();
+	if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
+		goto out;
+
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
+	bpf_program__set_ifindex(prog, rx_ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_HAS_METADATA);
+
+	if (!ASSERT_OK(xdp_metadata__load(bpf_obj), "load skeleton"))
+		goto out;
+
+	ret = bpf_xdp_attach(rx_ifindex,
+			     bpf_program__fd(bpf_obj->progs.rx),
+			     XDP_FLAGS, NULL);
+	if (!ASSERT_GE(ret, 0, "bpf_xdp_attach"))
+		goto out;
+
+	__u32 queue_id = QUEUE_ID;
+	int sock_fd = xsk_socket__fd(rx_xsk.socket);
+	ret = bpf_map_update_elem(bpf_map__fd(bpf_obj->maps.xsk), &queue_id, &sock_fd, 0);
+	if (!ASSERT_GE(ret, 0, "bpf_map_update_elem"))
+		goto out;
+
+	/* Send packet destined to RX AF_XDP socket. */
+	if (!ASSERT_GE(generate_packet(&tx_xsk, AF_XDP_CONSUMER_PORT), 0,
+		       "generate AF_XDP_CONSUMER_PORT"))
+	    goto out;
+
+	/* Verify AF_XDP RX packet has proper metadata. */
+	if (!ASSERT_GE(verify_xsk_metadata(&rx_xsk), 0,
+		       "verify_xsk_metadata"))
+	    goto out;
+
+out:
+	close_xsk(&rx_xsk);
+	close_xsk(&tx_xsk);
+	if (bpf_obj)
+		xdp_metadata__destroy(bpf_obj);
+	system("ip netns del xdp_metadata");
+	if (tok)
+		close_netns(tok);
+}
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata.c b/tools/testing/selftests/bpf/progs/xdp_metadata.c
new file mode 100644
index 000000000000..bdde17961ab6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/in.h>
+#include <linux/udp.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_XSKMAP);
+	__uint(max_entries, 4);
+	__type(key, __u32);
+	__type(value, __u32);
+} xsk SEC(".maps");
+
+extern int bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx) __ksym;
+extern const __u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx) __ksym;
+
+SEC("xdp")
+int rx(struct xdp_md *ctx)
+{
+	void *data, *data_meta;
+	int ret;
+
+	if (bpf_xdp_metadata_rx_timestamp_supported(ctx)) {
+		__u64 rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
+
+		if (rx_timestamp) {
+			ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(rx_timestamp));
+			if (ret != 0)
+				return XDP_DROP;
+
+			data = (void *)(long)ctx->data;
+			data_meta = (void *)(long)ctx->data_meta;
+
+			if (data_meta + sizeof(rx_timestamp) > data)
+				return XDP_DROP;
+
+			*(__u64 *)data_meta = rx_timestamp;
+		}
+	}
+
+	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.38.1.431.g37b22c650d-goog

