Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427CD3F7CEA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbhHYT7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235554AbhHYT7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17PJo4kU023262
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Fd6tEZ5nqp8njcBfd85QKkQzn2zMzVQbTt5W5TN/L+I=;
 b=dy8Lgi1rYGlOGV1MzdrlETkzyYPG8js+u4kZopMShFg8ZBetNBZVVnJC9U8guMHi0R7d
 WUdK4rjMdMPsVC1GNfA2yj/NPhDGwzzAZ1sSmJ2Ly/gnwHY1Ru0INF9JVdndTCY/F/FT
 Exw64FtsUxT1j8wtOwqenVONAFwIy3uazPQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3an5070rtq-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:38 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 12:58:32 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 3E16A5A34E5C; Wed, 25 Aug 2021 12:58:31 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 1/6] bpf: merge printk and seq_printf VARARG max macros
Date:   Wed, 25 Aug 2021 12:58:18 -0700
Message-ID: <20210825195823.381016-2-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825195823.381016-1-davemarchevsky@fb.com>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: VSzSckFuezwlg9hCtZz80FXJNZlF_LqW
X-Proofpoint-ORIG-GUID: VSzSckFuezwlg9hCtZz80FXJNZlF_LqW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108250117
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
index 4e8540716187..5ce19b376ef7 100644
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
index cbc73c08c4a4..2cf4bfa1ab7b 100644
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

