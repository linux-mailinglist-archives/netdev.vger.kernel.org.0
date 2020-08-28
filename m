Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFCE25527E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgH1BSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:18:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728165AbgH1BSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:18:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S1Apic007962
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZmBbOgr4Ws+CzFT+s76CxNRmU9CVHtqyrhhBePCAmls=;
 b=T+SZ+3g/jBOPiSH6DlcXdGIC0ixNNkWrZLGjGCVg4Sin2Pht5zZWMSL6gsIp25uyaefl
 E7wz8jSlR9bxIxw9Rs9Cj9XirPrHc6MyPi/EiUOPIQrKo7qq3CfLxFnwxN9wg9/SZsej
 onVgAVxauPz7DEml7jg81UqClOQ6s7qzLsc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up88hbv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:21 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 18:18:20 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 683A72946559; Thu, 27 Aug 2020 18:18:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] bpf: selftests: Add test for different inner map size
Date:   Thu, 27 Aug 2020 18:18:19 -0700
Message-ID: <20200828011819.1970825-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200828011800.1970018-1-kafai@fb.com>
References: <20200828011800.1970018-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_14:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=917 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tests the inner map size can be different
for reuseport_sockarray but has to be the same for
arraymap.  A new subtest "diff_size" is added for this.

The existing test is moved to a subtest "lookup_update".

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 35 ++++++++++++++++++-
 .../selftests/bpf/progs/test_btf_map_in_map.c | 31 ++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/to=
ols/testing/selftests/bpf/prog_tests/btf_map_in_map.c
index 6ccecbd39476..540fea4c91a5 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
@@ -53,7 +53,7 @@ static int kern_sync_rcu(void)
 	return err;
 }
=20
-void test_btf_map_in_map(void)
+static void test_lookup_update(void)
 {
 	int err, key =3D 0, val, i;
 	struct test_btf_map_in_map *skel;
@@ -143,3 +143,36 @@ void test_btf_map_in_map(void)
 cleanup:
 	test_btf_map_in_map__destroy(skel);
 }
+
+static void test_diff_size(void)
+{
+	struct test_btf_map_in_map *skel;
+	int err, inner_map_fd, zero =3D 0;
+
+	skel =3D test_btf_map_in_map__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
+		return;
+
+	inner_map_fd =3D bpf_map__fd(skel->maps.sockarr_sz2);
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.outer_sockarr), &zer=
o,
+				  &inner_map_fd, 0);
+	CHECK(err, "outer_sockarr inner map size check",
+	      "cannot use a different size inner_map\n");
+
+	inner_map_fd =3D bpf_map__fd(skel->maps.inner_map_sz2);
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &zero,
+				  &inner_map_fd, 0);
+	CHECK(!err, "outer_arr inner map size check",
+	      "incorrectly updated with a different size inner_map\n");
+
+	test_btf_map_in_map__destroy(skel);
+}
+
+void test_btf_map_in_map(void)
+{
+	if (test__start_subtest("lookup_update"))
+		test_lookup_update();
+
+	if (test__start_subtest("diff_size"))
+		test_diff_size();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c b/to=
ols/testing/selftests/bpf/progs/test_btf_map_in_map.c
index e5093796be97..193fe0198b21 100644
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
+} outer_sockarr SEC(".maps") =3D {
+	.values =3D { (void *)&sockarr_sz1 },
+};
+
 int input =3D 0;
=20
 SEC("raw_tp/sys_enter")
--=20
2.24.1

