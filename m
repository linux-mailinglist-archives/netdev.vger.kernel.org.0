Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8822D2D0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGYAGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:06:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45872 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727782AbgGYAEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:40 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmbc5012886
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8ycK9dyk0krVtM84IjwRBzsABNq6gvRDOeD6Zv8pbc0=;
 b=XWo7VR5rbMLw7v9FSIl4dN0qIDcOrZVZKV9qwPje5jmhY8COZejDW34Uu/Gy4fFhjXW6
 JJBn7Vtf9M9HJJ4kvm7a4fxjyzkIc9bJiH1iY4LXXTkqY5i/vtJiBa4Tebm0aj6tmUpU
 pO2oxJqm3kJiPtPou3aDrFPdGC9t/ve/P2Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegmm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:39 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:33 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id D7B0E1B35A7E; Fri, 24 Jul 2020 17:04:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 09/35] bpf: memcg-based memory accounting for bpf ringbuffer
Date:   Fri, 24 Jul 2020 17:03:44 -0700
Message-ID: <20200725000410.3566700-10-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=663 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=13
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the memcg-based memory accounting for the memory used by
the bpf ringbuffer.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/ringbuf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 002f8a5c9e51..e8e2c39cbdc9 100644
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

