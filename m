Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998BE62906B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbiKODEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiKODDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23C5632C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b17-20020a25b851000000b006e32b877068so2509277ybm.16
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CV+ux64Yz/p8PbqeYErWoR4W7lQkYoTRnhtVk1Wew7Y=;
        b=eUncWoSj5O1GYNCspMAYqmCjK/FWf1UZw3zoAORdmuZG7QTquFDzO6zWKsUJcKj+H+
         pbxqA5XdhYr2KQ5991WjlPJShCYX1uDmCvK1tCMMdE3PTZ27vdmaqIXEBnq6u8fm28kH
         KhGRK9rLIP3L9JmAvuJjFWLytbn5Hg6eSQICJG4AFEu6HbHJJlaPl3IJWTPWPHRoNgdH
         rdB+CNOgjj+ybf5otV9GOUs/EQVKAWKLNoxXyIqqA207BrLhpJW+h3ZfuSd3ZR07RmNX
         OW23rVd7+lihzHMW85LBAZ9+606kFJTxUcOLHwKAWLM+3G6WD3OrlaGft1cQsmWx6EI9
         beOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CV+ux64Yz/p8PbqeYErWoR4W7lQkYoTRnhtVk1Wew7Y=;
        b=kLlD9dHOuCjzjPbS1th6kDNsk0Jri96VgMXiU7b3LxPKuuKhJBoCqEa74F/DlRS8N1
         7DEZrvwVL0cBiTe2Zxb1dgeU8G2NmyIjszlChxhwlLzHqLkaoMEiSJ7ll1YO8Wycsdq3
         4h+R9sJBekHjytUPfExM5xiAUQEWwRNxM9kop2m0X3qbdrcwkGR/kicU/neycS1dL8qT
         GGukzX696RKMx8EP1iBpKBTX5xYwgknr3TLK3bAxEm532Ev6MiqB5hX8UrbR73hUmafr
         43CxEs7TRInUXxFoUcFRQA1U4YqmEVavK3onwADxSZt4Ih0EJLr/3iMqe6X9cp6NLP0K
         dp/Q==
X-Gm-Message-State: ANoB5pmBicnhx6ZguFAIVUnoCturfNO2NSKsRkJYB7cMk69njkE0yjuZ
        FLILEnBeYuC2k8RyRuKicZFOFdw=
X-Google-Smtp-Source: AA0mqf4fBbV0SFVoUuVo9AbyfvFGdXZcqlX0LNz/GVLq7+TTC3UyY1hvvh/e/EnW2IRoxnckAqvzkgc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:ac06:0:b0:356:d0ed:6a79 with SMTP id
 k6-20020a81ac06000000b00356d0ed6a79mr15488016ywh.489.1668481346098; Mon, 14
 Nov 2022 19:02:26 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:07 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-9-sdf@google.com>
Subject: [PATCH bpf-next 08/11] selftests/bpf: Verify xdp_metadata xdp->skb path
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

- divert 9081 UDP traffic to the kernel
- call bpf_xdp_metadata_export_to_skb for such packets
- the kernel should fill in hwtstamp
- verify that the received packet has non-zero hwtstamp

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
 tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 81 +++++++++++++++++++
 .../selftests/bpf/progs/xdp_metadata.c        | 64 +++++++++++++++
 3 files changed, 146 insertions(+)

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index be4e3d47ea3e..2fa350c8ab42 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -78,4 +78,5 @@ xdp_adjust_tail                          # case-128 err 0 errno 28 retval 1 size
 xdp_bonding                              # failed to auto-attach program 'trace_on_entry': -524                        (trampoline)
 xdp_bpf2bpf                              # failed to auto-attach program 'trace_on_entry': -524                        (trampoline)
 xdp_do_redirect                          # prog_run_max_size unexpected error: -22 (errno 22)
+xdp_metadata                             # JIT does not support push/pop opcodes                                       (jit)
 xdp_synproxy                             # JIT does not support calling kernel function                                (kfunc)
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index c3321d8c7cd4..b67a4dcfca6e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -19,6 +19,7 @@
 
 #define AF_XDP_SOURCE_PORT 1234
 #define AF_XDP_CONSUMER_PORT 8080
+#define SOCKET_CONSUMER_PORT 9081
 
 #define UMEM_NUM 16
 #define UMEM_FRAME_SIZE XSK_UMEM__DEFAULT_FRAME_SIZE
@@ -275,6 +276,61 @@ static int verify_xsk_metadata(struct xsk *xsk)
 	return 0;
 }
 
+static void timestamping_enable(int fd, int val)
+{
+	int ret;
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
+	ASSERT_OK(ret, "setsockopt(SO_TIMESTAMPING)");
+}
+
+static int verify_skb_metadata(int fd)
+{
+	char cmsg_buf[1024];
+	char packet_buf[128];
+
+	struct scm_timestamping *ts;
+	struct iovec packet_iov;
+	struct cmsghdr *cmsg;
+	struct msghdr hdr;
+	bool found_hwtstamp = false;
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
+	if (ASSERT_GE(recvmsg(fd, &hdr, 0), 0, "recvmsg")) {
+		for (cmsg = CMSG_FIRSTHDR(&hdr); cmsg != NULL;
+		     cmsg = CMSG_NXTHDR(&hdr, cmsg)) {
+
+			if (cmsg->cmsg_level != SOL_SOCKET)
+				continue;
+
+			switch (cmsg->cmsg_type) {
+			case SCM_TIMESTAMPING:
+				ts = (struct scm_timestamping *)CMSG_DATA(cmsg);
+				if (ts->ts[2].tv_sec || ts->ts[2].tv_nsec) {
+					found_hwtstamp = true;
+					break;
+				}
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	if (!ASSERT_EQ(found_hwtstamp, true, "no hwtstamp!"))
+		return -1;
+
+	return 0;
+}
+
 void test_xdp_metadata(void)
 {
 	struct xdp_metadata *bpf_obj = NULL;
@@ -283,6 +339,7 @@ void test_xdp_metadata(void)
 	struct bpf_program *prog;
 	struct xsk tx_xsk = {};
 	struct xsk rx_xsk = {};
+	int rx_udp_fd = -1;
 	int rx_ifindex;
 	int sock_fd;
 	int ret;
@@ -299,6 +356,8 @@ void test_xdp_metadata(void)
 	SYS("ip link set dev " RX_NAME " up");
 	SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
 	SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
+	SYS("sysctl -q net.ipv4.ip_forward=1");
+	SYS("sysctl -q net.ipv4.conf.all.accept_local=1");
 
 	rx_ifindex = if_nametoindex(RX_NAME);
 
@@ -312,6 +371,15 @@ void test_xdp_metadata(void)
 	if (!ASSERT_OK(ret, "open_xsk(RX_NAME)"))
 		goto out;
 
+	/* Setup UPD listener for RX interface. */
+
+	rx_udp_fd = start_server(FAMILY, SOCK_DGRAM, NULL, SOCKET_CONSUMER_PORT, 1000);
+	if (!ASSERT_GE(rx_udp_fd, 0, "start_server"))
+		goto out;
+	timestamping_enable(rx_udp_fd,
+			    SOF_TIMESTAMPING_SOFTWARE |
+			    SOF_TIMESTAMPING_RAW_HARDWARE);
+
 	/* Attach BPF program to RX interface. */
 
 	bpf_obj = xdp_metadata__open();
@@ -348,9 +416,22 @@ void test_xdp_metadata(void)
 
 	complete_tx(&tx_xsk);
 
+	/* Send packet destined to RX UDP socket. */
+	if (!ASSERT_GE(generate_packet(&tx_xsk, SOCKET_CONSUMER_PORT), 0,
+		       "generate SOCKET_CONSUMER_PORT"))
+		goto out;
+
+	/* Verify SKB RX packet has proper metadata. */
+	if (!ASSERT_GE(verify_skb_metadata(rx_udp_fd), 0,
+		       "verify_skb_metadata"))
+		goto out;
+
+	complete_tx(&tx_xsk);
+
 out:
 	close_xsk(&rx_xsk);
 	close_xsk(&tx_xsk);
+	close(rx_udp_fd);
 	if (bpf_obj)
 		xdp_metadata__destroy(bpf_obj);
 	system("ip netns del xdp_metadata");
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata.c b/tools/testing/selftests/bpf/progs/xdp_metadata.c
index bdde17961ab6..805178f55743 100644
--- a/tools/testing/selftests/bpf/progs/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata.c
@@ -17,15 +17,79 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+extern int bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx) __ksym;
 extern int bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx) __ksym;
 extern const __u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx) __ksym;
 
 SEC("xdp")
 int rx(struct xdp_md *ctx)
 {
+	struct xdp_skb_metadata *skb_metadata;
 	void *data, *data_meta;
+	struct ethhdr *eth = NULL;
+	struct udphdr *udp = NULL;
+	struct iphdr *iph = NULL;
+	void *data_end;
 	int ret;
 
+	/* Exercise xdp -> skb metadata path by diverting some traffic
+	 * into the kernel (UDP destination port 9081).
+	 */
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
+		if (udp && udp + 1 > data_end)
+			udp = NULL;
+	}
+	if (udp && udp->dest == bpf_htons(9081)) {
+		bpf_printk("exporting metadata to skb for UDP port 9081");
+
+		if (bpf_xdp_metadata_export_to_skb(ctx) < 0) {
+			bpf_printk("bpf_xdp_metadata_export_to_skb failed");
+			return XDP_DROP;
+		}
+
+		/* Make sure metadata can't be adjusted after a call
+		 * to bpf_xdp_metadata_export_to_skb().
+		 */
+
+		ret = bpf_xdp_adjust_meta(ctx, -4);
+		if (ret == 0) {
+			bpf_printk("bpf_xdp_adjust_meta -4 after bpf_xdp_metadata_export_to_skb succeeded");
+			return XDP_DROP;
+		}
+
+		/* Make sure calling bpf_xdp_metadata_export_to_skb()
+		 * second time is a no-op.
+		 */
+
+		if (bpf_xdp_metadata_export_to_skb(ctx) == 0) {
+			bpf_printk("bpf_xdp_metadata_export_to_skb succeeded 2nd time");
+			return XDP_DROP;
+		}
+
+		skb_metadata = ctx->skb_metadata;
+		if (!skb_metadata) {
+			bpf_printk("no ctx->skb_metadata");
+			return XDP_DROP;
+		}
+
+		if (!skb_metadata->rx_timestamp) {
+			bpf_printk("no skb_metadata->rx_timestamp");
+			return XDP_DROP;
+		}
+
+		/*return bpf_redirect(ifindex, BPF_F_INGRESS);*/
+		return XDP_PASS;
+	}
+
 	if (bpf_xdp_metadata_rx_timestamp_supported(ctx)) {
 		__u64 rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
 
-- 
2.38.1.431.g37b22c650d-goog

