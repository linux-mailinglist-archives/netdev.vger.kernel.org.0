Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79332BED15
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfIZILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:11:39 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:50638 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfIZILi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:11:38 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id D04F3A0849;
        Thu, 26 Sep 2019 10:11:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569485494;
        bh=nNvySICo5PhC5zoldvHhn+0/g43tvY699g3oSwo2wao=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=qWYpy/f1l1I0xfGD7vrLCOHc326iMFXRxlKyC+M1hIhcXs/r2KjGTkwq4DW76TjDg
         ULRYti/zJhDJN4CA+Y9rAaq+3qZ6WUk6HuWPQX4V0jKnRtgQhRINtBKnXzsLL3BAC/
         0iANmFUrVCvARbYz57BuElabhGfY2/pr1eLhfC6w=
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
 <20190924123126.GE14477@lunn.ch>
 <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
Message-ID: <385ff818-b852-b542-fc64-f4b884060f71@ysoft.com>
Date:   Thu, 26 Sep 2019 10:11:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24. 09. 19 15:10, Michal Vokáč wrote:
> On 24. 09. 19 14:31, Andrew Lunn wrote:
>> On Tue, Sep 24, 2019 at 01:27:24PM +0200, Michal Vokáč wrote:
>>> Hi,
>>>
>>> just tried booting latest next-20190920 on our imx6dl-yapp4-hydra platform
>>> with QCA8334 switch and got this:
>>>
>>> [    7.424620] [<806840e0>] (phy_support_asym_pause) from [<80686724>] (qca8k_port_enable+0x40/0x48)
>>> [    7.436911] [<806866e4>] (qca8k_port_enable) from [<80a74134>] (dsa_port_enable+0x3c/0x6c)
>>> [    7.448629]  r7:00000000 r6:e88a02cc r5:e812d090 r4:e812d090
>>> [    7.457708] [<80a740f8>] (dsa_port_enable) from [<80a730bc>] (dsa_register_switch+0x798/0xacc)
>>> [    7.469833]  r5:e812d0cc r4:e812d090
>>
>> Hi Michal
>>
>> Please could you add a printk to verify it is the CPU port, and that
>> in qca8k_port_enable() phy is a NULL pointer.
>>
>> I think the fix is going to look something like:
>>
>> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
>> index 16f15c93a102..86c80a873e30 100644
>> --- a/drivers/net/dsa/qca8k.c
>> +++ b/drivers/net/dsa/qca8k.c
>> @@ -939,7 +939,8 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
>>          qca8k_port_set_status(priv, port, 1);
>>          priv->port_sts[port].enabled = 1;
> 
>       dev_info(priv->dev, "port: %d, phy: %d", port, (u32)phy);
> 
>> -       phy_support_asym_pause(phy);
>> +       if (phy)
>> +               phy_support_asym_pause(phy);
>>          return 0;
>>   }
>>
> 
> I added the printk and the above fix and can confirm that it is the CPU
> port and the phy is NULL pointer:
> 
> [    6.976366] qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
> [    6.992021] qca8k 2188000.ethernet-1:0a: port: 0, phy: 0
> [    7.001323] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
> [    7.014221] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
> [    7.030598] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]
> [    7.043500] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
> [    7.063335] DSA: tree 0 setup
> 
> Now the device boots but there is a problem with the CPU port configuration:
> 
> root@hydraco:~# ifconfig eth0 up
> [  255.256047] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
> [  255.272449] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> [  255.286539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> root@hydraco:~# ifconfig eth1 up
> [  268.350078] qca8k 2188000.ethernet-1:0a: port: 3, phy: -393143296
> [  268.364442] qca8k 2188000.ethernet-1:0a eth1: configuring for phy/ link mode
> [  268.375400] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//Unknown/Unknown adv=00,00000000,000062ef pause=10 link=0 an=1
> [  268.393901] qca8k 2188000.ethernet-1:0a eth1: phy link up /1Gbps/Full
> [  268.404849] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//1Gbps/Full adv=00,00000000,00000000 pause=0e link=1 an=0
> [  268.420740] qca8k 2188000.ethernet-1:0a eth1: Link is Up - 1Gbps/Full - flow control rx/tx
> [  268.432995] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> root@hydraco:~# udhcpc -i eth1
> udhcpc (v1.23.2) started
> Sending discover...
> Sending discover...
> Sending discover...

I found and fixed the problem with CPU and USER ports not working.

The issue was in the fact that the qca8k driver incorrectly allocates
the dsa_switch structure with DSA_MAX_PORTS (which is 12) but the QCA8K
switches support up 7 ports.

So the dsa_tree_setup_switches() looped with num_ports set to 12.
Since commit [1] disables all unused ports, ports 7-11 were disabled.
What happened is that some registers were incorrectly rewritten by
the qca8k_port_disable() calls.

I will submit a patch very soon.

Thank you,
Michal

[1] 0394a63acfe2 ("net: dsa: enable and disable all ports")
