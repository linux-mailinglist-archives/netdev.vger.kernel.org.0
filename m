Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9104525B770
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgIBXxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:53:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726913AbgIBXxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:53:44 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082NdjRS014539
        for <netdev@vger.kernel.org>; Wed, 2 Sep 2020 16:53:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BsOEk19++R8OQ9HRuWMY36bAvQupS16Y2QvJq78mUSg=;
 b=pA+IY2Wp1zRo1jDYJHqUth6jqQqoOvJSWW4gly+JlwAsi/uUdFWaamNBntAo11eMe0/z
 pQPRIgWI9I64lg6VGnpeKzVfV9MhpT/xzbihSAp1a62Clo+7EPDOsVGCF083uCBJdsn+
 mrPvOvMZSnQGO+UrPszUZSlt83byS7Qayis= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33879nvgu1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 16:53:43 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Sep 2020 16:53:42 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CF6FB3704F6D; Wed,  2 Sep 2020 16:53:41 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf 2/2] selftests/bpf: add bpf_{update,delete}_map_elem in hashmap iter program
Date:   Wed, 2 Sep 2020 16:53:41 -0700
Message-ID: <20200902235341.2001534-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200902235340.2001300-1-yhs@fb.com>
References: <20200902235340.2001300-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=825 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009020222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added bpf_{updata,delete}_map_elem to the very map element the
iter program is visiting. Due to rcu protection, the visited map
elements, although stale, should still contain correct values.
  $ ./test_progs -n 4/18
  #4/18 bpf_hash_map:OK
  #4 bpf_iter:OK
  Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c   | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c b/=
tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
index 07ddbfdbcab7..6dfce3fd68bc 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
@@ -47,7 +47,10 @@ int dump_bpf_hash_map(struct bpf_iter__bpf_map_elem *c=
tx)
 	__u32 seq_num =3D ctx->meta->seq_num;
 	struct bpf_map *map =3D ctx->map;
 	struct key_t *key =3D ctx->key;
+	struct key_t tmp_key;
 	__u64 *val =3D ctx->value;
+	__u64 tmp_val =3D 0;
+	int ret;
=20
 	if (in_test_mode) {
 		/* test mode is used by selftests to
@@ -61,6 +64,18 @@ int dump_bpf_hash_map(struct bpf_iter__bpf_map_elem *c=
tx)
 		if (key =3D=3D (void *)0 || val =3D=3D (void *)0)
 			return 0;
=20
+		/* update the value and then delete the <key, value> pair.
+		 * it should not impact the existing 'val' which is still
+		 * accessible under rcu.
+		 */
+		__builtin_memcpy(&tmp_key, key, sizeof(struct key_t));
+		ret =3D bpf_map_update_elem(&hashmap1, &tmp_key, &tmp_val, 0);
+		if (ret)
+			return 0;
+		ret =3D bpf_map_delete_elem(&hashmap1, &tmp_key);
+		if (ret)
+			return 0;
+
 		key_sum_a +=3D key->a;
 		key_sum_b +=3D key->b;
 		key_sum_c +=3D key->c;
--=20
2.24.1

