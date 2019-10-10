Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7180FD20B3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbfJJGT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:19:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727199AbfJJGT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:19:28 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9A6Cbag018650
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 23:19:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=fQdwDnCPngz+0vM6jXWTh2YHwn4lEhUtF8/NVMQtnMY=;
 b=N+An6FkB8vi+UKXE4fPt0yehTc97qXxWrw4grcNh7LvlQ87QJoQvqF9iq0jcHfAxKYZw
 PDtHNzxGVpzomzBNe2JQkMxejdHdd1+BWgRfOgdgqJGGXKEfpe+mMgRrtQamYnsBslMi
 oh3znn5Mh7BFciLL89RujEpM0kY16rwe9ew= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vgr0gtmgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 23:19:27 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 23:19:25 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E4AD262E3559; Wed,  9 Oct 2019 23:19:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] bpf/stackmap: fix A-A deadlock in bpf_get_stack()
Date:   Wed, 9 Oct 2019 23:19:14 -0700
Message-ID: <20191010061916.198761-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_03:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=956 classifier=spam adjust=0 reason=mlx scancount=1
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

For more details on how to reproduce this is error, please refer to 2/2.

Fix this issue by checking a new helper this_rq_is_locked(). If the
rq_lock is already locked, postpone up_read() in irq_work, just like the
in_nmi() case.

Song Liu (2):
  sched: introduce this_rq_is_locked()
  bpf/stackmap: fix A-A deadlock in bpf_get_stack()

 include/linux/sched.h | 1 +
 kernel/bpf/stackmap.c | 2 +-
 kernel/sched/core.c   | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

--
2.17.1
