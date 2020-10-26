Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD329A020
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442538AbgJ0A0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410038AbgJZXxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBA82225C;
        Mon, 26 Oct 2020 23:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756399;
        bh=Yqk5FXGBcKBnhqS8F2wYGNYMmv3N3uxVYR4uH+Wcgts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Izwzh4vu0rUiFtdEiQhLIMTsDHHXjFHO/mOvXnXc507m2GK1iKEUoDLYABD4tYILY
         eBviLQL5zBcQQyDwsnEDq9dNe5pq2l7i+ro5qKN2Loe5j/14fOXona47kWvwvN5YPt
         sXtmDTRN2nZDAKNu55+q0Bbh1u8uEYGnIrM2a8mA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.8 059/132] selftests/bpf: Define string const as global for test_sysctl_prog.c
Date:   Mon, 26 Oct 2020 19:50:51 -0400
Message-Id: <20201026235205.1023962-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 6e057fc15a2da4ee03eb1fa6889cf687e690106e ]

When tweaking llvm optimizations, I found that selftest build failed
with the following error:
  libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
  libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
          in section '.rodata.str1.1'
  Error: failed to open BPF object file: Relocation failed
  make: *** [/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h] Error 255
  make: *** Deleting file `/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h'

The local string constant "tcp_mem_name" is put into '.rodata.str1.1' section
which libbpf cannot handle. Using untweaked upstream llvm, "tcp_mem_name"
is completely inlined after loop unrolling.

Commit 7fb5eefd7639 ("selftests/bpf: Fix test_sysctl_loop{1, 2}
failure due to clang change") solved a similar problem by defining
the string const as a global. Let us do the same here
for test_sysctl_prog.c so it can weather future potential llvm changes.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200910202718.956042-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
index 50525235380e8..5489823c83fc2 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
@@ -19,11 +19,11 @@
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
 
+const char tcp_mem_name[] = "net/ipv4/tcp_mem";
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
-	char tcp_mem_name[] = "net/ipv4/tcp_mem";
 	unsigned char i;
-	char name[64];
+	char name[sizeof(tcp_mem_name)];
 	int ret;
 
 	memset(name, 0, sizeof(name));
-- 
2.25.1

