Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9693918A154
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCRRQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:16:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12918 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgCRRQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:16:43 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHFvDk001874
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:16:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1yhxNONENWTgFNtFyIJ4GAsjLONNsenaZqTvl+jdD+s=;
 b=Z5g6WItqgg5G0IRxDcqN4OW9DdDiJWkwO4Uw3TuqCeLyrHveOuay8SlBGCsMA7OAQycm
 uRrwxLpWzymx8aMTZwZxVlDi89wBU5beek3/WzRubrAc/uceweBoyURBfaxaZSI9xjoZ
 bn2sJFauij4ffix80yG+J52kUKgve4+ggYM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9b5bkwr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:16:42 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 10:16:40 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9922629425EF; Wed, 18 Mar 2020 10:16:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 1/4] bpftool: Print the enum's name instead of value
Date:   Wed, 18 Mar 2020 10:16:37 -0700
Message-ID: <20200318171637.128862-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318171631.128566-1-kafai@fb.com>
References: <20200318171631.128566-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=939 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180077
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prints the enum's name if there is one found in
the array of btf_enum.

The commit 9eea98497951 ("bpf: fix BTF verification of enums")
has details about an enum could have any power-of-2 size (up to 8 bytes).
This patch also takes this chance to accommodate these non 4 byte
enums.

Acked-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 40 ++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 01cc52b834fa..e86e240da4df 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -43,9 +43,42 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
 	return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
 }
 
-static void btf_dumper_enum(const void *data, json_writer_t *jw)
+static int btf_dumper_enum(const struct btf_dumper *d,
+			    const struct btf_type *t,
+			    const void *data)
 {
-	jsonw_printf(jw, "%d", *(int *)data);
+	const struct btf_enum *enums = btf_enum(t);
+	__s64 value;
+	__u16 i;
+
+	switch (t->size) {
+	case 8:
+		value = *(__s64 *)data;
+		break;
+	case 4:
+		value = *(__s32 *)data;
+		break;
+	case 2:
+		value = *(__s16 *)data;
+		break;
+	case 1:
+		value = *(__s8 *)data;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < btf_vlen(t); i++) {
+		if (value == enums[i].val) {
+			jsonw_string(d->jw,
+				     btf__name_by_offset(d->btf,
+							 enums[i].name_off));
+			return 0;
+		}
+	}
+
+	jsonw_int(d->jw, value);
+	return 0;
 }
 
 static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
@@ -366,8 +399,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
 	case BTF_KIND_ARRAY:
 		return btf_dumper_array(d, type_id, data);
 	case BTF_KIND_ENUM:
-		btf_dumper_enum(data, d->jw);
-		return 0;
+		return btf_dumper_enum(d, t, data);
 	case BTF_KIND_PTR:
 		btf_dumper_ptr(data, d->jw, d->is_plain_text);
 		return 0;
-- 
2.17.1

