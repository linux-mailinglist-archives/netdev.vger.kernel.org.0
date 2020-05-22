Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18991DDD14
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgEVCYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:24:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727050AbgEVCYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 22:24:08 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M2O7Mp018088
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:24:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gU+TNATQ6pS6u5lCv+LO1PcwVc8Wrajrb96jRxaRnMs=;
 b=BwVrVZnb+ren9zjhCTf6vka3t/uirAaX0rXx7sm0w+UOBQKISgoN5cLf8M1FTzy1ybw3
 A9J5ov5JwmFxYxNxdTQN4Bgqu/h7IuFdeX6BwThjFBPf6OHe/vHZSZnVIQ2C2PMwlLUG
 NI2XKnyZJNx6ZiNM8mvNRNF7fn8okRdCTpI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 314jubn1sn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:24:07 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 19:23:57 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 74E8829455B1; Thu, 21 May 2020 19:23:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] bpf: selftests: Add test for different inner map size
Date:   Thu, 21 May 2020 19:23:55 -0700
Message-ID: <20200522022355.900283-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522022336.899416-1-kafai@fb.com>
References: <20200522022336.899416-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_16:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 mlxlogscore=674 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 suspectscore=13 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tests the inner map size can be different
for reuseport_sockarray but has to be the same for
arraymap.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 12 +++++++
 .../selftests/bpf/progs/test_btf_map_in_map.c | 31 +++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/to=
ols/testing/selftests/bpf/prog_tests/btf_map_in_map.c
index f7ee8fa377ad..7ae767d15608 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
@@ -44,6 +44,18 @@ void test_btf_map_in_map(void)
 	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
 	CHECK(val !=3D 3, "inner2", "got %d !=3D exp %d\n", val, 3);
=20
+	val =3D bpf_map__fd(skel->maps.sockarr_sz2);
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.outer_sockarr_sz1),
+				  &key, &val, 0);
+	CHECK(err, "outer_sockarr inner map size check",
+	      "cannot use an inner_map with different size\n");
+
+	val =3D bpf_map__fd(skel->maps.inner_map_sz2);
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key,
+				  &val, 0);
+	CHECK(!err, "outer_arr inner map size check",
+	      "incorrectly updated with an inner_map in different size\n");
+
 cleanup:
 	test_btf_map_in_map__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c b/to=
ols/testing/selftests/bpf/progs/test_btf_map_in_map.c
index e5093796be97..0b8e04a817f6 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
@@ -11,6 +11,13 @@ struct inner_map {
 } inner_map1 SEC(".maps"),
   inner_map2 SEC(".maps");
=20
+struct inner_map_sz2 {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, int);
+} inner_map_sz2 SEC(".maps");
+
 struct outer_arr {
 	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
 	__uint(max_entries, 3);
@@ -50,6 +57,30 @@ struct outer_hash {
 	},
 };
=20
+struct sockarr_sz1 {
+	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} sockarr_sz1 SEC(".maps");
+
+struct sockarr_sz2 {
+	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, int);
+} sockarr_sz2 SEC(".maps");
+
+struct outer_sockarr_sz1 {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__array(values, struct sockarr_sz1);
+} outer_sockarr_sz1 SEC(".maps") =3D {
+	.values =3D { (void *)&sockarr_sz1 },
+};
+
 int input =3D 0;
=20
 SEC("raw_tp/sys_enter")
--=20
2.24.1

