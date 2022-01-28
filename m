Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D8C49FC0F
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349458AbiA1OsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:48:16 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:40053 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349456AbiA1OsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643381291;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=iz8Ezjk18Z6wYZm+g6kbkcCyQRUTLyBEEhSEQinqcOw=;
    b=ABaGBri3Bcgq05h/X9PBt42+pWoiBzEhuC8rjE/MM0BbND5U525ISO0fxInw8s1zhd
    01pMDcyFeB/Of6dPkesCbi0WtuqaakUg8v+VqJ+73gvLF3N8qFfra2whGzl6/+7EPe2y
    nt/ARaYCEwMr/VS6Rs+633anY2tLiJCf6tDk0CUCPCTRYAZYgDo/IxTypm4586F4Zisj
    sTtc8k6bEsfqKc1N4ec63z3jFYKnwKv1cpHvX09qsbNEwT+Adwe9b9pWL8uGgnM54GDV
    ba90xqgeUU+tt6WWQmyePmHfj7QRB/735pfaT6BGuakPIEmfjrK9+e0arza35weBhVGq
    4J5w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0SEmARaa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 15:48:10 +0100 (CET)
Message-ID: <07c69ccd-dbc0-5c74-c68e-8636ec9179ef@hartkopp.net>
Date:   Fri, 28 Jan 2022 15:48:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
 <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
 <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
 <20220128084603.jvrvapqf5dt57yiq@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220128084603.jvrvapqf5dt57yiq@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc, hello William,

On 28.01.22 09:46, Marc Kleine-Budde wrote:
> On 28.01.2022 09:32:40, Oliver Hartkopp wrote:
>>
>>
>> On 28.01.22 09:07, Marc Kleine-Budde wrote:
>>> On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
>>>> I've seen the frame processing sometimes freezes for one second when
>>>> stressing the isotp_rcv() from multiple sources. This finally freezes
>>>> the entire softirq which is either not good and not needed as we only
>>>> need to fix this race for stress tests - and not for real world usage
>>>> that does not create this case.
>>>
>>> Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?


>> #
>> # Lock Debugging (spinlocks, mutexes, etc...)
>> #
>> CONFIG_LOCK_DEBUGGING_SUPPORT=y
>> # CONFIG_PROVE_LOCKING is not set
> CONFIG_PROVE_LOCKING=y

Now enabled even more locking (seen relevant kernel config at the end).

It turns out that there is no visible difference when using spin_lock() 
or spin_trylock().

I only got some of these kernel log entries

Jan 28 11:13:14 silver kernel: [ 2396.323211] perf: interrupt took too 
long (2549 > 2500), lowering kernel.perf_event_max_sample_rate to 78250
Jan 28 11:25:49 silver kernel: [ 3151.172773] perf: interrupt took too 
long (3188 > 3186), lowering kernel.perf_event_max_sample_rate to 62500
Jan 28 11:45:24 silver kernel: [ 4325.583328] perf: interrupt took too 
long (4009 > 3985), lowering kernel.perf_event_max_sample_rate to 49750
Jan 28 12:15:46 silver kernel: [ 6148.238246] perf: interrupt took too 
long (5021 > 5011), lowering kernel.perf_event_max_sample_rate to 39750
Jan 28 13:01:45 silver kernel: [ 8907.303715] perf: interrupt took too 
long (6285 > 6276), lowering kernel.perf_event_max_sample_rate to 31750

But I get these sporadically anyway. No other LOCKDEP splat.

At least the issue reported by William should be fixed now - but I'm 
still unclear whether spin_lock() or spin_trylock() is the best approach 
here in the NET_RX softirq?!?

Best regards,
Oliver


$ grep LOCK .config | grep -v BLOCK | grep -v CLOCK
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_DRM_DEBUG_MODESET_LOCK is not set
CONFIG_HWSPINLOCK=y
CONFIG_I8253_LOCK=y
CONFIG_FILE_LOCKING=y
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_TEST_LOCKUP is not set
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RAW_LOCK_NESTING=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
CONFIG_DEBUG_LOCKDEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set

