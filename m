Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38761BD1A3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD2BV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgD2BV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:27 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T1CBQS024838
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TQm9sfr0QqP19BhTi5hPo9qErEKDPKF43rRjVqH3TYA=;
 b=e63zK44KfygVscO1Yx3qPpOlI0oJtJeQjQ7cSFWWAnrmlEEhHdxJbdyXRCPqFCbVsFL5
 0QpqKe7AmkgDKrKpDfW4C2I4qK2GmDoUIEklCMR5RMkag+YzUbiI2HfCeriBJEoW+LYC
 /zo29KkXgHsT+5v6i5DXWNFVPglGtFG5UCA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvnqqjp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:26 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 22BC72EC30E4; Tue, 28 Apr 2020 18:21:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 02/11] selftests/bpf: add SAN_CFLAGS param to selftests build to allow sanitizers
Date:   Tue, 28 Apr 2020 18:21:02 -0700
Message-ID: <20200429012111.277390-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=8 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to specify extra compiler flags with SAN_CFLAGS for compilati=
on of
all user-space C files.  This allows to build all of selftest programs wi=
th,
e.g., custom sanitizer flags, without requiring support for such sanitize=
rs
from anyone compiling selftest/bpf.

As an example, to compile everything with AddressSanitizer, one would do:

  $ make clean && make SAN_CFLAGS=3D"-fsanitize=3Daddress"

For AddressSanitizer to work, one needs appropriate libasan shared librar=
y
installed in the system, with version of libasan matching what GCC links
against. E.g., GCC8 needs libasan5, while GCC7 uses libasan4.

For CentOS 7, to build everything successfully one would need to:
  $ sudo yum install devtoolset-8-gcc devtoolset-libasan-devel
  $ scl enable devtoolset-8 bash # set up environment

For Arch Linux to run selftests, one would need to install gcc-libs packa=
ge to
get libasan.so.5:
  $ sudo pacman -S gcc-libs

N.B. EXTRA_CFLAGS name wasn't used, because it's also used by libbpf's
Makefile and this causes few issues:
1. default "-g -Wall" flags are overriden;
2. compiling shared library with AddressSanitizer generates a bunch of sy=
mbols
   like: "_GLOBAL__sub_D_00099_0_btf_dump.c", "_GLOBAL__sub_D_00099_0_bpf=
.c",
   etc, which screws up versioned symbols check.

Cc: Julia Kartseva <hex@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 01c95f8278c7..887f06a514ee 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -20,9 +20,10 @@ CLANG		?=3D clang
 LLC		?=3D llc
 LLVM_OBJCOPY	?=3D llvm-objcopy
 BPF_GCC		?=3D $(shell command -v bpf-gcc;)
-CFLAGS +=3D -g -rdynamic -Wall -O2 $(GENFLAGS) -I$(CURDIR)		\
-	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)	\
-	  -I$(APIDIR)							\
+SAN_CFLAGS	?=3D
+CFLAGS +=3D -g -rdynamic -Wall -O2 $(GENFLAGS) $(SAN_CFLAGS)		\
+	  -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)		\
+	  -I$(TOOLSINCDIR) -I$(APIDIR)					\
 	  -Dbpf_prog_load=3Dbpf_prog_test_load				\
 	  -Dbpf_load_program=3Dbpf_test_load_program
 LDLIBS +=3D -lcap -lelf -lz -lrt -lpthread
--=20
2.24.1

