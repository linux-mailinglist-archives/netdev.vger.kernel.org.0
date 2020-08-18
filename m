Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A74249028
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHRVeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:34:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62248 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbgHRVeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:34:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ILTpkG013445
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NtWgSBHMlRBU3D8pfovl8LeA7mltK+oVVy1/dlunmiQ=;
 b=Wr4vdRcGYzJVjdhSMknKvx1FPTYDQuW5f7cYKdFoheEfLSh9NOJ3OfkwU9Q+w6Js7lQH
 4+0FuMYF45ZQzfpS/7gd0+2xiK7525z7xu3Rdscd7DM1UsDCpRPnlJIgBXUvADjf0R5a
 mLBhVz3kl4/LSBYbMX8d6ASMQ9pYIK7ZE64= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304jbd6u6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:18 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:34:17 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 888D82EC5EAC; Tue, 18 Aug 2020 14:34:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/7] selftests/bpf: fix test_vmlinux test to use bpf_probe_read_user()
Date:   Tue, 18 Aug 2020 14:33:54 -0700
Message-ID: <20200818213356.2629020-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818213356.2629020-1-andriin@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_15:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=877 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=8
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test is reading UAPI kernel structure from user-space. So it doesn't =
need
CO-RE relocations and has to use bpf_probe_read_user().

Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tr=
acing of syscalls")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/test_vmlinux.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/tes=
ting/selftests/bpf/progs/test_vmlinux.c
index 29fa09d6a6c6..e9dfa0313d1b 100644
--- a/tools/testing/selftests/bpf/progs/test_vmlinux.c
+++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
@@ -19,12 +19,14 @@ SEC("tp/syscalls/sys_enter_nanosleep")
 int handle__tp(struct trace_event_raw_sys_enter *args)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
=20
 	if (args->id !=3D __NR_nanosleep)
 		return 0;
=20
 	ts =3D (void *)args->args[0];
-	if (BPF_CORE_READ(ts, tv_nsec) !=3D MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec !=3D MY_TV_NSEC)
 		return 0;
=20
 	tp_called =3D true;
@@ -35,12 +37,14 @@ SEC("raw_tp/sys_enter")
 int BPF_PROG(handle__raw_tp, struct pt_regs *regs, long id)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
=20
 	if (id !=3D __NR_nanosleep)
 		return 0;
=20
 	ts =3D (void *)PT_REGS_PARM1_CORE(regs);
-	if (BPF_CORE_READ(ts, tv_nsec) !=3D MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec !=3D MY_TV_NSEC)
 		return 0;
=20
 	raw_tp_called =3D true;
@@ -51,12 +55,14 @@ SEC("tp_btf/sys_enter")
 int BPF_PROG(handle__tp_btf, struct pt_regs *regs, long id)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
=20
 	if (id !=3D __NR_nanosleep)
 		return 0;
=20
 	ts =3D (void *)PT_REGS_PARM1_CORE(regs);
-	if (BPF_CORE_READ(ts, tv_nsec) !=3D MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec !=3D MY_TV_NSEC)
 		return 0;
=20
 	tp_btf_called =3D true;
--=20
2.24.1

