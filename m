Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE4F2B5815
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgKQDl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:41:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11790 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727194AbgKQDlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:24 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3f122007663
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UcQLkGzmCCzxtZnn+cvMyPMDVngBz1PvcNY/9AFbCeE=;
 b=DC0xxdmmh+yyA2hSFvvy5ZmhILwmdJeM7IdmzLZvSiaLMK8vUb2KcvRrO+P8T/PQOjVq
 mmKPFoa6BLKcPwbsaG+TXDzVJec600WNj98ClvtuTgBunD20qXzUg8aZdpCos/GdJDD/
 bnxpoT8I12ZzE0IGzz/tfHnirHhtQSepvmw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34tykx8txv-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:24 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:18 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 7ED4DC63A87; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 24/34] bpf: eliminate rlimit-based memory accounting for lpm_trie maps
Date:   Mon, 16 Nov 2020 19:40:58 -0800
Message-ID: <20201117034108.1186569-25-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=38 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=709 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
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
index c9ebfb009955..4eaa48096bef 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -540,8 +540,6 @@ static int trie_delete_elem(struct bpf_map *map, void=
 *_key)
 static struct bpf_map *trie_alloc(union bpf_attr *attr)
 {
 	struct lpm_trie *trie;
-	u64 cost =3D sizeof(*trie), cost_per_node;
-	int ret;
=20
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -567,20 +565,9 @@ static struct bpf_map *trie_alloc(union bpf_attr *at=
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

