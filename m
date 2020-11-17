Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDD2B5739
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgKQC4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:56:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbgKQC4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:56:05 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2u0bg014258
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:56:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wD+NVx56YELtcSrWQbdTPkvWMrsvSTQmAm2aG4+C/0c=;
 b=KszfGfbYxSQalw5ZjO/oEx2RMrfP+d1jG53mArR0h7Av3px037krQjl4bKPmXQKwtQ9F
 Ze5R+AEkkpGY0f5FlKeCQaoEKcq5JynCaQq8kmlRuQIhSUNIPmqSKxNAmaL7LSqcuDg1
 QYUj6kXxyroSpr4VtOUb3poKYZNo7gKdjOs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34u0698hgu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:56:04 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:37 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id E5AC7C5F7D8; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 13/34] bpf: memcg-based memory accounting for lpm_trie maps
Date:   Mon, 16 Nov 2020 18:55:08 -0800
Message-ID: <20201117025529.1034387-14-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=13 priorityscore=1501
 spamscore=0 mlxlogscore=733 adultscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include lpm trie and lpm trie node objects into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/lpm_trie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 00e32f2ec3e6..c9ebfb009955 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -282,7 +282,7 @@ static struct lpm_trie_node *lpm_trie_node_alloc(cons=
t struct lpm_trie *trie,
 	if (value)
 		size +=3D trie->map.value_size;
=20
-	node =3D kmalloc_node(size, GFP_ATOMIC | __GFP_NOWARN,
+	node =3D kmalloc_node(size, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
 			    trie->map.numa_node);
 	if (!node)
 		return NULL;
@@ -557,7 +557,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *att=
r)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
=20
-	trie =3D kzalloc(sizeof(*trie), GFP_USER | __GFP_NOWARN);
+	trie =3D kzalloc(sizeof(*trie), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT=
);
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

