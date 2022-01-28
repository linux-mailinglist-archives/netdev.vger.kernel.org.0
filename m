Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4E64A03BB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351717AbiA1Wdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351714AbiA1Wdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:35 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6838C061747
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:34 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id hu2so7199229qvb.8
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Mxfkvpc23YtuqkVfzoDXsbicdcB3e3RMOYnQdu6ta0=;
        b=dOoyvL04P0JzrLFbg5/X84N9EfoNUKV9YJh6lseMo/JpRslkTGImtpyHHAuTqML/h+
         E8nD0UDdFTZNbE1u5Ab/riLqSMTcpBvESrSYart0xIAHDfQoi2mOGj4WEHigGhKZ81mN
         yqjEXY00pjskvAsKqmUmDPMb7VHqfp1198Iiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Mxfkvpc23YtuqkVfzoDXsbicdcB3e3RMOYnQdu6ta0=;
        b=warPxfNtkzFsKsICvCngeGP1pN/LOuNEr8z4P48a1FyGW3RY+44nlZEMDu+3Ww6Gpa
         vIKtFd4QQKSIV+gI2Do9TTnIV13xn8lZcjr4WQ03BZ457urfal2Rqb8COc4BkLS9saPl
         4WzS13ghiWPSa+3hxqSCXBv6nKfOoiYAOjZT/58p1vRruwRsb6YBuu/+ovdkL/XexA6L
         und0pl6zbpzXYjVoIwgm83aHqbpX9ZS4Drhz47giHq/y6S9uVAgawhbknu4vXoIu5zCZ
         8sDXjckOPa8KUebCus8HXy6J7uN+jBWOCL9SkZPrXtUrk77pitRbDD5TdoyJlS72oZXt
         gHFw==
X-Gm-Message-State: AOAM531++Ue0FpvFUPb2aEyD+AQYimFPvH9ip/leMxlPtYAtWdvVjdlO
        bN9Td8628dLGosP8plkeT6EwHQFYjTH5UfK1ogaaRUarxME3xlKTrP7xPDBQew5OugDP/Q88i8i
        HJbFvz/Mio4tY5Z51JlNmkXu0NzxuO6TzMvITTVIeveMhr3TPw30Xm0K68xvaAzaQVNG9aA==
X-Google-Smtp-Source: ABdhPJxKnfnfwFYe6KdIU+Wk1y6ihNS+J1K9oqq2rPa0fjh0Yg1ONhsAQyR/4ilo23DFQMuJ5QIBXA==
X-Received: by 2002:a05:6214:3005:: with SMTP id ke5mr9396812qvb.83.1643409211628;
        Fri, 28 Jan 2022 14:33:31 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:30 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 2/9] bpftool: Add gen min_core_btf command
Date:   Fri, 28 Jan 2022 17:33:05 -0500
Message-Id: <20220128223312.1253169-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This command is implemented under the "gen" command in bpftool and the
syntax is the following:

$ bpftool gen min_core_btf INPUT OUTPUT OBJECT(S)

INPUT can be either a single BTF file or a folder containing BTF files,
when it's a folder, a BTF file is generated for each BTF file contained
in this folder. OUTPUT is the file (or folder) where generated files are
stored and OBJECT(S) is the list of bpf objects we want to generate the
BTF file(s) for (each generated BTF file contains all the types needed
by all the objects).

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/bash-completion/bpftool |   6 +-
 tools/bpf/bpftool/gen.c                   | 112 +++++++++++++++++++++-
 2 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 493753a4962e..958e1fd71b5c 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1003,9 +1003,13 @@ _bpftool()
                             ;;
                     esac
                     ;;
+                min_core_btf)
+                    _filedir
+                    return 0
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'object skeleton help' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'object skeleton help min_core_btf' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8f78c27d41f0..7db31b0f265f 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #endif
 #include <ctype.h>
+#include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/err.h>
@@ -1084,6 +1085,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
+		"       %1$s %2$s min_core_btf INPUT OUTPUT OBJECT(S)\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
@@ -1094,10 +1096,114 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+/* Create BTF file for a set of BPF objects */
+static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	return -EOPNOTSUPP;
+}
+
+static int do_min_core_btf(int argc, char **argv)
+{
+	char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
+	bool input_is_file, output_is_file = true;
+	const char *input, *output;
+	const char **objs = NULL;
+	struct dirent *dir;
+	struct stat st;
+	DIR *d = NULL;
+	int i, err;
+
+	if (!REQ_ARGS(3)) {
+		usage();
+		return -1;
+	}
+
+	input = GET_ARG();
+	if (stat(input, &st) < 0) {
+		p_err("failed to stat %s: %s", input, strerror(errno));
+		return -errno;
+	}
+
+	if ((st.st_mode & S_IFMT) != S_IFDIR && (st.st_mode & S_IFMT) != S_IFREG) {
+		p_err("file type not valid: %s", input);
+		return -EINVAL;
+	}
+
+	input_is_file = (st.st_mode & S_IFMT) == S_IFREG;
+
+	output = GET_ARG();
+	if (stat(output, &st) == 0 && (st.st_mode & S_IFMT) == S_IFDIR)
+		output_is_file = false;
+
+	objs = (const char **) malloc((argc + 1) * sizeof(*objs));
+	if (!objs) {
+		p_err("failed to allocate array for object names");
+		return -ENOMEM;
+	}
+
+	i = 0;
+	while (argc > 0)
+		objs[i++] = GET_ARG();
+
+	objs[i] = NULL;
+
+	/* single BTF file */
+	if (input_is_file) {
+		p_info("Processing source BTF file: %s", input);
+
+		if (output_is_file) {
+			err = btfgen(input, output, objs);
+			goto out;
+		}
+		snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", output,
+			 basename(input));
+		err = btfgen(input, dst_btf_path, objs);
+		goto out;
+	}
+
+	if (output_is_file) {
+		p_err("can't have just one file as output");
+		err = -EINVAL;
+		goto out;
+	}
+
+	/* directory with BTF files */
+	d = opendir(input);
+	if (!d) {
+		p_err("error opening input dir: %s", strerror(errno));
+		err = -errno;
+		goto out;
+	}
+
+	while ((dir = readdir(d)) != NULL) {
+		if (dir->d_type != DT_REG)
+			continue;
+
+		if (strncmp(dir->d_name + strlen(dir->d_name) - 4, ".btf", 4))
+			continue;
+
+		snprintf(src_btf_path, sizeof(src_btf_path), "%s%s", input, dir->d_name);
+		snprintf(dst_btf_path, sizeof(dst_btf_path), "%s%s", output, dir->d_name);
+
+		p_info("Processing source BTF file: %s", src_btf_path);
+
+		err = btfgen(src_btf_path, dst_btf_path, objs);
+		if (err)
+			goto out;
+	}
+
+out:
+	free(objs);
+	if (d)
+		closedir(d);
+	return err;
+}
+
 static const struct cmd cmds[] = {
-	{ "object",	do_object },
-	{ "skeleton",	do_skeleton },
-	{ "help",	do_help },
+	{ "object",		do_object },
+	{ "skeleton",		do_skeleton },
+	{ "min_core_btf",	do_min_core_btf},
+	{ "help",		do_help },
 	{ 0 }
 };
 
-- 
2.25.1

