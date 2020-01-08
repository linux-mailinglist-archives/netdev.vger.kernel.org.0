Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0104B133C39
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgAHH0A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 02:26:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64466 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726788AbgAHHZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:25:53 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0087Nsp5012573
        for <netdev@vger.kernel.org>; Tue, 7 Jan 2020 23:25:52 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd5auscdy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 23:25:52 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jan 2020 23:25:51 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id AA1B5760DB5; Tue,  7 Jan 2020 23:25:40 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Date:   Tue, 7 Jan 2020 23:25:33 -0800
Message-ID: <20200108072538.3359838-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200108072538.3359838-1-ast@kernel.org>
References: <20200108072538.3359838-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_01:2020-01-07,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=938
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=1
 bulkscore=0 mlxscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case kernel doesn't support static/global/extern liknage of BTF_KIND_FUNC
sanitize BTF produced by llvm.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
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
index 7513165b104f..f72b3ed6c34b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -166,6 +166,8 @@ struct bpf_capabilities {
 	__u32 btf_datasec:1;
 	/* BPF_F_MMAPABLE is supported for arrays */
 	__u32 array_mmap:1;
+	/* static/global/extern is supported for BTF_KIND_FUNC */
+	__u32 btf_func_linkage:1;
 };
 
 enum reloc_type {
@@ -1817,13 +1819,14 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
 
 static void bpf_object__sanitize_btf(struct bpf_object *obj)
 {
+	bool has_func_linkage = obj->caps.btf_func_linkage;
 	bool has_datasec = obj->caps.btf_datasec;
 	bool has_func = obj->caps.btf_func;
 	struct btf *btf = obj->btf;
 	struct btf_type *t;
 	int i, j, vlen;
 
-	if (!obj->btf || (has_func && has_datasec))
+	if (!obj->btf || (has_func && has_datasec && has_func_linkage))
 		return;
 
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
@@ -1871,6 +1874,9 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 		} else if (!has_func && btf_is_func(t)) {
 			/* replace FUNC with TYPEDEF */
 			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
+		} else if (!has_func_linkage && btf_is_func(t)) {
+			/* replace BTF_FUNC_GLOBAL with BTF_FUNC_STATIC */
+			t->info = BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0);
 		}
 	}
 }
@@ -2804,6 +2810,32 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__probe_btf_func_linkage(struct bpf_object *obj)
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
+		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 1), 2),
+	};
+	int btf_fd;
+
+	btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
+				      strs, sizeof(strs));
+	if (btf_fd >= 0) {
+		obj->caps.btf_func_linkage = 1;
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
+		bpf_object__probe_btf_func_linkage,
 		bpf_object__probe_btf_datasec,
 		bpf_object__probe_array_mmap,
 	};
-- 
2.23.0

