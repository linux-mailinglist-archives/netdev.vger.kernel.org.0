Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404C3889D4
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHJINx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 04:13:53 -0400
Received: from mail5.windriver.com ([192.103.53.11]:50146 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfHJINx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 04:13:53 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x7A89qbk020525
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sat, 10 Aug 2019 01:10:03 -0700
Received: from pek-lpg-core2.corp.ad.wrs.com (128.224.153.41) by
 ALA-HCA.corp.ad.wrs.com (147.11.189.40) with Microsoft SMTP Server id
 14.3.468.0; Sat, 10 Aug 2019 01:09:41 -0700
From:   <zhe.he@windriver.com>
To:     <linux@armlinux.org.uk>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <matthias.schiffer@ew.tq-group.com>, <info@metux.net>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <zhe.he@windriver.com>
Subject: [PATCH] ARM: module: Avoid W and X mappings at the beginning
Date:   Sat, 10 Aug 2019 16:09:35 +0800
Message-ID: <1565424575-346010-1-git-send-email-zhe.he@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

It is more secure to map module memory as not-execute at the beginning.
Memory sections that need to be executable will be turned to executable
later in complete_formation.

This is a corresponding change for ARM to the following commit
commit f2c65fb3221a ("x86/modules: Avoid breaking W^X while loading modules")

Tested with test_bpf:
test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]

Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 arch/arm/kernel/module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index deef17f..197b3b9 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -45,12 +45,12 @@ void *module_alloc(unsigned long size)
 		gfp_mask |= __GFP_NOWARN;
 
 	p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				gfp_mask, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				gfp_mask, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 	if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || p)
 		return p;
 	return __vmalloc_node_range(size, 1,  VMALLOC_START, VMALLOC_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
-- 
2.7.4

