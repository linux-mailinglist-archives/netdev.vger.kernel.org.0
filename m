Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3652844FA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 06:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgJFEeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 00:34:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45982 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbgJFEef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 00:34:35 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0964OLGx022096
        for <netdev@vger.kernel.org>; Mon, 5 Oct 2020 21:34:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=FD0x/kj+Gcp+4ambPMN7yB9IhY1pQ2CR3QdPpzXV27o=;
 b=rV1w4uYMNm7NI64hZ+Ju3w/MGE4V1KHRKU/xD8CDWZKo8CCCLHLn0Ge3MG2Fe7Zm8/YB
 rECNVd+ErAHEfE6J6fgxvXFb3m4MiTuk8U5gNl4h33ikukxXHDZRIdxMTfSdm+s7aa6f
 T9UDdA9OcXeEu9DAqN40JyMHUmTsI8Co2mk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33xptn35q6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 21:34:34 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 21:34:33 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 5D3C137057DA; Mon,  5 Oct 2020 21:34:27 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next v2 2/2] samples/bpf: fix a compilation error with fallthrough marking
Date:   Mon, 5 Oct 2020 21:34:27 -0700
Message-ID: <20201006043427.1891805-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201006043427.1891742-1-yhs@fb.com>
References: <20201006043427.1891742-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_01:2020-10-05,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=755 clxscore=1015 suspectscore=8 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiling samples/bpf hits an error related to fallthrough marking.
    ...
    CC  samples/bpf/hbm.o
  samples/bpf/hbm.c: In function =E2=80=98main=E2=80=99:
  samples/bpf/hbm.c:486:4: error: =E2=80=98fallthrough=E2=80=99 undeclare=
d (first use in this function)
      fallthrough;
      ^~~~~~~~~~~

The "fallthrough" is not defined under tools/include directory.
Rather, it is "__fallthrough" is defined in linux/compiler.h.
Including "linux/compiler.h" and using "__fallthrough" fixed the issue.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/hbm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Changelog:
  v1 -> v2: no change

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 4b22ace52f80..ff4c533dfac2 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -40,6 +40,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/unistd.h>
+#include <linux/compiler.h>
=20
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
@@ -483,7 +484,7 @@ int main(int argc, char **argv)
 					"Option -%c requires an argument.\n\n",
 					optopt);
 		case 'h':
-			fallthrough;
+			__fallthrough;
 		default:
 			Usage();
 			return 0;
--=20
2.24.1

