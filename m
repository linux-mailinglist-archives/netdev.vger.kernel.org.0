Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B13F20EE04
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgF3GHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:07:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgF3GHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:07:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U60N35008984
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:07:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8DxzgmJD8bgapw/YIFW+MrR6rAzU5wpIYoZ/xTtQYS8=;
 b=XdarvPKBc0TmQg697mTvsuX3x/dDPjETjoin94w5MGK0M8394le8LV2FGPON2XbevtEe
 G15g4bJiptPG+8CJH7HHwYtmUdgh+/p1YjbiTPDE4nVwYTGQUCoH8m6TlfBOQluVRMfu
 usOrea6JQZtuVw7+ff+E59MiFe0pkPSXW/E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xpcnra73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:07:46 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 23:07:45 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AD3442EC2E95; Mon, 29 Jun 2020 23:07:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/2] libbpf: make bpf_endian co-exist with vmlinux.h
Date:   Mon, 29 Jun 2020 23:07:38 -0700
Message-ID: <20200630060739.1722733-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200630060739.1722733-1-andriin@fb.com>
References: <20200630060739.1722733-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_01:2020-06-30,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 cotscore=-2147483648 suspectscore=8
 priorityscore=1501 mlxlogscore=839 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpf_endian.h compatible with vmlinux.h. It is a frequent request fro=
m
users wanting to use bpf_endian.h in their BPF applications using CO-RE a=
nd
vmlinux.h.

To achieve that, re-implement byte swap macros and drop all the header
includes. This way it can be used both with linux header includes, as wel=
l as
with a vmlinux.h.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_endian.h | 43 +++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
index fbe28008450f..ec9db4feca9f 100644
--- a/tools/lib/bpf/bpf_endian.h
+++ b/tools/lib/bpf/bpf_endian.h
@@ -2,8 +2,35 @@
 #ifndef __BPF_ENDIAN__
 #define __BPF_ENDIAN__
=20
-#include <linux/stddef.h>
-#include <linux/swab.h>
+/*
+ * Isolate byte #n and put it into byte #m, for __u##b type.
+ * E.g., moving byte #6 (nnnnnnnn) into byte #1 (mmmmmmmm) for __u64:
+ * 1) xxxxxxxx nnnnnnnn xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx mmmmmmmm xxx=
xxxxx
+ * 2) nnnnnnnn xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx mmmmmmmm xxxxxxxx 000=
00000
+ * 3) 00000000 00000000 00000000 00000000 00000000 00000000 00000000 nnn=
nnnnn
+ * 4) 00000000 00000000 00000000 00000000 00000000 00000000 nnnnnnnn 000=
00000
+ */
+#define ___bpf_mvb(x, b, n, m) ((__u##b)(x) << (b-(n+1)*8) >> (b-8) << (=
m*8))
+
+#define ___bpf_swab16(x) ((__u16)(			\
+			  ___bpf_mvb(x, 16, 0, 1) |	\
+			  ___bpf_mvb(x, 16, 1, 0)))
+
+#define ___bpf_swab32(x) ((__u32)(			\
+			  ___bpf_mvb(x, 32, 0, 3) |	\
+			  ___bpf_mvb(x, 32, 1, 2) |	\
+			  ___bpf_mvb(x, 32, 2, 1) |	\
+			  ___bpf_mvb(x, 32, 3, 0)))
+
+#define ___bpf_swab64(x) ((__u64)(			\
+			  ___bpf_mvb(x, 64, 0, 7) |	\
+			  ___bpf_mvb(x, 64, 1, 6) |	\
+			  ___bpf_mvb(x, 64, 2, 5) |	\
+			  ___bpf_mvb(x, 64, 3, 4) |	\
+			  ___bpf_mvb(x, 64, 4, 3) |	\
+			  ___bpf_mvb(x, 64, 5, 2) |	\
+			  ___bpf_mvb(x, 64, 6, 1) |	\
+			  ___bpf_mvb(x, 64, 7, 0)))
=20
 /* LLVM's BPF target selects the endianness of the CPU
  * it compiles on, or the user specifies (bpfel/bpfeb),
@@ -23,16 +50,16 @@
 #if __BYTE_ORDER__ =3D=3D __ORDER_LITTLE_ENDIAN__
 # define __bpf_ntohs(x)			__builtin_bswap16(x)
 # define __bpf_htons(x)			__builtin_bswap16(x)
-# define __bpf_constant_ntohs(x)	___constant_swab16(x)
-# define __bpf_constant_htons(x)	___constant_swab16(x)
+# define __bpf_constant_ntohs(x)	___bpf_swab16(x)
+# define __bpf_constant_htons(x)	___bpf_swab16(x)
 # define __bpf_ntohl(x)			__builtin_bswap32(x)
 # define __bpf_htonl(x)			__builtin_bswap32(x)
-# define __bpf_constant_ntohl(x)	___constant_swab32(x)
-# define __bpf_constant_htonl(x)	___constant_swab32(x)
+# define __bpf_constant_ntohl(x)	___bpf_swab32(x)
+# define __bpf_constant_htonl(x)	___bpf_swab32(x)
 # define __bpf_be64_to_cpu(x)		__builtin_bswap64(x)
 # define __bpf_cpu_to_be64(x)		__builtin_bswap64(x)
-# define __bpf_constant_be64_to_cpu(x)	___constant_swab64(x)
-# define __bpf_constant_cpu_to_be64(x)	___constant_swab64(x)
+# define __bpf_constant_be64_to_cpu(x)	___bpf_swab64(x)
+# define __bpf_constant_cpu_to_be64(x)	___bpf_swab64(x)
 #elif __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
 # define __bpf_ntohs(x)			(x)
 # define __bpf_htons(x)			(x)
--=20
2.24.1

