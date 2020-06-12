Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AA1F740E
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFLGqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:46:54 -0400
Received: from nautica.notk.org ([91.121.71.147]:50528 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgFLGqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 02:46:50 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id BDA7BC009; Fri, 12 Jun 2020 08:46:47 +0200 (CEST)
Date:   Fri, 12 Jun 2020 08:46:32 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p/trans_fd: Fix concurrency del of req_list in
 p9_fd_cancelled/p9_read_work
Message-ID: <20200612064632.GA19461@nautica>
References: <20200611014855.60550-1-wanghai38@huawei.com>
 <20200611145055.GA28945@nautica>
 <7bed531c-0ea5-b5f8-eaf8-4feb9ccf1b31@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bed531c-0ea5-b5f8-eaf8-4feb9ccf1b31@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wanghai (M) wrote on Fri, Jun 12, 2020:
> You are right, I got a syzkaller bug.
> 
> "p9_read_work+0x7c3/0xd90" points to list_del(&m->rreq->req_list);
> 
> [   62.733598] kasan: CONFIG_KASAN_INLINE enabled
> [   62.734484] kasan: GPF could be caused by NULL-ptr deref or user memory access
> [   62.735670] general protection fault: 0000 [#1] SMP KASAN PTI
> [   62.736577] CPU: 3 PID: 82 Comm: kworker/3:1 Not tainted 4.19.124+ #2
> [   62.737582] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [   62.738988] Workqueue: events p9_read_work
> [   62.739642] RIP: 0010:p9_read_work+0x7c3/0xd90
> [   62.740348] Code: 48 c1 e9 03 80 3c 01 00 0f 85 cb 05 00 00 48 8d 7a 08 48 b9 00 00 00 00 00 fc ff df 49 8b 87 b8 00 00 00 48 89 fe 48 c1 ee 03 <80> 3c 0e 00 0f 85 89 05 00 00 48 89 c6 48 b9 00 00 00 00 00 fc ff
> [   62.743236] RSP: 0018:ffff8883ece17ca0 EFLAGS: 00010a06
> [   62.744059] RAX: dead000000000200 RBX: ffff8883d45666b0 RCX: dffffc0000000000
> [   62.745173] RDX: dead000000000100 RSI: 1bd5a00000000021 RDI: dead000000000108
> [   62.746279] RBP: ffff8883d4566590 R08: ffffed107a8acf31 R09: ffffed107a8acf31
> [   62.747398] R10: 0000000000000001 R11: ffffed107a8acf30 R12: 1ffff1107d9c2f9b
> [   62.748505] R13: ffff8883d45665d0 R14: ffff8883d4566608 R15: ffff8883e1f1c000
> [   62.749615] FS:  0000000000000000(0000) GS:ffff8883ef180000(0000) knlGS:0000000000000000
> [   62.750881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   62.751784] CR2: 0000000000000000 CR3: 000000009c622003 CR4: 00000000007606e0
> [   62.752898] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   62.754011] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   62.755126] PKRU: 55555554
> [   62.755561] Call Trace:
> [   62.755963]  ? p9_write_work+0xa00/0xa00
> [   62.756592]  process_one_work+0xae4/0x1b20
> [   62.757252]  ? apply_wqattrs_commit+0x3e0/0x3e0
> [   62.757985]  worker_thread+0x8c/0xe80
> [   62.758600]  ? __kthread_parkme+0xe9/0x190
> [   62.759254]  ? process_one_work+0x1b20/0x1b20
> [   62.759950]  kthread+0x341/0x410
> [   62.760479]  ? kthread_create_worker_on_cpu+0xf0/0xf0
> [   62.761296]  ret_from_fork+0x3a/0x50
> [   62.761874] Modules linked in:
> [   62.762378] Dumping ftrace buffer:
> [   62.762942]    (ftrace buffer empty)
> [   62.763547] ---[ end trace 69672816613947a3 ]---

This looks like:
https://syzkaller.appspot.com/bug?id=5df4f85d764ee89863d0294b4e0c87ef2fd2c624
I'm not sure how active this still is but please also add this
Reported-by tag:
Reported-by: syzbot+77a25acfa0382e06ab23@syzkaller.appspotmail.com

(can keep both)


> Yes，In this case,  all further 9p messages will not be read.
> >p9_read_work probably should handle REQ_STATUS_FLSHD in a special case
> >that just throws the message away without error as well.
> 
> Can it be solved like this?
> 
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -362,7 +362,7 @@ static void p9_read_work(struct work_struct *work)
>                 if (m->rreq->status == REQ_STATUS_SENT) {
>                         list_del(&m->rreq->req_list);
>                         p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
> -               } else {
> +               } else if (m->rreq->status != REQ_STATUS_FLSHD) {
>                         spin_unlock(&m->client->lock);
>                         p9_debug(P9_DEBUG_ERROR,
>                                  "Request tag %d errored out while
> we were reading the reply\n",

Yes that is probably correct.
Please add a comment above saying we ignore replies associated with a
cancelled request.

> This patch "afd8d65411" just moved list_del into cancelled ops. It
> is not actually the initial patch that caused the bug
> 
> In 60ff779c4abb ("9p: client: remove unused code and any reference
> to "cancelled" function")
> 
> It moved spin_lock under "if (oldreq->status == REQ_STATUS_FLSH)" .
> 
> After "if (oldreq->status == REQ_STATUS_FLSH)", oldreq may be
> changed by other thread.

Ok, thank you for explaining; I agree now.

-- 
Dominique
