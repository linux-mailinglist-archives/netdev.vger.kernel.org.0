Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9892E34D
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfE2RgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfE2RgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:22 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THUsrE016360
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Li1F9UqFa+Xa1rlr9ak9WLn/iPiFsiufAIWiCeBLLJs=;
 b=ULVwyBSGlFczzMRAwPZMvCy+Rsp4hWI8ikAXTEgDozWSD/hevmYE2vwhUlbyPhSFn1zC
 Nf/xtUf5/Fvhsi7FWZ6vcd3y8gd4ioGJ+t9P6T9GszZXaWiF7fZnKWU1IQnu8rlQ+Mb+
 lfEuYgj8R29huWUeECsxn+PIc/cP9izJHSE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ssrf51btt-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:21 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:18 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8D0088617AE; Wed, 29 May 2019 10:36:17 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/9] libbpf: fix detection of corrupted BPF instructions section
Date:   Wed, 29 May 2019 10:36:03 -0700
Message-ID: <20190529173611.4012579-2-andriin@fb.com>
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
 mlxlogscore=888 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that size of a section w/ BPF instruction is exactly a multiple
of BPF instruction size.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ca4432f5b067..c6c9d632624a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -349,8 +349,11 @@ static int
 bpf_program__init(void *data, size_t size, char *section_name, int idx,
 		  struct bpf_program *prog)
 {
-	if (size < sizeof(struct bpf_insn)) {
-		pr_warning("corrupted section '%s'\n", section_name);
+	const size_t bpf_insn_sz = sizeof(struct bpf_insn);
+
+	if (size == 0 || size % bpf_insn_sz) {
+		pr_warning("corrupted section '%s', size: %zu\n",
+			   section_name, size);
 		return -EINVAL;
 	}
 
@@ -376,9 +379,8 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
 			   section_name);
 		goto errout;
 	}
-	prog->insns_cnt = size / sizeof(struct bpf_insn);
-	memcpy(prog->insns, data,
-	       prog->insns_cnt * sizeof(struct bpf_insn));
+	prog->insns_cnt = size / bpf_insn_sz;
+	memcpy(prog->insns, data, size);
 	prog->idx = idx;
 	prog->instances.fds = NULL;
 	prog->instances.nr = -1;
-- 
2.17.1

