Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A5DF2501
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbfKGCJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733036AbfKGCJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:33 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA726IeM005806
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=NZp+Xh4fMr/F/npe5oxmgi297adP2YZgy+NJSYshDuY=;
 b=TVcfeYzXOs/yDHyJYjRwMxAfHyn6f2zOHlWVtHJD5+8xyf/fioQtmA2jpgbrohdc5n+L
 +em2qPKBMgHfoqX2A+g94ntPeTBaT2oC7j2aH+7b0v1vy5qOhnS3gAc/RMJTJ2mTneYn
 eaUiFNZmzNEB6XUviPLXloH3VCdyiI8wiUA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un2k93-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:32 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 18:09:28 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D9E942EC17EE; Wed,  6 Nov 2019 18:09:26 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/5] libbpf: fix another potential overflow issue in bpf_prog_linfo
Date:   Wed, 6 Nov 2019 18:08:53 -0800
Message-ID: <20191107020855.3834758-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
References: <20191107020855.3834758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=25 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix few issues found by Coverity and LGTM.

Fixes: b053b439b72a ("bpf: libbpf: bpftool: Print bpf_line_info during prog dump")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_prog_linfo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 8c67561c93b0..3ed1a27b5f7c 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -101,6 +101,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 {
 	struct bpf_prog_linfo *prog_linfo;
 	__u32 nr_linfo, nr_jited_func;
+	__u64 data_sz;
 
 	nr_linfo = info->nr_line_info;
 
@@ -122,11 +123,11 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	/* Copy xlated line_info */
 	prog_linfo->nr_linfo = nr_linfo;
 	prog_linfo->rec_size = info->line_info_rec_size;
-	prog_linfo->raw_linfo = malloc(nr_linfo * prog_linfo->rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->rec_size;
+	prog_linfo->raw_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_linfo)
 		goto err_free;
-	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info,
-	       nr_linfo * prog_linfo->rec_size);
+	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
 
 	nr_jited_func = info->nr_jited_ksyms;
 	if (!nr_jited_func ||
@@ -142,13 +143,12 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	/* Copy jited_line_info */
 	prog_linfo->nr_jited_func = nr_jited_func;
 	prog_linfo->jited_rec_size = info->jited_line_info_rec_size;
-	prog_linfo->raw_jited_linfo = malloc(nr_linfo *
-					     prog_linfo->jited_rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->jited_rec_size;
+	prog_linfo->raw_jited_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_jited_linfo)
 		goto err_free;
 	memcpy(prog_linfo->raw_jited_linfo,
-	       (void *)(long)info->jited_line_info,
-	       nr_linfo * prog_linfo->jited_rec_size);
+	       (void *)(long)info->jited_line_info, data_sz);
 
 	/* Number of jited_line_info per jited func */
 	prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
-- 
2.17.1

