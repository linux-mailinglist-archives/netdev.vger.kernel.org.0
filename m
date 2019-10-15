Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B29D7F05
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389148AbfJOS3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:29:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37570 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389127AbfJOS3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:29:06 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FIPisE001845
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:29:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Bnf40a2WeQgCDhgDUAmQhlGdfdB7lGzwRCntGITwz4E=;
 b=AfSw9euATMkc7Sf+Vz9mkGJLJgG+8hqHJ/jl6OcrkLpgkMLVxy6xAviiTjlYJFPLanmd
 aEt9FgiV/fJ82Uvn3NKOwNYZN2nbs+ffiwC7XZMY0h4q9x+s3ahCbyM/uznnet+Mt9ft
 7rI8xbR8dbMD5uTeos7lucQgqrLZwlaZ40c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxgeu9hc-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:29:05 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 11:29:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 81729861983; Tue, 15 Oct 2019 11:28:58 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 4/5] libbpf: add BPF-side definitions of supported field relocation kinds
Date:   Tue, 15 Oct 2019 11:28:48 -0700
Message-ID: <20191015182849.3922287-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015182849.3922287-1-andriin@fb.com>
References: <20191015182849.3922287-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum definition for Clang's __builtin_preserve_field_info()
second argument (info_kind). Currently only byte offset and existence
are supported. Corresponding Clang changes introducing this built-in can
be found at [0]

  [0] https://reviews.llvm.org/D67980

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 4daf04c25493..a273df3784f4 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -2,6 +2,28 @@
 #ifndef __BPF_CORE_READ_H__
 #define __BPF_CORE_READ_H__
 
+/*
+ * enum bpf_field_info_kind is passed as a second argument into
+ * __builtin_preserve_field_info() built-in to get a specific aspect of
+ * a field, captured as a first argument. __builtin_preserve_field_info(field,
+ * info_kind) returns __u32 integer and produces BTF field relocation, which
+ * is understood and processed by libbpf during BPF object loading. See
+ * selftests/bpf for examples.
+ */
+enum bpf_field_info_kind {
+	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+};
+
+/*
+ * Convenience macro to check that field actually exists in target kernel's.
+ * Returns:
+ *    1, if matching field is present in target kernel;
+ *    0, if no matching field found.
+ */
+#define bpf_core_field_exists(field)					    \
+	__builtin_preserve_field_info(field, BPF_FIELD_EXISTS)
+
 /*
  * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
  * relocation for source address using __builtin_preserve_access_index()
@@ -12,7 +34,7 @@
  * a relocation, which records BTF type ID describing root struct/union and an
  * accessor string which describes exact embedded field that was used to take
  * an address. See detailed description of this relocation format and
- * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h.
+ * semantics in comments to struct bpf_field_reloc in libbpf_internal.h.
  *
  * This relocation allows libbpf to adjust BPF instruction to use correct
  * actual field offset, based on target kernel BTF type that matches original
-- 
2.17.1

