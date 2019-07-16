Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7836A901
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 14:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbfGPM6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 08:58:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbfGPM6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 08:58:40 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GCwA94090858
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 08:58:39 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tsehbsjvh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 08:58:38 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 16 Jul 2019 13:58:36 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 13:58:35 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GCwYI149938486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 12:58:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE3925204E;
        Tue, 16 Jul 2019 12:58:33 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.96.205])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BB0155204F;
        Tue, 16 Jul 2019 12:58:33 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] selftests/bpf: fix perf_buffer on s390
Date:   Tue, 16 Jul 2019 14:58:27 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071612-0028-0000-0000-00000384B2BD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071612-0029-0000-0000-00002444D41D
Message-Id: <20190716125827.24413-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perf_buffer test fails for exactly the same reason test_attach_probe
used to fail: different nanosleep syscall kprobe name.

Reuse the test_attach_probe fix.

Fixes: ee5cf82ce04a ("selftests/bpf: test perf buffer API")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 .../testing/selftests/bpf/prog_tests/attach_probe.c  | 12 ++----------
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c |  8 +-------
 tools/testing/selftests/bpf/test_progs.h             |  8 ++++++++
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 47af4afc5013..5ecc267d98b0 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -21,14 +21,6 @@ ssize_t get_base_addr() {
 	return -EINVAL;
 }
 
-#ifdef __x86_64__
-#define SYS_KPROBE_NAME "__x64_sys_nanosleep"
-#elif defined(__s390x__)
-#define SYS_KPROBE_NAME "__s390x_sys_nanosleep"
-#else
-#define SYS_KPROBE_NAME "sys_nanosleep"
-#endif
-
 void test_attach_probe(void)
 {
 	const char *kprobe_name = "kprobe/sys_nanosleep";
@@ -86,7 +78,7 @@ void test_attach_probe(void)
 
 	kprobe_link = bpf_program__attach_kprobe(kprobe_prog,
 						 false /* retprobe */,
-						 SYS_KPROBE_NAME);
+						 SYS_NANOSLEEP_KPROBE_NAME);
 	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
 		  "err %ld\n", PTR_ERR(kprobe_link))) {
 		kprobe_link = NULL;
@@ -94,7 +86,7 @@ void test_attach_probe(void)
 	}
 	kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
 						    true /* retprobe */,
-						    SYS_KPROBE_NAME);
+						    SYS_NANOSLEEP_KPROBE_NAME);
 	if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
 		  "err %ld\n", PTR_ERR(kretprobe_link))) {
 		kretprobe_link = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index 3f1ef95865ff..3003fddc0613 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -5,12 +5,6 @@
 #include <sys/socket.h>
 #include <test_progs.h>
 
-#ifdef __x86_64__
-#define SYS_KPROBE_NAME "__x64_sys_nanosleep"
-#else
-#define SYS_KPROBE_NAME "sys_nanosleep"
-#endif
-
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
 	int cpu_data = *(int *)data, duration = 0;
@@ -56,7 +50,7 @@ void test_perf_buffer(void)
 
 	/* attach kprobe */
 	link = bpf_program__attach_kprobe(prog, false /* retprobe */,
-					  SYS_KPROBE_NAME);
+					  SYS_NANOSLEEP_KPROBE_NAME);
 	if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
 		goto out_close;
 
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index f095e1d4c657..49e0f7d85643 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -92,3 +92,11 @@ int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
 int extract_build_id(char *build_id, size_t size);
 void *spin_lock_thread(void *arg);
+
+#ifdef __x86_64__
+#define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
+#elif defined(__s390x__)
+#define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
+#else
+#define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
+#endif
-- 
2.21.0

