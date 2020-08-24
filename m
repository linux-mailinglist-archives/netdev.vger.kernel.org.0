Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13437250BA0
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgHXW2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:28:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726531AbgHXW2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:28:14 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OML0tp028314
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 15:28:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Ph2BI8Aws2Tf2cWVu8gVGq9pGhqUnKAxMSGZgTd0ZJo=;
 b=irklnqOBkrNlCz+dyDXVbXGrA/Wg6TiC9vrUa3oHlHp+6OhAEkCuchhrxXHEkQEsKCWC
 ErkDPp1fIWM3CuI40Vf+duZxZ9xUiQGWoA8PFGE7LbsJv/GqHjpQf4khuhphgsZw1VMb
 eJIX1hSkHJSErNayT9+eNc2WrFIfv05+u/o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 333jv9qh9s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 15:28:13 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 15:28:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6ED893704D57; Mon, 24 Aug 2020 15:28:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: enable tc verbose mode for test_sk_assign
Date:   Mon, 24 Aug 2020 15:28:07 -0700
Message-ID: <20200824222807.100200-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=8 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0
 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently test_sk_assign failed verifier with llvm11/llvm12.
During debugging, I found the default verifier output is
truncated like below
  Verifier analysis:

  Skipped 2200 bytes, use 'verb' option for the full verbose log.
  [...]
  off=3D23,r=3D34,imm=3D0) R5=3Dinv0 R6=3Dctx(id=3D0,off=3D0,imm=3D0) R7=3D=
pkt(id=3D0,off=3D0,r=3D34,imm=3D0) R10=3Dfp0
  80: (0f) r7 +=3D r2
  last_idx 80 first_idx 21
  regs=3D4 stack=3D0 before 78: (16) if w3 =3D=3D 0x11 goto pc+1
when I am using "./test_progs -vv -t assign".

The reason is tc verbose mode is not enabled.

This patched enabled tc verbose mode and the output looks like below
  Verifier analysis:

  0: (bf) r6 =3D r1
  1: (b4) w0 =3D 2
  2: (61) r1 =3D *(u32 *)(r6 +80)
  3: (61) r7 =3D *(u32 *)(r6 +76)
  4: (bf) r2 =3D r7
  5: (07) r2 +=3D 14
  6: (2d) if r2 > r1 goto pc+61
   R0_w=3Dinv2 R1_w=3Dpkt_end(id=3D0,off=3D0,imm=3D0) R2_w=3Dpkt(id=3D0,o=
ff=3D14,r=3D14,imm=3D0)
  ...

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_assign.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/t=
esting/selftests/bpf/prog_tests/sk_assign.c
index d43038d2b9e1..a49a26f95a8b 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -49,7 +49,7 @@ configure_stack(void)
 	sprintf(tc_cmd, "%s %s %s %s", "tc filter add dev lo ingress bpf",
 		       "direct-action object-file ./test_sk_assign.o",
 		       "section classifier/sk_assign_test",
-		       (env.verbosity < VERBOSE_VERY) ? " 2>/dev/null" : "");
+		       (env.verbosity < VERBOSE_VERY) ? " 2>/dev/null" : "verbose");
 	if (CHECK(system(tc_cmd), "BPF load failed;",
 		  "run with -vv for more info\n"))
 		return false;
--=20
2.24.1

