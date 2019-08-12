Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFB89FED
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfHLNmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:42:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfHLNmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 09:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wP9/YhXhhTrXAtgu2t1aKCPym9xbq8KIIf/zHdGPK5E=; b=1yNlF2YCqlhKPeveeY1yI71Tch
        HTJJszODy46EedfOZi1YHn89fckPZlgYMhtvY2Ya8oc9y28t6iNFo0SnWDYNymnsARTOS+SttbGYz
        5LLEd/NeVNiAdOs9doTVP3ylkLU/H0SBZXmi4b0X1bB8m8IOxrmFkRkGzWui3DiHwmM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxAax-0000QJ-MX; Mon, 12 Aug 2019 15:42:43 +0200
Date:   Mon, 12 Aug 2019 15:42:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] access to null-pointer in dsa_switch_event when bridge set
 up
Message-ID: <20190812134243.GK14290@lunn.ch>
References: <trinity-99bcd71d-8f78-4bbe-a439-f6a915040b0a-1565606589515@3c-app-gmx-bs80>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-99bcd71d-8f78-4bbe-a439-f6a915040b0a-1565606589515@3c-app-gmx-bs80>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, Aug 12, 2019 at 12:43:09PM +0200, Frank Wunderlich wrote:
> Hi,
> 
> i've noticed a bug when using bridge on dsa-ports. Tested on Bpi-r2, Crash happens on 5.3-rc1 and rc4, 5.2-rc7 (last version pre 5.3 i have found on my tftp) is not affected.

Hi Frank

A patch was merged last night with a fix for dsa_port_mdb_add. The
call stack looks the same. So i think this is fixed.

     Andrew

 
> [  115.038406] [<c09f28c0>] (dsa_switch_event) from [<c014d4f8>] (notifier_call_chain+0x58/0x94)
> [  115.046940]  r10:00000000 r9:c09f1dd0 r8:00000000 r7:00000005 r6:e71edd54 r5:00000000
> [  115.054771]  r4:ffffffff
> [  115.057308] [<c014d4a0>] (notifier_call_chain) from [<c014d658>] (raw_notifier_call_chain+0x28/0x30)
> [  115.066447]  r9:c09f1dd0 r8:c09f0740 r7:e71fd800 r6:00000000 r5:c1104c48 r4:c1104c48
> [  115.074197] [<c014d630>] (raw_notifier_call_chain) from [<c09efe1c>] (dsa_port_mdb_add+0x58/0x84)
> [  115.083078] [<c09efdc4>] (dsa_port_mdb_add) from [<c09f1e2c>] (dsa_slave_port_obj_add+0x5c/0x78)
> [  115.091866]  r4:e71ede38
> [  115.094403] [<c09f1dd0>] (dsa_slave_port_obj_add) from [<c0b47cc4>] (__switchdev_handle_port_obj_add+0x64/0xe4)
> [  115.104499] [<c0b47c60>] (__switchdev_handle_port_obj_add) from [<c0b47d5c>] (switchdev_handle_port_obj_add+0x18/0x24)
> [  115.115201]  r10:00000000 r9:00000000 r8:00000000 r7:00000006 r6:e71ede38 r5:00000000
> [  115.123032]  r4:ffffffff
> [  115.125570] [<c0b47d44>] (switchdev_handle_port_obj_add) from [<c09f1c58>] (dsa_slave_switchdev_blocking_event+0x50/0xb0)
> [  115.136535] [<c09f1c08>] (dsa_slave_switchdev_blocking_event) from [<c014d4f8>] (notifier_call_chain+0x58/0x94)
> [  115.146632] [<c014d4a0>] (notifier_call_chain) from [<c014dd70>] (blocking_notifier_call_chain+0x54/0x6c)
> [  115.156206]  r9:00000000 r8:e6932dd0 r7:e71fd800 r6:e71ede38 r5:c11bc820 r4:00000006
> [  115.163956] [<c014dd1c>] (blocking_notifier_call_chain) from [<c0b479ec>] (switchdev_port_obj_notify+0x54/0xb8)
> [  115.174049]  r6:00000000 r5:1021bd52 r4:c1104c48
> [  115.178670] [<c0b47998>] (switchdev_port_obj_notify) from [<c0b47af4>] (switchdev_port_obj_add_now+0xa4/0x118)
> [  115.188675]  r5:e71ede73 r4:c1104c48
> [  115.192254] [<c0b47a50>] (switchdev_port_obj_add_now) from [<c0b47b8c>] (switchdev_port_obj_add_deferred+0x24/0x70)
> [  115.202698]  r9:c11c50f0 r8:00000000 r7:00000100 r6:e71fd800 r5:e6932dd0 r4:e6932dc0
> [  115.210450] [<c0b47b68>] (switchdev_port_obj_add_deferred) from [<c0b477e0>] (switchdev_deferred_process+0x84/0x118)
> [  115.220978]  r7:00000100 r6:c12332ac r5:c11bc818 r4:e6932dc0
> [  115.226643] [<c0b4775c>] (switchdev_deferred_process) from [<c0b47890>] (switchdev_deferred_process_work+0x1c/0x24)
> [  115.237085]  r7:ead92200 r6:ead8f100 r5:e909f380 r4:c11bc83c
> [  115.242751] [<c0b47874>] (switchdev_deferred_process_work) from [<c0144dac>] (process_one_work+0x1ac/0x4bc)
> [  115.252499] [<c0144c00>] (process_one_work) from [<c0145b8c>] (worker_thread+0x5c/0x580)
> [  115.260597]  r10:c1103d00 r9:00000008 r8:ffffe000 r7:ead8f118 r6:e909f394 r5:ead8f100
> [  115.268427]  r4:e909f380
> [  115.270965] [<c0145b30>] (worker_thread) from [<c014ba18>] (kthread+0x168/0x170)
> [  115.278368]  r10:ea13fe74 r9:c0145b30 r8:e909f380 r7:e71ec000 r6:00000000 r5:e910bf00
> [  115.286199]  r4:e910bf40
> [  115.288737] [<c014b8b0>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
> [  115.295961] Exception stack(0xe71edfb0 to 0xe71edff8)
> [  115.301014] dfa0:                                     00000000 00000000 00000000 00000000
> [  115.309197] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  115.317379] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  115.323997]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c014b8b0
> [  115.331827]  r4:e910bf00
> [  115.334363] Code: bad PC value
> [  115.337583] ---[ end trace 3bdbb989816b27f4 ]---
> 
> regards Frank
> 
