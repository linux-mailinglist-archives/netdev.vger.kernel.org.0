Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DAD625A
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbfJNMVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:21:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59502 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730285AbfJNMVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 08:21:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1AD60898FDB40EB0DFEE;
        Mon, 14 Oct 2019 20:21:28 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 14 Oct 2019
 20:21:23 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     <linux-block@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <axboe@kernel.dk>, <ast@kernel.org>
CC:     <hare@suse.com>, <osandov@fb.com>, <ming.lei@redhat.com>,
        <damien.lemoal@wdc.com>, <bvanassche@acm.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>
Subject: [RFC PATCH 0/2] block: use eBPF to redirect IO completion
Date:   Mon, 14 Oct 2019 20:28:31 +0800
Message-ID: <20191014122833.64908-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For network stack, RPS, namely Receive Packet Steering, is used to
distribute network protocol processing from hardware-interrupted CPU
to specific CPUs and alleviating soft-irq load of the interrupted CPU.

For block layer, soft-irq (for single queue device) or hard-irq
(for multiple queue device) is used to handle IO completion, so
RPS will be useful when the soft-irq load or the hard-irq load
of a specific CPU is too high, or a specific CPU set is required
to handle IO completion.

Instead of setting the CPU set used for handling IO completion
through sysfs or procfs, we can attach an eBPF program to the
request-queue, provide some useful info (e.g., the CPU
which submits the request) to the program, and let the program
decides the proper CPU for IO completion handling.

In order to demonostrate the effect of IO completion redirection,
a test programm is built to redirect the IO completion handling
to all online CPUs or a specific CPU set:

	./test_blkdev_ccpu -d /dev/vda
or
	./test_blkdev_ccpu -d /dev/nvme0n1 -s 4,8,10-13

However I am still trying to find out a killer scenario for
the eBPF redirection, so suggestions and comments are welcome.

Regards,
Tao

Hou Tao (2):
  block: add support for redirecting IO completion through eBPF
  selftests/bpf: add test program for redirecting IO completion CPU

 block/Makefile                                |   2 +-
 block/blk-bpf.c                               | 127 +++++++++
 block/blk-mq.c                                |  22 +-
 block/blk-softirq.c                           |  27 +-
 include/linux/blkdev.h                        |   3 +
 include/linux/bpf_blkdev.h                    |   9 +
 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/syscall.c                          |   9 +
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/progs/blkdev_ccpu_rr.c      |  66 +++++
 .../testing/selftests/bpf/test_blkdev_ccpu.c  | 246 ++++++++++++++++++
 15 files changed, 507 insertions(+), 12 deletions(-)
 create mode 100644 block/blk-bpf.c
 create mode 100644 include/linux/bpf_blkdev.h
 create mode 100644 tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c
 create mode 100644 tools/testing/selftests/bpf/test_blkdev_ccpu.c

-- 
2.22.0

