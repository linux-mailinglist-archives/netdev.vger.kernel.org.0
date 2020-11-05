Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B000C2A767C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgKEEeZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49300 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731495AbgKEEeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:24 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54SUY6026266
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:23 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34kmux6eqd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:23 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 06DE12EC8E04; Wed,  4 Nov 2020 20:34:18 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 07/11] libbpf: fix BTF data layout checks and allow empty BTF
Date:   Wed, 4 Nov 2020 20:33:57 -0800
Message-ID: <20201105043402.2530976-8-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=8 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make data section layout checks stricter, disallowing overlap of types and
strings data.

Additionally, allow BTFs with no type data. There is nothing inherently wrong
with having BTF with no types (put potentially with some strings). This could
be a situation with kernel module BTFs, if module doesn't introduce any new
type information.

Also fix invalid offset alignment check for btf->hdr->type_off.

Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 0258cf108c0a..20bb88e71f07 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -245,22 +245,18 @@ static int btf_parse_hdr(struct btf *btf)
 		return -EINVAL;
 	}
 
-	if (meta_left < hdr->type_off) {
-		pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
+	if (meta_left < hdr->str_off + hdr->str_len) {
+		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
 		return -EINVAL;
 	}
 
-	if (meta_left < hdr->str_off) {
-		pr_debug("Invalid BTF string section offset:%u\n", hdr->str_off);
+	if (hdr->type_off + hdr->type_len > hdr->str_off) {
+		pr_debug("Invalid BTF data sections layout: type data at %u + %u, strings data at %u + %u\n",
+			 hdr->type_off, hdr->type_len, hdr->str_off, hdr->str_len);
 		return -EINVAL;
 	}
 
-	if (hdr->type_off >= hdr->str_off) {
-		pr_debug("BTF type section offset >= string section offset. No type?\n");
-		return -EINVAL;
-	}
-
-	if (hdr->type_off & 0x02) {
+	if (hdr->type_off % 4) {
 		pr_debug("BTF type section is not aligned to 4 bytes\n");
 		return -EINVAL;
 	}
-- 
2.24.1

