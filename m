Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CDC29E3B9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgJ2HUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:20:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28640 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbgJ2HUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:20:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T7KMbY020082
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8pfyRTLKgZJd5rwVpAZMn7BR3DOJlxIAHrZREzxHPug=;
 b=QAO5lKrA/ylXKc4Mu+i5FDGUt1eJ5XQUYSFILveQY/miGIsuy7VMykia64bq8/2n757x
 8fTVyB5p0V7dJovSZhV/QBBCz+EYk8z6dL/+JCfNHmqC6c0IUQ2JdHxR7wk8FP9rNYsW
 K3uiczq6OvTaLN5hlNnrKiWopMOcKHHnBH8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34ej3nm8ug-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:31 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 00:20:30 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 10D4062E580C; Thu, 29 Oct 2020 00:20:27 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 1/2] bpf: use separate lockdep class for each hashtab
Date:   Thu, 29 Oct 2020 00:19:24 -0700
Message-ID: <20201029071925.3103400-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201029071925.3103400-1-songliubraving@fb.com>
References: <20201029071925.3103400-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_03:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0 suspectscore=2
 phishscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a hashtab is accessed in both NMI and non-NMI contexts, it may cause
deadlock in bucket->lock. LOCKDEP NMI warning highlighted this issue:

./test_progs -t stacktrace

[   74.828970]
[   74.828971] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   74.828972] WARNING: inconsistent lock state
[   74.828973] 5.9.0-rc8+ #275 Not tainted
[   74.828974] --------------------------------
[   74.828975] inconsistent {INITIAL USE} -> {IN-NMI} usage.
[   74.828976] taskset/1174 [HC2[2]:SC0[0]:HE0:SE1] takes:
[   74.828977] ffffc90000ee96b0 (&htab->buckets[i].raw_lock){....}-{2:2},=
 at: htab_map_update_elem+0x271/0x5a0
[   74.828981] {INITIAL USE} state was registered at:
[   74.828982]   lock_acquire+0x137/0x510
[   74.828983]   _raw_spin_lock_irqsave+0x43/0x90
[   74.828984]   htab_map_update_elem+0x271/0x5a0
[   74.828984]   0xffffffffa0040b34
[   74.828985]   trace_call_bpf+0x159/0x310
[   74.828986]   perf_trace_run_bpf_submit+0x5f/0xd0
[   74.828987]   perf_trace_urandom_read+0x1be/0x220
[   74.828988]   urandom_read_nowarn.isra.0+0x26f/0x380
[   74.828989]   vfs_read+0xf8/0x280
[   74.828989]   ksys_read+0xc9/0x160
[   74.828990]   do_syscall_64+0x33/0x40
[   74.828991]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   74.828992] irq event stamp: 1766
[   74.828993] hardirqs last  enabled at (1765): [<ffffffff82800ace>] asm=
_exc_page_fault+0x1e/0x30
[   74.828994] hardirqs last disabled at (1766): [<ffffffff8267df87>] irq=
entry_enter+0x37/0x60
[   74.828995] softirqs last  enabled at (856): [<ffffffff81043e7c>] fpu_=
_clear+0xac/0x120
[   74.828996] softirqs last disabled at (854): [<ffffffff81043df0>] fpu_=
_clear+0x20/0x120
[   74.828997]
[   74.828998] other info that might help us debug this:
[   74.828999]  Possible unsafe locking scenario:
[   74.828999]
[   74.829000]        CPU0
[   74.829001]        ----
[   74.829001]   lock(&htab->buckets[i].raw_lock);
[   74.829003]   <Interrupt>
[   74.829004]     lock(&htab->buckets[i].raw_lock);
[   74.829006]
[   74.829006]  *** DEADLOCK ***
[   74.829007]
[   74.829008] 1 lock held by taskset/1174:
[   74.829008]  #0: ffff8883ec3fd020 (&cpuctx_lock){-...}-{2:2}, at: perf=
_event_task_tick+0x101/0x650
[   74.829012]
[   74.829013] stack backtrace:
[   74.829014] CPU: 0 PID: 1174 Comm: taskset Not tainted 5.9.0-rc8+ #275
[   74.829015] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.11.0-2.el7 04/01/2014
[   74.829016] Call Trace:
[   74.829016]  <NMI>
[   74.829017]  dump_stack+0x9a/0xd0
[   74.829018]  lock_acquire+0x461/0x510
[   74.829019]  ? lock_release+0x6b0/0x6b0
[   74.829020]  ? stack_map_get_build_id_offset+0x45e/0x800
[   74.829021]  ? htab_map_update_elem+0x271/0x5a0
[   74.829022]  ? rcu_read_lock_held_common+0x1a/0x50
[   74.829022]  ? rcu_read_lock_held+0x5f/0xb0
[   74.829023]  _raw_spin_lock_irqsave+0x43/0x90
[   74.829024]  ? htab_map_update_elem+0x271/0x5a0
[   74.829025]  htab_map_update_elem+0x271/0x5a0
[   74.829026]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x9c/0xe88
[   74.829027]  bpf_overflow_handler+0x127/0x320
[   74.829028]  ? perf_event_text_poke_output+0x4d0/0x4d0
[   74.829029]  ? sched_clock_cpu+0x18/0x130
[   74.829030]  __perf_event_overflow+0xae/0x190
[   74.829030]  handle_pmi_common+0x34c/0x470
[   74.829031]  ? intel_pmu_save_and_restart+0x90/0x90
[   74.829032]  ? lock_acquire+0x3f8/0x510
[   74.829033]  ? lock_release+0x6b0/0x6b0
[   74.829034]  intel_pmu_handle_irq+0x11e/0x240
[   74.829034]  perf_event_nmi_handler+0x40/0x60
[   74.829035]  nmi_handle+0x110/0x360
[   74.829036]  ? __intel_pmu_enable_all.constprop.0+0x72/0xf0
[   74.829037]  default_do_nmi+0x6b/0x170
[   74.829038]  exc_nmi+0x106/0x130
[   74.829038]  end_repeat_nmi+0x16/0x55
[   74.829039] RIP: 0010:__intel_pmu_enable_all.constprop.0+0x72/0xf0
[   74.829042] Code: 2f 1f 03 48 8d bb b8 0c 00 00 e8 29 09 41 00 48 ...
[   74.829043] RSP: 0000:ffff8880a604fc90 EFLAGS: 00000002
[   74.829044] RAX: 000000070000000f RBX: ffff8883ec2195a0 RCX: 000000000=
000038f
[   74.829045] RDX: 0000000000000007 RSI: ffffffff82e72c20 RDI: ffff8883e=
c21a258
[   74.829046] RBP: 000000070000000f R08: ffffffff8101b013 R09: fffffbfff=
0a7982d
[   74.829047] R10: ffffffff853cc167 R11: fffffbfff0a7982c R12: 000000000=
0000000
[   74.829049] R13: ffff8883ec3f0af0 R14: ffff8883ec3fd120 R15: ffff8883e=
9c92098
[   74.829049]  ? intel_pmu_lbr_enable_all+0x43/0x240
[   74.829050]  ? __intel_pmu_enable_all.constprop.0+0x72/0xf0
[   74.829051]  ? __intel_pmu_enable_all.constprop.0+0x72/0xf0
[   74.829052]  </NMI>
[   74.829053]  perf_event_task_tick+0x48d/0x650
[   74.829054]  scheduler_tick+0x129/0x210
[   74.829054]  update_process_times+0x37/0x70
[   74.829055]  tick_sched_handle.isra.0+0x35/0x90
[   74.829056]  tick_sched_timer+0x8f/0xb0
[   74.829057]  __hrtimer_run_queues+0x364/0x7d0
[   74.829058]  ? tick_sched_do_timer+0xa0/0xa0
[   74.829058]  ? enqueue_hrtimer+0x1e0/0x1e0
[   74.829059]  ? recalibrate_cpu_khz+0x10/0x10
[   74.829060]  ? ktime_get_update_offsets_now+0x1a3/0x360
[   74.829061]  hrtimer_interrupt+0x1bb/0x360
[   74.829062]  ? rcu_read_lock_sched_held+0xa1/0xd0
[   74.829063]  __sysvec_apic_timer_interrupt+0xed/0x3d0
[   74.829064]  sysvec_apic_timer_interrupt+0x3f/0xd0
[   74.829064]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[   74.829065]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   74.829066] RIP: 0033:0x7fba18d579b4
[   74.829068] Code: 74 54 44 0f b6 4a 04 41 83 e1 0f 41 80 f9 ...
[   74.829069] RSP: 002b:00007ffc9ba69570 EFLAGS: 00000206
[   74.829071] RAX: 00007fba192084c0 RBX: 00007fba18c24d28 RCX: 000000000=
00007a4
[   74.829072] RDX: 00007fba18c30488 RSI: 0000000000000000 RDI: 000000000=
000037b
[   74.829073] RBP: 00007fba18ca5760 R08: 00007fba18c248fc R09: 00007fba1=
8c94c30
[   74.829074] R10: 000000000000002f R11: 0000000000073c30 R12: 00007ffc9=
ba695e0
[   74.829075] R13: 00000000000003f3 R14: 00007fba18c21ac8 R15: 000000000=
00058d6

However, such warning should not apply across multiple hashtabs. The
system will not deadlock if one hashtab is used in NMI, while another
hashtab is used in non-NMI.

Use separate lockdep class for each hashtab, so that we don't get this
false alert.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/hashtab.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1815e97d4c9c1..278da031c91ab 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -99,6 +99,7 @@ struct bpf_htab {
 	u32 n_buckets;	/* number of hash buckets */
 	u32 elem_size;	/* size of each element in bytes */
 	u32 hashrnd;
+	struct lock_class_key lockdep_key;
 };
=20
 /* each htab element is struct htab_elem + key + value */
@@ -136,12 +137,18 @@ static void htab_init_buckets(struct bpf_htab *htab=
)
 {
 	unsigned i;
=20
+	lockdep_register_key(&htab->lockdep_key);
 	for (i =3D 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
-		if (htab_use_raw_lock(htab))
+		if (htab_use_raw_lock(htab)) {
 			raw_spin_lock_init(&htab->buckets[i].raw_lock);
-		else
+			lockdep_set_class(&htab->buckets[i].raw_lock,
+					  &htab->lockdep_key);
+		} else {
 			spin_lock_init(&htab->buckets[i].lock);
+			lockdep_set_class(&htab->buckets[i].lock,
+					  &htab->lockdep_key);
+		}
 	}
 }
=20
@@ -1312,6 +1319,7 @@ static void htab_map_free(struct bpf_map *map)
=20
 	free_percpu(htab->extra_elems);
 	bpf_map_area_free(htab->buckets);
+	lockdep_unregister_key(&htab->lockdep_key);
 	kfree(htab);
 }
=20
--=20
2.24.1

