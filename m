Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3115CD20B7
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbfJJGTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:19:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732918AbfJJGTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:19:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9A6Cbaj018650
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 23:19:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=H5WTiUKRu1qDnKEKpnXoZ0t4lsxmbyz/pzW2AERatVE=;
 b=VpkPzN+N6TbLnGIfa7Olee2m9RdSMucn9U+I2oiVTekSQbCyQ5wis9JddYAkR1fPojUb
 cy7qygFYDBAjDzV4Di6+f0vKBhllNkDo7MLAtwhqnEAC7xEoedOz7A/R5uiaeIGMpZ1j
 +QqPwR5xladfgZJRAZ2ac1IldxAZOhxgqQk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vgr0gtmgk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 23:19:28 -0700
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 23:19:26 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id F369962E3559; Wed,  9 Oct 2019 23:19:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        <stable@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in bpf_get_stack()
Date:   Wed, 9 Oct 2019 23:19:16 -0700
Message-ID: <20191010061916.198761-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191010061916.198761-1-songliubraving@fb.com>
References: <20191010061916.198761-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_03:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=2 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100058
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

Fix this by checking whether rq_lock is already locked. If so, postpone
the up_read() to irq_work, just like the in_nmi() case.

Fixes: commit 615755a77b24 ("bpf: extend stackmap to save binary_build_id+offset instead of address")
Cc: stable@vger.kernel.org # v4.17+
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Reported-by: Tejun Heo <tj@kernel.org>
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
 kernel/bpf/stackmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 052580c33d26..3b278f6b0c3e 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -287,7 +287,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	bool irq_work_busy = false;
 	struct stack_map_irq_work *work = NULL;

-	if (in_nmi()) {
+	if (in_nmi() || this_rq_is_locked()) {
 		work = this_cpu_ptr(&up_read_work);
 		if (work->irq_work.flags & IRQ_WORK_BUSY)
 			/* cannot queue more up_read, fallback */
--
2.17.1
