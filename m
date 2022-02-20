Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AF94BCE74
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 13:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbiBTM0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 07:26:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiBTM0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 07:26:43 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F28753B77;
        Sun, 20 Feb 2022 04:26:21 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4xWhn-_1645359978;
Received: from 30.47.199.196(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V4xWhn-_1645359978)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 20 Feb 2022 20:26:19 +0800
Message-ID: <1a7e74b4-8827-c14b-7371-9656a643d03c@linux.alibaba.com>
Date:   Sun, 20 Feb 2022 20:26:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [Issue report] drivers/ftgmac100: DHCP occasionally fails during
 boot up or link down/up
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
 <YgwSAjGN2eWUpamo@lunn.ch>
 <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
 <YhE2wl7XcTUQvEd4@lunn.ch>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <YhE2wl7XcTUQvEd4@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

There is indeed a dead lock warning after enabling prove_locking:


[   16.852199] ======================================================
[   16.859102] WARNING: possible circular locking dependency detected
[   16.866012] 5.10.36-60b3c9d-dirty-15f4fba #1 Not tainted
[   16.871976] ------------------------------------------------------
[   16.871991] kworker/1:1/23 is trying to acquire lock:
[   16.872000] 80fa0920 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x28
[   16.872047]
[   16.872047] but task is already holding lock:
[   16.872051] 821d44c0 (&dev->lock){+.+.}-{3:3}, at: 
phy_state_machine+0x50/0x290
[   16.872076]
[   16.872076] which lock already depends on the new lock.
[   16.872076]
[   16.872080]
[   16.872080] the existing dependency chain (in reverse order) is:
[   16.872083]
[   16.872083] -> #1 (&dev->lock){+.+.}-{3:3}:
[   16.872106]        lock_acquire+0x6c/0x74
[   16.872117]        __mutex_lock+0xb4/0xa48
[   16.872132]        mutex_lock_nested+0x2c/0x34
[   16.872141]        phy_start+0x30/0xc4
[   16.872155]        ftgmac100_open+0x1a0/0x254
[   16.872168]        __dev_open+0x110/0x1d0
[   16.872180]        __dev_change_flags+0x1d0/0x258
[   16.872192]        dev_change_flags+0x28/0x58
[   16.872204]        do_setlink+0x258/0xc60
[   16.872212]        rtnl_setlink+0x110/0x18c
[   16.872219]        rtnetlink_rcv_msg+0x1d0/0x53c
[   16.872226]        netlink_rcv_skb+0xd0/0x128
[   16.872233]        rtnetlink_rcv+0x20/0x24
[   16.872244]        netlink_unicast+0x1a8/0x26c
[   16.872254]        netlink_sendmsg+0x220/0x464
[   16.872265]        __sys_sendto+0xe4/0x134
[   16.872276]        sys_sendto+0x24/0x2c
[   16.872288]        ret_fast_syscall+0x0/0x28
[   16.872297]        0x7ed9e928
[   16.872301]
[   16.872301] -> #0 (rtnl_mutex){+.+.}-{3:3}:
[   16.872325]        __lock_acquire+0x17e8/0x3268
[   16.872331]        lock_acquire.part.0+0xcc/0x394
[   16.872341]        lock_acquire+0x6c/0x74
[   16.872354]        __mutex_lock+0xb4/0xa48
[   16.872365]        mutex_lock_nested+0x2c/0x34
[   16.872377]        rtnl_lock+0x24/0x28
[   16.872389]        ftgmac100_adjust_link+0xc0/0x144
[   16.872401]        phy_link_change+0x38/0x64
[   16.872411]        phy_check_link_status+0xa8/0xfc
[   16.872422]        phy_state_machine+0x80/0x290
[   16.872435]        process_one_work+0x294/0x7d8
[   16.872447]        worker_thread+0x6c/0x548
[   16.872456]        kthread+0x170/0x178
[   16.872462]        ret_from_fork+0x14/0x20
[   16.872467]        0x0
[   16.872471]
[   16.872471] other info that might help us debug this:
[   16.872471]
[   16.872475]  Possible unsafe locking scenario:
[   16.872475]
[   16.872478]        CPU0                    CPU1
[   16.872482]        ----                    ----
[   16.872485]   lock(&dev->lock);
[   16.872495]                                lock(rtnl_mutex);
[   16.872505] lock(&dev->lock);
[   16.872513]   lock(rtnl_mutex);
[   16.872522]
[   16.872522]  *** DEADLOCK ***
[   16.872522]
[   16.872528] 3 locks held by kworker/1:1/23:
[   16.872532]  #0: 818472a8 
((wq_completion)events_power_efficient){+.+.}-{0:0}, at: 
process_one_work+0x1e8/0x7d8
[   16.872558]  #1: 819fbef8 
((work_completion)(&(&dev->state_queue)->work)){+.+.}-{0:0}, at: 
process_one_work+0x1e8/0x7d8
[   16.872582]  #2: 821d44c0 (&dev->lock){+.+.}-{3:3}, at: 
phy_state_machine+0x50/0x290

Any advice to get around of it?

Thanks,

Heyi

在 2022/2/20 上午2:28, Andrew Lunn 写道:
> On Sat, Feb 19, 2022 at 06:08:35PM +0800, Heyi Guo wrote:
>> Hi Andrew,
>>
>> The DHCP issue is gone after applying below patch. I put the lock statements
>> outside of the pure reset function, for the phydev lock has been acquired
>> before calling adjust_link. The lock order in ftgmac100_reset_task() was
>> also changed, to make it the same as the lock procedure in adjust_link, in
>> which the phydev is locked first and then rtnl_lock. I'm not quite sure
>> whether it will bring in any potential dead lock. Any advice?
> Did you run the code with CONFIG_PROVE_LOCKING enabled. That will help
> detect possible deadlock situations.
>
>         Andrew
