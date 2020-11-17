Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE72B5766
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgKQC5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:57:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgKQCzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:46 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2sDwG023481
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZrFU9veoYi6LbfA4dVhaxejDOk6bL0QJBS4Cdd63aqk=;
 b=psZg27LMPDjbakCxqsst9xPNAlQBCg1aAtbljBxVMM/OKlJraAsLqmxhuMVu5FJ5mR6T
 J4oJv7IeEzEbR9/xuQt2B7ohY+GbgVNV9A+VF21P5OC1vQPXSUnSeij4sZFo/q/euiJ1
 g+bR6UetUyFAju7rnuz2y41XUFRAIkHkHPs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34uphj4xw3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:45 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:42 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id C0CEDC5F7C8; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 05/34] bpf: memcg-based memory accounting for bpf progs
Date:   Mon, 16 Nov 2020 18:55:00 -0800
Message-ID: <20201117025529.1034387-6-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=679 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=38 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include memory used by bpf programs into the memcg-based accounting.
This includes the memory used by programs itself, auxiliary data,
statistics and bpf line info. A memory cgroup containing the
process which loads the program is getting charged.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 55454d2278b1..fd83e5c65d15 100644
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

