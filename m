Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152963A1BA
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 21:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfFHTy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 15:54:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727684AbfFHTyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 15:54:23 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x58JoANG027523
        for <netdev@vger.kernel.org>; Sat, 8 Jun 2019 12:54:22 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t08b318v6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 12:54:22 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 8 Jun 2019 12:54:20 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 9658B23490D34; Sat,  8 Jun 2019 12:54:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <yhs@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v2 bpf] bpf: lpm_trie: check left child of last leftmost node for NULL
Date:   Sat, 8 Jun 2019 12:54:19 -0700
Message-ID: <20190608195419.1137313-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=677 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the leftmost parent node of the tree has does not have a child
on the left side, then trie_get_next_key (and bpftool map dump) will
not look at the child on the right.  This leads to the traversal
missing elements.

Lookup is not affected.

Update selftest to handle this case.

Reproducer:

 bpftool map create /sys/fs/bpf/lpm type lpm_trie key 6 \
     value 1 entries 256 name test_lpm flags 1
 bpftool map update pinned /sys/fs/bpf/lpm key  8 0 0 0  0   0 value 1
 bpftool map update pinned /sys/fs/bpf/lpm key 16 0 0 0  0 128 value 2
 bpftool map dump   pinned /sys/fs/bpf/lpm

Returns only 1 element. (2 expected)

Fixes: b471f2f1de8 ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/lpm_trie.c                      |  9 +++--
 tools/testing/selftests/bpf/test_lpm_map.c | 41 ++++++++++++++++++++--
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 09334f13a8a0..ec047a3658b4 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -710,9 +710,14 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 	 * have exact two children, so this function will never return NULL.
 	 */
 	for (node = search_root; node;) {
-		if (!(node->flags & LPM_TREE_NODE_FLAG_IM))
+		if (node->flags & LPM_TREE_NODE_FLAG_IM) {
+			node = rcu_dereference(node->child[0]);
+		} else {
 			next_node = node;
-		node = rcu_dereference(node->child[0]);
+			node = rcu_dereference(node->child[0]);
+			if (!node)
+				node = rcu_dereference(next_node->child[1]);
+		}
 	}
 do_copy:
 	next_key->prefixlen = next_node->prefixlen;
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index 02d7c871862a..006be3963977 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -573,13 +573,13 @@ static void test_lpm_get_next_key(void)
 
 	/* add one more element (total two) */
 	key_p->prefixlen = 24;
-	inet_pton(AF_INET, "192.168.0.0", key_p->data);
+	inet_pton(AF_INET, "192.168.128.0", key_p->data);
 	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
 
 	memset(key_p, 0, key_size);
 	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == 0);
 	assert(key_p->prefixlen == 24 && key_p->data[0] == 192 &&
-	       key_p->data[1] == 168 && key_p->data[2] == 0);
+	       key_p->data[1] == 168 && key_p->data[2] == 128);
 
 	memset(next_key_p, 0, key_size);
 	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
@@ -592,7 +592,7 @@ static void test_lpm_get_next_key(void)
 
 	/* Add one more element (total three) */
 	key_p->prefixlen = 24;
-	inet_pton(AF_INET, "192.168.128.0", key_p->data);
+	inet_pton(AF_INET, "192.168.0.0", key_p->data);
 	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
 
 	memset(key_p, 0, key_size);
@@ -643,6 +643,41 @@ static void test_lpm_get_next_key(void)
 	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
 	       errno == ENOENT);
 
+	/* Add one more element (total five) */
+	key_p->prefixlen = 28;
+	inet_pton(AF_INET, "192.168.1.128", key_p->data);
+	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
+
+	memset(key_p, 0, key_size);
+	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == 0);
+	assert(key_p->prefixlen == 24 && key_p->data[0] == 192 &&
+	       key_p->data[1] == 168 && key_p->data[2] == 0);
+
+	memset(next_key_p, 0, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 28 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 1 &&
+	       next_key_p->data[3] == 128);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 24 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 1);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 24 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 128);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 16 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
+	       errno == ENOENT);
+
 	/* no exact matching key should return the first one in post order */
 	key_p->prefixlen = 22;
 	inet_pton(AF_INET, "192.168.1.0", key_p->data);
-- 
2.17.1

