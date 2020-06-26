Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118A120A9B9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgFZANw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:13:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbgFZANv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:13:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q0BrOt007687
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PB4mymUPZh9olBqG+tmu3FmZh6UViBX5lSwF10QNN6A=;
 b=Y+uNakqO8dHNIv0pZW0f4P3kZ7qlLNkaUOPOTu35Izx8zZedKHj6zQYrd8KKbE8lgfNP
 tKb3dbgxDeHm/r9uBQaxzr/T1Ic1FdnekIDv2T4hzqGSNd+ocQrKZLFsWSGG6Ra998Qj
 7X/lk8ZH6wI3txTGmPNUriZJMlQ/LcUK4z4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0xttq5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:50 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 17:13:48 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5BED762E4FA9; Thu, 25 Jun 2020 17:13:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/4] bpf: allow %pB in bpf_seq_printf() and bpf_trace_printk()
Date:   Thu, 25 Jun 2020 17:13:31 -0700
Message-ID: <20200626001332.1554603-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626001332.1554603-1-songliubraving@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 mlxscore=0 impostorscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it easy to dump stack trace in text.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/trace/bpf_trace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 65fa62723e2f8..1cb90b0868817 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -376,7 +376,7 @@ static void bpf_trace_copy_string(char *buf, void *un=
safe_ptr, char fmt_ptype,
=20
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
@@ -420,6 +420,11 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_s=
ize, u64, arg1,
 				goto fmt_str;
 			}
=20
+			if (fmt[i + 1] =3D=3D 'B') {
+				i++;
+				goto fmt_next;
+			}
+
 			/* disallow any further format extensions */
 			if (fmt[i + 1] !=3D 0 &&
 			    !isspace(fmt[i + 1]) &&
@@ -479,7 +484,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_si=
ze, u64, arg1,
 #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
 #define __BPF_TP(...)							\
 	__trace_printk(0 /* Fake ip */,					\
-		       fmt, ##__VA_ARGS__)
+		       fmt, ##__VA_ARGS__)\
=20
 #define __BPF_ARG1_TP(...)						\
 	((mod[0] =3D=3D 2 || (mod[0] =3D=3D 1 && __BITS_PER_LONG =3D=3D 64))	\
@@ -636,7 +641,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char=
 *, fmt, u32, fmt_size,
 		if (fmt[i] =3D=3D 'p') {
 			if (fmt[i + 1] =3D=3D 0 ||
 			    fmt[i + 1] =3D=3D 'K' ||
-			    fmt[i + 1] =3D=3D 'x') {
+			    fmt[i + 1] =3D=3D 'x' ||
+			    fmt[i + 1] =3D=3D 'B') {
 				/* just kernel pointers */
 				params[fmt_cnt] =3D args[fmt_cnt];
 				fmt_cnt++;
--=20
2.24.1

