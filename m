Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C07B2B9980
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgKSRiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:38:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729502AbgKSRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:16 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AJHTu37026463
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LTLQPyjn9AU74KKeleForoHMcwhDRBWJSiJ+HSA8Smc=;
 b=Cmhswu7SdzqeUgjJUlgDdO/vAHYrjChrkNRZYmG2HHVazyYGfwYEm6VCRcLLY8TrCVhq
 6gWExz0Ja6EuWaQzq4ojMV7rvWesFT5a63C2QazoWwCyEwL2M8XOHU7rGhimgIkvcM0s
 HtbxjZuAPUJN/fEXeaI7SrO+bKZ/jpZZ7Gg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34wfdq70ae-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:15 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:04 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id E78DF145BD07; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 24/34] bpf: eliminate rlimit-based memory accounting for lpm_trie maps
Date:   Thu, 19 Nov 2020 09:37:44 -0800
Message-ID: <20201119173754.4125257-25-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=700 malwarescore=0 bulkscore=0 suspectscore=38
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for lpm_trie maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/lpm_trie.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index a7d1e5cb80da..65757321ddf8 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -541,8 +541,6 @@ static int trie_delete_elem(struct bpf_map *map, void=
 *_key)
 static struct bpf_map *trie_alloc(union bpf_attr *attr)
 {
 	struct lpm_trie *trie;
-	u64 cost =3D sizeof(*trie), cost_per_node;
-	int ret;
=20
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -568,20 +566,9 @@ static struct bpf_map *trie_alloc(union bpf_attr *at=
tr)
 			  offsetof(struct bpf_lpm_trie_key, data);
 	trie->max_prefixlen =3D trie->data_size * 8;
=20
-	cost_per_node =3D sizeof(struct lpm_trie_node) +
-			attr->value_size + trie->data_size;
-	cost +=3D (u64) attr->max_entries * cost_per_node;
-
-	ret =3D bpf_map_charge_init(&trie->map.memory, cost);
-	if (ret)
-		goto out_err;
-
 	spin_lock_init(&trie->lock);
=20
 	return &trie->map;
-out_err:
-	kfree(trie);
-	return ERR_PTR(ret);
 }
=20
 static void trie_free(struct bpf_map *map)
--=20
2.26.2

