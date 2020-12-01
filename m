Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A32CAF4E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbgLAWAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59610 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390451AbgLAV76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:58 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Lnubk020563
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UKxkxvAAuhNaKc9s1NfBxBtqwOSjGHpQevUyr/TJeOA=;
 b=DIpvRqTq/FRoi920kkeCA9/iZjvwqUd5Gss9j4Ic4SUj3S1QM/3yugWdm5EgfT4qaRrf
 4a4VcNNrovXmRcEPJzcweQwTuhkcgrf4/i4m8STE/jKiuUxDBdBUkRjRD8ig3/o5IOw6
 aYFKCpwRJjePtv7tZYXIo5TVCONlTvy/agA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7y1xay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:16 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:15 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 7B04A19702B8; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 13/34] bpf: memcg-based memory accounting for lpm_trie maps
Date:   Tue, 1 Dec 2020 13:58:39 -0800
Message-ID: <20201201215900.3569844-14-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=746 phishscore=0
 mlxscore=0 suspectscore=13 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include lpm trie and lpm trie node objects into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/lpm_trie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 00e32f2ec3e6..1a6981203d7f 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -282,8 +282,8 @@ static struct lpm_trie_node *lpm_trie_node_alloc(cons=
t struct lpm_trie *trie,
 	if (value)
 		size +=3D trie->map.value_size;
=20
-	node =3D kmalloc_node(size, GFP_ATOMIC | __GFP_NOWARN,
-			    trie->map.numa_node);
+	node =3D bpf_map_kmalloc_node(&trie->map, size, GFP_ATOMIC | __GFP_NOWA=
RN,
+				    trie->map.numa_node);
 	if (!node)
 		return NULL;
=20
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

