Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571EA16EF3F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgBYTpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:45:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:55584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbgBYTo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:44:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0272CAE72;
        Tue, 25 Feb 2020 19:44:54 +0000 (UTC)
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
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v3 1/5] bpftool: Move out sections to separate functions
Date:   Tue, 25 Feb 2020 20:44:39 +0100
Message-Id: <20200225194446.20651-2-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225194446.20651-1-mrostecki@opensuse.org>
References: <20200225194446.20651-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove all calls of print_end_then_start_section function and for loops
out from the do_probe function. Instead, provide separate functions for
each section (like i.e. section_helpers) which are called in do_probe.
This change is motivated by better readability.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/feature.c | 219 +++++++++++++++++++++---------------
 1 file changed, 126 insertions(+), 93 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 941873d778d8..345e4a2b4f53 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -112,18 +112,12 @@ print_start_section(const char *json_title, const char *plain_title,
 	}
 }
 
-static void
-print_end_then_start_section(const char *json_title, const char *plain_title,
-			     const char *define_comment,
-			     const char *define_prefix)
+static void print_end_section(void)
 {
 	if (json_output)
 		jsonw_end_object(json_wtr);
 	else
 		printf("\n");
-
-	print_start_section(json_title, plain_title, define_comment,
-			    define_prefix);
 }
 
 /* Probing functions */
@@ -584,13 +578,130 @@ probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
 			   res, define_prefix);
 }
 
+static void
+section_system_config(enum probe_component target, const char *define_prefix)
+{
+	switch (target) {
+	case COMPONENT_KERNEL:
+	case COMPONENT_UNSPEC:
+		if (define_prefix)
+			break;
+
+		print_start_section("system_config",
+				    "Scanning system configuration...",
+				    NULL, /* define_comment never used here */
+				    NULL); /* define_prefix always NULL here */
+		if (check_procfs()) {
+			probe_unprivileged_disabled();
+			probe_jit_enable();
+			probe_jit_harden();
+			probe_jit_kallsyms();
+			probe_jit_limit();
+		} else {
+			p_info("/* procfs not mounted, skipping related probes */");
+		}
+		probe_kernel_image_config();
+		print_end_section();
+		break;
+	default:
+		break;
+	}
+}
+
+static bool section_syscall_config(const char *define_prefix)
+{
+	bool res;
+
+	print_start_section("syscall_config",
+			    "Scanning system call availability...",
+			    "/*** System call availability ***/",
+			    define_prefix);
+	res = probe_bpf_syscall(define_prefix);
+	print_end_section();
+
+	return res;
+}
+
+static void
+section_program_types(bool *supported_types, const char *define_prefix,
+		      __u32 ifindex)
+{
+	unsigned int i;
+
+	print_start_section("program_types",
+			    "Scanning eBPF program types...",
+			    "/*** eBPF program types ***/",
+			    define_prefix);
+
+	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
+		probe_prog_type(i, supported_types, define_prefix, ifindex);
+
+	print_end_section();
+}
+
+static void section_map_types(const char *define_prefix, __u32 ifindex)
+{
+	unsigned int i;
+
+	print_start_section("map_types",
+			    "Scanning eBPF map types...",
+			    "/*** eBPF map types ***/",
+			    define_prefix);
+
+	for (i = BPF_MAP_TYPE_UNSPEC + 1; i < map_type_name_size; i++)
+		probe_map_type(i, define_prefix, ifindex);
+
+	print_end_section();
+}
+
+static void
+section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
+{
+	unsigned int i;
+
+	print_start_section("helpers",
+			    "Scanning eBPF helper functions...",
+			    "/*** eBPF helper functions ***/",
+			    define_prefix);
+
+	if (define_prefix)
+		printf("/*\n"
+		       " * Use %sHAVE_PROG_TYPE_HELPER(prog_type_name, helper_name)\n"
+		       " * to determine if <helper_name> is available for <prog_type_name>,\n"
+		       " * e.g.\n"
+		       " *	#if %sHAVE_PROG_TYPE_HELPER(xdp, bpf_redirect)\n"
+		       " *		// do stuff with this helper\n"
+		       " *	#elif\n"
+		       " *		// use a workaround\n"
+		       " *	#endif\n"
+		       " */\n"
+		       "#define %sHAVE_PROG_TYPE_HELPER(prog_type, helper)	\\\n"
+		       "	%sBPF__PROG_TYPE_ ## prog_type ## __HELPER_ ## helper\n",
+		       define_prefix, define_prefix, define_prefix,
+		       define_prefix);
+	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
+		probe_helpers_for_progtype(i, supported_types[i],
+					   define_prefix, ifindex);
+
+	print_end_section();
+}
+
+static void section_misc(const char *define_prefix, __u32 ifindex)
+{
+	print_start_section("misc",
+			    "Scanning miscellaneous eBPF features...",
+			    "/*** eBPF misc features ***/",
+			    define_prefix);
+	probe_large_insn_limit(define_prefix, ifindex);
+	print_end_section();
+}
+
 static int do_probe(int argc, char **argv)
 {
 	enum probe_component target = COMPONENT_UNSPEC;
 	const char *define_prefix = NULL;
 	bool supported_types[128] = {};
 	__u32 ifindex = 0;
-	unsigned int i;
 	char *ifname;
 
 	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
@@ -658,97 +769,19 @@ static int do_probe(int argc, char **argv)
 		jsonw_start_object(json_wtr);
 	}
 
-	switch (target) {
-	case COMPONENT_KERNEL:
-	case COMPONENT_UNSPEC:
-		if (define_prefix)
-			break;
-
-		print_start_section("system_config",
-				    "Scanning system configuration...",
-				    NULL, /* define_comment never used here */
-				    NULL); /* define_prefix always NULL here */
-		if (check_procfs()) {
-			probe_unprivileged_disabled();
-			probe_jit_enable();
-			probe_jit_harden();
-			probe_jit_kallsyms();
-			probe_jit_limit();
-		} else {
-			p_info("/* procfs not mounted, skipping related probes */");
-		}
-		probe_kernel_image_config();
-		if (json_output)
-			jsonw_end_object(json_wtr);
-		else
-			printf("\n");
-		break;
-	default:
-		break;
-	}
-
-	print_start_section("syscall_config",
-			    "Scanning system call availability...",
-			    "/*** System call availability ***/",
-			    define_prefix);
-
-	if (!probe_bpf_syscall(define_prefix))
+	section_system_config(target, define_prefix);
+	if (!section_syscall_config(define_prefix))
 		/* bpf() syscall unavailable, don't probe other BPF features */
 		goto exit_close_json;
-
-	print_end_then_start_section("program_types",
-				     "Scanning eBPF program types...",
-				     "/*** eBPF program types ***/",
-				     define_prefix);
-
-	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_prog_type(i, supported_types, define_prefix, ifindex);
-
-	print_end_then_start_section("map_types",
-				     "Scanning eBPF map types...",
-				     "/*** eBPF map types ***/",
-				     define_prefix);
-
-	for (i = BPF_MAP_TYPE_UNSPEC + 1; i < map_type_name_size; i++)
-		probe_map_type(i, define_prefix, ifindex);
-
-	print_end_then_start_section("helpers",
-				     "Scanning eBPF helper functions...",
-				     "/*** eBPF helper functions ***/",
-				     define_prefix);
-
-	if (define_prefix)
-		printf("/*\n"
-		       " * Use %sHAVE_PROG_TYPE_HELPER(prog_type_name, helper_name)\n"
-		       " * to determine if <helper_name> is available for <prog_type_name>,\n"
-		       " * e.g.\n"
-		       " *	#if %sHAVE_PROG_TYPE_HELPER(xdp, bpf_redirect)\n"
-		       " *		// do stuff with this helper\n"
-		       " *	#elif\n"
-		       " *		// use a workaround\n"
-		       " *	#endif\n"
-		       " */\n"
-		       "#define %sHAVE_PROG_TYPE_HELPER(prog_type, helper)	\\\n"
-		       "	%sBPF__PROG_TYPE_ ## prog_type ## __HELPER_ ## helper\n",
-		       define_prefix, define_prefix, define_prefix,
-		       define_prefix);
-	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, ifindex);
-
-	print_end_then_start_section("misc",
-				     "Scanning miscellaneous eBPF features...",
-				     "/*** eBPF misc features ***/",
-				     define_prefix);
-	probe_large_insn_limit(define_prefix, ifindex);
+	section_program_types(supported_types, define_prefix, ifindex);
+	section_map_types(define_prefix, ifindex);
+	section_helpers(supported_types, define_prefix, ifindex);
+	section_misc(define_prefix, ifindex);
 
 exit_close_json:
-	if (json_output) {
-		/* End current "section" of probes */
-		jsonw_end_object(json_wtr);
+	if (json_output)
 		/* End root object */
 		jsonw_end_object(json_wtr);
-	}
 
 	return 0;
 }
-- 
2.25.1

