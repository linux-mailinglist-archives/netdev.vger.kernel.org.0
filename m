Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4582080FDE
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfHEAy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 20:54:57 -0400
Received: from lekensteyn.nl ([178.21.112.251]:41089 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfHEAy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 20:54:57 -0400
X-Greylist: delayed 2350 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Aug 2019 20:54:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=23XVTJ0mMRsUdzz2hXUJCxyaTvqLXiJLySAxpuW0FfU=;
        b=jccqPI9EI+62hzXCLKEQuVjLOde4f4VW5//Fi7lzXtki6Yya+BvE/kOkBh8YbHtbLNzyikIOJZJLZ7zori9f3xd5l1B+ATmOey1m/3K6VFeHpxZ6mAMR+Z4SYi4jROycBIwEEkPlRiGRnkZrEWgAvZhlhWmnOnkwHTee0B8FWQn5GPhtoEqzYKP5wlfmCliyrdo6p6cVBsfAlnf0gi/o49qwud75G7siXl/LW9yvqg++z8c1DEz5A72GCT7uJAfUu3VTf9AlRWLVx2XsCC+HiBGzP2ziBaG9Y0PwWRxSlEIEo4GDvaJdqyyPhZSxxP8DxAWwg1wGGBsR6+hIhjoKQg==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1huQf9-0007k0-0c; Mon, 05 Aug 2019 02:15:43 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH] tools: bpftool: fix reading from /proc/config.gz
Date:   Mon,  5 Aug 2019 01:15:41 +0100
Message-Id: <20190805001541.8096-1-peter@lekensteyn.nl>
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
 tools/bpf/bpftool/feature.c | 92 +++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index d672d9086fff..e9e10f582047 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -284,34 +284,34 @@ static void probe_jit_limit(void)
 	}
 }
 
-static char *get_kernel_config_option(FILE *fd, const char *option)
+static bool get_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
+				     char **value)
 {
-	size_t line_n = 0, optlen = strlen(option);
-	char *res, *strval, *line = NULL;
-	ssize_t n;
+	char *sep;
+	ssize_t linelen;
 
-	rewind(fd);
-	while ((n = getline(&line, &line_n, fd)) > 0) {
-		if (strncmp(line, option, optlen))
+	while ((linelen = getline(buf_p, n_p, fd)) > 0) {
+		char *line = *buf_p;
+		if (strncmp(line, "CONFIG_", 7))
 			continue;
-		/* Check we have at least '=', value, and '\n' */
-		if (strlen(line) < optlen + 3)
-			continue;
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
@@ -386,31 +386,34 @@ static void probe_kernel_image_config(void)
 		/* test_bpf module for BPF tests */
 		"CONFIG_TEST_BPF",
 	};
+	char *values[ARRAY_SIZE(options)] = { };
 	char *value, *buf = NULL;
 	struct utsname utsn;
 	char path[PATH_MAX];
 	size_t i, n;
 	ssize_t ret;
-	FILE *fd;
+	FILE *fd = NULL;
+	bool is_pipe = false;
 
 	if (uname(&utsn))
-		goto no_config;
+		goto end_parse;
 
 	snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
 
 	fd = fopen(path, "r");
 	if (!fd && errno == ENOENT) {
-		/* Some distributions put the config file at /proc/config, give
-		 * it a try.
-		 * Sometimes it is also at /proc/config.gz but we do not try
-		 * this one for now, it would require linking against libz.
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
@@ -418,27 +421,36 @@ static void probe_kernel_image_config(void)
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
+	while (get_kernel_config_option(fd, &buf, &n, &value)) {
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
+		} else
+			fclose(fd);
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

