Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1321C39A28
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 04:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfFHCod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 22:44:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728860AbfFHCoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 22:44:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x582hhAx023292
        for <netdev@vger.kernel.org>; Fri, 7 Jun 2019 19:44:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2syq412mtp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 19:44:31 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Jun 2019 19:44:30 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 43FE623416584; Fri,  7 Jun 2019 19:44:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <yhs@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH bpf] bpf: lpm_trie: check left child of root for NULL
Date:   Fri, 7 Jun 2019 19:44:28 -0700
Message-ID: <20190608024428.2379850-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=701 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the root of the tree has does not have any elements on the left
branch, then trie_get_next_key (and bpftool map dump) will not look
at the rightmost branch.  This leads to the traversal missing elements.

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
 kernel/bpf/lpm_trie.c                      | 9 +++++++--
 tools/testing/selftests/bpf/test_lpm_map.c | 6 +++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 09334f13a8a0..38c1397eef6d 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -657,8 +657,13 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 		return -ENOENT;
 
 	/* For invalid key, find the leftmost node in the trie */
-	if (!key || key->prefixlen > trie->max_prefixlen)
-		goto find_leftmost;
+	if (!key || key->prefixlen > trie->max_prefixlen) {
+		if (!rcu_dereference(search_root->child[0])) {
+			next_node = search_root;
+			search_root = rcu_dereference(search_root->child[1]);
+		}
+                goto find_leftmost;
+	}
 
 	node_stack = kmalloc_array(trie->max_prefixlen,
 				   sizeof(struct lpm_trie_node *),
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index 02d7c871862a..79410d3857c0 100644
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
-- 
2.17.1

