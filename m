Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA56331E05
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 05:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCIEnm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Mar 2021 23:43:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhCIEn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 23:43:26 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1294dhNM029180
        for <netdev@vger.kernel.org>; Mon, 8 Mar 2021 20:43:26 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 374tew0qem-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 20:43:26 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 8 Mar 2021 20:43:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A3A642ED1B43; Mon,  8 Mar 2021 20:43:23 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: fix compiler warning in BPF_KPROBE definition in loop6.c
Date:   Mon, 8 Mar 2021 20:43:22 -0800
Message-ID: <20210309044322.3487636-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_03:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=871 phishscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing return type to BPF_KPROBE definition. Without it, compiler
generates the following warning:

progs/loop6.c:68:12: warning: type specifier missing, defaults to 'int' [-Wimplicit-int]
BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
           ^
1 warning generated.

Fixes: 86a35af628e5 ("selftests/bpf: Add a verifier scale test with unknown bounded loop")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/progs/loop6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/loop6.c b/tools/testing/selftests/bpf/progs/loop6.c
index 2a7141ac1656..38de0331e6b4 100644
--- a/tools/testing/selftests/bpf/progs/loop6.c
+++ b/tools/testing/selftests/bpf/progs/loop6.c
@@ -65,8 +65,8 @@ int config = 0;
 int result = 0;
 
 SEC("kprobe/virtqueue_add_sgs")
-BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
-	   unsigned int out_sgs, unsigned int in_sgs)
+int BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
+	       unsigned int out_sgs, unsigned int in_sgs)
 {
 	struct scatterlist *sgp = NULL;
 	__u64 length1 = 0, length2 = 0;
-- 
2.24.1

