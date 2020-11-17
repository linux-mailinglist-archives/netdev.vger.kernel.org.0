Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511FD2B573A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKQC4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:56:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727590AbgKQC4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:56:05 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2u0bh014258
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:56:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UL9KPXzaHLZpNSorKKTuhYlkZqIX5y2leBPcmirTmTo=;
 b=PGnysCQ1XKfPg+PGUfD6aGyLfIZC7/0gwQYs4OsopOG86oQtNsCPGxXJS9CzM+Eer+jr
 4GqVtvlQnKs2zPyXQS/G2+soe27j53GkuDmZEu3GMQWTJZMUc7HV0lbwcu55NVtpdkAS
 h0tfyQjKZxIz6dRbz+ZrlbMADvDyp48asFg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34u0698hgu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:56:04 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:37 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id EA793C5F7DA; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 14/34] bpf: memcg-based memory accounting for bpf ringbuffer
Date:   Mon, 16 Nov 2020 18:55:09 -0800
Message-ID: <20201117025529.1034387-15-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=13 priorityscore=1501
 spamscore=0 mlxlogscore=648 adultscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the memcg-based memory accounting for the memory used by
the bpf ringbuffer.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/ringbuf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 31cb04a4dd2d..ee5f55d9276e 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -60,8 +60,8 @@ struct bpf_ringbuf_hdr {
=20
 static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int nu=
ma_node)
 {
-	const gfp_t flags =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
-			    __GFP_ZERO;
+	const gfp_t flags =3D GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
+			    __GFP_NOWARN | __GFP_ZERO;
 	int nr_meta_pages =3D RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages =3D data_sz >> PAGE_SHIFT;
 	int nr_pages =3D nr_meta_pages + nr_data_pages;
@@ -89,7 +89,8 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_=
t data_sz, int numa_node)
 	 */
 	array_size =3D (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
 	if (array_size > PAGE_SIZE)
-		pages =3D vmalloc_node(array_size, numa_node);
+		pages =3D __vmalloc_node(array_size, 1, GFP_KERNEL_ACCOUNT,
+				       numa_node, __builtin_return_address(0));
 	else
 		pages =3D kmalloc_node(array_size, flags, numa_node);
 	if (!pages)
@@ -167,7 +168,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_at=
tr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
=20
-	rb_map =3D kzalloc(sizeof(*rb_map), GFP_USER);
+	rb_map =3D kzalloc(sizeof(*rb_map), GFP_USER | __GFP_ACCOUNT);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

