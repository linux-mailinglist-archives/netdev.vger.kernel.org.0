Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6D123D958
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgHFKoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 06:44:14 -0400
Received: from foss.arm.com ([217.140.110.172]:42238 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbgHFKnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 06:43:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B01D3113E;
        Thu,  6 Aug 2020 03:43:15 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 94F403F9AB;
        Thu,  6 Aug 2020 03:43:12 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Song.Zhu@arm.com,
        Jianlin.Lv@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2] bpf: fix compilation warning of selftests
Date:   Thu,  6 Aug 2020 18:42:24 +0800
Message-Id: <20200806104224.95306-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731061600.18344-1-Jianlin.Lv@arm.com>
References: <20200731061600.18344-1-Jianlin.Lv@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang compiler version: 12.0.0
The following warning appears during the selftests/bpf compilation:

prog_tests/send_signal.c:51:3: warning: ignoring return value of ‘write’,
declared with attribute warn_unused_result [-Wunused-result]
   51 |   write(pipe_c2p[1], buf, 1);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~
prog_tests/send_signal.c:54:3: warning: ignoring return value of ‘read’,
declared with attribute warn_unused_result [-Wunused-result]
   54 |   read(pipe_p2c[0], buf, 1);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~
......

prog_tests/stacktrace_build_id_nmi.c:13:2: warning: ignoring return value
of ‘fscanf’,declared with attribute warn_unused_result [-Wunused-resul]
   13 |  fscanf(f, "%llu", &sample_freq);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

test_tcpnotify_user.c:133:2: warning:ignoring return value of ‘system’,
declared with attribute warn_unused_result [-Wunused-result]
  133 |  system(test_script);
      |  ^~~~~~~~~~~~~~~~~~~
test_tcpnotify_user.c:138:2: warning:ignoring return value of ‘system’,
declared with attribute warn_unused_result [-Wunused-result]
  138 |  system(test_script);
      |  ^~~~~~~~~~~~~~~~~~~
test_tcpnotify_user.c:143:2: warning:ignoring return value of ‘system’,
declared with attribute warn_unused_result [-Wunused-result]
  143 |  system(test_script);
      |  ^~~~~~~~~~~~~~~~~~~

Add code that fix compilation warning about ignoring return value and
handles any errors; Check return value of library`s API make the code
more secure.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
v2:
- replease CHECK_FAIL by CHECK
- fix test_tcpnotify_user failed issue
---
 .../selftests/bpf/prog_tests/send_signal.c     | 18 ++++++++----------
 .../bpf/prog_tests/stacktrace_build_id_nmi.c   |  4 +++-
 .../selftests/bpf/test_tcpnotify_user.c        | 13 ++++++++++---
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 504abb7bfb95..7043e6ded0e6 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -48,21 +48,19 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 		close(pipe_p2c[1]); /* close write */
 
 		/* notify parent signal handler is installed */
-		write(pipe_c2p[1], buf, 1);
+		CHECK(write(pipe_c2p[1], buf, 1) != 1, "pipe_write", "err %d\n", -errno);
 
 		/* make sure parent enabled bpf program to send_signal */
-		read(pipe_p2c[0], buf, 1);
+		CHECK(read(pipe_p2c[0], buf, 1) != 1, "pipe_read", "err %d\n", -errno);
 
 		/* wait a little for signal handler */
 		sleep(1);
 
-		if (sigusr1_received)
-			write(pipe_c2p[1], "2", 1);
-		else
-			write(pipe_c2p[1], "0", 1);
+		buf[0] = sigusr1_received ? '2' : '0';
+		CHECK(write(pipe_c2p[1], buf, 1) != 1, "pipe_write", "err %d\n", -errno);
 
 		/* wait for parent notification and exit */
-		read(pipe_p2c[0], buf, 1);
+		CHECK(read(pipe_p2c[0], buf, 1) != 1, "pipe_read", "err %d\n", -errno);
 
 		close(pipe_c2p[1]);
 		close(pipe_p2c[0]);
@@ -99,7 +97,7 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 	}
 
 	/* wait until child signal handler installed */
-	read(pipe_c2p[0], buf, 1);
+	CHECK(read(pipe_c2p[0], buf, 1) != 1, "pipe_read", "err %d\n", -errno);
 
 	/* trigger the bpf send_signal */
 	skel->bss->pid = pid;
@@ -107,7 +105,7 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 	skel->bss->signal_thread = signal_thread;
 
 	/* notify child that bpf program can send_signal now */
-	write(pipe_p2c[1], buf, 1);
+	CHECK(write(pipe_p2c[1], buf, 1) != 1, "pipe_write", "err %d\n", -errno);
 
 	/* wait for result */
 	err = read(pipe_c2p[0], buf, 1);
@@ -121,7 +119,7 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 	CHECK(buf[0] != '2', test_name, "incorrect result\n");
 
 	/* notify child safe to exit */
-	write(pipe_p2c[1], buf, 1);
+	CHECK(write(pipe_p2c[1], buf, 1) != 1, "pipe_write", "err %d\n", -errno);
 
 disable_pmu:
 	close(pmu_fd);
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index f002e3090d92..11a769e18f5d 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -6,11 +6,13 @@ static __u64 read_perf_max_sample_freq(void)
 {
 	__u64 sample_freq = 5000; /* fallback to 5000 on error */
 	FILE *f;
+	__u32 duration = 0;
 
 	f = fopen("/proc/sys/kernel/perf_event_max_sample_rate", "r");
 	if (f == NULL)
 		return sample_freq;
-	fscanf(f, "%llu", &sample_freq);
+	CHECK(fscanf(f, "%llu", &sample_freq) != 1, "Get max sample rate",
+		  "return default value: 5000,err %d\n", -errno);
 	fclose(f);
 	return sample_freq;
 }
diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
index 8549b31716ab..73da7fe8c152 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -124,17 +124,24 @@ int main(int argc, char **argv)
 	sprintf(test_script,
 		"iptables -A INPUT -p tcp --dport %d -j DROP",
 		TESTPORT);
-	system(test_script);
+	if (system(test_script)) {
+		printf("FAILED: execute command: %s, err %d\n", test_script, -errno);
+		goto err;
+	}
 
 	sprintf(test_script,
 		"nc 127.0.0.1 %d < /etc/passwd > /dev/null 2>&1 ",
 		TESTPORT);
-	system(test_script);
+	if (system(test_script))
+		printf("execute command: %s, err %d\n", test_script, -errno);
 
 	sprintf(test_script,
 		"iptables -D INPUT -p tcp --dport %d -j DROP",
 		TESTPORT);
-	system(test_script);
+	if (system(test_script)) {
+		printf("FAILED: execute command: %s, err %d\n", test_script, -errno);
+		goto err;
+	}
 
 	rv = bpf_map_lookup_elem(bpf_map__fd(global_map), &key, &g);
 	if (rv != 0) {
-- 
2.17.1

