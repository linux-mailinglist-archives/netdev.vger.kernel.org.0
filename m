Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A161BD1A0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2BVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgD2BV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1Ksca025127
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CiB71Z0cH5VMCNUaNt2j9d4S2oFfr1E9cbvvaQOge/Y=;
 b=Qirmxir3EC0e5i+bUHhN9tc+ixHUx2nS5c0IKFwSJ60Poy9U3de6LbS2Gov/iQsvtNsy
 yS2vTU7b28MTuNWKdEA3/XCk6NZK7eNG6j5qIzM+PQHcEl3D9Td5GyRCSqZE+8eAUiW1
 9yZf6at+2R/kk+P0Wah9p2j1B/tNgbXZhPg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qbbp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:26 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5DC062EC30E4; Tue, 28 Apr 2020 18:21:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 03/11] selftests/bpf: convert test_hashmap into test_progs test
Date:   Tue, 28 Apr 2020 18:21:03 -0700
Message-ID: <20200429012111.277390-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fold stand-alone test_hashmap test into test_progs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   2 -
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../{test_hashmap.c =3D> prog_tests/hashmap.c}  | 280 +++++++++---------
 3 files changed, 140 insertions(+), 144 deletions(-)
 rename tools/testing/selftests/bpf/{test_hashmap.c =3D> prog_tests/hashm=
ap.c} (53%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index c30079c86998..16b9774d8b68 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -30,8 +30,6 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-test_hashmap
-test_btf_dump
 test_current_pid_tgid_new_ns
 xdping
 test_cpp
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 887f06a514ee..10f12a5aac20 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -33,7 +33,7 @@ TEST_GEN_PROGS =3D test_verifier test_tag test_maps tes=
t_lru_map test_lpm_map test
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
-	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashm=
ap \
+	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
 	test_progs-no_alu32 \
 	test_current_pid_tgid_new_ns
=20
diff --git a/tools/testing/selftests/bpf/test_hashmap.c b/tools/testing/s=
elftests/bpf/prog_tests/hashmap.c
similarity index 53%
rename from tools/testing/selftests/bpf/test_hashmap.c
rename to tools/testing/selftests/bpf/prog_tests/hashmap.c
index c490e012c23f..428d488830c6 100644
--- a/tools/testing/selftests/bpf/test_hashmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/hashmap.c
@@ -5,26 +5,17 @@
  *
  * Copyright (c) 2019 Facebook
  */
-#include <stdio.h>
-#include <errno.h>
-#include <linux/err.h>
+#include "test_progs.h"
 #include "bpf/hashmap.h"
=20
-#define CHECK(condition, format...) ({					\
-	int __ret =3D !!(condition);					\
-	if (__ret) {							\
-		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
-		fprintf(stderr, format);				\
-	}								\
-	__ret;								\
-})
+static int duration =3D 0;
=20
-size_t hash_fn(const void *k, void *ctx)
+static size_t hash_fn(const void *k, void *ctx)
 {
 	return (long)k;
 }
=20
-bool equal_fn(const void *a, const void *b, void *ctx)
+static bool equal_fn(const void *a, const void *b, void *ctx)
 {
 	return (long)a =3D=3D (long)b;
 }
@@ -49,53 +40,55 @@ static inline size_t exp_cap(size_t sz)
=20
 #define ELEM_CNT 62
=20
-int test_hashmap_generic(void)
+static void test_hashmap_generic(void)
 {
 	struct hashmap_entry *entry, *tmp;
 	int err, bkt, found_cnt, i;
 	long long found_msk;
 	struct hashmap *map;
=20
-	fprintf(stderr, "%s: ", __func__);
-
 	map =3D hashmap__new(hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
-		return 1;
+	if (CHECK(IS_ERR(map), "hashmap__new",
+		  "failed to create map: %ld\n", PTR_ERR(map)))
+		return;
=20
 	for (i =3D 0; i < ELEM_CNT; i++) {
 		const void *oldk, *k =3D (const void *)(long)i;
 		void *oldv, *v =3D (void *)(long)(1024 + i);
=20
 		err =3D hashmap__update(map, k, v, &oldk, &oldv);
-		if (CHECK(err !=3D -ENOENT, "unexpected result: %d\n", err))
-			return 1;
+		if (CHECK(err !=3D -ENOENT, "hashmap__update",
+			  "unexpected result: %d\n", err))
+			goto cleanup;
=20
 		if (i % 2) {
 			err =3D hashmap__add(map, k, v);
 		} else {
 			err =3D hashmap__set(map, k, v, &oldk, &oldv);
-			if (CHECK(oldk !=3D NULL || oldv !=3D NULL,
+			if (CHECK(oldk !=3D NULL || oldv !=3D NULL, "check_kv",
 				  "unexpected k/v: %p=3D%p\n", oldk, oldv))
-				return 1;
+				goto cleanup;
 		}
=20
-		if (CHECK(err, "failed to add k/v %ld =3D %ld: %d\n",
+		if (CHECK(err, "elem_add", "failed to add k/v %ld =3D %ld: %d\n",
 			       (long)k, (long)v, err))
-			return 1;
+			goto cleanup;
=20
-		if (CHECK(!hashmap__find(map, k, &oldv),
+		if (CHECK(!hashmap__find(map, k, &oldv), "elem_find",
 			  "failed to find key %ld\n", (long)k))
-			return 1;
-		if (CHECK(oldv !=3D v, "found value is wrong: %ld\n", (long)oldv))
-			return 1;
+			goto cleanup;
+		if (CHECK(oldv !=3D v, "elem_val",
+			  "found value is wrong: %ld\n", (long)oldv))
+			goto cleanup;
 	}
=20
-	if (CHECK(hashmap__size(map) !=3D ELEM_CNT,
+	if (CHECK(hashmap__size(map) !=3D ELEM_CNT, "hashmap__size",
 		  "invalid map size: %zu\n", hashmap__size(map)))
-		return 1;
+		goto cleanup;
 	if (CHECK(hashmap__capacity(map) !=3D exp_cap(hashmap__size(map)),
+		  "hashmap_cap",
 		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
-		return 1;
+		goto cleanup;
=20
 	found_msk =3D 0;
 	hashmap__for_each_entry(map, entry, bkt) {
@@ -103,42 +96,47 @@ int test_hashmap_generic(void)
 		long v =3D (long)entry->value;
=20
 		found_msk |=3D 1ULL << k;
-		if (CHECK(v - k !=3D 1024, "invalid k/v pair: %ld =3D %ld\n", k, v))
-			return 1;
+		if (CHECK(v - k !=3D 1024, "check_kv",
+			  "invalid k/v pair: %ld =3D %ld\n", k, v))
+			goto cleanup;
 	}
-	if (CHECK(found_msk !=3D (1ULL << ELEM_CNT) - 1,
+	if (CHECK(found_msk !=3D (1ULL << ELEM_CNT) - 1, "elem_cnt",
 		  "not all keys iterated: %llx\n", found_msk))
-		return 1;
+		goto cleanup;
=20
 	for (i =3D 0; i < ELEM_CNT; i++) {
 		const void *oldk, *k =3D (const void *)(long)i;
 		void *oldv, *v =3D (void *)(long)(256 + i);
=20
 		err =3D hashmap__add(map, k, v);
-		if (CHECK(err !=3D -EEXIST, "unexpected add result: %d\n", err))
-			return 1;
+		if (CHECK(err !=3D -EEXIST, "hashmap__add",
+			  "unexpected add result: %d\n", err))
+			goto cleanup;
=20
 		if (i % 2)
 			err =3D hashmap__update(map, k, v, &oldk, &oldv);
 		else
 			err =3D hashmap__set(map, k, v, &oldk, &oldv);
=20
-		if (CHECK(err, "failed to update k/v %ld =3D %ld: %d\n",
-			       (long)k, (long)v, err))
-			return 1;
-		if (CHECK(!hashmap__find(map, k, &oldv),
+		if (CHECK(err, "elem_upd",
+			  "failed to update k/v %ld =3D %ld: %d\n",
+			  (long)k, (long)v, err))
+			goto cleanup;
+		if (CHECK(!hashmap__find(map, k, &oldv), "elem_find",
 			  "failed to find key %ld\n", (long)k))
-			return 1;
-		if (CHECK(oldv !=3D v, "found value is wrong: %ld\n", (long)oldv))
-			return 1;
+			goto cleanup;
+		if (CHECK(oldv !=3D v, "elem_val",
+			  "found value is wrong: %ld\n", (long)oldv))
+			goto cleanup;
 	}
=20
-	if (CHECK(hashmap__size(map) !=3D ELEM_CNT,
+	if (CHECK(hashmap__size(map) !=3D ELEM_CNT, "hashmap__size",
 		  "invalid updated map size: %zu\n", hashmap__size(map)))
-		return 1;
+		goto cleanup;
 	if (CHECK(hashmap__capacity(map) !=3D exp_cap(hashmap__size(map)),
+		  "hashmap__capacity",
 		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
-		return 1;
+		goto cleanup;
=20
 	found_msk =3D 0;
 	hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
@@ -146,20 +144,21 @@ int test_hashmap_generic(void)
 		long v =3D (long)entry->value;
=20
 		found_msk |=3D 1ULL << k;
-		if (CHECK(v - k !=3D 256,
+		if (CHECK(v - k !=3D 256, "elem_check",
 			  "invalid updated k/v pair: %ld =3D %ld\n", k, v))
-			return 1;
+			goto cleanup;
 	}
-	if (CHECK(found_msk !=3D (1ULL << ELEM_CNT) - 1,
+	if (CHECK(found_msk !=3D (1ULL << ELEM_CNT) - 1, "elem_cnt",
 		  "not all keys iterated after update: %llx\n", found_msk))
-		return 1;
+		goto cleanup;
=20
 	found_cnt =3D 0;
 	hashmap__for_each_key_entry(map, entry, (void *)0) {
 		found_cnt++;
 	}
-	if (CHECK(!found_cnt, "didn't find any entries for key 0\n"))
-		return 1;
+	if (CHECK(!found_cnt, "found_cnt",
+		  "didn't find any entries for key 0\n"))
+		goto cleanup;
=20
 	found_msk =3D 0;
 	found_cnt =3D 0;
@@ -173,30 +172,31 @@ int test_hashmap_generic(void)
 		found_cnt++;
 		found_msk |=3D 1ULL << (long)k;
=20
-		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
+		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv), "elem_del",
 			  "failed to delete k/v %ld =3D %ld\n",
 			  (long)k, (long)v))
-			return 1;
-		if (CHECK(oldk !=3D k || oldv !=3D v,
+			goto cleanup;
+		if (CHECK(oldk !=3D k || oldv !=3D v, "check_old",
 			  "invalid deleted k/v: expected %ld =3D %ld, got %ld =3D %ld\n",
 			  (long)k, (long)v, (long)oldk, (long)oldv))
-			return 1;
-		if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
+			goto cleanup;
+		if (CHECK(hashmap__delete(map, k, &oldk, &oldv), "elem_del",
 			  "unexpectedly deleted k/v %ld =3D %ld\n",
 			  (long)oldk, (long)oldv))
-			return 1;
+			goto cleanup;
 	}
=20
-	if (CHECK(!found_cnt || !found_msk,
+	if (CHECK(!found_cnt || !found_msk, "found_entries",
 		  "didn't delete any key entries\n"))
-		return 1;
-	if (CHECK(hashmap__size(map) !=3D ELEM_CNT - found_cnt,
+		goto cleanup;
+	if (CHECK(hashmap__size(map) !=3D ELEM_CNT - found_cnt, "elem_cnt",
 		  "invalid updated map size (already deleted: %d): %zu\n",
 		  found_cnt, hashmap__size(map)))
-		return 1;
+		goto cleanup;
 	if (CHECK(hashmap__capacity(map) !=3D exp_cap(hashmap__size(map)),
+		  "hashmap__capacity",
 		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
-		return 1;
+		goto cleanup;
=20
 	hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
 		const void *oldk, *k;
@@ -208,53 +208,56 @@ int test_hashmap_generic(void)
 		found_cnt++;
 		found_msk |=3D 1ULL << (long)k;
=20
-		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
+		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv), "elem_del",
 			  "failed to delete k/v %ld =3D %ld\n",
 			  (long)k, (long)v))
-			return 1;
-		if (CHECK(oldk !=3D k || oldv !=3D v,
+			goto cleanup;
+		if (CHECK(oldk !=3D k || oldv !=3D v, "elem_check",
 			  "invalid old k/v: expect %ld =3D %ld, got %ld =3D %ld\n",
 			  (long)k, (long)v, (long)oldk, (long)oldv))
-			return 1;
-		if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
+			goto cleanup;
+		if (CHECK(hashmap__delete(map, k, &oldk, &oldv), "elem_del",
 			  "unexpectedly deleted k/v %ld =3D %ld\n",
 			  (long)k, (long)v))
-			return 1;
+			goto cleanup;
 	}
=20
 	if (CHECK(found_cnt !=3D ELEM_CNT || found_msk !=3D (1ULL << ELEM_CNT) =
- 1,
+		  "found_cnt",
 		  "not all keys were deleted: found_cnt:%d, found_msk:%llx\n",
 		  found_cnt, found_msk))
-		return 1;
-	if (CHECK(hashmap__size(map) !=3D 0,
+		goto cleanup;
+	if (CHECK(hashmap__size(map) !=3D 0, "hashmap__size",
 		  "invalid updated map size (already deleted: %d): %zu\n",
 		  found_cnt, hashmap__size(map)))
-		return 1;
+		goto cleanup;
=20
 	found_cnt =3D 0;
 	hashmap__for_each_entry(map, entry, bkt) {
-		CHECK(false, "unexpected map entries left: %ld =3D %ld\n",
-			     (long)entry->key, (long)entry->value);
-		return 1;
+		CHECK(false, "elem_exists",
+		      "unexpected map entries left: %ld =3D %ld\n",
+		      (long)entry->key, (long)entry->value);
+		goto cleanup;
 	}
=20
-	hashmap__free(map);
+	hashmap__clear(map);
 	hashmap__for_each_entry(map, entry, bkt) {
-		CHECK(false, "unexpected map entries left: %ld =3D %ld\n",
-			     (long)entry->key, (long)entry->value);
-		return 1;
+		CHECK(false, "elem_exists",
+		      "unexpected map entries left: %ld =3D %ld\n",
+		      (long)entry->key, (long)entry->value);
+		goto cleanup;
 	}
=20
-	fprintf(stderr, "OK\n");
-	return 0;
+cleanup:
+	hashmap__free(map);
 }
=20
-size_t collision_hash_fn(const void *k, void *ctx)
+static size_t collision_hash_fn(const void *k, void *ctx)
 {
 	return 0;
 }
=20
-int test_hashmap_multimap(void)
+static void test_hashmap_multimap(void)
 {
 	void *k1 =3D (void *)0, *k2 =3D (void *)1;
 	struct hashmap_entry *entry;
@@ -262,121 +265,116 @@ int test_hashmap_multimap(void)
 	long found_msk;
 	int err, bkt;
=20
-	fprintf(stderr, "%s: ", __func__);
-
 	/* force collisions */
 	map =3D hashmap__new(collision_hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
-		return 1;
-
+	if (CHECK(IS_ERR(map), "hashmap__new",
+		  "failed to create map: %ld\n", PTR_ERR(map)))
+		return;
=20
 	/* set up multimap:
 	 * [0] -> 1, 2, 4;
 	 * [1] -> 8, 16, 32;
 	 */
 	err =3D hashmap__append(map, k1, (void *)1);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
 	err =3D hashmap__append(map, k1, (void *)2);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
 	err =3D hashmap__append(map, k1, (void *)4);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
=20
 	err =3D hashmap__append(map, k2, (void *)8);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
 	err =3D hashmap__append(map, k2, (void *)16);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
 	err =3D hashmap__append(map, k2, (void *)32);
-	if (CHECK(err, "failed to add k/v: %d\n", err))
-		return 1;
+	if (CHECK(err, "elem_add", "failed to add k/v: %d\n", err))
+		goto cleanup;
=20
-	if (CHECK(hashmap__size(map) !=3D 6,
+	if (CHECK(hashmap__size(map) !=3D 6, "hashmap_size",
 		  "invalid map size: %zu\n", hashmap__size(map)))
-		return 1;
+		goto cleanup;
=20
 	/* verify global iteration still works and sees all values */
 	found_msk =3D 0;
 	hashmap__for_each_entry(map, entry, bkt) {
 		found_msk |=3D (long)entry->value;
 	}
-	if (CHECK(found_msk !=3D (1 << 6) - 1,
+	if (CHECK(found_msk !=3D (1 << 6) - 1, "found_msk",
 		  "not all keys iterated: %lx\n", found_msk))
-		return 1;
+		goto cleanup;
=20
 	/* iterate values for key 1 */
 	found_msk =3D 0;
 	hashmap__for_each_key_entry(map, entry, k1) {
 		found_msk |=3D (long)entry->value;
 	}
-	if (CHECK(found_msk !=3D (1 | 2 | 4),
+	if (CHECK(found_msk !=3D (1 | 2 | 4), "found_msk",
 		  "invalid k1 values: %lx\n", found_msk))
-		return 1;
+		goto cleanup;
=20
 	/* iterate values for key 2 */
 	found_msk =3D 0;
 	hashmap__for_each_key_entry(map, entry, k2) {
 		found_msk |=3D (long)entry->value;
 	}
-	if (CHECK(found_msk !=3D (8 | 16 | 32),
+	if (CHECK(found_msk !=3D (8 | 16 | 32), "found_msk",
 		  "invalid k2 values: %lx\n", found_msk))
-		return 1;
+		goto cleanup;
=20
-	fprintf(stderr, "OK\n");
-	return 0;
+cleanup:
+	hashmap__free(map);
 }
=20
-int test_hashmap_empty()
+static void test_hashmap_empty()
 {
 	struct hashmap_entry *entry;
 	int bkt;
 	struct hashmap *map;
 	void *k =3D (void *)0;
=20
-	fprintf(stderr, "%s: ", __func__);
-
 	/* force collisions */
 	map =3D hashmap__new(hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
-		return 1;
+	if (CHECK(IS_ERR(map), "hashmap__new",
+		  "failed to create map: %ld\n", PTR_ERR(map)))
+		goto cleanup;
=20
-	if (CHECK(hashmap__size(map) !=3D 0,
+	if (CHECK(hashmap__size(map) !=3D 0, "hashmap__size",
 		  "invalid map size: %zu\n", hashmap__size(map)))
-		return 1;
-	if (CHECK(hashmap__capacity(map) !=3D 0,
+		goto cleanup;
+	if (CHECK(hashmap__capacity(map) !=3D 0, "hashmap__capacity",
 		  "invalid map capacity: %zu\n", hashmap__capacity(map)))
-		return 1;
-	if (CHECK(hashmap__find(map, k, NULL), "unexpected find\n"))
-		return 1;
-	if (CHECK(hashmap__delete(map, k, NULL, NULL), "unexpected delete\n"))
-		return 1;
+		goto cleanup;
+	if (CHECK(hashmap__find(map, k, NULL), "elem_find",
+		  "unexpected find\n"))
+		goto cleanup;
+	if (CHECK(hashmap__delete(map, k, NULL, NULL), "elem_del",
+		  "unexpected delete\n"))
+		goto cleanup;
=20
 	hashmap__for_each_entry(map, entry, bkt) {
-		CHECK(false, "unexpected iterated entry\n");
-		return 1;
+		CHECK(false, "elem_found", "unexpected iterated entry\n");
+		goto cleanup;
 	}
 	hashmap__for_each_key_entry(map, entry, k) {
-		CHECK(false, "unexpected key entry\n");
-		return 1;
+		CHECK(false, "key_found", "unexpected key entry\n");
+		goto cleanup;
 	}
=20
-	fprintf(stderr, "OK\n");
-	return 0;
+cleanup:
+	hashmap__free(map);
 }
=20
-int main(int argc, char **argv)
+void test_hashmap()
 {
-	bool failed =3D false;
-
-	if (test_hashmap_generic())
-		failed =3D true;
-	if (test_hashmap_multimap())
-		failed =3D true;
-	if (test_hashmap_empty())
-		failed =3D true;
-
-	return failed;
+	if (test__start_subtest("generic"))
+		test_hashmap_generic();
+	if (test__start_subtest("multimap"))
+		test_hashmap_multimap();
+	if (test__start_subtest("empty"))
+		test_hashmap_empty();
 }
--=20
2.24.1

