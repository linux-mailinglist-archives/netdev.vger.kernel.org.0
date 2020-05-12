Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A1A1D035A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgELX7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 19:59:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25722 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731875AbgELX7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 19:59:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CNxALF013779
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 16:59:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VbWh0pxVL2xOKiED9drEE4WqC17f9kUncqvLzJjSJZw=;
 b=oHb0ucbi8Jsx8YiFvXOkhNz6KhhJdHwTp+1CNR6IaFw9DHGt+3lnUROaSX71pGZ7N3Fg
 L6poE44X3nVwblsFqtupED+hPvxUzXmS+h3CdHdI15nOVarrp1JA6g0EBF5ANvyJf0N+
 k+fk6++DfAMUVD0wFHiTD3azbEl8bnxyw58= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x6snwv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 16:59:29 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 16:59:28 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A03B72EC3233; Tue, 12 May 2020 16:59:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix bug in mmap() implementation for BPF array map
Date:   Tue, 12 May 2020 16:59:25 -0700
Message-ID: <20200512235925.3817805-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_08:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=870 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=8 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mmap() subsystem allows user-space application to memory-map region with
initial page offset. This wasn't taken into account in initial implementa=
tion
of BPF array memory-mapping. This would result in wrong pages, not taking=
 into
account requested page shift, being memory-mmaped into user-space. This p=
atch
fixes this gap and adds a test for such scenario.

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/arraymap.c                         | 7 ++++++-
 tools/testing/selftests/bpf/prog_tests/mmap.c | 8 ++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..1d6120fd5ba6 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -486,7 +486,12 @@ static int array_map_mmap(struct bpf_map *map, struc=
t vm_area_struct *vma)
 	if (!(map->map_flags & BPF_F_MMAPABLE))
 		return -EINVAL;
=20
-	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array), pgoff);
+	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) >
+	    PAGE_ALIGN((u64)array->map.max_entries * array->elem_size))
+		return -EINVAL;
+
+	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array),
+				   vma->vm_pgoff + pgoff);
 }
=20
 const struct bpf_map_ops array_map_ops =3D {
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testin=
g/selftests/bpf/prog_tests/mmap.c
index 56d80adcf4bd..6b9dce431d41 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -217,6 +217,14 @@ void test_mmap(void)
=20
 	munmap(tmp2, 4 * page_size);
=20
+	/* map all 4 pages, but with pg_off=3D1 page, should fail */
+	tmp1 =3D mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
+		    data_map_fd, page_size /* initial page shift */);
+	if (CHECK(tmp1 !=3D MAP_FAILED, "adv_mmap7", "unexpected success")) {
+		munmap(tmp1, 4 * page_size);
+		goto cleanup;
+	}
+
 	tmp1 =3D mmap(NULL, map_sz, PROT_READ, MAP_SHARED, data_map_fd, 0);
 	if (CHECK(tmp1 =3D=3D MAP_FAILED, "last_mmap", "failed %d\n", errno))
 		goto cleanup;
--=20
2.24.1

