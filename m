Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37434166D4A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgBUDQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:16:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:59522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbgBUDQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 22:16:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68BF4B202;
        Fri, 21 Feb 2020 03:16:24 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v2 2/5] bpftool: Make probes which emit dmesg warnings optional
Date:   Fri, 21 Feb 2020 04:16:57 +0100
Message-Id: <20200221031702.25292-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221031702.25292-1-mrostecki@opensuse.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probes related to bpf_probe_write_user and bpf_trace_printk helpers emit
dmesg warnings which might be confusing for people running bpftool on
production environments. This change filters them out by default and
introduces the new positional argument "full" which enables all
available probes.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/feature.c | 80 +++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 345e4a2b4f53..0731804b8160 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -3,6 +3,7 @@
 
 #include <ctype.h>
 #include <errno.h>
+#include <regex.h>
 #include <string.h>
 #include <unistd.h>
 #include <net/if.h>
@@ -22,6 +23,9 @@
 # define PROC_SUPER_MAGIC	0x9fa0
 #endif
 
+/* Regex pattern for filtering out probes which emit dmesg warnings */
+#define FILTER_OUT_PATTERN "(trace|write_user)"
+
 enum probe_component {
 	COMPONENT_UNSPEC,
 	COMPONENT_KERNEL,
@@ -57,6 +61,35 @@ static void uppercase(char *str, size_t len)
 		str[i] = toupper(str[i]);
 }
 
+/* Filtering utility functions */
+
+static bool
+check_filters(const char *name, regex_t *filter_out)
+{
+	char err_buf[100];
+	int ret;
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
@@ -515,7 +548,8 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 
 static void
 probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
-			   const char *define_prefix, __u32 ifindex)
+			   const char *define_prefix, regex_t *filter_out,
+			   __u32 ifindex)
 {
 	const char *ptype_name = prog_type_name[prog_type];
 	char feat_name[128];
@@ -542,6 +576,9 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 	}
 
 	for (id = 1; id < ARRAY_SIZE(helper_name); id++) {
+		if (!check_filters(helper_name[id], filter_out))
+			continue;
+
 		if (!supported_type)
 			res = false;
 		else
@@ -634,7 +671,8 @@ section_program_types(bool *supported_types, const char *define_prefix,
 			    define_prefix);
 
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_prog_type(i, supported_types, define_prefix, ifindex);
+		probe_prog_type(i, supported_types, define_prefix,
+				ifindex);
 
 	print_end_section();
 }
@@ -655,7 +693,8 @@ static void section_map_types(const char *define_prefix, __u32 ifindex)
 }
 
 static void
-section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
+section_helpers(bool *supported_types, const char *define_prefix,
+		regex_t *filter_out, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -681,7 +720,7 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 		       define_prefix);
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
 		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, ifindex);
+					   define_prefix, filter_out, ifindex);
 
 	print_end_section();
 }
@@ -701,8 +740,13 @@ static int do_probe(int argc, char **argv)
 	enum probe_component target = COMPONENT_UNSPEC;
 	const char *define_prefix = NULL;
 	bool supported_types[128] = {};
+	regex_t *filter_out = NULL;
+	bool full_mode = false;
+	char regerror_buf[100];
 	__u32 ifindex = 0;
 	char *ifname;
+	int reg_ret;
+	int ret = 0;
 
 	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
 	 * Let's approximate, and restrict usage to root user only.
@@ -740,6 +784,9 @@ static int do_probe(int argc, char **argv)
 				      strerror(errno));
 				return -1;
 			}
+		} else if (is_prefix(*argv, "full")) {
+			full_mode = true;
+			NEXT_ARG();
 		} else if (is_prefix(*argv, "macros") && !define_prefix) {
 			define_prefix = "";
 			NEXT_ARG();
@@ -764,6 +811,22 @@ static int do_probe(int argc, char **argv)
 		}
 	}
 
+	/* If full mode is not acivated, filter out probes which emit dmesg
+	 * messages.
+	 */
+	if (!full_mode) {
+		filter_out = malloc(sizeof(regex_t));
+		reg_ret = regcomp(filter_out, FILTER_OUT_PATTERN, REG_EXTENDED);
+		if (reg_ret) {
+			regerror(reg_ret, filter_out, regerror_buf,
+				 ARRAY_SIZE(regerror_buf));
+			p_err("could not compile regex: %s",
+			      regerror_buf);
+			ret = -1;
+			goto cleanup;
+		}
+	}
+
 	if (json_output) {
 		define_prefix = NULL;
 		jsonw_start_object(json_wtr);
@@ -775,7 +838,7 @@ static int do_probe(int argc, char **argv)
 		goto exit_close_json;
 	section_program_types(supported_types, define_prefix, ifindex);
 	section_map_types(define_prefix, ifindex);
-	section_helpers(supported_types, define_prefix, ifindex);
+	section_helpers(supported_types, define_prefix, filter_out, ifindex);
 	section_misc(define_prefix, ifindex);
 
 exit_close_json:
@@ -783,7 +846,10 @@ static int do_probe(int argc, char **argv)
 		/* End root object */
 		jsonw_end_object(json_wtr);
 
-	return 0;
+cleanup:
+	free(filter_out);
+
+	return ret;
 }
 
 static int do_help(int argc, char **argv)
@@ -794,7 +860,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [macros [prefix PREFIX]]\n"
+		"Usage: %s %s probe [COMPONENT] [full] [macros [prefix PREFIX]]\n"
 		"       %s %s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
-- 
2.25.0

