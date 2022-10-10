Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487D75F9FD5
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJJOIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiJJOIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:08:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EAB6E8BA;
        Mon, 10 Oct 2022 07:08:06 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MmLH63vTnz1M7ts;
        Mon, 10 Oct 2022 22:03:30 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 10 Oct
 2022 22:08:01 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH bpf v3 1/6] libbpf: Fix use-after-free in btf_dump_name_dups
Date:   Mon, 10 Oct 2022 10:25:48 -0400
Message-ID: <20221010142553.776550-2-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010142553.776550-1-xukuohai@huawei.com>
References: <20221010142553.776550-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASAN reports an use-after-free in btf_dump_name_dups:

ERROR: AddressSanitizer: heap-use-after-free on address 0xffff927006db at pc 0xaaaab5dfb618 bp 0xffffdd89b890 sp 0xffffdd89b928
READ of size 2 at 0xffff927006db thread T0
    #0 0xaaaab5dfb614 in __interceptor_strcmp.part.0 (test_progs+0x21b614)
    #1 0xaaaab635f144 in str_equal_fn tools/lib/bpf/btf_dump.c:127
    #2 0xaaaab635e3e0 in hashmap_find_entry tools/lib/bpf/hashmap.c:143
    #3 0xaaaab635e72c in hashmap__find tools/lib/bpf/hashmap.c:212
    #4 0xaaaab6362258 in btf_dump_name_dups tools/lib/bpf/btf_dump.c:1525
    #5 0xaaaab636240c in btf_dump_resolve_name tools/lib/bpf/btf_dump.c:1552
    #6 0xaaaab6362598 in btf_dump_type_name tools/lib/bpf/btf_dump.c:1567
    #7 0xaaaab6360b48 in btf_dump_emit_struct_def tools/lib/bpf/btf_dump.c:912
    #8 0xaaaab6360630 in btf_dump_emit_type tools/lib/bpf/btf_dump.c:798
    #9 0xaaaab635f720 in btf_dump__dump_type tools/lib/bpf/btf_dump.c:282
    #10 0xaaaab608523c in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:236
    #11 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #12 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #13 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #14 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #15 0xaaaab5d65990  (test_progs+0x185990)

0xffff927006db is located 11 bytes inside of 16-byte region [0xffff927006d0,0xffff927006e0)
freed by thread T0 here:
    #0 0xaaaab5e2c7c4 in realloc (test_progs+0x24c7c4)
    #1 0xaaaab634f4a0 in libbpf_reallocarray tools/lib/bpf/libbpf_internal.h:191
    #2 0xaaaab634f840 in libbpf_add_mem tools/lib/bpf/btf.c:163
    #3 0xaaaab636643c in strset_add_str_mem tools/lib/bpf/strset.c:106
    #4 0xaaaab6366560 in strset__add_str tools/lib/bpf/strset.c:157
    #5 0xaaaab6352d70 in btf__add_str tools/lib/bpf/btf.c:1519
    #6 0xaaaab6353e10 in btf__add_field tools/lib/bpf/btf.c:2032
    #7 0xaaaab6084fcc in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:232
    #8 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #9 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #10 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #11 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #12 0xaaaab5d65990  (test_progs+0x185990)

previously allocated by thread T0 here:
    #0 0xaaaab5e2c7c4 in realloc (test_progs+0x24c7c4)
    #1 0xaaaab634f4a0 in libbpf_reallocarray tools/lib/bpf/libbpf_internal.h:191
    #2 0xaaaab634f840 in libbpf_add_mem tools/lib/bpf/btf.c:163
    #3 0xaaaab636643c in strset_add_str_mem tools/lib/bpf/strset.c:106
    #4 0xaaaab6366560 in strset__add_str tools/lib/bpf/strset.c:157
    #5 0xaaaab6352d70 in btf__add_str tools/lib/bpf/btf.c:1519
    #6 0xaaaab6353ff0 in btf_add_enum_common tools/lib/bpf/btf.c:2070
    #7 0xaaaab6354080 in btf__add_enum tools/lib/bpf/btf.c:2102
    #8 0xaaaab6082f50 in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:162
    #9 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #10 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #11 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #12 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #13 0xaaaab5d65990  (test_progs+0x185990)

The reason is that the key stored in hash table name_map is a string
address, and the string memory is allocated by realloc() function, when
the memory is resized by realloc() later, the old memory may be freed,
so the address stored in name_map references to a freed memory, causing
use-after-free.

Fix it by storing duplicated string address in name_map.

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 tools/lib/bpf/btf_dump.c | 47 +++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index e4da6de68d8f..8365d801cbd0 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -219,6 +219,17 @@ static int btf_dump_resize(struct btf_dump *d)
 	return 0;
 }
 
+static void btf_dump_free_names(struct hashmap *map)
+{
+	size_t bkt;
+	struct hashmap_entry *cur;
+
+	hashmap__for_each_entry(map, cur, bkt)
+		free((void *)cur->key);
+
+	hashmap__free(map);
+}
+
 void btf_dump__free(struct btf_dump *d)
 {
 	int i;
@@ -237,8 +248,8 @@ void btf_dump__free(struct btf_dump *d)
 	free(d->cached_names);
 	free(d->emit_queue);
 	free(d->decl_stack);
-	hashmap__free(d->type_names);
-	hashmap__free(d->ident_names);
+	btf_dump_free_names(d->type_names);
+	btf_dump_free_names(d->ident_names);
 
 	free(d);
 }
@@ -634,8 +645,8 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 
 static const char *btf_dump_type_name(struct btf_dump *d, __u32 id);
 static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id);
-static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
-				 const char *orig_name);
+static ssize_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
+				  const char *orig_name);
 
 static bool btf_dump_is_blacklisted(struct btf_dump *d, __u32 id)
 {
@@ -995,7 +1006,7 @@ static void btf_dump_emit_enum32_val(struct btf_dump *d,
 	bool is_signed = btf_kflag(t);
 	const char *fmt_str;
 	const char *name;
-	size_t dup_cnt;
+	ssize_t dup_cnt;
 	int i;
 
 	for (i = 0; i < vlen; i++, v++) {
@@ -1020,7 +1031,7 @@ static void btf_dump_emit_enum64_val(struct btf_dump *d,
 	bool is_signed = btf_kflag(t);
 	const char *fmt_str;
 	const char *name;
-	size_t dup_cnt;
+	ssize_t dup_cnt;
 	__u64 val;
 	int i;
 
@@ -1521,14 +1532,30 @@ static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
 }
 
 /* return number of duplicates (occurrences) of a given name */
-static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
-				 const char *orig_name)
+static ssize_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
+				  const char *orig_name)
 {
-	size_t dup_cnt = 0;
+	int err;
+	char *old_name;
+	char *new_name;
+	ssize_t dup_cnt = 0;
+
+	new_name = strdup(orig_name);
+	if (!new_name)
+		return -ENOMEM;
 
 	hashmap__find(name_map, orig_name, (void **)&dup_cnt);
 	dup_cnt++;
-	hashmap__set(name_map, orig_name, (void *)dup_cnt, NULL, NULL);
+
+	err = hashmap__set(name_map, new_name, (void *)dup_cnt,
+			   (const void **)&old_name, NULL);
+	if (err) {
+		free(new_name);
+		return err;
+	}
+
+	if (old_name)
+		free(old_name);
 
 	return dup_cnt;
 }
-- 
2.30.2

