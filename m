Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BE255A40B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiFXV5o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jun 2022 17:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiFXV5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:57:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F3587D43
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:40 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaBji012457
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gwcu743y9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:39 -0700
Received: from twshared1457.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 24 Jun 2022 14:57:38 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 078AA94C3A27; Fri, 24 Jun 2022 14:57:25 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <x86@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>, <mcgrof@kernel.org>,
        <rick.p.edgecombe@intel.com>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 3/5] vmalloc: WARN for set_vm_flush_reset_perms() on huge pages
Date:   Fri, 24 Jun 2022 14:57:10 -0700
Message-ID: <20220624215712.3050672-4-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624215712.3050672-1-song@kernel.org>
References: <20220624215712.3050672-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AOAxOQDoZfBimeFotEYXrC8sYjRaGjcW
X-Proofpoint-GUID: AOAxOQDoZfBimeFotEYXrC8sYjRaGjcW
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

VM_FLUSH_RESET_PERMS is not yet ready for huge pages, add a WARN to
catch misuse soon.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/vmalloc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 096d48aa3437..59d3e1f3e108 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -239,6 +239,7 @@ static inline void set_vm_flush_reset_perms(void *addr)
 {
 	struct vm_struct *vm = find_vm_area(addr);
 
+	WARN_ON_ONCE(is_vm_area_hugepages(addr));
 	if (vm)
 		vm->flags |= VM_FLUSH_RESET_PERMS;
 }
-- 
2.30.2

