Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5750D55A410
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiFXV5r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jun 2022 17:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiFXV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:57:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5FB87B7D
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:41 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaEaf024800
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:41 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gwd56ub6n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:41 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 24 Jun 2022 14:57:39 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 52D0694C3A3C; Fri, 24 Jun 2022 14:57:28 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <x86@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>, <mcgrof@kernel.org>,
        <rick.p.edgecombe@intel.com>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 4/5] vmalloc: introduce huge_vmalloc_supported
Date:   Fri, 24 Jun 2022 14:57:11 -0700
Message-ID: <20220624215712.3050672-5-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624215712.3050672-1-song@kernel.org>
References: <20220624215712.3050672-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _d-btujO0xWlsulPoERN0S1xS4iJDjdR
X-Proofpoint-ORIG-GUID: _d-btujO0xWlsulPoERN0S1xS4iJDjdR
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

huge_vmalloc_supported() exposes vmap_allow_huge so that users of vmalloc
APIs could know whether vmalloc will return huge pages.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/vmalloc.h | 6 ++++++
 mm/vmalloc.c            | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 59d3e1f3e108..aa2182959fc5 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -243,11 +243,17 @@ static inline void set_vm_flush_reset_perms(void *addr)
 	if (vm)
 		vm->flags |= VM_FLUSH_RESET_PERMS;
 }
+bool huge_vmalloc_supported(void);
 
 #else
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 }
+
+static inline bool huge_vmalloc_supported(void)
+{
+	return false;
+}
 #endif
 
 /* for /proc/kcore */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index effd1ff6a4b4..0a5add4b5b2d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -72,6 +72,11 @@ early_param("nohugevmalloc", set_nohugevmalloc);
 static const bool vmap_allow_huge = false;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMALLOC */
 
+bool huge_vmalloc_supported(void)
+{
+	return vmap_allow_huge;
+}
+
 bool is_vmalloc_addr(const void *x)
 {
 	unsigned long addr = (unsigned long)kasan_reset_tag(x);
-- 
2.30.2

