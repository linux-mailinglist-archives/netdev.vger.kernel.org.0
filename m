Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C380214F54E
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 01:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBAADT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 19:03:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726264AbgBAADT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 19:03:19 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01101vEO002153
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 16:03:19 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xvn09juq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 16:03:18 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 31 Jan 2020 16:03:18 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 5FC1E76081D; Fri, 31 Jan 2020 16:03:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: Fix modifier skipping logic
Date:   Fri, 31 Jan 2020 16:03:14 -0800
Message-ID: <20200201000314.261392-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_07:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1034
 mlxlogscore=979 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the way modifiers are skipped while walking pointers. Otherwise second
level dereferences of 'const struct foo *' will be rejected by the verifier.

Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/btf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b7c1660fb594..a289f2915ba8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3931,6 +3931,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 		if (btf_type_is_ptr(mtype)) {
 			const struct btf_type *stype;
+			u32 id;
 
 			if (msize != size || off != moff) {
 				bpf_log(log,
@@ -3939,12 +3940,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
 				return -EACCES;
 			}
 
-			stype = btf_type_by_id(btf_vmlinux, mtype->type);
-			/* skip modifiers */
-			while (btf_type_is_modifier(stype))
-				stype = btf_type_by_id(btf_vmlinux, stype->type);
+			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
-				*next_btf_id = mtype->type;
+				*next_btf_id = id;
 				return PTR_TO_BTF_ID;
 			}
 		}
-- 
2.23.0

