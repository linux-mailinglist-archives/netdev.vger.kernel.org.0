Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEF2CAF92
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391896AbgLAWB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:01:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1620 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389824AbgLAV7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:55 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Lmm1K007480
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VG7+IcjHBmOmdSdI4afBmj5EWUBcGxUmixNnIwTV1P4=;
 b=UL66ifZQgoC2lb0Oodt0w4ZQb4+vkROLD4XFmViP39UdRU5z51I3RqLI4brNJ73T+JUI
 cwhZBfkJeqAQrHcOAXLDjV9uxC4LgqDTIZfsy/FmDGsp0DEKwcwy/LPXmMrf5Ofw3Ce6
 vAAFqkFSwE6mtLxonzOw4jljk6vYXPDMNEw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3547psq7s8-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:15 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:09 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 5D47D19702AC; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 07/34] bpf: memcg-based memory accounting for bpf maps
Date:   Tue, 1 Dec 2020 13:58:33 -0800
Message-ID: <20201201215900.3569844-8-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=564 adultscore=0 suspectscore=13 lowpriorityscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables memcg-based memory accounting for memory allocated
by __bpf_map_area_alloc(), which is used by many types of bpf maps for
large initial memory allocations.

Please note, that __bpf_map_area_alloc() should not be used outside of
map creation paths without setting the active memory cgroup to the
map's memory cgroup.

Following patches in the series will refine the accounting for
some of the map types.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/syscall.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dedbf6d4cd84..dff3a5f62d7a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -268,6 +268,10 @@ static int bpf_map_copy_value(struct bpf_map *map, v=
oid *key, void *value,
 	return err;
 }
=20
+/* Please, do not use this function outside from the map creation path
+ * (e.g. in map update path) without taking care of setting the active
+ * memory cgroup (see at bpf_map_kmalloc_node() for example).
+ */
 static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable=
)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -280,7 +284,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_=
node, bool mmapable)
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
=20
-	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO;
+	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
 	unsigned int flags =3D 0;
 	unsigned long align =3D 1;
 	void *area;
--=20
2.26.2

