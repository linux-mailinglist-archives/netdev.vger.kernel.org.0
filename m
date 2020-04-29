Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC01BD19B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgD2BV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63190 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgD2BV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:26 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1KaSe029020
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mGn8sekczkEVfiuyqaeU/ZWxA6NJEncA2CF12OXn3/k=;
 b=S33r6ObPBMKLI3KQAw3YzStbM2xtQTO+q26BcqPJKikR7Kn4dlt6qDswdWNhLCHITEVp
 Edo4GAk3sxYvxzaD6WEf6jWjGLE9WrmMYlJJV7a2ZW5Yf7NGYHtB5rCy0Y49sKlmUPrz
 DuzRP7zPz3kP5fVnTgy7R30GiQd3hYy2Vlw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30mjqnfd7m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:25 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8A7882EC30E4; Tue, 28 Apr 2020 18:21:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Alston Tang <alston64@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 04/11] libbpf: fix memory leak and possible double-free in hashmap__clear
Date:   Tue, 28 Apr 2020 18:21:04 -0700
Message-ID: <20200429012111.277390-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 mlxlogscore=346 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=25 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memory leak in hashmap_clear() not freeing hashmap_entry structs for =
each
of the remaining entries. Also NULL-out bucket list to prevent possible
double-free between hashmap__clear() and hashmap__free().

Running test_progs-asan flavor clearly showed this problem.

Cc: Alston Tang <alston64@fb.com>
Reported-by: Alston Tang <alston64@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/hashmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 54c30c802070..cffb96202e0d 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -59,7 +59,14 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
=20
 void hashmap__clear(struct hashmap *map)
 {
+	struct hashmap_entry *cur, *tmp;
+	int bkt;
+
+	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
+		free(cur);
+	}
 	free(map->buckets);
+	map->buckets =3D NULL;
 	map->cap =3D map->cap_bits =3D map->sz =3D 0;
 }
=20
--=20
2.24.1

