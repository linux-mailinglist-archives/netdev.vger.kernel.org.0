Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20AC1FD3A0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgFQRm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:42:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgFQRm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:42:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HHXBJU011797
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:42:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=PYgiC4RtNGwUt/8nCfb+htud5QZ91fDyCfx3NgcWYa4=;
 b=mCqYgSV8zh1KHRFA4xrNN1EtF32zOikOK8FVEsc6Wn/Dl66OrhnM1zYFikWOUT4FQ7K8
 ay8GNPd7KgloxFpJOT3D9Ag1UQJvkjfhs3Bi9ykTOrctgOJ6xvWBsQD4g6Uba36eGVmn
 2NAELVT5Aeb0L1UJ+XE97D4CQ4K16D76tig= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q8u6dv0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:42:28 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 10:42:27 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CD3042942DA5; Wed, 17 Jun 2020 10:42:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: sk_storage: Prefer to get a free cache_idx
Date:   Wed, 17 Jun 2020 10:42:26 -0700
Message-ID: <20200617174226.2301909-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_07:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 cotscore=-2147483648 malwarescore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=962 mlxscore=0 suspectscore=38 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cache_idx is currently picked by RR.  There is chance that
the same cache_idx will be picked by multiple sk_storage_maps while
other cache_idx is still unused.  e.g. It could happen when the
sk_storage_map is recreated during the restart of the user
space process.

This patch tracks the usage count for each cache_idx.  There is
16 of them now (defined in BPF_SK_STORAGE_CACHE_SIZE).
It will try to pick the free cache_idx.  If none was found,
it would pick one with the minimal usage count.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/bpf_sk_storage.c | 41 +++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index d2c4d16dadba..1dae4b543243 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -11,8 +11,6 @@
 #include <uapi/linux/sock_diag.h>
 #include <uapi/linux/btf.h>
=20
-static atomic_t cache_idx;
-
 #define SK_STORAGE_CREATE_FLAG_MASK					\
 	(BPF_F_NO_PREALLOC | BPF_F_CLONE)
=20
@@ -81,6 +79,9 @@ struct bpf_sk_storage_elem {
 #define SDATA(_SELEM) (&(_SELEM)->sdata)
 #define BPF_SK_STORAGE_CACHE_SIZE	16
=20
+static DEFINE_SPINLOCK(cache_idx_lock);
+static u64 cache_idx_usage_counts[BPF_SK_STORAGE_CACHE_SIZE];
+
 struct bpf_sk_storage {
 	struct bpf_sk_storage_data __rcu *cache[BPF_SK_STORAGE_CACHE_SIZE];
 	struct hlist_head list;	/* List of bpf_sk_storage_elem */
@@ -512,6 +513,37 @@ static int sk_storage_delete(struct sock *sk, struct=
 bpf_map *map)
 	return 0;
 }
=20
+static u16 cache_idx_get(void)
+{
+	u64 min_usage =3D U64_MAX;
+	u16 i, res =3D 0;
+
+	spin_lock(&cache_idx_lock);
+
+	for (i =3D 0; i < BPF_SK_STORAGE_CACHE_SIZE; i++) {
+		if (cache_idx_usage_counts[i] < min_usage) {
+			min_usage =3D cache_idx_usage_counts[i];
+			res =3D i;
+
+			/* Found a free cache_idx */
+			if (!min_usage)
+				break;
+		}
+	}
+	cache_idx_usage_counts[res]++;
+
+	spin_unlock(&cache_idx_lock);
+
+	return res;
+}
+
+static void cache_idx_free(u16 idx)
+{
+	spin_lock(&cache_idx_lock);
+	cache_idx_usage_counts[idx]--;
+	spin_unlock(&cache_idx_lock);
+}
+
 /* Called by __sk_destruct() & bpf_sk_storage_clone() */
 void bpf_sk_storage_free(struct sock *sk)
 {
@@ -560,6 +592,8 @@ static void bpf_sk_storage_map_free(struct bpf_map *m=
ap)
=20
 	smap =3D (struct bpf_sk_storage_map *)map;
=20
+	cache_idx_free(smap->cache_idx);
+
 	/* Note that this map might be concurrently cloned from
 	 * bpf_sk_storage_clone. Wait for any existing bpf_sk_storage_clone
 	 * RCU read section to finish before proceeding. New RCU
@@ -673,8 +707,7 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union=
 bpf_attr *attr)
 	}
=20
 	smap->elem_size =3D sizeof(struct bpf_sk_storage_elem) + attr->value_si=
ze;
-	smap->cache_idx =3D (unsigned int)atomic_inc_return(&cache_idx) %
-		BPF_SK_STORAGE_CACHE_SIZE;
+	smap->cache_idx =3D cache_idx_get();
=20
 	return &smap->map;
 }
--=20
2.24.1

