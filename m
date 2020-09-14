Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939C0269529
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgINSqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:46:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgINSqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:46:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EIkWfL030148
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:46:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=NyGYnCKnagehNgkOY9puCcuW66UHbPqyZ3QfebY8Weo=;
 b=SrDM1vIbQ1vClF/28MddgHheZYcsSEWvrPm93/b+GslYt8j5rAXL7jUgYfeDTNH0Ghjp
 ccxlP6a36TQwsdU//8JPdMVlmRbQI+3/KLI/EHcZSLUeMcepwu3l8k8gNxrx/aMEFERU
 kjEsGkgkj1IlXCMkMkZkN7js5i/twrIwXEY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33hed3xjt5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:46:38 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 11:46:31 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B58D23705727; Mon, 14 Sep 2020 11:46:30 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map iterator
Date:   Mon, 14 Sep 2020 11:46:30 -0700
Message-ID: <20200914184630.1048718-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=790
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we use bucket_lock when traversing bpf_sk_storage_map
elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
and bpf_sk_storage_delete() helpers which may also grab bucket lock,
we do not have a deadlock issue which exists for hashmap when
using bucket_lock ([1]).

If a bucket contains a lot of sockets, during bpf_iter traversing
a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
some undesirable delays. Using rcu_read_lock() is a reasonable
compromise here. Although it may lose some precision, e.g.,
access stale sockets, but it will not hurt performance of other
bpf programs.

[1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com

Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/core/bpf_sk_storage.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4a86ea34f29e..a1db5e988d19 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -701,7 +701,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_=
sk_storage_map_info *info,
 		if (!selem) {
 			/* not found, unlock and go to the next bucket */
 			b =3D &smap->buckets[bucket_id++];
-			raw_spin_unlock_bh(&b->lock);
+			rcu_read_unlock();
 			skip_elems =3D 0;
 			break;
 		}
@@ -715,7 +715,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_=
sk_storage_map_info *info,
=20
 	for (i =3D bucket_id; i < (1U << smap->bucket_log); i++) {
 		b =3D &smap->buckets[i];
-		raw_spin_lock_bh(&b->lock);
+		rcu_read_lock();
 		count =3D 0;
 		hlist_for_each_entry(selem, &b->list, map_node) {
 			sk_storage =3D rcu_dereference_raw(selem->local_storage);
@@ -726,7 +726,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_=
sk_storage_map_info *info,
 			}
 			count++;
 		}
-		raw_spin_unlock_bh(&b->lock);
+		rcu_read_unlock();
 		skip_elems =3D 0;
 	}
=20
@@ -806,13 +806,10 @@ static void bpf_sk_storage_map_seq_stop(struct seq_=
file *seq, void *v)
 	struct bpf_local_storage_map *smap;
 	struct bpf_local_storage_map_bucket *b;
=20
-	if (!v) {
+	if (!v)
 		(void)__bpf_sk_storage_map_seq_show(seq, v);
-	} else {
-		smap =3D (struct bpf_local_storage_map *)info->map;
-		b =3D &smap->buckets[info->bucket_id];
-		raw_spin_unlock_bh(&b->lock);
-	}
+	else
+		rcu_read_unlock();
 }
=20
 static int bpf_iter_init_sk_storage_map(void *priv_data,
--=20
2.24.1

