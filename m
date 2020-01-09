Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42329135083
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgAIAfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:35:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11538 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727635AbgAIAfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:35:11 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0090XtgQ018555
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:35:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Xs6Cyjrmg4eoTZhcgS1Hfal2Da6EDpa0rmnIUuRE2Xo=;
 b=VXWxyTqtD1Wm/FUJ+SI0LWGsez4KYJ+zVmYIrBVxGAZYkDaf7ebVghrIhUBxSVirmUN6
 nonOBys6q1nxFIqlFIBASqrUtTmCvVMWYMFpgajRC3dg5mw4KcN7qbC5/leB6sygZeEh
 nS7/J2IPaUJfUQbpSosZQ+u/rskTao2D0AM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xdrhwrb1s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:35:10 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 16:35:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id F05C52942576; Wed,  8 Jan 2020 16:34:56 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 02/11] bpf: Avoid storing modifier to info->btf_id
Date:   Wed, 8 Jan 2020 16:34:56 -0800
Message-ID: <20200109003456.3855176-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=651 malwarescore=0 adultscore=0 suspectscore=13
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090003
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

