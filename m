Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA06630FA9
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 18:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKSRTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 12:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKSRTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 12:19:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629E711C27;
        Sat, 19 Nov 2022 09:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF0D60A7C;
        Sat, 19 Nov 2022 17:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9B0C433D6;
        Sat, 19 Nov 2022 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668878339;
        bh=zr4d+rv3Q5Fxe/4kNQPntCAa7p0O3bFqpKvRY49n9/M=;
        h=From:To:Cc:Subject:Date:From;
        b=n7i2zdehTGtx4wuqqD+xpBH/OZ26MjDaJOC8O5x7w4SQSwkdbfNato47qMo1R7Qt6
         0PJZf9KXHTwNpbdPXoQVzU8tmmYskoBAlyVctlhe89vRe9vuWqDoKgcB5N/71ZiMF5
         aJVqr4KrJ7H7yAf9zNXpCV2/ft0NVpGkEG8Ea6Njn/YcQ6ei3aeF9AZUZrVWtBBShQ
         k0mbpPIKlq6QhcGE4M0NntSdCy38XsJLmraPGSGVjANdMjCsOASXzokEMQKxLjCp1O
         n+tcGSKIM+bS2tj/r7QFVmYQ53dGFM8rI5O8KhsMuNgINC3qkKlm+P7Cp8Bq9ox+Hq
         8xC6BP+y6h0zA==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Lina Wang <lina.wang@mediatek.com>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH net-next] selftests: net: Add cross-compilation support for BPF programs
Date:   Sat, 19 Nov 2022 18:18:41 +0100
Message-Id: <20221119171841.2014936-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.37.2
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

The selftests/net does not have proper cross-compilation support, and
does not properly state libbpf as a dependency. Mimic/copy the BPF
build from selftests/bpf, which has the nice side-effect that libbpf
is built as well.

Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
Now that BPF builds are starting to show up in more places
(selftests/net, and soon selftests/hid), maybe it would be cleaner to
move parts of the BPF builds to lib.mk?

Björn
---
 tools/testing/selftests/net/bpf/Makefile | 45 +++++++++++++++++++++---
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index 8ccaf8732eb2..a26cb94354f6 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -1,14 +1,51 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CLANG ?= clang
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+BPFDIR := $(abspath ../../../lib/bpf)
+APIDIR := $(abspath ../../../include/uapi)
+
 CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../../lib
 CCINCLUDE += -I../../../../../usr/include/
+CCINCLUDE += -I$(SCRATCH_DIR)/include
+
+BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
+
+MAKE_DIRS := $(BUILD_DIR)/libbpf
+$(MAKE_DIRS):
+	mkdir -p $@
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
 all: $(TEST_CUSTOM_PROGS)
 
-$(OUTPUT)/%.o: %.c
-	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
+# Get Clang's default includes on this system, as opposed to those seen by
+# '-target bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
+define get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
+
+$(TEST_CUSTOM_PROGS): $(BPFOBJ)
+	$(CLANG) -O2 -target bpf -c $(@:.o=.c) $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
+	   $(APIDIR)/linux/bpf.h					       \
+	   | $(BUILD_DIR)/libbpf
+	$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/     \
+		    EXTRA_CFLAGS='-g -O0'				       \
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)
 
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)

base-commit: 8bd8dcc5e47f0f9dc40187c3b8b42d992181eee1
-- 
2.37.2

