Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4109E2D32C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE2BOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:14:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42336 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfE2BOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:14:47 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T1AbO0014498
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PJy3eQGI+XeddCLYZXrRKUEV/kYYwXW76ZqxA06u71c=;
 b=Bcv20FE/w1iDDmgqTB6cKNKRWdioRjTN9X34jxSuVKYX6q+8NqIX5A8NhYvC/vflqjLa
 3AIfuR/qBsH+xCGgaqkDhyLu9SofxDv5h4LPKLsT3y3BSeX027YRC8JEudX175C0boKq
 pHXqTuIs2PpDJpKqGxeM9mN07DRynOEgMNA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss9209hxb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:46 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 18:14:45 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2D2FA8617AA; Tue, 28 May 2019 18:14:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 7/9] libbpf: simplify two pieces of logic
Date:   Tue, 28 May 2019 18:14:24 -0700
Message-ID: <20190529011426.1328736-8-andriin@fb.com>
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

Extra check for type is unnecessary in first case.

Extra zeroing is unnecessary, as snprintf guarantees that it will
zero-terminate string.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 292ea9a2dc3d..e3bc00933145 100644
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

