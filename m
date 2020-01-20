Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31841142BDD
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgATNNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:13:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727075AbgATNNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:13:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579526002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OV2F5KycaRYFyA7gRNTRFrtUAPvKB/uVOGe3Q95tG20=;
        b=CU6+1cuOi2LmooHfumWcf5DxSVOAtPnYT4y6XtSnrBOIIR69fFvpuFldD7tmjc/tUfE44n
        lX4hrf2/vPwcd/hQ8gvJWDM586610tY5Vla/Dvo2yQnKDdgoRBRhitkjHiekZpFNL8lOIh
        Ujz2ZpCvtJNXt09j2zXwOq9z2rKcAYQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-boPFXoErMWWgOI4C8THveQ-1; Mon, 20 Jan 2020 08:13:21 -0500
X-MC-Unique: boPFXoErMWWgOI4C8THveQ-1
Received: by mail-lj1-f197.google.com with SMTP id r14so7511481ljc.18
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OV2F5KycaRYFyA7gRNTRFrtUAPvKB/uVOGe3Q95tG20=;
        b=Y1vUEakeAC17c33XdVsVvkrbUa+BrPJW2cWULt+2N7FucxriLhDPCwisNPvV6SStOm
         ne4Q+Oz2kfVzON3HPsjG4nKHe48Ze4aUuU+C41JAP/ixj7NQ6w//ZI6TPzLmrkmVpCBF
         sDviskfeCsekfqp2tN7vWtP0l6Zjr2fXdZlJoKE5LaZZcl2noklJTAitc5TqooUujkJw
         Dp3BGPwYmJ9ugLROXFXrKo8Rr5zyt1RZu8rPZSxm8gxF+VOWa1KFVyfTp/Ye+GI22TDP
         3OfluZAYzZUxfhZOpHyTNFTJ8RrCimD3AEd8LZsJpG/8sCbCKpLzbjzjAt802qYFyuP9
         94rQ==
X-Gm-Message-State: APjAAAUwWHTygMI8TREHBJQnTaxpwm1EuC8cXZrgoGq2ZHLPGG2mgAw7
        xrhkx96UMsNSOUKz6QcZ7OMzy36OvXg0nttgFYFl/zjcZqA0aJjx/54lUURXX0pxwWjdA/Imhbg
        T0imX7kicjV9x6rQa
X-Received: by 2002:ac2:58c1:: with SMTP id u1mr6526496lfo.57.1579525999328;
        Mon, 20 Jan 2020 05:13:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6GaaMgnx8Xd+lJy37awgoTe/xbVU+R2aCqUfNb8TodmbD6JzVbGj8RG+80hAD+E40R80DWQ==
X-Received: by 2002:ac2:58c1:: with SMTP id u1mr6526468lfo.57.1579525998962;
        Mon, 20 Jan 2020 05:13:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b14sm16762076lff.68.2020.01.20.05.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:13:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8CE311804D8; Mon, 20 Jan 2020 14:06:52 +0100 (CET)
Subject: [PATCH bpf-next v5 11/11] selftests: Refactor build to remove
 tools/lib/bpf from include path
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Mon, 20 Jan 2020 14:06:52 +0100
Message-ID: <157952561246.1683545.2762245552022369203.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

To make sure no new files are introduced that doesn't include the bpf/
prefix in its #include, remove tools/lib/bpf from the include path
entirely.

Instead, we introduce a new header files directory under the scratch tools/
dir, and add a rule to run the 'install_headers' rule from libbpf to have a
full set of consistent libbpf headers in $(OUTPUT)/tools/include/bpf, and
then use $(OUTPUT)/tools/include as the include path for selftests.

For consistency we also make sure we put all the scratch build files from
other bpftool and libbpf into tools/build/, so everything stays within
selftests/.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/.gitignore |    4 +-
 tools/testing/selftests/bpf/Makefile   |   59 ++++++++++++++++----------------
 2 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1d14e3ab70be..ec464859c6b6 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -29,8 +29,6 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-libbpf.pc
-libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
@@ -39,4 +37,4 @@ test_cpp
 /no_alu32
 /bpf_gcc
 /tools
-bpf_helper_defs.h
+
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2cd91e0524cf..be8fe404a086 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -20,8 +20,8 @@ CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
-CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)  \
-	  -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)			\
+CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)		\
+	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)	\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lz -lrt -lpthread
@@ -97,11 +97,15 @@ OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,CLEAN)
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
-	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ clean
 endef
 
 include ../lib.mk
 
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+INCLUDE_DIR := $(SCRATCH_DIR)/include
+BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
+
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
 # to build individual tests.
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
@@ -120,7 +124,7 @@ $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
 	$(CC) -o $@ $< -Wl,--build-id
 
-$(OUTPUT)/test_stub.o: test_stub.c
+$(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
@@ -128,12 +132,10 @@ VMLINUX_BTF_PATHS := $(abspath ../../../../vmlinux)			\
 			       /sys/kernel/btf/vmlinux			\
 			       /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF:= $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))
-.PHONY: $(OUTPUT)/runqslower
-$(OUTPUT)/runqslower: force
+$(OUTPUT)/runqslower: $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
-		    OUTPUT=$(OUTPUT)/tools/ VMLINUX_BTF=$(VMLINUX_BTF)
-
-BPFOBJ := $(OUTPUT)/libbpf.a
+		    OUTPUT=$(SCRATCH_DIR)/ VMLINUX_BTF=$(VMLINUX_BTF)   \
+		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR)
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
@@ -151,25 +153,22 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 
-.PHONY: force
-
-# force a rebuild of BPFOBJ when its dependencies are updated
-force:
-
-DEFAULT_BPFTOOL := $(OUTPUT)/tools/sbin/bpftool
+DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
+$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			\
+		    OUTPUT=$(BUILD_DIR)/bpftool/			\
+		    prefix= DESTDIR=$(SCRATCH_DIR)/ install
 
-$(DEFAULT_BPFTOOL): force
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			      \
-		    prefix= DESTDIR=$(OUTPUT)/tools/ install
-
-$(BPFOBJ): force
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.c $(BPFDIR)/*.h $(BPFDIR)/Makefile)          \
+	   ../../../include/uapi/linux/bpf.h                                   \
+	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
+		DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
 
-BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
-$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)			      \
-		    OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
+$(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
+	$(call msg,MKDIR,,$@)
+	mkdir -p $@
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -189,8 +188,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
-	     -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi		\
-	     -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
+	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(CURDIR)/include/uapi	\
+	     -I$(APIDIR) -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -279,7 +278,7 @@ $(TRUNNER_BPF_PROGS_DIR)$(if $2,-)$2-bpfobjs := y
 $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
 		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
-		     $$(BPF_HELPERS) | $(TRUNNER_OUTPUT)
+		     $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS),	\
 					  $(TRUNNER_BPF_LDFLAGS))
@@ -392,7 +391,7 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc tools)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)

