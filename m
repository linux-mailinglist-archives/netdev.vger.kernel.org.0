Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082FF4DDAA
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfFTXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22670 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbfFTXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KN7pX3008295
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zyJ4qfMvqklWNmro8ZUSpTKeTVBaJFd9/tcc2HybfU0=;
 b=giNCTC5xtP6cOJqeymZYVgO2eR98+SjVKE7Gs5iMWYrTFHtW0uOBCWZ1ZUtjMfHrKOC7
 rtLq0jlSYTICp0hwXRAegCnLTgwKz52bpwfglslPNd2OYobeDO9+0MvvLZazjlMfp3aD
 NhB0CHuDncOu1Dffi6rjige2wNU283c7/1E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8ewt11vy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 16:10:22 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 532CD86173D; Thu, 20 Jun 2019 16:10:22 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/7] selftests/bpf: switch test to new attach_perf_event API
Date:   Thu, 20 Jun 2019 16:09:49 -0700
Message-ID: <20190620230951.3155955-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620230951.3155955-1-andriin@fb.com>
References: <20190620230951.3155955-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new bpf_program__attach_perf_event() in test previously relying on
direct ioctl manipulations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/stacktrace_build_id_nmi.c     | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 1c1a2f75f3d8..1bbdb0b82ac5 100644
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
@@ -47,16 +53,10 @@ void test_stacktrace_build_id_nmi(void)
 		  pmu_fd, errno))
 		goto close_prog;
 
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
-		  err, errno))
+	err = bpf_program__attach_perf_event(prog, pmu_fd);
+	if (CHECK(err, "attach_perf_event", "err %d\n", err))
 		goto close_pmu;
 
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
-	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
-		  err, errno))
-		goto disable_pmu;
-
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
 	if (CHECK(control_map_fd < 0, "bpf_find_map control_map",
-- 
2.17.1

