Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02B030FEE1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBDUvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:51:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230039AbhBDUvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:51:00 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114KiccJ018214
        for <netdev@vger.kernel.org>; Thu, 4 Feb 2021 12:50:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=10THGxePXoB95sI1fdIUAVKff0RKlTtaqSdCw8eabpw=;
 b=Q7emtN8VuM/eOGYijkKBDvOQXS/JbHhFVACcvL5WhP7mMIZ3mMV7f9PvvZlQjB51t7ff
 sx2nb6dgbA21cEvB6dXuKXfJycIlDVVgdQHx6VVlqo6/jCqZhDH0c22nIOgWsJExZkYS
 qFinNYCuAV4MZTGQvQ4+j0wmeP7g5ZWyOhA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36gqfkga76-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:19 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 12:50:16 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id F044162E1750; Thu,  4 Feb 2021 12:50:10 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v4 bpf-next 2/4] bpf: allow bpf_d_path in sleepable bpf_iter program
Date:   Thu, 4 Feb 2021 12:49:59 -0800
Message-ID: <20210204205002.4075937-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210204205002.4075937-1-songliubraving@fb.com>
References: <20210204205002.4075937-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_10:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=692 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040128
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

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/trace/bpf_trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6c0018abe68a0..1f3becd4435ae 100644
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

