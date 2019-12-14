Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A649211EF4D
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLNArr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:47:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21002 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfLNArq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:47:46 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0UsRO000709
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=aZ3k55IeHXzz0oQl49HHmGjLvl6KOkd3U1YI/LTpL4c=;
 b=rTdqZWW1rtaZQKDTxOFKU1mQE3mCQcSHJfHMrOEBS4BDMHROVemAN1DBxQllaxyqlau/
 rRPJlyN8SIJ7ApmW63lADKwogGP5mUx5VLba60mvLwWfUzrbY+Ogf1k7sXdiZPHW2jLK
 fXLnU4N9m0dPA3W58Ko0XDoruFJ/zhgXR6M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wv1r0vwer-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:44 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 16:47:42 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 019952943AB4; Fri, 13 Dec 2019 16:47:41 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 02/13] bpf: Avoid storing modifier to info->btf_id
Date:   Fri, 13 Dec 2019 16:47:41 -0800
Message-ID: <20191214004741.1652332-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 mlxlogscore=591 suspectscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info->btf_id expects the btf_id of a struct, so it should
store the final result after skipping modifiers (if any).

It also takes this chanace to add a missing newline in one of the
bpf_log() messages.

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

