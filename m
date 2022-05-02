Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614DF51793A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384581AbiEBVlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352930AbiEBVk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:40:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05757E0D2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:37:26 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242LKM0r032562
        for <netdev@vger.kernel.org>; Mon, 2 May 2022 14:37:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=wgp0G4hWeWiK5so1R05KUGRzq6OJMQiX/ath9F5ULtw=;
 b=q9IQ2L5hoZ+s5xUXDzcopEyQKKL7jUVTfyyJKJOXszw0ocLdp4PIMUM0PZxE6uNx3kyf
 Oc/B4aZTHjwTjszsZVkVLeinXJNoWVVo3hm8KkYZFDLGnKDB6YF0oS1oxaNnKOW9KQn3
 SMtwtwcZSIw5FWBNL6bYKJO1MeAz7ibXEeY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fs2uxv11e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 14:37:26 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 2 May 2022 14:37:24 -0700
Received: by devvm4403.frc0.facebook.com (Postfix, from userid 153359)
        id 5DD4E68A364F; Mon,  2 May 2022 14:37:13 -0700 (PDT)
From:   Takshak Chahande <ctakshak@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <ctakshak@fb.com>,
        <ndixit@fb.com>, <kafai@fb.com>, <andriin@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
Subject: [PATCH bpf-next v4 1/2] bpf: Extend batch operations for map-in-map bpf-maps
Date:   Mon, 2 May 2022 14:37:04 -0700
Message-ID: <20220502213705.1170077-1-ctakshak@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AQHH8Ff1ySd2uIc9G0lzT7DtDiB8Klkw
X-Proofpoint-GUID: AQHH8Ff1ySd2uIc9G0lzT7DtDiB8Klkw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_07,2022-05-02_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends batch operations support for map-in-map map-types:
BPF_MAP_TYPE_HASH_OF_MAPS and BPF_MAP_TYPE_ARRAY_OF_MAPS

A usecase where outer HASH map holds hundred of VIP entries and its
associated reuse-ports per VIP stored in REUSEPORT_SOCKARRAY type
inner map, needs to do batch operation for performance gain.

This patch leverages the exiting generic functions for most of the batch
operations. As map-in-map's value contains the actual reference of the in=
ner map,
for BPF_MAP_TYPE_HASH_OF_MAPS type, it needed an extra step to fetch the
map_id from the reference value.

selftests are added in next patch 2/2.

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/arraymap.c |  2 ++
 kernel/bpf/hashtab.c  | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

v3->v4:
- Added blank line between var declaration and actual code block (Yonghon=
g)

v1->v3:
- Changes in selftest/bpf patch 2/2

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index b3bf31fd9458..724613da6576 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1345,6 +1345,8 @@ const struct bpf_map_ops array_of_maps_map_ops =3D =
{
 	.map_fd_put_ptr =3D bpf_map_fd_put_ptr,
 	.map_fd_sys_lookup_elem =3D bpf_map_fd_sys_lookup_elem,
 	.map_gen_lookup =3D array_of_map_gen_lookup,
+	.map_lookup_batch =3D generic_map_lookup_batch,
+	.map_update_batch =3D generic_map_update_batch,
 	.map_check_btf =3D map_check_no_btf,
 	.map_btf_id =3D &array_map_btf_ids[0],
 };
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3e00e62b2218..705841279d16 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -140,7 +140,7 @@ static inline bool htab_use_raw_lock(const struct bpf=
_htab *htab)
=20
 static void htab_init_buckets(struct bpf_htab *htab)
 {
-	unsigned i;
+	unsigned int i;
=20
 	for (i =3D 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
@@ -1627,7 +1627,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *=
map,
 	void __user *uvalues =3D u64_to_user_ptr(attr->batch.values);
 	void __user *ukeys =3D u64_to_user_ptr(attr->batch.keys);
 	void __user *ubatch =3D u64_to_user_ptr(attr->batch.in_batch);
-	u32 batch, max_count, size, bucket_size;
+	u32 batch, max_count, size, bucket_size, map_id;
 	struct htab_elem *node_to_free =3D NULL;
 	u64 elem_map_flags, map_flags;
 	struct hlist_nulls_head *head;
@@ -1752,6 +1752,14 @@ __htab_map_lookup_and_delete_batch(struct bpf_map =
*map,
 			}
 		} else {
 			value =3D l->key + roundup_key_size;
+			if (map->map_type =3D=3D BPF_MAP_TYPE_HASH_OF_MAPS) {
+				struct bpf_map **inner_map =3D value;
+
+				 /* Actual value is the id of the inner map */
+				map_id =3D map->ops->map_fd_sys_lookup_elem(*inner_map);
+				value =3D &map_id;
+			}
+
 			if (elem_map_flags & BPF_F_LOCK)
 				copy_map_value_locked(map, dst_val, value,
 						      true);
@@ -2450,5 +2458,6 @@ const struct bpf_map_ops htab_of_maps_map_ops =3D {
 	.map_fd_sys_lookup_elem =3D bpf_map_fd_sys_lookup_elem,
 	.map_gen_lookup =3D htab_of_map_gen_lookup,
 	.map_check_btf =3D map_check_no_btf,
+	BATCH_OPS(htab),
 	.map_btf_id =3D &htab_map_btf_ids[0],
 };
--=20
2.30.2

