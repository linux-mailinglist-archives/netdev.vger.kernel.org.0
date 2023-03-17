Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB266BEB65
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCQOed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCQOeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:34:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD39BBB02
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679063610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8vU6UTCNa8VLC8bUbVAeQYsbfM406BB8QmE6QLJEh6w=;
        b=JLC6xxr6Qg8COFlHQ5yXedU7PkaghFLWeVIulhtV4TpSLqGJvh4amfd8oy1EXYRyuu3Gba
        2UXKxy4DA0SSiH3+fGhwzzYZev3ezePbMEcJaVeKzSJAXthI9WSwPbnE5ckb9v9DnKTAOp
        Je80N4WhTwXMxfFI6NVpTjaJflOl8bk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-fryAJ0AkMwCi0ppcf7JfEQ-1; Fri, 17 Mar 2023 10:33:27 -0400
X-MC-Unique: fryAJ0AkMwCi0ppcf7JfEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E12B1185A78B;
        Fri, 17 Mar 2023 14:33:26 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77F00140E95F;
        Fri, 17 Mar 2023 14:33:26 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E346B30721A6C;
        Fri, 17 Mar 2023 15:33:25 +0100 (CET)
Subject: [PATCH bpf-next V1 3/7] selftests/bpf: xdp_hw_metadata track more
 timestamps
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com
Date:   Fri, 17 Mar 2023 15:33:25 +0100
Message-ID: <167906360589.2706833.6188844928251441787.stgit@firesoul>
In-Reply-To: <167906343576.2706833.17489167761084071890.stgit@firesoul>
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To correlate the hardware RX timestamp with something, add tracking of
two software timestamps both clock source CLOCK_TAI (see description in
man clock_gettime(2)).

XDP metadata is extended with xdp_timestamp for capturing when XDP
received the packet. Populated with BPF helper bpf_ktime_get_tai_ns(). I
could not find a BPF helper for getting CLOCK_REALTIME, which would have
been preferred. In userspace when AF_XDP sees the packet another
software timestamp is recorded via clock_gettime() also clock source
CLOCK_TAI.

Example output shortly after loading igc driver:

  poll: 1 (0)
  xsk_ring_cons__peek: 1
  0x11fc958: rx_desc[7]->addr=10000000000f000 addr=f100 comp_addr=f000
  rx_hash: 0x00000000
  rx_timestamp:  1676297171760293047 (sec:1676297171.7603)
  XDP RX-time:   1676297208760355863 (sec:1676297208.7604) delta sec:37.0001
  AF_XDP time:   1676297208760416292 (sec:1676297208.7604) delta sec:0.0001 (60.429 usec)
  0x11fc958: complete idx=15 addr=f000

The first observation is that the 37 sec difference between RX HW vs XDP
timestamps, which indicate hardware is likely clock source
CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
with a 37 sec offset.

The 60 usec (microsec) difference between XDP vs AF_XDP userspace is the
userspace wakeup time. On this hardware it was caused by CPU idle sleep
states, which can be reduced by tuning /dev/cpu_dma_latency.

View current requested/allowed latency bound via:
  hexdump --format '"%d\n"' /dev/cpu_dma_latency

More explanation of the output and how this can be used to identify
clock drift for the HW clock can be seen here[1]:

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    8 ++-
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |   46 ++++++++++++++++++--
 tools/testing/selftests/bpf/xdp_metadata.h         |    1 
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 4c55b4d79d3d..f2a3b70a9882 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -69,9 +69,11 @@ int rx(struct xdp_md *ctx)
 		return XDP_PASS;
 	}
 
-	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
-		bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
-	else
+	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp)) {
+		meta->xdp_timestamp = bpf_ktime_get_tai_ns();
+		bpf_printk("populated rx_timestamp with  %llu", meta->rx_timestamp);
+		bpf_printk("populated xdp_timestamp with %llu", meta->xdp_timestamp);
+	} else
 		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
 
 	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 1c8acb68b977..400bfe19abfe 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -27,6 +27,7 @@
 #include <sys/mman.h>
 #include <net/if.h>
 #include <poll.h>
+#include <time.h>
 
 #include "xdp_metadata.h"
 
@@ -134,14 +135,47 @@ static void refill_rx(struct xsk *xsk, __u64 addr)
 	}
 }
 
-static void verify_xdp_metadata(void *data)
+#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
+static __u64 gettime(clockid_t clock_id)
+{
+	struct timespec t;
+	int res;
+
+	/* See man clock_gettime(2) for type of clock_id's */
+	res = clock_gettime(clock_id, &t);
+
+	if (res < 0)
+		error(res, errno, "Error with clock_gettime()");
+
+	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
+}
+
+static void verify_xdp_metadata(void *data, clockid_t clock_id)
 {
 	struct xdp_meta *meta;
 
 	meta = data - sizeof(*meta);
 
-	printf("rx_timestamp: %llu\n", meta->rx_timestamp);
 	printf("rx_hash: %u\n", meta->rx_hash);
+	printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
+	       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
+	if (meta->rx_timestamp) {
+		__u64 usr_clock = gettime(clock_id);
+		__u64 xdp_clock = meta->xdp_timestamp;
+		__s64 delta_X = xdp_clock - meta->rx_timestamp;
+		__s64 delta_X2U = usr_clock - xdp_clock;
+
+		printf("XDP RX-time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f usec)\n",
+		       xdp_clock, (double)xdp_clock / NANOSEC_PER_SEC,
+		       (double)delta_X / NANOSEC_PER_SEC,
+		       (double)delta_X / 1000);
+
+		printf("AF_XDP time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f usec)\n",
+		       usr_clock, (double)usr_clock / NANOSEC_PER_SEC,
+		       (double)delta_X2U / NANOSEC_PER_SEC,
+		       (double)delta_X2U / 1000);
+	}
+
 }
 
 static void verify_skb_metadata(int fd)
@@ -189,7 +223,7 @@ static void verify_skb_metadata(int fd)
 	printf("skb hwtstamp is not found!\n");
 }
 
-static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
+static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t clock_id)
 {
 	const struct xdp_desc *rx_desc;
 	struct pollfd fds[rxq + 1];
@@ -237,7 +271,8 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
 			addr = xsk_umem__add_offset_to_addr(rx_desc->addr);
 			printf("%p: rx_desc[%u]->addr=%llx addr=%llx comp_addr=%llx\n",
 			       xsk, idx, rx_desc->addr, addr, comp_addr);
-			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr));
+			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr),
+					    clock_id);
 			xsk_ring_cons__release(&xsk->rx, 1);
 			refill_rx(xsk, comp_addr);
 		}
@@ -364,6 +399,7 @@ static void timestamping_enable(int fd, int val)
 
 int main(int argc, char *argv[])
 {
+	clockid_t clock_id = CLOCK_TAI;
 	int server_fd = -1;
 	int ret;
 	int i;
@@ -437,7 +473,7 @@ int main(int argc, char *argv[])
 		error(1, -ret, "bpf_xdp_attach");
 
 	signal(SIGINT, handle_signal);
-	ret = verify_metadata(rx_xsk, rxq, server_fd);
+	ret = verify_metadata(rx_xsk, rxq, server_fd, clock_id);
 	close(server_fd);
 	cleanup();
 	if (ret)
diff --git a/tools/testing/selftests/bpf/xdp_metadata.h b/tools/testing/selftests/bpf/xdp_metadata.h
index f6780fbb0a21..260345b2c6f1 100644
--- a/tools/testing/selftests/bpf/xdp_metadata.h
+++ b/tools/testing/selftests/bpf/xdp_metadata.h
@@ -11,5 +11,6 @@
 
 struct xdp_meta {
 	__u64 rx_timestamp;
+	__u64 xdp_timestamp;
 	__u32 rx_hash;
 };


