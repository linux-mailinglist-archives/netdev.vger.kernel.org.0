Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4164B0677
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbiBJGlf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 01:41:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiBJGle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:41:34 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDD510AD
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 22:41:32 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21A1nQ3Q032027
        for <netdev@vger.kernel.org>; Wed, 9 Feb 2022 22:41:31 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4sckh48x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 22:41:31 -0800
Received: from twshared14630.35.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 22:41:30 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9B7AC29D423C9; Wed,  9 Feb 2022 22:41:21 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-mm@kvack.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <akpm@linux-foundation.org>,
        <eric.dumazet@gmail.com>, Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
Date:   Wed, 9 Feb 2022 22:41:08 -0800
Message-ID: <20220210064108.1095847-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210064108.1095847-1-song@kernel.org>
References: <20220210064108.1095847-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7N-72YumpeA3UUBArK3hRwlBI809_Sel
X-Proofpoint-GUID: 7N-72YumpeA3UUBArK3hRwlBI809_Sel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202100034
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

bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
allocate memory of size PMD_SIZE * num_online_nodes().

On the other hand, if the system doesn't support huge pages, it is more
efficient to allocate PAGE_SIZE bpf_prog_pack.

Address different scenarios with more flexible bpf_prog_pack_size().

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 42d96549a804..d961a1f07a13 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
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
 	void *ptr;
-	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
+	unsigned long bitmap[];
 };
 
-#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
 #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
 
 static DEFINE_MUTEX(pack_mutex);
 static LIST_HEAD(pack_list);
 
+static inline int bpf_prog_pack_size(void)
+{
+	/* If vmap_allow_huge == true, use pack size of the smallest
+	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
+	 * Otherwise, use pack size of PAGE_SIZE.
+	 */
+	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
+}
+
+static inline int bpf_prog_chunk_count(void)
+{
+	return bpf_prog_pack_size() / BPF_PROG_CHUNK_SIZE;
+}
+
 static struct bpf_prog_pack *alloc_new_pack(void)
 {
 	struct bpf_prog_pack *pack;
 
-	pack = kzalloc(sizeof(*pack), GFP_KERNEL);
+	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(bpf_prog_chunk_count()), GFP_KERNEL);
 	if (!pack)
 		return NULL;
-	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
+	pack->ptr = module_alloc(bpf_prog_pack_size());
 	if (!pack->ptr) {
 		kfree(pack);
 		return NULL;
 	}
-	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
+	bitmap_zero(pack->bitmap, bpf_prog_pack_size() / BPF_PROG_CHUNK_SIZE);
 	list_add_tail(&pack->list, &pack_list);
 
 	set_vm_flush_reset_perms(pack->ptr);
-	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
-	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
+	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size() / PAGE_SIZE);
+	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size() / PAGE_SIZE);
 	return pack;
 }
 
@@ -864,7 +871,7 @@ static void *bpf_prog_pack_alloc(u32 size)
 	unsigned long pos;
 	void *ptr = NULL;
 
-	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+	if (size > bpf_prog_pack_size()) {
 		size = round_up(size, PAGE_SIZE);
 		ptr = module_alloc(size);
 		if (ptr) {
@@ -876,9 +883,9 @@ static void *bpf_prog_pack_alloc(u32 size)
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
 
@@ -904,12 +911,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	unsigned long pos;
 	void *pack_ptr;
 
-	if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+	if (hdr->size > bpf_prog_pack_size()) {
 		module_memfree(hdr);
 		return;
 	}
 
-	pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
+	pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size() - 1));
 	mutex_lock(&pack_mutex);
 
 	list_for_each_entry(tmp, &pack_list, list) {
@@ -926,8 +933,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
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

