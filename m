Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92638629785
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbiKOLdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238066AbiKOLcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:32:54 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A1F29345;
        Tue, 15 Nov 2022 03:32:02 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 1D5C31883F5E;
        Tue, 15 Nov 2022 11:32:00 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 1309425002DE;
        Tue, 15 Nov 2022 11:32:00 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 09E9B9EC0023; Tue, 15 Nov 2022 11:31:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 12:31:59 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <20221115111034.z5bggxqhdf7kbw64@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-15 12:10, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 11:52:40AM +0100, netdev@kapio-technology.com 
> wrote:
>> I had a discussion with Jacub, which resulted in me sending a mail to
>> maintainers on this. The problem is shown below...
>> 
>> the phy is marvell/6097/88e3082
>> 
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 332 at drivers/net/phy/phy.c:975
>> phy_error+0x28/0x54
>> Modules linked in:
>> CPU: 0 PID: 332 Comm: kworker/0:0 Tainted: G        W          6.0.0 
>> #17
>> Hardware name: Freescale i.MX27 (Device Tree Support)
>> Workqueue: events_power_efficient phy_state_machine
>>   unwind_backtrace from show_stack+0x18/0x1c
>>   show_stack from dump_stack_lvl+0x28/0x30
>>   dump_stack_lvl from __warn+0xb8/0x114
>>   __warn from warn_slowpath_fmt+0x80/0xbc
>>   warn_slowpath_fmt from phy_error+0x28/0x54
>>   phy_error from phy_state_machine+0xbc/0x218
>>   phy_state_machine from process_one_work+0x17c/0x244
>>   process_one_work from worker_thread+0x248/0x2cc
>>   worker_thread from kthread+0xb0/0xbc
>>   kthread from ret_from_fork+0x14/0x2c
>> Exception stack(0xc4a71fb0 to 0xc4a71ff8)
>> 1fa0:                                     00000000 00000000 00000000 
>> 00000000
>> 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
>> 00000000
>> 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> ---[ end trace 0000000000000000 ]---
> 
> Was that email public on the lists? I don't see it...

Sorry, yes the public list was not added.

> 
> The phy_error() is called from phy_state_machine() if one of
> phy_check_link_status() or phy_start_aneg() fails.
> 
> Could you please print exactly the value of "err", as well as dig 
> deeper
> to see which call is failing, all the way into the PHY driver?

It happens on upstart, so I would then have to hack the system upstart 
to add trace.

I also have:
mv88e6085 1002b000.ethernet-1:04: switch 0x990 detected: Marvell 
88E6097/88E6097F, revision 2
mv88e6085 1002b000.ethernet-1:04: configuring for fixed/rgmii-id link 
mode
mv88e6085 1002b000.ethernet-1:04: Link is Up - 100Mbps/Full - flow 
control off
mv88e6085 1002b000.ethernet-1:04 eth10 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:00] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth6 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:01] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth9 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:02] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth5 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:03] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth8 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:04] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth4 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:05] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth7 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:06] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth3 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:07] driver 
[Generic PHY] (irq=POLL)
mv88e6085 1002b000.ethernet-1:04 eth2 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:08] driver 
[Marvell 88E1112] (irq=174)
mv88e6085 1002b000.ethernet-1:04 eth1 (uninitialized): PHY 
[!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:09] driver 
[Marvell 88E1112] (irq=175)

after this and adding the ifaces to the bridge, it continues like:

br0: port 1(eth10) entered blocking state
br0: port 1(eth10) entered disabled state
br0: port 2(eth6) entered blocking state
br0: port 2(eth6) entered disabled state
device eth6 entered promiscuous mode
device eth10 entered promiscuous mode
br0: port 3(eth9) entered blocking state
br0: port 3(eth9) entered disabled state
device eth9 entered promiscuous mode
br0: port 4(eth5) entered blocking state
br0: port 4(eth5) entered disabled state
device eth5 entered promiscuous mode
br0: port 5(eth8) entered blocking state
br0: port 5(eth8) entered disabled state
device eth8 entered promiscuous mode
br0: port 6(eth4) entered blocking state
br0: port 6(eth4) entered disabled state
mv88e6085 1002b000.ethernet-1:04: Timeout while waiting for switch
mv88e6085 1002b000.ethernet-1:04: port 0 failed to add 9a:af:03:f1:bd:0a 
vid 1 to fdb: -110
device eth4 entered promiscuous mode
br0: port 7(eth7) entered blocking state
br0: port 7(eth7) entered disabled state

I don't know if that gives ay clues...?

Otherwise I have to take more time to see what I can dig out. The 
easiest for me is then to
add some printk statements giving targeted information if told what and 
where...

> 
> Easiest way to do that would probably be something like:
> 
> $ trace-cmd record -e mdio sleep 10 &
> ... do your stuff ...
> $ trace-cmd report
>     kworker/u4:3-337   [001]    59.054741: mdio_access:
> 0000:00:00.3 read  phy:0x13 reg:0x01 val:0x7949
>     kworker/u4:3-337   [001]    59.054941: mdio_access:
> 0000:00:00.3 read  phy:0x13 reg:0x09 val:0x0700
>     kworker/u4:3-337   [001]    59.055262: mdio_access:
> 0000:00:00.3 read  phy:0x13 reg:0x0a val:0x4000
>     kworker/u4:3-337   [001]    60.075808: mdio_access:
> 0000:00:00.3 read  phy:0x13 reg:0x1c val:0x3005
> 
> "val" will be negative when there is an error. This is to see quicker
> what fails,
> and if some MDIO access ever works.
> 
> If you don't want to enable CONFIG_FTRACE or install trace-cmd, you
> could also probably do the debugging manually.
