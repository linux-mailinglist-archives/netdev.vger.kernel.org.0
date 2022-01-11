Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81EC48A568
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 03:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346469AbiAKCCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 21:02:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34894 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiAKCCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 21:02:12 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JXv7c0j0dzccLY;
        Tue, 11 Jan 2022 10:01:32 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 10:02:09 +0800
Subject: Re: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and
 remove hrtimer_tasklet
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <tglx@linutronix.de>, <anna-maria@linutronix.de>
References: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
 <YdwxtqexaE75uCZ8@kroah.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
Date:   Tue, 11 Jan 2022 10:02:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YdwxtqexaE75uCZ8@kroah.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Jan 10, 2022 at 09:23:22PM +0800, Ziyang Xuan wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> [ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]
>>
>> Stop tx/rx cycle rely on the active state of tasklet and hrtimer
>> sequentially in bcm_remove_op(), the op object will be freed if they
>> are all unactive. Assume the hrtimer timeout is short, the hrtimer
>> cb has been excuted after tasklet conditional judgment which must be
>> false after last round tasklet_kill() and before condition
>> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
>> is triggerd, because the stopping action is end and the op object
>> will be freed, but the tasklet is scheduled. The resources of the op
>> object will occur UAF bug.
> 
> That is not the changelog text of this commit.  Why modify it?

Above statement is the reason why I want to backport the patch to
stable tree. Maybe I could give an extra cover-letter to explain
the details of the problem, but modify the original changelog. Is it?

> 
>>
>> ----------------------------------------------------------------------
>>
>> This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
>> timer callback in softirq context and removes the hrtimer_tasklet.
>>
>> Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com

This is the public problem reporter. Do I need to move it to cover-letter
but here?

>> Cc: stable@vger.kernel.org # 4.19

I want to backport the patch to linux-4.19.y stable tree. How do I need to
modify?

>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  net/can/bcm.c | 156 +++++++++++++++++---------------------------------
>>  1 file changed, 52 insertions(+), 104 deletions(-)
> 
> What stable kernel tree(s) are you wanting this backported to?
> 
> thanks,
> 
> greg k-h
> .
> 

Thank you for your patient guidance.
