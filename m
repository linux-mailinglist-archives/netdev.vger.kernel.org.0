Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4324907E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgHRV7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:59:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbgHRV7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:59:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ILxJWU013458
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:59:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PzN3LXiQPdMDz2gEZ7AqS5OC0pgxjLspHlm6QtfU0fc=;
 b=TIL2Th3AzMFZ1ppWXfDloPOj/5OjOzkbdDtRkV3oIJQZIqCbBl6Qu6XVHpvjBD9qK+Aj
 NqNnQEAOajQWi2NmqZenYAkOs2ozOam20ouxbalVkWsiqvhvygHgoBzQ2sNAmbrCal2w
 AZwfMzlOcGghMZWfjH+A+dAZG4eTVgLbD74= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p7wcsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:59:51 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:59:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 468012EC5EB3; Tue, 18 Aug 2020 14:59:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] libbpf: centralize poisoning and poison reallocarray()
Date:   Tue, 18 Aug 2020 14:59:07 -0700
Message-ID: <20200818215908.2746786-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818215908.2746786-1-andriin@fb.com>
References: <20200818215908.2746786-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008180158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of libbpf source files already include libbpf_internal.h, so it's a =
good
place to centralize identifier poisoning. So move kernel integer type
poisoning there. And also add reallocarray to a poison list to prevent
accidental use of it. libbpf_reallocarray() should be used universally
instead.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c             | 3 ---
 tools/lib/bpf/bpf_prog_linfo.c  | 3 ---
 tools/lib/bpf/btf.c             | 3 ---
 tools/lib/bpf/btf_dump.c        | 3 ---
 tools/lib/bpf/hashmap.c         | 3 +++
 tools/lib/bpf/libbpf.c          | 3 ---
 tools/lib/bpf/libbpf_internal.h | 7 +++++++
 tools/lib/bpf/libbpf_probes.c   | 3 ---
 tools/lib/bpf/netlink.c         | 3 ---
 tools/lib/bpf/nlattr.c          | 9 +++------
 tools/lib/bpf/ringbuf.c         | 3 ---
 tools/lib/bpf/xsk.c             | 3 ---
 12 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 0750681057c2..82b983ff6569 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -32,9 +32,6 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 /*
  * When building perf, unistd.h is overridden. __NR_bpf is
  * required to be defined explicitly.
diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linf=
o.c
index bafca49cb1e6..3ed1a27b5f7c 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -8,9 +8,6 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 struct bpf_prog_linfo {
 	void *raw_linfo;
 	void *raw_jited_linfo;
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d3dc090364c5..87ebc586112d 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -21,9 +21,6 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 #define BTF_MAX_NR_TYPES 0x7fffffffU
 #define BTF_MAX_STR_OFFSET 0x7fffffffU
=20
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 1ad852ad0a86..0eaafd9bcfea 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -19,9 +19,6 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 static const char PREFIXES[] =3D "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT =3D sizeof(PREFIXES) - 1;
=20
diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index a405dad068f5..3c20b126d60d 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -15,6 +15,9 @@
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
=20
+/* prevent accidental re-addition of reallocarray() */
+#pragma GCC poison reallocarray
+
 /* start with 4 buckets */
 #define HASHMAP_MIN_CAP_BITS 2
=20
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a3de369bb2fb..f3f4963d6ba4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -55,9 +55,6 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 #ifndef EM_BPF
 #define EM_BPF 247
 #endif
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 013053c59614..e522b2bb70d8 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -10,6 +10,13 @@
 #define __LIBBPF_LIBBPF_INTERNAL_H
=20
 #include <stdlib.h>
+
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
+/* prevent accidental re-addition of reallocarray() */
+#pragma GCC poison reallocarray
+
 #include "libbpf.h"
=20
 #define BTF_INFO_ENC(kind, kind_flag, vlen) \
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.=
c
index 5a3d3f078408..010c9a76fd2b 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -17,9 +17,6 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 static bool grep(const char *buffer, const char *pattern)
 {
 	return !!strstr(buffer, pattern);
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 2465538a5ba9..4dd73de00b6f 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -15,9 +15,6 @@
 #include "libbpf_internal.h"
 #include "nlattr.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 #ifndef SOL_NETLINK
 #define SOL_NETLINK 270
 #endif
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 0ad41dfea8eb..b607fa9852b1 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -7,14 +7,11 @@
  */
=20
 #include <errno.h>
-#include "nlattr.h"
-#include "libbpf_internal.h"
-#include <linux/rtnetlink.h>
 #include <string.h>
 #include <stdio.h>
-
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+#include <linux/rtnetlink.h>
+#include "nlattr.h"
+#include "libbpf_internal.h"
=20
 static uint16_t nla_attr_minlen[LIBBPF_NLA_TYPE_MAX+1] =3D {
 	[LIBBPF_NLA_U8]		=3D sizeof(uint8_t),
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 5bd234be8a14..5c6522c89af1 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -21,9 +21,6 @@
 #include "libbpf_internal.h"
 #include "bpf.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 struct ring {
 	ring_buffer_sample_fn sample_cb;
 	void *ctx;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index f7f4efb70a4c..a9b02103767b 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -32,9 +32,6 @@
 #include "libbpf_internal.h"
 #include "xsk.h"
=20
-/* make sure libbpf doesn't use kernel-only integer typedefs */
-#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
-
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
--=20
2.24.1

