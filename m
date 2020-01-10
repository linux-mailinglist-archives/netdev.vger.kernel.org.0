Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233FB136791
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgAJGla convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 01:41:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731533AbgAJGla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:41:30 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A6dtmc013452
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 22:41:28 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xec3hj6x3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:41:28 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 9 Jan 2020 22:41:26 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 39A79760DBA; Thu,  9 Jan 2020 22:41:26 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/6] libbpf: Sanitize global functions
Date:   Thu, 9 Jan 2020 22:41:19 -0800
Message-ID: <20200110064124.1760511-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110064124.1760511-1-ast@kernel.org>
References: <20200110064124.1760511-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=1 mlxscore=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=870 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100055
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
index ee2620b2aa55..3afd780b0f06 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -173,6 +173,8 @@ struct bpf_capabilities {
 	__u32 btf_datasec:1;
 	/* BPF_F_MMAPABLE is supported for arrays */
 	__u32 array_mmap:1;
+	/* BTF_FUNC_GLOBAL is supported */
+	__u32 btf_func_global:1;
 };
 
 enum reloc_type {
@@ -2209,13 +2211,14 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
 
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
@@ -2263,6 +2266,9 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 		} else if (!has_func && btf_is_func(t)) {
 			/* replace FUNC with TYPEDEF */
 			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
+		} else if (!has_func_global && btf_is_func(t)) {
+			/* replace BTF_FUNC_GLOBAL with BTF_FUNC_STATIC */
+			t->info = BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0);
 		}
 	}
 }
@@ -3205,6 +3211,32 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
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
@@ -3260,6 +3292,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_name,
 		bpf_object__probe_global_data,
 		bpf_object__probe_btf_func,
+		bpf_object__probe_btf_func_global,
 		bpf_object__probe_btf_datasec,
 		bpf_object__probe_array_mmap,
 	};
-- 
2.23.0

