Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C281375F3
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgAJSTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:19:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbgAJSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:19:30 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AIAP3v018506
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:19:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=FNaAQjUrfcPszeDXTnf2J0FJpty/Rq0SaU+zTFujQiU=;
 b=KIz2jMvAi8vl7OpKXkVLrBFu7RQ6D91TqczjrYupKdhL5JJM5uMsxmbPZYyA4QpQf6lI
 yXsYLmvZYfYmKWO16bCJ44vOQRo6843CrLr0iEwF6oDrp7tUHzn5CwKc9FkPnIMOP5fn
 DUZANDTgTzvz/dRyNelZ0e9wYUgfYxQk9ws= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xehgum7fk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:19:29 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 10:19:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0C2512EC15C2; Fri, 10 Jan 2020 10:19:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: poison kernel-only integer types
Date:   Fri, 10 Jan 2020 10:19:16 -0800
Message-ID: <20200110181916.271446-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=8 bulkscore=0 malwarescore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's been a recurring issue with types like u32 slipping into libbpf source
code accidentally. This is not detected during builds inside kernel source
tree, but becomes a compilation error in libbpf's Github repo. Libbpf is
supposed to use only __{s,u}{8,16,32,64} typedefs, so poison {s,u}{8,16,32,64}
explicitly in every .c file. Doing that in a bit more centralized way, e.g.,
inside libbpf_internal.h breaks selftests, which are both using kernel u32 and
libbpf_internal.h.

This patch also fixes a new u32 occurence in libbpf.c, added recently.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c            | 3 +++
 tools/lib/bpf/bpf_prog_linfo.c | 3 +++
 tools/lib/bpf/btf.c            | 3 +++
 tools/lib/bpf/btf_dump.c       | 3 +++
 tools/lib/bpf/hashmap.c        | 3 +++
 tools/lib/bpf/libbpf.c         | 5 ++++-
 tools/lib/bpf/libbpf_errno.c   | 3 +++
 tools/lib/bpf/libbpf_probes.c  | 3 +++
 tools/lib/bpf/netlink.c        | 3 +++
 tools/lib/bpf/nlattr.c         | 3 +++
 tools/lib/bpf/str_error.c      | 3 +++
 tools/lib/bpf/xsk.c            | 3 +++
 12 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index b0ecbe9ef2d4..500afe478e94 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -32,6 +32,9 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 /*
  * When building perf, unistd.h is overridden. __NR_bpf is
  * required to be defined explicitly.
diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 3ed1a27b5f7c..bafca49cb1e6 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -8,6 +8,9 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 struct bpf_prog_linfo {
 	void *raw_linfo;
 	void *raw_jited_linfo;
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 5f04f56e1eb6..cfeb6a44480b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -17,6 +17,9 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #define BTF_MAX_NR_TYPES 0x7fffffff
 #define BTF_MAX_STR_OFFSET 0x7fffffff
 
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index e95f7710f210..885acebd4396 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -18,6 +18,9 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
 
diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 6122272943e6..54c30c802070 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -12,6 +12,9 @@
 #include <linux/err.h>
 #include "hashmap.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 /* start with 4 buckets */
 #define HASHMAP_MIN_CAP_BITS 2
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3afd780b0f06..0c229f00a67e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -55,6 +55,9 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #ifndef EM_BPF
 #define EM_BPF 247
 #endif
@@ -6475,7 +6478,7 @@ static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
 	Elf_Data *symbols;
 	unsigned int moff;
 	const char *name;
-	u32 member_idx;
+	__u32 member_idx;
 	GElf_Sym sym;
 	GElf_Rel rel;
 	int i, nrels;
diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.c
index 4343e40588c6..0afb51f7a919 100644
--- a/tools/lib/bpf/libbpf_errno.c
+++ b/tools/lib/bpf/libbpf_errno.c
@@ -13,6 +13,9 @@
 
 #include "libbpf.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #define ERRNO_OFFSET(e)		((e) - __LIBBPF_ERRNO__START)
 #define ERRCODE_OFFSET(c)	ERRNO_OFFSET(LIBBPF_ERRNO__##c)
 #define NR_ERRNO	(__LIBBPF_ERRNO__END - __LIBBPF_ERRNO__START)
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 320697f8e4c7..8cc992bc532a 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -17,6 +17,9 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 static bool grep(const char *buffer, const char *pattern)
 {
 	return !!strstr(buffer, pattern);
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 5065c1aa1061..431bd25c6cdb 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -15,6 +15,9 @@
 #include "libbpf_internal.h"
 #include "nlattr.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #ifndef SOL_NETLINK
 #define SOL_NETLINK 270
 #endif
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 8db44bbfc66d..0ad41dfea8eb 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -13,6 +13,9 @@
 #include <string.h>
 #include <stdio.h>
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 static uint16_t nla_attr_minlen[LIBBPF_NLA_TYPE_MAX+1] = {
 	[LIBBPF_NLA_U8]		= sizeof(uint8_t),
 	[LIBBPF_NLA_U16]	= sizeof(uint16_t),
diff --git a/tools/lib/bpf/str_error.c b/tools/lib/bpf/str_error.c
index b8064eedc177..146da01979c7 100644
--- a/tools/lib/bpf/str_error.c
+++ b/tools/lib/bpf/str_error.c
@@ -4,6 +4,9 @@
 #include <stdio.h>
 #include "str_error.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 /*
  * Wrapper to allow for building in non-GNU systems such as Alpine Linux's musl
  * libc, while checking strerror_r() return to avoid having to check this in
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8e0ffa800a71..9807903f121e 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -32,6 +32,9 @@
 #include "libbpf_internal.h"
 #include "xsk.h"
 
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
-- 
2.17.1

