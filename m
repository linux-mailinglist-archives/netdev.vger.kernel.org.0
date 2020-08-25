Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF51F252417
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHYXVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:21:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57096 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbgHYXU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:20:56 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PNKp6U027626
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CrnoMD0NeVZDGnzgwKPVVuhrCRvjB5I1gOKyBPSfx4Y=;
 b=f3tmtc2fjf0310tAysttYqdwtUepDxFjzvPI8DTunO/0fXhNhQj+NTEbOoABs4gowcC4
 ySVmM5CJYrANoTHqySIzmdqx9mXjQhWaduo7niqMiWowWKKPu39fKC2W8UEUbcoajRnQ
 /wc5QmktKz7pnduSkgGwZhdctCrZZzz0UWk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3330vjrub0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:54 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 16:20:47 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id 3FD1A2077AE; Tue, 25 Aug 2020 16:20:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Udip Pant <udippant@fb.com>
Smtp-Origin-Hostname: devbig218.frc2.facebook.com
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Smtp-Origin-Cluster: frc2c02
Subject: [PATCH bpf-next v3 2/4] selftests/bpf: add test for freplace program with write access
Date:   Tue, 25 Aug 2020 16:20:01 -0700
Message-ID: <20200825232003.2877030-3-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
References: <20200825232003.2877030-1-udippant@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest that tests the behavior when a freplace target progr=
am
attempts to make a write access on a packet. The expectation is that the =
read or write
access is granted based on the program type of the linked program and
not itself (which is of type, for e.g., BPF_PROG_TYPE_EXT).

This test fails without the associated patch on the verifier.

Signed-off-by: Udip Pant <udippant@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  1 +
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 +++++++++++++++++++
 .../selftests/bpf/progs/test_pkt_access.c     | 20 ++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 197d0d217b56..7c7168963d52 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -123,6 +123,7 @@ static void test_func_replace(void)
 		"freplace/get_skb_len",
 		"freplace/get_skb_ifindex",
 		"freplace/get_constant",
+		"freplace/test_pkt_write_access_subprog",
 	};
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
 				  "./test_pkt_access.o",
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/te=
sting/selftests/bpf/progs/fexit_bpf2bpf.c
index 98e1efe14549..49a84a3a2306 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <linux/stddef.h>
+#include <linux/if_ether.h>
 #include <linux/ipv6.h>
 #include <linux/bpf.h>
+#include <linux/tcp.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 #include <bpf/bpf_tracing.h>
@@ -151,4 +153,29 @@ int new_get_constant(long val)
 	test_get_constant =3D 1;
 	return test_get_constant; /* original get_constant() returns val - 122 =
*/
 }
+
+__u64 test_pkt_write_access_subprog =3D 0;
+SEC("freplace/test_pkt_write_access_subprog")
+int new_test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
+{
+
+	void *data =3D (void *)(long)skb->data;
+	void *data_end =3D (void *)(long)skb->data_end;
+	struct tcphdr *tcp;
+
+	if (off > sizeof(struct ethhdr) + sizeof(struct ipv6hdr))
+		return -1;
+
+	tcp =3D data + off;
+	if (tcp + 1 > data_end)
+		return -1;
+
+	/* make modifications to the packet data */
+	tcp->check++;
+	tcp->syn =3D 0;
+
+	test_pkt_write_access_subprog =3D 1;
+	return 0;
+}
+
 char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/=
testing/selftests/bpf/progs/test_pkt_access.c
index e72eba4a93d2..852051064507 100644
--- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
+++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
@@ -79,6 +79,24 @@ int get_skb_ifindex(int val, struct __sk_buff *skb, in=
t var)
 	return skb->ifindex * val * var;
 }
=20
+__attribute__ ((noinline))
+int test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
+{
+	void *data =3D (void *)(long)skb->data;
+	void *data_end =3D (void *)(long)skb->data_end;
+	struct tcphdr *tcp =3D NULL;
+
+	if (off > sizeof(struct ethhdr) + sizeof(struct ipv6hdr))
+		return -1;
+
+	tcp =3D data + off;
+	if (tcp + 1 > data_end)
+		return -1;
+	/* make modification to the packet data */
+	tcp->check++;
+	return 0;
+}
+
 SEC("classifier/test_pkt_access")
 int test_pkt_access(struct __sk_buff *skb)
 {
@@ -117,6 +135,8 @@ int test_pkt_access(struct __sk_buff *skb)
 	if (test_pkt_access_subprog3(3, skb) !=3D skb->len * 3 * skb->ifindex)
 		return TC_ACT_SHOT;
 	if (tcp) {
+		if (test_pkt_write_access_subprog(skb, (void *)tcp - data))
+			return TC_ACT_SHOT;
 		if (((void *)(tcp) + 20) > data_end || proto !=3D 6)
 			return TC_ACT_SHOT;
 		barrier(); /* to force ordering of checks */
--=20
2.24.1

