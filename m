Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665DC24924C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgHSBWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:22:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727830AbgHSBWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:22:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1DKF1007429
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:22:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ns2cizu1IOyjghm8rJICjOU8EAqSGifVMlLXFQrSzrA=;
 b=MfEdcE+FbiylBHW0IFnOVdZ5c9ueUc3oEMNItV9Rv0xnMn9cypy0w9Xdt5gD/2yqOuXa
 6QOqw+4ddMhYGxUzzWzb70nJDPyCQmLLCBsx6RbumuaGaxGDHRjoJ6XE4W8ysGMp2ZDa
 8KixsRXtgUs3OJNH/bQbeY1XY28NwfMqA4Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p7x5kv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:22:16 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:22:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9F2182EC5EF4; Tue, 18 Aug 2020 18:22:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/4] tools: remove feature-libelf-mmap feature detection
Date:   Tue, 18 Aug 2020 18:21:56 -0700
Message-ID: <20200819012156.3525852-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200819012156.3525852-1-andriin@fb.com>
References: <20200819012156.3525852-1-andriin@fb.com>
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
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008190010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's trivial to handle missing ELF_C_MMAP_READ support in libelf the way =
that
objtool has solved it in
("774bec3fddcc objtool: Add fallback from ELF_C_READ_MMAP to ELF_C_READ")=
.

So instead of having an entire feature detector for that, just do what ob=
jtool
does for perf and libbpf. And keep their Makefiles a bit simpler.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/build/Makefile.feature           |  1 -
 tools/build/feature/Makefile           |  4 ----
 tools/build/feature/test-all.c         |  4 ----
 tools/build/feature/test-libelf-mmap.c |  9 ---------
 tools/lib/bpf/Makefile                 |  6 +-----
 tools/lib/bpf/libbpf.c                 | 14 ++++++--------
 tools/perf/Makefile.config             |  4 ----
 tools/perf/util/symbol.h               |  2 +-
 8 files changed, 8 insertions(+), 36 deletions(-)
 delete mode 100644 tools/build/feature/test-libelf-mmap.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index c1daf4d57518..38415d251075 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -46,7 +46,6 @@ FEATURE_TESTS_BASIC :=3D                  \
         libelf-getphdrnum               \
         libelf-gelf_getnote             \
         libelf-getshdrstrndx            \
-        libelf-mmap                     \
         libnuma                         \
         numa_num_possible_cpus          \
         libperl                         \
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index d220fe952747..b2a2347c67ed 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -25,7 +25,6 @@ FILES=3D                                          \
          test-libelf-getphdrnum.bin             \
          test-libelf-gelf_getnote.bin           \
          test-libelf-getshdrstrndx.bin          \
-         test-libelf-mmap.bin                   \
          test-libdebuginfod.bin                 \
          test-libnuma.bin                       \
          test-numa_num_possible_cpus.bin        \
@@ -146,9 +145,6 @@ $(OUTPUT)test-dwarf.bin:
 $(OUTPUT)test-dwarf_getlocations.bin:
 	$(BUILD) $(DWARFLIBS)
=20
-$(OUTPUT)test-libelf-mmap.bin:
-	$(BUILD) -lelf
-
 $(OUTPUT)test-libelf-getphdrnum.bin:
 	$(BUILD) -lelf
=20
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-al=
l.c
index 5479e543b194..5284e6e9c756 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -30,10 +30,6 @@
 # include "test-libelf.c"
 #undef main
=20
-#define main main_test_libelf_mmap
-# include "test-libelf-mmap.c"
-#undef main
-
 #define main main_test_get_current_dir_name
 # include "test-get_current_dir_name.c"
 #undef main
diff --git a/tools/build/feature/test-libelf-mmap.c b/tools/build/feature=
/test-libelf-mmap.c
deleted file mode 100644
index 2c3ef81affe2..000000000000
--- a/tools/build/feature/test-libelf-mmap.c
+++ /dev/null
@@ -1,9 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libelf.h>
-
-int main(void)
-{
-	Elf *elf =3D elf_begin(0, ELF_C_READ_MMAP, 0);
-
-	return (long)elf;
-}
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 621ad96d06fd..c5dbfafdf889 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -56,7 +56,7 @@ ifndef VERBOSE
 endif
=20
 FEATURE_USER =3D .libbpf
-FEATURE_TESTS =3D libelf libelf-mmap zlib bpf
+FEATURE_TESTS =3D libelf zlib bpf
 FEATURE_DISPLAY =3D libelf zlib bpf
=20
 INCLUDES =3D -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(AR=
CH)/include/uapi -I$(srctree)/tools/include/uapi
@@ -98,10 +98,6 @@ else
   CFLAGS :=3D -g -Wall
 endif
=20
-ifeq ($(feature-libelf-mmap), 1)
-  override CFLAGS +=3D -DHAVE_LIBELF_MMAP_SUPPORT
-endif
-
 # Append required CFLAGS
 override CFLAGS +=3D $(EXTRA_WARNINGS) -Wno-switch-enum
 override CFLAGS +=3D -Werror -Wall
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8288ffb5f972..f4701eb3a9e6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -150,12 +150,6 @@ static void pr_perm_msg(int err)
 	___err; })
 #endif
=20
-#ifdef HAVE_LIBELF_MMAP_SUPPORT
-# define LIBBPF_ELF_C_READ_MMAP ELF_C_READ_MMAP
-#else
-# define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
-#endif
-
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -1064,6 +1058,11 @@ static void bpf_object__elf_finish(struct bpf_obje=
ct *obj)
 	obj->efile.obj_buf_sz =3D 0;
 }
=20
+/* if libelf is old and doesn't support mmap(), fall back to read() */
+#ifndef ELF_C_READ_MMAP
+#define ELF_C_READ_MMAP ELF_C_READ
+#endif
+
 static int bpf_object__elf_init(struct bpf_object *obj)
 {
 	int err =3D 0;
@@ -1092,8 +1091,7 @@ static int bpf_object__elf_init(struct bpf_object *=
obj)
 			return err;
 		}
=20
-		obj->efile.elf =3D elf_begin(obj->efile.fd,
-					   LIBBPF_ELF_C_READ_MMAP, NULL);
+		obj->efile.elf =3D elf_begin(obj->efile.fd, ELF_C_READ_MMAP, NULL);
 	}
=20
 	if (!obj->efile.elf) {
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 190be4fa5c21..81bb099f6f06 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -483,10 +483,6 @@ ifndef NO_LIBELF
   EXTLIBS +=3D -lelf
   $(call detected,CONFIG_LIBELF)
=20
-  ifeq ($(feature-libelf-mmap), 1)
-    CFLAGS +=3D -DHAVE_LIBELF_MMAP_SUPPORT
-  endif
-
   ifeq ($(feature-libelf-getphdrnum), 1)
     CFLAGS +=3D -DHAVE_ELF_GETPHDRNUM_SUPPORT
   endif
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ff4f4c47e148..03e264a27cd3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -28,7 +28,7 @@ struct option;
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef HAVE_LIBELF_MMAP_SUPPORT
+#ifdef ELF_C_READ_MMAP
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
 #else
 # define PERF_ELF_C_READ_MMAP ELF_C_READ
--=20
2.24.1

