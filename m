Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4940B27BFFA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgI2IsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:48:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgI2IsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:48:17 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T8gGam007392
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:48:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+R97lXwFg5naeDERa3Nxp06DjosuYccCbTRkixjpzwk=;
 b=jWx7A5yxI7pwxL197DHpT1LA9P52/UERynmySILZ97gxEL9IUMfgIMTBk7R5jg7m5mOT
 kPrhaFOjFTyqTObtGHezJg3E7NjoDc1AbxMKX1h1YWWNlEHI7ddA7IZean46jVh3x9/a
 /8/jixYDlSB2OGR4c3cskgq1swA3pROcJVU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33tn599d21-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:48:16 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 01:48:09 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 68DF962E5765; Tue, 29 Sep 2020 01:48:00 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf event array
Date:   Tue, 29 Sep 2020 01:47:49 -0700
Message-ID: <20200929084750.419168-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929084750.419168-1-songliubraving@fb.com>
References: <20200929084750.419168-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=2 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290080
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, perf event in perf event array is removed from the array when
the map fd used to add the event is closed. This behavior makes it
difficult to the share perf events with perf event array.

Introduce perf event map that keeps the perf event open with a new flag
BPF_F_SHARE_PE. With this flag set, perf events in the array are not
removed when the original map fd is closed. Instead, the perf event will
stay in the map until 1) it is explicitly removed from the array; or 2)
the array is freed.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/uapi/linux/bpf.h       |  3 +++
 kernel/bpf/arraymap.c          | 31 +++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  3 +++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 82522f05c0213..74f7a09e9d1e3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -414,6 +414,9 @@ enum {
=20
 /* Enable memory-mapping BPF map */
 	BPF_F_MMAPABLE		=3D (1U << 10),
+
+/* Share perf_event among processes */
+	BPF_F_SHARE_PE		=3D (1U << 11),
 };
=20
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index e5fd31268ae02..4938ff183d846 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -15,7 +15,7 @@
 #include "map_in_map.h"
=20
 #define ARRAY_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | BPF_F_SHARE_PE)
=20
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
@@ -64,6 +64,10 @@ int array_map_alloc_check(union bpf_attr *attr)
 	    attr->map_flags & BPF_F_MMAPABLE)
 		return -EINVAL;
=20
+	if (attr->map_type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
+	    attr->map_flags & BPF_F_SHARE_PE)
+		return -EINVAL;
+
 	if (attr->value_size > KMALLOC_MAX_SIZE)
 		/* if value_size is bigger, the user space won't be able to
 		 * access the elements.
@@ -778,6 +782,26 @@ static int fd_array_map_delete_elem(struct bpf_map *=
map, void *key)
 	}
 }
=20
+static void perf_event_fd_array_map_free(struct bpf_map *map)
+{
+	struct bpf_event_entry *ee;
+	struct bpf_array *array;
+	int i;
+
+	if ((map->map_flags & BPF_F_SHARE_PE) =3D=3D 0) {
+		fd_array_map_free(map);
+		return;
+	}
+
+	array =3D container_of(map, struct bpf_array, map);
+	for (i =3D 0; i < array->map.max_entries; i++) {
+		ee =3D READ_ONCE(array->ptrs[i]);
+		if (ee)
+			fd_array_map_delete_elem(map, &i);
+	}
+	bpf_map_area_free(array);
+}
+
 static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
@@ -1134,6 +1158,9 @@ static void perf_event_fd_array_release(struct bpf_=
map *map,
 	struct bpf_event_entry *ee;
 	int i;
=20
+	if (map->map_flags & BPF_F_SHARE_PE)
+		return;
+
 	rcu_read_lock();
 	for (i =3D 0; i < array->map.max_entries; i++) {
 		ee =3D READ_ONCE(array->ptrs[i]);
@@ -1148,7 +1175,7 @@ const struct bpf_map_ops perf_event_array_map_ops =3D=
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
index 82522f05c0213..74f7a09e9d1e3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -414,6 +414,9 @@ enum {
=20
 /* Enable memory-mapping BPF map */
 	BPF_F_MMAPABLE		=3D (1U << 10),
+
+/* Share perf_event among processes */
+	BPF_F_SHARE_PE		=3D (1U << 11),
 };
=20
 /* Flags for BPF_PROG_QUERY. */
--=20
2.24.1

