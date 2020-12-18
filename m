Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFF2DEC29
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLRX5D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 18:57:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLRX5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:57:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BINuMhb015378
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:22 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35gwa8b1ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:22 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 15:56:21 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A6EB52ECB8FE; Fri, 18 Dec 2020 15:56:18 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>
Subject: [PATCH bpf-next 1/3] libbpf: add user-space variants of BPF_CORE_READ() family of macros
Date:   Fri, 18 Dec 2020 15:56:12 -0800
Message-ID: <20201218235614.2284956-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218235614.2284956-1-andrii@kernel.org>
References: <20201218235614.2284956-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1034 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_CORE_READ_USER(), BPF_CORE_READ_USER_STR() and their _INTO()
variations to allow reading CO-RE-relocatable kernel data structures from the
user-space. One of such cases is reading input arguments of syscalls, while
reaping the benefits of CO-RE relocations w.r.t. handling 32/64 bit
conversions and handling missing/new fields in UAPI data structs.

Suggested-by: Gilad Reti <gilad.reti@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 98 +++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 39 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index bbcefb3ff5a5..db0c735ceb53 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -195,17 +195,20 @@ enum bpf_enum_value_kind {
  * (local) BTF, used to record relocation.
  */
 #define bpf_core_read(dst, sz, src)					    \
-	bpf_probe_read_kernel(dst, sz,					    \
-			      (const void *)__builtin_preserve_access_index(src))
+	bpf_probe_read_kernel(dst, sz, (const void *)__builtin_preserve_access_index(src))
 
+#define bpf_core_read_user(dst, sz, src)				    \
+	bpf_probe_read_user(dst, sz, (const void *)__builtin_preserve_access_index(src))
 /*
  * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
  * additionally emitting BPF CO-RE field relocation for specified source
  * argument.
  */
 #define bpf_core_read_str(dst, sz, src)					    \
-	bpf_probe_read_kernel_str(dst, sz,				    \
-				  (const void *)__builtin_preserve_access_index(src))
+	bpf_probe_read_kernel_str(dst, sz, (const void *)__builtin_preserve_access_index(src))
+
+#define bpf_core_read_user_str(dst, sz, src)				    \
+	bpf_probe_read_user_str(dst, sz, (const void *)__builtin_preserve_access_index(src))
 
 #define ___concat(a, b) a ## b
 #define ___apply(fn, n) ___concat(fn, n)
@@ -264,30 +267,29 @@ enum bpf_enum_value_kind {
 	read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
 
 /* "recursively" read a sequence of inner pointers using local __t var */
-#define ___rd_first(src, a) ___read(bpf_core_read, &__t, ___type(src), src, a);
-#define ___rd_last(...)							    \
-	___read(bpf_core_read, &__t,					    \
-		___type(___nolast(__VA_ARGS__)), __t, ___last(__VA_ARGS__));
-#define ___rd_p1(...) const void *__t; ___rd_first(__VA_ARGS__)
-#define ___rd_p2(...) ___rd_p1(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p3(...) ___rd_p2(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p4(...) ___rd_p3(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p5(...) ___rd_p4(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p6(...) ___rd_p5(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p7(...) ___rd_p6(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p8(...) ___rd_p7(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___rd_p9(...) ___rd_p8(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-#define ___read_ptrs(src, ...)						    \
-	___apply(___rd_p, ___narg(__VA_ARGS__))(src, __VA_ARGS__)
-
-#define ___core_read0(fn, dst, src, a)					    \
+#define ___rd_first(fn, src, a) ___read(fn, &__t, ___type(src), src, a);
+#define ___rd_last(fn, ...)						    \
+	___read(fn, &__t, ___type(___nolast(__VA_ARGS__)), __t, ___last(__VA_ARGS__));
+#define ___rd_p1(fn, ...) const void *__t; ___rd_first(fn, __VA_ARGS__)
+#define ___rd_p2(fn, ...) ___rd_p1(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p3(fn, ...) ___rd_p2(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p4(fn, ...) ___rd_p3(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p5(fn, ...) ___rd_p4(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p6(fn, ...) ___rd_p5(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p7(fn, ...) ___rd_p6(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p8(fn, ...) ___rd_p7(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___rd_p9(fn, ...) ___rd_p8(fn, ___nolast(__VA_ARGS__)) ___rd_last(fn, __VA_ARGS__)
+#define ___read_ptrs(fn, src, ...)					    \
+	___apply(___rd_p, ___narg(__VA_ARGS__))(fn, src, __VA_ARGS__)
+
+#define ___core_read0(fn, fn_ptr, dst, src, a)				    \
 	___read(fn, dst, ___type(src), src, a);
-#define ___core_readN(fn, dst, src, ...)				    \
-	___read_ptrs(src, ___nolast(__VA_ARGS__))			    \
+#define ___core_readN(fn, fn_ptr, dst, src, ...)			    \
+	___read_ptrs(fn_ptr, src, ___nolast(__VA_ARGS__))		    \
 	___read(fn, dst, ___type(src, ___nolast(__VA_ARGS__)), __t,	    \
 		___last(__VA_ARGS__));
-#define ___core_read(fn, dst, src, a, ...)				    \
-	___apply(___core_read, ___empty(__VA_ARGS__))(fn, dst,		    \
+#define ___core_read(fn, fn_ptr, dst, src, a, ...)			    \
+	___apply(___core_read, ___empty(__VA_ARGS__))(fn, fn_ptr, dst,	    \
 						      src, a, ##__VA_ARGS__)
 
 /*
@@ -295,20 +297,32 @@ enum bpf_enum_value_kind {
  * BPF_CORE_READ(), in which final field is read into user-provided storage.
  * See BPF_CORE_READ() below for more details on general usage.
  */
-#define BPF_CORE_READ_INTO(dst, src, a, ...)				    \
-	({								    \
-		___core_read(bpf_core_read, dst, (src), a, ##__VA_ARGS__)   \
-	})
+#define BPF_CORE_READ_INTO(dst, src, a, ...) ({				    \
+	___core_read(bpf_core_read, bpf_core_read,			    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
+/* Variant of BPF_CORE_READ_INTO() for reading from user-space memory */
+#define BPF_CORE_READ_USER_INTO(dst, src, a, ...) ({			    \
+	___core_read(bpf_core_read_user, bpf_core_read_user,		    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
 
 /*
  * BPF_CORE_READ_STR_INTO() does same "pointer chasing" as
  * BPF_CORE_READ() for intermediate pointers, but then executes (and returns
  * corresponding error code) bpf_core_read_str() for final string read.
  */
-#define BPF_CORE_READ_STR_INTO(dst, src, a, ...)			    \
-	({								    \
-		___core_read(bpf_core_read_str, dst, (src), a, ##__VA_ARGS__)\
-	})
+#define BPF_CORE_READ_STR_INTO(dst, src, a, ...) ({			    \
+	___core_read(bpf_core_read_str, bpf_core_read,			    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
+/* Variant of BPF_CORE_READ_STR_INTO() for reading from user-space memory */
+#define BPF_CORE_READ_USER_STR_INTO(dst, src, a, ...) ({		    \
+	___core_read(bpf_core_read_user_str, bpf_core_read_user,	    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
 
 /*
  * BPF_CORE_READ() is used to simplify BPF CO-RE relocatable read, especially
@@ -334,12 +348,18 @@ enum bpf_enum_value_kind {
  * N.B. Only up to 9 "field accessors" are supported, which should be more
  * than enough for any practical purpose.
  */
-#define BPF_CORE_READ(src, a, ...)					    \
-	({								    \
-		___type((src), a, ##__VA_ARGS__) __r;			    \
-		BPF_CORE_READ_INTO(&__r, (src), a, ##__VA_ARGS__);	    \
-		__r;							    \
-	})
+#define BPF_CORE_READ(src, a, ...) ({					    \
+	___type((src), a, ##__VA_ARGS__) __r;				    \
+	BPF_CORE_READ_INTO(&__r, (src), a, ##__VA_ARGS__);		    \
+	__r;								    \
+})
+
+/* Variant of BPF_CORE_READ() for reading from user-space memory */
+#define BPF_CORE_READ_USER(src, a, ...) ({				    \
+	___type((src), a, ##__VA_ARGS__) __r;				    \
+	BPF_CORE_READ_USER_INTO(&__r, (src), a, ##__VA_ARGS__);		    \
+	__r;								    \
+})
 
 #endif
 
-- 
2.24.1

