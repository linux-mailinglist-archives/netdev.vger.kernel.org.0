Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BEB6968FD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjBNQNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjBNQNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:13:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE33AB755;
        Tue, 14 Feb 2023 08:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E5EF61734;
        Tue, 14 Feb 2023 16:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B2C433EF;
        Tue, 14 Feb 2023 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676391180;
        bh=2D4vutaGGAQcjBv/Y+hlE6mTI66xLbC0P40xjGHa1tM=;
        h=From:To:Cc:Subject:Date:From;
        b=sq6Unzyxw2YZ6sPTYEqvxGx17YI8sxm4J/SL/bYvMolmdGb1tCpQA8AhpS5JheHbT
         KcUV51d7Rp4fWg3AxqSbBc8MS8eKnA65sRAm+WGRB+uuqP2aOKygWQpdigzb8vWpBL
         fxyz1hpBleEmpNGpt6jEi4pf6rBgsMlDz2vNEapfO2SWI+N4WLrqf2QD7/GRWZ2fQq
         +H4Gl+1HBPfdm24fVECmTphM3DF7keMAouhbMiOBt6tPksimqNtKUV6Xjpr6fKLRuK
         +s2ziHoskdrFUEMZ3L3JHXf6RRKycavRt6xhxdGov8i/hnA0AvohR8OsQ4akOfmZpY
         Vz4Xsbjl+YsAA==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zachary Leaf <zachary.leaf@arm.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2] selftests/bpf: Cross-compile bpftool
Date:   Tue, 14 Feb 2023 17:12:53 +0100
Message-Id: <20230214161253.183458-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

When the BPF selftests are cross-compiled, only the a host version of
bpftool is built. This version of bpftool is used on the host-side to
generate various intermediates, e.g., skeletons.

The test runners are also using bpftool, so the Makefile will symlink
bpftool from the selftest/bpf root, where the test runners will look
the tool:

  | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
  |    $(OUTPUT)/$(if $2,$2/)bpftool

There are two problems for cross-compilation builds:

 1. There is no native (cross-compilation target) of bpftool
 2. The bootstrap/bpftool is never cross-compiled (by design)

Make sure that a native/cross-compiled version of bpftool is built,
and if CROSS_COMPILE is set, symlink the native/non-bootstrap version.

Acked-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
v1->v2: Added the target bpftool version to install target (Zachary)
        Double-slash cosmetics (Quentin)

---
 tools/testing/selftests/bpf/Makefile | 30 ++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c4b5c44cdee2..3108352e65de 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -158,8 +158,9 @@ $(notdir $(TEST_GEN_PROGS)						\
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
@@ -209,6 +210,14 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
 
 DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
+ifneq ($(CROSS_COMPILE),)
+CROSS_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
+TRUNNER_BPFTOOL := $(CROSS_BPFTOOL)
+USE_BOOTSTRAP := ""
+else
+TRUNNER_BPFTOOL := $(DEFAULT_BPFTOOL)
+USE_BOOTSTRAP := "bootstrap/"
+endif
 
 $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	       \
@@ -220,7 +229,7 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
 		    EXTRA_LDFLAGS='$(SAN_LDFLAGS)' &&			       \
 		    cp $(RUNQSLOWER_OUTPUT)runqslower $@
 
-TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
+TEST_GEN_PROGS_EXTENDED += $(TRUNNER_BPFTOOL)
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(BPFOBJ)
 
@@ -258,6 +267,18 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
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
@@ -523,11 +544,12 @@ endif
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     $(RESOLVE_BTFIDS)				\
+			     $(TRUNNER_BPFTOOL)				\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 	$(Q)$(RESOLVE_BTFIDS) --btf $(TRUNNER_OUTPUT)/btf_data.bpf.o $$@
-	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
+	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/$(USE_BOOTSTRAP)bpftool \
 		   $(OUTPUT)/$(if $2,$2/)bpftool
 
 endef

base-commit: ab86cf337a5b64f0456d2d0d01edc939ad5c20bb
-- 
2.37.2

