Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33BA45B2D2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbhKXDxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:53:36 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58064 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240875AbhKXDxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:53:34 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxeNJ3tp1hx9oAAA--.1299S4;
        Wed, 24 Nov 2021 11:50:23 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org
Subject: [PATCH 2/4] MIPS: tx39: fix tx39_flush_cache_page
Date:   Wed, 24 Nov 2021 11:50:02 +0800
Message-Id: <20211124035004.7871-3-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211124035004.7871-1-huangpei@loongson.cn>
References: <20211124035004.7871-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxeNJ3tp1hx9oAAA--.1299S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4kuFWUZr15CF4xWFy8Xwb_yoW8Gw1xp3
        y2kan8J3y0g3WruFyfAw4qyr1Sg3srKFWIva17K34Y934YqF1UKrn3Krn0gF15ArZYyay7
        uFWjyF15Zw4qv3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv
        6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20xvY0x
        0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
        7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcV
        C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j4OJ5UUUUU=
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indexed cache operation need KSEG0 address for safety and assume
that no dcache alias nor high memory, since indexed cache instrcution
CAN NOT handle cache alias

Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 arch/mips/mm/c-tx39.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index 03dfbb40ec73..c7c3dbfe7756 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -170,6 +170,7 @@ static void tx39_flush_cache_page(struct vm_area_struct *vma, unsigned long page
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmdp;
 	pte_t *ptep;
+	unsigned long vaddr = phys_to_virt(pfn_to_phys(pfn));
 
 	/*
 	 * If ownes no valid ASID yet, cannot possibly have gotten
@@ -207,11 +208,14 @@ static void tx39_flush_cache_page(struct vm_area_struct *vma, unsigned long page
 	/*
 	 * Do indexed flush, too much work to get the (possible) TLB refills
 	 * to work correctly.
+	 *
+	 * Assuming that tx39 family do not support high memory, nor has
+	 * dcache alias, vaddr can index dcache directly and correctly
 	 */
-	if (cpu_has_dc_aliases || exec)
-		tx39_blast_dcache_page_indexed(page);
-	if (exec)
-		tx39_blast_icache_page_indexed(page);
+	if (exec) {
+		tx39_blast_dcache_page_indexed(vaddr);
+		tx39_blast_icache_page_indexed(vaddr);
+	}
 }
 
 static void local_tx39_flush_data_cache_page(void * addr)
-- 
2.20.1

