Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2C135343
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgAIGiB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 01:38:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728120AbgAIGiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:38:00 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0096bwEK001067
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 22:37:59 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2xdrhwshxa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 22:37:59 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 22:37:51 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 98D24760FEC; Wed,  8 Jan 2020 22:37:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/7] libbpf: Sanitize global functions
Date:   Wed, 8 Jan 2020 22:37:39 -0800
Message-ID: <20200109063745.3154913-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200109063745.3154913-1-ast@kernel.org>
References: <20200109063745.3154913-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_01:2020-01-08,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=874 malwarescore=0 adultscore=0 suspectscore=1
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the kernel doesn't support BTF_FUNC_GLOBAL sanitize BTF produced by the
compiler for global functions.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/include/uapi/linux/btf.h |  6 ++++++
 tools/lib/bpf/libbpf.c         | 35 +++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 1a2898c482ee..5a667107ad2c 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -146,6 +146,12 @@ enum {
 	BTF_VAR_GLOBAL_EXTERN = 2,
 };
 
+enum btf_func_linkage {
+	BTF_FUNC_STATIC = 0,
+	BTF_FUNC_GLOBAL = 1,
+	BTF_FUNC_EXTERN = 2,
+};
+
 /* BTF_KIND_VAR is followed by a single "struct btf_var" to describe
  * additional information related to the variable such as its linkage.
  */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7513165b104f..1039362a06a9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -166,6 +166,8 @@ struct bpf_capabilities {
 	__u32 btf_datasec:1;
 	/* BPF_F_MMAPABLE is supported for arrays */
 	__u32 array_mmap:1;
+	/* BTF_FUNC_GLOBAL is supported */
+	__u32 btf_func_global:1;
 };
 
 enum reloc_type {
@@ -1817,13 +1819,14 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
 
 static void bpf_object__sanitize_btf(struct bpf_object *obj)
 {
+	bool has_func_global = obj->caps.btf_func_global;
 	bool has_datasec = obj->caps.btf_datasec;
 	bool has_func = obj->caps.btf_func;
 	struct btf *btf = obj->btf;
 	struct btf_type *t;
 	int i, j, vlen;
 
-	if (!obj->btf || (has_func && has_datasec))
+	if (!obj->btf || (has_func && has_datasec && has_func_global))
 		return;
 
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
@@ -1871,6 +1874,9 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 		} else if (!has_func && btf_is_func(t)) {
 			/* replace FUNC with TYPEDEF */
 			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
+		} else if (!has_func_global && btf_is_func(t)) {
+			/* replace BTF_FUNC_GLOBAL with BTF_FUNC_STATIC */
+			t->info = BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0);
 		}
 	}
 }
@@ -2804,6 +2810,32 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__probe_btf_func_global(struct bpf_object *obj)
+{
+	static const char strs[] = "\0int\0x\0a";
+	/* static void x(int a) {} */
+	__u32 types[] = {
+		/* int */
+		BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
+		/* FUNC_PROTO */                                /* [2] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_FUNC_PROTO, 0, 1), 0),
+		BTF_PARAM_ENC(7, 1),
+		/* FUNC x BTF_FUNC_GLOBAL */                    /* [3] */
+		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, BTF_FUNC_GLOBAL), 2),
+	};
+	int btf_fd;
+
+	btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
+				      strs, sizeof(strs));
+	if (btf_fd >= 0) {
+		obj->caps.btf_func_global = 1;
+		close(btf_fd);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
 {
 	static const char strs[] = "\0x\0.data";
@@ -2859,6 +2891,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_name,
 		bpf_object__probe_global_data,
 		bpf_object__probe_btf_func,
+		bpf_object__probe_btf_func_global,
 		bpf_object__probe_btf_datasec,
 		bpf_object__probe_array_mmap,
 	};
-- 
2.23.0

