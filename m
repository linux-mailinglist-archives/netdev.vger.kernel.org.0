Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07513DE2A1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfJUDjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727021AbfJUDjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9L3U63E029836
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5y/va9/msMAijutnWbVeSAvy4IUt4s+rCi40uoYAEII=;
 b=MTbnsoRlqRrFc0bRh2/SicUPnp81Cl18G9BFI2ULzacOTZeh+MNPRpaZaeCR5FWT4dFj
 oofswPcuMCgmcQY1Umycb3BFeJRsUtCk6a09VfvcZUDwdyb4l1ntnaICYI2S7R4lD+XX
 GSPqz9OX3s4FP2Unh+R2vviK/OM9zXXgzuw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vqwyyd5jy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:21 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 20 Oct 2019 20:39:20 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2703B861976; Sun, 20 Oct 2019 20:39:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 6/7] selftests/bpf: make reference_tracking test use subtests
Date:   Sun, 20 Oct 2019 20:39:01 -0700
Message-ID: <20191021033902.3856966-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
References: <20191021033902.3856966-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=25 mlxlogscore=693 impostorscore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reference_tracking is actually a set of 9 sub-tests. Make it explicitly so.

Also, add explicit "classifier/" prefix to BPF program section names to
let libbpf correctly guess program type. Thus, also remove explicit
bpf_prog__set_type() call.

Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/reference_tracking.c        |  3 ++-
 .../selftests/bpf/progs/test_sk_lookup_kern.c  | 18 +++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index 86cee820d4d3..4493ba277bd7 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -31,7 +31,8 @@ void test_reference_tracking(void)
 		if (strstr(title, ".text") != NULL)
 			continue;
 
-		bpf_program__set_type(prog, BPF_PROG_TYPE_SCHED_CLS);
+		if (!test__start_subtest(title))
+			continue;
 
 		/* Expect verifier failure if test name has 'fail' */
 		if (strstr(title, "fail") != NULL) {
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
index e21cd736c196..cb49ccb707d1 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -53,7 +53,7 @@ static struct bpf_sock_tuple *get_tuple(void *data, __u64 nh_off,
 	return result;
 }
 
-SEC("sk_lookup_success")
+SEC("classifier/sk_lookup_success")
 int bpf_sk_lookup_test0(struct __sk_buff *skb)
 {
 	void *data_end = (void *)(long)skb->data_end;
@@ -78,7 +78,7 @@ int bpf_sk_lookup_test0(struct __sk_buff *skb)
 	return sk ? TC_ACT_OK : TC_ACT_UNSPEC;
 }
 
-SEC("sk_lookup_success_simple")
+SEC("classifier/sk_lookup_success_simple")
 int bpf_sk_lookup_test1(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -90,7 +90,7 @@ int bpf_sk_lookup_test1(struct __sk_buff *skb)
 	return 0;
 }
 
-SEC("fail_use_after_free")
+SEC("classifier/fail_use_after_free")
 int bpf_sk_lookup_uaf(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -105,7 +105,7 @@ int bpf_sk_lookup_uaf(struct __sk_buff *skb)
 	return family;
 }
 
-SEC("fail_modify_sk_pointer")
+SEC("classifier/fail_modify_sk_pointer")
 int bpf_sk_lookup_modptr(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -120,7 +120,7 @@ int bpf_sk_lookup_modptr(struct __sk_buff *skb)
 	return 0;
 }
 
-SEC("fail_modify_sk_or_null_pointer")
+SEC("classifier/fail_modify_sk_or_null_pointer")
 int bpf_sk_lookup_modptr_or_null(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -134,7 +134,7 @@ int bpf_sk_lookup_modptr_or_null(struct __sk_buff *skb)
 	return 0;
 }
 
-SEC("fail_no_release")
+SEC("classifier/fail_no_release")
 int bpf_sk_lookup_test2(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -143,7 +143,7 @@ int bpf_sk_lookup_test2(struct __sk_buff *skb)
 	return 0;
 }
 
-SEC("fail_release_twice")
+SEC("classifier/fail_release_twice")
 int bpf_sk_lookup_test3(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -155,7 +155,7 @@ int bpf_sk_lookup_test3(struct __sk_buff *skb)
 	return 0;
 }
 
-SEC("fail_release_unchecked")
+SEC("classifier/fail_release_unchecked")
 int bpf_sk_lookup_test4(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple tuple = {};
@@ -172,7 +172,7 @@ void lookup_no_release(struct __sk_buff *skb)
 	bpf_sk_lookup_tcp(skb, &tuple, sizeof(tuple), BPF_F_CURRENT_NETNS, 0);
 }
 
-SEC("fail_no_release_subcall")
+SEC("classifier/fail_no_release_subcall")
 int bpf_sk_lookup_test5(struct __sk_buff *skb)
 {
 	lookup_no_release(skb);
-- 
2.17.1

