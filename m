Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB0F190321
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCXBBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:01:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43138 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgCXBBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 21:01:22 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGXwP-0001lB-Rn; Tue, 24 Mar 2020 02:01:14 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 5C672100292; Tue, 24 Mar 2020 02:01:13 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
In-Reply-To: <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de> <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com> <87ftdypyec.fsf@nanos.tec.linutronix.de> <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
Date:   Tue, 24 Mar 2020 02:01:13 +0100
Message-ID: <875zeuftwm.fsf@nanos.tec.linutronix.de>
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
> On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>> > We use an ordered workqueue for tc filters, so these two
>> > works are executed in the same order as they are queued.
>>
>> The workqueue is ordered, but look how the work is queued on the work
>> queue:
>>
>> tcf_queue_work()
>>   queue_rcu_work()
>>     call_rcu(&rwork->rcu, rcu_work_rcufn);
>>
>> So after the grace period elapses rcu_work_rcufn() queues it in the
>> actual work queue.
>>
>> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
>> invoked from preemtible context. Now assume the following:
>>
>> CPU0
>>   tcf_queue_work()
>>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
>>
>> -> Migration
>>
>> CPU1
>>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
>>
>> So your RCU callbacks can be placed on different CPUs which obviously
>> has no ordering guarantee at all. See also:
>
> Good catch!
>
> I thought about this when I added this ordered workqueue, but it
> seems I misinterpret max_active, so despite we have max_active==1,
> more than 1 work could still be queued on different CPU's here.

The workqueue is not the problem. it works perfectly fine. The way how
the work gets queued is the issue.

> I don't know how to fix this properly, I think essentially RCU work
> should be guaranteed the same ordering with regular work. But this
> seems impossible unless RCU offers some API to achieve that.

I don't think that's possible w/o putting constraints on the flexibility
of RCU (Paul of course might disagree).

I assume that the filters which hang of tcindex_data::perfect and
tcindex_data:p must be freed before tcindex_data, right?

Refcounting of tcindex_data should do the trick. I.e. any element which
you add to a tcindex_data instance takes a refcount and when that is
destroyed then the rcu/work callback drops a reference which once it
reaches 0 triggers tcindex_data to be freed.

Thanks,

        tglx
