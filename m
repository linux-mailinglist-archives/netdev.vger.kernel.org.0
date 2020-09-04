Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5138525D03E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 06:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgIDEQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 00:16:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbgIDEQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 00:16:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0844EueD009349
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 21:16:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=k3BnDn9Pjj5o4CEbupjgzlLI4384iKFFs/2ktBDkssE=;
 b=WBFcpWazK8PGCCMXCWEHC6ov0uQaPV96tpaopP7tzfLOBXlX5dSfPHmVHVeK1m1fA0Xg
 tMfLCFM/mO38swebMHr9b6xDdtTXEIXFlBEoz9an67B56OBfcidJ214IhFTzTzt4wM+W
 v3nCC+z5tP0iMTa9fQu4UjkL7cFwJflnJVc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33b2heutmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 21:16:21 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 21:16:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DA1BF2EC6841; Thu,  3 Sep 2020 21:16:14 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 1/2] libbpf: fix another __u64 cast in printf
Date:   Thu, 3 Sep 2020 21:16:10 -0700
Message-ID: <20200904041611.1695163-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 mlxlogscore=865 mlxscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another issue of __u64 needing either %lu or %llu, depending on the
architecture. Fix with cast to `unsigned long long`.

Fixes: 7e06aad52929 ("libbpf: Add multi-prog section support for struct_o=
ps")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 47b43c13eee5..53be32a2b9fc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8224,7 +8224,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 		}
 		if (sym.st_value % BPF_INSN_SZ) {
 			pr_warn("struct_ops reloc %s: invalid target program offset %llu\n",
-				map->name, (__u64)sym.st_value);
+				map->name, (unsigned long long)sym.st_value);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 		insn_idx =3D sym.st_value / BPF_INSN_SZ;
--=20
2.24.1

