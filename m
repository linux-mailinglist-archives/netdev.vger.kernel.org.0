Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9BC2B999D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgKSRjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:39:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17174 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729526AbgKSRiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:17 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHXuEJ022399
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vBv4Fb39HVdGJ1zVwFFd8JvgoMglbZ6jD8fSoBf07qc=;
 b=X8kUnX25oL3vhbgXAIsH7QBXBXnrw8ZNp+iFn/TbSJlrWLAVc3GMgpLPC8SM7jmZAFM5
 iIeY+cb1FcwZORQ1znEDmF9bEZUVcEDP6FW+/iFWWngwly15KYvn4h9voQ5Al7WoXwNV
 920JKUYzoAdAjemlF1/ysPzXOApyunf5uwY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wthes6c7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:17 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:03 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id C0B39145BCF7; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 16/34] bpf: refine memcg-based memory accounting for sockmap and sockhash maps
Date:   Thu, 19 Nov 2020 09:37:36 -0800
Message-ID: <20201119173754.4125257-17-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=13
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190125
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

