Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D432E352
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfE2Rg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfE2Rg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THTiC7027606
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=FsE3XkK2qJftt1Bm/IoQNMcfHr4cEYQguMH0RpXO/QQ=;
 b=DsStfEIaIJd5sMZM4ZqXmBosrc9kBo7Fzvcj2yizhBZx0vi52cpanfPtsKPS0O92Jwsx
 S1bokTs9FHyAgSPuT4IOqlrbKMMqe77l6j8baasaIvCJZxgbCjYgZ6OIXK4EJP4D1tjL
 f3ytBHdmCXP56rvzzcLka+9Ol/ike/GIzQw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sswbt0adg-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:27 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:23 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A39AF8617AE; Wed, 29 May 2019 10:36:21 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 3/9] libbpf: simplify endianness check
Date:   Wed, 29 May 2019 10:36:05 -0700
Message-ID: <20190529173611.4012579-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529173611.4012579-1-andriin@fb.com>
References: <20190529173611.4012579-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite endianness check to use "more canonical" way, using
compiler-defined macros, similar to few other places in libbpf. It also
is more obvious and shorter.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5af331cb8e4f..fe700ef1135d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -607,31 +607,18 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	return err;
 }
 
-static int
-bpf_object__check_endianness(struct bpf_object *obj)
-{
-	static unsigned int const endian = 1;
-
-	switch (obj->efile.ehdr.e_ident[EI_DATA]) {
-	case ELFDATA2LSB:
-		/* We are big endian, BPF obj is little endian. */
-		if (*(unsigned char const *)&endian != 1)
-			goto mismatch;
-		break;
-
-	case ELFDATA2MSB:
-		/* We are little endian, BPF obj is big endian. */
-		if (*(unsigned char const *)&endian != 0)
-			goto mismatch;
-		break;
-	default:
-		return -LIBBPF_ERRNO__ENDIAN;
-	}
-
-	return 0;
-
-mismatch:
-	pr_warning("Error: endianness mismatch.\n");
+static int bpf_object__check_endianness(struct bpf_object *obj)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
+		return 0;
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
+		return 0;
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+	pr_warning("endianness mismatch.\n");
 	return -LIBBPF_ERRNO__ENDIAN;
 }
 
-- 
2.17.1

