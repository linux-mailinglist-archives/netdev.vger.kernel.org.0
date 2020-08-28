Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0545D25527F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgH1BSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:18:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48650 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgH1BSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:18:44 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S1IghK027840
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UJpPJAog+shu/6F08xa7Qw9Bo/b3nfzFp0Bk7N0CpR8=;
 b=X04mOYMNCDRqh5znvI9DcWUQOh+v4hnUgaL39+UiJp8D/f1Y/l4Z0Ex9SviWiMlVYH04
 pmXicqjFaSUIDb380fTGk+IoaJfQIK2NdMxyKJcUnZ45MDXko6e6j87jQnyNtOp34QNk
 Fl6l+Xm8tAIL1N3Dol2axE1DP+zD7TDO0Rk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up88j5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:42 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 18:18:15 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 28E4B2946559; Thu, 27 Aug 2020 18:18:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 2/3] bpf: Relax max_entries check for most of the inner map types
Date:   Thu, 27 Aug 2020 18:18:13 -0700
Message-ID: <20200828011813.1970516-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200828011800.1970018-1-kafai@fb.com>
References: <20200828011800.1970018-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_14:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=38 adultscore=0 mlxlogscore=921 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the maps do not use max_entries during verification time.
Thus, those map_meta_equal() do not need to enforce max_entries
when it is inserted as an inner map during runtime.  The max_entries
check is removed from the default implementation bpf_map_meta_equal().

The prog_array_map and xsk_map are exception.  Its map_gen_lookup
uses max_entries to generate inline lookup code.  Thus, they will
implement its own map_meta_equal() to enforce max_entries.
Since there are only two cases now, the max_entries check
is not refactored and stays in its own .c file.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/arraymap.c   | 9 ++++++++-
 kernel/bpf/map_in_map.c | 3 +--
 net/xdp/xskmap.c        | 9 ++++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 40d1f7f94307..d851ebbcf302 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -487,6 +487,13 @@ static int array_map_mmap(struct bpf_map *map, struc=
t vm_area_struct *vma)
 				   vma->vm_pgoff + pgoff);
 }
=20
+static bool array_map_meta_equal(const struct bpf_map *meta0,
+				 const struct bpf_map *meta1)
+{
+	return meta0->max_entries =3D=3D meta1->max_entries &&
+		bpf_map_meta_equal(meta0, meta1);
+}
+
 struct bpf_iter_seq_array_map_info {
 	struct bpf_map *map;
 	void *percpu_value_buf;
@@ -625,7 +632,7 @@ static const struct bpf_iter_seq_info iter_seq_info =3D=
 {
=20
 static int array_map_btf_id;
 const struct bpf_map_ops array_map_ops =3D {
-	.map_meta_equal =3D bpf_map_meta_equal,
+	.map_meta_equal =3D array_map_meta_equal,
 	.map_alloc_check =3D array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
 	.map_free =3D array_map_free,
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index e97a22dd3232..39ab0b68cade 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -75,8 +75,7 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 	return meta0->map_type =3D=3D meta1->map_type &&
 		meta0->key_size =3D=3D meta1->key_size &&
 		meta0->value_size =3D=3D meta1->value_size &&
-		meta0->map_flags =3D=3D meta1->map_flags &&
-		meta0->max_entries =3D=3D meta1->max_entries;
+		meta0->map_flags =3D=3D meta1->map_flags;
 }
=20
 void *bpf_map_fd_get_ptr(struct bpf_map *map,
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index f45f29f04151..2a4fd6677155 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -254,9 +254,16 @@ void xsk_map_try_sock_delete(struct xsk_map *map, st=
ruct xdp_sock *xs,
 	spin_unlock_bh(&map->lock);
 }
=20
+static bool xsk_map_meta_equal(const struct bpf_map *meta0,
+			       const struct bpf_map *meta1)
+{
+	return meta0->max_entries =3D=3D meta1->max_entries &&
+		bpf_map_meta_equal(meta0, meta1);
+}
+
 static int xsk_map_btf_id;
 const struct bpf_map_ops xsk_map_ops =3D {
-	.map_meta_equal =3D bpf_map_meta_equal,
+	.map_meta_equal =3D xsk_map_meta_equal,
 	.map_alloc =3D xsk_map_alloc,
 	.map_free =3D xsk_map_free,
 	.map_get_next_key =3D xsk_map_get_next_key,
--=20
2.24.1

