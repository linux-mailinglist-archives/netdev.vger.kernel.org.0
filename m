Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530F34D9C36
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348659AbiCON35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiCON3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:29:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0BD45AF7
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WPW7uB8yWsgRGB6K8duwkRWMUBGfAkjc8UcTk7yc1Hs=; b=TXVfhLDq+26VRIlJjLh1caOiSu
        UM5O0B7f3kW2Q3KGQYnZjt10dX3+uVSXUGGPRZSLbfDTdDqm9nlZeInI/yKSUVsPbUGk8TYXdPTpN
        cEkOTWpjbJxYvCUUHUSO9OZk06Q6x9i9uO30zSq2PF4QXXrF/yUkILq257LpOjSoR6rQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nU7E0-00AxoY-TB; Tue, 15 Mar 2022 14:28:32 +0100
Date:   Tue, 15 Mar 2022 14:28:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <YjCUgCNHw6BUqJxr@lunn.ch>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315113841.GA22337@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > It was linked to unregistered/freed
> > > netdev. This is why my patch changing the order to call phy_disconnect()
> > > first and then unregister_netdev().
> > 
> > Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
> > 
> >   usbnet_disconnect()
> >     unregister_netdev()
> >     ax88772_unbind()
> >       phy_disconnect()
> >     free_netdev()
> > 
> > Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> > net_device?

There are drivers which unregistering and then calling
phy_disconnect. In general that should be a valid pattern. But more
MAC drivers actually connect the PHY on open and disconnect it on
close. So it is less well used.

> > Oleksij, the commit message of 2c9d6c2b871d says that disconnecting the
> > PHY "fails" in that situation.  Please elaborate what the failure looked
> > like.  Did you get a stacktrace?
> 
> [   15.459655] asix 2-1.2:1.0 eth1: Link is Up - 100Mbps/Full - flow control off
> [   30.600242] usb 2-1.2: USB disconnect, device number 3
> [   30.611962] asix 2-1.2:1.0 eth1: unregister 'asix' usb-ci_hdrc.1-1.2, ASIX AX88772B USB 2.0 Ethernet
> [   30.649173] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
> [   30.657027] asix 2-1.2:1.0 eth1 (unregistered): Failed to write Medium Mode mode to 0x0000: ffffffed
> [   30.683006] asix 2-1.2:1.0 eth1 (unregistered): Link is Down
> [   30.689512] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
> [   30.697359] asix 2-1.2:1.0 eth1 (unregistered): Failed to enable software MII access
> [   30.706009] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
> [   30.714277] asix 2-1.2:1.0 eth1 (unregistered): Failed to enable software MII access
> [   30.732689] 8<--- cut here ---
> [   30.735757] Unable to handle kernel paging request at virtual address 2e839000
> [   30.996114] [<c08637f4>] (linkwatch_do_dev) from [<c0863a48>] (__linkwatch_run_queue+0xe0/0x1f0)
> [   31.004917] [<c0863a48>] (__linkwatch_run_queue) from [<c0863b8c>] (linkwatch_event+0x34/0x3c)
> [   31.013540] [<c0863b8c>] (linkwatch_event) from [<c0155550>] (process_one_work+0x20c/0x5d0)
> [   31.021911] [<c0155550>] (process_one_work) from [<c0155dc0>] (worker_thread+0x64/0x570)
> [   31.030010] [<c0155dc0>] (worker_thread) from [<c015bacc>] (kthread+0x178/0x190)
> [   31.037421] [<c015bacc>] (kthread) from [<c0100150>] (ret_from_fork+0x14/0x24)

This is not directly PHY related, although it could be indirect. This
is to do with sending notifications after the link changed etc. It is
async, so i wounder if by the time it runs the netdev has been freed?
That would indicate some sort of bug, missing lock etc.

     Andrew
