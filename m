Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1554CB2FB
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 00:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiCBXvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 18:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiCBXvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 18:51:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942DE64CE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 15:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bWjsF7uNB7MJczwOXQEwDgCwb5vkngDHRyGGCne/Kvo=; b=yvyMer/7SgWaji20XjefDMoDoz
        6pZ9Ka5ay/CrU7KHjH7jcrb4LHn6XV6gmphDRG0vC/eC31jeCKBpyrKnM4ZZt2wL3CYjWskrvTk+A
        0D9q/1W9bxlwkKHYUy1InyoFhjgXrdPolMnDWyOtRJr9cqHDvJgL0Xm4Y+zMP78GQGZ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPYjY-008zoD-HR; Thu, 03 Mar 2022 00:50:16 +0100
Date:   Thu, 3 Mar 2022 00:50:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Subject: Re: smsc95xx warning after a 'reboot' command
Message-ID: <YiACuNTd9lzN6Wym@lunn.ch>
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
 <Yh/r5hkui6MrV4W6@lunn.ch>
 <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> > So it looks like the PHY state machine has not been told to stop using
> > the PHY. That suggests smsc95xx_disconnect_phy() has not been
> > called. Could you confirm this by putting a printk() in there.
> 
> I added a printk (*********** smsc95xx_disconnect_phy())
> and confirmed that smsc95xx_disconnect_phy() is being called.
> 
> Please see the log below, thanks.
> 
> [   22.140598] ci_hdrc ci_hdrc.1: remove, state 1
> [   22.145077] usb usb2: USB disconnect, device number 1
> [   22.146674] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   22.150146] usb 2-1: USB disconnect, device number 2
> [   22.157275] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> [   22.162237] usb 2-1.1: USB disconnect, device number 3
> [   22.167986] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> [   22.174690] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
> usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
> [   22.179732] ------------[ cut here ]------------
> [   22.193687] WARNING: CPU: 1 PID: 114 at drivers/net/phy/phy.c:958
> phy_error+0x14/0x60
> [   22.201514] Modules linked in:
> [   22.204577] CPU: 1 PID: 114 Comm: kworker/u8:2 Not tainted
> 5.10.102-00042-ga4a140612082-dirty #29
> [   22.213447] Hardware name: CompuLab i.MX8MM IoT Gateway (DT)
> [   22.219112] Workqueue: events_power_efficient phy_state_machine
> [   22.225036] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> [   22.231043] pc : phy_error+0x14/0x60
> [   22.234620] lr : phy_state_machine+0x88/0x218
> [   22.238975] sp : ffff800011733d20
> [   22.242289] x29: ffff800011733d20 x28: ffff800011217000
> [   22.247608] x27: ffff000000008070 x26: ffff000000008020
> [   22.252924] x25: 0000000000000000 x24: 00000000ffffffed
> [   22.258240] x23: ffff00000edb8ce8 x22: ffff000002165580
> [   22.263558] x21: ffff00000edb8800 x20: 0000000000000005
> [   22.268875] x19: ffff00000edb8800 x18: 0000000000000010
> [   22.274193] x17: 0000000000000000 x16: 0000000000000000
> [   22.279509] x15: ffff0000021659f8 x14: 00000000000000dd
> [   22.284825] x13: 0000000000000001 x12: 0000000000000000
> [   22.290140] x11: 0000000000000000 x10: 00000000000009d0
> [   22.295456] x9 : ffff8000117338a0 x8 : ffff000002165fb0
> [   22.300772] x7 : ffff00007fb8d680 x6 : 000000000000000e
> [   22.306088] x5 : 00000000410fd030 x4 : 0000000000000000
> [   22.311406] x3 : ffff00000edb8ce8 x2 : 0000000000000000
> [   22.316723] x1 : ffff000002165580 x0 : ffff00000edb8800
> [   22.322039] Call trace:
> [   22.324490]  phy_error+0x14/0x60
> [   22.327722]  phy_state_machine+0x88/0x218
> [   22.331736]  process_one_work+0x1bc/0x338
> [   22.335747]  worker_thread+0x50/0x420
> [   22.339411]  kthread+0x140/0x160
> [   22.342642]  ret_from_fork+0x10/0x34
> [   22.346219] ---[ end trace 25b1972853f1f1f8 ]---
> [   22.350892] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> [   22.350975] *********** smsc95xx_disconnect_phy()

If i'm reading this correctly, this is way to late, the device has
already gone. The PHY needs to be stopped while the device is still
connected to the USB bus.

I could understand a trace like this with a hot unplug, but not with a
reboot. I would expect things to be shut down starting from the leaves
of the USB tree, so the smsc95xx should have a chance to perform a
controlled shutdown before the device is removed.

This code got reworked recently. smsc95xx_disconnect_phy() has been
removed, and the phy is now disconnected in smsc95xx_unbind(). Do you
get the same stack trace with 5.17-rc? Or is it a different stack
trace?

	Andrew

