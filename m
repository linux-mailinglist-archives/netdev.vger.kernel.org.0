Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29E244B6C2
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344445AbhKIW3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:29:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245550AbhKIW1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 17:27:48 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9M0ecD015194
        for <netdev@vger.kernel.org>; Tue, 9 Nov 2021 14:25:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=LozLCoIbVuwHkpTKVctjNR5MPn0RyCZVgLY+uqWjIRU=;
 b=fLvBRiK9kqo4RJQLKc60oLs/ZyuL0Zyd9rb6Mn3Pvw7Zxn3kbOo8Q2T6xMrfNkQc8Scw
 XM/kVoilVRe8Xh13MbcG4vxJoNooLV9TODn68eqzAkGRGmv5fJN9sKFAKE+C4g5Pwr82
 DFwyPoYONX/MPQi4TQtm4GcABM/15ighBnE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c7m9fxvtu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 14:25:02 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 9 Nov 2021 14:25:00 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8D8AE1ED8332F; Tue,  9 Nov 2021 14:24:53 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH bpf-next] bpf: fix btf_task_struct_ids w/o CONFIG_DEBUG_INFO_BTF
Date:   Tue, 9 Nov 2021 14:24:47 -0800
Message-ID: <20211109222447.3251621-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: BCkXR5JRTRBp_Aaeu4xripQaB9z-aZ1i
X-Proofpoint-ORIG-GUID: BCkXR5JRTRBp_Aaeu4xripQaB9z-aZ1i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxlogscore=896 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes KASAN oops like

BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf=
/task_iter.c:661
Read of size 4 at addr ffffffff90297404 by task swapper/0/1

CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
Hardware name: ... Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:25=
6
__kasan_report mm/kasan/report.c:442 [inline]
kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
do_one_initcall+0x103/0x650 init/main.c:1295
do_initcall_level init/main.c:1368 [inline]
do_initcalls init/main.c:1384 [inline]
do_basic_setup init/main.c:1403 [inline]
kernel_init_freeable+0x6b1/0x73a init/main.c:1606
kernel_init+0x1a/0x1d0 init/main.c:1497
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
</TASK>

Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cdb0fba656006..6db929a5826d4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6342,10 +6342,14 @@ const struct bpf_func_proto bpf_btf_find_by_name_=
kind_proto =3D {
 	.arg4_type	=3D ARG_ANYTHING,
 };
=20
+#ifdef CONFIG_DEBUG_INFO_BTF
 BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
 BTF_ID(struct, vm_area_struct)
+#else
+u32 btf_task_struct_ids[3];
+#endif
=20
 /* BTF ID set registration API for modules */
=20
--=20
2.30.2

