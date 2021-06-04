Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F9339AF0A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 02:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFDAZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 20:25:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49553 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 20:25:09 -0400
Received: from fsav402.sakura.ne.jp (fsav402.sakura.ne.jp [133.242.250.101])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1540N0ME072055;
        Fri, 4 Jun 2021 09:23:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav402.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp);
 Fri, 04 Jun 2021 09:23:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1540MrED071967
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 4 Jun 2021 09:23:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
References: <20210602151733.3630-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <265c1129-96f1-7bb1-1d01-b2b8cc5b1a42@hartkopp.net>
 <51ed3352-b5b0-03a1-ec25-faa368adcc46@i-love.sakura.ne.jp>
Message-ID: <5e4693cf-4691-e7da-9a04-3e70cc449bf5@i-love.sakura.ne.jp>
Date:   Fri, 4 Jun 2021 09:22:52 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <51ed3352-b5b0-03a1-ec25-faa368adcc46@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Kirill for commit 328fbe747ad4622f ("net: Close race between
{un, }register_netdevice_notifier() and setup_net()/cleanup_net()").

I'm proposing this patch because calling {,un}register_netdevice_notifier()
on every socket {initialization,destruction} is killing ability to
concurrently run cleanup_net() enough for khungtaskd to complain.

You are referring something with raw_init() in the above commit.
What is your concern? (I'm asking you in case this patch breaks
something you mentioned.)

On 2021/06/03 20:02, Tetsuo Handa wrote:
> On 2021/06/03 15:09, Oliver Hartkopp wrote:
>> so I wonder why only the *registering* of a netdev notifier can cause a 'hang' in that way?!?
> 
> Not only the *registering* of a netdev notifier causes a 'hang' in that way.
> For example,
> 
>> My assumption would be that a wrong type of locking mechanism is used in
>> register_netdevice_notifier() which you already tried to address here:
>>
>> https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30
> 
> the result of
> 
>> -> https://syzkaller.appspot.com/text?tag=Patch&x=106ad8dbd00000
> 
> is https://syzkaller.appspot.com/text?tag=CrashReport&x=1705d92fd00000 which
> says that the *unregistering* of a netdev notifier caused a 'hang'. In other
> words, making register_netdevice_notifier() killable is not sufficient, and
> it is impossible to make unregister_netdevice_notifier() killable.
> 
> Moreover, there are modules (e.g. CAN driver's raw/bcm/isotp modules) which are
> not prepared for register_netdevice_notifier() failure. Therefore, I made this
> patch which did not cause a 'hang' even if "many things" (see the next paragraph)
> are run concurrently.
> 
>> The removal of one to three data structures in CAN is not time consuming.
> 
> Yes, it would be true that CAN socket's operations alone are not time consuming.
> But since syzkaller is a fuzzer, it concurrently runs many things (including
> non-CAN sockets operations and various networking devices), and cleanup_net()
> for some complicated combinations will be time consuming.
> 
>> IMHO we need to fix some locking semantics (with pernet_ops_rwsem??) here.
> 
> Assuming that lockdep is correctly detecting possibility of deadlock, no lockdep
> warning indicates that there is no locking semantics error here. In other words,
> taking locks (e.g. pernet_ops_rwsem, rtnl_mutex) that are shared by many protocols
> causes fast protocols to be slowed down to the possible slowest operations.
> 
> As explained at
> https://lkml.kernel.org/r/CACT4Y+Y8KmaoEj0L8g=wX4owS38mjNLVMMLsjyoN8DU9n=FrrQ@mail.gmail.com ,
> unbounded asynchronous queuing is always a recipe for disaster. cleanup_net() is
> called from a WQ context, and does time consuming operations with pernet_ops_rwsem
> held for read. Therefore, reducing frequency of holding pernet_ops_rwsem for write
> (because CAN driver's raw/bcm/isotp modules are calling {,un}register_netdevice_notifier()
> on every socket) helps cleanup_net() to make more progress; a low-hanging mitigation
> for this problem.
> 

