Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138F6593CF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfF1Fx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:53:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbfF1Fx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:53:28 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5S5rRBr022599
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=YwqbDK/4xN43KXBklKPVgHWtFzAbOSYS8cH4sFnykwI=;
 b=m+0rY6Ze+/VUXaRs2sEGDu8YIBCZpMUIjrzwrEuboMwubNEjP+NwacH4XqFx0/nGON5x
 Tf9jSNYSiP9sVboPFDI1EHQefDWQk9FzgeK9CDCzkHHdQyn5pJkujGlaasfZV0gE4ypJ
 Pvw9omI7ULzJMS7Kz8OHaExvUkz00eEch94= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td4x7hg7a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:27 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 22:53:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C19A7861468; Thu, 27 Jun 2019 22:53:23 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <sdf@fomichev.me>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 7/9] selftests/bpf: switch test to new attach_perf_event API
Date:   Thu, 27 Jun 2019 22:53:01 -0700
Message-ID: <20190628055303.1249758-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628055303.1249758-1-andriin@fb.com>
References: <20190628055303.1249758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new bpf_program__attach_perf_event() in test previously relying on
direct ioctl manipulations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
---
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 1c1a2f75f3d8..9557b7dfb782 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -17,6 +17,7 @@ static __u64 read_perf_max_sample_freq(void)
 void test_stacktrace_build_id_nmi(void)
 {
 	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
+	const char *prog_name = "tracepoint/random/urandom_read";
 	const char *file = "./test_stacktrace_build_id.o";
 	int err, pmu_fd, prog_fd;
 	struct perf_event_attr attr = {
@@ -25,7 +26,9 @@ void test_stacktrace_build_id_nmi(void)
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
 	__u32 key, previous_key, val, duration = 0;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
+	struct bpf_link *link;
 	char buf[256];
 	int i, j;
 	struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
@@ -39,6 +42,10 @@ void test_stacktrace_build_id_nmi(void)
 	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
 		return;
 
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+		goto close_prog;
+
 	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
 			 0 /* cpu 0 */, -1 /* group id */,
 			 0 /* flags */);
@@ -47,15 +54,12 @@ void test_stacktrace_build_id_nmi(void)
 		  pmu_fd, errno))
 		goto close_prog;
 
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
-		  err, errno))
-		goto close_pmu;
-
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
-	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
-		  err, errno))
-		goto disable_pmu;
+	link = bpf_program__attach_perf_event(prog, pmu_fd);
+	if (CHECK(IS_ERR(link), "attach_perf_event",
+		  "err %ld\n", PTR_ERR(link))) {
+		close(pmu_fd);
+		goto close_prog;
+	}
 
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
@@ -134,8 +138,7 @@ void test_stacktrace_build_id_nmi(void)
 	 * try it one more time.
 	 */
 	if (build_id_matches < 1 && retry--) {
-		ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-		close(pmu_fd);
+		bpf_link__destroy(link);
 		bpf_object__close(obj);
 		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
 		       __func__);
@@ -154,11 +157,7 @@ void test_stacktrace_build_id_nmi(void)
 	 */
 
 disable_pmu:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-
-close_pmu:
-	close(pmu_fd);
-
+	bpf_link__destroy(link);
 close_prog:
 	bpf_object__close(obj);
 }
-- 
2.17.1

