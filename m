Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37D92C372C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKYDBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:01:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727889AbgKYDBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:40 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP31Ubk018043
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vBv4Fb39HVdGJ1zVwFFd8JvgoMglbZ6jD8fSoBf07qc=;
 b=NVQkkbzqucw9j107v5YAIGilNV9cVJuX1YztRjI3YvNEO/7DTDV7CZa8Fq+eSkIPq8ZP
 WATmLO4W0TDy07lhcZshLv1m9xilomPVBBUJYNG7z1BZSx00ynde7hLRB7nbdwadGNE0
 VgSF7YblzIitR+ruebjy0LUaNsl9ZuuNZgI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 350qy4wcy4-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:40 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:32 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 33EE916A18A1; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 16/34] bpf: refine memcg-based memory accounting for sockmap and sockhash maps
Date:   Tue, 24 Nov 2020 19:01:01 -0800
Message-ID: <20201125030119.2864302-17-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 phishscore=0 bulkscore=0 impostorscore=0 suspectscore=13
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include internal metadata into the memcg-based memory accounting.
Also include the memory allocated on updating an element.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/core/sock_map.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ddc899e83313..3ff635af737a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -39,7 +39,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *a=
ttr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
=20
-	stab =3D kzalloc(sizeof(*stab), GFP_USER);
+	stab =3D kzalloc(sizeof(*stab), GFP_USER | __GFP_ACCOUNT);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
=20
@@ -975,8 +975,9 @@ static struct bpf_shtab_elem *sock_hash_alloc_elem(st=
ruct bpf_shtab *htab,
 		}
 	}
=20
-	new =3D kmalloc_node(htab->elem_size, GFP_ATOMIC | __GFP_NOWARN,
-			   htab->map.numa_node);
+	new =3D bpf_map_kmalloc_node(&htab->map, htab->elem_size,
+				   GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
+				   htab->map.numa_node);
 	if (!new) {
 		atomic_dec(&htab->count);
 		return ERR_PTR(-ENOMEM);
@@ -1116,7 +1117,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_at=
tr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
=20
-	htab =3D kzalloc(sizeof(*htab), GFP_USER);
+	htab =3D kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

