Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A97162F45
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgBRTCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:02:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:35632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRTCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 14:02:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C8EDDADBB;
        Tue, 18 Feb 2020 19:02:34 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/6] bpftool: Allow to select a specific section to probe
Date:   Tue, 18 Feb 2020 20:02:19 +0100
Message-Id: <20200218190224.22508-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218190224.22508-1-mrostecki@opensuse.org>
References: <20200218190224.22508-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces a new positional argument "section" which takes
the following arguments:

- system_config
- syscall_config
- program_types
- map_types
- helpers
- misc

If "section" argument is defined, only that particular section is going
to be probed and printed. The only section which is always going to be
probed is "syscall_config", but if the other section was provided as an
argument, "syscall_config" check will perform silently without printing
and exit bpftool if the bpf() syscall is not available (because in that
case running any probe has no sense).

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/feature.c | 159 ++++++++++++++++++++++++++++--------
 1 file changed, 123 insertions(+), 36 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 345e4a2b4f53..cfba0faf148f 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -22,6 +22,13 @@
 # define PROC_SUPER_MAGIC	0x9fa0
 #endif
 
+#define SECTION_SYSCALL_CONFIG "syscall_config"
+#define SECTION_SYSTEM_CONFIG "system_config"
+#define SECTION_PROGRAM_TYPES "program_types"
+#define SECTION_MAP_TYPES "map_types"
+#define SECTION_HELPERS "helpers"
+#define SECTION_MISC "misc"
+
 enum probe_component {
 	COMPONENT_UNSPEC,
 	COMPONENT_KERNEL,
@@ -436,24 +443,26 @@ static void probe_kernel_image_config(void)
 	}
 }
 
-static bool probe_bpf_syscall(const char *define_prefix)
+static bool
+probe_bpf_syscall(bool print_syscall_config, const char *define_prefix)
 {
 	bool res;
 
 	bpf_load_program(BPF_PROG_TYPE_UNSPEC, NULL, 0, NULL, 0, NULL, 0);
 	res = (errno != ENOSYS);
 
-	print_bool_feature("have_bpf_syscall",
-			   "bpf() syscall",
-			   "BPF_SYSCALL",
-			   res, define_prefix);
+	if (print_syscall_config)
+		print_bool_feature("have_bpf_syscall",
+				   "bpf() syscall",
+				   "BPF_SYSCALL",
+				   res, define_prefix);
 
 	return res;
 }
 
 static void
-probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
-		const char *define_prefix, __u32 ifindex)
+probe_prog_type(bool print_program_types, enum bpf_prog_type prog_type,
+		bool *supported_types, const char *define_prefix, __u32 ifindex)
 {
 	char feat_name[128], plain_desc[128], define_name[128];
 	const char *plain_comment = "eBPF program_type ";
@@ -484,8 +493,10 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 	sprintf(define_name, "%s_prog_type", prog_type_name[prog_type]);
 	uppercase(define_name, sizeof(define_name));
 	sprintf(plain_desc, "%s%s", plain_comment, prog_type_name[prog_type]);
-	print_bool_feature(feat_name, plain_desc, define_name, res,
-			   define_prefix);
+
+	if (print_program_types)
+		print_bool_feature(feat_name, plain_desc, define_name, res,
+				   define_prefix);
 }
 
 static void
@@ -587,7 +598,7 @@ section_system_config(enum probe_component target, const char *define_prefix)
 		if (define_prefix)
 			break;
 
-		print_start_section("system_config",
+		print_start_section(SECTION_SYSTEM_CONFIG,
 				    "Scanning system configuration...",
 				    NULL, /* define_comment never used here */
 				    NULL); /* define_prefix always NULL here */
@@ -608,42 +619,48 @@ section_system_config(enum probe_component target, const char *define_prefix)
 	}
 }
 
-static bool section_syscall_config(const char *define_prefix)
+static bool
+section_syscall_config(bool print_syscall_config, const char *define_prefix)
 {
 	bool res;
 
-	print_start_section("syscall_config",
-			    "Scanning system call availability...",
-			    "/*** System call availability ***/",
-			    define_prefix);
-	res = probe_bpf_syscall(define_prefix);
-	print_end_section();
+	if (print_syscall_config)
+		print_start_section(SECTION_SYSCALL_CONFIG,
+				    "Scanning system call availability...",
+				    "/*** System call availability ***/",
+				    define_prefix);
+	res = probe_bpf_syscall(print_syscall_config, define_prefix);
+	if (print_syscall_config)
+		print_end_section();
 
 	return res;
 }
 
 static void
-section_program_types(bool *supported_types, const char *define_prefix,
-		      __u32 ifindex)
+section_program_types(bool print_program_types, bool *supported_types,
+		      const char *define_prefix, __u32 ifindex)
 {
 	unsigned int i;
 
-	print_start_section("program_types",
-			    "Scanning eBPF program types...",
-			    "/*** eBPF program types ***/",
-			    define_prefix);
+	if (print_program_types)
+		print_start_section(SECTION_PROGRAM_TYPES,
+				    "Scanning eBPF program types...",
+				    "/*** eBPF program types ***/",
+				    define_prefix);
 
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_prog_type(i, supported_types, define_prefix, ifindex);
+		probe_prog_type(print_program_types, i, supported_types,
+				define_prefix, ifindex);
 
-	print_end_section();
+	if (print_program_types)
+		print_end_section();
 }
 
 static void section_map_types(const char *define_prefix, __u32 ifindex)
 {
 	unsigned int i;
 
-	print_start_section("map_types",
+	print_start_section(SECTION_MAP_TYPES,
 			    "Scanning eBPF map types...",
 			    "/*** eBPF map types ***/",
 			    define_prefix);
@@ -659,7 +676,7 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 {
 	unsigned int i;
 
-	print_start_section("helpers",
+	print_start_section(SECTION_HELPERS,
 			    "Scanning eBPF helper functions...",
 			    "/*** eBPF helper functions ***/",
 			    define_prefix);
@@ -688,7 +705,7 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 
 static void section_misc(const char *define_prefix, __u32 ifindex)
 {
-	print_start_section("misc",
+	print_start_section(SECTION_MISC,
 			    "Scanning miscellaneous eBPF features...",
 			    "/*** eBPF misc features ***/",
 			    define_prefix);
@@ -699,8 +716,25 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
 static int do_probe(int argc, char **argv)
 {
 	enum probe_component target = COMPONENT_UNSPEC;
+	/* Syscall probe is always performed, because performing any other
+	 * checks without bpf() syscall does not make sense and the program
+	 * should exit.
+	 */
+	bool print_syscall_config = false;
 	const char *define_prefix = NULL;
+	bool check_system_config = false;
+	/* Program types probes are needed if helper probes are going to be
+	 * performed. Therefore we should differentiate between checking and
+	 * printing supported program types. If only helper checks were
+	 * requested, program types probes will be performed, but not printed.
+	 */
+	bool check_program_types = false;
+	bool print_program_types = false;
 	bool supported_types[128] = {};
+	bool check_map_types = false;
+	bool check_helpers = false;
+	bool check_section = false;
+	bool check_misc = false;
 	__u32 ifindex = 0;
 	char *ifname;
 
@@ -740,6 +774,39 @@ static int do_probe(int argc, char **argv)
 				      strerror(errno));
 				return -1;
 			}
+		} else if (is_prefix(*argv, "section")) {
+			check_section = true;
+			NEXT_ARG();
+			if (is_prefix(*argv, SECTION_SYSTEM_CONFIG)) {
+				check_system_config = true;
+			} else if (is_prefix(*argv, SECTION_SYSCALL_CONFIG)) {
+				print_syscall_config = true;
+			} else if (is_prefix(*argv, SECTION_PROGRAM_TYPES)) {
+				check_program_types = true;
+				print_program_types = true;
+			} else if (is_prefix(*argv, SECTION_MAP_TYPES)) {
+				check_map_types = true;
+			} else if (is_prefix(*argv, SECTION_HELPERS)) {
+				/* When helpers probes are requested, program
+				 * types probes have to be performed, but they
+				 * may not be printed.
+				 */
+				check_program_types = true;
+				check_helpers = true;
+			} else if (is_prefix(*argv, SECTION_MISC)) {
+				check_misc = true;
+			} else {
+				p_err("unrecognized section '%s', available sections: %s, %s, %s, %s, %s, %s",
+				      *argv,
+				      SECTION_SYSTEM_CONFIG,
+				      SECTION_SYSCALL_CONFIG,
+				      SECTION_PROGRAM_TYPES,
+				      SECTION_MAP_TYPES,
+				      SECTION_HELPERS,
+				      SECTION_MISC);
+				return -1;
+			}
+			NEXT_ARG();
 		} else if (is_prefix(*argv, "macros") && !define_prefix) {
 			define_prefix = "";
 			NEXT_ARG();
@@ -764,19 +831,36 @@ static int do_probe(int argc, char **argv)
 		}
 	}
 
+	/* Perform all checks if specific section check was not requested. */
+	if (!check_section) {
+		print_syscall_config = true;
+		check_system_config = true;
+		check_program_types = true;
+		print_program_types = true;
+		check_map_types = true;
+		check_helpers = true;
+		check_misc = true;
+	}
+
 	if (json_output) {
 		define_prefix = NULL;
 		jsonw_start_object(json_wtr);
 	}
 
-	section_system_config(target, define_prefix);
-	if (!section_syscall_config(define_prefix))
+	if (check_system_config)
+		section_system_config(target, define_prefix);
+	if (!section_syscall_config(print_syscall_config, define_prefix))
 		/* bpf() syscall unavailable, don't probe other BPF features */
 		goto exit_close_json;
-	section_program_types(supported_types, define_prefix, ifindex);
-	section_map_types(define_prefix, ifindex);
-	section_helpers(supported_types, define_prefix, ifindex);
-	section_misc(define_prefix, ifindex);
+	if (check_program_types)
+		section_program_types(print_program_types, supported_types,
+				      define_prefix, ifindex);
+	if (check_map_types)
+		section_map_types(define_prefix, ifindex);
+	if (check_helpers)
+		section_helpers(supported_types, define_prefix, ifindex);
+	if (check_misc)
+		section_misc(define_prefix, ifindex);
 
 exit_close_json:
 	if (json_output)
@@ -794,12 +878,15 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [macros [prefix PREFIX]]\n"
+		"Usage: %s %s probe [COMPONENT] [section SECTION] [macros [prefix PREFIX]]\n"
 		"       %s %s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
+		"       SECTION := { %s | %s | %s | %s | %s | %s }\n"
 		"",
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], SECTION_SYSTEM_CONFIG,
+		SECTION_SYSCALL_CONFIG, SECTION_PROGRAM_TYPES,
+		SECTION_MAP_TYPES, SECTION_HELPERS, SECTION_MISC);
 
 	return 0;
 }
-- 
2.25.0

