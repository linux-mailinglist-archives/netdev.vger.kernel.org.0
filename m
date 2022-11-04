Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0775618F03
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiKDD1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiKDD0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A629625C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:46 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id k11-20020aa792cb000000b00558674e8e7fso1696177pfa.6
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TF3gnikwGWod7jyf9S0gnIr/jNh+FCDx9Jkdj/Kkpp8=;
        b=ZPiJVlIzPI5tA0QTNExoYHzEBc/nx437ZSrPWy8j5UsaJ4xbuf1R0TcuFPw7kds5Bz
         MQFu+FNjclu6+NMW0VYJTgios2noZ90uFH1q3HrfIJZbLg2bQPx70qOQUyt9jOze15qv
         oPVmRQEibrzqOmxm7LOkSk18Z+r2hgH0u1lGHbpfuQ3rpkx8v0o2MR83gBRzPKYqqE0D
         +cBbKSplpgYDuaRSACgYzWCotXaPbt+sOeiOD7bz4uIeYbfoy457pvfhMxhGj1p8LhcA
         jAFv/tr82+ivOJQgut0fRCmOiBHZUEdDgPTqbnOJ29nug2VOdZ/QI2JgW0kkQBmVIkNW
         8R9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TF3gnikwGWod7jyf9S0gnIr/jNh+FCDx9Jkdj/Kkpp8=;
        b=6hdbQIzJSmLNfZ+kMKP7LLJwecMEjT/KJe8OTCMizxzS97qW3Nhs69LXfds9X1EAow
         U+SMw0xK77oi2mF714mKK+16cnBv2iZAk5EjcHuE/NbqE4J3oho/JCU1M7PGtBoq+Jtd
         Dc1iXD0hzhSbzG2zcm7IkmlYtYzxqul81+qbeiuAIj9IKCOhQik8Smu8cFRy/SXmkPFS
         aFPioRzWmwHhAorima+omA51heewEPmrafd4upIUQamslmqsgwO1g2K9VE6hswZ3/jmf
         5vKl8TtpZwFjUlo9Z9h0xtV/OZkttKi14sJkbn8tJR2fiUc/zlIZ54+dmOfZK3GmUivz
         9gVA==
X-Gm-Message-State: ACrzQf0imjGZlNC8qwQhYcShR0QIQ3uWViQpwpRtg0KjZtXMACAWwFKq
        695Su4IGRYJpLUWeQyGJLZwionU=
X-Google-Smtp-Source: AMsMyM4l+bXmf0a0f9swdUoqCtFk/7uqXEnZQd/v+Q165X7IlFkSyIXQ5nAVRxZjbxzqkdcPXJjmU8c=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:4c84:b0:565:f8bb:96f8 with SMTP id
 eb4-20020a056a004c8400b00565f8bb96f8mr249640pfb.45.1667532346122; Thu, 03 Nov
 2022 20:25:46 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:25 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-8-sdf@google.com>
Subject: [RFC bpf-next v2 07/14] selftests/bpf: Verify xdp_metadata xdp->skb path
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
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 92 +++++++++++++++++++
 .../selftests/bpf/progs/xdp_metadata.c        | 28 ++++++
 2 files changed, 120 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index bb06e25fb2bb..96cc6d7697f8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -19,6 +19,11 @@
 
 #define AF_XDP_SOURCE_PORT 1234
 #define AF_XDP_CONSUMER_PORT 8080
+#define SOCKET_CONSUMER_PORT 9081
+
+#ifndef SOL_UDP
+#define SOL_UDP		17
+#endif
 
 #define UMEM_NUM 16
 #define UMEM_FRAME_SIZE XSK_UMEM__DEFAULT_FRAME_SIZE
@@ -221,6 +226,71 @@ int verify_xsk_metadata(struct xsk *xsk)
 	return 0;
 }
 
+static void disable_rx_checksum(int fd)
+{
+	int ret, val;
+
+	val = 1;
+	ret = setsockopt(fd, SOL_UDP, UDP_NO_CHECK6_RX, &val, sizeof(val));
+	ASSERT_OK(ret, "setsockopt(UDP_NO_CHECK6_RX)");
+}
+
+static void timestamping_enable(int fd)
+{
+	int ret, val;
+
+	val = SOF_TIMESTAMPING_SOFTWARE | SOF_TIMESTAMPING_RAW_HARDWARE;
+	ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
+	ASSERT_OK(ret, "setsockopt(SO_TIMESTAMPING)");
+}
+
+int verify_skb_metadata(int fd)
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
@@ -228,6 +298,7 @@ void test_xdp_metadata(void)
 	struct bpf_program *prog;
 	struct xsk tx_xsk = {};
 	struct xsk rx_xsk = {};
+	int rx_udp_fd = -1;
 	int rx_ifindex;
 	int ret;
 
@@ -243,6 +314,8 @@ void test_xdp_metadata(void)
 	SYS("ip link set dev " RX_NAME " up");
 	SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
 	SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
+	SYS("sysctl -q net.ipv4.ip_forward=1");
+	SYS("sysctl -q net.ipv4.conf.all.accept_local=1");
 
 	rx_ifindex = if_nametoindex(RX_NAME);
 
@@ -256,6 +329,14 @@ void test_xdp_metadata(void)
 	if (!ASSERT_OK(ret, "open_xsk(RX_NAME)"))
 		goto out;
 
+	/* Setup UPD listener for RX interface. */
+
+	rx_udp_fd = start_server(FAMILY, SOCK_DGRAM, NULL, SOCKET_CONSUMER_PORT, 1000);
+	if (!ASSERT_GE(rx_udp_fd, 0, "start_server"))
+		goto out;
+	disable_rx_checksum(rx_udp_fd);
+	timestamping_enable(rx_udp_fd);
+
 	/* Attach BPF program to RX interface. */
 
 	bpf_obj = xdp_metadata__open();
@@ -291,9 +372,20 @@ void test_xdp_metadata(void)
 		       "verify_xsk_metadata"))
 	    goto out;
 
+	/* Send packet destined to RX UDP socket. */
+	if (!ASSERT_GE(generate_packet(&tx_xsk, SOCKET_CONSUMER_PORT), 0,
+		       "generate SOCKET_CONSUMER_PORT"))
+	    goto out;
+
+	/* Verify SKB RX packet has proper metadata. */
+	if (!ASSERT_GE(verify_skb_metadata(rx_udp_fd), 0,
+		       "verify_skb_metadata"))
+	    goto out;
+
 out:
 	close_xsk(&rx_xsk);
 	close_xsk(&tx_xsk);
+	close(rx_udp_fd);
 	if (bpf_obj)
 		xdp_metadata__destroy(bpf_obj);
 	system("ip netns del xdp_metadata");
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata.c b/tools/testing/selftests/bpf/progs/xdp_metadata.c
index bdde17961ab6..6e7292c58b86 100644
--- a/tools/testing/selftests/bpf/progs/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata.c
@@ -17,6 +17,7 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+extern void bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx) __ksym;
 extern int bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx) __ksym;
 extern const __u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx) __ksym;
 
@@ -24,8 +25,35 @@ SEC("xdp")
 int rx(struct xdp_md *ctx)
 {
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
+		bpf_xdp_metadata_export_to_skb(ctx);
+		bpf_printk("exporting metadata to skb for UDP port 9081");
+		/*return bpf_redirect(ifindex, BPF_F_INGRESS);*/
+		return XDP_PASS;
+	}
+
 	if (bpf_xdp_metadata_rx_timestamp_supported(ctx)) {
 		__u64 rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
 
-- 
2.38.1.431.g37b22c650d-goog

