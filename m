Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F02D517938
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351081AbiEBVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiEBVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:40:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A964D6
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:37:22 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242LKGpZ006644
        for <netdev@vger.kernel.org>; Mon, 2 May 2022 14:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ODACN0yUKip44oOeYmstNAHe8x5kZreCHzRJxBu1XmM=;
 b=PbKMue4gk3WNSWVvFctZnEoC6IFGTpQBy0L9BSS/NQ9IdD75IbR+yRopBapilfe1eggt
 npbgJpL4oaL20sTiAjUzXKG8q8mneHiJzvJjs8fCNwAQ4yg8KJl+rf5K0+a1fv40S81J
 /IM3Fk5UuEmlE/PNNl2fnggkxYZrfNW/Upc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fs27rm66w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 14:37:21 -0700
Received: from twshared27672.24.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 2 May 2022 14:37:20 -0700
Received: by devvm4403.frc0.facebook.com (Postfix, from userid 153359)
        id 09F5668A3651; Mon,  2 May 2022 14:37:15 -0700 (PDT)
From:   Takshak Chahande <ctakshak@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <ctakshak@fb.com>,
        <ndixit@fb.com>, <kafai@fb.com>, <andriin@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
Subject: [PATCH bpf-next v4 2/2] selftests/bpf: handle batch operations for map-in-map bpf-maps
Date:   Mon, 2 May 2022 14:37:05 -0700
Message-ID: <20220502213705.1170077-2-ctakshak@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502213705.1170077-1-ctakshak@fb.com>
References: <20220502213705.1170077-1-ctakshak@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uHzUv_rh9fmY5hFbCdXW5q2SsMfCEWhs
X-Proofpoint-ORIG-GUID: uHzUv_rh9fmY5hFbCdXW5q2SsMfCEWhs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_07,2022-05-02_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds up test cases that handles 4 combinations:
 a) outer map: BPF_MAP_TYPE_ARRAY_OF_MAPS
    inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
 b) outer map: BPF_MAP_TYPE_HASH_OF_MAPS
    inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../bpf/map_tests/map_in_map_batch_ops.c      | 245 ++++++++++++++++++
 1 file changed, 245 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batc=
h_ops.c

v3->v4:
- Addressed nits; kept this map test together in map_tests/  (Yonghong, A=
ndrii)

v2->v3:
- Handled transient ENOSPC correctly, bug was found in BPF CI (Daniel)

v1->v2:
- Fixed no format arguments error (Andrii)

diff --git a/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c=
 b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
new file mode 100644
index 000000000000..3b56c874fbd6
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+#define OUTER_MAP_ENTRIES 10
+
+static __u32 get_map_id_from_fd(int map_fd)
+{
+	struct bpf_map_info map_info =3D {};
+	uint32_t info_len =3D sizeof(map_info);
+	int ret;
+
+	ret =3D bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
+	CHECK(ret < 0, "Finding map info failed", "error:%s\n",
+	      strerror(errno));
+
+	return map_info.id;
+}
+
+/* This creates number of OUTER_MAP_ENTRIES maps that will be stored
+ * in outer map and return the created map_fds
+ */
+static void create_inner_maps(enum bpf_map_type map_type,
+			      __u32 *inner_map_fds)
+{
+	int map_fd, map_index, ret;
+	__u32 map_key =3D 0, map_id;
+	char map_name[15];
+
+	for (map_index =3D 0; map_index < OUTER_MAP_ENTRIES; map_index++) {
+		memset(map_name, 0, sizeof(map_name));
+		sprintf(map_name, "inner_map_fd_%d", map_index);
+		map_fd =3D bpf_map_create(map_type, map_name, sizeof(__u32),
+					sizeof(__u32), 1, NULL);
+		CHECK(map_fd < 0,
+		      "inner bpf_map_create() failed",
+		      "map_type=3D(%d) map_name(%s), error:%s\n",
+		      map_type, map_name, strerror(errno));
+
+		/* keep track of the inner map fd as it is required
+		 * to add records in outer map
+		 */
+		inner_map_fds[map_index] =3D map_fd;
+
+		/* Add entry into this created map
+		 * eg: map1 key =3D 0, value =3D map1's map id
+		 *     map2 key =3D 0, value =3D map2's map id
+		 */
+		map_id =3D get_map_id_from_fd(map_fd);
+		ret =3D bpf_map_update_elem(map_fd, &map_key, &map_id, 0);
+		CHECK(ret !=3D 0,
+		      "bpf_map_update_elem failed",
+		      "map_type=3D(%d) map_name(%s), error:%s\n",
+		      map_type, map_name, strerror(errno));
+	}
+}
+
+static int create_outer_map(enum bpf_map_type map_type, __u32 inner_map_=
fd)
+{
+	int outer_map_fd;
+	LIBBPF_OPTS(bpf_map_create_opts, attr);
+
+	attr.inner_map_fd =3D inner_map_fd;
+	outer_map_fd =3D bpf_map_create(map_type, "outer_map", sizeof(__u32),
+				      sizeof(__u32), OUTER_MAP_ENTRIES,
+				      &attr);
+	CHECK(outer_map_fd < 0,
+	      "outer bpf_map_create()",
+	      "map_type=3D(%d), error:%s\n",
+	      map_type, strerror(errno));
+
+	return outer_map_fd;
+}
+
+static void validate_fetch_results(int outer_map_fd, __u32 *inner_map_fd=
s,
+				   __u32 *fetched_keys, __u32 *fetched_values,
+				   __u32 max_entries_fetched)
+{
+	__u32 inner_map_key, inner_map_value;
+	int inner_map_fd, entry, err;
+	__u32 outer_map_value;
+
+	for (entry =3D 0; entry < max_entries_fetched; ++entry) {
+		outer_map_value =3D fetched_values[entry];
+		inner_map_fd =3D bpf_map_get_fd_by_id(outer_map_value);
+		CHECK(inner_map_fd < 0,
+		      "Failed to get inner map fd",
+		      "from id(%d), error=3D%s\n",
+		      outer_map_value, strerror(errno));
+		err =3D bpf_map_get_next_key(inner_map_fd, NULL, &inner_map_key);
+		CHECK(err !=3D 0,
+		      "Failed to get inner map key",
+		      "error=3D%s\n", strerror(errno));
+
+		err =3D bpf_map_lookup_elem(inner_map_fd, &inner_map_key,
+					  &inner_map_value);
+		CHECK(err !=3D 0,
+		      "Failed to get inner map value",
+		      "for key(%d), error=3D%s\n",
+		      inner_map_key, strerror(errno));
+
+		/* Actual value validation */
+		CHECK(outer_map_value !=3D inner_map_value,
+		      "Failed to validate inner map value",
+		      "fetched(%d) and lookedup(%d)!\n",
+		      outer_map_value, inner_map_value);
+	}
+}
+
+static void fetch_and_validate(int outer_map_fd,
+			       __u32 *inner_map_fds,
+			       struct bpf_map_batch_opts *opts,
+			       __u32 batch_size, bool delete_entries)
+{
+	__u32 *fetched_keys, *fetched_values, total_fetched =3D 0;
+	__u32 batch_key =3D 0, fetch_count, step_size;
+	int err, max_entries =3D OUTER_MAP_ENTRIES;
+	__u32 value_size =3D sizeof(__u32);
+
+	/* Total entries needs to be fetched */
+	fetched_keys =3D calloc(max_entries, value_size);
+	fetched_values =3D calloc(max_entries, value_size);
+	CHECK((!fetched_keys || !fetched_values),
+	      "Memory allocation failed for fetched_keys or fetched_values",
+	      "error=3D%s\n", strerror(errno));
+
+	for (step_size =3D batch_size;
+	     step_size <=3D max_entries;
+	     step_size +=3D batch_size) {
+		fetch_count =3D step_size;
+		err =3D delete_entries
+		      ? bpf_map_lookup_and_delete_batch(outer_map_fd,
+				      total_fetched ? &batch_key : NULL,
+				      &batch_key,
+				      fetched_keys + total_fetched,
+				      fetched_values + total_fetched,
+				      &fetch_count, opts)
+		      : bpf_map_lookup_batch(outer_map_fd,
+				      total_fetched ? &batch_key : NULL,
+				      &batch_key,
+				      fetched_keys + total_fetched,
+				      fetched_values + total_fetched,
+				      &fetch_count, opts);
+
+		if (err && errno =3D=3D ENOSPC) {
+			/* Fetch again with higher batch size */
+			total_fetched =3D 0;
+			continue;
+		}
+
+		CHECK((err < 0 && (errno !=3D ENOENT)),
+		      "lookup with steps failed",
+		      "error: %s\n", strerror(errno));
+
+		/* Update the total fetched number */
+		total_fetched +=3D fetch_count;
+		if (err)
+			break;
+	}
+
+	CHECK((total_fetched !=3D max_entries),
+	      "Unable to fetch expected entries !",
+	      "total_fetched(%d) and max_entries(%d) error: (%d):%s\n",
+	      total_fetched, max_entries, errno, strerror(errno));
+
+	/* validate the fetched entries */
+	validate_fetch_results(outer_map_fd, inner_map_fds, fetched_keys,
+			       fetched_values, total_fetched);
+	printf("batch_op(%s) is successful with batch_size(%d)\n",
+	       delete_entries ? "LOOKUP_AND_DELETE" : "LOOKUP", batch_size);
+
+	free(fetched_keys);
+	free(fetched_values);
+}
+
+static void _map_in_map_batch_ops(enum bpf_map_type outer_map_type,
+				  enum bpf_map_type inner_map_type)
+{
+	__u32 *outer_map_keys, *inner_map_fds;
+	__u32 max_entries =3D OUTER_MAP_ENTRIES;
+	LIBBPF_OPTS(bpf_map_batch_opts, opts);
+	__u32 value_size =3D sizeof(__u32);
+	int batch_size[2] =3D {5, 10};
+	__u32 map_index, op_index;
+	int outer_map_fd, ret;
+
+	outer_map_keys =3D calloc(max_entries, value_size);
+	inner_map_fds =3D calloc(max_entries, value_size);
+	CHECK((!outer_map_keys || !inner_map_fds),
+	      "Memory allocation failed for outer_map_keys or inner_map_fds",
+	      "error=3D%s\n", strerror(errno));
+
+	create_inner_maps(inner_map_type, inner_map_fds);
+
+	outer_map_fd =3D create_outer_map(outer_map_type, *inner_map_fds);
+	/* create outer map keys */
+	for (map_index =3D 0; map_index < max_entries; map_index++)
+		outer_map_keys[map_index] =3D
+			((outer_map_type =3D=3D BPF_MAP_TYPE_ARRAY_OF_MAPS)
+			 ? 9 : 1000) - map_index;
+
+	/* batch operation - map_update */
+	ret =3D bpf_map_update_batch(outer_map_fd, outer_map_keys,
+				   inner_map_fds, &max_entries, &opts);
+	CHECK(ret !=3D 0,
+	      "Failed to update the outer map batch ops",
+	      "error=3D%s\n", strerror(errno));
+
+	/* batch operation - map_lookup */
+	for (op_index =3D 0; op_index < 2; ++op_index)
+		fetch_and_validate(outer_map_fd, inner_map_fds, &opts,
+				   batch_size[op_index], false);
+
+	/* batch operation - map_lookup_delete */
+	if (outer_map_type =3D=3D BPF_MAP_TYPE_HASH_OF_MAPS)
+		fetch_and_validate(outer_map_fd, inner_map_fds, &opts,
+				   max_entries, true /*delete*/);
+
+	free(inner_map_fds);
+	free(outer_map_keys);
+}
+
+void test_map_in_map_batch_ops_array(void)
+{
+	_map_in_map_batch_ops(BPF_MAP_TYPE_ARRAY_OF_MAPS, BPF_MAP_TYPE_ARRAY);
+	printf("%s:PASS with inner ARRAY map\n", __func__);
+	_map_in_map_batch_ops(BPF_MAP_TYPE_ARRAY_OF_MAPS, BPF_MAP_TYPE_HASH);
+	printf("%s:PASS with inner HASH map\n", __func__);
+}
+
+void test_map_in_map_batch_ops_hash(void)
+{
+	_map_in_map_batch_ops(BPF_MAP_TYPE_HASH_OF_MAPS, BPF_MAP_TYPE_ARRAY);
+	printf("%s:PASS with inner ARRAY map\n", __func__);
+	_map_in_map_batch_ops(BPF_MAP_TYPE_HASH_OF_MAPS, BPF_MAP_TYPE_HASH);
+	printf("%s:PASS with inner HASH map\n", __func__);
+}
--=20
2.30.2

