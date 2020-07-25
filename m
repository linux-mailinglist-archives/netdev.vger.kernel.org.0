Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9322D2CA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGYAEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:04:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39004 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726977AbgGYAEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:38 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06ONnhsI027954
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=m9nqxqECxychr9pV9MaWkZGUlt3JX3XgdCcRN5eRYho=;
 b=PryLGD8e1VbAEoeCAE51w5FU5FUmOfm9xdzIuxE70U7Ng7VVe68qGDoZCpTn1xn1qGTI
 t05kDCM0wCLSpAAcPhlBkndy7CF9OUMFd/sng22ZsE71GGz8O7l1OZXfcDahAk3Nj71N
 fyaRcIDSvDu70yliPgGwf0pz/Ygk8MhEefY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32esdjvm75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:37 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:36 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 2F1CD1B35A9E; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 25/35] bpf: eliminate rlimit-based memory accounting for socket storage maps
Date:   Fri, 24 Jul 2020 17:04:00 -0700
Message-ID: <20200725000410.3566700-26-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=13 bulkscore=0 priorityscore=1501 mlxlogscore=908
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for socket storage maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/core/bpf_sk_storage.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index fbcd03cd00d3..c0a35b6368af 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -676,8 +676,6 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union=
 bpf_attr *attr)
 	struct bpf_sk_storage_map *smap;
 	unsigned int i;
 	u32 nbuckets;
-	u64 cost;
-	int ret;
=20
 	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT=
);
 	if (!smap)
@@ -688,18 +686,9 @@ static struct bpf_map *bpf_sk_storage_map_alloc(unio=
n bpf_attr *attr)
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1=
 bucket */
 	nbuckets =3D max_t(u32, 2, nbuckets);
 	smap->bucket_log =3D ilog2(nbuckets);
-	cost =3D sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
-
-	ret =3D bpf_map_charge_init(&smap->map.memory, cost);
-	if (ret < 0) {
-		kfree(smap);
-		return ERR_PTR(ret);
-	}
-
 	smap->buckets =3D kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		bpf_map_charge_finish(&smap->map.memory);
 		kfree(smap);
 		return ERR_PTR(-ENOMEM);
 	}
--=20
2.26.2

