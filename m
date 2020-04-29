Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52971BD1A5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgD2BVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbgD2BVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:34 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1IRh8020001
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nHb5EkxXmoRgKg29GO2FFV9d0TPr3WOjfGMIv+xIj3k=;
 b=jAT7R06qRUawRFupyVNY4LnI/8x32qQwAoOkxhNEqWgWI1alNc8IwktbcLT61MF46csL
 0lr+PP/smZxeidQYeBzSFM8zy/jQ9tGZzL54cuDQuRxJtJQh0ZRb+HZf4r5xp9LaKJwy
 4Udp1TEDLStQhwBIK11DM3FCBpqv7Bqe0yU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54ek7np-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:32 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 24D862EC30E4; Tue, 28 Apr 2020 18:21:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 07/11] selftests/bpf: fix invalid memory reads in core_relo selftest
Date:   Tue, 28 Apr 2020 18:21:07 -0700
Message-ID: <20200429012111.277390-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=8 spamscore=0 impostorscore=0
 mlxlogscore=761 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another one found by AddressSanitizer. input_len is bigger than actually
initialized data size.

Fixes: c7566a69695c ("selftests/bpf: Add field existence CO-RE relocs tes=
ts")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/=
testing/selftests/bpf/prog_tests/core_reloc.c
index 31e177adbdf1..084ed26a7d78 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -392,7 +392,7 @@ static struct core_reloc_test_case test_cases[] =3D {
 		.input =3D STRUCT_TO_CHAR_PTR(core_reloc_existence___minimal) {
 			.a =3D 42,
 		},
-		.input_len =3D sizeof(struct core_reloc_existence),
+		.input_len =3D sizeof(struct core_reloc_existence___minimal),
 		.output =3D STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
 			.a_exists =3D 1,
 			.b_exists =3D 0,
--=20
2.24.1

