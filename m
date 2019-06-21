Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839AA4DFE6
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfFUE4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:56:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12268 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbfFUE4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:56:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L4nMIr021681
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:56:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tIZH5d4Hw94HARbcW9PqBXRMqTbUQwhIALOj3O2m2vc=;
 b=HRa1r8vmAuWadvKVt+o9K8joyMB5wmyXICWQx60IunZBJP4LXhSLPhvU29ZrZZqwswSg
 Y04QAAOdt+CLBwi/1xCxeDYmuIqeZGOlE+osryl5mQ3xpYRe3IbWRNjagIXlalr5jT1L
 w5Sc8aQshFkPVdDA4pd/Z8BOA/+JMZXr6lE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8n908hvm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:56:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 21:56:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3D346861776; Thu, 20 Jun 2019 21:56:08 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <sdf@fomichev.me>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 5/7] selftests/bpf: switch test to new attach_perf_event API
Date:   Thu, 20 Jun 2019 21:55:53 -0700
Message-ID: <20190621045555.4152743-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621045555.4152743-1-andriin@fb.com>
References: <20190621045555.4152743-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new bpf_program__attach_perf_event() in test previously relying on
direct ioctl manipulations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 1c1a2f75f3d8..c83f16e8eccf 100644
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
@@ -25,6 +26,7 @@ void test_stacktrace_build_id_nmi(void)
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
 	__u32 key, previous_key, val, duration = 0;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char buf[256];
 	int i, j;
@@ -39,6 +41,10 @@ void test_stacktrace_build_id_nmi(void)
 	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
 		return;
 
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+		goto close_prog;
+
 	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
 			 0 /* cpu 0 */, -1 /* group id */,
 			 0 /* flags */);
@@ -47,14 +53,8 @@ void test_stacktrace_build_id_nmi(void)
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
+	err = bpf_program__attach_perf_event(prog, pmu_fd);
+	if (CHECK(err, "attach_perf_event", "err %d\n", err))
 		goto disable_pmu;
 
 	/* find map fds */
@@ -134,8 +134,7 @@ void test_stacktrace_build_id_nmi(void)
 	 * try it one more time.
 	 */
 	if (build_id_matches < 1 && retry--) {
-		ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-		close(pmu_fd);
+		libbpf_perf_event_disable_and_close(pmu_fd);
 		bpf_object__close(obj);
 		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
 		       __func__);
@@ -154,10 +153,7 @@ void test_stacktrace_build_id_nmi(void)
 	 */
 
 disable_pmu:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-
-close_pmu:
-	close(pmu_fd);
+	libbpf_perf_event_disable_and_close(pmu_fd);
 
 close_prog:
 	bpf_object__close(obj);
-- 
2.17.1

