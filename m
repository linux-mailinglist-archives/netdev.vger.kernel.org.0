Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8E227DB3B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgI2V5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:57:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728199AbgI2V5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:57:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TLucqp014970
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:57:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0p/MpUuBPlM9q5zBlXyWceVaFyhw798LlXRz7q5M2vE=;
 b=F+SAq2kbD2TSXm11dAtsDnI+u8hHq0yF0OFfifYX0tr5IUFnBVUqYjLOgHy7lw9pEkbz
 BPSx1YRqDSWjRlUW0RLP2gedWvtCiXvZwt16RlRST8sx8HOXlP8OgtgXVbEA0axJj5VV
 JINoEc7oXhdC6QcOFwixmaAkkNBUS1kPBQA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vtu8tn-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:57:11 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 14:57:05 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 6F3F062E55BF; Tue, 29 Sep 2020 14:57:04 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 1/2] bpf: introduce BPF_F_PRESERVE_ELEMS for perf event array
Date:   Tue, 29 Sep 2020 14:56:58 -0700
Message-ID: <20200929215659.3938706-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929215659.3938706-1-songliubraving@fb.com>
References: <20200929215659.3938706-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290188
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, perf event in perf event array is removed from the array when
the map fd used to add the event is closed. This behavior makes it
difficult to the share perf events with perf event array.

Introduce perf event map that keeps the perf event open with a new flag
BPF_F_PRESERVE_ELEMS. With this flag set, perf events in the array are no=
t
removed when the original map fd is closed. Instead, the perf event will
stay in the map until 1) it is explicitly removed from the array; or 2)
the array is freed.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/uapi/linux/bpf.h       |  3 +++
 kernel/bpf/arraymap.c          | 21 +++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  3 +++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 82522f05c0213..ea78eb89f8d67 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -414,6 +414,9 @@ enum {
=20
 /* Enable memory-mapping BPF map */
 	BPF_F_MMAPABLE		=3D (1U << 10),
+
+/* Share perf_event among processes */
+	BPF_F_PRESERVE_ELEMS	=3D (1U << 11),
 };
=20
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index e5fd31268ae02..644ceb67350a6 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -15,7 +15,8 @@
 #include "map_in_map.h"
=20
 #define ARRAY_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
+	 BPF_F_PRESERVE_ELEMS)
=20
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
@@ -64,6 +65,10 @@ int array_map_alloc_check(union bpf_attr *attr)
 	    attr->map_flags & BPF_F_MMAPABLE)
 		return -EINVAL;
=20
+	if (attr->map_type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
+	    attr->map_flags & BPF_F_PRESERVE_ELEMS)
+		return -EINVAL;
+
 	if (attr->value_size > KMALLOC_MAX_SIZE)
 		/* if value_size is bigger, the user space won't be able to
 		 * access the elements.
@@ -778,6 +783,15 @@ static int fd_array_map_delete_elem(struct bpf_map *=
map, void *key)
 	}
 }
=20
+static void bpf_fd_array_map_clear(struct bpf_map *map);
+
+static void perf_event_fd_array_map_free(struct bpf_map *map)
+{
+	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
+		bpf_fd_array_map_clear(map);
+	fd_array_map_free(map);
+}
+
 static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
@@ -1134,6 +1148,9 @@ static void perf_event_fd_array_release(struct bpf_=
map *map,
 	struct bpf_event_entry *ee;
 	int i;
=20
+	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
+		return;
+
 	rcu_read_lock();
 	for (i =3D 0; i < array->map.max_entries; i++) {
 		ee =3D READ_ONCE(array->ptrs[i]);
@@ -1148,7 +1165,7 @@ const struct bpf_map_ops perf_event_array_map_ops =3D=
 {
 	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D fd_array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
-	.map_free =3D fd_array_map_free,
+	.map_free =3D perf_event_fd_array_map_free,
 	.map_get_next_key =3D array_map_get_next_key,
 	.map_lookup_elem =3D fd_array_map_lookup_elem,
 	.map_delete_elem =3D fd_array_map_delete_elem,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 82522f05c0213..ea78eb89f8d67 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -414,6 +414,9 @@ enum {
=20
 /* Enable memory-mapping BPF map */
 	BPF_F_MMAPABLE		=3D (1U << 10),
+
+/* Share perf_event among processes */
+	BPF_F_PRESERVE_ELEMS	=3D (1U << 11),
 };
=20
 /* Flags for BPF_PROG_QUERY. */
--=20
2.24.1

