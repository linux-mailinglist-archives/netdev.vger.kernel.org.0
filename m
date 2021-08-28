Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2C3FA3D3
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 07:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhH1FV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 01:21:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhH1FVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 01:21:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17S5BSZt019527
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:20:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ILZyEqCRwDm76XZE8oy1eHkT/ZLL0fZ/U2KBBxy/xZk=;
 b=pNFlp2iPFw86x/yYaaB/qJj/+nSCm6qfP1LSn0qEuZPpsaunrNgjtrqoEc01r35fIkb0
 3ua5J2lncd5GKx6gUA84Ovlh09WAWVkqqK2vAShlgRr8h0qNhtAsJnWXmlhrdOMM6n1Q
 EP4Q7PJDndJzHeBfRA7AofofQ7wfp0IzWbY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3apfpfterk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:20:30 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 22:20:29 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id E8D275BF0E16; Fri, 27 Aug 2021 22:20:16 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v3 bpf-next 1/7] bpf: merge printk and seq_printf VARARG max macros
Date:   Fri, 27 Aug 2021 22:20:00 -0700
Message-ID: <20210828052006.1313788-2-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210828052006.1313788-1-davemarchevsky@fb.com>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: cQm1yWtrFUDqzXKEn3nMWYlN5Hw4CXHu
X-Proofpoint-GUID: cQm1yWtrFUDqzXKEn3nMWYlN5Hw4CXHu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-28_01:2021-08-27,2021-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108280031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAX_SNPRINTF_VARARGS and MAX_SEQ_PRINTF_VARARGS are used by bpf helpers
bpf_snprintf and bpf_seq_printf to limit their varargs. Both call into
bpf_bprintf_prepare for print formatting logic and have convenience
macros in libbpf (BPF_SNPRINTF, BPF_SEQ_PRINTF) which use the same
helper macros to convert varargs to a byte array.

Changing shared functionality to support more varargs for either bpf
helper would affect the other as well, so let's combine the _VARARGS
macros to make this more obvious.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h      | 2 ++
 kernel/bpf/helpers.c     | 4 +---
 kernel/trace/bpf_trace.c | 4 +---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f19f83e..be8d57e6e78a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2216,6 +2216,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke=
_type t,
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
=20
+#define MAX_BPRINTF_VARARGS		12
+
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 **bin_buf, u32 num_args);
 void bpf_bprintf_cleanup(void);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index c227b7d4f56c..0d969f8501e2 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -969,15 +969,13 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, co=
nst u64 *raw_args,
 	return err;
 }
=20
-#define MAX_SNPRINTF_VARARGS		12
-
 BPF_CALL_5(bpf_snprintf, char *, str, u32, str_size, char *, fmt,
 	   const void *, data, u32, data_len)
 {
 	int err, num_args;
 	u32 *bin_args;
=20
-	if (data_len % 8 || data_len > MAX_SNPRINTF_VARARGS * 8 ||
+	if (data_len % 8 || data_len > MAX_BPRINTF_VARARGS * 8 ||
 	    (data_len && !data))
 		return -EINVAL;
 	num_args =3D data_len / 8;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8e2eb950aa82..10672ebc63b7 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -414,15 +414,13 @@ const struct bpf_func_proto *bpf_get_trace_printk_p=
roto(void)
 	return &bpf_trace_printk_proto;
 }
=20
-#define MAX_SEQ_PRINTF_VARARGS		12
-
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_s=
ize,
 	   const void *, data, u32, data_len)
 {
 	int err, num_args;
 	u32 *bin_args;
=20
-	if (data_len & 7 || data_len > MAX_SEQ_PRINTF_VARARGS * 8 ||
+	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
 	    (data_len && !data))
 		return -EINVAL;
 	num_args =3D data_len / 8;
--=20
2.30.2

