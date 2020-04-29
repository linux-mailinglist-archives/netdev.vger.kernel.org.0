Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6131BE175
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgD2OpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgD2OpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:45:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819B7C08E859
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d15so2883691wrx.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1pb24uR21VUp2hP8cBfznro73d21AmZJyr3yv94fFwc=;
        b=fiecpfI8clFN5Z0FzTo0DpVc6f+SEaGEsHeOhU1ErsmCHxViSsoXpmk3loess4FWBn
         LH75L8fAQSZ/QmP98vbrd1/gDXNaJJCbwOHGrjCtAbw97QqDdT2mHnSznee00j+t90D2
         Ubaczyg7snsEbfpCgXkzlO22SK6jECIacwbmGN1G8I8FR1daUElyQWw5RsVBTAnjjrkW
         UqpBdcLLUoEB3imfMJHz0GRIlS75zKB11/1OWgsOqmrKabULOcdpLIuLAcDi3DdRCTwl
         tmvvrK3HEnTCK7bjJ1hfUCBlqOXCwkl8FJtFC7SHlqcOpvmJfLeAUOIwNW+Bzu/HnGzT
         D+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1pb24uR21VUp2hP8cBfznro73d21AmZJyr3yv94fFwc=;
        b=tF8eaxcr3+R3cqXTr10BC+xXOC/Cvd2kbyLRkGcptnECeJ8B9+fT2C85yl37NP1yBg
         +FN/aMfQJUj6bi/86fsPDb1u/4oFbvkm8PJVQjogwKh6nLAMqEqUxpJOtng8rLRiyP1g
         L+ENQugMXBHPKUMv1wasMB49SvbV11SD8rhnnV3IhXzoJpSACFWafPLbb+sm/BKMRLsz
         Fh54+ZzLLRap8s4f9IoEAaitv7ykLH3LBNdudbAji94aP7QK4+uQQkEL4znTBBWC4i27
         IwVUkL3zKxIvaaNmJBI13zjv+LLeHrRY34WrdD72efyFPsZzYfcuGXz4+E5qN4xlh/Zm
         N4TA==
X-Gm-Message-State: AGi0PuZ3dKophXT4hLH72d/CyhT+2enon0RYwP4/8xZ79RSEqAQXwm6J
        M+s1FbHMrm+NHBb4dtZqrqLXlQ==
X-Google-Smtp-Source: APiQypJ7pnQNRJFUjwKAVrPErbXIgDwzJbeOExZJS0w0O0LQ/aBH549HfMbteYxcE0hcqe4SJ0p8Og==
X-Received: by 2002:a5d:6145:: with SMTP id y5mr38936686wrt.126.1588171512113;
        Wed, 29 Apr 2020 07:45:12 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id a10sm20071739wrg.32.2020.04.29.07.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 07:45:11 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next v3 2/3] tools: bpftool: allow unprivileged users to probe features
Date:   Wed, 29 Apr 2020 15:45:05 +0100
Message-Id: <20200429144506.8999-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429144506.8999-1-quentin@isovalent.com>
References: <20200429144506.8999-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is demand for a way to identify what BPF helper functions are
available to unprivileged users. To do so, allow unprivileged users to
run "bpftool feature probe" to list BPF-related features. This will only
show features accessible to those users, and may not reflect the full
list of features available (to administrators) on the system.

To avoid the case where bpftool is inadvertently run as non-root and
would list only a subset of the features supported by the system when it
would be expected to list all of them, running as unprivileged is gated
behind the "unprivileged" keyword passed to the command line. When used
by a privileged user, this keyword allows to drop the CAP_SYS_ADMIN and
to list the features available to unprivileged users. Note that this
addsd a dependency on libpcap for compiling bpftool.

Note that there is no particular reason why the probes were restricted
to root, other than the fact I did not need them for unprivileged and
did not bother with the additional checks at the time probes were added.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-feature.rst |  10 +-
 tools/bpf/bpftool/Makefile                    |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
 tools/bpf/bpftool/feature.c                   | 102 +++++++++++++++---
 4 files changed, 100 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index b04156cfd7a3..ca085944e4cf 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -19,7 +19,7 @@ SYNOPSIS
 FEATURE COMMANDS
 ================
 
-|	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**macros** [**prefix** *PREFIX*]]
+|	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
 |	**bpftool** **feature help**
 |
 |	*COMPONENT* := { **kernel** | **dev** *NAME* }
@@ -49,6 +49,14 @@ DESCRIPTION
 		  Keyword **kernel** can be omitted. If no probe target is
 		  specified, probing the kernel is the default behaviour.
 
+		  When the **unprivileged** keyword is used, bpftool will dump
+		  only the features available to a user who does not have the
+		  **CAP_SYS_ADMIN** capability set. The features available in
+		  that case usually represent a small subset of the parameters
+		  supported by the system. Unprivileged users MUST use the
+		  **unprivileged** keyword: This is to avoid misdetection if
+		  bpftool is inadvertently run as non-root, for example.
+
 	**bpftool feature probe dev** *NAME* [**full**] [**macros** [**prefix** *PREFIX*]]
 		  Probe network device for supported eBPF features and dump
 		  results to the console.
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index f584d1fdfc64..89d7962a4a44 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -55,7 +55,7 @@ ifneq ($(EXTRA_LDFLAGS),)
 LDFLAGS += $(EXTRA_LDFLAGS)
 endif
 
-LIBS = $(LIBBPF) -lelf -lz
+LIBS = $(LIBBPF) -lelf -lz -lcap
 
 INSTALL ?= install
 RM ?= rm -f
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index c033c3329f73..fc989ead7313 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1079,7 +1079,7 @@ _bpftool()
                         COMPREPLY+=( $( compgen -W 'macros' -- "$cur" ) )
                     fi
                     _bpftool_one_of_list 'kernel dev'
-                    _bpftool_once_attr 'full'
+                    _bpftool_once_attr 'full unprivileged'
                     return 0
                     ;;
                 *)
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 59e4cb44efbc..952f4b1987c0 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <net/if.h>
+#include <sys/capability.h>
 #include <sys/utsname.h>
 #include <sys/vfs.h>
 
@@ -36,6 +37,7 @@ static const char * const helper_name[] = {
 #undef BPF_HELPER_MAKE_ENTRY
 
 static bool full_mode;
+static bool run_as_unprivileged;
 
 /* Miscellaneous utility functions */
 
@@ -473,6 +475,11 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 		}
 
 	res = bpf_probe_prog_type(prog_type, ifindex);
+	/* Probe may succeed even if program load fails, for unprivileged users
+	 * check that we did not fail because of insufficient permissions
+	 */
+	if (run_as_unprivileged && errno == EPERM)
+		res = false;
 
 	supported_types[prog_type] |= res;
 
@@ -501,6 +508,10 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 
 	res = bpf_probe_map_type(map_type, ifindex);
 
+	/* Probe result depends on the success of map creation, no additional
+	 * check required for unprivileged users
+	 */
+
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
 	if (strlen(map_type_name[map_type]) > maxlen) {
 		p_info("map type name too long");
@@ -520,12 +531,17 @@ probe_helper_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 			  const char *define_prefix, unsigned int id,
 			  const char *ptype_name, __u32 ifindex)
 {
-	bool res;
+	bool res = false;
 
-	if (!supported_type)
-		res = false;
-	else
+	if (supported_type) {
 		res = bpf_probe_helper(id, prog_type, ifindex);
+		/* Probe may succeed even if program load fails, for
+		 * unprivileged users check that we did not fail because of
+		 * insufficient permissions
+		 */
+		if (run_as_unprivileged && errno == EPERM)
+			res = false;
+	}
 
 	if (json_output) {
 		if (res)
@@ -720,6 +736,65 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
 	print_end_section();
 }
 
+static int handle_perms(void)
+{
+	cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
+	bool has_sys_admin_cap = false;
+	cap_flag_value_t val;
+	int res = -1;
+	cap_t caps;
+
+	caps = cap_get_proc();
+	if (!caps) {
+		p_err("failed to get capabilities for process: %s",
+		      strerror(errno));
+		return -1;
+	}
+
+	if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
+		p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
+		goto exit_free;
+	}
+	if (val == CAP_SET)
+		has_sys_admin_cap = true;
+
+	if (!run_as_unprivileged && !has_sys_admin_cap) {
+		p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
+		goto exit_free;
+	}
+
+	if ((run_as_unprivileged && !has_sys_admin_cap) ||
+	    (!run_as_unprivileged && has_sys_admin_cap)) {
+		/* We are all good, exit now */
+		res = 0;
+		goto exit_free;
+	}
+
+	/* if (run_as_unprivileged && has_sys_admin_cap), drop CAP_SYS_ADMIN */
+
+	if (cap_set_flag(caps, CAP_EFFECTIVE, ARRAY_SIZE(cap_list), cap_list,
+			 CAP_CLEAR)) {
+		p_err("bug: failed to clear CAP_SYS_ADMIN from capabilities");
+		goto exit_free;
+	}
+
+	if (cap_set_proc(caps)) {
+		p_err("failed to drop CAP_SYS_ADMIN: %s", strerror(errno));
+		goto exit_free;
+	}
+
+	res = 0;
+
+exit_free:
+	if (cap_free(caps) && !res) {
+		p_err("failed to clear storage object for capabilities: %s",
+		      strerror(errno));
+		res = -1;
+	}
+
+	return res;
+}
+
 static int do_probe(int argc, char **argv)
 {
 	enum probe_component target = COMPONENT_UNSPEC;
@@ -728,14 +803,6 @@ static int do_probe(int argc, char **argv)
 	__u32 ifindex = 0;
 	char *ifname;
 
-	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
-	 * Let's approximate, and restrict usage to root user only.
-	 */
-	if (geteuid()) {
-		p_err("please run this command as root user");
-		return -1;
-	}
-
 	set_max_rlimit();
 
 	while (argc) {
@@ -784,6 +851,9 @@ static int do_probe(int argc, char **argv)
 			if (!REQ_ARGS(1))
 				return -1;
 			define_prefix = GET_ARG();
+		} else if (is_prefix(*argv, "unprivileged")) {
+			run_as_unprivileged = true;
+			NEXT_ARG();
 		} else {
 			p_err("expected no more arguments, 'kernel', 'dev', 'macros' or 'prefix', got: '%s'?",
 			      *argv);
@@ -791,6 +861,12 @@ static int do_probe(int argc, char **argv)
 		}
 	}
 
+	/* Full feature detection requires CAP_SYS_ADMIN privilege.
+	 * Let's approximate, and warn if user is not root.
+	 */
+	if (handle_perms())
+		return -1;
+
 	if (json_output) {
 		define_prefix = NULL;
 		jsonw_start_object(json_wtr);
@@ -821,7 +897,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [full] [macros [prefix PREFIX]]\n"
+		"Usage: %s %s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
 		"       %s %s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
-- 
2.20.1

