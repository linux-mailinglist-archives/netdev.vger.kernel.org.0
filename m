Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8593D75CE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhG0NSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhG0NSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:23 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B774C0613D3;
        Tue, 27 Jul 2021 06:18:21 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j2so15142930wrx.9;
        Tue, 27 Jul 2021 06:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcvyBXGKRkQZQLpDB3lr5QdEFpA/NZDEkkdYXGna3jA=;
        b=SjZbFWesQmVkYxPwOCfd4gXr2HnZi+5YMnpl4SyWbf9lTlLsyyAqsTF0//R0UkHmBE
         8xMgxboWyR97cqPsNkfDatcvA0AbT1cG1zykQntywymmvXDpIVls/cjEPfubIBo1fY/y
         gqIGbmjRvF1ucnD4HW1j+vwT/2ZEoc9Ae9ima3bctbzIVBsPMN/aBOqpHag4ZjVEFKPr
         WqTMsVTX8fwgGveA267AC7uvd84EiRtoXB6u8UDkgQyZC0ycVGrhhWJclUyang2wPuNv
         M5PjSGM/t6z6vaO9kFUAG+iSgAuGRMMp8XvzWrxDQbInjhXsiDqgCLpdSDCeLW3MEaqC
         qtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcvyBXGKRkQZQLpDB3lr5QdEFpA/NZDEkkdYXGna3jA=;
        b=YwWOD2+aAWH1i+yopsS7vEM70EKmNAraX0j4clIRgiJfE2sqrZDqK7fJga3uKtuOhs
         2/s+R2M5rgmENIIFCEyNkXtSD+z4HBhORkkxj8KlITyVzVIeytNGDr9CP2iRsn2VOK4b
         z1GicJ8amnE3cpQk8xhAm2srUyfProgaEV7b9o9UVHnVLHe4k72TYHr0tnbNSALcJxX7
         scujwUlGQysa0PkOrbj0qwmuk6y6Y0xjmSLQiOjRd5WrWPhBHuS6yFgZQ68/nwybnAEX
         a1v9YKvLzlWsswqbf+R9s15Qpae1mqGkknv+QzJCxwB/aHjfOdq4OSjWV0iBMkGYBQ3L
         A1tQ==
X-Gm-Message-State: AOAM531uybcC0mi/Jf6CsAKUoVuYqT1vDnUPna1j6ucZlhwPf1onesav
        cgP2wxvmqzvJQvKCFrVssio=
X-Google-Smtp-Source: ABdhPJweshyjhBlnhh6uIRvZFkxiSobp2ojSfEEBMQkK38AtmSGcv5t1rTKWO4WITAnmv1ZlI+BNfw==
X-Received: by 2002:adf:ffd1:: with SMTP id x17mr24152597wrs.411.1627391899939;
        Tue, 27 Jul 2021 06:18:19 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:19 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 08/17] selftests: xsk: disassociate umem size with packets sent
Date:   Tue, 27 Jul 2021 15:17:44 +0200
Message-Id: <20210727131753.10924-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index b77ee9bb91e1..4c9f38e9a268 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -250,7 +250,7 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
 }
 
-static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
+static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size, int idx)
 {
 	const struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct xsk_umem_config cfg = {
@@ -260,7 +260,6 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 		.frame_headroom = frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
-	int size = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	struct xsk_umem_info *umem;
 	int ret;
 
@@ -727,22 +726,23 @@ static void worker_pkt_validate(void)
 
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
@@ -758,7 +758,7 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	ifobject->xsk = ifobject->xsk_arr[0];
 
 	if (test_type == TEST_TYPE_BPF_RES) {
-		xsk_configure_umem(ifobject, (u8 *)bufs + (umem_sz / 2), 1);
+		xsk_configure_umem(ifobject, (u8 *)bufs + umem_sz, umem_sz, 1);
 		ifobject->umem = ifobject->umem_arr[1];
 		ret = xsk_configure_socket(ifobject, 1);
 	}
@@ -1095,8 +1095,6 @@ int main(int argc, char **argv)
 
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

