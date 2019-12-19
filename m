Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C781D125875
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSA2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:28:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33164 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbfLSA2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:28:48 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ0Qq1l015622
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=W2gjuOGraQBpJyb3aQPpDF5MB4AmOuZRt5mVN2TcA94=;
 b=kIEPAPRas5eX9YEefMkGz+NHJL1bMJhE+Cfl6KB6S7s3J7WczuJ3oNLZ7TDYlVAm4AT0
 qM9cctSKXreA3FcBWz3/pB3hNAZSQGrgrzO+n7WWKCdFaZsch0DKOEYTYsIwPtPDQFYv
 r/DNJM9OG66V+Q+DTL+tHUiq4flV5LucUro= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wykmqkhb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:48 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 16:28:47 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 999072EC18AF; Wed, 18 Dec 2019 16:28:46 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] libbpf: BTF is required when externs are present
Date:   Wed, 18 Dec 2019 16:28:36 -0800
Message-ID: <20191219002837.3074619-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219002837.3074619-1-andriin@fb.com>
References: <20191219002837.3074619-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 priorityscore=1501 malwarescore=0 mlxlogscore=974
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF is required to get type information about extern variables.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f90db2b18e4b..e1d91c64e093 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1887,7 +1887,8 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 
 static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
 {
-	return obj->efile.btf_maps_shndx >= 0;
+	return obj->efile.btf_maps_shndx >= 0 ||
+	       obj->nr_extern > 0;
 }
 
 static int bpf_object__init_btf(struct bpf_object *obj,
-- 
2.17.1

