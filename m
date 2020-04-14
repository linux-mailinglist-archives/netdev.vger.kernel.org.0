Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD131A84F7
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391689AbgDNQaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:30:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44248 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391683AbgDNQar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 12:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bfBQPK6jHUP0T6D3BfvHJs65UU0jMBvVftwbQ7Ccv0A=; b=VrbNfrwuFd02NIyb8SgmA6cXs
        bvHoC4l9VPppfChhyDlv74mX1jH0buHsPPiGeFkFW087qAV/vkOnKuFd+ditPqCNsdsCrMBDz/Oeu
        DkYhXbu8i+lVtPUS+iy2IPBMxqzkfM+av6JIvX2U2l92tcypiIkD3ItnposiaxADUpBTjXGgD9oyr
        Y2htpGA0K+zpWj/LuW3+v7NAttyghVVpH33SGIshzpTk5sQhUf5KV6q4Lvd45270cYxOZO/ME373c
        LkdvqqMI8uUi/hEhURA5/tVGpm0tTr+igwVPgNrGUgkfJFepZUOcmQkeAdtUtsCncmrKMzYwF/xpL
        2pNgd9CZg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:45874)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jOOSF-0000h9-Pb; Tue, 14 Apr 2020 17:30:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jOOSA-0008Fc-I7; Tue, 14 Apr 2020 17:30:26 +0100
Date:   Tue, 14 Apr 2020 17:30:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200414163026.GW25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > about 10% of the board idle power.
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Hi,
> 
> I have a Macchiatobin double shot, and my 10G ports stop working after
> this change.
> I reverted this commit on top of latest net-next and now the ports work again.

For the public record, I've been debugging this in-part on Matteo's
board, and it looks like it's a PHY firmware issue.

Both my Macchiatobin boards use firmware 0.2.1.0 (which is not even
mentioned on Marvell's extranet), whereas Matteo's board uses 0.3.3.0.
It seems firmware 0.2.1.0 behaves "correctly" with my patch, but
0.3.3.0 does not - and neither does the latest 0.3.10.0.  Both of
these more recent versions seem to need a software reset to recover
from power down mode... so a patch will be coming soon to add that.

I also think it would be a good idea to print the PHY firmware
version when the PHY is probed - another patch coming for that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
