Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF15D6813
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbfJNRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:12:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51282 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388354AbfJNRMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:12:31 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9EH8J37027086
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 10:12:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VZQSaFL6cILSBSh9R3ERpIGAqSNRb2JkOURfLEvU0XA=;
 b=XxjhRdaOOEW/3QdKoX/UzbVRKdtqhSM/r4lOVuctEYUIoxhlJyBxNq5w1fqO/f59m/lZ
 ZLKsA55TuNwkS+PI0hW67c3jqlKQlwGrVrs+GPj8VrxXn90jyePl6MfCN9JReKA2xEed
 r/VxfmIuJLHLv/rPno1eAdTq675SGSO/zQ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vky52dbms-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 10:12:30 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Oct 2019 10:12:28 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BC1D262E1383; Mon, 14 Oct 2019 10:12:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <sashal@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>, <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] bpf/stackmap: fix deadlock with rq_lock in bpf_get_stack()
Date:   Mon, 14 Oct 2019 10:12:23 -0700
Message-ID: <20191014171223.357174-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_09:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=2 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf stackmap with build-id lookup (BPF_F_STACK_BUILD_ID) can trigger A-A
deadlock on rq_lock():

rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[...]
Call Trace:
 try_to_wake_up+0x1ad/0x590
 wake_up_q+0x54/0x80
 rwsem_wake+0x8a/0xb0
 bpf_get_stack+0x13c/0x150
 bpf_prog_fbdaf42eded9fe46_on_event+0x5e3/0x1000
 bpf_overflow_handler+0x60/0x100
 __perf_event_overflow+0x4f/0xf0
 perf_swevent_overflow+0x99/0xc0
 ___perf_sw_event+0xe7/0x120
 __schedule+0x47d/0x620
 schedule+0x29/0x90
 futex_wait_queue_me+0xb9/0x110
 futex_wait+0x139/0x230
 do_futex+0x2ac/0xa50
 __x64_sys_futex+0x13c/0x180
 do_syscall_64+0x42/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This can be reproduced by:
1. Start a multi-thread program that does parallel mmap() and malloc();
2. taskset the program to 2 CPUs;
3. Attach bpf program to trace_sched_switch and gather stackmap with
   build-id, e.g. with trace.py from bcc tools:
   trace.py -U -p <pid> -s <some-bin,some-lib> t:sched:sched_switch

A sample reproducer is attached at the end.

This could also trigger deadlock with other locks that are nested with
rq_lock.

Fix this by checking whether irqs are disabled. Since rq_lock and all
other nested locks are irq safe, it is safe to do up_read() when irqs are
not disable. If the irqs are disabled, postpone up_read() in irq_work.

Fixes: commit 615755a77b24 ("bpf: extend stackmap to save binary_build_id+offset instead of address")
Cc: stable@vger.kernel.org # v4.17+
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Song Liu <songliubraving@fb.com>

Reproducer:
============================ 8< ============================

char *filename;

void *worker(void *p)
{
        void *ptr;
        int fd;
        char *pptr;

        fd = open(filename, O_RDONLY);
        if (fd < 0)
                return NULL;
        while (1) {
                struct timespec ts = {0, 1000 + rand() % 2000};

                ptr = mmap(NULL, 4096 * 64, PROT_READ, MAP_PRIVATE, fd, 0);
                usleep(1);
                if (ptr == MAP_FAILED) {
                        printf("failed to mmap\n");
                        break;
                }
                munmap(ptr, 4096 * 64);
                usleep(1);
                pptr = malloc(1);
                usleep(1);
                pptr[0] = 1;
                usleep(1);
                free(pptr);
                usleep(1);
                nanosleep(&ts, NULL);
        }
        close(fd);
        return NULL;
}

int main(int argc, char *argv[])
{
        void *ptr;
        int i;
        pthread_t threads[THREAD_COUNT];

        if (argc < 2)
                return 0;

        filename = argv[1];

        for (i = 0; i < THREAD_COUNT; i++) {
                if (pthread_create(threads + i, NULL, worker, NULL)) {
                        fprintf(stderr, "Error creating thread\n");
                        return 0;
                }
        }

        for (i = 0; i < THREAD_COUNT; i++)
                pthread_join(threads[i], NULL);
        return 0;
}
============================ 8< ============================

---
Changes v1 => v2:
1. Drop (1/1) and cover letter;
2. Check irqs_disabled() instead of this_rq_is_locked()
---
 kernel/bpf/stackmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 052580c33d26..173e983619d7 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -287,7 +287,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	bool irq_work_busy = false;
 	struct stack_map_irq_work *work = NULL;
 
-	if (in_nmi()) {
+	if (irqs_disabled()) {
 		work = this_cpu_ptr(&up_read_work);
 		if (work->irq_work.flags & IRQ_WORK_BUSY)
 			/* cannot queue more up_read, fallback */
@@ -295,8 +295,9 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	}
 
 	/*
-	 * We cannot do up_read() in nmi context. To do build_id lookup
-	 * in nmi context, we need to run up_read() in irq_work. We use
+	 * We cannot do up_read() when the irq is disabled, because of
+	 * risk to deadlock with rq_lock. To do build_id lookup when the
+	 * irqs are disabled, we need to run up_read() in irq_work. We use
 	 * a percpu variable to do the irq_work. If the irq_work is
 	 * already used by another lookup, we fall back to report ips.
 	 *
-- 
2.17.1

