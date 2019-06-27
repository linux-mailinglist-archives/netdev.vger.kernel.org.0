Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F357860
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfF0AdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfF0AdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:07 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A5F620659;
        Thu, 27 Jun 2019 00:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595586;
        bh=ey4XY2fnHSK9yr28cRRuMCpnQpVzKjWWw7EuES0fdwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8HKxGB1F4gC8VVua5gvEpOGtveAM0XrJawNFYjqTTQC+SiCt2idCg1zgiN5OIug9
         yEMrXeWSfr23/EEoXPpOFxS6QQeN2YznKe9ir2PoMCPhbIkHcemc5ZyZGH6NbcboP9
         +FntaPMvnRUp0INpCT87ysTn0dpYz7/bV8Rbuqdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 48/95] bpf: lpm_trie: check left child of last leftmost node for NULL
Date:   Wed, 26 Jun 2019 20:29:33 -0400
Message-Id: <20190627003021.19867-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit da2577fdd0932ea4eefe73903f1130ee366767d2 ]

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

Fixes: b471f2f1de8b ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c                      |  9 +++--
 tools/testing/selftests/bpf/test_lpm_map.c | 41 ++++++++++++++++++++--
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 93a5cbbde421..3b03a7342f3c 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -715,9 +715,14 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
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
2.20.1

