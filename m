Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED71A24E3A2
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHUW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:56:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726705AbgHUW4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:56:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07LMmWgE017214
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 15:56:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=iuY4HZISNsHPX+fEP9ZLfZC2i+Pgc/GbLLUIhPf2oS0=;
 b=SZkxmvAPPBmTsXyOp0Fo9J6WhyjwWSvL8NEuWYf7Sz5ikYd4hE0fa6r8NxV6aMPhJ7ZV
 F19dawq5pNsOL6IlH3mhTXrQjpXm117a2i5HdqzkhTRgwM94Zx+wPs9M3bsEQyeXfLqN
 Rlw32SAKk3tDjVFOIuYW2+SyaU7mpc7huzQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjqfdj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 15:56:03 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 15:56:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5AC782EC6002; Fri, 21 Aug 2020 15:55:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: avoid false unuinitialized variable warning in bpf_core_apply_relo
Date:   Fri, 21 Aug 2020 15:55:56 -0700
Message-ID: <20200821225556.2178419-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_10:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210213
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some versions of GCC report uninitialized targ_spec usage. GCC is wrong, =
but
let's avoid unnecessary warnings.

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algor=
ithm")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ea80a1582af6..58b9e7ea42b7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5285,7 +5285,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 			       struct hashmap *cand_cache)
 {
 	const char *prog_name =3D bpf_program__title(prog, false);
-	struct bpf_core_spec local_spec, cand_spec, targ_spec;
+	struct bpf_core_spec local_spec, cand_spec, targ_spec =3D {};
 	const void *type_key =3D u32_as_hash_key(relo->type_id);
 	struct bpf_core_relo_res cand_res, targ_res;
 	const struct btf_type *local_type;
--=20
2.24.1

