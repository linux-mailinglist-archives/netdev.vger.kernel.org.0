Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE6509C8C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387787AbiDUJqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387775AbiDUJqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B6CF24961
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 02:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650534209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CyDh3hl+YzWggwwXxS6GM8Fx57mAYVs3NhlXvVZSunA=;
        b=jR+r0F83ZMdfJPc8hHs3gexOBIoNaQXMgmWndCwr+W4bX9IjMTxEz6mrlUy/QSv/oLwAZt
        HEwzfN8LNA5doMSUMxo/3BmMIw9sVaO/m2ptfE4bqifj8+JS3wV3FFX0c/GFQIP5BzBfYd
        qtPB2SMPY4Ug23Xe3WTPKpyOXR+SyPQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-dvVnHdHMMfCpxUDiU8dbvA-1; Thu, 21 Apr 2022 05:43:23 -0400
X-MC-Unique: dvVnHdHMMfCpxUDiU8dbvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E6DA86B8A3;
        Thu, 21 Apr 2022 09:43:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8F5C40EC002;
        Thu, 21 Apr 2022 09:43:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id D6EDA1C016C; Thu, 21 Apr 2022 11:43:21 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: fix map tests errno checks
Date:   Thu, 21 Apr 2022 11:43:20 +0200
Message-Id: <20220421094320.1563570-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switching to libbpf 1.0 API broke test_lpm_map and test_lru_map as error
reporting changed. Instead of setting errno and returning -1 bpf calls
now return -Exxx directly.
Drop errno checks and look at return code directly.

Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/test_lpm_map.c | 39 +++++--------
 tools/testing/selftests/bpf/test_lru_map.c | 66 ++++++++--------------
 2 files changed, 37 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index 789c9748d241..c028d621c744 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -408,16 +408,13 @@ static void test_lpm_ipaddr(void)
 
 	/* Test some lookups that should not match any entry */
 	inet_pton(AF_INET, "10.0.0.1", key_ipv4->data);
-	assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -ENOENT);
 
 	inet_pton(AF_INET, "11.11.11.11", key_ipv4->data);
-	assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -ENOENT);
 
 	inet_pton(AF_INET6, "2a00:ffff::", key_ipv6->data);
-	assert(bpf_map_lookup_elem(map_fd_ipv6, key_ipv6, &value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd_ipv6, key_ipv6, &value) == -ENOENT);
 
 	close(map_fd_ipv4);
 	close(map_fd_ipv6);
@@ -474,18 +471,15 @@ static void test_lpm_delete(void)
 	/* remove non-existent node */
 	key->prefixlen = 32;
 	inet_pton(AF_INET, "10.0.0.1", key->data);
-	assert(bpf_map_lookup_elem(map_fd, key, &value) == -1 &&
-		errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd, key, &value) == -ENOENT);
 
 	key->prefixlen = 30; // unused prefix so far
 	inet_pton(AF_INET, "192.255.0.0", key->data);
-	assert(bpf_map_delete_elem(map_fd, key) == -1 &&
-		errno == ENOENT);
+	assert(bpf_map_delete_elem(map_fd, key) == -ENOENT);
 
 	key->prefixlen = 16; // same prefix as the root node
 	inet_pton(AF_INET, "192.255.0.0", key->data);
-	assert(bpf_map_delete_elem(map_fd, key) == -1 &&
-		errno == ENOENT);
+	assert(bpf_map_delete_elem(map_fd, key) == -ENOENT);
 
 	/* assert initial lookup */
 	key->prefixlen = 32;
@@ -530,8 +524,7 @@ static void test_lpm_delete(void)
 
 	key->prefixlen = 32;
 	inet_pton(AF_INET, "192.168.128.1", key->data);
-	assert(bpf_map_lookup_elem(map_fd, key, &value) == -1 &&
-		errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd, key, &value) == -ENOENT);
 
 	close(map_fd);
 }
@@ -552,8 +545,7 @@ static void test_lpm_get_next_key(void)
 	assert(map_fd >= 0);
 
 	/* empty tree. get_next_key should return ENOENT */
-	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == -ENOENT);
 
 	/* get and verify the first key, get the second one should fail. */
 	key_p->prefixlen = 16;
@@ -565,8 +557,7 @@ static void test_lpm_get_next_key(void)
 	assert(key_p->prefixlen == 16 && key_p->data[0] == 192 &&
 	       key_p->data[1] == 168);
 
-	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
 
 	/* no exact matching key should get the first one in post order. */
 	key_p->prefixlen = 8;
@@ -590,8 +581,7 @@ static void test_lpm_get_next_key(void)
 	       next_key_p->data[1] == 168);
 
 	memcpy(key_p, next_key_p, key_size);
-	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
 
 	/* Add one more element (total three) */
 	key_p->prefixlen = 24;
@@ -614,8 +604,7 @@ static void test_lpm_get_next_key(void)
 	       next_key_p->data[1] == 168);
 
 	memcpy(key_p, next_key_p, key_size);
-	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
 
 	/* Add one more element (total four) */
 	key_p->prefixlen = 24;
@@ -643,8 +632,7 @@ static void test_lpm_get_next_key(void)
 	       next_key_p->data[1] == 168);
 
 	memcpy(key_p, next_key_p, key_size);
-	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
 
 	/* Add one more element (total five) */
 	key_p->prefixlen = 28;
@@ -678,8 +666,7 @@ static void test_lpm_get_next_key(void)
 	       next_key_p->data[1] == 168);
 
 	memcpy(key_p, next_key_p, key_size);
-	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
 
 	/* no exact matching key should return the first one in post order */
 	key_p->prefixlen = 22;
diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index a6aa2d121955..4d0650cfb5cd 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -175,24 +175,20 @@ static void test_lru_sanity0(int map_type, int map_flags)
 				    BPF_NOEXIST));
 
 	/* BPF_NOEXIST means: add new element if it doesn't exist */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
-	       /* key=1 already exists */
-	       && errno == EEXIST);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
+	/* key=1 already exists */
 
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, -1) == -1 &&
-	       errno == EINVAL);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, -1) == -EINVAL);
 
 	/* insert key=2 element */
 
 	/* check that key=2 is not found */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* BPF_EXIST means: update existing element */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
-	       /* key=2 is not there */
-	       errno == ENOENT);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
+	/* key=2 is not there */
 
 	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
 
@@ -200,8 +196,7 @@ static void test_lru_sanity0(int map_type, int map_flags)
 
 	/* check that key=3 is not found */
 	key = 3;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* check that key=1 can be found and mark the ref bit to
 	 * stop LRU from removing key=1
@@ -217,8 +212,7 @@ static void test_lru_sanity0(int map_type, int map_flags)
 
 	/* key=2 has been removed from the LRU */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* lookup elem key=1 and delete it, then check it doesn't exist */
 	key = 1;
@@ -381,8 +375,7 @@ static void test_lru_sanity2(int map_type, int map_flags, unsigned int tgt_free)
 	end_key = 1 + batch_size;
 	value[0] = 4321;
 	for (key = 1; key < end_key; key++) {
-		assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-		       errno == ENOENT);
+		assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 		assert(!bpf_map_update_elem(lru_map_fd, &key, value,
 					    BPF_NOEXIST));
 		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
@@ -562,8 +555,7 @@ static void do_test_lru_sanity5(unsigned long long last_key, int map_fd)
 	assert(!bpf_map_lookup_elem_with_ref_bit(map_fd, key, value));
 
 	/* Cannot find the last key because it was removed by LRU */
-	assert(bpf_map_lookup_elem(map_fd, &last_key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(map_fd, &last_key, value) == -ENOENT);
 }
 
 /* Test map with only one element */
@@ -711,21 +703,18 @@ static void test_lru_sanity7(int map_type, int map_flags)
 				    BPF_NOEXIST));
 
 	/* BPF_NOEXIST means: add new element if it doesn't exist */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
-	       /* key=1 already exists */
-	       && errno == EEXIST);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
+	/* key=1 already exists */
 
 	/* insert key=2 element */
 
 	/* check that key=2 is not found */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* BPF_EXIST means: update existing element */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
-	       /* key=2 is not there */
-	       errno == ENOENT);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
+	/* key=2 is not there */
 
 	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
 
@@ -733,8 +722,7 @@ static void test_lru_sanity7(int map_type, int map_flags)
 
 	/* check that key=3 is not found */
 	key = 3;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* check that key=1 can be found and mark the ref bit to
 	 * stop LRU from removing key=1
@@ -757,8 +745,7 @@ static void test_lru_sanity7(int map_type, int map_flags)
 
 	/* key=2 has been removed from the LRU */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	assert(map_equal(lru_map_fd, expected_map_fd));
 
@@ -805,21 +792,18 @@ static void test_lru_sanity8(int map_type, int map_flags)
 	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
 
 	/* BPF_NOEXIST means: add new element if it doesn't exist */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
-	       /* key=1 already exists */
-	       && errno == EEXIST);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
+	/* key=1 already exists */
 
 	/* insert key=2 element */
 
 	/* check that key=2 is not found */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* BPF_EXIST means: update existing element */
-	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
-	       /* key=2 is not there */
-	       errno == ENOENT);
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
+	/* key=2 is not there */
 
 	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
 	assert(!bpf_map_update_elem(expected_map_fd, &key, value,
@@ -829,8 +813,7 @@ static void test_lru_sanity8(int map_type, int map_flags)
 
 	/* check that key=3 is not found */
 	key = 3;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	/* check that key=1 can be found and do _not_ mark ref bit.
 	 * this will be evicted on next update.
@@ -853,8 +836,7 @@ static void test_lru_sanity8(int map_type, int map_flags)
 
 	/* key=1 has been removed from the LRU */
 	key = 1;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
-	       errno == ENOENT);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
 
 	assert(map_equal(lru_map_fd, expected_map_fd));
 
-- 
2.35.1

