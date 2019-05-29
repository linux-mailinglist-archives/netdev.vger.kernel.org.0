Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37B2E359
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfE2Rgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbfE2Rge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:34 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THR8n4028691
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=yEmasW0vo/2RBvH4vsqgsBM3FEYAoGSyjw0fyOP5DIg=;
 b=qvjySELGsbpKJxCxVHgsOVla3FGFuNKJVHUza/m//DnPNNKEzhkqJuQBtY3Se8N8hgtj
 F0Dt5PARHmn/MStivADaKxSxLU3zGlnj796kyAzOOyw/1T5SuKvrgjg3zaBcgnDpTWR9
 Lc1or9NpysxSG0/4pkpzGG+QY3M733i4IqA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2ssckekc1g-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:33 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:30 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CDEA98617AE; Wed, 29 May 2019 10:36:29 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 7/9] libbpf: simplify two pieces of logic
Date:   Wed, 29 May 2019 10:36:09 -0700
Message-ID: <20190529173611.4012579-8-andriin@fb.com>
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

Extra check for type is unnecessary in first case.

Extra zeroing is unnecessary, as snprintf guarantees that it will
zero-terminate string.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a27a0351e595..5ea84ab69db1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1430,8 +1430,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 				if (maps[map_idx].libbpf_type != type)
 					continue;
 				if (type != LIBBPF_MAP_UNSPEC ||
-				    (type == LIBBPF_MAP_UNSPEC &&
-				     maps[map_idx].offset == sym.st_value)) {
+				    maps[map_idx].offset == sym.st_value) {
 					pr_debug("relocation: find map %zd (%s) for insn %u\n",
 						 map_idx, maps[map_idx].name, insn_idx);
 					break;
@@ -2354,7 +2353,6 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
 			 (unsigned long)obj_buf,
 			 (unsigned long)obj_buf_sz);
-		tmp_name[sizeof(tmp_name) - 1] = '\0';
 		name = tmp_name;
 	}
 	pr_debug("loading object '%s' from buffer\n",
-- 
2.17.1

