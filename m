Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784052C373F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgKYDCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:02:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34820 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727622AbgKYDBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:36 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP2skx0014300
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UL9KPXzaHLZpNSorKKTuhYlkZqIX5y2leBPcmirTmTo=;
 b=S5oliPa0iY27ok1KZWQALZ4rO8pZ2GNWh4EjUxk5FvkjbXPu8Dv2dRtZXv9hTfMpgBVf
 goGMUKI9QH9ppZX0x5aQIhQZvIHG6kKMHMDDfJ4h0baHi0HdcTVC0uw8QtVbMsk0Z8vR
 fCT/TQSjFXHQJHxQdhc1jc2FdROCGd96yzA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34ykxgmjxs-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:35 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:32 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 2A87016A189D; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 14/34] bpf: memcg-based memory accounting for bpf ringbuffer
Date:   Tue, 24 Nov 2020 19:00:59 -0800
Message-ID: <20201125030119.2864302-15-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=13 mlxlogscore=704 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
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

