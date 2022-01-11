Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F074A48A90D
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348801AbiAKIBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:01:11 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:36187 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348793AbiAKIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 03:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641887872;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=mYH9lkT+GwFnDOw9IKYwpC+Ah/WIwWlmTNiFmGgdIkA=;
    b=GXR6V0q+Z3Xh+leOYC3SpC1EvyRJXrQI9LZtITL0tabILVvqacaKxfVlpV5B2k4kbf
    F65oRGMqJSznYWyPINizUH2XF83ZMIHDhvHdb0G3TNHZ6DSTNnW8eD0lTjzSAkT4fB7G
    guIuM7DOc8HJK/sMA29mrk7IvfgzEKj57WlGKyoEyzx3L3juW78xJshtbFqfidDZDKMC
    Q69zk4tDPS03wjFOzCIaJgcnVCxoK7LXyw1ySJiZu+5HqNfRLn8T4Zf7vHEtoyNFwBTh
    wpSmgku0xmCYFq/B+2FhKKtXQX668uFDvfGbOrXUQ5UTVhz+zB7/X160m+0mt0g8QE7p
    jwcQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id Rb080by0B7vpB3s
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 08:57:51 +0100 (CET)
Subject: Re: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and
 remove hrtimer_tasklet
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-can@vger.kernel.org, tglx@linutronix.de,
        anna-maria@linutronix.de
References: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
 <YdwxtqexaE75uCZ8@kroah.com>
 <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <ad8ed3db-b5aa-9c48-0bff-2c2623bd17fa@hartkopp.net>
Date:   Tue, 11 Jan 2022 08:57:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11.01.22 03:02, Ziyang Xuan (William) wrote:
>> On Mon, Jan 10, 2022 at 09:23:22PM +0800, Ziyang Xuan wrote:
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>
>>> [ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]
>>>
>>> Stop tx/rx cycle rely on the active state of tasklet and hrtimer
>>> sequentially in bcm_remove_op(), the op object will be freed if they
>>> are all unactive. Assume the hrtimer timeout is short, the hrtimer
>>> cb has been excuted after tasklet conditional judgment which must be
>>> false after last round tasklet_kill() and before condition
>>> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
>>> is triggerd, because the stopping action is end and the op object
>>> will be freed, but the tasklet is scheduled. The resources of the op
>>> object will occur UAF bug.
>>
>> That is not the changelog text of this commit.  Why modify it?
> 
> Above statement is the reason why I want to backport the patch to
> stable tree. Maybe I could give an extra cover-letter to explain
> the details of the problem, but modify the original changelog. Is it?
> 

If you backport the bcm HRTIMER_MODE_SOFT implementation to the 4.19 
stable tree the problem is not fixed for 4.14, 4.4, etc.

HRTIMER_MODE_SOFT has been introduced in 4.16

The issue of a race condition at bcm op removal has already been 
addressed before in commit a06393ed03167 ("can: bcm: fix hrtimer/tasklet 
termination in bcm op removal").

-       hrtimer_cancel(&op->timer);
-       hrtimer_cancel(&op->thrtimer);
-
-       if (op->tsklet.func)
-               tasklet_kill(&op->tsklet);
+       if (op->tsklet.func) {
+               while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
+                      test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
+                      hrtimer_active(&op->timer)) {
+                       hrtimer_cancel(&op->timer);
+                       tasklet_kill(&op->tsklet);
+               }
+       }

IMO we should better try to improve this fix and enable it for older 
stable trees than fixing only the 4.19.

Best regards,
Oliver



>>
>>>
>>> ----------------------------------------------------------------------
>>>
>>> This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
>>> timer callback in softirq context and removes the hrtimer_tasklet.
>>>
>>> Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com
> 
> This is the public problem reporter. Do I need to move it to cover-letter
> but here?
> 
>>> Cc: stable@vger.kernel.org # 4.19
> 
> I want to backport the patch to linux-4.19.y stable tree. How do I need to
> modify?
> 
>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
>>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>> ---
>>>   net/can/bcm.c | 156 +++++++++++++++++---------------------------------
>>>   1 file changed, 52 insertions(+), 104 deletions(-)
>>
>> What stable kernel tree(s) are you wanting this backported to?
>>
>> thanks,
>>
>> greg k-h
>> .
>>
> 
> Thank you for your patient guidance.
> 
