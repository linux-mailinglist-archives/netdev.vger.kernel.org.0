Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FCBC89B
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395349AbfIXNKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:10:46 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:44390 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390444AbfIXNKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 09:10:46 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 7BD2BA3A41;
        Tue, 24 Sep 2019 15:10:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569330644;
        bh=nqNKUFXSPDD01SG2a6aTBTsCVa8D14eHdZvnjI1JW0o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nzxGROPQJz6gTVGFcy26B5yGMaZZoFkH1QBmnVB6NttY7J32XwZuI9dSx51+ApmOy
         SJpqdQl2LKt+RUqr1OFVItxpMn5MZ/JJ3eQVyH+asZp+MstGeJaes7JKbDdofw3Aeo
         idxQ2/124D6i4mYh7XZRKAXWOOe98kzWKEmgqhSI=
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
 <20190924123126.GE14477@lunn.ch>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
Date:   Tue, 24 Sep 2019 15:10:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924123126.GE14477@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24. 09. 19 14:31, Andrew Lunn wrote:
> On Tue, Sep 24, 2019 at 01:27:24PM +0200, Michal Vokáč wrote:
>> Hi,
>>
>> just tried booting latest next-20190920 on our imx6dl-yapp4-hydra platform
>> with QCA8334 switch and got this:
>>
>> [    7.424620] [<806840e0>] (phy_support_asym_pause) from [<80686724>] (qca8k_port_enable+0x40/0x48)
>> [    7.436911] [<806866e4>] (qca8k_port_enable) from [<80a74134>] (dsa_port_enable+0x3c/0x6c)
>> [    7.448629]  r7:00000000 r6:e88a02cc r5:e812d090 r4:e812d090
>> [    7.457708] [<80a740f8>] (dsa_port_enable) from [<80a730bc>] (dsa_register_switch+0x798/0xacc)
>> [    7.469833]  r5:e812d0cc r4:e812d090
> 
> Hi Michal
> 
> Please could you add a printk to verify it is the CPU port, and that
> in qca8k_port_enable() phy is a NULL pointer.
> 
> I think the fix is going to look something like:
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 16f15c93a102..86c80a873e30 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -939,7 +939,8 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
>          qca8k_port_set_status(priv, port, 1);
>          priv->port_sts[port].enabled = 1;

  	dev_info(priv->dev, "port: %d, phy: %d", port, (u32)phy);

>   
> -       phy_support_asym_pause(phy);
> +       if (phy)
> +               phy_support_asym_pause(phy);
>   
>          return 0;
>   }
> 

I added the printk and the above fix and can confirm that it is the CPU
port and the phy is NULL pointer:

[    6.976366] qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
[    6.992021] qca8k 2188000.ethernet-1:0a: port: 0, phy: 0
[    7.001323] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
[    7.014221] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
[    7.030598] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]
[    7.043500] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
[    7.063335] DSA: tree 0 setup

Now the device boots but there is a problem with the CPU port configuration:

root@hydraco:~# ifconfig eth0 up
[  255.256047] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
[  255.272449] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
[  255.286539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@hydraco:~# ifconfig eth1 up
[  268.350078] qca8k 2188000.ethernet-1:0a: port: 3, phy: -393143296
[  268.364442] qca8k 2188000.ethernet-1:0a eth1: configuring for phy/ link mode
[  268.375400] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//Unknown/Unknown adv=00,00000000,000062ef pause=10 link=0 an=1
[  268.393901] qca8k 2188000.ethernet-1:0a eth1: phy link up /1Gbps/Full
[  268.404849] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//1Gbps/Full adv=00,00000000,00000000 pause=0e link=1 an=0
[  268.420740] qca8k 2188000.ethernet-1:0a eth1: Link is Up - 1Gbps/Full - flow control rx/tx
[  268.432995] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
root@hydraco:~# udhcpc -i eth1
udhcpc (v1.23.2) started
Sending discover...
Sending discover...
Sending discover...

On v5.3.1 it works OK:

root@hydraco:~# ifconfig eth0 up
[   29.665997] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
[   29.682075] Generic PHY fixed-0:00: PHY advertising (00,00000200,000022e0) more modes than genphy supports, some modes not advertised.
[   29.698284] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
[   29.709568] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@hydraco:~# ifconfig eth1 up
[   33.699923] qca8k 2188000.ethernet-1:0a eth1: configuring for phy/ link mode
[   33.714466] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//Unknown/Unknown adv=00,00000000,000062ef pause=10 link=0 an=1
[   33.735356] 8021q: adding VLAN 0 to HW filter on device eth1
[   33.755671] qca8k 2188000.ethernet-1:0a eth1: phy link up /1Gbps/Full
[   33.766071] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//1Gbps/Full adv=00,00000000,00000000 pause=0e link=1 an=0
[   33.781987] qca8k 2188000.ethernet-1:0a eth1: Link is Up - 1Gbps/Full - flow control rx/tx
[   33.794290] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
oot@hydraco:~# udhcpc -i eth1
udhcpc (v1.23.2) started
Sending discover...
Sending select for 10.1.8.103...

> But i want to take a closer look at what priv->port_sts[port].enabled
> = 1; does. Also, if there are any other port_enable() functions which
> always assume a valid phy device.

Anything else I can do to help with this?

Thank you!
Michal
