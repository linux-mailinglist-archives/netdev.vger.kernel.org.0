Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A925C67425
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfGLR0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:26:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39212 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbfGLR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:26:17 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CHKuO7002056
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=CDrbiU9ZGnVrmUq6PNMQipu3RS4YuGfd7sv8JbRbd9Y=;
 b=JFb5b9pnUURew5hUGcxGi/XgFXju1tcfkDdgOMZYl9hS43fiCoDp34XBrQy6cMSPPA95
 NKpgNXQaqUMjieaLP2GAHU3ypPXaowTm1fY7OcwRCsS2LRFmT5zLJZpSNTpzSh09E9ch
 o8I0esYWRWOHMiRqUlwX2zjoB+JkTSQ0ZiE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpr8a9c5v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:16 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 12 Jul 2019 10:26:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 5B41E8614A9; Fri, 12 Jul 2019 10:26:13 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf 2/3] selftests/bpf: add trickier size resolution tests
Date:   Fri, 12 Jul 2019 10:25:56 -0700
Message-ID: <20190712172557.4039121-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190712172557.4039121-1-andriin@fb.com>
References: <20190712172557.4039121-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=810 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more BTF tests, validating that size resolution logic is correct in
few trickier cases.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_btf.c | 88 ++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 8351cb5f4a20..3d617e806054 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -3417,6 +3417,94 @@ static struct btf_raw_test raw_tests[] = {
 	.value_type_id = 1,
 	.max_entries = 4,
 },
+/*
+ * typedef int arr_t[16];
+ * struct s {
+ *	arr_t *a;
+ * };
+ */
+{
+	.descr = "struct->ptr->typedef->array->int size resolution",
+	.raw_types = {
+		BTF_STRUCT_ENC(NAME_TBD, 1, 8),			/* [1] */
+		BTF_MEMBER_ENC(NAME_TBD, 2, 0),
+		BTF_PTR_ENC(3),					/* [2] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),			/* [3] */
+		BTF_TYPE_ARRAY_ENC(5, 5, 16),			/* [4] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [5] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0s\0a\0arr_t"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = "ptr_mod_chain_size_resolve_map",
+	.key_size = sizeof(int),
+	.value_size = sizeof(int) * 16,
+	.key_type_id = 5 /* int */,
+	.value_type_id = 3 /* arr_t */,
+	.max_entries = 4,
+},
+/*
+ * typedef int arr_t[16][8][4];
+ * struct s {
+ *	arr_t *a;
+ * };
+ */
+{
+	.descr = "struct->ptr->typedef->multi-array->int size resolution",
+	.raw_types = {
+		BTF_STRUCT_ENC(NAME_TBD, 1, 8),			/* [1] */
+		BTF_MEMBER_ENC(NAME_TBD, 2, 0),
+		BTF_PTR_ENC(3),					/* [2] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),			/* [3] */
+		BTF_TYPE_ARRAY_ENC(5, 7, 16),			/* [4] */
+		BTF_TYPE_ARRAY_ENC(6, 7, 8),			/* [5] */
+		BTF_TYPE_ARRAY_ENC(7, 7, 4),			/* [6] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [7] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0s\0a\0arr_t"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = "multi_arr_size_resolve_map",
+	.key_size = sizeof(int),
+	.value_size = sizeof(int) * 16 * 8 * 4,
+	.key_type_id = 7 /* int */,
+	.value_type_id = 3 /* arr_t */,
+	.max_entries = 4,
+},
+/*
+ * typedef int int_t;
+ * typedef int_t arr3_t[4];
+ * typedef arr3_t arr2_t[8];
+ * typedef arr2_t arr1_t[16];
+ * struct s {
+ *	arr1_t *a;
+ * };
+ */
+{
+	.descr = "typedef/multi-arr mix size resolution",
+	.raw_types = {
+		BTF_STRUCT_ENC(NAME_TBD, 1, 8),			/* [1] */
+		BTF_MEMBER_ENC(NAME_TBD, 2, 0),
+		BTF_PTR_ENC(3),					/* [2] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),			/* [3] */
+		BTF_TYPE_ARRAY_ENC(5, 10, 16),			/* [4] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 6),			/* [5] */
+		BTF_TYPE_ARRAY_ENC(7, 10, 8),			/* [6] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 8),			/* [7] */
+		BTF_TYPE_ARRAY_ENC(9, 10, 4),			/* [8] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 10),			/* [9] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [10] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0s\0a\0arr1_t\0arr2_t\0arr3_t\0int_t"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = "typedef_arra_mix_size_resolve_map",
+	.key_size = sizeof(int),
+	.value_size = sizeof(int) * 16 * 8 * 4,
+	.key_type_id = 10 /* int */,
+	.value_type_id = 3 /* arr_t */,
+	.max_entries = 4,
+},
 
 }; /* struct btf_raw_test raw_tests[] */
 
-- 
2.17.1

