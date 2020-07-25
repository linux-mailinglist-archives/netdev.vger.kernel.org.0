Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F319922D301
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgGYAHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:07:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726988AbgGYAEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmed8013832
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=i9/1jbWQ4GxTiRm+DIEz3bZ8w7LZrOddPgH6XE94iCw=;
 b=OXunITM8a/7bFuCZZrs1znEDDv1DYfFuGnTXTerzXb1h1y2F0NjO+WAF03+4YwIiOTil
 P88MjsjKy4C6IoTTwiK7vUiqBzMkf1vtI5rYPqypkKMaoQvelQjyXXqp5xdpi5lovypR
 nWEvaAPCDe4TBAybVovT2AgJ54bXZ3HIc1Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32fh7kpdm6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:32 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:31 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 04F271B35A8C; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 16/35] bpf: eliminate rlimit-based memory accounting for cgroup storage maps
Date:   Fri, 24 Jul 2020 17:03:51 -0700
Message-ID: <20200725000410.3566700-17-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=38 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for cgroup storage maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/local_storage.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 117acb2e80fb..5f29a420849c 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -288,8 +288,6 @@ static struct bpf_map *cgroup_storage_map_alloc(union=
 bpf_attr *attr)
 {
 	int numa_node =3D bpf_map_attr_numa_node(attr);
 	struct bpf_cgroup_storage_map *map;
-	struct bpf_map_memory mem;
-	int ret;
=20
 	if (attr->key_size !=3D sizeof(struct bpf_cgroup_storage_key) &&
 	    attr->key_size !=3D sizeof(__u64))
@@ -309,18 +307,10 @@ static struct bpf_map *cgroup_storage_map_alloc(uni=
on bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
=20
-	ret =3D bpf_map_charge_init(&mem, sizeof(struct bpf_cgroup_storage_map)=
);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	map =3D kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
 			   __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
-	if (!map) {
-		bpf_map_charge_finish(&mem);
+	if (!map)
 		return ERR_PTR(-ENOMEM);
-	}
-
-	bpf_map_charge_move(&map->map.memory, &mem);
=20
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&map->map, attr);
@@ -509,9 +499,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(s=
truct bpf_prog *prog,
=20
 	size =3D bpf_cgroup_storage_calculate_size(map, &pages);
=20
-	if (bpf_map_charge_memlock(map, pages))
-		return ERR_PTR(-EPERM);
-
 	storage =3D kmalloc_node(sizeof(struct bpf_cgroup_storage), gfp,
 			       map->numa_node);
 	if (!storage)
@@ -533,7 +520,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(s=
truct bpf_prog *prog,
 	return storage;
=20
 enomem:
-	bpf_map_uncharge_memlock(map, pages);
 	kfree(storage);
 	return ERR_PTR(-ENOMEM);
 }
@@ -560,16 +546,11 @@ void bpf_cgroup_storage_free(struct bpf_cgroup_stor=
age *storage)
 {
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_map *map;
-	u32 pages;
=20
 	if (!storage)
 		return;
=20
 	map =3D &storage->map->map;
-
-	bpf_cgroup_storage_calculate_size(map, &pages);
-	bpf_map_uncharge_memlock(map, pages);
-
 	stype =3D cgroup_storage_type(map);
 	if (stype =3D=3D BPF_CGROUP_STORAGE_SHARED)
 		call_rcu(&storage->rcu, free_shared_cgroup_storage_rcu);
--=20
2.26.2

