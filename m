Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4324AF22
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHTGOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:14:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726803AbgHTGOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:14:37 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07K6EWeA007090
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=23X/0OoFMp1lkx9fJ069SLw3UlOPehuxdZ0ns2v1g5E=;
 b=gW2q1r98OjR6IsYTilYxM/EhqUfJDOiAwaSxAqNTvK59ATFR1+LcwkXuHli644IRI82X
 8m6TEn+6OnVYR8wcwzOvClT7yLMfInPaFSx42WoUxru9f7Ihvz6mix6c7526azO9biS7
 CxlLL5O2gy7ijs8O3IPata+TNPqio/ea7ck= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 331hcbreqn-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:36 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 23:14:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B5FE62EC5ED6; Wed, 19 Aug 2020 23:14:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] libbpf: fix detection of BPF helper call instruction
Date:   Wed, 19 Aug 2020 23:14:08 -0700
Message-ID: <20200820061411.1755905-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=8 clxscore=1015 bulkscore=0
 mlxlogscore=807 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008200055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_CALL | BPF_JMP32 is explicitly not allowed by verifier for BPF helper
calls, so don't detect it as a valid call. Also drop the check on func_id
pointer, as it's currently always non-null.

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: 109cea5a594f ("libbpf: Sanitize BPF program code for bpf_probe_rea=
d_{kernel, user}[_str]")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 77d420c02094..92ca4eb6ba2d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5844,14 +5844,12 @@ static int bpf_object__collect_reloc(struct bpf_o=
bject *obj)
=20
 static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id =
*func_id)
 {
-	__u8 class =3D BPF_CLASS(insn->code);
-
-	if ((class =3D=3D BPF_JMP || class =3D=3D BPF_JMP32) &&
+	if (BPF_CLASS(insn->code) =3D=3D BPF_JMP &&
 	    BPF_OP(insn->code) =3D=3D BPF_CALL &&
 	    BPF_SRC(insn->code) =3D=3D BPF_K &&
-	    insn->src_reg =3D=3D 0 && insn->dst_reg =3D=3D 0) {
-		    if (func_id)
-			    *func_id =3D insn->imm;
+	    insn->src_reg =3D=3D 0 &&
+	    insn->dst_reg =3D=3D 0) {
+		    *func_id =3D insn->imm;
 		    return true;
 	}
 	return false;
--=20
2.24.1

