Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC462A13C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKOSVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiKOSVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:21:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED1926127;
        Tue, 15 Nov 2022 10:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A91961984;
        Tue, 15 Nov 2022 18:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258E5C4347C;
        Tue, 15 Nov 2022 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668536479;
        bh=kVzmN1nhvJ7rXQ8CtIjwZxxIsXnCovpfzTGFioT4v9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma3yBe1TSehHWYD1ASpuWsoYAedQbCS84Xf7g4d9vwu4EvXET9EAEnphGu15H5K70
         qKydZKkbHbfgNIFWIi8eL8SFvTG0lGFS7Ynyzqfl7jl+v8pWSbTEupW1NGTZM4nfj6
         cyq70hQGLPgmd/JaHe29ZGXUphBTPqYRvMXA7Kw5k/Pmywv8mOQEffIiaWWGWxz8PY
         RaSC5f2rq3BnV0EzOacujI1/bx4gTUuylISxwjNhMLGIFoRn8k3XkTixoXQ3vgZ2JW
         5UJaoDMGfE7gED5rGXdVY0YySZhG3DS4zeo8JhvcUVymdJNrYJS7i/IDl0lZ9Jf/S1
         vnnvIuaaDepYQ==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        Mykola Lysenko <mykolal@fb.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 2/2] selftests/bpf: Pass target triple to get_sys_includes macro
Date:   Tue, 15 Nov 2022 19:20:51 +0100
Message-Id: <20221115182051.582962-2-bjorn@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115182051.582962-1-bjorn@kernel.org>
References: <20221115182051.582962-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

When cross-compiling [1], the get_sys_includes make macro should use
the target system include path, and not the build hosts system include
path.

Make clang honor the CROSS_COMPILE triple.

[1] e.g. "ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make"

Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
 tools/testing/selftests/bpf/Makefile | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8f8ede30e94e..a2a1eae75820 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -309,9 +309,9 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 # Use '-idirafter': Don't interfere with include mechanics except where the
 # build would have failed anyways.
 define get_sys_includes
-$(shell $(1) -v -E - </dev/null 2>&1 \
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
 endef
 
 # Determine target endianness.
@@ -319,7 +319,11 @@ IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
 			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
 MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
-CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
 BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
 	     -I$(abspath $(OUTPUT)/../usr/include)
@@ -539,7 +543,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs,no_alu32))
 # Define test_progs BPF-GCC-flavored test runner.
 ifneq ($(BPF_GCC),)
 TRUNNER_BPF_BUILD_RULE := GCC_BPF_BUILD_RULE
-TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(call get_sys_includes,gcc)
+TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(call get_sys_includes,gcc,)
 $(eval $(call DEFINE_TEST_RUNNER,test_progs,bpf_gcc))
 endif
 
-- 
2.37.2

