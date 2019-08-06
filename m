Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87131837A5
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfHFRJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:09:08 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41549 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733201AbfHFRJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:09:07 -0400
Received: by mail-pg1-f201.google.com with SMTP id b18so55310853pgg.8
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pEg5rb9stUUJ5L/uEsWqFESiT33BU7mvugU4FLHi+as=;
        b=CXVr63Jv1WyVruwuESoCqVbWDuFKhR9nlKNDgDhgCYSTmxZNvKdD2UHui/9KrITC9d
         l9W+Lb/yK146ZbcyPuturKU5YYdbAZGY1mswuO5Jlf0b2XRW7yvTGUT53YykfQVPtIxx
         7lZeeZsBc7KGQB+MpB6PYROM7u26PTVdIAHiaiFzSSANCRiGOBfx91DO7nYa6cn0/sI7
         H5YadAsRAjMe+BJ0N9g5/hgOkryNp1xzYJdmmSkl/AThRi1UKuhPYy8dIYcfd1tJF+Cz
         iPFFMloXSpB5mevq60UuUYEkslV0bddhhnCVbJ+ArIU2L2MW4YPuePCkJEPcFq0I9sB4
         jYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pEg5rb9stUUJ5L/uEsWqFESiT33BU7mvugU4FLHi+as=;
        b=d/gGL7JdaqGkXE5OJN1zNFLVyZNdRToZj/uOjhJPYoJPKY7Dyu8jW0s+qMGAXZHLOQ
         RFm3Y03JWAqx3x6MoUiJ1FMjrENi+/S4OrqNKzdPDIoA/ABucy48+Klr9a62do6PIwxF
         dAPSCoIfLaCRH2DY0HHpcS/e9kfD+jrY8tHE2p3U+EwB2mhPoGjMAJLYbm/yaItnVgbX
         EmAFl3yjTUzW2RGiU40D3/C/dn+Hmm2LWjeKQdOGlcRtmm5sdVDe0udZ6GCofv8Lb/Ts
         6u5rm7QqzT9BGjz4nWNAp6d3iX419fZPZRQXdPQtj/gnMAL6L6UBzXzRPSNdHZaIjl/s
         P6nA==
X-Gm-Message-State: APjAAAW6+GjJ84k4KAfOJWApxkT02uRG/Af03OxxKEegpWaE+gIWAsCM
        kixPw2mrr7t0OeaV5DHht4rOiBeXdIrhDUBK60u9STScd7cgR4K/xJfGLmuusK19XaDk9jjJ0FZ
        iiZrfl9rb7nkt5Cq2jobkjQv9ANQvoHIuIFcNBGRi7A4VoW7fJphnPQ==
X-Google-Smtp-Source: APXvYqwmDNTlEJ9jOHc8LSssjyvsLo5MuJxYCbEAR4hsvfEqMB7TCLDgrDXV17amTuc4xVxsSJggWuA=
X-Received: by 2002:a65:6406:: with SMTP id a6mr3806509pgv.393.1565111346367;
 Tue, 06 Aug 2019 10:09:06 -0700 (PDT)
Date:   Tue,  6 Aug 2019 10:08:59 -0700
In-Reply-To: <20190806170901.142264-1-sdf@google.com>
Message-Id: <20190806170901.142264-2-sdf@google.com>
Mime-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v4 1/3] selftests/bpf: test_progs: switch to open_memstream
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use open_memstream to override stdout during test execution.
The copy of the original stdout is held in env.stdout and used
to print subtest info and dump failed log.

test_{v,}printf are now simple wrappers around stdout and will be
removed in the next patch.

v4:
* one field per line for stdout/stderr (Andrii Nakryiko)

v3:
* don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)

v2:
* add ifdef __GLIBC__ around open_memstream (maybe pointless since
  we already depend on glibc for argp_parse)
* hijack stderr as well (Andrii Nakryiko)
* don't hijack for every test, do it once (Andrii Nakryiko)
* log_cap -> log_size (Andrii Nakryiko)
* do fseeko in a proper place (Andrii Nakryiko)
* check open_memstream returned value (Andrii Nakryiko)

Cc: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
 tools/testing/selftests/bpf/test_progs.h |   3 +-
 2 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index db00196c8315..9556439c607c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -40,14 +40,20 @@ static bool should_run(struct test_selector *sel, int num, const char *name)
 
 static void dump_test_log(const struct prog_test_def *test, bool failed)
 {
+	if (stdout == env.stdout)
+		return;
+
+	fflush(stdout); /* exports env.log_buf & env.log_cnt */
+
 	if (env.verbose || test->force_log || failed) {
 		if (env.log_cnt) {
-			fprintf(stdout, "%s", env.log_buf);
+			fprintf(env.stdout, "%s", env.log_buf);
 			if (env.log_buf[env.log_cnt - 1] != '\n')
-				fprintf(stdout, "\n");
+				fprintf(env.stdout, "\n");
 		}
 	}
-	env.log_cnt = 0;
+
+	fseeko(stdout, 0, SEEK_SET); /* rewind */
 }
 
 void test__end_subtest()
@@ -62,7 +68,7 @@ void test__end_subtest()
 
 	dump_test_log(test, sub_error_cnt);
 
-	printf("#%d/%d %s:%s\n",
+	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
 }
@@ -79,7 +85,8 @@ bool test__start_subtest(const char *name)
 	test->subtest_num++;
 
 	if (!name || !name[0]) {
-		fprintf(stderr, "Subtest #%d didn't provide sub-test name!\n",
+		fprintf(env.stderr,
+			"Subtest #%d didn't provide sub-test name!\n",
 			test->subtest_num);
 		return false;
 	}
@@ -100,53 +107,7 @@ void test__force_log() {
 
 void test__vprintf(const char *fmt, va_list args)
 {
-	size_t rem_sz;
-	int ret = 0;
-
-	if (env.verbose || (env.test && env.test->force_log)) {
-		vfprintf(stderr, fmt, args);
-		return;
-	}
-
-try_again:
-	rem_sz = env.log_cap - env.log_cnt;
-	if (rem_sz) {
-		va_list ap;
-
-		va_copy(ap, args);
-		/* we reserved extra byte for \0 at the end */
-		ret = vsnprintf(env.log_buf + env.log_cnt, rem_sz + 1, fmt, ap);
-		va_end(ap);
-
-		if (ret < 0) {
-			env.log_buf[env.log_cnt] = '\0';
-			fprintf(stderr, "failed to log w/ fmt '%s'\n", fmt);
-			return;
-		}
-	}
-
-	if (!rem_sz || ret > rem_sz) {
-		size_t new_sz = env.log_cap * 3 / 2;
-		char *new_buf;
-
-		if (new_sz < 4096)
-			new_sz = 4096;
-		if (new_sz < ret + env.log_cnt)
-			new_sz = ret + env.log_cnt;
-
-		/* +1 for guaranteed space for terminating \0 */
-		new_buf = realloc(env.log_buf, new_sz + 1);
-		if (!new_buf) {
-			fprintf(stderr, "failed to realloc log buffer: %d\n",
-				errno);
-			return;
-		}
-		env.log_buf = new_buf;
-		env.log_cap = new_sz;
-		goto try_again;
-	}
-
-	env.log_cnt += ret;
+	vprintf(fmt, args);
 }
 
 void test__printf(const char *fmt, ...)
@@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	return 0;
 }
 
+static void stdio_hijack(void)
+{
+#ifdef __GLIBC__
+	if (env.verbose || (env.test && env.test->force_log)) {
+		/* nothing to do, output to stdout by default */
+		return;
+	}
+
+	/* stdout and stderr -> buffer */
+	fflush(stdout);
+
+	env.stdout = stdout;
+	env.stderr = stderr;
+
+	stdout = open_memstream(&env.log_buf, &env.log_cnt);
+	if (!stdout) {
+		stdout = env.stdout;
+		perror("open_memstream");
+		return;
+	}
+
+	stderr = stdout;
+#endif
+}
+
+static void stdio_restore(void)
+{
+#ifdef __GLIBC__
+	if (stdout == env.stdout)
+		return;
+
+	fclose(stdout);
+	free(env.log_buf);
+
+	env.log_buf = NULL;
+	env.log_cnt = 0;
+
+	stdout = env.stdout;
+	stderr = env.stderr;
+#endif
+}
+
 int main(int argc, char **argv)
 {
 	static const struct argp argp = {
@@ -496,6 +499,7 @@ int main(int argc, char **argv)
 
 	env.jit_enabled = is_jit_enabled();
 
+	stdio_hijack();
 	for (i = 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test = &prog_test_defs[i];
 		int old_pass_cnt = pass_cnt;
@@ -523,13 +527,14 @@ int main(int argc, char **argv)
 
 		dump_test_log(test, test->error_cnt);
 
-		printf("#%d %s:%s\n", test->test_num, test->test_name,
-		       test->error_cnt ? "FAIL" : "OK");
+		fprintf(env.stdout, "#%d %s:%s\n",
+			test->test_num, test->test_name,
+			test->error_cnt ? "FAIL" : "OK");
 	}
+	stdio_restore();
 	printf("Summary: %d/%d PASSED, %d FAILED\n",
 	       env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
 
-	free(env.log_buf);
 	free(env.test_selector.num_set);
 	free(env.subtest_selector.num_set);
 
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index afd14962456f..541f9eab5eed 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -56,9 +56,10 @@ struct test_env {
 	bool jit_enabled;
 
 	struct prog_test_def *test;
+	FILE *stdout;
+	FILE *stderr;
 	char *log_buf;
 	size_t log_cnt;
-	size_t log_cap;
 
 	int succ_cnt; /* successful tests */
 	int sub_succ_cnt; /* successful sub-tests */
-- 
2.22.0.770.g0f2c4a37fd-goog

