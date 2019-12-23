Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C0C1291CE
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfLWGNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:13:46 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41996 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfLWGNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 01:13:45 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so8653058pfz.9;
        Sun, 22 Dec 2019 22:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzLLXgScNK2NFx9W8K4Xo6N6LSZ1F5SXbeG183QdbNg=;
        b=Yp3Wht3Ac9Yt2DIxrFs7shTnzEQKcWgBYSx9P94e5PpDHmBuDYREbTmuRLkgFXP+37
         IVavDSNpKCaXRSF1HHEq4J6LgdCPmeC6QTHy7sxI+d0BRstHXjNWLbgHV+FAI4ELSjnh
         L8tvlfwbVZ5NVT3KI0TTyMuyoKBixjkpzGwnogm1c/5Fax58Xr080AID7cookuQ/0xo3
         KHQ8ezLSZi1FxTOT/DLUrennQyGeGy+x+5pqTqD1WdNfoGBt5cOXM7itrHNMfpq84zsm
         rYEVFx4U+pfckXxmIQSzb40VMMSbtaCkNU2fO/08vGT0Fd+j/tleH1U2XoCDnSTbskG1
         Rf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=FzLLXgScNK2NFx9W8K4Xo6N6LSZ1F5SXbeG183QdbNg=;
        b=aMPyYoM9gSOA+SiQfgOsem4cn/csfW03TdqJ3cBBKZYV0zYEW3bBFpgd1iwqp8Snbn
         ScbD76wvbfRIENQWFO8FikHCfU23ml8LDynAu/uII7r8DpcKaMbb/dBoXT5ADCsffKME
         I3YJ2GUILb6Wsy4wlXp1YtG+q7a1ivlrXy+auojga7bXAZjj0Jxw0J/7KvcYWRGSWa61
         fuzKZilQt7QQSzW3X/m35pQ1gcVYfcTKjNMzTqw97M+gtHqm3EuDFqlNwpQEcbWSZ+Is
         5TbstaUB11mZL9KVK/uztw8mH+hmcpqBIf+p2/T72CSk0ICBSBVJXaIyekG+9nwPymUU
         ERkA==
X-Gm-Message-State: APjAAAX0jeME0Al2UQZMuZBB10qAFxa/wELaKae4/YBX205g0pAKSYRz
        SrjMhpQtMEQ9ZmyOAgC+ft4=
X-Google-Smtp-Source: APXvYqx7UJZD+6h38WSob/AxeFIUEhgC3GQuS6W0Avi0J8jeHbCLMZg5JkHhbZYBolf0OQaPZcM1tQ==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr15949396pgh.9.1577081624762;
        Sun, 22 Dec 2019 22:13:44 -0800 (PST)
Received: from gaurie.seo.corp.google.com ([2401:fa00:d:1:4eb0:a5ef:3975:7440])
        by smtp.gmail.com with ESMTPSA id u7sm21622191pfh.128.2019.12.22.22.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 22:13:44 -0800 (PST)
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH bpf v3] libbpf: Fix build on read-only filesystems
Date:   Mon, 23 Dec 2019 15:13:26 +0900
Message-Id: <20191223061326.843366-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <CAM9d7ch1=pmgkFbgGr2YignQwdNjke2QeOAFLCFYu8L8J-Z8vw@mail.gmail.com>
References: <CAM9d7ch1=pmgkFbgGr2YignQwdNjke2QeOAFLCFYu8L8J-Z8vw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got the following error when I tried to build perf on a read-only
filesystem with O=dir option.

  $ cd /some/where/ro/linux/tools/perf
  $ make O=$HOME/build/perf
  ...
    CC       /home/namhyung/build/perf/lib.o
  /bin/sh: bpf_helper_defs.h: Read-only file system
  make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 1
  make[2]: *** [Makefile.perf:778: /home/namhyung/build/perf/libbpf.a] Error 2
  make[2]: *** Waiting for unfinished jobs....
    LD       /home/namhyung/build/perf/libperf-in.o
    AR       /home/namhyung/build/perf/libperf.a
    PERF_VERSION = 5.4.0
  make[1]: *** [Makefile.perf:225: sub-make] Error 2
  make: *** [Makefile:70: all] Error 2

It was becaused bpf_helper_defs.h was generated in current directory.
Move it to OUTPUT directory.

Tested-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/bpf/Makefile                 | 15 ++++++++-------
 tools/testing/selftests/bpf/.gitignore |  1 +
 tools/testing/selftests/bpf/Makefile   |  6 +++---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index defae23a0169..97830e46d1a0 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -138,6 +138,7 @@ STATIC_OBJDIR	:= $(OUTPUT)staticobjs/
 BPF_IN_SHARED	:= $(SHARED_OBJDIR)libbpf-in.o
 BPF_IN_STATIC	:= $(STATIC_OBJDIR)libbpf-in.o
 VERSION_SCRIPT	:= libbpf.map
+BPF_HELPER_DEFS	:= $(OUTPUT)bpf_helper_defs.h
 
 LIB_TARGET	:= $(addprefix $(OUTPUT),$(LIB_TARGET))
 LIB_FILE	:= $(addprefix $(OUTPUT),$(LIB_FILE))
@@ -159,7 +160,7 @@ all: fixdep
 
 all_cmd: $(CMD_TARGETS) check
 
-$(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
+$(BPF_IN_SHARED): force elfdep bpfdep $(BPF_HELPER_DEFS)
 	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/linux/bpf.h && ( \
 	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.h >/dev/null) || \
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
@@ -177,12 +178,12 @@ $(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS) $(SHLIB_FLAGS)"
 
-$(BPF_IN_STATIC): force elfdep bpfdep bpf_helper_defs.h
+$(BPF_IN_STATIC): force elfdep bpfdep $(BPF_HELPER_DEFS)
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
-bpf_helper_defs.h: $(srctree)/tools/include/uapi/linux/bpf.h
+$(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
 	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
-		--file $(srctree)/tools/include/uapi/linux/bpf.h > bpf_helper_defs.h
+		--file $(srctree)/tools/include/uapi/linux/bpf.h > $(BPF_HELPER_DEFS)
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
@@ -243,7 +244,7 @@ install_lib: all_cmd
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_FILE) $(DESTDIR)$(libdir_SQ)
 
-install_headers: bpf_helper_defs.h
+install_headers: $(BPF_HELPER_DEFS)
 	$(call QUIET_INSTALL, headers) \
 		$(call do_install,bpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
@@ -251,7 +252,7 @@ install_headers: bpf_helper_defs.h
 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
 		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
-		$(call do_install,bpf_helper_defs.h,$(prefix)/include/bpf,644); \
+		$(call do_install,$(BPF_HELPER_DEFS),$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_core_read.h,$(prefix)/include/bpf,644);
@@ -271,7 +272,7 @@ install: install_lib install_pkgconfig
 clean:
 	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(CMD_TARGETS) \
 		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
-		*.pc LIBBPF-CFLAGS bpf_helper_defs.h \
+		*.pc LIBBPF-CFLAGS $(BPF_HELPER_DEFS) \
 		$(SHARED_OBJDIR) $(STATIC_OBJDIR)
 	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
 
diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 419652458da4..1ff0a9f49c01 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -40,3 +40,4 @@ xdping
 test_cpp
 /no_alu32
 /bpf_gcc
+bpf_helper_defs.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e0fe01d9ec33..e2fd6f8d579c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -120,9 +120,9 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
-BPF_HELPERS := $(BPFDIR)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
-$(BPFDIR)/bpf_helper_defs.h:
-	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ bpf_helper_defs.h
+BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
+$(OUTPUT)/bpf_helper_defs.h:
+	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
-- 
2.24.1.735.g03f4e72817-goog

