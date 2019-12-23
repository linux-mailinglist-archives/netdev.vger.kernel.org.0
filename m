Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5909A129111
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 04:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLWDFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 22:05:39 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54380 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfLWDFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 22:05:39 -0500
Received: by mail-pj1-f65.google.com with SMTP id kx11so2703637pjb.4;
        Sun, 22 Dec 2019 19:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1PF13WTRlXWAqJo9Ns5429HXKixxKYXJGlm3W2emPxY=;
        b=Vl6YDCfI5JNsE+9+ty2YVcCcsOQmeIvJVXASYbCHxg/W+jGC4iakz1dixXR7GQLpzF
         EzBPOvu1cBBSc64OGMQFITq5BnvaHbVWdXwjJS08NeHovZdBXWgrHBHiEH1++UHKYkDJ
         34cORcZuBBoCcOp9DnuPLlv5wgI5eDUcxZ+PJZhQ49uMYtcTGrXMjuDP2ouZjB6z3r5D
         ZD/jfVtDODqR9fR58i4yPuO2caiEPbftSqBXOxnT3XmEwnoY8evsCZk+T9n4AhUEzid3
         a5TIsju9fFznKXtnY0mKscpBHwQgv5OEMMAXkwsvyJDpPrf7mFQ41Rz32HGk6vD3FshS
         l2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1PF13WTRlXWAqJo9Ns5429HXKixxKYXJGlm3W2emPxY=;
        b=RtcrhF/PTOce9j+ujpceHdshNVdBFda/Rv60/hipJ3r58FoXXN7topzAw+wlg3zJUa
         pfQqAdyEIgMJT98okqaRpMQI4JlVwBZ+tka4P6Tj3Sw0iArgoEZCd2+Ra1tUEp9OMzXr
         j27sOhV3PKrwsVAsWSq8MHD7HPrYpXgSgl8rciw7ceF9V/VNg7bOXEF8KDug6sZEHcX3
         x3ZYOGTRtgn0QpIsGD7rTJHeFz5oRkuf+Jk3eYARJwyPWNit4BlJMHIMhQl0TzoNoIZK
         Pim+77XNLXqiQXWpjFNG4axkt5EyjrtCakl21h1hQNtOSTGDNOx4g70vUmB06RReiVgg
         41Hw==
X-Gm-Message-State: APjAAAUDKpQ4T+c2i9x8REQYlS2Fxv/Wv2hUwXbFHAd8Kzi77bePR4QP
        mwteHnusPnUsLAN2AFMMyaY=
X-Google-Smtp-Source: APXvYqyXDldD69h9xW7hVtjTEfETbazMMt4qJHKRFkynb7hiARw37NrLC9Kq46SP33GgVQ+XHwM7DQ==
X-Received: by 2002:a17:90a:a60f:: with SMTP id c15mr7458709pjq.61.1577070338157;
        Sun, 22 Dec 2019 19:05:38 -0800 (PST)
Received: from gaurie.seo.corp.google.com ([2401:fa00:d:1:4eb0:a5ef:3975:7440])
        by smtp.gmail.com with ESMTPSA id 3sm20711717pfi.13.2019.12.22.19.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 19:05:37 -0800 (PST)
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH bpf] libbpf: Fix build on read-only filesystems
Date:   Mon, 23 Dec 2019 12:05:30 +0900
Message-Id: <20191223030530.725937-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20191221162158.rw6xqqktubozg6fg@ast-mbp.dhcp.thefacebook.com>
References: <20191221162158.rw6xqqktubozg6fg@ast-mbp.dhcp.thefacebook.com>
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/bpf/Makefile               | 15 ++++++++-------
 tools/testing/selftests/bpf/Makefile |  6 +++---
 2 files changed, 11 insertions(+), 10 deletions(-)

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

