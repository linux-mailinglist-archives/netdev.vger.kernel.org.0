Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A29EA7C8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfJ3Xa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:30:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbfJ3Xa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:30:26 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9UNTwZe007729
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 16:30:25 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vxwn8xke5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 16:30:25 -0700
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 30 Oct 2019 16:30:23 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9CFD0760EEC; Wed, 30 Oct 2019 16:30:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <jolsa@redhat.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Fix bpf jit kallsym access
Date:   Wed, 30 Oct 2019 16:30:19 -0700
Message-ID: <20191030233019.1187404-1-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=940
 bulkscore=0 spamscore=0 suspectscore=1 priorityscore=1501 mlxscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1034 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910300211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri reported crash when JIT is on, but net.core.bpf_jit_kallsyms is off.
bpf_prog_kallsyms_find() was skipping addr->bpf_prog resolution
logic in oops and stack traces. That's incorrect.
It should only skip addr->name resolution for 'cat /proc/kallsyms'.
That's what bpf_jit_kallsyms and bpf_jit_harden protect.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 3dec541b2e63 ("bpf: Add support for BTF pointers to x86 JIT")
---
 kernel/bpf/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 673f5d40a93e..8d3fbc86ca5e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -668,9 +668,6 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 {
 	struct latch_tree_node *n;
 
-	if (!bpf_jit_kallsyms_enabled())
-		return NULL;
-
 	n = latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
 	return n ?
 	       container_of(n, struct bpf_prog_aux, ksym_tnode)->prog :
-- 
2.17.1

