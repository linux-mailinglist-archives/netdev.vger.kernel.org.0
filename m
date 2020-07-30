Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AEB233AD6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgG3V0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:26:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730662AbgG3VXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:23:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULEqWb024305
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/tVjpn6IPA6wCA2n7HvN76zLeswT56pQAbaOuZUCx9E=;
 b=pjo0K/BEsBjCwX660sQuYmhq5vVbM8fech/XETnNWKFMaMQJomLckh7mZXDCN7HSNJ5z
 /6IyuOXJ/YjDA061breAm7sqbX0abNTMskxJoJQMREZkBm4V2fhllpDFeNFlP3fdz+u0
 3lLC6iP2/HDQW5wyOoCcrHG35jkIpe/UET0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32m01cj9v4-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:17 -0700
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:23:17 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id C4D9420B00B2; Thu, 30 Jul 2020 14:23:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v3 11/29] bpf: refine memcg-based memory accounting for sockmap and sockhash maps
Date:   Thu, 30 Jul 2020 14:22:52 -0700
Message-ID: <20200730212310.2609108-12-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200730212310.2609108-1-guro@fb.com>
References: <20200730212310.2609108-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 suspectscore=13 mlxlogscore=999
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include internal metadata into the memcg-based memory accounting.
Also include the memory allocated on updating an element.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 net/core/sock_map.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 119f52a99dc1..bc797adca44c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -38,7 +38,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *a=
ttr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
=20
-	stab =3D kzalloc(sizeof(*stab), GFP_USER);
+	stab =3D kzalloc(sizeof(*stab), GFP_USER | __GFP_ACCOUNT);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
=20
@@ -829,7 +829,8 @@ static struct bpf_shtab_elem *sock_hash_alloc_elem(st=
ruct bpf_shtab *htab,
 		}
 	}
=20
-	new =3D kmalloc_node(htab->elem_size, GFP_ATOMIC | __GFP_NOWARN,
+	new =3D kmalloc_node(htab->elem_size,
+			   GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
 			   htab->map.numa_node);
 	if (!new) {
 		atomic_dec(&htab->count);
@@ -1011,7 +1012,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_at=
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

