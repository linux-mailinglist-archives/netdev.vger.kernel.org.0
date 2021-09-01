Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42A73FD810
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbhIAKtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhIAKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C693C0617AD;
        Wed,  1 Sep 2021 03:48:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n5so3732090wro.12;
        Wed, 01 Sep 2021 03:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uaulvf/dGdDSmW0mxusxiglw2RgbgacnhYhdb6gP9+8=;
        b=HM/BJfmKQDj5rdztP1MTuE1iVYOND/Wu+FlEPN47rY26p8sp/hG13XxIUSGhqJcrMT
         Y8z4YxuoZM1UTZMTDkeF/ol06LtJaZHtgT3pvuJ6kv4dL/14Xqmu7Zv6cx6kakTXsX9F
         YiRH56EoLuGn5jmm5+q+q8YyvAox62lVG2KDncqKf1qcHnOMMYNt0m0tjN5ylb8bTPXn
         Tyx3XXG+jRstAQenENkD/P3sQ4FwbEsnjbourott6/RjmJY6veSQ77DADjUCJda1d2zO
         6gysDSVv/c+hBvFAjmcnvDto2bejpuyOvho/Pv/43Z86aE0EsMvkVAQKXwy+Tm0L1CL2
         F2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uaulvf/dGdDSmW0mxusxiglw2RgbgacnhYhdb6gP9+8=;
        b=REjLTK0THPLLKzMJ5jTCHtVMA/A1hkpRudqT6MDkFQel7KilFQVokti0ytwKSbirQz
         9v+HNHxkBs56MDkLjGbzX1rUqFelDsAQBPCMdAvzj4iAqmjDWGC7NYq+CD5gLvSYxlRb
         gZEqpmmmQoFC/aMoR8XCjwIjRdq9iOdzCJtmiFc5FKkBcfBwE1eOg3RB1Vp1fgxMF7dM
         DDvB412rKwq49j0z/ZVP7FxKEj4zHb8GOTHkgj4X03R/Bg579m4+tOP04Y9a9kFBK+9v
         9bewg4a1I3CKocmIe0geX6KqMX99TvyhTOmC/TCvAA4eGarn/SpVtY16bF7sa1lBYEgt
         ugRQ==
X-Gm-Message-State: AOAM532xM32k1ahb9po45XGwI6LZIC4Zbzx8C2Rj2bXm+4DyTjb8tp7H
        yuHh1ZifKJ6fcqeXQ1aJ/nc=
X-Google-Smtp-Source: ABdhPJzRmfhST8YXeCbe+om1NKk0maID0DyoXpkAYJw+z3HawYYc4+KwgVJ55cHvoLJlqXfDZcEA1g==
X-Received: by 2002:adf:c381:: with SMTP id p1mr36884156wrf.163.1630493287885;
        Wed, 01 Sep 2021 03:48:07 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:07 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 06/20] selftests: xsk: make frame_size configurable
Date:   Wed,  1 Sep 2021 12:47:18 +0200
Message-Id: <20210901104732.10956-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
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

