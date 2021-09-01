Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8A3FD808
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbhIAKtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbhIAKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD32CC0617A8;
        Wed,  1 Sep 2021 03:48:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i6so3835742wrv.2;
        Wed, 01 Sep 2021 03:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=obBkzebWL7uuIG+0NdExWZj3JRncqJP+NsVPCtUWNb8=;
        b=T9DokBKICl4BuLx8iUj8PQdRcCJsqmbEW7UHRxag1YTr9bdXJvvYMT90qVASENM0zf
         e2k6f+lbGRtoHR/yNrUvcXsZa0n8LWZJibWNV7lFGrc/CO9P+MpxdjhMhPIiTgIBv7Oc
         AVOBajKm9M5Il2SN/PmTMk5kVDA2d/9aif0KWJJ5MFuwqLqrNuP0p7H5zBfc82OmvFWc
         Kgm5T53UWxPTc/VK/9SuPU7ZqoW7UlDS8SMMkBWPUVuVLukuB90V/HghX/pUfLqeOes+
         Ojqk3jr+2NlTbpIUYbADdEbBQ5lvQTeWtV/9J6Q6gFbxFEUEOT5WsRMC7XIe30N2LkEr
         iHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=obBkzebWL7uuIG+0NdExWZj3JRncqJP+NsVPCtUWNb8=;
        b=EgVykYUZ6MAjrYTsnU7cnElDUuoPG01GQTvlAnMEZzWQvvRr6RWPx9byQSk4AuCp1r
         xLq5modWrPPMs/dRbuisMXFE8tlqhY6OJIfIOKrtmM6Doli1/rxz/YbuMhoQ75oVUJ4s
         a4lMemXjloCMbbignKRxjMRIxZrx85tOo+ag5mmRRtMmaW2RRNlWWxblxm1hjoFVziZx
         6rT1FSkwQi7NBiaNzTq336pGts9m3ybI2ePMPuLNNKKk8bFaQg2ZsJiwdGa2XiSEkARg
         TwKxAijb6WsMC1aOjLcmkJnT1UIeRc3po20S4neHwQsJuSon21c30Py8opa4htbLsD2n
         CQUg==
X-Gm-Message-State: AOAM532UipbPyzirfTZt4SoUkv3FzLo7xF4IvN+dwuKUQdTdP8OjZv8L
        YB9j8vEjthoww9NvzD5ZFcg=
X-Google-Smtp-Source: ABdhPJyfXASWKgD5jqjEc0eP6PNDITKN/a/sJZbIbXqasjSzbbTMaozfhA8wBQMrapav4UNXTVECAw==
X-Received: by 2002:adf:de8f:: with SMTP id w15mr36836167wrl.277.1630493286347;
        Wed, 01 Sep 2021 03:48:06 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:05 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 05/20] selftests: xsk: move rxqsize into xsk_socket_info
Date:   Wed,  1 Sep 2021 12:47:17 +0200
Message-Id: <20210901104732.10956-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move the global variable rxqsize to struct xsk_socket_info as it
describes the size of a ring in that struct. By default, it is set to
the size dictated by libbpf.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 9 +++------
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 56ee03fda2b3..28bf62c56190 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -276,7 +276,7 @@ static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_inf
 	struct xsk_ring_prod *txr;
 
 	xsk->umem = umem;
-	cfg.rx_size = rxqsize;
+	cfg.rx_size = xsk->rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
 	cfg.xdp_flags = xdp_flags;
@@ -407,6 +407,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
 			ifobj->umem_arr[j].num_frames = DEFAULT_PKT_CNT / 4;
+			ifobj->xsk_arr[j].rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		}
 	}
 
@@ -988,16 +989,13 @@ static void testapp_stats(struct test_spec *test)
 		test_spec_reset(test);
 		stat_test_type = i;
 
-		/* reset defaults */
-		rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
-
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
 			test->ifobj_rx->umem->frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
 				XDP_PACKET_HEADROOM - 1;
 			break;
 		case STAT_TEST_RX_FULL:
-			rxqsize = RX_FULL_RXQSIZE;
+			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
 			break;
 		case STAT_TEST_TX_INVALID:
 			continue;
@@ -1040,7 +1038,6 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	second_step = 0;
 	stat_test_type = -1;
-	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 
 	configured_mode = mode;
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0d93a9e6c4f3..09e4e015b1bf 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -79,7 +79,6 @@ static bool opt_verbose;
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static int stat_test_type;
-static u32 rxqsize;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
@@ -96,6 +95,7 @@ struct xsk_socket_info {
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
 	u32 outstanding_tx;
+	u32 rxqsize;
 };
 
 struct flow_vector {
-- 
2.29.0

