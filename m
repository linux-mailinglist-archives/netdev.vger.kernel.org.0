Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0D050ACF8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 02:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442991AbiDVAyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 20:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbiDVAx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 20:53:59 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73FF6398
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 17:51:07 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23LNWoPM004583
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 17:51:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3WGxdHxarxaW8PjuDsYbWnjeLLy1sQFj8j2bhlO2L5w=;
 b=AhqA/dloJG7QtRdzTwvQ6XC3VSM6ayqp3o1bQ+WXNTXG++kGuNDYsPFZcM6TkxZa8r0D
 hnQo3v5y0i/h8OXnHZ5m2/KikcbxHKTmvMr48tPsh8VToBR+28BgxUDy+wtsh47c7MEY
 2A/dS3X9IXKmQitoEYm0new2LxfBFeZAQas= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjsrk0tbn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 17:51:07 -0700
Received: from twshared5730.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 17:51:05 -0700
Received: by devvm4403.frc0.facebook.com (Postfix, from userid 153359)
        id 53FC15F56A21; Thu, 21 Apr 2022 17:51:01 -0700 (PDT)
From:   Takshak Chahande <ctakshak@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <kernel-team@fb.com>,
        <ctakshak@fb.com>, <ndixit@fb.com>, <kafai@fb.com>,
        <andriin@fb.com>
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: handle batch operations for map-in-map bpf-maps
Date:   Thu, 21 Apr 2022 17:50:44 -0700
Message-ID: <20220422005044.4099919-2-ctakshak@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422005044.4099919-1-ctakshak@fb.com>
References: <20220422005044.4099919-1-ctakshak@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: srnBaAutY_iuejPOV6NvvA0QE4qmE7vC
X-Proofpoint-GUID: srnBaAutY_iuejPOV6NvvA0QE4qmE7vC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_06,2022-04-21_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes v1 =3D> v2:
1. Fixed no format arguments error (Andrii)

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
---
 .../bpf/map_tests/map_in_map_batch_ops.c      | 232 ++++++++++++++++++
 1 file changed, 232 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batc=
h_ops.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c=
 b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
new file mode 100644
index 000000000000..9b705ec9562e
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
@@ -0,0 +1,232 @@
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
+
+	LIBBPF_OPTS(bpf_map_create_opts, attr);
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
+	__u32 *fetched_keys, *fetched_values, fetched_entries =3D 0;
+	__u32 next_batch_key =3D 0, step_size =3D 5;
+	int err, retries =3D 0, max_retries =3D 3;
+	__u32 value_size =3D sizeof(__u32);
+
+	fetched_keys =3D calloc(batch_size, value_size);
+	fetched_values =3D calloc(batch_size, value_size);
+
+	while (fetched_entries < batch_size) {
+		err =3D delete_entries
+		      ? bpf_map_lookup_and_delete_batch(outer_map_fd,
+				      fetched_entries ? &next_batch_key : NULL,
+				      &next_batch_key,
+				      fetched_keys + fetched_entries,
+				      fetched_values + fetched_entries,
+				      &step_size, opts)
+		      : bpf_map_lookup_batch(outer_map_fd,
+				      fetched_entries ? &next_batch_key : NULL,
+				      &next_batch_key,
+				      fetched_keys + fetched_entries,
+				      fetched_values + fetched_entries,
+				      &step_size, opts);
+		CHECK((err < 0 && (errno !=3D ENOENT && errno !=3D ENOSPC)),
+		      "lookup with steps failed",
+		      "error: %s\n", strerror(errno));
+
+		fetched_entries +=3D step_size;
+		/* retry for max_retries if ENOSPC */
+		if (errno =3D=3D ENOSPC)
+			++retries;
+
+		if (retries >=3D max_retries)
+			break;
+	}
+
+	CHECK((fetched_entries !=3D batch_size && err !=3D ENOSPC),
+	      "Unable to fetch expected entries !",
+	      "fetched_entries(%d) and batch_size(%d) error: (%d):%s\n",
+	      fetched_entries, batch_size, errno, strerror(errno));
+
+	/* validate the fetched entries */
+	validate_fetch_results(outer_map_fd, inner_map_fds, fetched_keys,
+			       fetched_values, fetched_entries);
+	printf("batch_op is successful for batch_size(%d)\n", batch_size);
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
+	__u32 value_size =3D sizeof(__u32);
+	int batch_size[2] =3D {5, 10};
+	__u32 map_index, op_index;
+	int outer_map_fd, ret;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+			    .elem_flags =3D 0,
+			    .flags =3D 0,
+	);
+
+	outer_map_keys =3D calloc(max_entries, value_size);
+	inner_map_fds =3D calloc(max_entries, value_size);
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

