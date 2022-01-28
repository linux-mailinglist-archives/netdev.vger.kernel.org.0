Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C3149F525
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347310AbiA1Ic5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:32:57 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:39969 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiA1Ics (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:32:48 -0500
X-Greylist: delayed 2177 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 03:32:48 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643358761;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nvSJZBBJT2q+vUwqNK0O/1viTFb58vvMn1effcu24RM=;
    b=DIXenEET2Dy7Gbverr5Plo+LymUUpRURXYTLhcjzPje2u041fiNKKxbK6eeN1GiSu+
    m8B9dxri2+AzmCDFIYSpl+iN/nWWjSHHRyID25wbGI/A8JVOzZ9kidZyXRH1s52M11aJ
    PGzHyjEMPkapkgdYKfa4Tvu3HBerpV8I2rG5IJDkL2ymH65D4QjXh5yrfaFY2DI508Im
    7SDkeCWw/GVhe+tv/HWNJpep7NfIPtJ0+eZrq08qIfwleii0anH8mMOOXxVfuwiJdD+F
    okDtiE/ehB4TbVcRSgzpXenlHqvIHYVFxgPMgijxCf1dVsfFdbq87f0W9ol3aYkVCmey
    /sAA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0S8WeQ4Z
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 09:32:40 +0100 (CET)
Message-ID: <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
Date:   Fri, 28 Jan 2022 09:32:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
 <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.01.22 09:07, Marc Kleine-Budde wrote:
> On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
>> I've seen the frame processing sometimes freezes for one second when
>> stressing the isotp_rcv() from multiple sources. This finally freezes
>> the entire softirq which is either not good and not needed as we only
>> need to fix this race for stress tests - and not for real world usage
>> that does not create this case.
> 
> Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?

In kernel config? I enabled almost everything with LOCKing ;-)


CONFIG_LOCKDEP_SUPPORT=y

CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y

CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

CONFIG_HWSPINLOCK=y

CONFIG_I8253_LOCK=y

#
# Debug Oops, Lockups and Hangs
#
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120 <--- the isotp timeout is 1000 ms 
what I can observe here with v1 patch

# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

Only this debugging stuff is not really enabled:

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

Would this help to be enabled for this test (of the v1 patch?

Best regards,
Oliver

