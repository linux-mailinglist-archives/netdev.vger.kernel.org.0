Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6CD48C608
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354123AbiALO1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354147AbiALO1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:35 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDEBC061763
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:24 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id g21so3022405qtk.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDqre2rSvtFPf7A1bMcsPD24lUg6JYhD3wbRftk5/iY=;
        b=Ii8mdGdN92PusiEqtumyi6Yq3o0HxH/zRDtB1qX+Py0d6P7CCOIlRe7DaBEfhzXGFw
         yVfeN3mgjnYeus021VYJNabwg6mlC68ahJqVACzxmTFFYo3N84LBOD3O/TxImADQfXHy
         DwfASaCRgsZOhmYkdILMRjd12AEjGgkrtkcI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDqre2rSvtFPf7A1bMcsPD24lUg6JYhD3wbRftk5/iY=;
        b=xShj12wuMAPhQPnBfFTDxGJonIzXXrxlP0N9f/vvEqMxaw1wSquGOAnP0OemWSxorF
         1rJp3hNCDtYC+sQfIvMFjlJqDtPCRG8P4KwAAGm0aNnVOb/dB0UBDgv+xdF1VQHTO1wf
         dgV0HoiII9yoSZqT6ZAnW2bC63gJz5tOHolMbKzEL6enSX12OYkoJUqLFiqYkaal28Ys
         zHX6ihTomLWVl9HpZEeaTKvt0ZYvXfzS2i6ibXjN5YRXsoGmkfhx0t8pyhZwsD68rliy
         vmX8pRZ51HHCoIZGaLUWlTX1RYNW3kYxba8oXrX8a6cczgSwZtjyWa9tqc9mVsdpr/1D
         nLrg==
X-Gm-Message-State: AOAM530paatdQG4DxLYICUZzrkmKdywdsmwLOWpltLDFErTChPvJBl8V
        p+MVPAZ+3S3PtH/gCpUor+FEVMQ2aZk1voCKk/3hSWMZIBA/jYM3RWlWolJ3u2bzJo9/Y9TbPPa
        yJifVpLEto/O1HdJsH7KOxkaM3tUx/XQRch85LZDaldZR29oDmJMtsMG6z/C/TopzmJimFOcQ
X-Google-Smtp-Source: ABdhPJytD+C1sQzvveAf4S8mXsSeRjwJld63kxPM/MAJsj9ZLyBet/dBk3U6uy3XWk1wEyNcaof23Q==
X-Received: by 2002:ac8:5753:: with SMTP id 19mr7473149qtx.631.1641997641741;
        Wed, 12 Jan 2022 06:27:21 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:21 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 3/8] bpftool: Add gen btf command
Date:   Wed, 12 Jan 2022 09:27:04 -0500
Message-Id: <20220112142709.102423-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This command is implemented under the "gen" command in bpftool and the
syntax is the following:

$ bpftool gen btf INPUT OUTPUT OBJECT(S)

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
 tools/bpf/bpftool/gen.c | 117 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 43e3f8700ecc..cdeb1047d79d 100644
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
+		"       %1$s %2$s btf INPUT OUTPUT OBJECT(S)\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
@@ -1094,9 +1096,124 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+/* Create BTF file for a set of BPF objects */
+static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	return -EOPNOTSUPP;
+}
+
+static int is_file(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	switch (st.st_mode & S_IFMT) {
+	case S_IFDIR:
+		return 0;
+	case S_IFREG:
+		return 1;
+	default:
+		return -1;
+	}
+}
+
+static int do_gen_btf(int argc, char **argv)
+{
+	char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
+	bool input_is_file, output_is_file = false;
+	const char *input, *output;
+	const char **objs = NULL;
+	struct dirent *dir;
+	DIR *d = NULL;
+	int i, err;
+
+	if (!REQ_ARGS(3)) {
+		usage();
+		return -1;
+	}
+
+	input = GET_ARG();
+	err = is_file(input);
+	if (err < 0) {
+		p_err("failed to stat %s: %s", input, strerror(errno));
+		return err;
+	}
+	input_is_file = err;
+
+	output = GET_ARG();
+	err = is_file(output);
+	if (err != 0)
+		output_is_file = true;
+
+	objs = (const char **) malloc((argc + 1) * sizeof(*objs));
+	if (!objs)
+		return -ENOMEM;
+
+	i = 0;
+	while (argc > 0)
+		objs[i++] = GET_ARG();
+
+	objs[i] = NULL;
+
+	/* single BTF file */
+	if (input_is_file) {
+		printf("SBTF: %s\n", input);
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
+		snprintf(src_btf_path, sizeof(src_btf_path), "%s/%s", input, dir->d_name);
+		snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", output, dir->d_name);
+
+		printf("SBTF: %s\n", src_btf_path);
+
+		err = btfgen(src_btf_path, dst_btf_path, objs);
+		if (err)
+			goto out;
+	}
+
+out:
+	if (!err)
+		printf("STAT: done!\n");
+	free(objs);
+	closedir(d);
+	return err;
+}
+
 static const struct cmd cmds[] = {
 	{ "object",	do_object },
 	{ "skeleton",	do_skeleton },
+	{ "btf",	do_gen_btf},
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.25.1

