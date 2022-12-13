Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B033764ADC5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiLMChp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiLMChB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:37:01 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4471A04A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:33 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id f14-20020a056a0022ce00b005782e3b4704so1133230pfj.4
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0m6R6fzsh/fm8sAJzuMe3pI5P5q7by5MUsxZ9GF5kAs=;
        b=cFq8A/ecb6rOXem+ASLqGjmJMRwTmkOiVwIf28tAfKiuqAmaW9CD69cYpoHwh1pJAw
         2AFehOyZXaIf8eCm8gQXGQoMCmOuDEBXXlht4wg/ESAaey+MZxlrIOnerKYSXtKWPuCn
         /eJNr+oepg0L2PMhYq3KmmjDPSbnp51DxBHpLhvFf6DeoxQ8izXg/QVJq97JahuShPT1
         VqDd8yFOLfAwpYEwfFRYUPLCe4tKufZe7+kLqrBSvEsPqhe+LKVcBEzFwGztRnGJoDFY
         pk5HhWrkB+Wg+5JzvTjnVbCSEUxfae+B1uJrXwudCg+F90t+9xiHmOzMjd7uTJJPPkaA
         FCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0m6R6fzsh/fm8sAJzuMe3pI5P5q7by5MUsxZ9GF5kAs=;
        b=xwrYLyDWoiuYYBLz5A20fNF3MM6h920kEW9ETMBnirjTH8Qq8iT1fcq3vt4V2byPTm
         0S3FLBvx6Lpp4uFyAzjfioANduYOFhN1hbWmzHFvgkMhgyZ01xty3w0nDPeMm9blx1wX
         HAaxu8rnmXlnNfKah3LGIPnKQBzbgRwlim0Qq0tZhRxtzORdq5Fqw9wHBY5XHAICLdmK
         PV2m3Er93F7YOZyXL74ghabSje65jOYS6vXyuGWXR1R36RdXx5eAVBcLQ2bB2yOgs+mO
         EXjBHK0swww7pIr/tVOL8K4S7/qNp7+Iwk6uFYOsfQmVK0enmqyszxZz/zF3Jo9TtKFb
         XN7w==
X-Gm-Message-State: ANoB5pnZ7F+6ivoegHWZOrsT5eb8PlvBLc2AtJ4pxy+dq9J8NDAtdJFj
        FbVOs5cmVJfT9U818T8MYu5lhY4=
X-Google-Smtp-Source: AA0mqf71DlvCiw9ZbG2Y+Xn16ubvfY+EQY3dKNagEPJq2GP+1rKY87Gwjx0uOU7vGYABV/0elbM9s2o=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:82c8:b0:189:f390:61d5 with SMTP id
 u8-20020a17090282c800b00189f39061d5mr8409273plz.141.1670898992507; Mon, 12
 Dec 2022 18:36:32 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:36:05 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-16-sdf@google.com>
Subject: [PATCH bpf-next v4 15/15] selftests/bpf: Simple program to dump XDP
 RX metadata
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

To be used for verification of driver implementations. Note that
the skb path is gone from the series, but I'm still keeping the
implementation for any possible future work.

$ xdp_hw_metadata <ifname>

On the other machine:

$ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
$ echo -n skb | nc -u -q1 <target> 9092 # for skb

Sample output:

  # xdp
  xsk_ring_cons__peek: 1
  0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
  rx_timestamp_supported: 1
  rx_timestamp: 1667850075063948829
  0x19f9090: complete idx=8 addr=8000

  # skb
  found skb hwtstamp = 1668314052.854274681

Decoding:
  # xdp
  rx_timestamp=1667850075.063948829

  $ date -d @1667850075
  Mon Nov  7 11:41:15 AM PST 2022
  $ date
  Mon Nov  7 11:42:05 AM PST 2022

  # skb
  $ date -d @1668314052
  Sat Nov 12 08:34:12 PM PST 2022
  $ date
  Sat Nov 12 08:37:06 PM PST 2022

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
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
 4 files changed, 492 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 07d2d0a8c5cb..01e3baeefd4f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -46,3 +46,4 @@ test_cpp
 xskxceiver
 xdp_redirect_multi
 xdp_synproxy
+xdp_hw_metadata
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e6cbc04a7920..b7d5d3aa554e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xskxceiver xdp_redirect_multi xdp_synproxy veristat
+	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
 TEST_GEN_FILES += liburandom_read.so
@@ -241,6 +241,9 @@ $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
 $(OUTPUT)/xsk.o: $(BPFOBJ)
 $(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
+$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/xsk.o $(OUTPUT)/xdp_hw_metadata.skel.h
+$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/network_helpers.o
+$(OUTPUT)/xdp_hw_metadata: LDFLAGS += -static
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
@@ -383,6 +386,7 @@ linked_maps.skel.h-deps := linked_maps1.bpf.o linked_maps2.bpf.o
 test_subskeleton.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o test_subskeleton.bpf.o
 test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o
 test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
+xdp_hw_metadata.skel.h-deps := xdp_hw_metadata.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
new file mode 100644
index 000000000000..25b8178735ee
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include "xdp_metadata.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_XSKMAP);
+	__uint(max_entries, 256);
+	__type(key, __u32);
+	__type(value, __u32);
+} xsk SEC(".maps");
+
+extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
+					 __u64 *timestamp) __ksym;
+extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
+				    __u32 *hash) __ksym;
+
+SEC("xdp")
+int rx(struct xdp_md *ctx)
+{
+	void *data, *data_meta, *data_end;
+	struct ipv6hdr *ip6h = NULL;
+	struct ethhdr *eth = NULL;
+	struct udphdr *udp = NULL;
+	struct iphdr *iph = NULL;
+	struct xdp_meta *meta;
+	int ret;
+
+	data = (void *)(long)ctx->data;
+	data_end = (void *)(long)ctx->data_end;
+	eth = data;
+	if (eth + 1 < data_end) {
+		if (eth->h_proto == bpf_htons(ETH_P_IP)) {
+			iph = (void *)(eth + 1);
+			if (iph + 1 < data_end && iph->protocol == IPPROTO_UDP)
+				udp = (void *)(iph + 1);
+		}
+		if (eth->h_proto == bpf_htons(ETH_P_IPV6)) {
+			ip6h = (void *)(eth + 1);
+			if (ip6h + 1 < data_end && ip6h->nexthdr == IPPROTO_UDP)
+				udp = (void *)(ip6h + 1);
+		}
+		if (udp && udp + 1 > data_end)
+			udp = NULL;
+	}
+
+	if (!udp)
+		return XDP_PASS;
+
+	if (udp->dest != bpf_htons(9091))
+		return XDP_PASS;
+
+	bpf_printk("forwarding UDP:9091 to AF_XDP");
+
+	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
+	if (ret != 0) {
+		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
+		return XDP_PASS;
+	}
+
+	data = (void *)(long)ctx->data;
+	data_meta = (void *)(long)ctx->data_meta;
+	meta = data_meta;
+
+	if (meta + 1 > data) {
+		bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
+		return XDP_PASS;
+	}
+
+	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
+		bpf_printk("populated rx_timestamp with %u", meta->rx_timestamp);
+
+	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
+		bpf_printk("populated rx_hash with %u", meta->rx_hash);
+
+	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
new file mode 100644
index 000000000000..b8b7600dc275
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Reference program for verifying XDP metadata on real HW. Functional test
+ * only, doesn't test the performance.
+ *
+ * RX:
+ * - UDP 9091 packets are diverted into AF_XDP
+ * - Metadata verified:
+ *   - rx_timestamp
+ *   - rx_hash
+ *
+ * TX:
+ * - TBD
+ */
+
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "xdp_hw_metadata.skel.h"
+#include "xsk.h"
+
+#include <error.h>
+#include <linux/errqueue.h>
+#include <linux/if_link.h>
+#include <linux/net_tstamp.h>
+#include <linux/udp.h>
+#include <linux/sockios.h>
+#include <sys/mman.h>
+#include <net/if.h>
+#include <poll.h>
+
+#include "xdp_metadata.h"
+
+#define UMEM_NUM 16
+#define UMEM_FRAME_SIZE XSK_UMEM__DEFAULT_FRAME_SIZE
+#define UMEM_SIZE (UMEM_FRAME_SIZE * UMEM_NUM)
+#define XDP_FLAGS (XDP_FLAGS_DRV_MODE | XDP_FLAGS_REPLACE)
+
+struct xsk {
+	void *umem_area;
+	struct xsk_umem *umem;
+	struct xsk_ring_prod fill;
+	struct xsk_ring_cons comp;
+	struct xsk_ring_prod tx;
+	struct xsk_ring_cons rx;
+	struct xsk_socket *socket;
+};
+
+struct xdp_hw_metadata *bpf_obj;
+struct xsk *rx_xsk;
+const char *ifname;
+int ifindex;
+int rxq;
+
+void test__fail(void) { /* for network_helpers.c */ }
+
+static int open_xsk(const char *ifname, struct xsk *xsk, __u32 queue_id)
+{
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	const struct xsk_socket_config socket_config = {
+		.rx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD,
+		.xdp_flags = XDP_FLAGS,
+		.bind_flags = XDP_COPY,
+	};
+	const struct xsk_umem_config umem_config = {
+		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
+		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
+		.flags = XDP_UMEM_UNALIGNED_CHUNK_FLAG,
+	};
+	__u32 idx;
+	u64 addr;
+	int ret;
+	int i;
+
+	xsk->umem_area = mmap(NULL, UMEM_SIZE, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+	if (xsk->umem_area == MAP_FAILED)
+		return -ENOMEM;
+
+	ret = xsk_umem__create(&xsk->umem,
+			       xsk->umem_area, UMEM_SIZE,
+			       &xsk->fill,
+			       &xsk->comp,
+			       &umem_config);
+	if (ret)
+		return ret;
+
+	ret = xsk_socket__create(&xsk->socket, ifname, queue_id,
+				 xsk->umem,
+				 &xsk->rx,
+				 &xsk->tx,
+				 &socket_config);
+	if (ret)
+		return ret;
+
+	/* First half of umem is for TX. This way address matches 1-to-1
+	 * to the completion queue index.
+	 */
+
+	for (i = 0; i < UMEM_NUM / 2; i++) {
+		addr = i * UMEM_FRAME_SIZE;
+		printf("%p: tx_desc[%d] -> %lx\n", xsk, i, addr);
+	}
+
+	/* Second half of umem is for RX. */
+
+	ret = xsk_ring_prod__reserve(&xsk->fill, UMEM_NUM / 2, &idx);
+	for (i = 0; i < UMEM_NUM / 2; i++) {
+		addr = (UMEM_NUM / 2 + i) * UMEM_FRAME_SIZE;
+		printf("%p: rx_desc[%d] -> %lx\n", xsk, i, addr);
+		*xsk_ring_prod__fill_addr(&xsk->fill, i) = addr;
+	}
+	xsk_ring_prod__submit(&xsk->fill, ret);
+
+	return 0;
+}
+
+static void close_xsk(struct xsk *xsk)
+{
+	if (xsk->umem)
+		xsk_umem__delete(xsk->umem);
+	if (xsk->socket)
+		xsk_socket__delete(xsk->socket);
+	munmap(xsk->umem, UMEM_SIZE);
+}
+
+static void refill_rx(struct xsk *xsk, __u64 addr)
+{
+	__u32 idx;
+
+	if (xsk_ring_prod__reserve(&xsk->fill, 1, &idx) == 1) {
+		printf("%p: complete idx=%u addr=%llx\n", xsk, idx, addr);
+		*xsk_ring_prod__fill_addr(&xsk->fill, idx) = addr;
+		xsk_ring_prod__submit(&xsk->fill, 1);
+	}
+}
+
+static void verify_xdp_metadata(void *data)
+{
+	struct xdp_meta *meta;
+
+	meta = data - sizeof(*meta);
+
+	printf("rx_timestamp: %llu\n", meta->rx_timestamp);
+	printf("rx_hash: %u\n", meta->rx_hash);
+}
+
+static void verify_skb_metadata(int fd)
+{
+	char cmsg_buf[1024];
+	char packet_buf[128];
+
+	struct scm_timestamping *ts;
+	struct iovec packet_iov;
+	struct cmsghdr *cmsg;
+	struct msghdr hdr;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.msg_iov = &packet_iov;
+	hdr.msg_iovlen = 1;
+	packet_iov.iov_base = packet_buf;
+	packet_iov.iov_len = sizeof(packet_buf);
+
+	hdr.msg_control = cmsg_buf;
+	hdr.msg_controllen = sizeof(cmsg_buf);
+
+	if (recvmsg(fd, &hdr, 0) < 0)
+		error(-1, errno, "recvmsg");
+
+	for (cmsg = CMSG_FIRSTHDR(&hdr); cmsg != NULL;
+	     cmsg = CMSG_NXTHDR(&hdr, cmsg)) {
+
+		if (cmsg->cmsg_level != SOL_SOCKET)
+			continue;
+
+		switch (cmsg->cmsg_type) {
+		case SCM_TIMESTAMPING:
+			ts = (struct scm_timestamping *)CMSG_DATA(cmsg);
+			if (ts->ts[2].tv_sec || ts->ts[2].tv_nsec) {
+				printf("found skb hwtstamp = %lu.%lu\n",
+				       ts->ts[2].tv_sec, ts->ts[2].tv_nsec);
+				return;
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	printf("skb hwtstamp is not found!\n");
+}
+
+static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
+{
+	const struct xdp_desc *rx_desc;
+	struct pollfd fds[rxq + 1];
+	__u64 comp_addr;
+	__u64 addr;
+	__u32 idx;
+	int ret;
+	int i;
+
+	for (i = 0; i < rxq; i++) {
+		fds[i].fd = xsk_socket__fd(rx_xsk[i].socket);
+		fds[i].events = POLLIN;
+		fds[i].revents = 0;
+	}
+
+	fds[rxq].fd = server_fd;
+	fds[rxq].events = POLLIN;
+	fds[rxq].revents = 0;
+
+	while (true) {
+		errno = 0;
+		ret = poll(fds, rxq + 1, 1000);
+		printf("poll: %d (%d)\n", ret, errno);
+		if (ret < 0)
+			break;
+		if (ret == 0)
+			continue;
+
+		if (fds[rxq].revents)
+			verify_skb_metadata(server_fd);
+
+		for (i = 0; i < rxq; i++) {
+			if (fds[i].revents == 0)
+				continue;
+
+			struct xsk *xsk = &rx_xsk[i];
+
+			ret = xsk_ring_cons__peek(&xsk->rx, 1, &idx);
+			printf("xsk_ring_cons__peek: %d\n", ret);
+			if (ret != 1)
+				continue;
+
+			rx_desc = xsk_ring_cons__rx_desc(&xsk->rx, idx);
+			comp_addr = xsk_umem__extract_addr(rx_desc->addr);
+			addr = xsk_umem__add_offset_to_addr(rx_desc->addr);
+			printf("%p: rx_desc[%u]->addr=%llx addr=%llx comp_addr=%llx\n",
+			       xsk, idx, rx_desc->addr, addr, comp_addr);
+			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr));
+			xsk_ring_cons__release(&xsk->rx, 1);
+			refill_rx(xsk, comp_addr);
+		}
+	}
+
+	return 0;
+}
+
+struct ethtool_channels {
+	__u32	cmd;
+	__u32	max_rx;
+	__u32	max_tx;
+	__u32	max_other;
+	__u32	max_combined;
+	__u32	rx_count;
+	__u32	tx_count;
+	__u32	other_count;
+	__u32	combined_count;
+};
+
+#define ETHTOOL_GCHANNELS	0x0000003c /* Get no of channels */
+
+static int rxq_num(const char *ifname)
+{
+	struct ethtool_channels ch = {
+		.cmd = ETHTOOL_GCHANNELS,
+	};
+
+	struct ifreq ifr = {
+		.ifr_data = (void *)&ch,
+	};
+	strcpy(ifr.ifr_name, ifname);
+	int fd, ret;
+
+	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (fd < 0)
+		error(-1, errno, "socket");
+
+	ret = ioctl(fd, SIOCETHTOOL, &ifr);
+	if (ret < 0)
+		error(-1, errno, "socket");
+
+	close(fd);
+
+	return ch.rx_count + ch.combined_count;
+}
+
+static void cleanup(void)
+{
+	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
+	int ret;
+	int i;
+
+	if (bpf_obj) {
+		opts.old_prog_fd = bpf_program__fd(bpf_obj->progs.rx);
+		if (opts.old_prog_fd >= 0) {
+			printf("detaching bpf program....\n");
+			ret = bpf_xdp_detach(ifindex, XDP_FLAGS, &opts);
+			if (ret)
+				printf("failed to detach XDP program: %d\n", ret);
+		}
+	}
+
+	for (i = 0; i < rxq; i++)
+		close_xsk(&rx_xsk[i]);
+
+	if (bpf_obj)
+		xdp_hw_metadata__destroy(bpf_obj);
+}
+
+static void handle_signal(int sig)
+{
+	/* interrupting poll() is all we need */
+}
+
+static void timestamping_enable(int fd, int val)
+{
+	int ret;
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
+	if (ret < 0)
+		error(-1, errno, "setsockopt(SO_TIMESTAMPING)");
+}
+
+int main(int argc, char *argv[])
+{
+	int server_fd = -1;
+	int ret;
+	int i;
+
+	struct bpf_program *prog;
+
+	if (argc != 2) {
+		fprintf(stderr, "pass device name\n");
+		return -1;
+	}
+
+	ifname = argv[1];
+	ifindex = if_nametoindex(ifname);
+	rxq = rxq_num(ifname);
+
+	printf("rxq: %d\n", rxq);
+
+	rx_xsk = malloc(sizeof(struct xsk) * rxq);
+	if (!rx_xsk)
+		error(-1, ENOMEM, "malloc");
+
+	for (i = 0; i < rxq; i++) {
+		printf("open_xsk(%s, %p, %d)\n", ifname, &rx_xsk[i], i);
+		ret = open_xsk(ifname, &rx_xsk[i], i);
+		if (ret)
+			error(-1, -ret, "open_xsk");
+
+		printf("xsk_socket__fd() -> %d\n", xsk_socket__fd(rx_xsk[i].socket));
+	}
+
+	printf("open bpf program...\n");
+	bpf_obj = xdp_hw_metadata__open();
+	if (libbpf_get_error(bpf_obj))
+		error(-1, libbpf_get_error(bpf_obj), "xdp_hw_metadata__open");
+
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
+	bpf_program__set_ifindex(prog, ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
+
+	printf("load bpf program...\n");
+	ret = xdp_hw_metadata__load(bpf_obj);
+	if (ret)
+		error(-1, -ret, "xdp_hw_metadata__load");
+
+	printf("prepare skb endpoint...\n");
+	server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092, 1000);
+	if (server_fd < 0)
+		error(-1, errno, "start_server");
+	timestamping_enable(server_fd,
+			    SOF_TIMESTAMPING_SOFTWARE |
+			    SOF_TIMESTAMPING_RAW_HARDWARE);
+
+	printf("prepare xsk map...\n");
+	for (i = 0; i < rxq; i++) {
+		int sock_fd = xsk_socket__fd(rx_xsk[i].socket);
+		__u32 queue_id = i;
+
+		printf("map[%d] = %d\n", queue_id, sock_fd);
+		ret = bpf_map_update_elem(bpf_map__fd(bpf_obj->maps.xsk), &queue_id, &sock_fd, 0);
+		if (ret)
+			error(-1, -ret, "bpf_map_update_elem");
+	}
+
+	printf("attach bpf program...\n");
+	ret = bpf_xdp_attach(ifindex,
+			     bpf_program__fd(bpf_obj->progs.rx),
+			     XDP_FLAGS, NULL);
+	if (ret)
+		error(-1, -ret, "bpf_xdp_attach");
+
+	signal(SIGINT, handle_signal);
+	ret = verify_metadata(rx_xsk, rxq, server_fd);
+	close(server_fd);
+	cleanup();
+	if (ret)
+		error(-1, -ret, "verify_metadata");
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

