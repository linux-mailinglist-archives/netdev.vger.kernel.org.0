Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA558314343
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBHWxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:53:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230413AbhBHWxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:53:50 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 118MhZLS015185
        for <netdev@vger.kernel.org>; Mon, 8 Feb 2021 14:53:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=10THGxePXoB95sI1fdIUAVKff0RKlTtaqSdCw8eabpw=;
 b=YQhAYMpbqxAd/G83xGcb9fp8Yr5IKEUez7jEGdBkJTQo1bKzKajXJEStB2N5HPIoscoh
 kmKdhTTqRTRl5MQ4YcaMJCU6Rd25Fqc4bsvh7uC9FRpvAKNyaHfPdfe4Ue3qoGccAQaj
 rOvITyUaV9JCI48963W3ueaBtEufHVk9y/w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 36hqntajjg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:53:09 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 14:53:06 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0DD8E62E092E; Mon,  8 Feb 2021 14:53:04 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v5 bpf-next 2/4] bpf: allow bpf_d_path in sleepable bpf_iter program
Date:   Mon, 8 Feb 2021 14:52:53 -0800
Message-ID: <20210208225255.3089073-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210208225255.3089073-1-songliubraving@fb.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_16:2021-02-08,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=692
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080126
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

