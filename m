Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E293D33A14F
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhCMVJs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 16:09:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234182AbhCMVJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:09:33 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DL7nog025146
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:33 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378ucs9nya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:33 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 13:09:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 790F12ED2050; Sat, 13 Mar 2021 13:09:29 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 3/4] selftests/bpf: fix maybe-uninitialized warning in xdpxceiver test
Date:   Sat, 13 Mar 2021 13:09:19 -0800
Message-ID: <20210313210920.1959628-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313210920.1959628-1-andrii@kernel.org>
References: <20210313210920.1959628-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_10:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_ring_prod__reserve() doesn't necessarily set idx in some conditions, so
from static analysis point of view compiler is right about the problems like:

In file included from xdpxceiver.c:92:
xdpxceiver.c: In function ‘xsk_populate_fill_ring’:
/data/users/andriin/linux/tools/testing/selftests/bpf/tools/include/bpf/xsk.h:119:20: warning: ‘idx’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return &addrs[idx & fill->mask];
                ~~~~^~~~~~~~~~~~
xdpxceiver.c:300:6: note: ‘idx’ was declared here
  u32 idx;
      ^~~
xdpxceiver.c: In function ‘tx_only’:
xdpxceiver.c:596:30: warning: ‘idx’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix two warnings reported by compiler by pre-initializing variable.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8b0f7fdd9003..1e21a3172687 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -297,7 +297,7 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
 static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 {
 	int ret, i;
-	u32 idx;
+	u32 idx = 0;
 
 	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
@@ -584,7 +584,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 {
-	u32 idx;
+	u32 idx = 0;
 	unsigned int i;
 	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
 	u32 len = tx_invalid_test ? XSK_UMEM__DEFAULT_FRAME_SIZE + 1 : PKT_SIZE;
-- 
2.24.1

