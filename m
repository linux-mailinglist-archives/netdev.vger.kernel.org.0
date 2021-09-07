Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5972C402405
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbhIGHVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbhIGHVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D918BC061575;
        Tue,  7 Sep 2021 00:19:59 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q26so11982281wrc.7;
        Tue, 07 Sep 2021 00:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uaulvf/dGdDSmW0mxusxiglw2RgbgacnhYhdb6gP9+8=;
        b=HT9Yp98kd9wVy5gtpQzG76VKXDRxakUlzqV36if15mQQRVpSjQ64cxwbo0WSpb3B8S
         BvhAfUr5Ga/Wy2XcX8QeOlnM5tQf3GqTJyRsa+r7XqQJ+925DubX94WXSIOLgdAKHpbq
         Ls2K5MBmEqALPBdttHRMjWIX9RVsYyunNY92Rz3SbKYiWChhwlOCywuLl94T6uovP9TN
         vzOI3spyKH8FFJh2S83M+YzrFDwbFzgS90LunynhvPRVJzbhZ5RRl999xJmLlte5HTfw
         JFC1zGP0B1v7r/LxkdzhWh2TpyJ7al2AxtwiRcowTvHl7i4dJr7SUmTW+8Dk1r4Wzpm7
         gj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uaulvf/dGdDSmW0mxusxiglw2RgbgacnhYhdb6gP9+8=;
        b=IImEVO0n47yI5ycRFSRwerP3BAxVCG3axeDNk4e6gU6KiQQCtpYFlttYEvAPem1JK7
         ZmCRRXsJjVknhHl73WG1NU+uw/sb3XFBfeX100jgfJVk4iVmjUgkC2mlxXl1jSTx5w+L
         LYSAM7pt7n/00Fu14rBlE6OA9e1NNKPqQCmf7CYHxSAWUA78HPsktxoEwgd7DmG8OdNS
         Jrd64fX8aqPXqi5dbhvyD9i8fWVZI4Qiqr2GxM1/D31mZfsCqCfqU/jbnGejjAJzp069
         qGQgE5f6fskd86N+H9PtBSHvgQHbpZspWjI+QV7TMo8LQLxNvIVEHw2uY42gdnuc7u7f
         Y/hQ==
X-Gm-Message-State: AOAM531LTe/HCDez0hViU8gBpzmkEyss6vPTmt2++VgXVxKsM2ckh761
        pW9a05jE5G0SD8WmVMpAKUU=
X-Google-Smtp-Source: ABdhPJyHAlvdQIVF+olWQ806OhoiztaksGqLyMVV0Ve2uChtTHGokT0qNyqSP/P5RWxTDYAFkHqiCg==
X-Received: by 2002:adf:82a9:: with SMTP id 38mr17201833wrc.82.1630999198436;
        Tue, 07 Sep 2021 00:19:58 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.19.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:19:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 06/20] selftests: xsk: make frame_size configurable
Date:   Tue,  7 Sep 2021 09:19:14 +0200
Message-Id: <20210907071928.9750-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the frame size configurable instead of it being hard coded to a
default. This is a property of the umem and will make it possible to
implement tests for different umem frame sizes in a later patch.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 11 ++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 28bf62c56190..79cf082a7581 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -240,7 +240,7 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
-		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
+		.frame_size = umem->frame_size,
 		.frame_headroom = umem->frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
@@ -264,7 +264,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
 		exit_with_error(-ret);
 	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
-		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * XSK_UMEM__DEFAULT_FRAME_SIZE;
+		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * umem->frame_size;
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
 }
 
@@ -407,6 +407,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
 			ifobj->umem_arr[j].num_frames = DEFAULT_PKT_CNT / 4;
+			ifobj->umem_arr[j].frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 			ifobj->xsk_arr[j].rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		}
 	}
@@ -450,7 +451,7 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 
 	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = (i % umem->num_frames) * XSK_UMEM__DEFAULT_FRAME_SIZE;
+		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
 	}
@@ -768,7 +769,7 @@ static void tx_stats_validate(struct ifobject *ifobject)
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
-	u64 umem_sz = ifobject->umem->num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	size_t mmap_sz = umem_sz;
 	int ctr = 0, ret;
@@ -991,7 +992,7 @@ static void testapp_stats(struct test_spec *test)
 
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
-			test->ifobj_rx->umem->frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
+			test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 				XDP_PACKET_HEADROOM - 1;
 			break;
 		case STAT_TEST_RX_FULL:
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 09e4e015b1bf..bfd14190abfc 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -87,6 +87,7 @@ struct xsk_umem_info {
 	u32 num_frames;
 	u32 frame_headroom;
 	void *buffer;
+	u32 frame_size;
 };
 
 struct xsk_socket_info {
-- 
2.29.0

