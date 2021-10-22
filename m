Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63F4380BF
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJVXur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:50:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231624AbhJVXur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:50:47 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MNlSXX017209
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 16:48:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=zgFZgn3XzLa3XFa50o5bvPzG+RtReeoJG1ORt/ZMQOs=;
 b=bsZXRGQS3vUcFGk9zUKwp4JFRfzTwzyFmxTk9BMtVgwTfWAqr5eCJZg+DOL2hNjjSrEj
 qKzVfkhaVFfCUQtNHyPatmEckBtYYAZaFlrhB7jKjsi1esaSxE99tq5Zp+n0emq4NDqG
 NHal7Xbt18xg0QMWLUrJmRr0vHErGwXbb/w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bv79hg02f-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 16:48:29 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 22 Oct 2021 16:48:26 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E4EFA19E2A367; Fri, 22 Oct 2021 16:48:21 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: guess function end for test_get_branch_snapshot
Date:   Fri, 22 Oct 2021 16:48:14 -0700
Message-ID: <20211022234814.318457-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: ADeUvHC_U3TV9zpHyIPjfaX9a6RVf7JR
X-Proofpoint-ORIG-GUID: ADeUvHC_U3TV9zpHyIPjfaX9a6RVf7JR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function in modules could appear in /proc/kallsyms in random order.

ffffffffa02608a0 t bpf_testmod_loop_test
ffffffffa02600c0 t __traceiter_bpf_testmod_test_writable_bare
ffffffffa0263b60 d __tracepoint_bpf_testmod_test_write_bare
ffffffffa02608c0 T bpf_testmod_test_read
ffffffffa0260d08 t __SCT__tp_func_bpf_testmod_test_writable_bare
ffffffffa0263300 d __SCK__tp_func_bpf_testmod_test_read
ffffffffa0260680 T bpf_testmod_test_write
ffffffffa0260860 t bpf_testmod_test_mod_kfunc

Therefore, we cannot reliably use kallsyms_find_next() to find the end of
a function. Replace it with a simple guess (start + 128). This is good
enough for this test.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/get_branch_snapshot.c      |  7 ++--
 tools/testing/selftests/bpf/trace_helpers.c   | 36 -------------------
 tools/testing/selftests/bpf/trace_helpers.h   |  5 ---
 3 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c=
 b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
index d6d70a359aeb5..bc2b6e6d167d4 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
@@ -91,9 +91,10 @@ void serial_test_get_branch_snapshot(void)
 	if (!ASSERT_OK(err, "kallsyms_find"))
 		goto cleanup;
=20
-	err =3D kallsyms_find_next("bpf_testmod_loop_test", &skel->bss->address=
_high);
-	if (!ASSERT_OK(err, "kallsyms_find_next"))
-		goto cleanup;
+	/* Just a guess for the end of this function, as module functions
+	 * in /proc/kallsyms could come in any order.
+	 */
+	skel->bss->address_high =3D skel->bss->address_low + 128;
=20
 	err =3D get_branch_snapshot__attach(skel);
 	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/=
selftests/bpf/trace_helpers.c
index 5100a169b72b1..7b7f918eda776 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -118,42 +118,6 @@ int kallsyms_find(const char *sym, unsigned long lon=
g *addr)
 	return err;
 }
=20
-/* find the address of the next symbol of the same type, this can be use=
d
- * to determine the end of a function.
- */
-int kallsyms_find_next(const char *sym, unsigned long long *addr)
-{
-	char type, found_type, name[500];
-	unsigned long long value;
-	bool found =3D false;
-	int err =3D 0;
-	FILE *f;
-
-	f =3D fopen("/proc/kallsyms", "r");
-	if (!f)
-		return -EINVAL;
-
-	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
-		/* Different types of symbols in kernel modules are mixed
-		 * in /proc/kallsyms. Only return the next matching type.
-		 * Use tolower() for type so that 'T' matches 't'.
-		 */
-		if (found && found_type =3D=3D tolower(type)) {
-			*addr =3D value;
-			goto out;
-		}
-		if (strcmp(name, sym) =3D=3D 0) {
-			found =3D true;
-			found_type =3D tolower(type);
-		}
-	}
-	err =3D -ENOENT;
-
-out:
-	fclose(f);
-	return err;
-}
-
 void read_trace_pipe(void)
 {
 	int trace_fd;
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/=
selftests/bpf/trace_helpers.h
index bc8ed86105d94..d907b445524d5 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -16,11 +16,6 @@ long ksym_get_addr(const char *name);
 /* open kallsyms and find addresses on the fly, faster than load + searc=
h. */
 int kallsyms_find(const char *sym, unsigned long long *addr);
=20
-/* find the address of the next symbol, this can be used to determine th=
e
- * end of a function
- */
-int kallsyms_find_next(const char *sym, unsigned long long *addr);
-
 void read_trace_pipe(void);
=20
 ssize_t get_uprobe_offset(const void *addr, ssize_t base);
--=20
2.30.2

