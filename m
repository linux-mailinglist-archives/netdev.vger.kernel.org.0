Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF61A644141
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiLFK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiLFK2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:28:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3D917581;
        Tue,  6 Dec 2022 02:28:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623E0B818E3;
        Tue,  6 Dec 2022 10:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D745C433D6;
        Tue,  6 Dec 2022 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670322530;
        bh=oEIEMz9chzh0pt9Xq/JSwkrnlGW5wav7o7/ZYyrUiFI=;
        h=From:To:Cc:Subject:Date:From;
        b=tcLPzU+gfzRUL+uWqaJQQ6nMp0IJtNh+v8wEWfIXd7RltK+3MnEf9GozcgTEzC0I9
         S6zivf5Zh6t0Cor6ZnmCkatp48WA58jH46Fc8wWY8orzyWaXVb9bEaDXw4JtDZ9QvL
         qK53ylvsVBqR5K2rf+JfjxEwCRHG9f/Nt9c4xCqAq1P+oZaXoRHAsuiWrslKIoCELE
         H6w983gSoFviErehZHqgaJ0r3dnnHOzo/UFJg8rbfCHtbK1ZZeB5lg1f8M6yL2T/Qm
         LEVjKCUwQKRG90vjrLHJxtBhtt7MWg6BCe3GixIm2rQT8XLLSvjz30H0K0OGTaigjf
         gIuZ41vQCfa1g==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Lina Wang <lina.wang@mediatek.com>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] selftests: net: Fix O=dir builds
Date:   Tue,  6 Dec 2022 11:28:38 +0100
Message-Id: <20221206102838.272584-1-bjorn@kernel.org>
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

The BPF Makefile in net/bpf did incorrect path substitution for O=dir
builds, e.g.

  make O=/tmp/kselftest headers
  make O=/tmp/kselftest -C tools/testing/selftests

would fail in selftest builds [1] net/ with

  clang-16: error: no such file or directory: 'kselftest/net/bpf/nat6to4.c'
  clang-16: error: no input files

Add a pattern prerequisite and an order-only-prerequisite (for
creating the directory), to resolve the issue.

[1] https://lore.kernel.org/all/202212060009.34CkQmCN-lkp@intel.com/

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 837a3d66d698 ("selftests: net: Add cross-compilation support for BPF programs")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
 tools/testing/selftests/net/bpf/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index a26cb94354f6..4abaf16d2077 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -12,7 +12,7 @@ CCINCLUDE += -I$(SCRATCH_DIR)/include
 
 BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 
-MAKE_DIRS := $(BUILD_DIR)/libbpf
+MAKE_DIRS := $(BUILD_DIR)/libbpf $(OUTPUT)/bpf
 $(MAKE_DIRS):
 	mkdir -p $@
 
@@ -37,8 +37,8 @@ endif
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
 
-$(TEST_CUSTOM_PROGS): $(BPFOBJ)
-	$(CLANG) -O2 -target bpf -c $(@:.o=.c) $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
+$(TEST_CUSTOM_PROGS): $(OUTPUT)/%.o: %.c $(BPFOBJ) | $(MAKE_DIRS)
+	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
 
 $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	   $(APIDIR)/linux/bpf.h					       \

base-commit: c9f8d73645b6f76c8d14f49bc860f7143d001cb7
-- 
2.37.2

