Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB11C28C56F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390465AbgJLXuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:50:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389460AbgJLXuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 19:50:04 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CNnvgk003592
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 16:50:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=DTTjSIB8MQVwaw/rlRdz1VKVb2ywGrMhX8K8wwM/Q8A=;
 b=F1RqRx3N1yK4neRImzmcBYQlrYKb3ZSUlKS42JcTG3JlVJAPsw/kz0rAUSX+LMNY2pFD
 0LqfnbYD/otGyria+I7W5nTxcbLm+bu6DYDNtDXXXoGL5KyfWqaG/SndxCIha/dpVWHI
 QiKZNKtKn9TxanOxvveGvF1pVkPrD7saBlU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 343vfbqy9s-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 16:50:04 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 16:49:41 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5722329464F4; Mon, 12 Oct 2020 16:49:40 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf] bpf: selftest: Fix flaky tcp_hdr_options test when adding addr to lo
Date:   Mon, 12 Oct 2020 16:49:40 -0700
Message-ID: <20201012234940.1707941-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_18:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 suspectscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010120174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_hdr_options test adds a "::eB9F" addr to the lo dev.
However, this non loopback address will have a race on ipv6 dad
which may lead to EADDRNOTAVAIL error from time to time.

Even nodad is used in the iproute2 command, there is still a race in
when the route will be added.  This will then lead to ENETUNREACH from
time to time.

To avoid the above, this patch uses the default loopback address "::1"
to do the test.

Fixes: ad2f8eb0095e ("bpf: selftests: Tcp header options")
Reported-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/tcp_hdr_options.c          | 26 +------------------
 .../bpf/progs/test_misc_tcp_hdr_options.c     |  2 +-
 2 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index c86e67214a9e..c85174cdcb77 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -15,7 +15,7 @@
 #include "test_tcp_hdr_options.skel.h"
 #include "test_misc_tcp_hdr_options.skel.h"
=20
-#define LO_ADDR6 "::eB9F"
+#define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-hdr-opt-test"
=20
 struct bpf_test_option exp_passive_estab_in;
@@ -40,27 +40,6 @@ struct sk_fds {
 	int active_lport;
 };
=20
-static int add_lo_addr(void)
-{
-	char ip_addr_cmd[256];
-	int cmdlen;
-
-	cmdlen =3D snprintf(ip_addr_cmd, sizeof(ip_addr_cmd),
-			  "ip -6 addr add %s/128 dev lo scope host",
-			  LO_ADDR6);
-
-	if (CHECK(cmdlen >=3D sizeof(ip_addr_cmd), "compile ip cmd",
-		  "failed to add host addr %s to lo. ip cmdlen is too long\n",
-		  LO_ADDR6))
-		return -1;
-
-	if (CHECK(system(ip_addr_cmd), "run ip cmd",
-		  "failed to add host addr %s to lo\n", LO_ADDR6))
-		return -1;
-
-	return 0;
-}
-
 static int create_netns(void)
 {
 	if (CHECK(unshare(CLONE_NEWNET), "create netns",
@@ -72,9 +51,6 @@ static int create_netns(void)
 		  "failed to bring lo link up\n"))
 		return -1;
=20
-	if (add_lo_addr())
-		return -1;
-
 	return 0;
 }
=20
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.=
c b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
index 72ec0178f653..6077a025092c 100644
--- a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
@@ -16,7 +16,7 @@
 #define BPF_PROG_TEST_TCP_HDR_OPTIONS
 #include "test_tcp_hdr_options.h"
=20
-__u16 last_addr16_n =3D __bpf_htons(0xeB9F);
+__u16 last_addr16_n =3D __bpf_htons(1);
 __u16 active_lport_n =3D 0;
 __u16 active_lport_h =3D 0;
 __u16 passive_lport_n =3D 0;
--=20
2.24.1

