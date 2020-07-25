Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08BD22D2F0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgGYAGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:06:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbgGYAEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONjPCF007805
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FaJ1i3Jvwgzp3yQTLRS/t9DNv3oIBKU1p40msqTMQZ4=;
 b=Ptz7rjc90ZrIxd0THn9u/Z1rR43LIgC1lCaqtUB2KcZw2VFGxxwjlfCBJuBulf3fPTpF
 +nBD7seCmHsM9vTK7t58FSs035Cxfp3Gruu10EVk8M5eiLz+iATS63PLfEJUxMfKUiwy
 JvjJ/5NPAJsr9TVDki8QNcp3mqoqjMrPj8w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etbgc7qf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:34 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:32 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 0E4D91B35A90; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 18/35] bpf: eliminate rlimit-based memory accounting for hashtab maps
Date:   Fri, 24 Jul 2020 17:03:53 -0700
Message-ID: <20200725000410.3566700-19-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=809 spamscore=0 adultscore=0
 suspectscore=38 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for hashtab maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/hashtab.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 9d0432170812..9372b559b4e7 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -422,7 +422,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	bool percpu_lru =3D (attr->map_flags & BPF_F_NO_COMMON_LRU);
 	bool prealloc =3D !(attr->map_flags & BPF_F_NO_PREALLOC);
 	struct bpf_htab *htab;
-	u64 cost;
 	int err;
=20
 	htab =3D kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
@@ -459,26 +458,12 @@ static struct bpf_map *htab_map_alloc(union bpf_att=
r *attr)
 	    htab->n_buckets > U32_MAX / sizeof(struct bucket))
 		goto free_htab;
=20
-	cost =3D (u64) htab->n_buckets * sizeof(struct bucket) +
-	       (u64) htab->elem_size * htab->map.max_entries;
-
-	if (percpu)
-		cost +=3D (u64) round_up(htab->map.value_size, 8) *
-			num_possible_cpus() * htab->map.max_entries;
-	else
-	       cost +=3D (u64) htab->elem_size * num_possible_cpus();
-
-	/* if map size is larger than memlock limit, reject it */
-	err =3D bpf_map_charge_init(&htab->map.memory, cost);
-	if (err)
-		goto free_htab;
-
 	err =3D -ENOMEM;
 	htab->buckets =3D bpf_map_area_alloc(htab->n_buckets *
 					   sizeof(struct bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets)
-		goto free_charge;
+		goto free_htab;
=20
 	if (htab->map.map_flags & BPF_F_ZERO_SEED)
 		htab->hashrnd =3D 0;
@@ -508,8 +493,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	prealloc_destroy(htab);
 free_buckets:
 	bpf_map_area_free(htab->buckets);
-free_charge:
-	bpf_map_charge_finish(&htab->map.memory);
 free_htab:
 	kfree(htab);
 	return ERR_PTR(err);
--=20
2.26.2

