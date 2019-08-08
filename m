Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C650B85745
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbfHHAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:39:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389488AbfHHAjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:39:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x780RX5R032447
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 17:39:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=y4suneNXnOUhAS+0Se9kjnvNT70cdMWBPHZlzyGENtM=;
 b=ftZWvua4GDUT2BXkLMh0SeGRe0L8A2OBU0kQwPmqil5J9AGJ8mzYNzCp4Y485DneN+A4
 NdyO+OL+RT83Zvs9LzxgoCgwYkS8QIgo5n+G1MtfCmuzkuS57g0KNY1sff/7EdvRwb1s
 mw2cWaCEbGOT0oTjGniXAd5utg2M0WtQo84= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u87u1g95s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 17:39:01 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 7 Aug 2019 17:38:59 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C3C67370280D; Wed,  7 Aug 2019 17:38:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/bpf: fix core_reloc.c compilation error
Date:   Wed, 7 Aug 2019 17:38:56 -0700
Message-ID: <20190808003856.555097-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=990 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my local machine, I have the following compilation errors:
=3D=3D=3D=3D=3D
  In file included from prog_tests/core_reloc.c:3:0:
  ./progs/core_reloc_types.h:517:46: error: expected =E2=80=98=3D=E2=80=99=
, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=
=98__attribute__=E2=80=99 before =E2=80=98fancy_char_ptr_t=E2=80=99
 typedef const char * const volatile restrict fancy_char_ptr_t;
                                              ^
  ./progs/core_reloc_types.h:527:2: error: unknown type name =E2=80=98fan=
cy_char_ptr_t=E2=80=99
    fancy_char_ptr_t d;
    ^
=3D=3D=3D=3D=3D

I am using gcc 4.8.5. Later compilers may change their behavior not emitt=
ing the
error. Nevertheless, let us fix the issue. "restrict" can be tested
without typedef.

Fixes: 9654e2ae908e ("selftests/bpf: add CO-RE relocs modifiers/typedef t=
ests")
Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/progs/core_reloc_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools=
/testing/selftests/bpf/progs/core_reloc_types.h
index 10a252b6da55..f686a8138d90 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -514,7 +514,7 @@ typedef arr1_t arr2_t;
 typedef arr2_t arr3_t;
 typedef arr3_t arr4_t;
=20
-typedef const char * const volatile restrict fancy_char_ptr_t;
+typedef const char * const volatile fancy_char_ptr_t;
=20
 typedef core_reloc_mods_substruct_t core_reloc_mods_substruct_tt;
=20
--=20
2.17.1

