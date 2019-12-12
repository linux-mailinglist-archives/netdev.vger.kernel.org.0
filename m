Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5011C24B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfLLBgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:36:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727469AbfLLBgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:36:31 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC1XN7N028613
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=xQ5M/cOvnftQuavJNO36z9POUkMAY3rR4Tcd3dP6nOs=;
 b=DrA4PzWqytYfSQOyqEfOAvw/9mkOLjoNnpD1ZBkM/jvcV/UrCqjGvihNyuJ87JO9Ak3U
 0MWxReOblLAhlh85MqiE9LTc6tjZ9Zcscnmz4jcQbxX6jYR4+P+ciw4SYYnJCt/TgfmP
 WquOjjvqudLtapmjm2RQyqowWIhpm7qvmdo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu4ksa1a8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:30 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Dec 2019 17:36:28 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2C0AE2EC1A0E; Wed, 11 Dec 2019 17:36:23 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] selftests/bpf: fix perf_buffer test on systems w/ offline CPUs
Date:   Wed, 11 Dec 2019 17:36:20 -0800
Message-ID: <20191212013621.1691858-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=25 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up perf_buffer.c selftest to take into account offline/missing CPUs.
Fixes: ee5cf82ce04a ("selftests/bpf: test perf buffer API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/perf_buffer.c    | 29 +++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index 3003fddc0613..cf6c87936c69 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -4,6 +4,7 @@
 #include <sched.h>
 #include <sys/socket.h>
 #include <test_progs.h>
+#include "libbpf_internal.h"
 
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
@@ -19,7 +20,7 @@ static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 
 void test_perf_buffer(void)
 {
-	int err, prog_fd, nr_cpus, i, duration = 0;
+	int err, prog_fd, on_len, nr_on_cpus = 0,  nr_cpus, i, duration = 0;
 	const char *prog_name = "kprobe/sys_nanosleep";
 	const char *file = "./test_perf_buffer.o";
 	struct perf_buffer_opts pb_opts = {};
@@ -29,15 +30,27 @@ void test_perf_buffer(void)
 	struct bpf_object *obj;
 	struct perf_buffer *pb;
 	struct bpf_link *link;
+	bool *online;
 
 	nr_cpus = libbpf_num_possible_cpus();
 	if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
 		return;
 
+	err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
+				  &online, &on_len);
+	if (CHECK(err, "nr_on_cpus", "err %d\n", err))
+		return;
+
+	for (i = 0; i < on_len; i++)
+		if (online[i])
+			nr_on_cpus++;
+
 	/* load program */
 	err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
-		return;
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno)) {
+		obj = NULL;
+		goto out_close;
+	}
 
 	prog = bpf_object__find_program_by_title(obj, prog_name);
 	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
@@ -64,6 +77,11 @@ void test_perf_buffer(void)
 	/* trigger kprobe on every CPU */
 	CPU_ZERO(&cpu_seen);
 	for (i = 0; i < nr_cpus; i++) {
+		if (i >= on_len || !online[i]) {
+			printf("skipping offline CPU #%d\n", i);
+			continue;
+		}
+
 		CPU_ZERO(&cpu_set);
 		CPU_SET(i, &cpu_set);
 
@@ -81,8 +99,8 @@ void test_perf_buffer(void)
 	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
 		goto out_free_pb;
 
-	if (CHECK(CPU_COUNT(&cpu_seen) != nr_cpus, "seen_cpu_cnt",
-		  "expect %d, seen %d\n", nr_cpus, CPU_COUNT(&cpu_seen)))
+	if (CHECK(CPU_COUNT(&cpu_seen) != nr_on_cpus, "seen_cpu_cnt",
+		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
 		goto out_free_pb;
 
 out_free_pb:
@@ -91,4 +109,5 @@ void test_perf_buffer(void)
 	bpf_link__destroy(link);
 out_close:
 	bpf_object__close(obj);
+	free(online);
 }
-- 
2.17.1

