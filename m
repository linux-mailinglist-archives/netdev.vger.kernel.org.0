Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8535D3AA9D2
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhFQERQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Jun 2021 00:17:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32788 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhFQERP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:17:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15H4D7lA012861
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:15:07 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 397tkf99pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:15:07 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 21:15:06 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5C3943D808A8; Wed, 16 Jun 2021 21:14:47 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH bpf-next] selftests/bpf: fix selftests build with old system-wide headers
Date:   Wed, 16 Jun 2021 21:14:46 -0700
Message-ID: <20210617041446.425283-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xrsSmj6EO3yBjt8Gx2bPdtAUlGj3GYOV
X-Proofpoint-ORIG-GUID: xrsSmj6EO3yBjt8Gx2bPdtAUlGj3GYOV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_01:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 impostorscore=0 phishscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=714 adultscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

migrate_reuseport.c selftest relies on having TCP_FASTOPEN_CONNECT defined in
system-wide netinet/tcp.h. Selftests can use up-to-date uapi/linux/tcp.h, but
that one doesn't have SOL_TCP. So instead of switching everything to uapi
header, add #define for TCP_FASTOPEN_CONNECT to fix the build.

Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Fixes: c9d0bdef89a6 ("bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
index 0fa3f750567d..59adb4715394 100644
--- a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -30,6 +30,10 @@
 #include "test_migrate_reuseport.skel.h"
 #include "network_helpers.h"
 
+#ifndef TCP_FASTOPEN_CONNECT
+#define TCP_FASTOPEN_CONNECT 30
+#endif
+
 #define IFINDEX_LO 1
 
 #define NR_SERVERS 5
-- 
2.30.2

