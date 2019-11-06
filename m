Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456BAF15EA
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfKFMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:16:38 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:52750 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfKFMQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 07:16:38 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iSKEl-0001CL-Ev; Wed, 06 Nov 2019 13:16:35 +0100
To:     Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH] net: hns: Ensure that interface teardown cannot race  with TX interrupt
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 Nov 2019 13:25:56 +0109
From:   Marc Zyngier <maz@kernel.org>
Cc:     <edumazet@google.com>, <netdev@vger.kernel.org>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linuxarm <linuxarm@huawei.com>
In-Reply-To: <2311b5965adb4ccea83b6072115efc6c@huawei.com>
References: <20191104195604.17109-1-maz@kernel.org>
 <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com> <20191106081748.0e21554c@why>
 <2311b5965adb4ccea83b6072115efc6c@huawei.com>
Message-ID: <21493d3d08936d7ed67f7153cdaa418e@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: salil.mehta@huawei.com, edumazet@google.com, netdev@vger.kernel.org, lipeng321@huawei.com, yisen.zhuang@huawei.com, davem@davemloft.net, linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-06 12:28, Salil Mehta wrote:
> Hi Marc,
>
>> On Tue, 5 Nov 2019 18:41:11 +0000
>> Salil Mehta <salil.mehta@huawei.com> wrote:
>>
>> Hi Salil,
>>
>> > Hi Marc,
>> > I tested with the patch on D05 with the lockdep enabled kernel 
>> with below options
>> > and I could not reproduce the deadlock. I do not argue the issue 
>> being mentioned
>> > as this looks to be a clear bug which should hit while TX 
>> data-path is running
>> > and we try to disable the interface.
>>
>> Lockdep screaming at you doesn't mean the deadly scenario happens in
>> practice, and I've never seen the machine hanging in these 
>> conditions.
>> But I've also never tried to trigger it in anger.
>>
>> > Could you please help me know the exact set of steps you used to 
>> get into this
>> > problem. Also, are you able to re-create it easily/frequently?
>>
>> I just need to issue "reboot" (which calls "ip link ... down") for 
>> this
>> to trigger. Here's a full splat[1], as well as my full config[2]. It 
>> is
>> 100% repeatable.
>>
>> > # Kernel Config options:
>> > CONFIG_LOCKDEP_SUPPORT=y
>> > CONFIG_LOCKDEP=y
>>
>> You'll need at least
>>
>> CONFIG_PROVE_LOCKING=y
>> CONFIG_NET_POLL_CONTROLLER=y
>
>
> Few points:
> 1. To me netpoll causing spinlock deadlock with IRQ leg of TX and ip 
> util is
>     highly unlikely since netpoll runs with both RX/TX interrupts 
> disabled.
>     It runs in polling mode to facilitate parallel path to features 
> like
>     Netconsole, netdump etc. hence, deadlock because of the netpoll 
> should
>     be highly unlikely. Therefore, smells of some other problem 
> here...
> 2. Also, I remember patch[s1][s2] from Eric Dumazet to disable
> netpoll on many
>     NICs way back in 4.19 kernel on the basis of Song Liu's findings.
>
> Problem:
> Aah, I see the problem now, it is because of the stray code related 
> to the
> NET_POLL_CONTROLLER in hns driver which actually should have got
> remove within
> the patch[s1], and that also explains why it does not get hit while 
> NET POLL
> is disabled.
>
>
> /* netif_tx_lock will turn down the performance, set only when 
> necessary */
> #ifdef CONFIG_NET_POLL_CONTROLLER
> #define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
> #define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
> #else
> #define NETIF_TX_LOCK(ring)
> #define NETIF_TX_UNLOCK(ring)
> #endif
>
>
> Once you define CONFIG_NET_POLL_CONTROLLER in the latest code these 
> macros
> Kick-in even for the normal NAPI path. Which can cause deadlock and
> that perhaps
> is what you are seeing?

Yes, that's the problem.

> Now, the question is do we require these locks in normal NAPI poll? I 
> do not
> see that we need them anymore as Tasklets are serialized to 
> themselves and
> configuration path like "ip <intf> down" cannot conflict with NAPI 
> poll path
> as the later is always disabled prior performing interface down 
> operation.
> Hence, no conflict there.

My preference would indeed be to drop these per-queue locks if they 
aren't
required. I couldn't figure out from a cursory look at the code whether
two CPUs could serve the same TX queue. If that cannot happen by 
construction,
then these locks are perfectly useless and should be removed.

>
> As  a side analysis, I could figure out some contentions in the 
> configuration
> path not related to this though. :)
>
>
> Suggested Solution:
> Since we do not have support of NET_POLL_CONTROLLER macros 
> NETIF_TX_[UN]LOCK
> We should remove these NET_POLL_CONTROLLER macros altogether for now.
>
> Though, I still have not looked comprehensively how other are able to 
> use
> Debugging utils like netconsole etc without having 
> NET_POLL_CONTROLLER.
> Maybe @Eric Dumazet might give us some insight on this?
>
>
> If you agree with this then I can send a patch to remove these from 
> hns
> driver. This should solve your problem as well?

Sure, as long as you can guarantee that these locks are never used for 
anything
useful.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
