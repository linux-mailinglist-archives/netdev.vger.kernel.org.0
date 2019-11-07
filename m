Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B13F2504
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733051AbfKGCJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732931AbfKGCJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:48 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA725oYQ005426
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=RbMBPx7cQT6Fh+tEYYgHsCqRq1kVe30n2pN0oO/I1u0=;
 b=FHOKObcHXuzs5LwDzDGEoR6Xdhb2R9TCr3dhVcM3o13QLALaY83i0vk+DqZKvsqyiI+R
 qS2020pDymfLcDI6mLApGbRGCs6cDslThzktWhEC/6+2ICOvduWIubIAK6l7t007AC7j
 cujsn3GCTSk58cIrXZSMw6bP6YPC4dbiSCQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un2k92-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:47 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 18:09:29 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 086192EC17EE; Wed,  6 Nov 2019 18:09:29 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/5] libbpf: make btf__resolve_size logic always check size error condition
Date:   Wed, 6 Nov 2019 18:08:54 -0800
Message-ID: <20191107020855.3834758-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
References: <20191107020855.3834758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=8 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform size check always in btf__resolve_size. Makes the logic a bit more
robust against corrupted BTF and silences LGTM/Coverity complaining about
always true (size < 0) check.

Fixes: 69eaab04c675 ("btf: extract BTF type size calculation")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d72e9a79dce1..86a1847e4a9f 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -269,10 +269,9 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 		t = btf__type_by_id(btf, type_id);
 	}
 
+done:
 	if (size < 0)
 		return -EINVAL;
-
-done:
 	if (nelems && size > UINT32_MAX / nelems)
 		return -E2BIG;
 
-- 
2.17.1

