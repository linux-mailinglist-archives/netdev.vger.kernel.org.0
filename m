Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263442044FC
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgFWAJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:09:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731468AbgFWAJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:09:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05N09N3O017365
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:09:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VVRkw0mNMzliyUAcnBvWOxYyVmvpyV4erL4y1PLHQeo=;
 b=DGoa18aFwi2CZj5Hnx9vNq1f8RJxqxNPGOl4YnZ/k9tRg88qnJSNDoDSuAW6razcV/If
 wsiajoJ+2rdbaP2ghqHO7VX6bX/lJiMzcBJQ1ZVlxQcpnjyImhGBe0uw/g9pPwSmu33U
 N+kfNkWCE98mRN0IhXDWJ84qIFodpJOyFPo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31sdxyuarp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:09:26 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 17:09:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9E92C2EC3BAF; Mon, 22 Jun 2020 17:09:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: add variable-length data concat pattern less than test
Date:   Mon, 22 Jun 2020 17:09:04 -0700
Message-ID: <20200623000905.3076979-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623000905.3076979-1-andriin@fb.com>
References: <20200623000905.3076979-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_15:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 phishscore=0 mlxscore=0 lowpriorityscore=0 cotscore=-2147483648
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=551
 malwarescore=0 clxscore=1015 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend original variable-length tests with a case to catch a common
existing pattern of testing for < 0 for errors. Note because
verifier also tracks upper bounds and we know it can not be greater
than MAX_LEN here we can skip upper bound check.

In ALU64 enabled compilation converting from long->int return types
in probe helpers results in extra instruction pattern, <<=3D 32, s >>=3D =
32.
The trade-off is the non-ALU64 case works. If you really care about
every extra insn (XDP case?) then you probably should be using original
int type.

In addition adding a sext insn to bpf might help the verifier in the
general case to avoid these types of tricks.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/varlen.c | 12 +++
 .../testing/selftests/bpf/progs/test_varlen.c | 74 ++++++++++++++++++-
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/varlen.c b/tools/test=
ing/selftests/bpf/prog_tests/varlen.c
index 7533565e096d..c75525eab02c 100644
--- a/tools/testing/selftests/bpf/prog_tests/varlen.c
+++ b/tools/testing/selftests/bpf/prog_tests/varlen.c
@@ -51,6 +51,18 @@ void test_varlen(void)
 	CHECK_VAL(data->total2, size1 + size2);
 	CHECK(memcmp(data->payload2, exp_str, size1 + size2), "content_check",
 	      "doesn't match!");
+
+	CHECK_VAL(data->payload3_len1, size1);
+	CHECK_VAL(data->payload3_len2, size2);
+	CHECK_VAL(data->total3, size1 + size2);
+	CHECK(memcmp(data->payload3, exp_str, size1 + size2), "content_check",
+	      "doesn't match!");
+
+	CHECK_VAL(data->payload4_len1, size1);
+	CHECK_VAL(data->payload4_len2, size2);
+	CHECK_VAL(data->total4, size1 + size2);
+	CHECK(memcmp(data->payload4, exp_str, size1 + size2), "content_check",
+	      "doesn't match!");
 cleanup:
 	test_varlen__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/test=
ing/selftests/bpf/progs/test_varlen.c
index 09691852debf..622ee9f075a4 100644
--- a/tools/testing/selftests/bpf/progs/test_varlen.c
+++ b/tools/testing/selftests/bpf/progs/test_varlen.c
@@ -26,8 +26,18 @@ int payload2_len2 =3D -1;
 int total2 =3D -1;
 char payload2[MAX_LEN + MAX_LEN] =3D { 1 };
=20
+int payload3_len1 =3D -1;
+int payload3_len2 =3D -1;
+int total3=3D -1;
+char payload3[MAX_LEN + MAX_LEN] =3D { 1 };
+
+int payload4_len1 =3D -1;
+int payload4_len2 =3D -1;
+int total4=3D -1;
+char payload4[MAX_LEN + MAX_LEN] =3D { 1 };
+
 SEC("raw_tp/sys_enter")
-int handler64(void *regs)
+int handler64_gt(void *regs)
 {
 	int pid =3D bpf_get_current_pid_tgid() >> 32;
 	void *payload =3D payload1;
@@ -54,8 +64,36 @@ int handler64(void *regs)
 	return 0;
 }
=20
-SEC("tp_btf/sys_enter")
-int handler32(void *regs)
+SEC("raw_tp/sys_exit")
+int handler64_lt(void *regs)
+{
+	int pid =3D bpf_get_current_pid_tgid() >> 32;
+	void *payload =3D payload3;
+	long len;
+
+	/* ignore irrelevant invocations */
+	if (test_pid !=3D pid || !capture)
+		return 0;
+
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
+	if (len < 0)
+		goto next_lt_long;
+	payload +=3D len;
+	payload3_len1 =3D len;
+next_lt_long:
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
+	if (len < 0)
+		goto done_lt_long;
+	payload +=3D len;
+	payload3_len2 =3D len;
+done_lt_long:
+	total3 =3D payload - (void *)payload3;
+
+	return 0;
+}
+
+SEC("tp/raw_syscalls/sys_enter")
+int handler32_gt(void *regs)
 {
 	int pid =3D bpf_get_current_pid_tgid() >> 32;
 	void *payload =3D payload2;
@@ -82,7 +120,35 @@ int handler32(void *regs)
 	return 0;
 }
=20
-SEC("tp_btf/sys_exit")
+SEC("tp/raw_syscalls/sys_exit")
+int handler32_lt(void *regs)
+{
+	int pid =3D bpf_get_current_pid_tgid() >> 32;
+	void *payload =3D payload4;
+	int len;
+
+	/* ignore irrelevant invocations */
+	if (test_pid !=3D pid || !capture)
+		return 0;
+
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
+	if (len < 0)
+		goto next_lt_int;
+	payload +=3D len;
+	payload4_len1 =3D len;
+next_lt_int:
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
+	if (len < 0)
+		goto done_lt_int;
+	payload +=3D len;
+	payload4_len2 =3D len;
+done_lt_int:
+	total4 =3D payload - (void *)payload4;
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_exit_getpid")
 int handler_exit(void *regs)
 {
 	long bla;
--=20
2.24.1

