Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6926A4B0676
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiBJGl1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 01:41:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiBJGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:41:26 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061010A7
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 22:41:28 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 219NYHAk002462
        for <netdev@vger.kernel.org>; Wed, 9 Feb 2022 22:41:26 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e4ha0cp0n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 22:41:26 -0800
Received: from twshared22811.39.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 22:41:25 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 42D8229D423BF; Wed,  9 Feb 2022 22:41:19 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-mm@kvack.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <akpm@linux-foundation.org>,
        <eric.dumazet@gmail.com>, Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 1/2] vmalloc: expose vmap_allow_huge via get_vmap_allow_huge()
Date:   Wed, 9 Feb 2022 22:41:07 -0800
Message-ID: <20220210064108.1095847-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210064108.1095847-1-song@kernel.org>
References: <20220210064108.1095847-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Rj27020c0hsBVnTXgRrfCqNs8nak3MFi
X-Proofpoint-GUID: Rj27020c0hsBVnTXgRrfCqNs8nak3MFi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100034
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

Users can use get_vmap_allow_huge() to predict the behavior of vmalloc (or
its variations). Specifically, if get_vmap_allow_huge() == false, vmalloc
will never return huge pages.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/vmalloc.h | 1 +
 mm/vmalloc.c            | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 880227b9f044..22acfcd2d0d1 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -256,6 +256,7 @@ extern long vread(char *buf, char *addr, unsigned long count);
 extern struct list_head vmap_area_list;
 extern __init void vm_area_add_early(struct vm_struct *vm);
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
+extern bool get_vmap_allow_huge(void);
 
 #ifdef CONFIG_SMP
 # ifdef CONFIG_MMU
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4165304d3547..895ac81b6bb4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -72,6 +72,11 @@ early_param("nohugevmalloc", set_nohugevmalloc);
 static const bool vmap_allow_huge = false;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMALLOC */
 
+bool get_vmap_allow_huge(void)
+{
+	return vmap_allow_huge;
+}
+
 bool is_vmalloc_addr(const void *x)
 {
 	unsigned long addr = (unsigned long)x;
-- 
2.30.2

