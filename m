Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A0F1A4B20
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgDJU0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:26:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgDJU0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 16:26:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03AK69ow014206
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:26:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qciUO1R4PjdWuZFn1+K4sgxfTX2Il0f1WfoaqJS/qSg=;
 b=qrJ2lQPaePwFGsU4oXjwX/huMmHCs9ARn5/Knd+15QbbPER6eMhI1Rk+WFr+0Mt8PWP9
 99JOz3byiSce6Wo9WJc/aaeCVWmrNdPkxiNEe5aywMjmqKM9qacQHr3H9BLBrVdGeJhE
 wZtCZEAZK/Mp5ZBLigHrq2akuteIcjxiCfU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30a4b806kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:26:19 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 13:26:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D9BE12EC2343; Fri, 10 Apr 2020 13:26:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable for initially r/o mapping
Date:   Fri, 10 Apr 2020 13:26:12 -0700
Message-ID: <20200410202613.3679837-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_08:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=8 bulkscore=0 phishscore=0 mlxscore=0
 mlxlogscore=845 priorityscore=1501 adultscore=0 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004100147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VM_MAYWRITE flag during initial memory mapping determines if already mmap=
()'ed
pages can be later remapped as writable ones through mprotect() call. To
prevent user application to rewrite contents of memory-mapped as read-onl=
y and
subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initia=
lly
read-only mapping.

Alternatively, we could treat any memory-mapping on unfrozen map as writa=
ble
and bump writecnt instead. But there is little legitimate reason to map
BPF map as read-only and then re-mmap() it as writable through mprotect()=
,
instead of just mmap()'ing it as read/write from the very beginning.

Also, at the suggestion of Jann Horn, drop unnecessary refcounting in mma=
p
operations. We can just rely on VMA holding reference to BPF map's file
properly.

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da34202..d85f37239540 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -586,9 +586,7 @@ static void bpf_map_mmap_open(struct vm_area_struct *=
vma)
 {
 	struct bpf_map *map =3D vma->vm_file->private_data;
=20
-	bpf_map_inc_with_uref(map);
-
-	if (vma->vm_flags & VM_WRITE) {
+	if (vma->vm_flags & VM_MAYWRITE) {
 		mutex_lock(&map->freeze_mutex);
 		map->writecnt++;
 		mutex_unlock(&map->freeze_mutex);
@@ -600,13 +598,11 @@ static void bpf_map_mmap_close(struct vm_area_struc=
t *vma)
 {
 	struct bpf_map *map =3D vma->vm_file->private_data;
=20
-	if (vma->vm_flags & VM_WRITE) {
+	if (vma->vm_flags & VM_MAYWRITE) {
 		mutex_lock(&map->freeze_mutex);
 		map->writecnt--;
 		mutex_unlock(&map->freeze_mutex);
 	}
-
-	bpf_map_put_with_uref(map);
 }
=20
 static const struct vm_operations_struct bpf_map_default_vmops =3D {
@@ -635,14 +631,16 @@ static int bpf_map_mmap(struct file *filp, struct v=
m_area_struct *vma)
 	/* set default open/close callbacks */
 	vma->vm_ops =3D &bpf_map_default_vmops;
 	vma->vm_private_data =3D map;
+	vma->vm_flags &=3D ~VM_MAYEXEC;
+	if (!(vma->vm_flags & VM_WRITE))
+		/* disallow re-mapping with PROT_WRITE */
+		vma->vm_flags &=3D ~VM_MAYWRITE;
=20
 	err =3D map->ops->map_mmap(map, vma);
 	if (err)
 		goto out;
=20
-	bpf_map_inc_with_uref(map);
-
-	if (vma->vm_flags & VM_WRITE)
+	if (vma->vm_flags & VM_MAYWRITE)
 		map->writecnt++;
 out:
 	mutex_unlock(&map->freeze_mutex);
--=20
2.24.1

