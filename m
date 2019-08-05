Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4235E8207F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfHEPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:41:01 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:34928 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbfHEPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:41:00 -0400
Received: by mail-pg1-f201.google.com with SMTP id w12so10647519pgo.2
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VbWp2IcFMmNTy3ZnP2gppqLHvrQI7kxDAWjKQpCIscA=;
        b=dHy29LrKZBy7IJjkj6i/K8/d6O4i83apB8eRif1mvuTglNz0wHys6yVdqa9t8/vY5Z
         75beephVNpvlb60hQ0chXggFq7iYwGNbBysQk+Z67anUQtsfTjmVoExo4tOdTAQp0bBz
         O1VmXhR+CcOJ/llhf7q0qu6j94VrQO0Wz3TB17q/xoQZIv0lS64E/tMjIgYQc5KGNJxG
         sLVrWZa3N1C0oSDY6BBSdSiiM9N5vWX3sFWaAByAS6FuAtaFSCPwNq2Q1C4c892QVlyx
         4gailQvxUWvHdEAoF3tjzNZdzA/eytm1flXe3+igDbOEmGspYE+yQ60pxzDOgVGTxBl8
         MygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VbWp2IcFMmNTy3ZnP2gppqLHvrQI7kxDAWjKQpCIscA=;
        b=LnvQRkn9VKh2fd+nRyLxVnvu4YtT+GC2m056mA3ebCauTDLQ5tMwb3ZMpw28ae6yNr
         0Ln5+HUHy2BfD5voPftUmAnFs8tTBOYeQ/Nrk4fDYtuQ+z2t6whpSL0WDHlF7GFDsROT
         UWWuSD+zGvJEwTiu5thAm01Zo3i4egxmRvrrJNogEZq+u6AwtO4ePAgfacVcVZNh1GS1
         JEx5laRWkm8rYDuQAikwclI/aKKuAvWMaNkf2Dim0hg+49VbHu28oqu1Jt3Qi68V6WEi
         HveX5SSKiDORRIZU8jLi6u8k2ROOdZWfJABk25AXgzX2vmF5RmRr9eNNAkluFN8lC35L
         7DKQ==
X-Gm-Message-State: APjAAAXb0Gqpw3pprZIbdlArYamk8yj9FhamC0ikbofIrM+SoPJ+7kC9
        Bb3LfA6/nyl3Gdp/GiCvLZsbPsOZ7Yc2toHPo5/jyWP5uNE0nyVMHznvY9q3IMVdh4f5oi8MpO4
        c8oWh+bjNGJlKhnXO6WYcusHvDkC4Sj00TI5Rwcny3jxSsP/gcqxEgg==
X-Google-Smtp-Source: APXvYqxy+eymvhIKhlx2Qd0cP1/DIarOSCPV+EgRxlotQIKp90YHcCe4WyM3aWtFCw9Mj/Gx3y+k/Bc=
X-Received: by 2002:a63:2157:: with SMTP id s23mr20530402pgm.167.1565019659450;
 Mon, 05 Aug 2019 08:40:59 -0700 (PDT)
Date:   Mon,  5 Aug 2019 08:40:53 -0700
In-Reply-To: <20190805154055.197664-1-sdf@google.com>
Message-Id: <20190805154055.197664-2-sdf@google.com>
Mime-Version: 1.0
References: <20190805154055.197664-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v3 1/3] selftests/bpf: test_progs: switch to open_memstream
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
 tools/testing/selftests/bpf/test_progs.h |   2 +-
 2 files changed, 61 insertions(+), 56 deletions(-)

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
index afd14962456f..4c00fc79ac5f 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -56,9 +56,9 @@ struct test_env {
 	bool jit_enabled;
 
 	struct prog_test_def *test;
+	FILE *stdout, *stderr;
 	char *log_buf;
 	size_t log_cnt;
-	size_t log_cap;
 
 	int succ_cnt; /* successful tests */
 	int sub_succ_cnt; /* successful sub-tests */
-- 
2.22.0.770.g0f2c4a37fd-goog

