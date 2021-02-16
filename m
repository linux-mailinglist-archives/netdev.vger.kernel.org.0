Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6268931CDE8
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhBPQW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:22:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16779 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBPQWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:22:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602bf1340000>; Tue, 16 Feb 2021 08:22:12 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 16:22:11 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Feb 2021 16:22:09 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <xiyou.wangcong@gmail.com>,
        <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>
CC:     <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net: sched: fix police ext initialization
Date:   Tue, 16 Feb 2021 18:22:00 +0200
Message-ID: <20210216162200.1834139-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
References: <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613492532; bh=O4R2iwkBYENhxWHFO0GQzJomk+OPK+x88ARSmZpOwDs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=B/O8c1oTv3rMnCCf4OdFyZ+rj7Af96mIec1wgaRMrXX36BcWmOM3OCKF7SJatBM+X
         3uSPIIgZE0L9jX1WTPm9LeGUhrlRwHaMi7CNPVMPBnEIW2SUuogXtD0lb7tP8TtEiM
         WjCEr6z2hDmh7bF7IN/OE0Hk9Q/08Vvqr+HX7L1er7tmgOJafc5UtKCB9Yd6ETeaIK
         PuN5cv1fNCqobZvnYAlQn4STwI9iW6rJJYpGMhR8beFN8tLDf0GEzGVpINmJEdZXLi
         2Au7Mv/Ul48yLUgZSQt6nXwwTnBaRfErKqtPS2Zblm6aNpARunAFwTMaif4WUdsYu/
         HpOf5wGKNPE1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When police action is created by cls API tcf_exts_validate() first
conditional that calls tcf_action_init_1() directly, the action idr is not
updated according to latest changes in action API that require caller to
commit newly created action to idr with tcf_idr_insert_many(). This results
such action not being accessible through act API and causes crash reported
by syzbot:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrume=
nted.h:71 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instru=
mented.h:27 [inline]
BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:178 [in=
line]
BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act=
_api.c:598
Read of size 4 at addr 0000000000000010 by task kworker/u4:5/204

CPU: 0 PID: 204 Comm: kworker/u4:5 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:400 [inline]
 kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 204 Comm: kworker/u4:5 Tainted: G    B             5.11.0-rc7-s=
yzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 end_report+0x58/0x5e mm/kasan/report.c:100
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x67/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled

Fix the issue by calling tcf_idr_insert_many() after successful action
initialization.

Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/act_api.h | 1 +
 net/sched/act_api.c   | 2 +-
 net/sched/cls_api.c   | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 55dab604861f..57be7c5d273b 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -166,6 +166,7 @@ int tcf_idr_create_from_flags(struct tc_action_net *tn,=
 u32 index,
 			      struct nlattr *est, struct tc_action **a,
 			      const struct tc_action_ops *ops, int bind,
 			      u32 flags);
+void tcf_idr_insert_many(struct tc_action *actions[]);
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2e85b636b27b..ebc8f1413078 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -908,7 +908,7 @@ static const struct nla_policy tcf_action_policy[TCA_AC=
T_MAX + 1] =3D {
 	[TCA_ACT_HW_STATS]	=3D NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
=20
-static void tcf_idr_insert_many(struct tc_action *actions[])
+void tcf_idr_insert_many(struct tc_action *actions[])
 {
 	int i;
=20
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 37b77bd30974..0b3900dd2354 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3053,6 +3053,7 @@ int tcf_exts_validate(struct net *net, struct tcf_pro=
to *tp, struct nlattr **tb,
 			act->type =3D exts->type =3D TCA_OLD_COMPAT;
 			exts->actions[0] =3D act;
 			exts->nr_actions =3D 1;
+			tcf_idr_insert_many(exts->actions);
 		} else if (exts->action && tb[exts->action]) {
 			int err;
=20
--=20
2.29.2

