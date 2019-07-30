Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248457B39F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfG3Tyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:54:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32866 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726764AbfG3Tyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:54:44 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UJseEQ011498
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=CW0jEKNgj2WzOoC0hw5dTAe+von8rP307/kyEJAMaIo=;
 b=Rfzs7e1ChjkZKpFlU+4WJtbyw1y3Oqk8PJ5G//hkVXBIwDpfwyyIs0TLJGLqa6YdJjIW
 lB7xdZThvC4/gm3gEpwhEg79K6Xg0XHLCd24SXiIeef7ZfqgKEPnFfAF7Xmf+lwzDXu9
 4mp+Jb4vfrWt+hvhAJOqF2yyEqkAImy1LY8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2pwm1dan-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:43 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 12:54:18 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 80804861655; Tue, 30 Jul 2019 12:54:17 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ relocatable read macro
Date:   Tue, 30 Jul 2019 12:53:59 -0700
Message-ID: <20190730195408.670063-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730195408.670063-1-andriin@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_CORE_READ macro used in tests to do bpf_core_read(), which
automatically captures offset relocation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index f804f210244e..81bc51293d11 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -501,4 +501,23 @@ struct pt_regs;
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
+#define BPF_CORE_READ(dst, src) \
+	bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))
+
 #endif
-- 
2.17.1

