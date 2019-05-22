Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2267C26D28
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbfEVTjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732948AbfEVT3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:29:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DB3217D9;
        Wed, 22 May 2019 19:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553375;
        bh=DMcVsn0ohh25afz3dEf0waXI4SCKFzmZdHefFU0jzvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgrZstSlXEXkdiYjfLxhOw3EpLAryC2/Bs9BWFj4fjwR219LEKjZbuOpv9G119Vrk
         6gDChGElap6jGLS1RXGvDlvQcOkDIixcTjJPEW5WrlyPKehOzIyhsdHU6kwwDAxMCv
         KoNWpm3N2GHSLaaxYgQPwaCMTVbngxJSkpP12Uv0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 035/167] libbpf: fix samples/bpf build failure due to undefined UINT32_MAX
Date:   Wed, 22 May 2019 15:26:30 -0400
Message-Id: <20190522192842.25858-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit 32e621e55496a0009f44fe4914cd4a23cade4984 ]

Currently, building bpf samples will cause the following error.

    ./tools/lib/bpf/bpf.h:132:27: error: 'UINT32_MAX' undeclared here (not in a function) ..
     #define BPF_LOG_BUF_SIZE (UINT32_MAX >> 8) /* verifier maximum in kernels <= 5.1 */
                               ^
    ./samples/bpf/bpf_load.h:31:25: note: in expansion of macro 'BPF_LOG_BUF_SIZE'
     extern char bpf_log_buf[BPF_LOG_BUF_SIZE];
                             ^~~~~~~~~~~~~~~~

Due to commit 4519efa6f8ea ("libbpf: fix BPF_LOG_BUF_SIZE off-by-one error")
hard-coded size of BPF_LOG_BUF_SIZE has been replaced with UINT32_MAX which is
defined in <stdint.h> header.

Even with this change, bpf selftests are running fine since these are built
with clang and it includes header(-idirafter) from clang/6.0.0/include.
(it has <stdint.h>)

    clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/include -idirafter /usr/include \
    -idirafter /usr/lib/llvm-6.0/lib/clang/6.0.0/include -idirafter /usr/include/x86_64-linux-gnu \
    -Wno-compare-distinct-pointer-types -O2 -target bpf -emit-llvm -c progs/test_sysctl_prog.c -o - | \
    llc -march=bpf -mcpu=generic  -filetype=obj -o /linux/tools/testing/selftests/bpf/test_sysctl_prog.o

But bpf samples are compiled with GCC, and it only searches and includes
headers declared at the target file. As '#include <stdint.h>' hasn't been
declared in tools/lib/bpf/bpf.h, it causes build failure of bpf samples.

    gcc -Wp,-MD,./samples/bpf/.sockex3_user.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes \
    -O2 -fomit-frame-pointer -std=gnu89 -I./usr/include -I./tools/lib/ -I./tools/testing/selftests/bpf/ \
    -I./tools/  lib/ -I./tools/include -I./tools/perf -c -o ./samples/bpf/sockex3_user.o ./samples/bpf/sockex3_user.c;

This commit add declaration of '#include <stdint.h>' to tools/lib/bpf/bpf.h
to fix this problem.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index b8ea5843c39ee..e9423d6af9332 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -23,6 +23,7 @@
 
 #include <linux/bpf.h>
 #include <stddef.h>
+#include <stdint.h>
 
 int bpf_create_map_node(enum bpf_map_type map_type, int key_size,
 			int value_size, int max_entries, __u32 map_flags,
-- 
2.20.1

