Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1484C9A07
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiCBAox convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Mar 2022 19:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238790AbiCBAov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:44:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5115F24F
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 16:44:09 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 221HveTl010181
        for <netdev@vger.kernel.org>; Tue, 1 Mar 2022 16:44:09 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ehrbjak4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 16:44:09 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 16:44:02 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A8E6E2B47846C; Tue,  1 Mar 2022 16:43:54 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH bpf-next 1/2] x86: disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86
Date:   Tue, 1 Mar 2022 16:43:38 -0800
Message-ID: <20220302004339.3932356-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302004339.3932356-1-song@kernel.org>
References: <20220302004339.3932356-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0DlRIhR94ogFr6HbxiEzG2Y2YyiVyLyB
X-Proofpoint-ORIG-GUID: 0DlRIhR94ogFr6HbxiEzG2Y2YyiVyLyB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=701 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020001
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

kernel test robot reported kernel BUG like:

[ 44.587744][ T1] kernel BUG at arch/x86/mm/physaddr.c:76!
[ 44.590151][ T1] __vmalloc_area_node (mm/vmalloc.c:622 mm/vmalloc.c:2995)
[ 44.590151][ T1] __vmalloc_node_range (mm/vmalloc.c:3108)
[ 44.590151][ T1] __vmalloc_node (mm/vmalloc.c:3157)

which is triggered with HAVE_ARCH_HUGE_VMALLOC on 32-bit x86. Since BPF
only uses HAVE_ARCH_HUGE_VMALLOC for x86_64, turn it off for 32-bit x86.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: fac54e2bfb5b ("x86/Kconfig: Select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP")
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 995f2dc28631..9b356da6f46b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -158,7 +158,7 @@ config X86
 	select HAVE_ALIGNED_STRUCT_PAGE		if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
-	select HAVE_ARCH_HUGE_VMALLOC		if HAVE_ARCH_HUGE_VMAP
+	select HAVE_ARCH_HUGE_VMALLOC		if X86_64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
-- 
2.30.2

