Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94712D682
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 07:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfLaGUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 01:20:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23924 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfLaGUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 01:20:46 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBV6EZj3029623
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 22:20:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Xs6Cyjrmg4eoTZhcgS1Hfal2Da6EDpa0rmnIUuRE2Xo=;
 b=hp7Pey4NB8iMJDb0XdRc4s/5ff4ZfMT+uTxF4EKmjlKfPMbwjUrPBHHBWBVE6PpC496E
 AvDbCHsjcoWsdQn4iadUTX7KkzX6qJfV/d/pahrlXLUuOU2VegPoRXxujBN0uqvLx65R
 3O3ynj/n/ue4OHEoqtT8W37zgN+s6idmQiQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x65eu9hc6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 22:20:44 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Dec 2019 22:20:43 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C589F294410B; Mon, 30 Dec 2019 22:20:41 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 02/11] bpf: Avoid storing modifier to info->btf_id
Date:   Mon, 30 Dec 2019 22:20:41 -0800
Message-ID: <20191231062041.280948-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191231062037.280596-1-kafai@fb.com>
References: <20191231062037.280596-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-30_08:2019-12-27,2019-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 suspectscore=13 priorityscore=1501 impostorscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=642 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912310050
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
index ed2075884724..497ecf62d79d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3697,7 +3697,6 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	/* this is a pointer to another type */
 	info->reg_type = PTR_TO_BTF_ID;
-	info->btf_id = t->type;
 
 	if (tgt_prog) {
 		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type);
@@ -3708,10 +3707,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
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
@@ -3737,7 +3740,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 again:
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
 	if (!btf_type_is_struct(t)) {
-		bpf_log(log, "Type '%s' is not a struct", tname);
+		bpf_log(log, "Type '%s' is not a struct\n", tname);
 		return -EINVAL;
 	}
 
-- 
2.17.1

