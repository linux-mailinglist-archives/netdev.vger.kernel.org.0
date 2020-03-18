Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6418A15F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCRRRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:17:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgCRRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:17:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHH0mP019631
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=D0Jtkkm6AL4Oe4xGtKHLS8UlTsEKAsa9KsYEwJtAblo=;
 b=H375uT+SmEqlz76jTSyvtbieTlJBQDgQdmJ/rcZ94jUDNjubX2LQVIN6uHQAVaKyfvmo
 LEtBMlFh7wiINpKkmq87VRSIW1X2ZaNTBQK0inYFhAcysddW9JfItUHqIt3lo+RoMI48
 QzoDq6Ig5vMdjmjsiLN0cmOoOZdd64UcGJg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu7j2439r-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:17:51 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 10:16:46 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D365B29425EF; Wed, 18 Mar 2020 10:16:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/4] bpftool: Print as a string for char array
Date:   Wed, 18 Mar 2020 10:16:43 -0700
Message-ID: <20200318171643.129021-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318171631.128566-1-kafai@fb.com>
References: <20200318171631.128566-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=13 priorityscore=1501 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=921 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180077
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A char[] is currently printed as an integer array.
This patch will print it as a string when
1) The array element type is an one byte int
2) The array element type has a BTF_INT_CHAR encoding or
   the array element type's name is "char"
3) All characters is between (0x1f, 0x7f) and it is terminated
   by a null character.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 41 ++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index e86e240da4df..e0cff4de2101 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -81,6 +81,42 @@ static int btf_dumper_enum(const struct btf_dumper *d,
 	return 0;
 }
 
+static bool is_str_array(const struct btf *btf, const struct btf_array *arr,
+			 const char *s)
+{
+	const struct btf_type *elem_type;
+	const char *end_s;
+
+	if (!arr->nelems)
+		return false;
+
+	elem_type = btf__type_by_id(btf, arr->type);
+	/* Not skipping typedef.  typedef to char does not count as
+	 * a string now.
+	 */
+	while (elem_type && btf_is_mod(elem_type))
+		elem_type = btf__type_by_id(btf, elem_type->type);
+
+	if (!elem_type || !btf_is_int(elem_type) || elem_type->size != 1)
+		return false;
+
+	if (btf_int_encoding(elem_type) != BTF_INT_CHAR &&
+	    strcmp("char", btf__name_by_offset(btf, elem_type->name_off)))
+		return false;
+
+	end_s = s + arr->nelems;
+	while (s < end_s) {
+		if (!*s)
+			return true;
+		if (*s <= 0x1f || *s >= 0x7f)
+			return false;
+		s++;
+	}
+
+	/* '\0' is not found */
+	return false;
+}
+
 static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
 			    const void *data)
 {
@@ -90,6 +126,11 @@ static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
 	int ret = 0;
 	__u32 i;
 
+	if (is_str_array(d->btf, arr, data)) {
+		jsonw_string(d->jw, data);
+		return 0;
+	}
+
 	elem_size = btf__resolve_size(d->btf, arr->type);
 	if (elem_size < 0)
 		return elem_size;
-- 
2.17.1

