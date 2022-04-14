Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C005014EB
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbiDNNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345128AbiDNNpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:45:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6D5FD5;
        Thu, 14 Apr 2022 06:42:40 -0700 (PDT)
Received: from kwepemi100016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KfLFW1Dt7zgYjT;
        Thu, 14 Apr 2022 21:40:47 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 kwepemi100016.china.huawei.com (7.221.188.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 21:42:37 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 21:42:36 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <trix@redhat.com>, <ak@linux.intel.com>,
        <adrian.hunter@intel.com>, <james.clark@arm.com>,
        <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <llvm@lists.linux.dev>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH] perf llvm: Fix compile bpf failed to cope with latest llvm
Date:   Thu, 14 Apr 2022 21:41:34 +0800
Message-ID: <20220414134134.247912-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline assembly used by asm/sysreg.h is incompatible with latest llvm,
If bpf C program include "linux/ptrace.h" (which is common), compile will fail:

 # perf --debug verbose record -e bpf-output/no-inherit,name=evt/ \
                              -e ./perf_bpf_test.c/map:channel.event=evt/ ls
 [SNIP]
 /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:20:7: error: invalid output constraint '=a' in asm
                          : "="REG_OUT (res)
                           ^
 /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:48:7: error: invalid output constraint '=a' in asm
                          : "="REG_OUT (res)
                           ^
 In file included from /root/projects/perf-bpf/perf_bpf_test.c:2:
 In file included from /lib/modules/5.17/build/./include/linux/ptrace.h:6:
 In file included from /lib/modules/5.17/build/./include/linux/sched.h:12:
 In file included from /lib/modules/5.17/build/./arch/x86/include/asm/current.h:6:
 In file included from /lib/modules/5.17/build/./arch/x86/include/asm/percpu.h:27:
 In file included from /lib/modules/5.17/build/./include/linux/kernel.h:25:
 In file included from /lib/modules/5.17/build/./include/linux/math.h:6:
 /lib/modules/5.17.0/build/./arch/x86/include/asm/div64.h:85:28: error: invalid output constraint '=a' in asm
         asm ("mulq %2; divq %3" : "=a" (q)
 [SNIP]
 # cat /root/projects/perf-bpf/perf_bpf_test.c
 /************************ BEGIN **************************/
 #include <uapi/linux/bpf.h>
 #include <linux/ptrace.h>
 #include <linux/types.h>
 #define SEC(NAME) __attribute__((section(NAME), used))

 struct bpf_map_def {
         unsigned int type;
         unsigned int key_size;
         unsigned int value_size;
         unsigned int max_entries;
 };

 static int (*perf_event_output)(void *, struct bpf_map_def *, int, void *,
     unsigned long) = (void *)BPF_FUNC_perf_event_output;

 struct bpf_map_def SEC("maps") channel = {
         .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
         .key_size = sizeof(int),
         .value_size = sizeof(__u32),
         .max_entries = __NR_CPUS__,
 };

 #define MIN_BYTES 1024

 SEC("func=vfs_read")
 int bpf_myprog(struct pt_regs *ctx)
 {
         long bytes = ctx->dx;
         if (bytes >= MIN_BYTES) {
                 perf_event_output(ctx, &channel, BPF_F_CURRENT_CPU,
                                   &bytes, sizeof(bytes));
         }

         return 0;
 }

char _license[] SEC("license") = "GPL";
int _version SEC("version") = LINUX_VERSION_CODE;
/************************* END ***************************/

Compilation command is modified to be the same as that in samples/bpf/Makefile,
use clang | opt | llvm-dis | llc chain of commands to solve the problem.
see the comment in samples/bpf/Makefile.

Modifications:
1. Change "clang --target bpf" to chain of commands "clang | opt | llvm-dis | llc"
2. Delete "CLANG_EMIT_LLVM" and "LLVM_OPTIONS_PIPE" macros from the compilation
   command because the two macros are not defined and the content is empty.
3. Add options llvm.llvm-opt-path, llvm.llvm-dis-path, and llvm.llc-path to
   perf config for user-defined settings, which are similar to llvm.clang-path.
4. Add "-Wno-address-of-packed-member" to resolve the compilation warning of
   "/lib/modules/5.17/build/./arch/x86/include/asm/processor.h:552:17: \
    warning: taking address of packed member 'sp0' of class or structure \
    'x86_hw_tss' may result in an unaligned pointer value [-Waddress-of-packed-member]
        this_cpu_write(cpu_tss_rw.x86_tss.sp0, sp0);
                       ^~~~~~~~~~~~~~~~~~~~~~
   /lib/modules/5.17/build/./include/linux/percpu-defs.h:508:68: note: \
   expanded from macro 'this_cpu_write' \
    #define this_cpu_write(pcp, val)        __pcpu_size_call(this_cpu_write_, pcp, val)",
   which is similar to that of sample/bpf/Makefile.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Documentation/perf-config.txt | 16 ++++++++++-
 tools/perf/util/llvm-utils.c             | 35 ++++++++++++++++++------
 tools/perf/util/llvm-utils.h             |  4 +++
 3 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Documentation/perf-config.txt b/tools/perf/Documentation/perf-config.txt
index 0420e71698ee..48f12bd6ca9a 100644
--- a/tools/perf/Documentation/perf-config.txt
+++ b/tools/perf/Documentation/perf-config.txt
@@ -655,6 +655,15 @@ llvm.*::
 	llvm.clang-path::
 		Path to clang. If omit, search it from $PATH.
 
+	llvm.llvm-opt-path::
+		Path to llvm opt. If omit, search it from $PATH.
+
+	llvm.llvm-dis-path::
+		Path to llvm-dis. If omit, search it from $PATH.
+
+	llvm.llc-path::
+		Path to llc. If omit, search it from $PATH.
+
 	llvm.clang-bpf-cmd-template::
 		Cmdline template. Below lines show its default value. Environment
 		variable is used to pass options.
@@ -662,8 +671,13 @@ llvm.*::
 		"-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "	\
 		"$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
 		"-Wno-unused-value -Wno-pointer-sign "		\
+		"-Wno-address-of-packed-member "                \
 		"-working-directory $WORKING_DIR "		\
-		"-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
+		"-c \"$CLANG_SOURCE\" "                               \
+		"-O2 -emit-llvm -Xclang -disable-llvm-passes -o - | " \
+		"$LLVM_OPT_EXEC -O2 -mtriple=bpf-pc-linux | "         \
+		"$LLVM_DIS_EXEC | "                                   \
+		"$LLC_EXEC -march=bpf -filetype=obj -o -"
 
 	llvm.clang-opt::
 		Options passed to clang.
diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index 96c8ef60f4f8..c939681dfafb 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -24,11 +24,18 @@
 		"-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "	\
 		"$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
 		"-Wno-unused-value -Wno-pointer-sign "		\
+		"-Wno-address-of-packed-member "		\
 		"-working-directory $WORKING_DIR "		\
-		"-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
+		"-c \"$CLANG_SOURCE\" "				      \
+		"-O2 -emit-llvm -Xclang -disable-llvm-passes -o - | " \
+		"$LLVM_OPT_EXEC -O2 -mtriple=bpf-pc-linux | "	      \
+		"$LLVM_DIS_EXEC | "				      \
+		"$LLC_EXEC -march=bpf -filetype=obj -o -"
 
 struct llvm_param llvm_param = {
 	.clang_path = "clang",
+	.llvm_opt_path = "opt",
+	.llvm_dis_path = "llvm-dis",
 	.llc_path = "llc",
 	.clang_bpf_cmd_template = CLANG_BPF_CMD_DEFAULT_TEMPLATE,
 	.clang_opt = NULL,
@@ -48,6 +55,12 @@ int perf_llvm_config(const char *var, const char *value)
 
 	if (!strcmp(var, "clang-path"))
 		llvm_param.clang_path = strdup(value);
+	else if (!strcmp(var, "llvm-opt-path"))
+		llvm_param.llvm_opt_path = strdup(value);
+	else if (!strcmp(var, "llvm-dis-path"))
+		llvm_param.llvm_dis_path = strdup(value);
+	else if (!strcmp(var, "llc-path"))
+		llvm_param.llc_path = strdup(value);
 	else if (!strcmp(var, "clang-bpf-cmd-template"))
 		llvm_param.clang_bpf_cmd_template = strdup(value);
 	else if (!strcmp(var, "clang-opt"))
@@ -456,6 +469,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 	char linux_version_code_str[64];
 	const char *clang_opt = llvm_param.clang_opt;
 	char clang_path[PATH_MAX], llc_path[PATH_MAX], abspath[PATH_MAX], nr_cpus_avail_str[64];
+	char llvm_opt_path[PATH_MAX], llvm_dis_path[PATH_MAX];
 	char serr[STRERR_BUFSIZE];
 	char *kbuild_dir = NULL, *kbuild_include_opts = NULL,
 	     *perf_bpf_include_opts = NULL;
@@ -475,9 +489,10 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 	if (!template)
 		template = CLANG_BPF_CMD_DEFAULT_TEMPLATE;
 
-	err = search_program_and_warn(llvm_param.clang_path,
-			     "clang", clang_path);
-	if (err)
+	if (search_program_and_warn(llvm_param.clang_path, "clang", clang_path) ||
+	    search_program_and_warn(llvm_param.llvm_opt_path, "opt", llvm_opt_path) ||
+	    search_program_and_warn(llvm_param.llvm_dis_path, "llvm-dis", llvm_dis_path) ||
+	    search_program_and_warn(llvm_param.llc_path, "llc", llc_path))
 		return -ENOENT;
 
 	/*
@@ -495,21 +510,23 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	snprintf(linux_version_code_str, sizeof(linux_version_code_str),
 		 "0x%x", kernel_version);
-	if (asprintf(&perf_bpf_include_opts, "-I%s/bpf", perf_include_dir) < 0)
+	if (asprintf(&perf_bpf_include_opts, "-I%s/bpf", perf_include_dir) < 0) {
+		err = -ENOMEM;
 		goto errout;
+	}
+
 	force_set_env("NR_CPUS", nr_cpus_avail_str);
 	force_set_env("LINUX_VERSION_CODE", linux_version_code_str);
 	force_set_env("CLANG_EXEC", clang_path);
+	force_set_env("LLVM_OPT_EXEC", llvm_opt_path);
+	force_set_env("LLVM_DIS_EXEC", llvm_dis_path);
+	force_set_env("LLC_EXEC", llc_path);
 	force_set_env("CLANG_OPTIONS", clang_opt);
 	force_set_env("KERNEL_INC_OPTIONS", kbuild_include_opts);
 	force_set_env("PERF_BPF_INC_OPTIONS", perf_bpf_include_opts);
 	force_set_env("WORKING_DIR", kbuild_dir ? : ".");
 
 	if (opts) {
-		err = search_program_and_warn(llvm_param.llc_path, "llc", llc_path);
-		if (err)
-			goto errout;
-
 		err = -ENOMEM;
 		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
 			      template, llc_path, opts) < 0) {
diff --git a/tools/perf/util/llvm-utils.h b/tools/perf/util/llvm-utils.h
index 7878a0e3fa98..e276d10f85b4 100644
--- a/tools/perf/util/llvm-utils.h
+++ b/tools/perf/util/llvm-utils.h
@@ -11,6 +11,10 @@
 struct llvm_param {
 	/* Path of clang executable */
 	const char *clang_path;
+	/* Path of llvm opt executable */
+	const char *llvm_opt_path;
+	/* Path of llvm-dis executable */
+	const char *llvm_dis_path;
 	/* Path of llc executable */
 	const char *llc_path;
 	/*
-- 
2.30.GIT

