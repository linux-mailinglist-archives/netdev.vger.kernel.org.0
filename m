Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94657F24FD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733000AbfKGCJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732713AbfKGCJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:28 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA726IeD005806
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=laOvc9e7uFypBJ4p6LaL8U4EIapGLQ/v8Btvh2/r8DM=;
 b=b1f8HkxskHyTXCa5/sWmNuPwp8alVQOPirXzpIrlOo8okQxXg/UJUbE1tUCu7bDUoiQE
 ULiNjpN5BwBmneGyAM6j3JeTHp+rw3MzIXZzJktUZU6ri3NWZAGQc1/4CBvLmXjKdPcS
 wiOa31u4RgmKGU4OryEa74npIVNR72sp690= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un2k93-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:26 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 18:09:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B1DD32EC17EE; Wed,  6 Nov 2019 18:09:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/5] libbpf: fix potential overflow issue
Date:   Wed, 6 Nov 2019 18:08:52 -0800
Message-ID: <20191107020855.3834758-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
References: <20191107020855.3834758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=8 impostorscore=0 mlxlogscore=712
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a potential overflow issue found by LGTM analysis, based on Github libbpf
source code.

Fixes: 3d65014146c6 ("bpf: libbpf: Add btf_line_info support to libbpf")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index ca0d635b1d5e..b3e3e99a0f28 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -189,7 +189,7 @@ static void *
 alloc_zero_tailing_info(const void *orecord, __u32 cnt,
 			__u32 actual_rec_size, __u32 expected_rec_size)
 {
-	__u64 info_len = actual_rec_size * cnt;
+	__u64 info_len = (__u64)actual_rec_size * cnt;
 	void *info, *nrecord;
 	int i;
 
-- 
2.17.1

