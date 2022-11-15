Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8ED629666
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiKOKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKOKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:54:07 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ADD26557;
        Tue, 15 Nov 2022 02:52:41 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 76E4618842EC;
        Tue, 15 Nov 2022 10:52:40 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6D2FE250030B;
        Tue, 15 Nov 2022 10:52:40 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 668EB9EC0022; Tue, 15 Nov 2022 10:52:40 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 11:52:40 +0100
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
In-Reply-To: <20221115102833.ahwnahrqstcs2eug@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
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

On 2022-11-15 11:28, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 11:26:55AM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2022-11-15 10:30, Ido Schimmel wrote:
>> > On Sat, Nov 12, 2022 at 09:37:46PM +0100, Hans J. Schultz wrote:
>> > > This patchset adds MAB [1] offload support in mv88e6xxx.
>> > >
>> > > Patch #1: Fix a problem when reading the FID needed to get the VID.
>> > >
>> > > Patch #2: The MAB implementation for mv88e6xxx.
>> >
>> > Just to be sure, this was tested with bridge_locked_port.sh, right?
>> 
>> As I have the phy regression I have given notice of, that has simply 
>> not
>> been possible. After maybe 50 resets it worked for me at a point
>> (something to do with timing), and I tested it manually.
>> 
>> When I have tried to run the selftests, I get errors related to the 
>> phy
>> problem, which I have not been able to find a way around.
> 
> What PHY regression?

I had a discussion with Jacub, which resulted in me sending a mail to
maintainers on this. The problem is shown below...


the phy is marvell/6097/88e3082

------------[ cut here ]------------
WARNING: CPU: 0 PID: 332 at drivers/net/phy/phy.c:975
phy_error+0x28/0x54
Modules linked in:
CPU: 0 PID: 332 Comm: kworker/0:0 Tainted: G        W          6.0.0 #17
Hardware name: Freescale i.MX27 (Device Tree Support)
Workqueue: events_power_efficient phy_state_machine
   unwind_backtrace from show_stack+0x18/0x1c
   show_stack from dump_stack_lvl+0x28/0x30
   dump_stack_lvl from __warn+0xb8/0x114
   __warn from warn_slowpath_fmt+0x80/0xbc
   warn_slowpath_fmt from phy_error+0x28/0x54
   phy_error from phy_state_machine+0xbc/0x218
   phy_state_machine from process_one_work+0x17c/0x244
   process_one_work from worker_thread+0x248/0x2cc
   worker_thread from kthread+0xb0/0xbc
   kthread from ret_from_fork+0x14/0x2c
Exception stack(0xc4a71fb0 to 0xc4a71ff8)
1fa0:                                     00000000 00000000 00000000
00000000
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000
1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 0000000000000000 ]---
