Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C08E63E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbfHOIZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:25:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38290 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbfHOIZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 04:25:47 -0400
Received: by mail-pg1-f196.google.com with SMTP id e11so1014153pga.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 01:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=30cHDPSODRjzx60oee0Lo4biVeqVEQUgsOye86CZdQ0=;
        b=ujE9YZn8x6/VcmU/0Z+b4S3X6Cc16ZsAIPvkqSVtQwq16OT9HflIeTaqoSW2FR/Ke7
         pu0uhXzPhdpX9DiT3XQgShPJlpuqBxJdNZs8Aaj4cB7dfExAZzxyM39q8LLWdC+UpKOz
         k90c82vCno8LxDjEONoJFd2bg3U4bdlt53Fjr9zXU3s7TlwjqTN4SbME2Rzl7e8n0ylT
         gi2S+9nTPjn00Unn9INJNJx7m+ofE0Y8KoJqrT5whrrkCi72chH938iGwKZsohAywF77
         TKe7KYSqgpYalJHvwHRD5S4s2yVrMCYUwk9A3QGiG047eiYL1AX6eLc0rqvqgn2Wj0MD
         qFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=30cHDPSODRjzx60oee0Lo4biVeqVEQUgsOye86CZdQ0=;
        b=BssnZcbyIQqPMkLgsPZeZUHvHTeJGonqaikYP1749kYYoLKMTt69AObMq7dmwhei39
         uvfdBSFqtGKjUoQh3+CA/AUdLh1U9tEqn9qVozD9KgbcbkU2lqNc/DRSHbTAzj5nPIHj
         sKpCP0bUHasRzh6SkKidNiMeCaLDRQQt8zFMmRBmyPKiPtRMUI+F6dQkZ4yiaaHhzSbU
         hZUHkiKrDPvTLwofrpngc39Ml1g4fGAEa1CTlnPnEr9caMSJbzl80GNwsKt/BCEZFvYb
         cAKLDEB9PNVg8hpeAPdUl+L0kqozEF0ZzutCjpWChZPVPATuS3epPZX4Rkshin3SrRXf
         Qmww==
X-Gm-Message-State: APjAAAV6etxSSfGWzAfpccltmAYy5nWjxJ+QRHzPTvOl8WVNAhdT0PMo
        MWefMiGymOfCuKOgIrPbBH7T2A==
X-Google-Smtp-Source: APXvYqwjBEsniOi5hJVUrh23+U47HSZ1lTJaoKAz8PwNLCTH7NTTuxiXAdNbrYWwQMmDwCRhuMpAuQ==
X-Received: by 2002:aa7:87d5:: with SMTP id i21mr4259475pfo.70.1565857546207;
        Thu, 15 Aug 2019 01:25:46 -0700 (PDT)
Received: from localhost.localdomain (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id e6sm2399223pfl.37.2019.08.15.01.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 01:25:45 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5] perf machine: arm/arm64: Improve completeness for kernel address space
Date:   Thu, 15 Aug 2019 16:25:21 +0800
Message-Id: <20190815082521.16885-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arm and arm64 architecture reserve some memory regions prior to the
symbol '_stext' and these memory regions later will be used by device
module and BPF jit.  The current code misses to consider these memory
regions thus any address in the regions will be taken as user space
mode, but perf cannot find the corresponding dso with the wrong CPU
mode so we misses to generate samples for device module and BPF
related trace data.

This patch parse the link scripts to get the memory size prior to start
address and reduce this size from 'machine>->kernel_start', then can
get a fixed up kernel start address which contain memory regions for
device module and BPF.  Finally, machine__get_kernel_start() can reflect
more complete kernel memory regions and perf can successfully generate
samples.

The reason for parsing the link scripts is Arm architecture changes text
offset dependent on different platforms, which define multiple text
offsets in $kernel/arch/arm/Makefile.  This offset is decided when build
kernel and the final value is extended in the link script, so we can
extract the used value from the link script.  We use the same way to
parse arm64 link script as well.  If fail to find the link script, the
pre start memory size is assumed as zero, in this case it has no any
change caused with this patch.

Below is detailed info for testing this patch:

- Install or build LLVM/Clang;

- Configure perf with ~/.perfconfig:

  root@debian:~# cat ~/.perfconfig
  # this file is auto-generated.
  [llvm]
          clang-path = /mnt/build/llvm-build/build/install/bin/clang
          kbuild-dir = /mnt/linux-kernel/linux-cs-dev/
          clang-opt = "-g"
          dump-obj = true

  [trace]
          show_zeros = yes
          show_duration = no
          no_inherit = yes
          show_timestamp = no
          show_arg_names = no
          args_alignment = 40
          show_prefix = yes

- Run 'perf trace' command with eBPF event:

  root@debian:~# perf trace -e string \
      -e $kernel/tools/perf/examples/bpf/augmented_raw_syscalls.c

- Read eBPF program memory mapping in kernel:

  root@debian:~# echo 1 > /proc/sys/net/core/bpf_jit_kallsyms
  root@debian:~# cat /proc/kallsyms | grep -E "bpf_prog_.+_sys_[enter|exit]"
  ffff00000008a0d0 t bpf_prog_e470211b846088d5_sys_enter  [bpf]
  ffff00000008c6a4 t bpf_prog_29c7ae234d79bd5c_sys_exit   [bpf]

- Launch any program which accesses file system frequently so can hit
  the system calls trace flow with eBPF event;

- Capture CoreSight trace data with filtering eBPF program:

  root@debian:~# perf record -e cs_etm/@tmc_etr0/ \
	--filter 'filter 0xffff00000008a0d0/0x800' -a sleep 5s

- Decode the eBPF program symbol 'bpf_prog_f173133dc38ccf87_sys_enter':

  root@debian:~# perf script -F,ip,sym
  Frame deformatter: Found 4 FSYNCS
                  0 [unknown]
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a250 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a124 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a13c bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a180 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a190 bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a250 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a124 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a180 bpf_prog_e470211b846088d5_sys_enter
   [...]

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/Makefile.config | 22 ++++++++++++++++++++++
 tools/perf/util/machine.c  | 15 ++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index e4988f49ea79..d7ff839d8b20 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -48,9 +48,20 @@ ifeq ($(SRCARCH),x86)
   NO_PERF_REGS := 0
 endif
 
+ARM_PRE_START_SIZE := 0
+
 ifeq ($(SRCARCH),arm)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
+  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
+    # Extract info from lds:
+    #   . = ((0xC0000000)) + 0x00208000;
+    # ARM_PRE_START_SIZE := 0x00208000
+    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
+      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+      awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
+  endif
 endif
 
 ifeq ($(SRCARCH),arm64)
@@ -58,8 +69,19 @@ ifeq ($(SRCARCH),arm64)
   NO_SYSCALL_TABLE := 0
   CFLAGS += -I$(OUTPUT)arch/arm64/include/generated
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
+  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
+    # Extract info from lds:
+    #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
+    # ARM_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000) = 0x10080000
+    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
+      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+      awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
+  endif
 endif
 
+CFLAGS += -DARM_PRE_START_SIZE=$(ARM_PRE_START_SIZE)
+
 ifeq ($(SRCARCH),csky)
   NO_PERF_REGS := 0
 endif
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f6ee7fbad3e4..e993f891bb82 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2687,13 +2687,26 @@ int machine__get_kernel_start(struct machine *machine)
 	machine->kernel_start = 1ULL << 63;
 	if (map) {
 		err = map__load(map);
+		if (err)
+			return err;
+
 		/*
 		 * On x86_64, PTI entry trampolines are less than the
 		 * start of kernel text, but still above 2^63. So leave
 		 * kernel_start = 1ULL << 63 for x86_64.
 		 */
-		if (!err && !machine__is(machine, "x86_64"))
+		if (!machine__is(machine, "x86_64"))
 			machine->kernel_start = map->start;
+
+		/*
+		 * On arm/arm64, the kernel uses some memory regions which are
+		 * prior to '_stext' symbol; to reflect the complete kernel
+		 * address space, compensate these pre-defined regions for
+		 * kernel start address.
+		 */
+		if (!strcmp(perf_env__arch(machine->env), "arm") ||
+		    !strcmp(perf_env__arch(machine->env), "arm64"))
+			machine->kernel_start -= ARM_PRE_START_SIZE;
 	}
 	return err;
 }
-- 
2.17.1

