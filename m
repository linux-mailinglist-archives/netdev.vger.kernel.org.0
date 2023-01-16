Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1B66B4E8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjAPAL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjAPAL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:11:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A5114489;
        Sun, 15 Jan 2023 16:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lmkdEcOMa22/cNfyH6E4d0tkT2Pw8Zs3e69B0uPLP6g=; b=A8ci/1LDB9If56FC+FFbCnDmqe
        MszSvig0jtgkT0SVe37Xael1VlKS4KL0Y/lb0Ut87B040OVRgNmYFtdcYBsdTsZGj0v9cVfc2opIg
        2MX4IkfvDtrROiLO8UA97w0Ni8sph38Rd6nkwpzihONEmZ2XREfyZKKAD1e3Hmnt7Zr0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHD6F-002AA7-Ri; Mon, 16 Jan 2023 01:11:43 +0100
Date:   Mon, 16 Jan 2023 01:11:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.passaro@gmail.com>
Cc:     Lars-Peter Clausen <lars@metafoo.de>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com,
        pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8SWPwM7V8yj9s+v@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> IMHO, since the framework allows defining the reset GPIO, it does not sound
> reasonable to manage it only after checking if the PHY can communicate:
> if the reset is asserted, the PHY cannot communicate at all.
> This patch just ensures that, if the reset GPIO is defined, it's not asserted
> while checking the communication.

The problem is, you are only solving 1/4 of the problem. What about
the clock the PHY needs? And the regulator, and the linux reset
controller? And what order to do enable these, and how long do you
wait between each one?

And why are you solving this purely for Ethernet PHYs when the same
problem probably affects other sorts of devices which have reset
GPIOs, regulators and clocks? It looks like MMC/SDIO devices have a
similar problem.

https://lwn.net/Articles/867740/

As i said, i've not been following this work. Has it got anywhere? Can
ethernet PHYs use it?

	 Andrew

