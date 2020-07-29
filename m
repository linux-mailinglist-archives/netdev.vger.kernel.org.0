Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC10A2318CF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 06:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgG2EvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 00:51:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgG2EvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 00:51:01 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06T4n9tL019547
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 21:51:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=K5sq1FzzUDjCtPDhZVD1PDhxer1YWGfOQzeB/Z02i0s=;
 b=jKnqG0FJXykTpim+46dzmsmsnx///+lIczG0Wnm4yF3dmfmR8no+CNZ9aVSgoO1tqMLX
 G0o01YZhErO3wznygV8JZWxrgkbfvNFzJXjQgqXVWuS+QRP5JxxhstjgQeIrCTTfPmaK
 apNFMmPkoRef3x1n8SYB0q2T5Nl4QrDHlUU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9n9j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 21:51:00 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 21:50:59 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 23BFE2EC4C9F; Tue, 28 Jul 2020 21:50:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        YiFei Zhu <zhuyifei@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: don't destroy failed link
Date:   Tue, 28 Jul 2020 21:50:56 -0700
Message-ID: <20200729045056.3363921-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_02:2020-07-28,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=604
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that link is NULL or proper pointer before invoking bpf_link__destr=
oy().
Not doing this causes crash in test_progs, when cg_storage_multi selftest
fails.

Cc: YiFei Zhu <zhuyifei@google.com>
Fixes: 3573f384014f ("selftests/bpf: Test CGROUP_STORAGE behavior on shar=
ed egress + ingress")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/cg_storage_multi.c         | 42 ++++++++++++-------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c b/=
tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
index c67d8c076a34..643dfa35419c 100644
--- a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
@@ -147,8 +147,10 @@ static void test_egress_only(int parent_cgroup_fd, i=
nt child_cgroup_fd)
 		goto close_bpf_object;
=20
 close_bpf_object:
-	bpf_link__destroy(parent_link);
-	bpf_link__destroy(child_link);
+	if (!IS_ERR(parent_link))
+		bpf_link__destroy(parent_link);
+	if (!IS_ERR(child_link))
+		bpf_link__destroy(child_link);
=20
 	cg_storage_multi_egress_only__destroy(obj);
 }
@@ -262,12 +264,18 @@ static void test_isolated(int parent_cgroup_fd, int=
 child_cgroup_fd)
 		goto close_bpf_object;
=20
 close_bpf_object:
-	bpf_link__destroy(parent_egress1_link);
-	bpf_link__destroy(parent_egress2_link);
-	bpf_link__destroy(parent_ingress_link);
-	bpf_link__destroy(child_egress1_link);
-	bpf_link__destroy(child_egress2_link);
-	bpf_link__destroy(child_ingress_link);
+	if (!IS_ERR(parent_egress1_link))
+		bpf_link__destroy(parent_egress1_link);
+	if (!IS_ERR(parent_egress2_link))
+		bpf_link__destroy(parent_egress2_link);
+	if (!IS_ERR(parent_ingress_link))
+		bpf_link__destroy(parent_ingress_link);
+	if (!IS_ERR(child_egress1_link))
+		bpf_link__destroy(child_egress1_link);
+	if (!IS_ERR(child_egress2_link))
+		bpf_link__destroy(child_egress2_link);
+	if (!IS_ERR(child_ingress_link))
+		bpf_link__destroy(child_ingress_link);
=20
 	cg_storage_multi_isolated__destroy(obj);
 }
@@ -367,12 +375,18 @@ static void test_shared(int parent_cgroup_fd, int c=
hild_cgroup_fd)
 		goto close_bpf_object;
=20
 close_bpf_object:
-	bpf_link__destroy(parent_egress1_link);
-	bpf_link__destroy(parent_egress2_link);
-	bpf_link__destroy(parent_ingress_link);
-	bpf_link__destroy(child_egress1_link);
-	bpf_link__destroy(child_egress2_link);
-	bpf_link__destroy(child_ingress_link);
+	if (!IS_ERR(parent_egress1_link))
+		bpf_link__destroy(parent_egress1_link);
+	if (!IS_ERR(parent_egress2_link))
+		bpf_link__destroy(parent_egress2_link);
+	if (!IS_ERR(parent_ingress_link))
+		bpf_link__destroy(parent_ingress_link);
+	if (!IS_ERR(child_egress1_link))
+		bpf_link__destroy(child_egress1_link);
+	if (!IS_ERR(child_egress2_link))
+		bpf_link__destroy(child_egress2_link);
+	if (!IS_ERR(child_ingress_link))
+		bpf_link__destroy(child_ingress_link);
=20
 	cg_storage_multi_shared__destroy(obj);
 }
--=20
2.24.1

