Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4088847DE68
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 05:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbhLWE4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 23:56:12 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33904 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhLWE4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 23:56:12 -0500
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JKHvQ36DQzXtLt;
        Thu, 23 Dec 2021 12:55:46 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 12:56:10 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 12:56:09 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf-next v2] selftests/bpf: Fix cross compiling error when using userspace pt_regs
Date:   Thu, 23 Dec 2021 05:20:07 +0000
Message-ID: <20211223052007.4111674-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When cross compiling arm64 bpf selftests in x86_64 host, the following
error occur:

progs/loop2.c:20:7: error: incomplete definition of type 'struct
user_pt_regs'

Some archs, like arm64 and riscv, use userspace pt_regs in bpf_tracing.h.
When arm64 bpf selftests cross compiling in x86_64 host, clang cannot
find the arch specific uapi ptrace.h. We can add arch specific header
file directory to fix this issue.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
v1->v2:
- use vmlinux.h directly might lead to verifier fail.
- use source arch header file directory suggested by Andrii Nakryiko.

 tools/testing/selftests/bpf/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 42ffc24e9e71..1ecb6d192953 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -12,6 +12,7 @@ BPFDIR := $(LIBDIR)/bpf
 TOOLSINCDIR := $(TOOLSDIR)/include
 BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
 APIDIR := $(TOOLSINCDIR)/uapi
+ARCH_APIDIR := $(abspath ../../../../arch/$(SRCARCH)/include/uapi)
 GENDIR := $(abspath ../../../../include/generated)
 GENHDR := $(GENDIR)/autoconf.h
 
@@ -294,7 +295,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
-	     -I$(abspath $(OUTPUT)/../usr/include)
+	     -I$(abspath $(OUTPUT)/../usr/include)			\
+	     -I$(ARCH_APIDIR)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
-- 
2.25.1

