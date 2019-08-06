Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB27382904
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 03:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbfHFBHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 21:07:09 -0400
Received: from lekensteyn.nl ([178.21.112.251]:52921 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbfHFBHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 21:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=Eco6wgfKsARQ+Y0b0QLjUMg+d0by1sbRz7Q/ZW7O1wU=;
        b=Dz6CfvtNDFcL6PDKPrLk0YHrq6POVjcizSihnlPui15gfSTsVXt9I8EWY0RzdX4tAW1wxw/2Kl9E9WjDeTTB/hBDEIzm1f8WeQqQM+PsRk98zTTU1cansrWF3+vvoFHo/e0B1MRkCoIYxX/U25/25t0apjySNAYK6wITDdGkMX9uANTiY2p6Z/Idl9y9zGcH2h4vHd13uyKH13+YukB3SbuRVC2A55S2mvAnEUkUtzpCdm1IlHSYzm/6NiwuHojpmc51eXgXFeB1NfNGfWdMYc+71Y3RH+FjrWVnla5kzQIFVTbiSi4z7X29NDuIg1xaVdWK9utpxZSsLJ5lQR6gzA==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hunwN-00084H-GD; Tue, 06 Aug 2019 03:07:03 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH v2] tools: bpftool: fix reading from /proc/config.gz
Date:   Tue,  6 Aug 2019 02:07:02 +0100
Message-Id: <20190806010702.3303-1-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/config has never existed as far as I can see, but /proc/config.gz
is present on Arch Linux. Execute an external gunzip program to avoid
linking to zlib and rework the option scanning code since a pipe is not
seekable. This also fixes a file handle leak on some error paths.

Fixes: 4567b983f78c ("tools: bpftool: add probes for kernel configuration options")
Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 v2: fix style (reorder vars as reverse xmas tree, rename function,
     braces), fallback to /proc/config.gz if uname() fails.

Hi,

Although Stanislav and Jakub suggested to use zlib in v1, I have not
implemented that yet since the current patch is quite minimal.

Using zlib instead of executing an external gzip program would like add
another 100-150 lines. It likely requires a bigger rewrite to avoid
getline() assuming that no temporary file is used for the uncompressed
config. If zlib is desired, I would suggest doing it in another patch.

Thoughts?

Kind regards,
Peter
---
 tools/bpf/bpftool/feature.c | 104 +++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 44 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index d672d9086fff..b9ade5a8bc3c 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -284,34 +284,35 @@ static void probe_jit_limit(void)
 	}
 }
 
-static char *get_kernel_config_option(FILE *fd, const char *option)
+static bool read_next_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
+					   char **value)
 {
-	size_t line_n = 0, optlen = strlen(option);
-	char *res, *strval, *line = NULL;
-	ssize_t n;
+	ssize_t linelen;
+	char *sep;
 
-	rewind(fd);
-	while ((n = getline(&line, &line_n, fd)) > 0) {
-		if (strncmp(line, option, optlen))
-			continue;
-		/* Check we have at least '=', value, and '\n' */
-		if (strlen(line) < optlen + 3)
+	while ((linelen = getline(buf_p, n_p, fd)) > 0) {
+		char *line = *buf_p;
+
+		if (strncmp(line, "CONFIG_", 7))
 			continue;
-		if (*(line + optlen) != '=')
+
+		sep = memchr(line, '=', linelen);
+		if (!sep)
 			continue;
 
 		/* Trim ending '\n' */
-		line[strlen(line) - 1] = '\0';
+		line[linelen - 1] = '\0';
+
+		/* Split on '=' and ensure that a value is present. */
+		*sep = '\0';
+		if (!sep[1])
+			continue;
 
-		/* Copy and return config option value */
-		strval = line + optlen + 1;
-		res = strdup(strval);
-		free(line);
-		return res;
+		*value = sep + 1;
+		return true;
 	}
-	free(line);
 
-	return NULL;
+	return false;
 }
 
 static void probe_kernel_image_config(void)
@@ -386,31 +387,36 @@ static void probe_kernel_image_config(void)
 		/* test_bpf module for BPF tests */
 		"CONFIG_TEST_BPF",
 	};
+	char *values[ARRAY_SIZE(options)] = { };
 	char *value, *buf = NULL;
 	struct utsname utsn;
 	char path[PATH_MAX];
+	bool is_pipe = false;
+	FILE *fd = NULL;
 	size_t i, n;
 	ssize_t ret;
-	FILE *fd;
 
-	if (uname(&utsn))
-		goto no_config;
+	if (!uname(&utsn)) {
+		snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
 
-	snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
+		fd = fopen(path, "r");
+		if (!fd && errno != ENOENT)
+			p_info("Cannot open %s: %s", path, strerror(errno));
+	}
 
-	fd = fopen(path, "r");
-	if (!fd && errno == ENOENT) {
-		/* Some distributions put the config file at /proc/config, give
-		 * it a try.
-		 * Sometimes it is also at /proc/config.gz but we do not try
-		 * this one for now, it would require linking against libz.
+	if (!fd) {
+		/* Some distributions build with CONFIG_IKCONFIG=y and put the
+		 * config file at /proc/config.gz. We try to invoke an external
+		 * gzip program to avoid linking to libz.
+		 * Hide stderr to avoid interference with the JSON output.
 		 */
-		fd = fopen("/proc/config", "r");
+		fd = popen("gunzip -c /proc/config.gz 2>/dev/null", "r");
+		is_pipe = true;
 	}
 	if (!fd) {
 		p_info("skipping kernel config, can't open file: %s",
 		       strerror(errno));
-		goto no_config;
+		goto end_parse;
 	}
 	/* Sanity checks */
 	ret = getline(&buf, &n, fd);
@@ -418,27 +424,37 @@ static void probe_kernel_image_config(void)
 	if (!buf || !ret) {
 		p_info("skipping kernel config, can't read from file: %s",
 		       strerror(errno));
-		free(buf);
-		goto no_config;
+		goto end_parse;
 	}
 	if (strcmp(buf, "# Automatically generated file; DO NOT EDIT.\n")) {
 		p_info("skipping kernel config, can't find correct file");
-		free(buf);
-		goto no_config;
+		goto end_parse;
+	}
+
+	while (read_next_kernel_config_option(fd, &buf, &n, &value)) {
+		for (i = 0; i < ARRAY_SIZE(options); i++) {
+			if (values[i] || strcmp(buf, options[i]))
+				continue;
+
+			values[i] = strdup(value);
+		}
+	}
+
+end_parse:
+	if (fd) {
+		if (is_pipe) {
+			if (pclose(fd))
+				p_info("failed to read /proc/config.gz");
+		} else {
+			fclose(fd);
+		}
 	}
 	free(buf);
 
 	for (i = 0; i < ARRAY_SIZE(options); i++) {
-		value = get_kernel_config_option(fd, options[i]);
-		print_kernel_option(options[i], value);
-		free(value);
+		print_kernel_option(options[i], values[i]);
+		free(values[i]);
 	}
-	fclose(fd);
-	return;
-
-no_config:
-	for (i = 0; i < ARRAY_SIZE(options); i++)
-		print_kernel_option(options[i], NULL);
 }
 
 static bool probe_bpf_syscall(const char *define_prefix)
-- 
2.22.0

