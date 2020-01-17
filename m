Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E401403C4
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAQGIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:08:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgAQGIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:08:12 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H61Z0B031387
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Mi1w89sCou+O1RrZhaGhoPI8TQ+wxBWanqAzKMDVXJw=;
 b=UcAJD3ZSCPzinYNv+Lsylc45aIGoFoVb1O8mPLBf3jWnSy+uyFt0jgxmsl3u8oh6sMg9
 F0yR6AY5MV6e7raQJwgpyknOt3aYbnQYVeLhD05enpi67IdamUBeJ68de+vp6AdWEIe4
 MmOQWpTvxMqHshsOqnxeaf6tT2FgWOwsbw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0sbsbj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:11 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 22:08:09 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9DE892EC1745; Thu, 16 Jan 2020 22:08:08 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] libbpf: simplify BTF initialization logic
Date:   Thu, 16 Jan 2020 22:07:59 -0800
Message-ID: <20200117060801.1311525-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117060801.1311525-1-andriin@fb.com>
References: <20200117060801.1311525-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=25 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 mlxscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation of bpf_object's BTF initialization is very convoluted
and thus prone to errors. It doesn't have to be like that. This patch
simplifies it significantly.

This code also triggered static analysis issues over logically dead code due
to redundant error checks. This simplification should fix that as well.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3afaca9bce1d..3b0b88c3377d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2297,16 +2297,18 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 				Elf_Data *btf_data,
 				Elf_Data *btf_ext_data)
 {
-	bool btf_required = bpf_object__is_btf_mandatory(obj);
-	int err = 0;
+	int err = -ENOENT;
 
 	if (btf_data) {
 		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
 		if (IS_ERR(obj->btf)) {
+			err = PTR_ERR(obj->btf);
+			obj->btf = NULL;
 			pr_warn("Error loading ELF section %s: %d.\n",
 				BTF_ELF_SEC, err);
 			goto out;
 		}
+		err = 0;
 	}
 	if (btf_ext_data) {
 		if (!obj->btf) {
@@ -2324,18 +2326,9 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 		}
 	}
 out:
-	if (err || IS_ERR(obj->btf)) {
-		if (btf_required)
-			err = err ? : PTR_ERR(obj->btf);
-		else
-			err = 0;
-		if (!IS_ERR_OR_NULL(obj->btf))
-			btf__free(obj->btf);
-		obj->btf = NULL;
-	}
-	if (btf_required && !obj->btf) {
+	if (err && bpf_object__is_btf_mandatory(obj)) {
 		pr_warn("BTF is required, but is missing or corrupted.\n");
-		return err == 0 ? -ENOENT : err;
+		return err;
 	}
 	return 0;
 }
-- 
2.17.1

