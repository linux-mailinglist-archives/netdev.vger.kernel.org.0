Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945B476A5C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfGZNkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbfGZNkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF14C22CB9;
        Fri, 26 Jul 2019 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148438;
        bh=7RAidGglI7aphPYIWI0gFIpx2fMV/LHZrmurjZTT1Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNrErPOUvGYQSamwaZvsRstU7CwjjeTtp0IyuRato71abI643fMQ73y/pFdsPd0zp
         XbKI4xasLHVs+ppzmqq9F+XjmbgnVlJCys0FT3wQmht1JgyWoPtdmkB5RublzNNWAG
         RNlZ1lnbFqcXMXm4NsZ4dEbvGizevykJeQJ+Gf+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.2 39/85] selftests/bpf: do not ignore clang failures
Date:   Fri, 26 Jul 2019 09:38:49 -0400
Message-Id: <20190726133936.11177-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 9cae4ace80ef39005da106fbb89c952b27d7b89e ]

When compiling an eBPF prog fails, make still returns 0, because
failing clang command's output is piped to llc and therefore its
exit status is ignored.

When clang fails, pipe the string "clang failed" to llc. This will make
llc fail with an informative error message. This solution was chosen
over using pipefail, having separate targets or getting rid of llc
invocation due to its simplicity.

In addition, pull Kbuild.include in order to get .DELETE_ON_ERROR target,
which would cause partial .o files to be removed.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e36356e2377e..e375f399b7a6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../../../scripts/Kbuild.include
 
 LIBDIR := ../../../lib
 BPFDIR := $(LIBDIR)/bpf
@@ -185,8 +186,8 @@ $(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
 
 $(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR) \
 					$(ALU32_BUILD_DIR)/test_progs_32
-	$(CLANG) $(CLANG_FLAGS) \
-		 -O2 -target bpf -emit-llvm -c $< -o - |      \
+	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
 		-filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
@@ -197,16 +198,16 @@ endif
 # Have one program compiled without "-target bpf" to test whether libbpf loads
 # it successfully
 $(OUTPUT)/test_xdp.o: progs/test_xdp.c
-	$(CLANG) $(CLANG_FLAGS) \
-		-O2 -emit-llvm -c $< -o - | \
+	($(CLANG) $(CLANG_FLAGS) -O2 -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
 endif
 
 $(OUTPUT)/%.o: progs/%.c
-	$(CLANG) $(CLANG_FLAGS) \
-		 -O2 -target bpf -emit-llvm -c $< -o - |      \
+	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
-- 
2.20.1

