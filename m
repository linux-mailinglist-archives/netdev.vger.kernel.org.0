Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C204C5E8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFTDpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 23:45:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45414 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfFTDpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 23:45:09 -0400
Received: by mail-oi1-f193.google.com with SMTP id m206so1054832oib.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hmozZ3T7yXiQbHQwiiLz6hpYqDbodbt9yn6e1/Zlmk=;
        b=h4QOvbpsIt3d3LIasq/8Yn9F2fiY5AlxUwWHg9KnfBzwX7+RIOOprlOJs74qJhE4Vu
         yyvd9iiQy3wAg8/sDoD10cYJ2q5JODGUJ4tr+p0Wocb+qt/m0/g2GlfyDpxStAe8oVUA
         UsdhPWpAdT0m3ROySt69iAsmqqgcIUuDeBO+JU3WS+ROWDeKOrv20SF9qkNVGco16keF
         th/rxkbUIdSsIXln6ei/JQmYggM+NGNOaw2KsL/FlzlIDoswiS6LIeS8fiJJcGM3TD4q
         M9E8JaXuVTqZ6QKTfNjkGmFE5nXzW2dbKd6E9m9dTj33u56ao9L6GcOt6GPBw7jXH5I7
         Bmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hmozZ3T7yXiQbHQwiiLz6hpYqDbodbt9yn6e1/Zlmk=;
        b=a9GKJeYuzJ3ux6Q3o0dWCHXjtkvjF0PPaN/5dph+ZsO+v8yRQaepq0cwwZBLVSO2Gf
         Dc8uFWrtVJTB8ld+ZbjlKHali8f3uWTIUQ0BnMnEK3K23LsQmjdMgiypdGIARXccoEVW
         fYL8CaBjUE1uKXGub9jURCVkBKlyUcakyPwHXCCOhR+o7W3oFO8a98M+S2eWoO0eQIn4
         /zXaGGR3RLBE4mGKhWy/M2cZZPhrJ4H7GymLEbJIMw0aN6zZ6a7rdqQq5b1wlZjA1k1g
         qsvHwnZk4TJ6hqXvK4O0W+18gz/98UFOiadNLgLIWDgQMluCRmGJnwgE8AXJRfZvuXyI
         tphA==
X-Gm-Message-State: APjAAAWWk+4p6XX32i5w04pX5Fn5vraUdnA1LET9ZDmdTPeKMfjJUnjA
        KOKHQadGuu8MqFHirskwerShRg==
X-Google-Smtp-Source: APXvYqxibUhIiIOjuUpqxJfBW3ShhDR1KSMaBGfRGCWxo0//PMWa/TCML0kWk4uvNJre+U0LPcgTZA==
X-Received: by 2002:aca:f4ce:: with SMTP id s197mr5088167oih.45.1561002308790;
        Wed, 19 Jun 2019 20:45:08 -0700 (PDT)
Received: from localhost.localdomain (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id a18sm7142158otf.67.2019.06.19.20.45.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 20:45:07 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        coresight@lists.linaro.org
Subject: [PATCH v3] perf cs-etm: Improve completeness for kernel address space
Date:   Thu, 20 Jun 2019 11:44:46 +0800
Message-Id: <20190620034446.25561-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
address and reduce this size from 'etmq->etm->kernel_start', then can
get a fixed up kernel start address which contain memory regions for
device module and BPF.  Finally, cs_etm__cpu_mode() can return right
mode for these memory regions and perf can successfully generate
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

- Build LLVM/Clang 8.0 or later version;

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
  ffff000000086a84 t bpf_prog_f173133dc38ccf87_sys_enter  [bpf]
  ffff000000088618 t bpf_prog_c1bd85c092d6e4aa_sys_exit   [bpf]

- Launch any program which accesses file system frequently so can hit
  the system calls trace flow with eBPF event;

- Capture CoreSight trace data with filtering eBPF program:

  root@debian:~# perf record -e cs_etm/@20070000.etr/ \
	  --filter 'filter 0xffff000000086a84/0x800' -a sleep 5s

- Annotate for symbol 'bpf_prog_f173133dc38ccf87_sys_enter':

  root@debian:~# perf report
  Then select 'branches' samples and press 'a' to annotate symbol
  'bpf_prog_f173133dc38ccf87_sys_enter', press 'P' to print to the
  bpf_prog_f173133dc38ccf87_sys_enter.annotation file:

  root@debian:~# cat bpf_prog_f173133dc38ccf87_sys_enter.annotation

  bpf_prog_f173133dc38ccf87_sys_enter() bpf_prog_f173133dc38ccf87_sys_enter
  Event: branches

  Percent      int sys_enter(struct syscall_enter_args *args)
                 stp  x29, x30, [sp, #-16]!

               	int key = 0;
                 mov  x29, sp

                       augmented_args = bpf_map_lookup_elem(&augmented_filename_map, &key);
                 stp  x19, x20, [sp, #-16]!

                       augmented_args = bpf_map_lookup_elem(&augmented_filename_map, &key);
                 stp  x21, x22, [sp, #-16]!

                 stp  x25, x26, [sp, #-16]!

               	return bpf_get_current_pid_tgid();
                 mov  x25, sp

               	return bpf_get_current_pid_tgid();
                 mov  x26, #0x0                   	// #0

                 sub  sp, sp, #0x10

               	return bpf_map_lookup_elem(pids, &pid) != NULL;
                 add  x19, x0, #0x0

                 mov  x0, #0x0                   	// #0

                 mov  x10, #0xfffffffffffffff8    	// #-8

               	if (pid_filter__has(&pids_filtered, getpid()))
                 str  w0, [x25, x10]

               	probe_read(&augmented_args->args, sizeof(augmented_args->args), args);
                 add  x1, x25, #0x0

               	probe_read(&augmented_args->args, sizeof(augmented_args->args), args);
                 mov  x10, #0xfffffffffffffff8    	// #-8

               	syscall = bpf_map_lookup_elem(&syscalls, &augmented_args->args.syscall_nr);
                 add  x1, x1, x10

               	syscall = bpf_map_lookup_elem(&syscalls, &augmented_args->args.syscall_nr);
                 mov  x0, #0xffff8009ffffffff    	// #-140694538682369

                 movk x0, #0x6698, lsl #16

                 movk x0, #0x3e00

                 mov  x10, #0xffffffffffff1040    	// #-61376

               	if (syscall == NULL || !syscall->enabled)
                 movk x10, #0x1023, lsl #16

               	if (syscall == NULL || !syscall->enabled)
                 movk x10, #0x0, lsl #32

               	loop_iter_first()
    3.69       → blr  bpf_prog_f173133dc38ccf87_sys_enter
               	loop_iter_first()
                 add  x7, x0, #0x0

               	loop_iter_first()
                 add  x20, x7, #0x0

               	int size = probe_read_str(&augmented_filename->value, filename_len, filename_arg);
                 mov  x0, #0x1                   	// #1

  [...]

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/Makefile.config | 22 ++++++++++++++++++++++
 tools/perf/util/cs-etm.c   | 19 ++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 51dd00f65709..a58cd5a43a98 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -418,6 +418,28 @@ ifdef CORESIGHT
     endif
     LDFLAGS += $(LIBOPENCSD_LDFLAGS)
     EXTLIBS += $(OPENCSDLIBS)
+    PRE_START_SIZE := 0
+    ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
+      ifeq ($(SRCARCH),arm64)
+        # Extract info from lds:
+        #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
+        # PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000) = 0x10080000
+        PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
+          $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+          sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+          awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
+      endif
+      ifeq ($(SRCARCH),arm)
+        # Extract info from lds:
+        #   . = ((0xC0000000)) + 0x00208000;
+        # PRE_START_SIZE := 0x00208000
+        PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
+          $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+          sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+          awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
+      endif
+    endif
+    CFLAGS += -DARM_PRE_START_SIZE=$(PRE_START_SIZE)
     $(call detected,CONFIG_LIBOPENCSD)
     ifdef CSTRACE_RAW
       CFLAGS += -DCS_DEBUG_RAW
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 0c7776b51045..5fa0be3a3904 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -613,10 +613,27 @@ static void cs_etm__free(struct perf_session *session)
 static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
 {
 	struct machine *machine;
+	u64 fixup_kernel_start = 0;
 
 	machine = etmq->etm->machine;
 
-	if (address >= etmq->etm->kernel_start) {
+	/*
+	 * Since arm and arm64 specify some memory regions prior to
+	 * 'kernel_start', kernel addresses can be less than 'kernel_start'.
+	 *
+	 * For arm architecture, the 16MB virtual memory space prior to
+	 * 'kernel_start' is allocated to device modules, a PMD table if
+	 * CONFIG_HIGHMEM is enabled and a PGD table.
+	 *
+	 * For arm64 architecture, the root PGD table, device module memory
+	 * region and BPF jit region are prior to 'kernel_start'.
+	 *
+	 * To reflect the complete kernel address space, compensate these
+	 * pre-defined regions for kernel start address.
+	 */
+	fixup_kernel_start = etmq->etm->kernel_start - ARM_PRE_START_SIZE;
+
+	if (address >= fixup_kernel_start) {
 		if (machine__is_host(machine))
 			return PERF_RECORD_MISC_KERNEL;
 		else
-- 
2.17.1

