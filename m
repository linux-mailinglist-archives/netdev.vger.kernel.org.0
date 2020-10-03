Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ECA28207D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgJCCTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:19:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725820AbgJCCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:19:09 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0932CDmM000965
        for <netdev@vger.kernel.org>; Fri, 2 Oct 2020 19:19:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=UtoBmt7G4vnsx9cntc5KsyzqrpxcBgUDrG3pImKf9lE=;
 b=VbKlOkYt0GKK4WpYyMFL7DDzY7g87hcUW3UQL3+dRaMcwkDnLggrV7BzqiGaypewzDPG
 hAzkw3adao0p/yE4kwr3qr5tNkor1x4wnVRXzhbkTWtWITpw0gtqdlzRBqh0KSkjrCC3
 NZUVJx79vDKAS+IqHaoaSrto0PNQzgVQeS4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33w05ndq04-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 19:19:07 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 19:19:05 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D42493705CBA; Fri,  2 Oct 2020 19:19:04 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/2] samples/bpf: fix a compilation error with fallthrough marking
Date:   Fri, 2 Oct 2020 19:19:04 -0700
Message-ID: <20201003021904.1468772-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201003021904.1468678-1-yhs@fb.com>
References: <20201003021904.1468678-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 mlxlogscore=713 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030019
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

