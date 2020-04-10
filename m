Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919751A3D2D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 02:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgDJAEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 20:04:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbgDJAEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 20:04:37 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03A03Ofh009578
        for <netdev@vger.kernel.org>; Thu, 9 Apr 2020 17:04:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VsTwKJ14jmyg++RnaKeTORwNV+qZPB0bcEJYT0TSCUM=;
 b=NC5FW+e5D58xRqGqH8KIjO77ZYISvrWfQ0N0LTCii5DxWWCf0u4Oxdw7mjqW+2XPjeXG
 4zB1DzHd2R3FoeqU2x8iXXQ/m8F1Gu7flqoMjSujkG6zJOyoBUp6shSPdyRyVIA663yT
 V2E21rmzY77vWnrXNMI3rFjkNwC4St04GvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 309sad6b37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 17:04:36 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 17:04:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4427A2EC31C4; Thu,  9 Apr 2020 17:04:30 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable for initially r/o mapping
Date:   Thu, 9 Apr 2020 17:04:24 -0700
Message-ID: <20200410000425.2597887-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_09:2020-04-07,2020-04-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=655
 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=8 spamscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004090171
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

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da34202..f7f6db50a085 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -635,6 +635,10 @@ static int bpf_map_mmap(struct file *filp, struct vm=
_area_struct *vma)
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
--=20
2.24.1

