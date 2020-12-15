Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0F62DB76D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgLPABX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37126 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726221AbgLOXiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 18:38:00 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFNWulE008132
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+UK0j/mFombeFsFq0Rpm6Ff6mQdxwD/eCrgr4iYJQPk=;
 b=IeYinZqq+7GvLLtRv6oilJWPpAHiFhLWeTvoGgetEv023DHPXAoUgfCXUy7E5xwzCxYY
 yvI89CYmNbT2xxYofWoOjIB8uweiuc7aA0oZMTS83Q8TPaRA3G6ROl8tQwd49SWIfYXr
 pc4xCNqsx+jAvYLZYMy+XbB1IZKtzZzylBo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ej69p7ak-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:19 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 15:37:15 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 3FA7462E56FB; Tue, 15 Dec 2020 15:37:09 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 2/4] bpf: allow bpf_d_path in sleepable bpf_iter program
Date:   Tue, 15 Dec 2020 15:37:00 -0800
Message-ID: <20201215233702.3301881-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201215233702.3301881-1-songliubraving@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_13:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=680 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

task_file and task_vma iter programs have access to file->f_path. Enable
bpf_d_path to print paths of these file.

bpf_iter programs are generally called in sleepable context. However, it
is still necessary to diffientiate sleepable and non-sleepable bpf_iter
programs: sleepable programs have access to bpf_d_path; non-sleepable
programs have access to bpf_spin_lock.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/trace/bpf_trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4be771df5549a..9e5f9b968355f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1191,6 +1191,11 @@ BTF_SET_END(btf_allowlist_d_path)
=20
 static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 {
+	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
+	    prog->expected_attach_type =3D=3D BPF_TRACE_ITER &&
+	    prog->aux->sleepable)
+		return true;
+
 	if (prog->type =3D=3D BPF_PROG_TYPE_LSM)
 		return bpf_lsm_is_sleepable_hook(prog->aux->attach_btf_id);
=20
--=20
2.24.1

