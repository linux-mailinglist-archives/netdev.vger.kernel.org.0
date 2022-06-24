Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4655A40F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiFXV5q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jun 2022 17:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiFXV5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:57:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2005487D41
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:40 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaEac024800
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:39 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gwd56ub6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:39 -0700
Received: from twshared1457.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 24 Jun 2022 14:57:37 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 93EAE94C3A1A; Fri, 24 Jun 2022 14:57:23 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <x86@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>, <mcgrof@kernel.org>,
        <rick.p.edgecombe@intel.com>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 2/5] bpf: use module_alloc_huge for bpf_prog_pack
Date:   Fri, 24 Jun 2022 14:57:09 -0700
Message-ID: <20220624215712.3050672-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624215712.3050672-1-song@kernel.org>
References: <20220624215712.3050672-1-song@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: N30isrDt8EaEGt6yEkg5YWwFViZOyO1X
X-Proofpoint-ORIG-GUID: N30isrDt8EaEGt6yEkg5YWwFViZOyO1X
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use module_alloc_huge for bpf_prog_pack so that BPF programs sit on
PMD_SIZE pages. This benefits system performance by reducing iTLB miss
rate. Benchmark of a real web service workload shows this change gives
another ~0.2% performance boost on top of PAGE_SIZE bpf_prog_pack
(which improve system throughput by ~0.5%).

Also, remove set_vm_flush_reset_perms() from alloc_new_pack() and use
set_memory_[nx|rw] in bpf_prog_pack_free(). This is because
VM_FLUSH_RESET_PERMS does not work with huge pages yet. [1]

[1] https://lore.kernel.org/bpf/aeeeaf0b7ec63fdba55d4834d2f524d8bf05b71b.camel@intel.com/
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index f023cb399e3f..83f5a98517d5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -857,7 +857,7 @@ static size_t select_bpf_prog_pack_size(void)
 	void *ptr;
 
 	size = BPF_HPAGE_SIZE * num_online_nodes();
-	ptr = module_alloc(size);
+	ptr = module_alloc_huge(size);
 
 	/* Test whether we can get huge pages. If not just use PAGE_SIZE
 	 * packs.
@@ -881,7 +881,7 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 		       GFP_KERNEL);
 	if (!pack)
 		return NULL;
-	pack->ptr = module_alloc(bpf_prog_pack_size);
+	pack->ptr = module_alloc_huge(bpf_prog_pack_size);
 	if (!pack->ptr) {
 		kfree(pack);
 		return NULL;
@@ -890,7 +890,6 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
 	list_add_tail(&pack->list, &pack_list);
 
-	set_vm_flush_reset_perms(pack->ptr);
 	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
 	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
 	return pack;
@@ -909,10 +908,9 @@ static void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insn
 
 	if (size > bpf_prog_pack_size) {
 		size = round_up(size, PAGE_SIZE);
-		ptr = module_alloc(size);
+		ptr = module_alloc_huge(size);
 		if (ptr) {
 			bpf_fill_ill_insns(ptr, size);
-			set_vm_flush_reset_perms(ptr);
 			set_memory_ro((unsigned long)ptr, size / PAGE_SIZE);
 			set_memory_x((unsigned long)ptr, size / PAGE_SIZE);
 		}
@@ -949,6 +947,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 
 	mutex_lock(&pack_mutex);
 	if (hdr->size > bpf_prog_pack_size) {
+		set_memory_nx((unsigned long)hdr, hdr->size / PAGE_SIZE);
+		set_memory_rw((unsigned long)hdr, hdr->size / PAGE_SIZE);
 		module_memfree(hdr);
 		goto out;
 	}
@@ -975,6 +975,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
 				       bpf_prog_chunk_count(), 0) == 0) {
 		list_del(&pack->list);
+		set_memory_nx((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
+		set_memory_rw((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
 		module_memfree(pack->ptr);
 		kfree(pack);
 	}
-- 
2.30.2

