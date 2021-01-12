Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515E92F4082
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393449AbhAMAmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13374 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390545AbhALXqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:46:38 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CNeHNc023466
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 15:45:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=NL2PGNFXKFKSixamVmoVdBmisIyuQtxJt43Z8l9r8iA=;
 b=d1yj73GusbdukRvQ90g7MTUCegf6ugdaN9HNJb/btbFsIntQCd3IdWbdGmzIuZdOxzCc
 lguVQh7Qp6XcrH94nbvcTJnyaTVbIPG0UvBaK2okcchxF4oi0zFx6YV51lpT0VFh8fHg
 mSIYyHNw1UqE1CMmKRg7weL/pst8UXT6y34= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpja5yh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 15:45:56 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 15:45:55 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id ABA9262E0B5E; Tue, 12 Jan 2021 15:43:03 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test run
Date:   Tue, 12 Jan 2021 15:42:54 -0800
Message-ID: <20210112234254.1906829-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_21:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a WARNING for allocating too big memory:

WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+=
0x5f8/0x730 mm/page_alloc.c:5011
Modules linked in:
CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #=
0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 7=
0 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 =
fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
alloc_pages include/linux/gfp.h:547 [inline]
kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
kmalloc include/linux/slab.h:557 [inline]
kzalloc include/linux/slab.h:682 [inline]
bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
__do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440499
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000

This is because we didn't filter out too big ctx_size_in. Fix it by
rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
numbers.

Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 net/bpf/test_run.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 23dfb2010ba69..58bcb8c849d54 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -272,7 +272,8 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 	    kattr->test.repeat)
 		return -EINVAL;
=20
-	if (ctx_size_in < prog->aux->max_ctx_offset)
+	if (ctx_size_in < prog->aux->max_ctx_offset ||
+	    ctx_size_in > MAX_BPF_FUNC_ARGS * sizeof(u64))
 		return -EINVAL;
=20
 	if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) =3D=3D 0 && cpu !=3D 0)
--=20
2.24.1

