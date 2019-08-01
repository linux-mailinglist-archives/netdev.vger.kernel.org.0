Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB4F7D63B
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfHAHYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:24:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61696 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730763AbfHAHYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:24:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x717OYqC016094
        for <netdev@vger.kernel.org>; Thu, 1 Aug 2019 00:24:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=RYLwBism92fkaf/clIOb5zGtUeHI4x+0NDU5AO1wlns=;
 b=mTfx8wvMFiHojiIG00tnne+c1TQ21cGeHq1RVw5ry+NokbadOJrJaFLD+pVBIG+/KdCf
 L6JEZsA0W1yg2MwNSX2Ybpcz57FTRUJ4Lqe48WjDmcWEom0bxqsUwFrlbxbOhiXQRef2
 ThF1tRIebKLiWDmaADfU6b/5ZyoWfYn4FQ8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u3cxbk3pj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 00:24:34 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 1 Aug 2019 00:24:33 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2FB0386167B; Thu,  1 Aug 2019 00:24:30 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: set BTF FD for prog only when there is supported .BTF.ext data
Date:   Thu, 1 Aug 2019 00:24:05 -0700
Message-ID: <20190801072405.2835116-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-01_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908010075
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
introduced backwards-compatibility issue, manifesting itself as -E2BIG
error returned on program load due to unknown non-zero btf_fd attribute
value for BPF_PROG_LOAD sys_bpf() sub-command.

This patch fixes bug by ensuring that we only ever associate BTF FD with
program if there is a BTF.ext data that was successfully loaded into
kernel, which automatically means kernel supports func_info/line_info
and associated BTF FD for progs (checked and ensured also by BTF
sanitization code).

Fixes: 5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2e84fa5b8479..2b57d7ea7836 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2472,7 +2472,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	btf_fd = bpf_object__btf_fd(prog->obj);
+	/* if .BTF.ext was loaded, kernel supports associated BTF for prog */
+	if (prog->obj->btf_ext)
+		btf_fd = bpf_object__btf_fd(prog->obj);
+	else
+		btf_fd = -1;
 	load_attr.prog_btf_fd = btf_fd >= 0 ? btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
-- 
2.17.1

