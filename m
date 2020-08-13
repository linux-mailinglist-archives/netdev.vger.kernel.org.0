Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4EC243FF7
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHMUkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:40:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42308 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726669AbgHMUkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:40:09 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DKcluw020858
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:40:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zdOUMlPLM5CeGR3mHvYZL7On1+O0+1hDd4dBEIzkVd4=;
 b=AoqGOZlS15WKBlYcmKcfG8ukFkyRvTq6AsIPPunYVeRohs+FSvmzlEQZvEWxKAir4PQK
 MM8+txVGppEPYO2WD311ZRL3y8w8neg63ozrKjPmTRkRpkQlmxl/oA2Yd5Dj9vkQYnYP
 MUvfeYx5e4+L9PH3dtCMrCgZ/XhkRV5wtes= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kfkxtr-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:40:08 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 13:39:59 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6D8FD2EC596D; Thu, 13 Aug 2020 13:39:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 8/9] tools/bpftool: generate data section struct with conservative alignment
Date:   Thu, 13 Aug 2020 13:39:28 -0700
Message-ID: <20200813203930.978141-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200813203930.978141-1-andriin@fb.com>
References: <20200813203930.978141-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_17:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 suspectscore=8 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008130147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment in the code describes this in good details. Generate such a m=
emory
layout that would work both on 32-bit and 64-bit architectures for user-s=
pace.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index db80e836816e..f61184653633 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -143,6 +143,20 @@ static int codegen_datasec_def(struct bpf_object *ob=
j,
 			      var_name, align);
 			return -EINVAL;
 		}
+		/* Assume 32-bit architectures when generating data section
+		 * struct memory layout. Given bpftool can't know which target
+		 * host architecture it's emitting skeleton for, we need to be
+		 * conservative and assume 32-bit one to ensure enough padding
+		 * bytes are generated for pointer and long types. This will
+		 * still work correctly for 64-bit architectures, because in
+		 * the worst case we'll generate unnecessary padding field,
+		 * which on 64-bit architectures is not strictly necessary and
+		 * would be handled by natural 8-byte alignment. But it still
+		 * will be a correct memory layout, based on recorded offsets
+		 * in BTF.
+		 */
+		if (align > 4)
+			align =3D 4;
=20
 		align_off =3D (off + align - 1) / align * align;
 		if (align_off !=3D need_off) {
--=20
2.24.1

