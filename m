Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58772691A33
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjBJInj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjBJInh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:43:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9011CF5E;
        Fri, 10 Feb 2023 00:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18DCEB82400;
        Fri, 10 Feb 2023 08:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D59C433EF;
        Fri, 10 Feb 2023 08:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676018614;
        bh=1u042cYBsvXuLk8fikYK1wNFgZJi8z1lXcs+toDaNiE=;
        h=From:To:Cc:Subject:Date:From;
        b=niPEkkykQiF2AUnkE4SeGXUPDnEJrA0E2m0xk4DGnsiPsh/W+uQe0NVY+BEOThVoT
         9kplVQaCe8gs6eIxmPiY2fG+T6/aWyeCKJLbkrZa2nUSW/NN095YDbwEt27St9CEyG
         z+/biM7eYk3iFSGumr42hSM9DGT1ExhSVDlclPKM0RSqAqHVVyk7hoil4c3tPQYeDR
         kA5oU6nbcdD4Sz+QpuFOjT9SHXvTa/OqAStmBnvr+veyyDqN6qIZqmiaB82qfuFx94
         HC80ohp95Lhk3+Ew3gNhn/rdgU5Z6w15dOYzLIkZvIYpZdwp/Czr674IpIBekRiYW4
         6mMYlBH/DFsEg==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
Date:   Fri, 10 Feb 2023 09:43:26 +0100
Message-Id: <20230210084326.1802597-1-bjorn@kernel.org>
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

When the BPF selftests are cross-compiled, only the a host version of
bpftool is built. This version of bpftool is used to generate various
intermediates, e.g., skeletons.

The test runners are also using bpftool. The Makefile will symlink
bpftool from the selftest/bpf root, where the test runners will look
for the tool:

  | ...
  | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
  |    $(OUTPUT)/$(if $2,$2/)bpftool

There are two issues for cross-compilation builds:

 1. There is no native (cross-compilation target) build of bpftool
 2. The bootstrap variant of bpftool is never cross-compiled (by
    design)

Make sure that a native/cross-compiled version of bpftool is built,
and if CROSS_COMPILE is set, symlink to the native/non-bootstrap
version.

Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
 tools/testing/selftests/bpf/Makefile | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b2eb3201b85a..b706750f71e2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -157,8 +157,9 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
 # sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	       \
-	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids      \
+MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	\
+	       $(BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/bpftool		\
+	       $(HOST_BUILD_DIR)/resolve_btfids				\
 	       $(RUNQSLOWER_OUTPUT) $(INCLUDE_DIR))
 $(MAKE_DIRS):
 	$(call msg,MKDIR,,$@)
@@ -208,6 +209,14 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
 
 DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
+ifneq ($(CROSS_COMPILE),)
+CROSS_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
+TRUNNER_BPFTOOL := $(CROSS_BPFTOOL)
+USE_BOOTSTRAP := ""
+else
+TRUNNER_BPFTOOL := $(DEFAULT_BPFTOOL)
+USE_BOOTSTRAP := "bootstrap"
+endif
 
 $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	       \
@@ -255,6 +264,18 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
 		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
 
+ifneq ($(CROSS_COMPILE),)
+$(CROSS_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)	\
+		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)				\
+		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)			\
+		    EXTRA_CFLAGS='-g -O0'					\
+		    OUTPUT=$(BUILD_DIR)/bpftool/				\
+		    LIBBPF_OUTPUT=$(BUILD_DIR)/libbpf/				\
+		    LIBBPF_DESTDIR=$(SCRATCH_DIR)/				\
+		    prefix= DESTDIR=$(SCRATCH_DIR)/ install-bin
+endif
+
 all: docs
 
 docs:
@@ -518,11 +539,12 @@ endif
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     $(RESOLVE_BTFIDS)				\
+			     $(TRUNNER_BPFTOOL)				\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 	$(Q)$(RESOLVE_BTFIDS) --btf $(TRUNNER_OUTPUT)/btf_data.bpf.o $$@
-	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
+	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/$(USE_BOOTSTRAP)/bpftool \
 		   $(OUTPUT)/$(if $2,$2/)bpftool
 
 endef

base-commit: 06744f24696e1e7598412c3df61a538b57ebec22
-- 
2.37.2

