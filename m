Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C104C6A87FC
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCBRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCBRis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:38:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869B0EB61
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6eiV4rAGdaX12LUD9adLsWxur0J4JIOOd2TQ3YgjL7k=; b=oXmnGA6AG8alXKhmmMPlTQhud8
        qcrsrlEA9NyJTpsuI7casZgJ59uMRPPcYzXvjIk0pu/QysQynRFbYsndh6hGeByfBGQrybyc+CZdO
        AzIdwe2IRpqZ5WUGEbIONhGveyWvVWxaC2QL9POLITsmaLCrWG55u0ThXsA8kZIiur3o1eZVuvn8+
        FzKGeqsnL8MEQ58axwXv7ESPDX/lDpSqg533hK8P8CT/t57+q1n8aA+uvGV47pk+okSYZXccqUK5I
        ouPwzb+IkhrEf8LeQA8DIn9RqCs9JaoDG29N3YHeyFwPGCVgzbHyJx9ogjyrNBHaeP/eB7i9VYaex
        LcXBHT/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33008)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pXmt8-00089p-CA; Thu, 02 Mar 2023 17:38:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pXmt7-0004zO-52; Thu, 02 Mar 2023 17:38:41 +0000
Date:   Thu, 2 Mar 2023 17:38:41 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <ZADfIev/RpykWvDi@shell.armlinux.org.uk>
References: <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20230302113752.057a3213@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230302113752.057a3213@kmaincent-XPS-13-7390>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 11:37:52AM +0100, Köry Maincent wrote:
> Hello Russell,
> 
> > I have the situation on a couple of devices where there are multiple
> > places that can do PTP timestamping:
> > 
> > - the PHY (slow to access, only event capture which may not be wired,
> >    doesn't seem to synchronise well - delay of 58000, frequency changes
> >    every second between +/-1500ppb.)
> > - the Ethernet MAC (fast to access, supports event capture and trigger
> >    generation which also may not be wired, synchronises well, delay of
> >    700, frequency changes every second +/- 40ppb.)
> 
> Does this test have been made with the marvell 88E151x PHY?

Yes. Remember, however, that there are many factors that influence
the access latency (as I detailed in my chronologically previous
reply on the other thread.)

> On my side with a zynqMP SOM (cadence MACB MAC) the synchronization of the PHY
> PTP clock is way better: +/-50ppb. Do you have an idea about the difference? 
> Which link partner were you using? stm32mp157 hardware PTP on my side.

Both of my results were through synchronising the PHC with the
machine's local clock (which had already been synchronised via NTP),
thereby creating a "grand master" for my network. That's the only
way to setup a grand master short of purchasing specific kit for
that job (and from what I can see, that's $$$$$ - and out of reach
for your average volunteer kernel maintainer).

I also rigged up the PP2 to provide a PPS signal, connected that to
my TXCO-based frequency counter, measuring the PPS period - which
gives independent measurement of the stability of the PHC. It wasn't
possible to do that with the PHY since the hardware signals aren't
exposed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
