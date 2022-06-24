Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11155A409
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiFXV5i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jun 2022 17:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiFXV5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:57:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F5587B7B
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:37 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaEnW024778
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:37 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gwd56ub6a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:37 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 24 Jun 2022 14:57:35 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id C6D2094C3A15; Fri, 24 Jun 2022 14:57:22 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <x86@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>, <mcgrof@kernel.org>,
        <rick.p.edgecombe@intel.com>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 1/5] module: introduce module_alloc_huge
Date:   Fri, 24 Jun 2022 14:57:08 -0700
Message-ID: <20220624215712.3050672-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624215712.3050672-1-song@kernel.org>
References: <20220624215712.3050672-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _Mr3Kwzy6NAUMO6E5IWbcNlar12fKFxr
X-Proofpoint-ORIG-GUID: _Mr3Kwzy6NAUMO6E5IWbcNlar12fKFxr
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

Introduce module_alloc_huge, which allocates huge page backed memory in
module memory space. The primary user of this memory is bpf_prog_pack
(multiple BPF programs sharing a huge page).

Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/kernel/module.c     | 21 +++++++++++++++++++++
 include/linux/moduleloader.h |  5 +++++
 kernel/module/main.c         |  8 ++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b98ffcf4d250..63f6a16c70dc 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -86,6 +86,27 @@ void *module_alloc(unsigned long size)
 	return p;
 }
 
+void *module_alloc_huge(unsigned long size)
+{
+	gfp_t gfp_mask = GFP_KERNEL;
+	void *p;
+
+	if (PAGE_ALIGN(size) > MODULES_LEN)
+		return NULL;
+
+	p = __vmalloc_node_range(size, MODULE_ALIGN,
+				 MODULES_VADDR + get_module_load_offset(),
+				 MODULES_END, gfp_mask, PAGE_KERNEL,
+				 VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
+				 NUMA_NO_NODE, __builtin_return_address(0));
+	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
+		vfree(p);
+		return NULL;
+	}
+
+	return p;
+}
+
 #ifdef CONFIG_X86_32
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 9e09d11ffe5b..d34743a88938 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -26,6 +26,11 @@ unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
    sections.  Returns NULL on failure. */
 void *module_alloc(unsigned long size);
 
+/* Allocator used for allocating memory in module memory space. If size is
+ * greater than PMD_SIZE, allow using huge pages. Returns NULL on failure.
+ */
+void *module_alloc_huge(unsigned long size);
+
 /* Free memory returned from module_alloc. */
 void module_memfree(void *module_region);
 
diff --git a/kernel/module/main.c b/kernel/module/main.c
index fed58d30725d..349b2a8bd20f 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1613,6 +1613,14 @@ void * __weak module_alloc(unsigned long size)
 			NUMA_NO_NODE, __builtin_return_address(0));
 }
 
+void * __weak module_alloc_huge(unsigned long size)
+{
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC,
+				    VM_FLUSH_RESET_PERMS | VM_ALLOW_HUGE_VMAP,
+				    NUMA_NO_NODE, __builtin_return_address(0));
+}
+
 bool __weak module_init_section(const char *name)
 {
 	return strstarts(name, ".init");
-- 
2.30.2

