Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B3853236E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiEXGnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:43:13 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6F50067
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:43:12 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L6l573qyRzDqPQ;
        Tue, 24 May 2022 14:43:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 14:43:10 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 24 May
 2022 14:43:09 +0800
Subject: Re: packet stuck in qdisc : patch proposal
To:     Vincent Ray <vray@kalrayinc.com>
CC:     davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        "vladimir oltean" <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        "Remy Gauguey" <rgauguey@kalrayinc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "will@kernel.org" <will@kernel.org>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
Date:   Tue, 24 May 2022 14:43:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/23 21:54, Vincent Ray wrote:
> Hi Yunsheng, all,

+cc Will & Eric

> 
> I finally spotted the bug that caused (nvme-)tcp packets to remain stuck in the qdisc once in a while.
> It's in qdisc_run_begin within sch_generic.h : 
> 
> smp_mb__before_atomic();
>  
> // [comments]
> 
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
> 
> should be 
> 
> smp_mb();
> 
> // [comments]
> 
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
> 
> I have written a more detailed explanation in the attached patch, including a race example, but in short that's because test_bit() is not an atomic operation.
> Therefore it does not give you any ordering guarantee on any architecture.
> And neither does spin_trylock() called at the beginning of qdisc_run_begin() when it does not grab the lock...
> So test_bit() may be reordered whith a preceding enqueue(), leading to a possible race in the dialog with pfifo_fast_dequeue().
> We may then end up with a skbuff pushed "silently" to the qdisc (MISSED cleared, nobody aware that there is something in the backlog).
> Then the cores pushing new skbuffs to the qdisc may all bypass it for an arbitrary amount of time, leaving the enqueued skbuff stuck in the backlog.
> 
> I believe the reason for which you could not reproduce the issue on ARM64 is that, on that architecture, smp_mb__before_atomic() will translate to a memory barrier.
> It does not on x86 (turned into a NOP) because you're supposed to use this function just before an atomic operation, and atomic operations themselves provide full ordering effects on x86.
> 
> I think the code has been flawed for some time but the introduction of a (true) bypass policy in 5.14 made it more visible, because without this, the "victim" skbuff does not stay very long in the backlog : it is bound to pe popped by the next core executing __qdic_run().
> 
> In my setup, with our use case (16 (virtual) cpus in a VM shooting 4KB buffers with fio through a -i4 nvme-tcp connection to a target), I did not notice any performance degradation using smp_mb() in place of smp_mb__before_atomic(), but of course that does not mean it cannot happen in other configs.
> 
> I think Guoju's patch is also correct and necessary so that both patches, his and mine, should be applied "asap" to the kernel.
> A difference between Guoju's race and "mine" is that, in his case, the MISSED bit will be set : though no one will take care of the skbuff immediately, the next cpu pushing to the qdisc (if ever ...) will notice and dequeue it (so Guoju's race probably happens in my use case too but is not noticeable).
> 
> Finally, given the necessity of these two new full barriers in the code, I wonder if the whole lockless (+ bypass) thing should be reconsidered.
> At least, I think general performance tests should be run to check that lockless qdics still outperform locked qdiscs, in both bypassable and not-bypassable modes.
>     
> More generally, I found this piece of code quite tricky and error-prone, as evidenced by the numerous fixes it went through in the recent history. 
> I believe most of this complexity comes from the lockless qdisc handling in itself, but of course the addition of the bypass support does not really help ;-)
> I'm a linux kernel beginner however, so I'll let more experienced programmers decide about that :-)
> 
> I've made sure that, with this patch, no stuck packets happened any more on both v5.15 and v5.18-rc2 (whereas without the patch, numerous occurrences of stuck packets are visible).
> I'm quite confident it will apply to any concerned version, that is from 5.14 (or before) to mainline.
> 
> Can you please tell me :
> 
> 1) if you agree with this ?
> 
> 2) how to proceed to push this patch (and Guoju's) for quick integration into the mainline ?
> 
> NB : an alternative fix (which I've tested OK too) would be to simply remove the
> 
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
> 
> code path, but I have no clue if this would be better or worse than the present patch in terms of performance.
>     
> Thank you, best regards

Hi, thanks for the testing and debugging. So the main problem is that
test_bit() is not an atomic operation, so using smp_mb __*_atomic() is
not really helping, right?

In that case we might only need to change smp_mb__before_atomic() to
smp_rmb() in qdisc_run_begin(), as we only need to order test_bit()
after set_bit() and clear_bit(), which is a read/write ordering?

By the way,  Guoju need to ensure ordering between spin_unlock() and
test_bit() in qdisc_run_end(), which is a write/read ordering, so
smp_mb() is used.


> 
> V
> 
> 
