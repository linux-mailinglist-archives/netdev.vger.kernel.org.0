Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B754427F579
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgI3WuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:50:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731839AbgI3WuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:50:05 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UMkl0b024866
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6o+g6CvLKaTKQuIHDUh/KcMdLPvg7ltHmTb/OOFUgJM=;
 b=Ahw38LIDJpON7f8Q7HLkr09kdWe++6F61Y3UZ06ozaZZPdoan6qxAM/EyOMLhRpuneUt
 7lz2IQsgIo4fNudAJqg53AfoFwAZbEki5H7/CrVoK/UBLWJqKd8uohRT9Vnxi5ldh9ko
 g1+B7zT3XsGCAUaN3QsCG6ASkla7sPpcGdw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vu1t5u-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:50:04 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 15:49:58 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BDA8862E586A; Wed, 30 Sep 2020 15:49:53 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 1/2] bpf: introduce BPF_F_PRESERVE_ELEMS for perf event array
Date:   Wed, 30 Sep 2020 15:49:26 -0700
Message-ID: <20200930224927.1936644-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930224927.1936644-1-songliubraving@fb.com>
References: <20200930224927.1936644-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300183
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
 kernel/bpf/arraymap.c          | 19 +++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  3 +++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1f17c6752debb..4f556cfcbfbee 100644
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
index e5fd31268ae02..bd777dd6f9677 100644
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
@@ -1134,6 +1139,9 @@ static void perf_event_fd_array_release(struct bpf_=
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
@@ -1143,12 +1151,19 @@ static void perf_event_fd_array_release(struct bp=
f_map *map,
 	rcu_read_unlock();
 }
=20
+static void perf_event_fd_array_map_free(struct bpf_map *map)
+{
+	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
+		bpf_fd_array_map_clear(map);
+	fd_array_map_free(map);
+}
+
 static int perf_event_array_map_btf_id;
 const struct bpf_map_ops perf_event_array_map_ops =3D {
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
index 1f17c6752debb..4f556cfcbfbee 100644
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

