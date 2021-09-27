Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F30419331
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhI0LgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:36:06 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:18589 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbhI0LgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 07:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632742333;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=A7jJT/r6/9Ett/t4hQhIi6ULJqWDgIKTPE7eELyiqA0=;
    b=gLLYDycb0+GMF9cTOKAhHrpTom96pYzfDa6Smzs+0KzlPUD/fkrkeP5O+NZBhn/YGJ
    Gj9y3rRzluIEXuEUHLRjHHg3p3mtK0MrMr4VbrFTyJOuCIKQlZD/H/YTcDEOXzjwaIaN
    ygg5FEnhVdcbvG75lRr1m5SfOt7IXBWmKMk/Lys81wLK0ssAhn1xoebe0UQR2zsk6oGE
    XR9Y2HWh2mPk5w1SEtbWCo2mjL7DrZ73cANFmITdcTmbFJO1sitJo8M4DoCWVjso8BZi
    Dq8IAZP4xGibE/oTdoBGnrF7Ua3A6j7zDebmxpaQxc0A6Za4ELHtYSKuF72TmPU+9GOb
    6pzg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVvBOfXT2V6Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f904::b82]
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 900f80x8RBWDHN5
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 27 Sep 2021 13:32:13 +0200 (CEST)
Subject: Re: [PATCH net] can: isotp: add result check for
 wait_event_interruptible()
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20210918092819.156291-1-william.xuanziyang@huawei.com>
 <1fcfeb88-d49d-2a2a-1524-8504eb848123@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <e9607f21-f0d0-7b20-8d55-fad9cee7ee28@hartkopp.net>
Date:   Mon, 27 Sep 2021 13:32:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1fcfeb88-d49d-2a2a-1524-8504eb848123@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.09.21 03:39, Ziyang Xuan (William) wrote:
>> Using wait_event_interruptible() to wait for complete transmission,
>> but do not check the result of wait_event_interruptible() which can
>> be interrupted. It will result in tx buffer has multiple accessers
>> and the later process interferes with the previous process.
>>
>> Following is one of the problems reported by syzbot.
>>
>> =============================================================
>> WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
>> RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
>> Call Trace:
>>   <IRQ>
>>   ? isotp_setsockopt+0x390/0x390
>>   __hrtimer_run_queues+0xb8/0x610
>>   hrtimer_run_softirq+0x91/0xd0
>>   ? rcu_read_lock_sched_held+0x4d/0x80
>>   __do_softirq+0xe8/0x553
>>   irq_exit_rcu+0xf8/0x100
>>   sysvec_apic_timer_interrupt+0x9e/0xc0
>>   </IRQ>
>>   asm_sysvec_apic_timer_interrupt+0x12/0x20
>>
>> Add result check for wait_event_interruptible() in isotp_sendmsg()
>> to avoid multiple accessers for tx buffer.
>>
>> Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
>> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> Hi Oliver,
> I send a new patch with this problem, ignore this patch please.
> 
> Thank you!
> 

I was still pondering on this patch ;-)

But I'll take a look on the update now.

Thanks & best regards,
Oliver
