Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064BE1287BF
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLUG0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbfLUG0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBL6OkWr029018
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=eqG7cGifLkLj0mZdEgac9irYO5y0Z8NYirVp/nkf54Q=;
 b=cftViNiZcdUafosMqquCRAsATo3+6RTjGQscTbJwixis6j0zhGnKhUktJMuShbpxD7Cw
 qVaCdKV9jrzVOYaOwRzMvy8Xp7JS4m3nw62re3Y4St//dVH6f5EGU4KfXuCp4Wg1Lgeg
 JNfanaD2pISGGWgy5PnPJev5kpCHT5YGwQY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x11nsuag6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:01 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Dec 2019 22:26:00 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E63752946127; Fri, 20 Dec 2019 22:25:59 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 02/11] bpf: Avoid storing modifier to info->btf_id
Date:   Fri, 20 Dec 2019 22:25:59 -0800
Message-ID: <20191221062559.1182467-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=633
 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=13 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info->btf_id expects the btf_id of a struct, so it should
store the final result after skipping modifiers (if any).

It also takes this chanace to add a missing newline in one of the
bpf_log() messages.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7d40da240891..88359a4bccb0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3696,7 +3696,6 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	/* this is a pointer to another type */
 	info->reg_type = PTR_TO_BTF_ID;
-	info->btf_id = t->type;
 
 	if (tgt_prog) {
 		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type);
@@ -3707,10 +3706,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 			return false;
 		}
 	}
+
+	info->btf_id = t->type;
 	t = btf_type_by_id(btf, t->type);
 	/* skip modifiers */
-	while (btf_type_is_modifier(t))
+	while (btf_type_is_modifier(t)) {
+		info->btf_id = t->type;
 		t = btf_type_by_id(btf, t->type);
+	}
 	if (!btf_type_is_struct(t)) {
 		bpf_log(log,
 			"func '%s' arg%d type %s is not a struct\n",
@@ -3736,7 +3739,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 again:
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
 	if (!btf_type_is_struct(t)) {
-		bpf_log(log, "Type '%s' is not a struct", tname);
+		bpf_log(log, "Type '%s' is not a struct\n", tname);
 		return -EINVAL;
 	}
 
-- 
2.17.1

