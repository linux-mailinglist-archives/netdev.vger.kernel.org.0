Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA93218610A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgCPA4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:56:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729327AbgCPA4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:56:11 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02G0l769018422
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wBV1J7nj2QpHKzdwUsLMgIwgz+/2x1oLOge1gZYznss=;
 b=NnEC2SfcCWk7tSxBjkh9u/SWYWs4XuEGkXuf3nfiT6orQVt4DZ8AHFaS7rngKRjy5Iiw
 FslQtWYuyXqYeNwJ+e1vI53l6mk+kwzDcdWqlI+/VdgHjr5fz6XJNQMR66O9wd8AV8gE
 wZxh2KznqU2P+i/zIOF5IzPSTMa8FEatrP0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9qj9hp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 15 Mar 2020 17:56:08 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CE9812942F81; Sun, 15 Mar 2020 17:56:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] bpftool: Print the enum's name instead of value
Date:   Sun, 15 Mar 2020 17:56:05 -0700
Message-ID: <20200316005605.2953117-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316005559.2952646-1-kafai@fb.com>
References: <20200316005559.2952646-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-15_05:2020-03-12,2020-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 bulkscore=0 suspectscore=13 clxscore=1015 malwarescore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160001
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

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 35 +++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 01cc52b834fa..57bd6c0fafc9 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -43,9 +43,38 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
 	return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
 }
 
-static void btf_dumper_enum(const void *data, json_writer_t *jw)
+static void btf_dumper_enum(const struct btf_dumper *d,
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
+	default:
+		value = *(__s8 *)data;
+	}
+
+	for (i = 0; i < btf_vlen(t); i++) {
+		if (value == enums[i].val) {
+			jsonw_string(d->jw,
+				     btf__name_by_offset(d->btf,
+							 enums[i].name_off));
+			return;
+		}
+	}
+
+	jsonw_int(d->jw, value);
 }
 
 static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
@@ -366,7 +395,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
 	case BTF_KIND_ARRAY:
 		return btf_dumper_array(d, type_id, data);
 	case BTF_KIND_ENUM:
-		btf_dumper_enum(data, d->jw);
+		btf_dumper_enum(d, t, data);
 		return 0;
 	case BTF_KIND_PTR:
 		btf_dumper_ptr(data, d->jw, d->is_plain_text);
-- 
2.17.1

