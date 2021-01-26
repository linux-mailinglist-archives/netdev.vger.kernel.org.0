Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3B303F58
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405514AbhAZNxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405322AbhAZNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:50:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2121DC0611C2;
        Tue, 26 Jan 2021 05:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J5ZqF3ROoAZvc79uZMB4KxJkDo/pwToOQ5rY1t//3ZM=; b=KZChSPk+5hypw/XJh9A75gVhv
        JDD6HhjfEwWfJ+zoV2ECb2EymAIkJ9h4MarIq8lf/u5o8Bj6n7pJ6LKaX/jQMYmC7WzRyf65ZwxTv
        wzs3KBDTDsE54WsaJ14tbbJ65G2Leh0i4DGXXY0MFGlpWyAhgH32owmUzfbxEfiYg0awvCPhbv1cN
        uVCEGtVHmJbb9Qi5kDbtzTJCNLbQLg8TLwejyJbTscSQ61H5nXLy95K6qMPzoE+tnNioCmB3oo9/K
        whzN7Fkio789ZBSbVnVmg/cZd06vt+AwujSxEGBxpzy3mN0evJNDlxIw++8JaYfjW9YhcIWwI+kws
        XNsOU3yvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52974)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l4Oix-0004Ud-Ly; Tue, 26 Jan 2021 13:49:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l4Oiw-0003qo-3H; Tue, 26 Jan 2021 13:49:38 +0000
Date:   Tue, 26 Jan 2021 13:49:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mike Looijmans <mike.looijmans@topic.nl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <20210126134937.GI1551@shell.armlinux.org.uk>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBAVwFlLsfVEHd+E@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 02:14:40PM +0100, Andrew Lunn wrote:
> On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
> > The mdio_bus reset code first de-asserted the reset by allocating with
> > GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
> > the reset signal defaulted to asserted, there'd be a short "spike"
> > before the reset.
> > 
> > Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
> > removes the spike and also removes a line of code since the signal
> > is already high.
> 
> Hi Mike
> 
> This however appears to remove the reset pulse, if the reset line was
> already low to start with. Notice you left
> 
> fsleep(bus->reset_delay_us);
> 
> without any action before it? What are we now waiting for?  Most data
> sheets talk of a reset pulse. Take the reset line high, wait for some
> time, take the reset low, wait for some time, and then start talking
> to the PHY. I think with this patch, we have lost the guarantee of a
> low to high transition.
> 
> Is this spike, followed by a pulse actually causing you problems? If
> so, i would actually suggest adding another delay, to stretch the
> spike. We have no control over the initial state of the reset line, it
> is how the bootloader left it, we have to handle both states.

Andrew, I don't get what you're saying.

Here is what happens depending on the pre-existing state of the
reset signal:

Reset (previously asserted):   ~~~|_|~~~~|_______
Reset (previously deasserted): _____|~~~~|_______
                                  ^ ^    ^
                                  A B    C

At point A, the low going transition is because the reset line is
requested using GPIOD_OUT_LOW. If the line is successfully requested,
the first thing we do is set it high _without_ any delay. This is
point B. So, a glitch occurs between A and B.

We then fsleep() and finally set the GPIO low at point C.

Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
transitions. Instead we get:

Reset (previously asserted)  : ~~~~~~~~~~|______
Reset (previously deasserted): ____|~~~~~|______
                                   ^     ^
                                   A     C

Where A and C are the points described above in the code. Point B
has been eliminated.

Therefore, to me the patch looks entirely reasonable and correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
