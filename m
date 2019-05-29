Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D153A2D323
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfE2BOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:14:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfE2BOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:14:40 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T18sDH014313
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=a9PJg81Vl5pbVhImTx+z6qkv89D9tfm/N8te+fCBEKM=;
 b=XpqemwoJNO62hGvEaFRIhI5Jv+dGChnFeidRCp0JEeN7rto1u9P/gMHxR3xBSCnPJXuo
 rx5E6yie4JME0Rxq90tnSk+UXhvgJhCzQUHHAfDXGnIgiRLHGoQGGBnrDy9TXgZl2g6j
 RN41EFdDnlMK0T5IG2XKr1q5Gxjc59LuLpQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss90chjxy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:38 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 18:14:36 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id EF6E18617AA; Tue, 28 May 2019 18:14:34 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 3/9] libbpf: simplify endianness check
Date:   Tue, 28 May 2019 18:14:20 -0700
Message-ID: <20190529011426.1328736-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529011426.1328736-1-andriin@fb.com>
References: <20190529011426.1328736-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite endianness check to use "more canonical" way, using
compiler-defined macros, similar to few other places in libbpf. It also
is more obvious and shorter.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7b80b9ae8a1f..c98f9942fba4 100644
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

