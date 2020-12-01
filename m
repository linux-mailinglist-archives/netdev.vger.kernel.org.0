Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93D2CAF9A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389439AbgLAWCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:02:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59326 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389580AbgLAV7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:54 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LnWeb024474
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Hwzm6M4F6p3wIIDsFCV/NiMC7IzEqkcaYpjxL5TApLo=;
 b=OhUTrvsXSavFj1y5SJcM83IRKTVNv+STxqXEenteKREZwySjqwDr6MZmNSGoeF0ixHt/
 8TyT9zLm/BHOCNllFMgWur/AspxKXAFs5jBUK0dKSLyhlakbHGduiOO14qsNJoh/bp+g
 ufjyy2Laj3iYvH2lanYTkdFHC1P0HoiW6hc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 353uh50v0a-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:13 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:09 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 4975419702A4; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 03/34] mm: introduce page memcg flags
Date:   Tue, 1 Dec 2020 13:58:29 -0800
Message-ID: <20201201215900.3569844-4-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxlogscore=482 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lowest bit in page->memcg_data is used to distinguish between struct
memory_cgroup pointer and a pointer to a objcgs array.  All checks and
modifications of this bit are open-coded.

Let's formalize it using page memcg flags, defined in enum
page_memcg_data_flags.

Additional flags might be added later.

Link: https://lkml.kernel.org/r/20201027001657.3398190-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c7ac0a5b8989..99a4841d658b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -343,6 +343,15 @@ struct mem_cgroup {
=20
 extern struct mem_cgroup *root_mem_cgroup;
=20
+enum page_memcg_data_flags {
+	/* page->memcg_data is a pointer to an objcgs vector */
+	MEMCG_DATA_OBJCGS =3D (1UL << 0),
+	/* the next bit after the last actual flag */
+	__NR_MEMCG_DATA_FLAGS  =3D (1UL << 1),
+};
+
+#define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
+
 /*
  * page_memcg - get the memory cgroup associated with a page
  * @page: a pointer to the page struct
@@ -404,13 +413,7 @@ static inline struct mem_cgroup *page_memcg_check(stru=
ct page *page)
 	 */
 	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
=20
-	/*
-	 * The lowest bit set means that memcg isn't a valid
-	 * memcg pointer, but a obj_cgroups pointer.
-	 * In this case the page is shared and doesn't belong
-	 * to any specific memory cgroup.
-	 */
-	if (memcg_data & 0x1UL)
+	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
=20
 	return (struct mem_cgroup *)memcg_data;
@@ -429,7 +432,11 @@ static inline struct mem_cgroup *page_memcg_check(stru=
ct page *page)
  */
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
-	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
+
+	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
=20
 /*
@@ -444,10 +451,10 @@ static inline struct obj_cgroup **page_objcgs_check(s=
truct page *page)
 {
 	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
=20
-	if (memcg_data && (memcg_data & 0x1UL))
-		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
+		return NULL;
=20
-	return NULL;
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
=20
 /*
@@ -460,7 +467,8 @@ static inline struct obj_cgroup **page_objcgs_check(str=
uct page *page)
 static inline bool set_page_objcgs(struct page *page,
 					struct obj_cgroup **objcgs)
 {
-	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs |
+			MEMCG_DATA_OBJCGS);
 }
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
--=20
2.26.2

