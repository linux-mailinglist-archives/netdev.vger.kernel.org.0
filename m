Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6552415E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349553AbiELAGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349569AbiELAGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:06:23 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9882B24F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:19 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwjwl012850
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=OQsHd5Wn0LindOFAJmwntmJ7SIuup+aWXsuYfB5PkaQ=;
 b=V9a2SOfiDJaeK0JIfgVBB8wJRMA7rnNHzlDgNhETdmfvSZuc6Z2ewOTxCHmJYqy+On62
 X6RqbrRP+jt9PYjREuabLZ/QJNhhgq2Y6IRp8LWeVuTNcfV6ueEYulqzpPOqSNWW2pyo
 WQExZbGMhPwJWlG3KeoHXrM0GPb9sSnvb7w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyx8p9kqm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:19 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:06:17 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id CBB434AD251F; Wed, 11 May 2022 17:06:11 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/4] net: selftests: Stress reuseport listen
Date:   Wed, 11 May 2022 17:06:11 -0700
Message-ID: <20220512000611.191789-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
References: <20220512000546.188616-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: pl7ouwZ6XZRJZyyznlr7qc3p_P1lU3Bc
X-Proofpoint-ORIG-GUID: pl7ouwZ6XZRJZyyznlr7qc3p_P1lU3Bc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test that has 300 VIPs listening on port 443.
Each VIP:443 will have 80 listening socks by using SO_REUSEPORT.
Thus, it will have 24000 listening socks.

Before removing the port only listening_hash, all socks will be in the
same port 443 bucket and inet_reuseport_add_sock() spends much time to
walk through the bucket.  After removing the port only listening_hash
and move all usage to the port+addr lhash2, each bucket in the
ideal case has 80 sk which is much smaller than before.

Here is the test result from a qemu:
Before: listen 24000 socks took 210.210485362 (~210s)
 After: listen 24000 socks took 0.207173      (~210ms)

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/stress_reuseport_listen.c   | 105 ++++++++++++++++++
 .../selftests/net/stress_reuseport_listen.sh  |  25 +++++
 3 files changed, 132 insertions(+)
 create mode 100644 tools/testing/selftests/net/stress_reuseport_listen.c
 create mode 100755 tools/testing/selftests/net/stress_reuseport_listen.s=
h

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index 0fbdacfdcd6a..afada3d09dde 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -37,6 +37,7 @@ TEST_PROGS +=3D srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS +=3D vrf_strict_mode_test.sh
 TEST_PROGS +=3D arp_ndisc_evict_nocarrier.sh
 TEST_PROGS +=3D ndisc_unsolicited_na_test.sh
+TEST_PROGS +=3D stress_reuseport_listen.sh
 TEST_PROGS_EXTENDED :=3D in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED +=3D toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =3D  socket nettest
@@ -55,6 +56,7 @@ TEST_GEN_PROGS =3D reuseport_bpf reuseport_bpf_cpu reus=
eport_bpf_numa
 TEST_GEN_PROGS +=3D reuseport_dualstack reuseaddr_conflict tls
 TEST_GEN_FILES +=3D toeplitz
 TEST_GEN_FILES +=3D cmsg_sender
+TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
=20
 TEST_FILES :=3D settings
diff --git a/tools/testing/selftests/net/stress_reuseport_listen.c b/tool=
s/testing/selftests/net/stress_reuseport_listen.c
new file mode 100644
index 000000000000..ef800bb35a8e
--- /dev/null
+++ b/tools/testing/selftests/net/stress_reuseport_listen.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2022 Meta Platforms, Inc. and affiliates. */
+
+/* Test listening on the same port 443 with multiple VIPS.
+ * Each VIP:443 will have multiple sk listening on by using
+ * SO_REUSEPORT.
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <error.h>
+#include <errno.h>
+#include <time.h>
+#include <arpa/inet.h>
+
+#define IP6_LADDR_START "2401:dead::1"
+#define IP6_LPORT 443
+#define NSEC_PER_SEC 1000000000L
+#define NSEC_PER_USEC 1000L
+
+static unsigned int nr_socks_per_vip;
+static unsigned int nr_vips;
+
+static int *bind_reuseport_sock6(void)
+{
+	int *lfds, *cur_fd, err, optvalue =3D 1;
+	struct sockaddr_in6 sa6 =3D {};
+	unsigned int i, j;
+
+	sa6.sin6_family =3D AF_INET6;
+	sa6.sin6_port =3D htons(IP6_LPORT);
+	err =3D inet_pton(AF_INET6, IP6_LADDR_START, &sa6.sin6_addr);
+	if (err !=3D 1)
+		error(1, err, "inet_pton(%s)", IP6_LADDR_START);
+
+	lfds =3D malloc(nr_vips * nr_socks_per_vip * sizeof(lfds[0]));
+	if (!lfds)
+		error(1, errno, "cannot alloc array of lfds");
+
+	cur_fd =3D lfds;
+	for (i =3D 0; i < nr_vips; i++) {
+		for (j =3D 0; j < nr_socks_per_vip; j++) {
+			*cur_fd =3D socket(AF_INET6, SOCK_STREAM, 0);
+			if (*cur_fd =3D=3D -1)
+				error(1, errno,
+				      "lfds[%u,%u] =3D socket(AF_INET6)", i, j);
+
+			err =3D setsockopt(*cur_fd, SOL_SOCKET, SO_REUSEPORT,
+					 &optvalue, sizeof(optvalue));
+			if (err)
+				error(1, errno,
+				      "setsockopt(lfds[%u,%u], SO_REUSEPORT)",
+				      i, j);
+
+			err =3D bind(*cur_fd, (struct sockaddr *)&sa6,
+				   sizeof(sa6));
+			if (err)
+				error(1, errno, "bind(lfds[%u,%u])", i, j);
+			cur_fd++;
+		}
+		sa6.sin6_addr.s6_addr32[3]++;
+	}
+
+	return lfds;
+}
+
+int main(int argc, const char *argv[])
+{
+	struct timespec start_ts, end_ts;
+	unsigned long start_ns, end_ns;
+	unsigned int nr_lsocks;
+	int *lfds, i, err;
+
+	if (argc !=3D 3 || atoi(argv[1]) <=3D 0 || atoi(argv[2]) <=3D 0)
+		error(1, 0, "Usage: %s <nr_vips> <nr_socks_per_vip>\n",
+		      argv[0]);
+
+	nr_vips =3D atoi(argv[1]);
+	nr_socks_per_vip =3D atoi(argv[2]);
+	nr_lsocks =3D nr_vips * nr_socks_per_vip;
+	lfds =3D bind_reuseport_sock6();
+
+	clock_gettime(CLOCK_MONOTONIC, &start_ts);
+	for (i =3D 0; i < nr_lsocks; i++) {
+		err =3D listen(lfds[i], 0);
+		if (err)
+			error(1, errno, "listen(lfds[%d])", i);
+	}
+	clock_gettime(CLOCK_MONOTONIC, &end_ts);
+
+	start_ns =3D start_ts.tv_sec * NSEC_PER_SEC + start_ts.tv_nsec;
+	end_ns =3D end_ts.tv_sec * NSEC_PER_SEC + end_ts.tv_nsec;
+
+	printf("listen %d socks took %lu.%lu\n", nr_lsocks,
+	       (end_ns - start_ns) / NSEC_PER_SEC,
+	       (end_ns - start_ns) / NSEC_PER_USEC);
+
+	for (i =3D 0; i < nr_lsocks; i++)
+		close(lfds[i]);
+
+	free(lfds);
+	return 0;
+}
diff --git a/tools/testing/selftests/net/stress_reuseport_listen.sh b/too=
ls/testing/selftests/net/stress_reuseport_listen.sh
new file mode 100755
index 000000000000..4de11da4092b
--- /dev/null
+++ b/tools/testing/selftests/net/stress_reuseport_listen.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+
+NS=3D'stress_reuseport_listen_ns'
+NR_FILES=3D24100
+SAVED_NR_FILES=3D$(ulimit -n)
+
+setup() {
+	ip netns add $NS
+	ip netns exec $NS sysctl -q -w net.ipv6.ip_nonlocal_bind=3D1
+	ulimit -n $NR_FILES
+}
+
+cleanup() {
+	ip netns del $NS
+	ulimit -n $SAVED_NR_FILES
+}
+
+trap cleanup EXIT
+setup
+# 300 different vips listen on port 443
+# Each vip:443 sockaddr has 80 LISTEN sock by using SO_REUSEPORT
+# Total 24000 listening socks
+ip netns exec $NS ./stress_reuseport_listen 300 80
--=20
2.30.2

