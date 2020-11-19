Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E82B99CE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKSRlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:41:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729380AbgKSRiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:05 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHXu1u022383
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Hwzm6M4F6p3wIIDsFCV/NiMC7IzEqkcaYpjxL5TApLo=;
 b=gjYrtDrI1z/zCicvUTWQlMmj//dWeLZaXZVRM3k+w+gQg11o4zj6O+CKma0um8XtnvOb
 mGZtUX9LsfxqBHQcmsEhOS/CcNrCqL6C/SxbXNwt0fJ68zMG4JMMbAlC0bvLOCuTOSEZ
 zerj7CWuE6bcINu3566yh3NNCXRNz+ib9Y4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wthes6ag-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:05 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:02 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 805B4145BCDD; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 03/34] mm: introduce page memcg flags
Date:   Thu, 19 Nov 2020 09:37:23 -0800
Message-ID: <20201119173754.4125257-4-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=493
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=1 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190125
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

