Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7815D16EF51
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbgBYTpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:45:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:55608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgBYTo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:44:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B623AFCD;
        Tue, 25 Feb 2020 19:44:56 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 2/5] bpftool: Make probes which emit dmesg warnings optional
Date:   Tue, 25 Feb 2020 20:44:40 +0100
Message-Id: <20200225194446.20651-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225194446.20651-1-mrostecki@opensuse.org>
References: <20200225194446.20651-1-mrostecki@opensuse.org>
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
 tools/bpf/bpftool/feature.c | 70 ++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 345e4a2b4f53..ada3e1502b45 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -513,14 +513,39 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 			   define_prefix);
 }
 
+static void
+probe_helper_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
+			  const char *define_prefix, unsigned int id,
+			  const char *ptype_name, __u32 ifindex)
+{
+	bool res;
+
+	if (!supported_type)
+		res = false;
+	else
+		res = bpf_probe_helper(id, prog_type, ifindex);
+
+	if (json_output) {
+		if (res)
+			jsonw_string(json_wtr, helper_name[id]);
+	} else if (define_prefix) {
+		printf("#define %sBPF__PROG_TYPE_%s__HELPER_%s %s\n",
+		       define_prefix, ptype_name, helper_name[id],
+		       res ? "1" : "0");
+	} else {
+		if (res)
+			printf("\n\t- %s", helper_name[id]);
+	}
+}
+
 static void
 probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
-			   const char *define_prefix, __u32 ifindex)
+			   const char *define_prefix, bool full_mode,
+			   __u32 ifindex)
 {
 	const char *ptype_name = prog_type_name[prog_type];
 	char feat_name[128];
 	unsigned int id;
-	bool res;
 
 	if (ifindex)
 		/* Only test helpers for offload-able program types */
@@ -542,21 +567,19 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 	}
 
 	for (id = 1; id < ARRAY_SIZE(helper_name); id++) {
-		if (!supported_type)
-			res = false;
-		else
-			res = bpf_probe_helper(id, prog_type, ifindex);
-
-		if (json_output) {
-			if (res)
-				jsonw_string(json_wtr, helper_name[id]);
-		} else if (define_prefix) {
-			printf("#define %sBPF__PROG_TYPE_%s__HELPER_%s %s\n",
-			       define_prefix, ptype_name, helper_name[id],
-			       res ? "1" : "0");
-		} else {
-			if (res)
-				printf("\n\t- %s", helper_name[id]);
+		/* Skip helper functions which emit dmesg messages when not in
+		 * the full mode.
+		 */
+		switch (id) {
+		case 6: /* trace_printk */
+		case 36: /* probe_write_user */
+			if (!full_mode)
+				continue;
+			/* fallthrough */
+		default:
+			probe_helper_for_progtype(prog_type, supported_type,
+						  define_prefix, id, ptype_name,
+						  ifindex);
 		}
 	}
 
@@ -655,7 +678,8 @@ static void section_map_types(const char *define_prefix, __u32 ifindex)
 }
 
 static void
-section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
+section_helpers(bool *supported_types, const char *define_prefix,
+		bool full_mode, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -681,7 +705,7 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 		       define_prefix);
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
 		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, ifindex);
+					   define_prefix, full_mode, ifindex);
 
 	print_end_section();
 }
@@ -701,6 +725,7 @@ static int do_probe(int argc, char **argv)
 	enum probe_component target = COMPONENT_UNSPEC;
 	const char *define_prefix = NULL;
 	bool supported_types[128] = {};
+	bool full_mode = false;
 	__u32 ifindex = 0;
 	char *ifname;
 
@@ -740,6 +765,9 @@ static int do_probe(int argc, char **argv)
 				      strerror(errno));
 				return -1;
 			}
+		} else if (is_prefix(*argv, "full")) {
+			full_mode = true;
+			NEXT_ARG();
 		} else if (is_prefix(*argv, "macros") && !define_prefix) {
 			define_prefix = "";
 			NEXT_ARG();
@@ -775,7 +803,7 @@ static int do_probe(int argc, char **argv)
 		goto exit_close_json;
 	section_program_types(supported_types, define_prefix, ifindex);
 	section_map_types(define_prefix, ifindex);
-	section_helpers(supported_types, define_prefix, ifindex);
+	section_helpers(supported_types, define_prefix, full_mode, ifindex);
 	section_misc(define_prefix, ifindex);
 
 exit_close_json:
@@ -794,7 +822,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [macros [prefix PREFIX]]\n"
+		"Usage: %s %s probe [COMPONENT] [full] [macros [prefix PREFIX]]\n"
 		"       %s %s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
-- 
2.25.1

