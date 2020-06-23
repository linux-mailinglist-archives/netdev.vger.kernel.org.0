Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14982047E7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgFWDWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:22:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36800 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731552AbgFWDWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:22:38 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N3EKRY022183
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:22:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jGEd8Qm8VYhVNHEomGb8YOl2uMOuG8pc+dweqhO0500=;
 b=ofhWpTG1CQ1SCDp2xE+HKKhUiZNPvpmE+eKQJ1TgtcSGYkSiiYkIoa5hqwtigUQ7fcBq
 HWm4JF4hPmpAYCXFlj17FOzGA6CtfC51veduL8jXydzqAWn+rlED6eFXQpsY7W6VR37T
 VWe5zL9YZMRejFAJf2nyVAe5xT7pidDAwHA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31sfykun43-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:22:37 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 20:22:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9DD882EC33D1; Mon, 22 Jun 2020 20:22:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: add variable-length data concat pattern less than test
Date:   Mon, 22 Jun 2020 20:22:23 -0700
Message-ID: <20200623032224.4020118-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623032224.4020118-1-andriin@fb.com>
References: <20200623032224.4020118-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=534 spamscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

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
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../testing/selftests/bpf/prog_tests/varlen.c | 12 ++++
 .../testing/selftests/bpf/progs/test_varlen.c | 70 +++++++++++++++++--
 2 files changed, 78 insertions(+), 4 deletions(-)

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
index 09691852debf..cd4b72c55dfe 100644
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
+int handler64_unsigned(void *regs)
 {
 	int pid =3D bpf_get_current_pid_tgid() >> 32;
 	void *payload =3D payload1;
@@ -54,8 +64,34 @@ int handler64(void *regs)
 	return 0;
 }
=20
-SEC("tp_btf/sys_enter")
-int handler32(void *regs)
+SEC("raw_tp/sys_exit")
+int handler64_signed(void *regs)
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
+	if (len >=3D 0) {
+		payload +=3D len;
+		payload3_len1 =3D len;
+	}
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
+	if (len >=3D 0) {
+		payload +=3D len;
+		payload3_len2 =3D len;
+	}
+	total3 =3D payload - (void *)payload3;
+
+	return 0;
+}
+
+SEC("tp/raw_syscalls/sys_enter")
+int handler32_unsigned(void *regs)
 {
 	int pid =3D bpf_get_current_pid_tgid() >> 32;
 	void *payload =3D payload2;
@@ -82,7 +118,33 @@ int handler32(void *regs)
 	return 0;
 }
=20
-SEC("tp_btf/sys_exit")
+SEC("tp/raw_syscalls/sys_exit")
+int handler32_signed(void *regs)
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
+	if (len >=3D 0) {
+		payload +=3D len;
+		payload4_len1 =3D len;
+	}
+	len =3D bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
+	if (len >=3D 0) {
+		payload +=3D len;
+		payload4_len2 =3D len;
+	}
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

