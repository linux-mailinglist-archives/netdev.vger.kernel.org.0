Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D7A48AE14
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbiAKNCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:02:41 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17338 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiAKNCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:02:40 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JY9n722f7z9s7R;
        Tue, 11 Jan 2022 21:01:31 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 21:02:38 +0800
Subject: Re: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and
 remove hrtimer_tasklet
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <tglx@linutronix.de>,
        <anna-maria@linutronix.de>
References: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
 <YdwxtqexaE75uCZ8@kroah.com>
 <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
 <ad8ed3db-b5aa-9c48-0bff-2c2623bd17fa@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <fc20454f-68ee-21f5-10a4-8100407aad53@huawei.com>
Date:   Tue, 11 Jan 2022 21:02:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ad8ed3db-b5aa-9c48-0bff-2c2623bd17fa@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 11.01.22 03:02, Ziyang Xuan (William) wrote:
>>> On Mon, Jan 10, 2022 at 09:23:22PM +0800, Ziyang Xuan wrote:
>>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>>
>>>> [ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]
>>>>
>>>> Stop tx/rx cycle rely on the active state of tasklet and hrtimer
>>>> sequentially in bcm_remove_op(), the op object will be freed if they
>>>> are all unactive. Assume the hrtimer timeout is short, the hrtimer
>>>> cb has been excuted after tasklet conditional judgment which must be
>>>> false after last round tasklet_kill() and before condition
>>>> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
>>>> is triggerd, because the stopping action is end and the op object
>>>> will be freed, but the tasklet is scheduled. The resources of the op
>>>> object will occur UAF bug.
>>>
>>> That is not the changelog text of this commit.  Why modify it?
>>
>> Above statement is the reason why I want to backport the patch to
>> stable tree. Maybe I could give an extra cover-letter to explain
>> the details of the problem, but modify the original changelog. Is it?
>>
> 
> If you backport the bcm HRTIMER_MODE_SOFT implementation to the 4.19 stable tree the problem is not fixed for 4.14, 4.4, etc.

This backport patch does not fit lts 4.4 and 4.9. In addition,
I backport patch to lts for the first time. So I am going to
backport the patch one by one.

> 
> HRTIMER_MODE_SOFT has been introduced in 4.16
> 
> The issue of a race condition at bcm op removal has already been addressed before in commit a06393ed03167 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal").
> 
> -       hrtimer_cancel(&op->timer);
> -       hrtimer_cancel(&op->thrtimer);
> -
> -       if (op->tsklet.func)
> -               tasklet_kill(&op->tsklet);
> +       if (op->tsklet.func) {
> +               while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
> +                      test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
> +                      hrtimer_active(&op->timer)) {
> +                       hrtimer_cancel(&op->timer);
> +                       tasklet_kill(&op->tsklet);
> +               }
> +       }
> 
> IMO we should better try to improve this fix and enable it for older stable trees than fixing only the 4.19.

The commit bf74aa86e111 can solve the op UAF nicely and enter mainline from v5.4.
I prefer to backport the patch to lower lts, but other sewing and mending,
for example move hrtimer_active() forward.

> 
> Best regards,
> Oliver
> 
> 
> 
>>>
>>>>
>>>> ----------------------------------------------------------------------
>>>>
>>>> This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
>>>> timer callback in softirq context and removes the hrtimer_tasklet.
>>>>
>>>> Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com
>>
>> This is the public problem reporter. Do I need to move it to cover-letter
>> but here?
>>
>>>> Cc: stable@vger.kernel.org # 4.19
>>
>> I want to backport the patch to linux-4.19.y stable tree. How do I need to
>> modify?
>>
>>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>>> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
>>>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>> ---
>>>>   net/can/bcm.c | 156 +++++++++++++++++---------------------------------
>>>>   1 file changed, 52 insertions(+), 104 deletions(-)
>>>
>>> What stable kernel tree(s) are you wanting this backported to?
>>>
>>> thanks,
>>>
>>> greg k-h
>>> .
>>>
>>
>> Thank you for your patient guidance.
>>
> .
