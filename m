Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A951D190016
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCWVOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:14:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42841 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgCWVOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:14:17 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGUOa-0007Jk-Ch; Mon, 23 Mar 2020 22:14:04 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C404A1040AA; Mon, 23 Mar 2020 22:14:03 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
In-Reply-To: <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de> <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
Date:   Mon, 23 Mar 2020 22:14:03 +0100
Message-ID: <87ftdypyec.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:
> On Sat, Mar 21, 2020 at 3:19 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> > ------------[ cut here ]------------
>> > ODEBUG: free active (active state 0) object type: work_struct hint: tcindex_destroy_rexts_work+0x0/0x20 net/sched/cls_tcindex.c:143
>> ...
>> >  __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
>> >  debug_check_no_obj_freed+0x2e1/0x445 lib/debugobjects.c:998
>> >  kfree+0xf6/0x2b0 mm/slab.c:3756
>> >  tcindex_destroy_work+0x2e/0x70 net/sched/cls_tcindex.c:231
>>
>> So this is:
>>
>>         kfree(p->perfect);
>>
>> Looking at the place which queues that work:
>>
>> tcindex_destroy()
>>
>>    if (p->perfect) {
>>         if (tcf_exts_get_net(&r->exts))
>>             tcf_queue_work(&r-rwork, tcindex_destroy_rexts_work);
>>         else
>>             __tcindex_destroy_rexts(r)
>>    }
>>
>>    .....
>>
>>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
>>
>> So obviously if tcindex_destroy_work() runs before
>> tcindex_destroy_rexts_work() then the above happens.
>
> We use an ordered workqueue for tc filters, so these two
> works are executed in the same order as they are queued.

The workqueue is ordered, but look how the work is queued on the work
queue:

tcf_queue_work()
  queue_rcu_work()
    call_rcu(&rwork->rcu, rcu_work_rcufn);

So after the grace period elapses rcu_work_rcufn() queues it in the
actual work queue.

Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
invoked from preemtible context. Now assume the following:

CPU0
  tcf_queue_work()
    tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);

-> Migration

CPU1
   tcf_queue_work(&p->rwork, tcindex_destroy_work);

So your RCU callbacks can be placed on different CPUs which obviously
has no ordering guarantee at all. See also:

  https://mirrors.edge.kernel.org/pub/linux/kernel/people/paulmck/Answers/RCU/RCUCBordering.html

Disabling preemption would "fix" it today, but that documentation
explicitely says that it is an implementation detail, but not
guaranteed by design.

Thanks,

        tglx

