Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969EA3AC017
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhFRAao convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Jun 2021 20:30:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2908 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233263AbhFRAan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 20:30:43 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I0PLU4009093
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 17:28:35 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3980gge2ua-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 17:28:35 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 17:28:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AF6D63D8012F; Thu, 17 Jun 2021 17:28:27 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: fix ringbuf test fetching map FD
Date:   Thu, 17 Jun 2021 17:28:24 -0700
Message-ID: <20210618002824.2081922-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: XSc4VmszpbVQfRRFp2hb5PmT7_hMRtCG
X-Proofpoint-ORIG-GUID: XSc4VmszpbVQfRRFp2hb5PmT7_hMRtCG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_16:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 mlxlogscore=685 adultscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106180000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seems like 4d1b62986125 ("selftests/bpf: Convert few tests to light skeleton.")
and 704e2beba23c ("selftests/bpf: Test ringbuf mmap read-only and read-write
restrictions") were done independently on bpf and bpf-next trees and are in
conflict with each other, despite a clean merge. Fix fetching of ringbuf's
map_fd to use light skeleton properly.

Fixes: 704e2beba23c ("selftests/bpf: Test ringbuf mmap read-only and read-write restrictions")
Fixes: 4d1b62986125 ("selftests/bpf: Convert few tests to light skeleton.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index a01788090c31..4706cee84360 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -100,7 +100,7 @@ void test_ringbuf(void)
 	if (CHECK(err != 0, "skel_load", "skeleton load failed\n"))
 		goto cleanup;
 
-	rb_fd = bpf_map__fd(skel->maps.ringbuf);
+	rb_fd = skel->maps.ringbuf.map_fd;
 	/* good read/write cons_pos */
 	mmap_ptr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, rb_fd, 0);
 	ASSERT_OK_PTR(mmap_ptr, "rw_cons_pos");
-- 
2.30.2

