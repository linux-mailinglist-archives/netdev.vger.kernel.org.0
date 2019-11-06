Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59508F14E4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfKFLUF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Nov 2019 06:20:05 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2078 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFLUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:20:05 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id E26877F523FB82AE9FB6;
        Wed,  6 Nov 2019 19:19:28 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 19:19:28 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 6 Nov 2019 19:19:26 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1713.004;
 Wed, 6 Nov 2019 11:19:24 +0000
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH] net: hns: Ensure that interface teardown cannot race with
 TX interrupt
Thread-Topic: [PATCH] net: hns: Ensure that interface teardown cannot race
 with TX interrupt
Thread-Index: AQHVk0n0bjLQxPyNVEeIvNGhOalq6ad8Sp0QgAA7j2CAAUiZAIAAIPgQ
Date:   Wed, 6 Nov 2019 11:19:24 +0000
Message-ID: <2311b5965adb4ccea83b6072115efc6c@huawei.com>
References: <20191104195604.17109-1-maz@kernel.org>
        <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com> <20191106081748.0e21554c@why>
In-Reply-To: <20191106081748.0e21554c@why>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: Wednesday, November 6, 2019 8:18 AM
> To: Salil Mehta <salil.mehta@huawei.com>

Hi Marc,

> On Tue, 5 Nov 2019 18:41:11 +0000
> Salil Mehta <salil.mehta@huawei.com> wrote:
> 
> Hi Salil,
> 
> > Hi Marc,
> > I tested with the patch on D05 with the lockdep enabled kernel with below options
> > and I could not reproduce the deadlock. I do not argue the issue being mentioned
> > as this looks to be a clear bug which should hit while TX data-path is running
> > and we try to disable the interface.
> 
> Lockdep screaming at you doesn't mean the deadly scenario happens in
> practice, and I've never seen the machine hanging in these conditions.
> But I've also never tried to trigger it in anger.
> 
> > Could you please help me know the exact set of steps you used to get into this
> > problem. Also, are you able to re-create it easily/frequently?
> 
> I just need to issue "reboot" (which calls "ip link ... down") for this
> to trigger. Here's a full splat[1], as well as my full config[2]. It is
> 100% repeatable.
> 
> > # Kernel Config options:
> > CONFIG_LOCKDEP_SUPPORT=y
> > CONFIG_LOCKDEP=y
> 
> You'll need at least
> 
> CONFIG_PROVE_LOCKING=y
> CONFIG_NET_POLL_CONTROLLER=y


Few points:
1. To me netpoll causing spinlock deadlock with IRQ leg of TX and ip util is
    highly unlikely since netpoll runs with both RX/TX interrupts disabled.
    It runs in polling mode to facilitate parallel path to features like
    Netconsole, netdump etc. hence, deadlock because of the netpoll should
    be highly unlikely. Therefore, smells of some other problem here...
2. Also, I remember patch[s1][s2] from Eric Dumazet to disable netpoll on many
    NICs way back in 4.19 kernel on the basis of Song Liu's findings.

Problem: 
Aah, I see the problem now, it is because of the stray code related to the
NET_POLL_CONTROLLER in hns driver which actually should have got remove within
the patch[s1], and that also explains why it does not get hit while NET POLL
is disabled.


/* netif_tx_lock will turn down the performance, set only when necessary */
#ifdef CONFIG_NET_POLL_CONTROLLER
#define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
#define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
#else
#define NETIF_TX_LOCK(ring)
#define NETIF_TX_UNLOCK(ring)
#endif


Once you define CONFIG_NET_POLL_CONTROLLER in the latest code these macros
Kick-in even for the normal NAPI path. Which can cause deadlock and that perhaps
is what you are seeing?

Now, the question is do we require these locks in normal NAPI poll? I do not
see that we need them anymore as Tasklets are serialized to themselves and
configuration path like "ip <intf> down" cannot conflict with NAPI poll path
as the later is always disabled prior performing interface down operation.
Hence, no conflict there.

As  a side analysis, I could figure out some contentions in the configuration
path not related to this though. :) 


Suggested Solution:
Since we do not have support of NET_POLL_CONTROLLER macros NETIF_TX_[UN]LOCK
We should remove these NET_POLL_CONTROLLER macros altogether for now.

Though, I still have not looked comprehensively how other are able to use
Debugging utils like netconsole etc without having NET_POLL_CONTROLLER.
Maybe @Eric Dumazet might give us some insight on this?


If you agree with this then I can send a patch to remove these from hns
driver. This should solve your problem as well?



[S1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4bd2c03be7
[S2] https://lkml.org/lkml/2018/10/4/32

> 
> in order to hit it.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://paste.debian.net/1114451/
> [2] https://paste.debian.net/1114472/
> --
> Jazz is not dead. It just smells funny...
