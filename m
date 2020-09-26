Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4B279567
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIZAIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:08:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIZAIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:08:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q06DPU029114
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:08:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qTEG/ZjUMY5fpclg4E+VYvLhz4GTO9FMU/7RVCJSxLY=;
 b=XfXFg++OAShB8tBNJIvoPpxCRmcSSBtFW+3MzqdjBWFXFAHWBrOJp37QOvyXV+4F+O4F
 TY/m5OJXDMW2WU0KMbOyTnNClQ5EJqrsSrxSXaH5iRwcBPz3BmL6XmXwAHIW765ivYs+
 j4WDe2weuw2ZL4ZZOMKk8hqi6oyLdJ8F744= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp8aafd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:08:09 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 17:08:08 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 560AA62E556D; Fri, 25 Sep 2020 17:08:07 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next] bpf: use raw_spin_trylock() for pcpu_freelist_push/pop in NMI
Date:   Fri, 25 Sep 2020 17:07:56 -0700
Message-ID: <20200926000756.893078-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009250182
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

For systems with only one cpu, there is a trickier scenario with
pcpu_freelist_push(): if the only pcpu_freelist_head.lock is already
locked before NMI, raw_spin_trylock() will never succeed. Unlike,
_pop(), where we can failover and return NULL, failing _push() will leak
memory. Fix this issue with an extra list, pcpu_freelist.extralist. The
extralist is primarily used to take _push() when raw_spin_trylock()
failed on all the per cpu lists. It should be empty most of the time.
The following table summarizes the behavior of pcpu_freelist in NMI
and non-NMI:

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
-void __pcpu_freelist_push(struct pcpu_freelist *s,
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
 					     struct pcpu_freelist_node *node)
 {
-	struct pcpu_freelist_head *head =3D this_cpu_ptr(s->freelist);
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
=20
-	___pcpu_freelist_push(head, node);
+		/* cannot lock any per cpu lock, try extralist */
+		if (cpu =3D=3D orig_cpu &&
+		    pcpu_freelist_try_push_extra(s, node))
+			return;
+	}
+}
+
+void __pcpu_freelist_push(struct pcpu_freelist *s,
+			struct pcpu_freelist_node *node)
+{
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
 			}
+			raw_spin_unlock(&head->lock);
+		}
+		cpu =3D cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >=3D nr_cpu_ids)
+			cpu =3D 0;
+		if (cpu =3D=3D orig_cpu)
+			break;
+	}
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

