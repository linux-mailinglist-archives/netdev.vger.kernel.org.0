Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AFB18610B
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgCPA4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:56:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729326AbgCPA4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:56:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02G0tFq0008358
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2U3258jE+KR2c5xsRPR76Yhc0qXFcpAxvcyyXcLDLJA=;
 b=YV3ZCmZhFSUyUSbAIhHARDCpUzULs13SFCR5VvNF75OhxLvlfvRF94QHD9iM9sNeE5Kq
 XiFOXwbBhbr+7tuG0IFka7RrvAZUR6kOO9w9q7ASBj9AZqDtA9BFqqacYNi6DWCQ3v3F
 QKUKxxDvm2atKAyPRa6/uE60fsKT6eylRiY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf36t9sb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:14 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 15 Mar 2020 17:56:14 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1344E2942F81; Sun, 15 Mar 2020 17:56:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] bpftool: Print as a string for char array
Date:   Sun, 15 Mar 2020 17:56:12 -0700
Message-ID: <20200316005612.2953413-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316005559.2952646-1-kafai@fb.com>
References: <20200316005559.2952646-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-15_05:2020-03-12,2020-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=986
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=13 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160002
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

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 41 ++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 57bd6c0fafc9..1d2d8d2cedea 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -77,6 +77,42 @@ static void btf_dumper_enum(const struct btf_dumper *d,
 	jsonw_int(d->jw, value);
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
@@ -86,6 +122,11 @@ static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
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

