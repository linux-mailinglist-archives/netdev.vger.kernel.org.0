Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F261310A0F9
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 16:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKZPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 10:10:52 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36291 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfKZPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 10:10:52 -0500
Received: by mail-qt1-f196.google.com with SMTP id y10so21746727qto.3;
        Tue, 26 Nov 2019 07:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=s1e6R5LzISNI3RRfOMJIG7ybk8wvYFHMYA9iGjx9Lug=;
        b=aX8cMxjiwRsH8dV2icZ1VyJaJS66qh0ltpBVpx7KR6uoCEyN/VxmJJgKFviDa+lBIb
         NpRN4dVSED2QbqeF6kqmxce4vfxA014QCX72poJHh6Xf3Bl2xJyCArGcygRoG0Iis3FI
         kCxtDirx+30qdh0xRhaNGWAx5J6PdSe5eAgDySPViexFdJYV2fxY0Dos3OX640DjvrIj
         eif0gz412JhyQZHZd3BxFN0NXSjZM6QMnrl2xZhKSYrioa+iuhalB5nDpPduniuBuPLz
         1oUx1juMcOBZ3f5yhQgZtJyy0VnGiTyyUfd1/fnISz4JXPWr6iqGKTaG7CSKKrxAWNzZ
         AbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=s1e6R5LzISNI3RRfOMJIG7ybk8wvYFHMYA9iGjx9Lug=;
        b=MiJBlWgeiB0GfZHShu6HKSAvhM6/SwfW4R5bn4joKuDYlEVosGPmrGxO3aryLbtlle
         8mGZ/p9SaybZNj1V00CgwRwr5ZloQAesnbHwKwEzZ6pZgMGyGhGfohgtg6CKrmAl3YK0
         yyyNpEzuYRqD4hMle8UkweoJhmtrNWiFT34185f0IuecwNMwn8RuRtx5tAGUyvqF4/vo
         QvKmhb0kDDz45NF3qsXsds25ADsK5iyOnGyDOKkPpLP0gG2Dv6CXMIRLwvaDTc8jWuyJ
         vP0wj22wLWP49jEfL0Gl+ZO8yR5avt3+oYyfQiUVJyAJiK1KujcD0DljmE+JjzLXD06I
         Y/SQ==
X-Gm-Message-State: APjAAAVAc5jG/0VJtzYNVwltkpcuR1vczD3dFDoVAlHjai+MOKCJltgM
        KgPUMHhAqqv2Lnk7w+6IgqY=
X-Google-Smtp-Source: APXvYqzH5QpMTB24j6jx3odDXoCfM3tfuXsE5dasbM5Ddo1jOKR9U5ifpZXmu1yEbrfsnwBoUr7Xig==
X-Received: by 2002:ac8:66d7:: with SMTP id m23mr25666497qtp.53.1574781049030;
        Tue, 26 Nov 2019 07:10:49 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id c25sm5189708qkl.23.2019.11.26.07.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 07:10:47 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8A75A40D3E; Tue, 26 Nov 2019 12:10:45 -0300 (-03)
Date:   Tue, 26 Nov 2019 12:10:45 -0300
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126151045.GB19483@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

   While merging perf/core with mainline I found the problem below for
which I'm adding this patch to my perf/core branch, that soon will go
Ingo's way, etc. Please let me know if you think this should be handled
some other way,

Thanks,

- Arnaldo

commit 94b2e22463f592d2161eb491ddb0b4659e2a91b4
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Nov 26 11:46:08 2019 -0300

    libbpf: Fix up generation of bpf_helper_defs.h
    
    Building perf as a detached tarball, i.e. by using one of:
    
      $ make help | grep perf
        perf-tar-src-pkg    - Build perf-5.4.0.tar source tarball
        perf-targz-src-pkg  - Build perf-5.4.0.tar.gz source tarball
        perf-tarbz2-src-pkg - Build perf-5.4.0.tar.bz2 source tarball
        perf-tarxz-src-pkg  - Build perf-5.4.0.tar.xz source tarball
      $
    
    And then trying to build the resulting tarball, which is the first thing
    that running:
    
      $ make -C tools/perf build-test
    
    does, ends up with these two problems:
    
      make[3]: *** No rule to make target '/tmp/tmp.zq13cHILGB/perf-5.3.0/include/uapi/linux/bpf.h', needed by 'bpf_helper_defs.h'.  Stop.
      make[3]: *** Waiting for unfinished jobs....
      make[2]: *** [Makefile.perf:757: /tmp/tmp.zq13cHILGB/perf-5.3.0/tools/lib/bpf/libbpf.a] Error 2
      make[2]: *** Waiting for unfinished jobs....
    
    Because $(srcdir) points to the /tmp/tmp.zq13cHILGB/perf-5.3.0 directory
    and we need '/tools/ after that variable, and after fixing this then we
    get to another problem:
    
      /bin/sh: /home/acme/git/perf/tools/scripts/bpf_helpers_doc.py: No such file or directory
      make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 127
      make[3]: *** Deleting file 'bpf_helper_defs.h'
        LD       /tmp/build/perf/libapi-in.o
      make[2]: *** [Makefile.perf:778: /tmp/build/perf/libbpf.a] Error 2
      make[2]: *** Waiting for unfinished jobs....
    
    Because this requires something outside the tools/ directories that gets
    collected into perf's detached tarballs, to fix it just add it to
    tools/perf/MANIFEST, which this patch does, now it works for that case
    and also for all these other cases after doing a:
    
      $ make -C tools clean
    
    On a kernel sources directory:
    
      $ make -C tools/bpf/bpftool/
      make: Entering directory '/home/acme/git/perf/tools/bpf/bpftool'
    
      Auto-detecting system features:
      ...                        libbfd: [ on  ]
      ...        disassembler-four-args: [ on  ]
      ...                          zlib: [ on  ]
    
        CC       map_perf_ring.o
      <SNIP>
        CC       disasm.o
      make[1]: Entering directory '/home/acme/git/perf/tools/lib/bpf'
    
      Auto-detecting system features:
      ...                        libelf: [ on  ]
      ...                           bpf: [ on  ]
    
        MKDIR    staticobjs/
        CC       staticobjs/libbpf.o
      <SNIP>
        LD       staticobjs/libbpf-in.o
        LINK     libbpf.a
      make[1]: Leaving directory '/home/acme/git/perf/tools/lib/bpf'
        LINK     bpftool
      make: Leaving directory '/home/acme/git/perf/tools/bpf/bpftool'
      $
    
      $ make -C tools/perf
      <SNIP>
      Auto-detecting system features:
      ...                         dwarf: [ on  ]
      ...            dwarf_getlocations: [ on  ]
      ...                         glibc: [ on  ]
      ...                          gtk2: [ on  ]
      ...                      libaudit: [ on  ]
      ...                        libbfd: [ on  ]
      ...                        libcap: [ on  ]
      ...                        libelf: [ on  ]
      ...                       libnuma: [ on  ]
      ...        numa_num_possible_cpus: [ on  ]
      ...                       libperl: [ on  ]
      ...                     libpython: [ on  ]
      ...                     libcrypto: [ on  ]
      ...                     libunwind: [ on  ]
      ...            libdw-dwarf-unwind: [ on  ]
      ...                          zlib: [ on  ]
      ...                          lzma: [ on  ]
      ...                     get_cpuid: [ on  ]
      ...                           bpf: [ on  ]
      ...                        libaio: [ on  ]
      ...                       libzstd: [ on  ]
      ...        disassembler-four-args: [ on  ]
    
        GEN      common-cmds.h
        CC       exec-cmd.o
        <SNIP>
        CC       util/pmu.o
        CC       util/pmu-flex.o
        LD       util/perf-in.o
        LD       perf-in.o
        LINK     perf
      make: Leaving directory '/home/acme/git/perf/tools/perf'
      $
    
      $ make -C tools/lib/bpf
      make: Entering directory '/home/acme/git/perf/tools/lib/bpf'
    
      Auto-detecting system features:
      ...                        libelf: [ on  ]
      ...                           bpf: [ on  ]
    
        HOSTCC   fixdep.o
        HOSTLD   fixdep-in.o
        LINK     fixdep
      Parsed description of 117 helper function(s)
        MKDIR    staticobjs/
        CC       staticobjs/libbpf.o
        CC       staticobjs/bpf.o
        CC       staticobjs/nlattr.o
        CC       staticobjs/btf.o
        CC       staticobjs/libbpf_errno.o
        CC       staticobjs/str_error.o
        CC       staticobjs/netlink.o
        CC       staticobjs/bpf_prog_linfo.o
        CC       staticobjs/libbpf_probes.o
        CC       staticobjs/xsk.o
        CC       staticobjs/hashmap.o
        CC       staticobjs/btf_dump.o
        LD       staticobjs/libbpf-in.o
        LINK     libbpf.a
        MKDIR    sharedobjs/
        CC       sharedobjs/libbpf.o
        CC       sharedobjs/bpf.o
        CC       sharedobjs/nlattr.o
        CC       sharedobjs/btf.o
        CC       sharedobjs/libbpf_errno.o
        CC       sharedobjs/str_error.o
        CC       sharedobjs/netlink.o
        CC       sharedobjs/bpf_prog_linfo.o
        CC       sharedobjs/libbpf_probes.o
        CC       sharedobjs/xsk.o
        CC       sharedobjs/hashmap.o
        CC       sharedobjs/btf_dump.o
        LD       sharedobjs/libbpf-in.o
        LINK     libbpf.so.0.0.6
        GEN      libbpf.pc
        LINK     test_libbpf
      make: Leaving directory '/home/acme/git/perf/tools/lib/bpf'
      $
    
    Fixes: e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, tracing}.h into libbpf")
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Alexei Starovoitov <ast@kernel.org>
    Cc: Andrii Nakryiko <andriin@fb.com>
    Cc: Daniel Borkmann <daniel@iogearbox.net>
    Cc: Jiri Olsa <jolsa@kernel.org>
    Cc: Martin KaFai Lau <kafai@fb.com>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Link: https://lkml.kernel.org/n/tip-4pnkg2vmdvq5u6eivc887wen@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 99425d0be6ff..8ec6bc4e5e46 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -180,9 +180,9 @@ $(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
 $(BPF_IN_STATIC): force elfdep bpfdep bpf_helper_defs.h
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
-bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
+bpf_helper_defs.h: $(srctree)/tools/include/uapi/linux/bpf.h
 	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
-		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
+		--file $(srctree)/tools/include/uapi/linux/bpf.h > bpf_helper_defs.h
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 70f1ff4e2eb4..4934edb5adfd 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -19,3 +19,4 @@ tools/lib/bitmap.c
 tools/lib/str_error_r.c
 tools/lib/vsprintf.c
 tools/lib/zalloc.c
+scripts/bpf_helpers_doc.py
