Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13122B99C0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgKSRk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:40:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729431AbgKSRiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:11 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHUdE7012525
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RH10uTc2SABI5+AuWBz8rVMMslGuSfje99oYC4biZTk=;
 b=IIraCG87v+1feIgNrftxlSPlQyccTsTw3yIFe8BumAGekwRDn8EF1dhGRai1cwdj5kQG
 z9l1OOCS5laMYQD/mMx7bewjh7GvAKgpFCwxN2w9OWs3X9zBKJpNpB+iAvU15q/Ymmr2
 9c86N7zDw6iWOrJDrL/Lvq1BniL2i1fjQ/c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34w2mkbdda-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:10 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:04 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id B1FFF145BCF1; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 13/34] bpf: memcg-based memory accounting for lpm_trie maps
Date:   Thu, 19 Nov 2020 09:37:33 -0800
Message-ID: <20201119173754.4125257-14-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=759
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include lpm trie and lpm trie node objects into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/lpm_trie.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 00e32f2ec3e6..a7d1e5cb80da 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -282,8 +282,9 @@ static struct lpm_trie_node *lpm_trie_node_alloc(cons=
t struct lpm_trie *trie,
 	if (value)
 		size +=3D trie->map.value_size;
=20
-	node =3D kmalloc_node(size, GFP_ATOMIC | __GFP_NOWARN,
-			    trie->map.numa_node);
+	node =3D bpf_map_kmalloc_node(&trie->map, size,
+				    GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
+				    trie->map.numa_node);
 	if (!node)
 		return NULL;
=20
@@ -557,7 +558,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *att=
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

