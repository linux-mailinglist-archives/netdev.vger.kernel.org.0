Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35F1EB0E2
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgFAVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAVVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:21:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D551C061A0E;
        Mon,  1 Jun 2020 14:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tqW4VYGG9Fe/MRunQJThk25D/0Z+SuQJNcCD6SJisQk=; b=ei05sGg8B9oW+xlKoWiwGUwVd
        0JPFiBUZSr0zNQlwQb8NBoHCLlAoS+iC3jwwfkP5NHlNw9nGACB9z2YVjc3wnu+NrLUnXdHpZFSGB
        Zf1A8FDj2KKaSeq3kjSpzcQfIO7ptFPaznj+pvKLRSTyIvq09DL38/mDamHwUiSdRfABVT3SDMww1
        wmB2BIo4B0yL+aPdleD5ShLOIDyYlX4MwHBPPeoYfL6SjiKYsB0nZ8ecV4zJi6oogNfBrNmEFTBrZ
        mpttlHb+bZv2UbHvYPFmkH1+uCUOKXj7K77PbvMuZhOZ1tXW4TPLCb9m6C6/lE120mh2N6dI09Rot
        AXLG51T9w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37666)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jfrs2-0001JV-Sm; Mon, 01 Jun 2020 22:21:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jfrru-0003fj-Jp; Mon, 01 Jun 2020 22:21:14 +0100
Date:   Mon, 1 Jun 2020 22:21:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, zefir.kurtisi@neratec.com
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
Message-ID: <20200601212114.GT1551@shell.armlinux.org.uk>
References: <20200530214315.1051358-1-olteanv@gmail.com>
 <20200531001849.GG1551@shell.armlinux.org.uk>
 <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com>
 <20200601002753.GH1551@shell.armlinux.org.uk>
 <CA+h21hqongWM=M7E_0d+Zb_qOsw-Gc4soZXoXd_izciz6YeUpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqongWM=M7E_0d+Zb_qOsw-Gc4soZXoXd_izciz6YeUpA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 11:57:30PM +0300, Vladimir Oltean wrote:
> On Mon, 1 Jun 2020 at 03:28, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > And yes, I do have some copper SFP modules that have an (inaccessible)
> > AR803x PHY on them - Microtik S-RJ01 to be exact.  I forget exactly
> > which variant it is, and no, I haven't seen any of this "SGMII fails
> > to come up" - in fact, the in-band SGMII status is the only way to
> > know what the PHY negotiated with its link partner... and this SFP
> > module works with phylink with no issues.
> 
> See, you should also specify what kernel you're testing on. Since
> Heiner did the PHY_AN cleanup, phy_aneg_done is basically dead code
> from the state machine's perspective, only a few random drivers call
> it:
> https://elixir.bootlin.com/linux/latest/A/ident/phy_aneg_done
> So I would not be at all surprised that you're not hitting it simply
> because at803x_aneg_done is never in your call path.

Please re-read the paragraph of my reply that is quoted above, and
consider your response to it in light of the word *inaccessible* in
my paragraph above.

Specifically, ask yourself the question: "if the PHY is inaccessible,
does it matter what kernel version is being tested?  Does it matter
what the at803x code is doing?"

The point that I was trying to get across, but you seem to have missed,
is that this SFP module uses an AR803x PHY that is inaccessible and I
have never seen a problem with the SGMII side coming up - and if the
SGMII side does not come up, we have no way to know what the copper
side is doing.  With this module, we are totally reliant on the SGMII
side working correctly to work out what the copper side status is.

*Frustrated*.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
