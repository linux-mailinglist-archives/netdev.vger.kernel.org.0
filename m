Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9084CDCDC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiCDSoU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Mar 2022 13:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiCDSoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:44:19 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F777DA9F
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:43:30 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 224HQlhd024692
        for <netdev@vger.kernel.org>; Fri, 4 Mar 2022 10:43:29 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ek4kfy8fx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 10:43:29 -0800
Received: from twshared33837.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 10:43:27 -0800
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 88A3E19D6D6E; Fri,  4 Mar 2022 10:43:22 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <edumazet@google.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH bpf-next] bpf: select proper size for bpf_prog_pack
Date:   Fri, 4 Mar 2022 10:43:20 -0800
Message-ID: <20220304184320.3424748-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7oWimjl0j_Neoptpt02pQ1aDxfDkFfNq
X-Proofpoint-GUID: 7oWimjl0j_Neoptpt02pQ1aDxfDkFfNq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=823 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040093
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
cases. Specifically, for NUMA systems, __vmalloc_node_range requires
PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
does not support huge pages (i.e., with cmdline option nohugevmalloc), it
is better to use PAGE_SIZE packs.

Add logic to select proper size for bpf_prog_pack. This solution is not
ideal, as it makes assumption about the behavior of module_alloc and
__vmalloc_node_range. However, it appears to be the easiest solution as
it doesn't require changes in module_alloc and vmalloc code.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 66 +++++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ab630f773ec1..957b198364eb 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -33,6 +33,7 @@
 #include <linux/extable.h>
 #include <linux/log2.h>
 #include <linux/bpf_verifier.h>
+#include <linux/nodemask.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -814,15 +815,9 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
  * to host BPF programs.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
-#else
-#define BPF_PROG_PACK_SIZE	PAGE_SIZE
-#endif
 #define BPF_PROG_CHUNK_SHIFT	6
 #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
 #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
-#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
 
 struct bpf_prog_pack {
 	struct list_head list;
@@ -830,30 +825,57 @@ struct bpf_prog_pack {
 	unsigned long bitmap[];
 };
 
-#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
 #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
 
+static size_t bpf_prog_pack_size = -1;
+
+static inline int bpf_prog_chunk_count(void)
+{
+	WARN_ON_ONCE(bpf_prog_pack_size == -1);
+	return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
+}
+
 static DEFINE_MUTEX(pack_mutex);
 static LIST_HEAD(pack_list);
 
 static struct bpf_prog_pack *alloc_new_pack(void)
 {
 	struct bpf_prog_pack *pack;
+	size_t size;
+	void *ptr;
 
-	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
-	if (!pack)
+	if (bpf_prog_pack_size == -1) {
+		/* Test whether we can get huge pages. If not just use
+		 * PAGE_SIZE packs.
+		 */
+		size = PMD_SIZE * num_online_nodes();
+		ptr = module_alloc(size);
+		if (ptr && is_vm_area_hugepages(ptr)) {
+			bpf_prog_pack_size = size;
+			goto got_ptr;
+		} else {
+			bpf_prog_pack_size = PAGE_SIZE;
+			vfree(ptr);
+		}
+	}
+
+	ptr = module_alloc(bpf_prog_pack_size);
+	if (!ptr)
 		return NULL;
-	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
-	if (!pack->ptr) {
-		kfree(pack);
+got_ptr:
+	pack = kzalloc(struct_size(pack, bitmap, BITS_TO_LONGS(bpf_prog_chunk_count())),
+		       GFP_KERNEL);
+	if (!pack) {
+		vfree(ptr);
 		return NULL;
 	}
-	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
+	pack->ptr = ptr;
+	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
 	list_add_tail(&pack->list, &pack_list);
 
 	set_vm_flush_reset_perms(pack->ptr);
-	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
-	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
+	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
+	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
 	return pack;
 }
 
@@ -864,7 +886,7 @@ static void *bpf_prog_pack_alloc(u32 size)
 	unsigned long pos;
 	void *ptr = NULL;
 
-	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+	if (size > bpf_prog_pack_size) {
 		size = round_up(size, PAGE_SIZE);
 		ptr = module_alloc(size);
 		if (ptr) {
@@ -876,9 +898,9 @@ static void *bpf_prog_pack_alloc(u32 size)
 	}
 	mutex_lock(&pack_mutex);
 	list_for_each_entry(pack, &pack_list, list) {
-		pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
+		pos = bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
 						 nbits, 0);
-		if (pos < BPF_PROG_CHUNK_COUNT)
+		if (pos < bpf_prog_chunk_count())
 			goto found_free_area;
 	}
 
@@ -904,12 +926,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	unsigned long pos;
 	void *pack_ptr;
 
-	if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+	if (hdr->size > bpf_prog_pack_size) {
 		module_memfree(hdr);
 		return;
 	}
 
-	pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
+	pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size - 1));
 	mutex_lock(&pack_mutex);
 
 	list_for_each_entry(tmp, &pack_list, list) {
@@ -926,8 +948,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
 
 	bitmap_clear(pack->bitmap, pos, nbits);
-	if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
-				       BPF_PROG_CHUNK_COUNT, 0) == 0) {
+	if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
+				       bpf_prog_chunk_count(), 0) == 0) {
 		list_del(&pack->list);
 		module_memfree(pack->ptr);
 		kfree(pack);
-- 
2.30.2

