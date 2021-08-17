Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCE3EE9C9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhHQJ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhHQJ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:38 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0C6C06179A;
        Tue, 17 Aug 2021 02:29:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x10so21259449wrt.8;
        Tue, 17 Aug 2021 02:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FkSX+q6lNV8RfsiU+JBNPDdX/Xw/Tk761bFEK2gJIzY=;
        b=FpVLi6qPvx9OkgFE6UIBxN5B5FxsqDpSGF/QFgeD70n+0Wlsetgxr8dJ129/9+qSsB
         uZidJ5YbiioFK1Bx1Ba/WxRfdcmP0qmjCJ3n+N8C8GFTh7GfAHtWOo8pW5m/Cij4lyOt
         jdtvX74DmEIUf9sYdsWNjqaVi7/qNcPgg6Acckujw3fbyH/cJSiyACPn+eP/dKdP/su1
         d3My8o3oddwLJnEQiWMLh4DErHZ1kiLR2/iR0m6pDJZGfpTkZZOq7/aeWR+Oxp+M4IL9
         jY1IvPJbPvSSZzLGtMexx9/2BOZGWSckRR5A5Ce/2OZABij2zbASZ65WWDlkd3XYKD0q
         pz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FkSX+q6lNV8RfsiU+JBNPDdX/Xw/Tk761bFEK2gJIzY=;
        b=YBhOStwuD2RZxqeYvtM8uT6ZUubf2NrIUcGbzrCTPQ0XCWyJnlIqABOVrukXUN9Wk1
         GHDgf1U+gjcU5ICtbHLPnwMuJyDU8mpfX2ZJZT2pO4Bn3yt7WilrHoqc0VxS2ekQdnuJ
         wownbaqIvyX1sa1V23cUMq7BkO4zxN2UO/TO21NpEBVWl7Rouh7UMKO+lpAo6mvuuIsr
         aNqeHICNLdwstybT0N/ZmD0jGHL83UJjT505mAuzyO+XKnnAzgKkunxCRv0K3ZrQ3iBT
         ElvqqkVIsmbqRTrVVT2g17fnhFTMws9z3AxsitCeCt3ihzmwIY2XW3Mby3lMhE3M00P2
         9TDw==
X-Gm-Message-State: AOAM531ZUJr528/Rhu3Uvw3y+AShgaQ3hKNjgnkWwd5XrtjyH59EzFWT
        AhTipPVm/x+oKy93fEJJEUw=
X-Google-Smtp-Source: ABdhPJwgtNw5u0soa7O9VF+alhTM1lF3WRTUwi5los7x1h1sjhn/zCif9R7KFZsXZq17G26FzzhNKw==
X-Received: by 2002:a5d:4d4b:: with SMTP id a11mr2764808wru.411.1629192543447;
        Tue, 17 Aug 2021 02:29:03 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:03 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 07/16] selftests: xsk: disassociate umem size with packets sent
Date:   Tue, 17 Aug 2021 11:27:20 +0200
Message-Id: <20210817092729.433-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Disassociate the number of packets sent with the number of buffers in
the umem. This so we can loop over the umem to test more things. Set
the size of the umem to be a multiple of 2M. A requirement for huge
pages that are needed in unaligned mode.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 18 ++++++++----------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index b0fee71355bf..ebed88c13509 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -250,7 +250,7 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
 }
 
-static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
+static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size, int idx)
 {
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
@@ -259,7 +259,6 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 		.frame_headroom = frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
-	int size = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	struct xsk_umem_info *umem;
 	int ret;
 
@@ -722,22 +721,23 @@ static void worker_pkt_validate(void)
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
-	int umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	u64 umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	size_t mmap_sz = umem_sz;
 	int ctr = 0;
 	int ret;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
 	if (test_type == TEST_TYPE_BPF_RES)
-		umem_sz *= 2;
+		mmap_sz *= 2;
 
-	bufs = mmap(NULL, umem_sz,
-		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
 	while (ctr++ < SOCK_RECONF_CTR) {
-		xsk_configure_umem(ifobject, bufs, 0);
+		xsk_configure_umem(ifobject, bufs, umem_sz, 0);
 		ifobject->umem = ifobject->umem_arr[0];
 		ret = xsk_configure_socket(ifobject, 0);
 		if (!ret)
@@ -753,7 +753,7 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	ifobject->xsk = ifobject->xsk_arr[0];
 
 	if (test_type == TEST_TYPE_BPF_RES) {
-		xsk_configure_umem(ifobject, (u8 *)bufs + (umem_sz / 2), 1);
+		xsk_configure_umem(ifobject, (u8 *)bufs + umem_sz, umem_sz, 1);
 		ifobject->umem = ifobject->umem_arr[1];
 		ret = xsk_configure_socket(ifobject, 1);
 	}
@@ -1094,8 +1094,6 @@ int main(int argc, char **argv)
 
 	parse_command_line(argc, argv);
 
-	num_frames = ++opt_pkt_count;
-
 	init_iface(ifdict[0], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
 	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index a4371d9e2798..131bd998e374 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -70,7 +70,7 @@ enum STAT_TEST_TYPES {
 
 static int configured_mode = TEST_MODE_UNCONFIGURED;
 static u8 debug_pkt_dump;
-static u32 num_frames;
+static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
 static int test_type;
 
-- 
2.29.0

