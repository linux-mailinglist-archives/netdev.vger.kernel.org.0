Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FB3246F16
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgHQRmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:42:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731550AbgHQRma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 13:42:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07HHTGOi017614
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:42:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Wl1nAbsoAEGytOCmCAQ3djPCVpfOiulFd7onoiO/9fM=;
 b=oFcoCiIPc95yosBGp+LMhETVgmaVDUZDY3kIOViM/9ylLnM8EbnU+e/9J3hqXrE0c0Ro
 /NOWM0xF1LOqpsRuANixjF52uVPugssKEB6AE35udjW/u5LblcO2CWYdRDIAgB0b7XX2
 X5+oipHSjRoVTNioAluKKHgqSft6DrIY4Os= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32xyyp6f1r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:42:29 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 17 Aug 2020 10:42:26 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D724D3704B8B; Mon, 17 Aug 2020 10:42:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: use get_file_rcu() instead of get_file() for task_file iterator
Date:   Mon, 17 Aug 2020 10:42:14 -0700
Message-ID: <20200817174214.252601-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-17_13:2020-08-17,2020-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxscore=0 suspectscore=9 clxscore=1015
 mlxlogscore=815 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With latest `bpftool prog` command, we observed the following kernel
panic.
    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    PGD dfe894067 P4D dfe894067 PUD deb663067 PMD 0
    Oops: 0010 [#1] SMP
    CPU: 9 PID: 6023 ...
    RIP: 0010:0x0
    Code: Bad RIP value.
    RSP: 0000:ffffc900002b8f18 EFLAGS: 00010286
    RAX: ffff8883a405f400 RBX: ffff888e46a6bf00 RCX: 000000008020000c
    RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8883a405f400
    RBP: ffff888e46a6bf50 R08: 0000000000000000 R09: ffffffff81129600
    R10: ffff8883a405f300 R11: 0000160000000000 R12: 0000000000002710
    R13: 000000e9494b690c R14: 0000000000000202 R15: 0000000000000009
    FS:  00007fd9187fe700(0000) GS:ffff888e46a40000(0000) knlGS:000000000=
0000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffffffffffd6 CR3: 0000000de5d33002 CR4: 0000000000360ee0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     <IRQ>
     rcu_core+0x1a4/0x440
     __do_softirq+0xd3/0x2c8
     irq_exit+0x9d/0xa0
     smp_apic_timer_interrupt+0x68/0x120
     apic_timer_interrupt+0xf/0x20
     </IRQ>
    RIP: 0033:0x47ce80
    Code: Bad RIP value.
    RSP: 002b:00007fd9187fba40 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff1=
3
    RAX: 0000000000000002 RBX: 00007fd931789160 RCX: 000000000000010c
    RDX: 00007fd9308cdfb4 RSI: 00007fd9308cdfb4 RDI: 00007ffedd1ea0a8
    RBP: 00007fd9187fbab0 R08: 000000000000000e R09: 000000000000002a
    R10: 0000000000480210 R11: 00007fd9187fc570 R12: 00007fd9316cc400
    R13: 0000000000000118 R14: 00007fd9308cdfb4 R15: 00007fd9317a9380

After further analysis, the bug is triggered by
Commit eaaacd23910f ("bpf: Add task and task/file iterator targets")
which introduced task_file bpf iterator, which traverses all open file
descriptors for all tasks in the current namespace.
The latest `bpftool prog` calls a task_file bpf program to traverse
all files in the system in order to associate processes with progs/maps, =
etc.
When traversing files for a given task, rcu read_lock is taken to
access all files in a file_struct. But it used get_file() to grab
a file, which is not right. It is possible file->f_count is 0 and
get_file() will unconditionally increase it.
Later put_file() may cause all kind of issues with the above
as one of sympotoms.

The failure can be reproduced with the following steps in a few seconds:
    $ cat t.c
    #include <stdio.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>
    #include <unistd.h>

    #define N 10000
    int fd[N];
    int main() {
      int i;

      for (i =3D 0; i < N; i++) {
        fd[i] =3D open("./note.txt", 'r');
        if (fd[i] < 0) {
           fprintf(stderr, "failed\n");
           return -1;
        }
      }
      for (i =3D 0; i < N; i++)
        close(fd[i]);

      return 0;
    }
    $ gcc -O2 t.c
    $ cat run.sh
    #/bin/bash
    for i in {1..100}
    do
      while true; do ./a.out; done &
    done
    $ ./run.sh
    $ while true; do bpftool prog >& /dev/null; done

This patch used get_file_rcu() which only grabs a file if the
file->f_count is not zero. This is to ensure the file pointer
is always valid. The above reproducer did not fail for more
than 30 minutes.

Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/task_iter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 232df29793e9..f21b5e1e4540 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -178,10 +178,11 @@ task_file_seq_get_next(struct bpf_iter_seq_task_fil=
e_info *info,
 		f =3D fcheck_files(curr_files, curr_fd);
 		if (!f)
 			continue;
+		if (!get_file_rcu(f))
+			continue;
=20
 		/* set info->fd */
 		info->fd =3D curr_fd;
-		get_file(f);
 		rcu_read_unlock();
 		return f;
 	}
--=20
2.24.1

