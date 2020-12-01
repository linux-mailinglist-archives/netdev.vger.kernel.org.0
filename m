Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AEB2CAF80
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391660AbgLAWBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:01:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390498AbgLAV76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:58 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LnsZq020436
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jZJAmnGBGR3rAQTYVZOpoRCaKf3XnFApmm8Z0UX5Ep0=;
 b=PRm5UmdFpGCNJ/SahKp2IrQ3siUAJFah9v4Ii65foPrs988HJ4PCnFiA6kk+XDTZwF9V
 j6l2WGzvToJYKvO5m4Ns1rzLtaJY4evqLVrUC8iuWfPeN7C/6farEzLLcnf3WxQ1AIx1
 oCyHdmWqC3/RFBUMz8KpwP8MtSGDmqmwiXc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7y1xb0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:17 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:15 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 7FF6119702BA; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 14/34] bpf: memcg-based memory accounting for bpf ringbuffer
Date:   Tue, 1 Dec 2020 13:58:40 -0800
Message-ID: <20201201215900.3569844-15-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=628 phishscore=0
 mlxscore=0 suspectscore=13 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the memcg-based memory accounting for the memory used by
the bpf ringbuffer.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/ringbuf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 31cb04a4dd2d..8983a46f6580 100644
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
@@ -88,10 +88,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size=
_t data_sz, int numa_node)
 	 * user-space implementations significantly.
 	 */
 	array_size =3D (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	if (array_size > PAGE_SIZE)
-		pages =3D vmalloc_node(array_size, numa_node);
-	else
-		pages =3D kmalloc_node(array_size, flags, numa_node);
+	pages =3D bpf_map_area_alloc(array_size, numa_node);
 	if (!pages)
 		return NULL;
=20
@@ -167,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_at=
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

