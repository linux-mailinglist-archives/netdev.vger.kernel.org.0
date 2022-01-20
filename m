Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53E34954C1
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377522AbiATTO6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jan 2022 14:14:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42914 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377447AbiATTNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:13:44 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20KHwhFo016285
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:13:44 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dq56xkcw0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:13:44 -0800
Received: from twshared3115.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 11:13:22 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2C0F8283245EA; Thu, 20 Jan 2022 11:13:21 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 3/7] bpf: use size instead of pages in bpf_binary_header
Date:   Thu, 20 Jan 2022 11:13:01 -0800
Message-ID: <20220120191306.1801459-4-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120191306.1801459-1-song@kernel.org>
References: <20220120191306.1801459-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Vd2jO1zyfh1dwu3yf8goHTJEbyXglqyb
X-Proofpoint-ORIG-GUID: Vd2jO1zyfh1dwu3yf8goHTJEbyXglqyb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_07,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=882 phishscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201200097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

This is necessary to charge sub page memory for the BPF program.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/filter.h |  6 +++---
 kernel/bpf/core.c      | 11 +++++------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index d23e999dc032..5855eb474c62 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -548,7 +548,7 @@ struct sock_fprog_kern {
 #define BPF_IMAGE_ALIGNMENT 8
 
 struct bpf_binary_header {
-	u32 pages;
+	u32 size;
 	u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
 };
 
@@ -886,8 +886,8 @@ static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
 	set_vm_flush_reset_perms(hdr);
-	set_memory_ro((unsigned long)hdr, hdr->pages);
-	set_memory_x((unsigned long)hdr, hdr->pages);
+	set_memory_ro((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
+	set_memory_x((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
 }
 
 static inline struct bpf_binary_header *
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b9c6a426a7dd..f252d8529b0b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -543,7 +543,7 @@ bpf_prog_ksym_set_addr(struct bpf_prog *prog)
 	WARN_ON_ONCE(!bpf_prog_ebpf_jited(prog));
 
 	prog->aux->ksym.start = (unsigned long) prog->bpf_func;
-	prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE;
+	prog->aux->ksym.end   = addr + hdr->size;
 }
 
 static void
@@ -866,7 +866,7 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	struct bpf_binary_header *hdr;
-	u32 size, hole, start, pages;
+	u32 size, hole, start;
 
 	WARN_ON_ONCE(!is_power_of_2(alignment) ||
 		     alignment > BPF_IMAGE_ALIGNMENT);
@@ -876,7 +876,6 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 	 * random section of illegal instructions.
 	 */
 	size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
-	pages = size / PAGE_SIZE;
 
 	if (bpf_jit_charge_modmem(size))
 		return NULL;
@@ -889,7 +888,7 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 	/* Fill space with illegal/arch-dep instructions. */
 	bpf_fill_ill_insns(hdr, size);
 
-	hdr->pages = pages;
+	hdr->size = size;
 	hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
 		     PAGE_SIZE - sizeof(*hdr));
 	start = (get_random_int() % hole) & ~(alignment - 1);
@@ -902,10 +901,10 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 
 void bpf_jit_binary_free(struct bpf_binary_header *hdr)
 {
-	u32 pages = hdr->pages;
+	u32 size = hdr->size;
 
 	bpf_jit_free_exec(hdr);
-	bpf_jit_uncharge_modmem(pages << PAGE_SHIFT);
+	bpf_jit_uncharge_modmem(size);
 }
 
 /* This symbol is only overridden by archs that have different
-- 
2.30.2

