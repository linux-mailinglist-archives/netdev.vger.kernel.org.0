Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B5D283CF1
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgJEQ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:58:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbgJEQ6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:58:47 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095GrcN0008109
        for <netdev@vger.kernel.org>; Mon, 5 Oct 2020 09:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=crS2MNwP7DjxYVyJCkL8M5svDqLbBGLiWgq4QuNOrDQ=;
 b=S8Cnjm8GDF+/JQgVAxhbp6KlwTFAKx911rZTRQISvGkrsa3TAeiMVSIpUIDWR8uJhGcd
 30zIInQP80p+PSJrRbHq999ytaAnXpKUAtXIqRt63K3FX2jM+B1pRa4UYh7ElVZ70jlD
 SGBr0qSgY4X2r4xPNJjR8rwot5pjkVdNqaw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33y9jnnh47-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 09:58:47 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 09:58:46 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id EE1F462E514C; Mon,  5 Oct 2020 09:58:44 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next] bpf: use raw_spin_trylock() for pcpu_freelist_push/pop in NMI
Date:   Mon, 5 Oct 2020 09:58:38 -0700
Message-ID: <20201005165838.3735218-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_12:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010050125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
pcpu_freelist in NMI:

./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi

[   18.984807] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   18.984807] WARNING: inconsistent lock state
[   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
[   18.984809] --------------------------------
[   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
[   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
[   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
__pcpu_freelist_pop+0xe3/0x180
[   18.984813] {INITIAL USE} state was registered at:
[   18.984814]   lock_acquire+0x175/0x7c0
[   18.984814]   _raw_spin_lock+0x2c/0x40
[   18.984815]   __pcpu_freelist_pop+0xe3/0x180
[   18.984815]   pcpu_freelist_pop+0x31/0x40
[   18.984816]   htab_map_alloc+0xbbf/0xf40
[   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
[   18.984817]   do_syscall_64+0x2d/0x40
[   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   18.984818] irq event stamp: 12
[ ... ]
[   18.984822] other info that might help us debug this:
[   18.984823]  Possible unsafe locking scenario:
[   18.984823]
[   18.984824]        CPU0
[   18.984824]        ----
[   18.984824]   lock(&head->lock);
[   18.984826]   <Interrupt>
[   18.984826]     lock(&head->lock);
[   18.984827]
[   18.984828]  *** DEADLOCK ***
[   18.984828]
[   18.984829] 2 locks held by test_progs/1990:
[ ... ]
[   18.984838]  <NMI>
[   18.984838]  dump_stack+0x9a/0xd0
[   18.984839]  lock_acquire+0x5c9/0x7c0
[   18.984839]  ? lock_release+0x6f0/0x6f0
[   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
[   18.984840]  _raw_spin_lock+0x2c/0x40
[   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
[   18.984841]  __pcpu_freelist_pop+0xe3/0x180
[   18.984842]  pcpu_freelist_pop+0x17/0x40
[   18.984842]  ? lock_release+0x6f0/0x6f0
[   18.984843]  __bpf_get_stackid+0x534/0xaf0
[   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
[   18.984844]  bpf_overflow_handler+0x12f/0x3f0

This is because pcpu_freelist_head.lock is accessed in both NMI and
non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.

Since NMI interrupts non-NMI context, when NMI context tries to lock the
raw_spinlock, non-NMI context of the same cpu may already have locked a
lock and is blocked from unlocking the lock. For a system with N cpus,
there could be N NMIs at the same time, and they may block N non-NMI
raw_spinlocks. This is tricky for pcpu_freelist_push(), where unlike
_pop(), failing _push() means leaking memory. This issue is more likely t=
o
trigger in non-SMP system.

Fix this issue with an extra list, pcpu_freelist.extralist. The extralist
is primarily used to take _push() when raw_spin_trylock() failed on all
the per cpu lists. It should be empty most of the time. The following
table summarizes the behavior of pcpu_freelist in NMI and non-NMI:

non-NMI pop(): 	use _lock(); check per cpu lists first;
                if all per cpu lists are empty, check extralist;
                if extralist is empty, return NULL.

non-NMI push(): use _lock(); only push to per cpu lists.

NMI pop():    use _trylock(); check per cpu lists first;
              if all per cpu lists are locked or empty, check extralist;
              if extralist is locked or empty, return NULL.

NMI push():   use _trylock(); check per cpu lists first;
              if all per cpu lists are locked; try push to extralist;
              if extralist is also locked, keep trying on per cpu lists.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>

---
Changes v1 =3D> v2:
1. Update commit log. (Daniel)
---
 kernel/bpf/percpu_freelist.c | 101 +++++++++++++++++++++++++++++++++--
 kernel/bpf/percpu_freelist.h |   1 +
 2 files changed, 97 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index b367430e611c7..3d897de890612 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -17,6 +17,8 @@ int pcpu_freelist_init(struct pcpu_freelist *s)
 		raw_spin_lock_init(&head->lock);
 		head->first =3D NULL;
 	}
+	raw_spin_lock_init(&s->extralist.lock);
+	s->extralist.first =3D NULL;
 	return 0;
 }
=20
@@ -40,12 +42,50 @@ static inline void ___pcpu_freelist_push(struct pcpu_=
freelist_head *head,
 	raw_spin_unlock(&head->lock);
 }
=20
+static inline bool pcpu_freelist_try_push_extra(struct pcpu_freelist *s,
+						struct pcpu_freelist_node *node)
+{
+	if (!raw_spin_trylock(&s->extralist.lock))
+		return false;
+
+	pcpu_freelist_push_node(&s->extralist, node);
+	raw_spin_unlock(&s->extralist.lock);
+	return true;
+}
+
+static inline void ___pcpu_freelist_push_nmi(struct pcpu_freelist *s,
+					     struct pcpu_freelist_node *node)
+{
+	int cpu, orig_cpu;
+
+	orig_cpu =3D cpu =3D raw_smp_processor_id();
+	while (1) {
+		struct pcpu_freelist_head *head;
+
+		head =3D per_cpu_ptr(s->freelist, cpu);
+		if (raw_spin_trylock(&head->lock)) {
+			pcpu_freelist_push_node(head, node);
+			raw_spin_unlock(&head->lock);
+			return;
+		}
+		cpu =3D cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >=3D nr_cpu_ids)
+			cpu =3D 0;
+
+		/* cannot lock any per cpu lock, try extralist */
+		if (cpu =3D=3D orig_cpu &&
+		    pcpu_freelist_try_push_extra(s, node))
+			return;
+	}
+}
+
 void __pcpu_freelist_push(struct pcpu_freelist *s,
 			struct pcpu_freelist_node *node)
 {
-	struct pcpu_freelist_head *head =3D this_cpu_ptr(s->freelist);
-
-	___pcpu_freelist_push(head, node);
+	if (in_nmi())
+		___pcpu_freelist_push_nmi(s, node);
+	else
+		___pcpu_freelist_push(this_cpu_ptr(s->freelist), node);
 }
=20
 void pcpu_freelist_push(struct pcpu_freelist *s,
@@ -81,7 +121,7 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, v=
oid *buf, u32 elem_size,
 	}
 }
=20
-struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)
+static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freel=
ist *s)
 {
 	struct pcpu_freelist_head *head;
 	struct pcpu_freelist_node *node;
@@ -102,8 +142,59 @@ struct pcpu_freelist_node *__pcpu_freelist_pop(struc=
t pcpu_freelist *s)
 		if (cpu >=3D nr_cpu_ids)
 			cpu =3D 0;
 		if (cpu =3D=3D orig_cpu)
-			return NULL;
+			break;
+	}
+
+	/* per cpu lists are all empty, try extralist */
+	raw_spin_lock(&s->extralist.lock);
+	node =3D s->extralist.first;
+	if (node)
+		s->extralist.first =3D node->next;
+	raw_spin_unlock(&s->extralist.lock);
+	return node;
+}
+
+static struct pcpu_freelist_node *
+___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
+{
+	struct pcpu_freelist_head *head;
+	struct pcpu_freelist_node *node;
+	int orig_cpu, cpu;
+
+	orig_cpu =3D cpu =3D raw_smp_processor_id();
+	while (1) {
+		head =3D per_cpu_ptr(s->freelist, cpu);
+		if (raw_spin_trylock(&head->lock)) {
+			node =3D head->first;
+			if (node) {
+				head->first =3D node->next;
+				raw_spin_unlock(&head->lock);
+				return node;
+			}
+			raw_spin_unlock(&head->lock);
+		}
+		cpu =3D cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >=3D nr_cpu_ids)
+			cpu =3D 0;
+		if (cpu =3D=3D orig_cpu)
+			break;
 	}
+
+	/* cannot pop from per cpu lists, try extralist */
+	if (!raw_spin_trylock(&s->extralist.lock))
+		return NULL;
+	node =3D s->extralist.first;
+	if (node)
+		s->extralist.first =3D node->next;
+	raw_spin_unlock(&s->extralist.lock);
+	return node;
+}
+
+struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)
+{
+	if (in_nmi())
+		return ___pcpu_freelist_pop_nmi(s);
+	return ___pcpu_freelist_pop(s);
 }
=20
 struct pcpu_freelist_node *pcpu_freelist_pop(struct pcpu_freelist *s)
diff --git a/kernel/bpf/percpu_freelist.h b/kernel/bpf/percpu_freelist.h
index fbf8a8a289791..3c76553cfe571 100644
--- a/kernel/bpf/percpu_freelist.h
+++ b/kernel/bpf/percpu_freelist.h
@@ -13,6 +13,7 @@ struct pcpu_freelist_head {
=20
 struct pcpu_freelist {
 	struct pcpu_freelist_head __percpu *freelist;
+	struct pcpu_freelist_head extralist;
 };
=20
 struct pcpu_freelist_node {
--=20
2.24.1

