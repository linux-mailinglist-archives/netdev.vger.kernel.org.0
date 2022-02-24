Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD444C21E6
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiBXCxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 21:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiBXCxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 21:53:23 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C661662C0;
        Wed, 23 Feb 2022 18:52:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5LiApd_1645671168;
Received: from 30.225.140.83(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5LiApd_1645671168)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 10:52:49 +0800
Message-ID: <c378a57f-cb21-eb86-0290-0c08fa748f10@linux.alibaba.com>
Date:   Thu, 24 Feb 2022 10:52:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
 <1675a52d-a270-d768-5ccc-35b1e82e56d2@gmail.com>
 <5cdf5d09-9b32-ec98-cbd1-c05365ec01fa@linux.alibaba.com>
 <91e2d4ad-7544-784b-defe-3a76577462f1@gmail.com>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <91e2d4ad-7544-784b-defe-3a76577462f1@gmail.com>
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

Hi Florian,

在 2022/2/24 上午1:55, Florian Fainelli 写道:
>
>
> On 2/23/2022 3:39 AM, Heyi Guo wrote:
>> Hi Florian,
>>
>> 在 2022/2/23 下午1:00, Florian Fainelli 写道:
>>>
>>>
>>> On 2/22/2022 7:14 PM, Heyi Guo wrote:
>>>> DHCP failures were observed with systemd 247.6. The issue could be
>>>> reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
>>>> down/up.
>>>>
>>>> It is caused by below procedures in the driver:
>>>>
>>>> 1. ftgmac100_open() enables net interface and call phy_start()
>>>> 2. When PHY is link up, it calls netif_carrier_on() and then
>>>> adjust_link callback
>>>> 3. ftgmac100_adjust_link() will schedule the reset task
>>>> 4. ftgmac100_reset_task() will then reset the MAC in another schedule
>>>>
>>>> After step 2, systemd will be notified to send DHCP discover packet,
>>>> while the packet might be corrupted by MAC reset operation in step 4.
>>>>
>>>> Call ftgmac100_reset() directly instead of scheduling task to fix the
>>>> issue.
>>>>
>>>> Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
>>>> ---
>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>> Cc: Joel Stanley <joel@jms.id.au>
>>>> Cc: Guangbin Huang <huangguangbin2@huawei.com>
>>>> Cc: Hao Chen <chenhao288@hisilicon.com>
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Dylan Hung <dylan_hung@aspeedtech.com>
>>>> Cc: netdev@vger.kernel.org
>>>>
>>>>
>>>> ---
>>>>   drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
>>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
>>>> b/drivers/net/ethernet/faraday/ftgmac100.c
>>>> index c1deb6e5d26c5..d5356db7539a4 100644
>>>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>>>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>>>> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct 
>>>> net_device *netdev)
>>>>       /* Disable all interrupts */
>>>>       iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>>>>   -    /* Reset the adapter asynchronously */
>>>> -    schedule_work(&priv->reset_task);
>>>> +    /* Release phy lock to allow ftgmac100_reset to aquire it, 
>>>> keeping lock
>>>
>>> typo: acquire
>>>
>> Thanks for the catch :)
>>>> +     * order consistent to prevent dead lock.
>>>> +     */
>>>> +    if (netdev->phydev)
>>>> +        mutex_unlock(&netdev->phydev->lock);
>>>> +
>>>> +    ftgmac100_reset(priv);
>>>> +
>>>> +    if (netdev->phydev)
>>>> +        mutex_lock(&netdev->phydev->lock);
>>>
>>> Do you really need to perform a full MAC reset whenever the link 
>>> goes up or down? Instead cannot you just extract the maccr 
>>> configuration which adjusts the speed and be done with it?
>>
>> This is the original behavior and not changed in this patch set, and 
>> I'm not familiar with the hardware design of ftgmac100, so I'd like 
>> to limit the changes to the code which really causes practical issues.
>
> This unlocking and re-locking seems superfluous when you could 
> introduce a version of ftgmac100_reset() which does not acquire the 
> PHY device mutex, and have that version called from 
> ftgmac100_adjust_link(). For every other call site, you would acquire 
> it. Something like this for instance:
>
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index 691605c15265..98179c3fd9ee 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1038,7 +1038,7 @@ static void ftgmac100_adjust_link(struct 
> net_device *netdev)
>         iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>
>         /* Reset the adapter asynchronously */
> -       schedule_work(&priv->reset_task);
> +       ftgmac100_reset(priv, false);
>  }
>
>  static int ftgmac100_mii_probe(struct net_device *netdev)
> @@ -1410,10 +1410,8 @@ static int ftgmac100_init_all(struct ftgmac100 
> *priv, bool ignore_alloc_err)
>         return err;
>  }
>
> -static void ftgmac100_reset_task(struct work_struct *work)
> +static void ftgmac100_reset_task(struct ftgmac100_priv *priv, bool 
> lock_phy)
>  {
> -       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
> -                                             reset_task);
>         struct net_device *netdev = priv->netdev;
>         int err;
>
> @@ -1421,7 +1419,7 @@ static void ftgmac100_reset_task(struct 
> work_struct *work)
>
>         /* Lock the world */
>         rtnl_lock();
> -       if (netdev->phydev)
> +       if (netdev->phydev && lock_phy)
>                 mutex_lock(&netdev->phydev->lock);
>         if (priv->mii_bus)
>                 mutex_lock(&priv->mii_bus->mdio_lock);
> @@ -1454,11 +1452,19 @@ static void ftgmac100_reset_task(struct 
> work_struct *work)
>   bail:
>         if (priv->mii_bus)
>                 mutex_unlock(&priv->mii_bus->mdio_lock);
> -       if (netdev->phydev)
> +       if (netdev->phydev && lock_phy)
>                 mutex_unlock(&netdev->phydev->lock);
>         rtnl_unlock();
>  }

This is also what we supposed to do at first, however it will introduce 
a potential dead lock for different locks acquiring order, and 
CONFIG_PROVE_LOCKING will complain about it:

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

Thanks,

Heyi

>
> +static void ftgmac100_reset_task(struct work_struct *work)
> +{
> +       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
> +                                             reset_task);
> +
> +       ftgmac100_reset(priv, true);
> +}
> +
>  static int ftgmac100_open(struct net_device *netdev)
>  {
>         struct ftgmac100 *priv = netdev_priv(netdev)
