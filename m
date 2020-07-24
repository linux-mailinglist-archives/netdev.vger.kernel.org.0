Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4F522BB47
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 03:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGXBRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 21:17:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgGXBRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 21:17:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06O1FOSD021765
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 18:17:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=eVHfyRC1IBovFPGS2P7OR2Jg5TMlOWuUQYYhWJ2W9vI=;
 b=G22WaDHFXhSowRZkI3GdLf3TAgBDtHzlceWg64CXpvnOZoUdVf66VDsHb27vKWevcw7X
 hoaBTxTkNZC0NS/ke8bJ+o253TXMx7tvLlMWwHnV7adLM08TGLBCYUgHCNveRUSWqSyf
 i1yupXDxzylmOT+n7261CfZwsqcOGZrGnXU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etg3f5hr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 18:17:08 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 18:17:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C6BA82EC494D; Thu, 23 Jul 2020 18:17:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: fix map leak in HASH_OF_MAPS map
Date:   Thu, 23 Jul 2020 18:16:59 -0700
Message-ID: <20200724011700.2854734-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_20:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 suspectscore=25 bulkscore=0 mlxlogscore=866
 priorityscore=1501 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix HASH_OF_MAPS bug of not putting inner map pointer on bpf_map_elem_upd=
ate()
operation. This is due to per-cpu extra_elems optimization, which bypasse=
d
free_htab_elem() logic doing proper clean ups. Make sure that inner map i=
s put
properly in optimized case as well.

Fixes: 8c290e60fa2a ("bpf: fix hashmap extra_elems logic")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/hashtab.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index b4b288a3c3c9..b32cc8ce8ff6 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -779,15 +779,20 @@ static void htab_elem_free_rcu(struct rcu_head *hea=
d)
 	htab_elem_free(htab, l);
 }
=20
-static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
+static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l=
)
 {
 	struct bpf_map *map =3D &htab->map;
+	void *ptr;
=20
 	if (map->ops->map_fd_put_ptr) {
-		void *ptr =3D fd_htab_map_get_ptr(map, l);
-
+		ptr =3D fd_htab_map_get_ptr(map, l);
 		map->ops->map_fd_put_ptr(ptr);
 	}
+}
+
+static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
+{
+	htab_put_fd_value(htab, l);
=20
 	if (htab_is_prealloc(htab)) {
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
@@ -839,6 +844,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 			 */
 			pl_new =3D this_cpu_ptr(htab->extra_elems);
 			l_new =3D *pl_new;
+			htab_put_fd_value(htab, old_elem);
 			*pl_new =3D old_elem;
 		} else {
 			struct pcpu_freelist_node *l;
--=20
2.24.1

