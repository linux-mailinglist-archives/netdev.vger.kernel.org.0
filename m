Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6BD162F3D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBRTCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:02:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:35646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgBRTCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 14:02:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AD6E7ADBE;
        Tue, 18 Feb 2020 19:02:36 +0000 (UTC)
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
Subject: [PATCH bpf-next 3/6] bpftool: Add arguments for filtering in and filtering out probes
Date:   Tue, 18 Feb 2020 20:02:20 +0100
Message-Id: <20200218190224.22508-4-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218190224.22508-1-mrostecki@opensuse.org>
References: <20200218190224.22508-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add positional arguments "filter_in" and "filter_out" to the feature
command of bpftool. If "filter_in" is defined, bpftool is going to
perform and print only checks which match the given pattern. If
"filter_out" is defined, bpftool will not perform and print checks which
match the given pattern.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/feature.c | 324 ++++++++++++++++++++++++++++--------
 1 file changed, 256 insertions(+), 68 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index cfba0faf148f..f10e928d18c8 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -3,6 +3,7 @@
 
 #include <ctype.h>
 #include <errno.h>
+#include <regex.h>
 #include <string.h>
 #include <unistd.h>
 #include <net/if.h>
@@ -64,6 +65,55 @@ static void uppercase(char *str, size_t len)
 		str[i] = toupper(str[i]);
 }
 
+/* Filtering utility functions */
+
+static bool
+check_filters(const char *name, regex_t *filter_in, regex_t *filter_out)
+{
+	char err_buf[100];
+	int ret;
+
+	/* Do not probe if filter_in was defined and string does not match
+	 * against the pattern.
+	 */
+	if (filter_in) {
+		ret = regexec(filter_in, name, 0, NULL, 0);
+		switch (ret) {
+		case 0:
+			break;
+		case REG_NOMATCH:
+			return false;
+		default:
+			regerror(ret, filter_in, err_buf, ARRAY_SIZE(err_buf));
+			p_err("could not match regex: %s", err_buf);
+			free(filter_in);
+			free(filter_out);
+			exit(1);
+		}
+	}
+
+	/* Do not probe if filter_out was defined and string matches against the
+	 * pattern.
+	 */
+	if (filter_out) {
+		ret = regexec(filter_out, name, 0, NULL, 0);
+		switch (ret) {
+		case 0:
+			return false;
+		case REG_NOMATCH:
+			break;
+		default:
+			regerror(ret, filter_out, err_buf, ARRAY_SIZE(err_buf));
+			p_err("could not match regex: %s", err_buf);
+			free(filter_in);
+			free(filter_out);
+			exit(1);
+		}
+	}
+
+	return true;
+}
+
 /* Printing utility functions */
 
 static void
@@ -79,11 +129,16 @@ print_bool_feature(const char *feat_name, const char *plain_name,
 		printf("%s is %savailable\n", plain_name, res ? "" : "NOT ");
 }
 
-static void print_kernel_option(const char *name, const char *value)
+static void
+print_kernel_option(const char *name, const char *value, regex_t *filter_in,
+		    regex_t *filter_out)
 {
 	char *endptr;
 	int res;
 
+	if (!check_filters(name, filter_in, filter_out))
+		return;
+
 	/* No support for C-style ouptut */
 
 	if (json_output) {
@@ -154,15 +209,19 @@ static int read_procfs(const char *path)
 	return res;
 }
 
-static void probe_unprivileged_disabled(void)
+static void probe_unprivileged_disabled(regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "unprivileged_bpf_disabled";
 	int res;
 
 	/* No support for C-style ouptut */
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = read_procfs("/proc/sys/kernel/unprivileged_bpf_disabled");
 	if (json_output) {
-		jsonw_int_field(json_wtr, "unprivileged_bpf_disabled", res);
+		jsonw_int_field(json_wtr, feat_name, res);
 	} else {
 		switch (res) {
 		case 0:
@@ -180,15 +239,19 @@ static void probe_unprivileged_disabled(void)
 	}
 }
 
-static void probe_jit_enable(void)
+static void probe_jit_enable(regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "bpf_jit_enable";
 	int res;
 
 	/* No support for C-style ouptut */
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = read_procfs("/proc/sys/net/core/bpf_jit_enable");
 	if (json_output) {
-		jsonw_int_field(json_wtr, "bpf_jit_enable", res);
+		jsonw_int_field(json_wtr, feat_name, res);
 	} else {
 		switch (res) {
 		case 0:
@@ -210,15 +273,19 @@ static void probe_jit_enable(void)
 	}
 }
 
-static void probe_jit_harden(void)
+static void probe_jit_harden(regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "bpf_jit_harden";
 	int res;
 
 	/* No support for C-style ouptut */
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = read_procfs("/proc/sys/net/core/bpf_jit_harden");
 	if (json_output) {
-		jsonw_int_field(json_wtr, "bpf_jit_harden", res);
+		jsonw_int_field(json_wtr, feat_name, res);
 	} else {
 		switch (res) {
 		case 0:
@@ -240,15 +307,19 @@ static void probe_jit_harden(void)
 	}
 }
 
-static void probe_jit_kallsyms(void)
+static void probe_jit_kallsyms(regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "bpf_jit_kallsyms";
 	int res;
 
 	/* No support for C-style ouptut */
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = read_procfs("/proc/sys/net/core/bpf_jit_kallsyms");
 	if (json_output) {
-		jsonw_int_field(json_wtr, "bpf_jit_kallsyms", res);
+		jsonw_int_field(json_wtr, feat_name, res);
 	} else {
 		switch (res) {
 		case 0:
@@ -266,15 +337,19 @@ static void probe_jit_kallsyms(void)
 	}
 }
 
-static void probe_jit_limit(void)
+static void probe_jit_limit(regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "bpf_jit_limit";
 	int res;
 
 	/* No support for C-style ouptut */
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = read_procfs("/proc/sys/net/core/bpf_jit_limit");
 	if (json_output) {
-		jsonw_int_field(json_wtr, "bpf_jit_limit", res);
+		jsonw_int_field(json_wtr, feat_name, res);
 	} else {
 		switch (res) {
 		case -1:
@@ -314,7 +389,8 @@ static bool read_next_kernel_config_option(gzFile file, char *buf, size_t n,
 	return false;
 }
 
-static void probe_kernel_image_config(void)
+static void
+probe_kernel_image_config(regex_t *filter_in, regex_t *filter_out)
 {
 	static const char * const options[] = {
 		/* Enable BPF */
@@ -438,23 +514,31 @@ static void probe_kernel_image_config(void)
 		gzclose(file);
 
 	for (i = 0; i < ARRAY_SIZE(options); i++) {
-		print_kernel_option(options[i], values[i]);
+		print_kernel_option(options[i], values[i], filter_in,
+				    filter_out);
 		free(values[i]);
 	}
 }
 
 static bool
-probe_bpf_syscall(bool print_syscall_config, const char *define_prefix)
+probe_bpf_syscall(bool print_syscall_config, const char *define_prefix,
+		  regex_t *filter_in, regex_t *filter_out)
 {
+	const char *feat_name = "have_bpf_syscall";
+	const char *plain_desc = "bpf() syscall";
+	const char *define_name = "BPF_SYSCALL";
 	bool res;
 
 	bpf_load_program(BPF_PROG_TYPE_UNSPEC, NULL, 0, NULL, 0, NULL, 0);
 	res = (errno != ENOSYS);
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		print_syscall_config = false;
+
 	if (print_syscall_config)
-		print_bool_feature("have_bpf_syscall",
-				   "bpf() syscall",
-				   "BPF_SYSCALL",
+		print_bool_feature(feat_name,
+				   plain_desc,
+				   define_name,
 				   res, define_prefix);
 
 	return res;
@@ -462,13 +546,19 @@ probe_bpf_syscall(bool print_syscall_config, const char *define_prefix)
 
 static void
 probe_prog_type(bool print_program_types, enum bpf_prog_type prog_type,
-		bool *supported_types, const char *define_prefix, __u32 ifindex)
+		bool *supported_types, const char *define_prefix,
+		regex_t *filter_in, regex_t *filter_out, __u32 ifindex)
 {
 	char feat_name[128], plain_desc[128], define_name[128];
 	const char *plain_comment = "eBPF program_type ";
 	size_t maxlen;
 	bool res;
 
+	sprintf(feat_name, "have_%s_prog_type", prog_type_name[prog_type]);
+	sprintf(define_name, "%s_prog_type", prog_type_name[prog_type]);
+	uppercase(define_name, sizeof(define_name));
+	sprintf(plain_desc, "%s%s", plain_comment, prog_type_name[prog_type]);
+
 	if (ifindex)
 		/* Only test offload-able program types */
 		switch (prog_type) {
@@ -489,10 +579,8 @@ probe_prog_type(bool print_program_types, enum bpf_prog_type prog_type,
 		return;
 	}
 
-	sprintf(feat_name, "have_%s_prog_type", prog_type_name[prog_type]);
-	sprintf(define_name, "%s_prog_type", prog_type_name[prog_type]);
-	uppercase(define_name, sizeof(define_name));
-	sprintf(plain_desc, "%s%s", plain_comment, prog_type_name[prog_type]);
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
 
 	if (print_program_types)
 		print_bool_feature(feat_name, plain_desc, define_name, res,
@@ -501,13 +589,21 @@ probe_prog_type(bool print_program_types, enum bpf_prog_type prog_type,
 
 static void
 probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
-	       __u32 ifindex)
+	       regex_t *filter_in, regex_t *filter_out, __u32 ifindex)
 {
 	char feat_name[128], plain_desc[128], define_name[128];
 	const char *plain_comment = "eBPF map_type ";
 	size_t maxlen;
 	bool res;
 
+	sprintf(feat_name, "have_%s_map_type", map_type_name[map_type]);
+	sprintf(define_name, "%s_map_type", map_type_name[map_type]);
+	uppercase(define_name, sizeof(define_name));
+	sprintf(plain_desc, "%s%s", plain_comment, map_type_name[map_type]);
+
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = bpf_probe_map_type(map_type, ifindex);
 
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
@@ -516,23 +612,23 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 		return;
 	}
 
-	sprintf(feat_name, "have_%s_map_type", map_type_name[map_type]);
-	sprintf(define_name, "%s_map_type", map_type_name[map_type]);
-	uppercase(define_name, sizeof(define_name));
-	sprintf(plain_desc, "%s%s", plain_comment, map_type_name[map_type]);
 	print_bool_feature(feat_name, plain_desc, define_name, res,
 			   define_prefix);
 }
 
 static void
 probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
-			   const char *define_prefix, __u32 ifindex)
+			   const char *define_prefix, regex_t *filter_in,
+			   regex_t *filter_out, __u32 ifindex)
 {
 	const char *ptype_name = prog_type_name[prog_type];
 	char feat_name[128];
 	unsigned int id;
 	bool res;
 
+	if (!check_filters(ptype_name, filter_in, filter_out))
+		return;
+
 	if (ifindex)
 		/* Only test helpers for offload-able program types */
 		switch (prog_type) {
@@ -553,6 +649,9 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 	}
 
 	for (id = 1; id < ARRAY_SIZE(helper_name); id++) {
+		if (!check_filters(helper_name[id], filter_in, filter_out))
+			continue;
+
 		if (!supported_type)
 			res = false;
 		else
@@ -578,19 +677,27 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 }
 
 static void
-probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
+probe_large_insn_limit(const char *define_prefix, regex_t *filter_in,
+		       regex_t *filter_out, __u32 ifindex)
 {
+	const char *plain_desc = "Large program size limit";
+	const char *feat_name = "have_large_insn_limit";
+	const char *define_name = "LARGE_INSN_LIMIT";
 	bool res;
 
+	if (!check_filters(feat_name, filter_in, filter_out))
+		return;
+
 	res = bpf_probe_large_insn_limit(ifindex);
-	print_bool_feature("have_large_insn_limit",
-			   "Large program size limit",
-			   "LARGE_INSN_LIMIT",
+	print_bool_feature(feat_name,
+			   plain_desc,
+			   define_name,
 			   res, define_prefix);
 }
 
 static void
-section_system_config(enum probe_component target, const char *define_prefix)
+section_system_config(enum probe_component target, const char *define_prefix,
+		      regex_t *filter_in, regex_t *filter_out)
 {
 	switch (target) {
 	case COMPONENT_KERNEL:
@@ -603,15 +710,15 @@ section_system_config(enum probe_component target, const char *define_prefix)
 				    NULL, /* define_comment never used here */
 				    NULL); /* define_prefix always NULL here */
 		if (check_procfs()) {
-			probe_unprivileged_disabled();
-			probe_jit_enable();
-			probe_jit_harden();
-			probe_jit_kallsyms();
-			probe_jit_limit();
+			probe_unprivileged_disabled(filter_in, filter_out);
+			probe_jit_enable(filter_in, filter_out);
+			probe_jit_harden(filter_in, filter_out);
+			probe_jit_kallsyms(filter_in, filter_out);
+			probe_jit_limit(filter_in, filter_out);
 		} else {
 			p_info("/* procfs not mounted, skipping related probes */");
 		}
-		probe_kernel_image_config();
+		probe_kernel_image_config(filter_in, filter_out);
 		print_end_section();
 		break;
 	default:
@@ -620,7 +727,8 @@ section_system_config(enum probe_component target, const char *define_prefix)
 }
 
 static bool
-section_syscall_config(bool print_syscall_config, const char *define_prefix)
+section_syscall_config(bool print_syscall_config, const char *define_prefix,
+		       regex_t *filter_in, regex_t *filter_out)
 {
 	bool res;
 
@@ -629,7 +737,8 @@ section_syscall_config(bool print_syscall_config, const char *define_prefix)
 				    "Scanning system call availability...",
 				    "/*** System call availability ***/",
 				    define_prefix);
-	res = probe_bpf_syscall(print_syscall_config, define_prefix);
+	res = probe_bpf_syscall(print_syscall_config, define_prefix,
+				filter_in, filter_out);
 	if (print_syscall_config)
 		print_end_section();
 
@@ -638,7 +747,8 @@ section_syscall_config(bool print_syscall_config, const char *define_prefix)
 
 static void
 section_program_types(bool print_program_types, bool *supported_types,
-		      const char *define_prefix, __u32 ifindex)
+		      const char *define_prefix, regex_t *filter_in,
+		      regex_t *filter_out, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -650,13 +760,14 @@ section_program_types(bool print_program_types, bool *supported_types,
 
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
 		probe_prog_type(print_program_types, i, supported_types,
-				define_prefix, ifindex);
+				define_prefix, filter_in, filter_out, ifindex);
 
 	if (print_program_types)
 		print_end_section();
 }
 
-static void section_map_types(const char *define_prefix, __u32 ifindex)
+static void section_map_types(const char *define_prefix, regex_t *filter_in,
+			      regex_t *filter_out, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -666,13 +777,15 @@ static void section_map_types(const char *define_prefix, __u32 ifindex)
 			    define_prefix);
 
 	for (i = BPF_MAP_TYPE_UNSPEC + 1; i < map_type_name_size; i++)
-		probe_map_type(i, define_prefix, ifindex);
+		probe_map_type(i, define_prefix, filter_in, filter_out,
+			       ifindex);
 
 	print_end_section();
 }
 
 static void
-section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
+section_helpers(bool *supported_types, const char *define_prefix,
+		regex_t *filter_in, regex_t *filter_out, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -698,18 +811,20 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 		       define_prefix);
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
 		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, ifindex);
+					   define_prefix, filter_in, filter_out,
+					   ifindex);
 
 	print_end_section();
 }
 
-static void section_misc(const char *define_prefix, __u32 ifindex)
+static void section_misc(const char *define_prefix, regex_t *filter_in,
+			 regex_t *filter_out, __u32 ifindex)
 {
 	print_start_section(SECTION_MISC,
 			    "Scanning miscellaneous eBPF features...",
 			    "/*** eBPF misc features ***/",
 			    define_prefix);
-	probe_large_insn_limit(define_prefix, ifindex);
+	probe_large_insn_limit(define_prefix, filter_in, filter_out, ifindex);
 	print_end_section();
 }
 
@@ -721,6 +836,8 @@ static int do_probe(int argc, char **argv)
 	 * should exit.
 	 */
 	bool print_syscall_config = false;
+	const char *filter_out_raw = NULL;
+	const char *filter_in_raw = NULL;
 	const char *define_prefix = NULL;
 	bool check_system_config = false;
 	/* Program types probes are needed if helper probes are going to be
@@ -734,9 +851,14 @@ static int do_probe(int argc, char **argv)
 	bool check_map_types = false;
 	bool check_helpers = false;
 	bool check_section = false;
+	regex_t *filter_out = NULL;
+	regex_t *filter_in = NULL;
 	bool check_misc = false;
+	char regerror_buf[100];
 	__u32 ifindex = 0;
 	char *ifname;
+	int reg_ret;
+	int ret = 0;
 
 	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
 	 * Let's approximate, and restrict usage to root user only.
@@ -752,7 +874,8 @@ static int do_probe(int argc, char **argv)
 		if (is_prefix(*argv, "kernel")) {
 			if (target != COMPONENT_UNSPEC) {
 				p_err("component to probe already specified");
-				return -1;
+				ret = -1;
+				goto cleanup;
 			}
 			target = COMPONENT_KERNEL;
 			NEXT_ARG();
@@ -761,10 +884,13 @@ static int do_probe(int argc, char **argv)
 
 			if (target != COMPONENT_UNSPEC || ifindex) {
 				p_err("component to probe already specified");
-				return -1;
+				ret = -1;
+				goto cleanup;
+			}
+			if (!REQ_ARGS(1)) {
+				ret = -1;
+				goto cleanup;
 			}
-			if (!REQ_ARGS(1))
-				return -1;
 
 			target = COMPONENT_DEVICE;
 			ifname = GET_ARG();
@@ -772,7 +898,8 @@ static int do_probe(int argc, char **argv)
 			if (!ifindex) {
 				p_err("unrecognized netdevice '%s': %s", ifname,
 				      strerror(errno));
-				return -1;
+				ret = -1;
+				goto cleanup;
 			}
 		} else if (is_prefix(*argv, "section")) {
 			check_section = true;
@@ -804,30 +931,82 @@ static int do_probe(int argc, char **argv)
 				      SECTION_MAP_TYPES,
 				      SECTION_HELPERS,
 				      SECTION_MISC);
-				return -1;
+				ret = -1;
+				goto cleanup;
+			}
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "filter_in")) {
+			if (filter_in_raw) {
+				p_err("filter_in can be used only once");
+				ret = -1;
+				goto cleanup;
 			}
 			NEXT_ARG();
+			if (!REQ_ARGS(1)) {
+				ret = -1;
+				goto cleanup;
+			}
+			filter_in_raw = GET_ARG();
+
+			filter_in = malloc(sizeof(regex_t));
+			reg_ret = regcomp(filter_in, filter_in_raw, 0);
+			if (reg_ret) {
+				regerror(reg_ret, filter_in, regerror_buf,
+					 ARRAY_SIZE(regerror_buf));
+				p_err("could not compile regex: %s",
+				      regerror_buf);
+				ret = -1;
+				goto cleanup;
+			}
+		} else if (is_prefix(*argv, "filter_out")) {
+			if (filter_out_raw) {
+				p_err("filter_out can be used only once");
+				ret = -1;
+				goto cleanup;
+			}
+			NEXT_ARG();
+			if (!REQ_ARGS(1)) {
+				ret = -1;
+				goto cleanup;
+			}
+			filter_out_raw = GET_ARG();
+
+			filter_out = malloc(sizeof(regex_t));
+			reg_ret = regcomp(filter_out, filter_out_raw, 0);
+			if (reg_ret) {
+				regerror(reg_ret, filter_out, regerror_buf,
+					 ARRAY_SIZE(regerror_buf));
+				p_err("could not compile regex: %s",
+				      regerror_buf);
+				ret = -1;
+				goto cleanup;
+			}
 		} else if (is_prefix(*argv, "macros") && !define_prefix) {
 			define_prefix = "";
 			NEXT_ARG();
 		} else if (is_prefix(*argv, "prefix")) {
 			if (!define_prefix) {
 				p_err("'prefix' argument can only be use after 'macros'");
-				return -1;
+				ret = -1;
+				goto cleanup;
 			}
 			if (strcmp(define_prefix, "")) {
 				p_err("'prefix' already defined");
-				return -1;
+				ret = -1;
+				goto cleanup;
 			}
 			NEXT_ARG();
 
-			if (!REQ_ARGS(1))
-				return -1;
+			if (!REQ_ARGS(1)) {
+				ret = -1;
+				goto cleanup;
+			}
 			define_prefix = GET_ARG();
 		} else {
 			p_err("expected no more arguments, 'kernel', 'dev', 'macros' or 'prefix', got: '%s'?",
 			      *argv);
-			return -1;
+			ret = -1;
+			goto cleanup;
 		}
 	}
 
@@ -848,26 +1027,35 @@ static int do_probe(int argc, char **argv)
 	}
 
 	if (check_system_config)
-		section_system_config(target, define_prefix);
-	if (!section_syscall_config(print_syscall_config, define_prefix))
+		section_system_config(target, define_prefix, filter_in,
+				      filter_out);
+	if (!section_syscall_config(print_syscall_config, define_prefix,
+				    filter_in, filter_out))
 		/* bpf() syscall unavailable, don't probe other BPF features */
 		goto exit_close_json;
 	if (check_program_types)
 		section_program_types(print_program_types, supported_types,
-				      define_prefix, ifindex);
+				      define_prefix, filter_in, filter_out,
+				      ifindex);
 	if (check_map_types)
-		section_map_types(define_prefix, ifindex);
+		section_map_types(define_prefix, filter_in, filter_out,
+				  ifindex);
 	if (check_helpers)
-		section_helpers(supported_types, define_prefix, ifindex);
+		section_helpers(supported_types, define_prefix, filter_in,
+				filter_out, ifindex);
 	if (check_misc)
-		section_misc(define_prefix, ifindex);
+		section_misc(define_prefix, filter_in, filter_out, ifindex);
 
 exit_close_json:
 	if (json_output)
 		/* End root object */
 		jsonw_end_object(json_wtr);
 
-	return 0;
+cleanup:
+	free(filter_in);
+	free(filter_out);
+
+	return ret;
 }
 
 static int do_help(int argc, char **argv)
@@ -878,7 +1066,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [section SECTION] [macros [prefix PREFIX]]\n"
+		"Usage: %s %s probe [COMPONENT] [section SECTION] [filter_in PATTERN] [filter_out PATTERN] [macros [prefix PREFIX]]\n"
 		"       %s %s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
-- 
2.25.0

