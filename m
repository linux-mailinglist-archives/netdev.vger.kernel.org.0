Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2721A854A8
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbfHGUtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:49:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389513AbfHGUtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:49:03 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77KkCmH007866
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 13:49:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=itJDGWsVbe9cruu2zBofgc7p1RuKV0nf2ROBkbmO5j0=;
 b=dHoEu5/mV03QISTtBBkAse/Uocgv8yTocQKTVN+7FPy7fBACFyahW8ug/8hmijke3aVe
 ++5XSOKfsIjWRIfEJ/PnUC6xqdcM/yKTdLxSON/dDaZj/tflFUtupkVE9CVZbnINFszy
 SF3y1yJwGye2IuUT7/Rv3z3Yx5YgqLk8q5U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7y8b9rgs-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:49:02 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 13:48:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2A19686167B; Wed,  7 Aug 2019 13:48:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 05/14] selftests/bpf: add BPF_CORE_READ relocatable read macro
Date:   Wed, 7 Aug 2019 13:48:34 -0700
Message-ID: <20190807204843.513594-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807204843.513594-1-andriin@fb.com>
References: <20190807204843.513594-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_CORE_READ macro used in tests to do bpf_core_read(), which
automatically captures offset relocation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 120aa86c58d3..8b503ea142f0 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -504,4 +504,24 @@ struct pt_regs;
 				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
 #endif
 
+/*
+ * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
+ * relocation for source address using __builtin_preserve_access_index()
+ * built-in, provided by Clang.
+ *
+ * __builtin_preserve_access_index() takes as an argument an expression of
+ * taking an address of a field within struct/union. It makes compiler emit
+ * a relocation, which records BTF type ID describing root struct/union and an
+ * accessor string which describes exact embedded field that was used to take
+ * an address. See detailed description of this relocation format and
+ * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h.
+ *
+ * This relocation allows libbpf to adjust BPF instruction to use correct
+ * actual field offset, based on target kernel BTF type that matches original
+ * (local) BTF, used to record relocation.
+ */
+#define BPF_CORE_READ(dst, src)						\
+	bpf_probe_read((dst), sizeof(*(src)),				\
+		       __builtin_preserve_access_index(src))
+
 #endif
-- 
2.17.1

