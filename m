Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A0B424CAA
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhJGFHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:07:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhJGFHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 01:07:44 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196MdpMG014769
        for <netdev@vger.kernel.org>; Wed, 6 Oct 2021 22:05:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7hdLXDicxvEonqM+TahiXJu4T51iJEkOb954yCnSW5k=;
 b=lu24iiC8wbZt9nfOIVXkKDkLptVCdwloMWLu6o5SptyAieecAvzPSLWL7cMg/FNrb5cJ
 QcshAJnXxIzunzQ1nF3Osng/5lVrNBAMloKgY7w5tSUMXao4JyVVKh66NItVOkmkFVJM
 PhsFsjcUCDMBuUup1p1xMOK+kC5bpeYOpH8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bhmsjsuke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 22:05:51 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 6 Oct 2021 22:02:44 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8622515E2E2F3; Wed,  6 Oct 2021 22:02:40 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next v2] selftests/bpf: skip the second half of get_branch_snapshot in vm
Date:   Wed, 6 Oct 2021 22:02:31 -0700
Message-ID: <20211007050231.728496-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 0FYtscTWOH9yb5wcD9g88Ok3-asZZI91
X-Proofpoint-ORIG-GUID: 0FYtscTWOH9yb5wcD9g88Ok3-asZZI91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 mlxlogscore=933 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110070033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VMs running on latest kernel support LBR. However, bpf_get_branch_snapsho=
t
couldn't stop the LBR before too many entries are flushed. Skip the
hit/waste test for VMs before we find a proper fix for LBR in VM.

Fixes: 025bd7c753aa ("selftests/bpf: Add test for bpf_get_branch_snapshot=
")
Signed-off-by: Song Liu <songliubraving@fb.com>

---
Changes v1 =3D> v2:
1. Move the is_hypervisor() check to later in the test, so that we still
   Run the first half of the test in vm
2. Use strncmp instead of strstr. (Andrii)
3. Fix the Fixes tag. (Andrii)
---
 .../bpf/prog_tests/get_branch_snapshot.c      | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c=
 b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
index 67e86f8d86775..e4f92feb7b32c 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
@@ -6,6 +6,30 @@
 static int *pfd_array;
 static int cpu_cnt;
=20
+static bool is_hypervisor(void)
+{
+	char *line =3D NULL;
+	bool ret =3D false;
+	size_t len;
+	FILE *fp;
+
+	fp =3D fopen("/proc/cpuinfo", "r");
+	if (!fp)
+		return false;
+
+	while (getline(&line, &len, fp) !=3D -1) {
+		if (!strncmp(line, "flags", 5)) {
+			if (strstr(line, "hypervisor") !=3D NULL)
+				ret =3D true;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(fp);
+	return ret;
+}
+
 static int create_perf_events(void)
 {
 	struct perf_event_attr attr =3D {0};
@@ -83,6 +107,16 @@ void test_get_branch_snapshot(void)
 		goto cleanup;
 	}
=20
+	if (is_hypervisor()) {
+		/* As of today, LBR in hypervisor cannot be stopped before
+		 * too many entries are flushed. Skip the hit/waste test
+		 * for now in hypervisor until we optimize the LBR in
+		 * hypervisor.
+		 */
+		test__skip();
+		goto cleanup;
+	}
+
 	ASSERT_GT(skel->bss->test1_hits, 6, "find_looptest_in_lbr");
=20
 	/* Given we stop LBR in software, we will waste a few entries.
--=20
2.30.2

