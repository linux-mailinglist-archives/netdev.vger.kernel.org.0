Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B326165051
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBSUze convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Feb 2020 15:55:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgBSUze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:55:34 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01JKtVrw002858
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 12:55:33 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2y8ubumsjf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 12:55:33 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 19 Feb 2020 12:55:17 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2A168760B34; Wed, 19 Feb 2020 12:55:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: Fix build of sockmap_ktls.c
Date:   Wed, 19 Feb 2020 12:55:14 -0800
Message-ID: <20200219205514.3353788-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_06:2020-02-19,2020-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=972
 bulkscore=0 malwarescore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The selftests fails to build with:
tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c: In function ‘test_sockmap_ktls_disconnect_after_delete’:
tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c:72:37: error: ‘TCP_ULP’ undeclared (first use in this function)
   72 |  err = setsockopt(cli, IPPROTO_TCP, TCP_ULP, "tls", strlen("tls"));
      |                                     ^~~~~~~

Similar to commit that fixes build of sockmap_basic.c on systems with old
/usr/include fix the build of sockmap_ktls.c

Fixes: d1ba1204f2ee ("selftests/bpf: Test unhashing kTLS socket after removing from map")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
index 589b50c91b96..06b86addc181 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
@@ -7,6 +7,7 @@
 #include "test_progs.h"
 
 #define MAX_TEST_NAME 80
+#define TCP_ULP 31
 
 static int tcp_server(int family)
 {
-- 
2.23.0

