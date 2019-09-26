Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B58BFB9E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 01:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbfIZXCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 19:02:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbfIZXCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 19:02:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8QMs5ih029253
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 16:02:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=bYw3lyB1mldE+JJKpmjaVaKwzoTKIJgZbzyWoKd+PXo=;
 b=Hymelu4It4KEZpxqu1sCfCD9tvHrAfFi9oDQeS6EuRfOjNhNY6+5223PGH18pMXm2jJZ
 vNttNTiMX5K35UF4uhPEH3VPwehpb+VaCCN6SZs3+niDOPsEXhz+mGbfmEbWBabISHcB
 9+5A4kjAn9WxiL/eNW25YAZjDWK0qBkRhFw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v8u2euepe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 16:02:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 26 Sep 2019 16:02:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0A7483702B16; Thu, 26 Sep 2019 16:02:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: add macro __BUILD_STATIC_LIBBPF__ to guard .symver
Date:   Thu, 26 Sep 2019 16:02:04 -0700
Message-ID: <20190926230204.1911391-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-26_08:2019-09-25,2019-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909260181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcc uses libbpf repo as a submodule. It brings in libbpf source
code and builds everything together to produce shared libraries.
With latest libbpf, I got the following errors:
  /bin/ld: libbcc_bpf.so.0.10.0: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
  /bin/ld: failed to set dynamic section sizes: Bad value
  collect2: error: ld returned 1 exit status
  make[2]: *** [src/cc/libbcc_bpf.so.0.10.0] Error 1

In xsk.c, we have
  asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
  asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
The linker thinks the built is for LIBBPF but cannot find proper version
LIBBPF_0.0.2/4, so emit errors.

I also confirmed that using libbpf.a to produce a shared library also
has issues:
  -bash-4.4$ cat t.c
  extern void *xsk_umem__create;
  void * test() { return xsk_umem__create; }
  -bash-4.4$ gcc -c t.c
  -bash-4.4$ gcc -shared t.o libbpf.a -o t.so
  /bin/ld: t.so: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
  /bin/ld: failed to set dynamic section sizes: Bad value
  collect2: error: ld returned 1 exit status
  -bash-4.4$

To fix the problem, I simply added a macro __BUILD_STATIC_LIBBPF__
which will prevent issuing .symver assembly codes when enabled.
The .symver assembly codes are still issued by default.
This will at least give other libbpf users to build libbpf
without these versioned symbols.

I did not touch Makefile to actually use this macro to build
static library as I want to check whether this is desirable or not.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/xsk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 24fa313524fb..76c12c4c5c70 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -261,8 +261,11 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 	return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
 					&config);
 }
+
+#ifndef __BUILD_STATIC_LIBBPF__
 asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
 asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
+#endif
 
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
-- 
2.17.1

