Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07C61080E1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 23:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfKWWIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 17:08:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726759AbfKWWIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 17:08:47 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xANM8iKZ007526
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 14:08:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Q4HyTg+AVHFsiXHRjg/IF7gdOFQ7BelGBoC4nPOTKMY=;
 b=jQHDBzc/VuOQL2IaxYAHvQQjxN8c7hKDKz0f4gGRbdmFjka6JeUQ8tAZ/mPs7ic/1WRy
 mNHVLXL0c9swgL3Hk1Cdj2s0N+by6svDCZcTcglTMZnE6lkmxObsl23mDqj+I4q2Oo3D
 4uEFDuG13SWqajQuclmI+G/94KSkXXgZjSo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wf2rm9y93-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 14:08:46 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 23 Nov 2019 14:08:42 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 65E562EC18F0; Sat, 23 Nov 2019 14:08:40 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] mm: implement no-MMU variant of vmalloc_user_node_flags
Date:   Sat, 23 Nov 2019 14:08:35 -0800
Message-ID: <20191123220835.1237773-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-23_05:2019-11-21,2019-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=789
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 impostorscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911230189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 mm/nommu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 99b7ec318824..7de592058ab4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -155,11 +155,11 @@ void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
 	return __vmalloc(size, flags, PAGE_KERNEL);
 }
 
-void *vmalloc_user(unsigned long size)
+static void *__vmalloc_user_flags(unsigned long size, gfp_t flags)
 {
 	void *ret;
 
-	ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc(size, flags, PAGE_KERNEL);
 	if (ret) {
 		struct vm_area_struct *vma;
 
@@ -172,8 +172,19 @@ void *vmalloc_user(unsigned long size)
 
 	return ret;
 }
+
+void *vmalloc_user(unsigned long size)
+{
+	return __vmalloc_user_flags(size, GFP_KERNEL | __GFP_ZERO);
+}
 EXPORT_SYMBOL(vmalloc_user);
 
+void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
+{
+	return __vmalloc_user_flags(size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vmalloc_user_node_flags);
+
 struct page *vmalloc_to_page(const void *addr)
 {
 	return virt_to_page(addr);
-- 
2.17.1

