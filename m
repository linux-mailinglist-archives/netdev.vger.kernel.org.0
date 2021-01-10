Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4862F05CB
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 08:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbhAJHEj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 10 Jan 2021 02:04:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34598 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbhAJHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 02:04:39 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10A73vxB002990
        for <netdev@vger.kernel.org>; Sat, 9 Jan 2021 23:03:58 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yavstpn5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 23:03:58 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 23:03:50 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 589FD2ECD3D6; Sat,  9 Jan 2021 23:03:47 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
Subject: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
Date:   Sat, 9 Jan 2021 23:03:41 -0800
Message-ID: <20210110070341.1380086-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210110070341.1380086-1-andrii@kernel.org>
References: <20210110070341.1380086-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=829 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101100044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Empty BTFs do come up (e.g., simple kernel modules with no new types and
strings, compared to the vmlinux BTF) and there is nothing technically wrong
with them. So remove unnecessary check preventing loading empty BTFs.

Reported-by: Christopher William Snowhill <chris@kode54.net>
Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3c3f2bc6c652..9970a288dda5 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
 	}
 
 	meta_left = btf->raw_size - sizeof(*hdr);
-	if (!meta_left) {
-		pr_debug("BTF has no data\n");
-		return -EINVAL;
-	}
-
 	if (meta_left < hdr->str_off + hdr->str_len) {
 		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
 		return -EINVAL;
-- 
2.24.1

