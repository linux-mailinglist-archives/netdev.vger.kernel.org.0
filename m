Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9538B1403C8
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgAQGIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:08:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26128 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbgAQGIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:08:19 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H64EPi009878
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=RJoMSeW+6PxNy42HgyDQWPz09EvziKk28klg9Wf/De0=;
 b=R0vVKpl8O4FyB0G3XDLiLIMRk1aIhogfcKGIXl+HGRqUHxJRn7SHEcEdM3jolqDEckit
 2dguJQDLUbRXAVc7vbz/no4B3J6NMkrFLEHNUENaX/o8uZ3gXKTcGJlgVe56hMVyuP09
 2UN2b1f69KZJmy+Tk/HGG2hxzkBtCOjb2V4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0rphb1e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:19 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 22:08:17 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7E9B82EC1745; Thu, 16 Jan 2020 22:08:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] libbpf: fix potential multiplication overflow in mmap() size calculation
Date:   Thu, 16 Jan 2020 22:08:00 -0800
Message-ID: <20200117060801.1311525-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117060801.1311525-1-andriin@fb.com>
References: <20200117060801.1311525-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=710
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent potential overflow performed in 32-bit integers, before assigning
result to size_t. Reported by LGTM static analysis.

Fixes: eba9c5f498a1 ("libbpf: Refactor global data map initialization")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3b0b88c3377d..fc41c3f2e983 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1283,7 +1283,7 @@ static size_t bpf_map_mmap_sz(const struct bpf_map *map)
 	long page_sz = sysconf(_SC_PAGE_SIZE);
 	size_t map_sz;
 
-	map_sz = roundup(map->def.value_size, 8) * map->def.max_entries;
+	map_sz = (size_t)roundup(map->def.value_size, 8) * map->def.max_entries;
 	map_sz = roundup(map_sz, page_sz);
 	return map_sz;
 }
-- 
2.17.1

