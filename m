Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256712B1178
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgKLW0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgKLW0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:30 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMLR0a032438
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8oHPPQUDRpM6JE4KnFdjWww9JTDD3xNWkjQoy6jAuOE=;
 b=BrwJ7KWLT3lmtpEQN3BL5Jf75ogZ3wuq7pmeEuzau8Ryj5/ZpbR9RFZW+O1DYKJr4D1P
 U0bf+KSrPt96ZZorZ02zDJLkUBWKes+9PeZoD4y/d3dJd7qdi/Nt7q2JPkDbs91+a0Dd
 bQF569G29MyKbyeIkEzz1QbL3JcyoytOVjw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34s7dstksf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:30 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 14:26:28 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id D2389A7D1DA; Thu, 12 Nov 2020 14:16:00 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>
Subject: [PATCH bpf-next v5 05/34] bpf: memcg-based memory accounting for bpf progs
Date:   Thu, 12 Nov 2020 14:15:14 -0800
Message-ID: <20201112221543.3621014-6-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201112221543.3621014-1-guro@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_14:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=700
 bulkscore=0 phishscore=0 suspectscore=38 spamscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include memory used by bpf programs into the memcg-based accounting.
This includes the memory used by programs itself, auxiliary data,
statistics and bpf line info. A memory cgroup containing the
process which loads the program is getting charged.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9268d77898b7..8346ebcbde99 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct=
 sk_buff *skb, int k, uns
=20
 struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_ex=
tra_flags)
 {
-	gfp_t gfp_flags =3D GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *fp;
=20
@@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int s=
ize, gfp_t gfp_extra_flag
 	if (fp =3D=3D NULL)
 		return NULL;
=20
-	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
+	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
 	if (aux =3D=3D NULL) {
 		vfree(fp);
 		return NULL;
@@ -106,7 +106,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int=
 size, gfp_t gfp_extra_flag
=20
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags=
)
 {
-	gfp_t gfp_flags =3D GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *prog;
 	int cpu;
=20
@@ -138,7 +138,7 @@ int bpf_prog_alloc_jited_linfo(struct bpf_prog *prog)
=20
 	prog->aux->jited_linfo =3D kcalloc(prog->aux->nr_linfo,
 					 sizeof(*prog->aux->jited_linfo),
-					 GFP_KERNEL | __GFP_NOWARN);
+					 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!prog->aux->jited_linfo)
 		return -ENOMEM;
=20
@@ -219,7 +219,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int =
size,
 				  gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags =3D GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
 	u32 pages, delta;
 	int ret;
--=20
2.26.2

