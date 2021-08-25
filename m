Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36FD3F71E5
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhHYJiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239787AbhHYJis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:48 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3F3C061796;
        Wed, 25 Aug 2021 02:38:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g138so14540600wmg.4;
        Wed, 25 Aug 2021 02:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FkSX+q6lNV8RfsiU+JBNPDdX/Xw/Tk761bFEK2gJIzY=;
        b=Qwekri2ljCH4GOMRo/smmnCN4xyUvnGkO6m8v0epeGSOvIrGwaCNPzEou2axVj/eCc
         nssG+3VAocubf0AWbCcirqEiIpFVlTlXJ6Q96rGak5/1S9Gz47FH3byskLyqLomAu+/0
         g8jgMFTMlH4yjpaXvPPaI7ob9ySjVREhPQC2QB8Qmeq9QlJSnyK3twPtY468K54FGNpG
         Aj7m2aK5XfS9jl8B1T9VygW+V1zeLvU5GEnpcpdYy7i5Rzrp1Nypi8s/lCr/RGJraLtj
         TwdBcvzCbvsiJb8CpfN8GJzDPLDow+6MWjZeLr/PpPGOk2xsw6J8WIHYVRL+OOYTsazS
         wXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FkSX+q6lNV8RfsiU+JBNPDdX/Xw/Tk761bFEK2gJIzY=;
        b=oDTyQOWHkddqq7nONCqXjuO+4m3vHKugiB7nzLMaChA8YUZ+iwn+yvzVJMPPPHqxuk
         YSj/7Fl7boY7CrHuPasWhZV7RbFtWC+k5uHYEt7FNoU9bkLqCpcHPMcSxQpzNFf9NkR6
         HAi0HUpC4OKkVM1Ic056lDJPl4Qy9j6l3dt8t0pO/q1vzn0YzCR4Bt/NdwBZR8Pmp1eS
         3WXedan8+9Re63bRyaQkdXxd2rkte4A89zGFmkPX63/vhWsi9v9DumLfI2L4cpTtI66w
         0agwmb299k42t32GS/+iHSAa59Rl/HPwW9LBnkQ2L/IrgKzdgFBnXlzH+sPGrXVa2ZtO
         d+JQ==
X-Gm-Message-State: AOAM5310lYhDFPV0RhpirTwWBpMAVyFOtglIplmIOHUqlNTzG/cpRG1E
        cdCkWd4xrmAOK3KCqKiQZWs=
X-Google-Smtp-Source: ABdhPJxMbLckaMtHxcUEBQNUgkMR3aXc/7Z1f3bnhRKpQM1xnQFFtS+fRwlUtSCQTBsm0qqf4E1nKw==
X-Received: by 2002:a1c:2702:: with SMTP id n2mr8292096wmn.78.1629884281951;
        Wed, 25 Aug 2021 02:38:01 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:01 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 07/16] selftests: xsk: disassociate umem size with packets sent
Date:   Wed, 25 Aug 2021 11:37:13 +0200
Message-Id: <20210825093722.10219-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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

