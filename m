Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509633946A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfFGSem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:34:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36966 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbfFGSel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rx2NLNKZ6Rcxn8puYvwxzmgPOzgGIDsesRlDG/LBDiQ=; b=pehy2HaT2pOe0UgiyXCUpJPoO
        /+YIBFo2wvNRHBKW58BJ/A5YMNp33c2TT1EvgHAbYhRtG7kPL2y3RmcdY+qyoSjDOXPZw/ZF3tRTd
        HW8NmyumHye0MdiO39Dke/WC4b4nsbHLooeqfTyRlfQOO50Ezcfp2DOVb+GQ9eJjyZFP+1iJJxuJi
        IXL6kb3keS3KHoa4g9G/JviaSO7ch7wu2b6EGlnVq2Bojv92bQrlwq5rqzADpRDnsQ5CCKrBF84X/
        pt7XitJkXk9PjMqvprBPbhzf6WehTA/CYE62gFs+GyVzSarf5Ak5FSpaXG8isT0KyzbMeZVBepiGN
        +AgSxZfXw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38562)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hZJhF-0005vd-Id; Fri, 07 Jun 2019 19:34:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hZJhE-0004UX-R3; Fri, 07 Jun 2019 19:34:36 +0100
Date:   Fri, 7 Jun 2019 19:34:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
Message-ID: <20190607183436.af6h5lhw7nb3ycet@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
 <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
 <4b7bf6b4-dbc8-d3d0-4b31-789fcdb8e6b7@sedsystems.ca>
 <20190602151534.nv4b67n5n2iermnr@shell.armlinux.org.uk>
 <37914305-fd19-949a-e20e-b709495c517d@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37914305-fd19-949a-e20e-b709495c517d@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:10:57PM -0600, Robert Hancock wrote:
> On 2019-06-02 9:15 a.m., Russell King - ARM Linux admin wrote:
> > On Fri, May 31, 2019 at 06:17:51PM -0600, Robert Hancock wrote:
> >> Our device is mainly intended for fiber modules, which is why 1000BaseX
> >> is being used. The variant of fiber modules we are using (for example,
> >> Finisar FCLF8520P2BTL) are set up for 1000BaseX, and seem like they are
> >> kind of a hack to allow using copper on devices which only support
> >> 1000BaseX mode (in fact that particular one is extra hacky since you
> >> have to disable 1000BaseX autonegotiation on the host side). This patch
> >> is basically intended to allow that particular case to work.
> > 
> > Looking at the data sheet for FCLF8520P2BTL, it explicit states:
> > 
> > PRODUCT SELECTION
> > Part Number	Link Indicator	1000BASE-X auto-negotiation
> > 		on RX_LOS Pin	enabled by default
> > FCLF8520P2BTL	Yes		No
> > FCLF8521P2BTL	No		Yes
> > FCLF8522P2BTL	Yes		Yes
> > 
> > The idea being, you buy the correct one according to what the host
> > equipment requires, rather than just picking one and hoping it works.
> > 
> > The data sheet goes on to mention that the module uses a Marvell
> > 88e1111 PHY, which seems to be quite common for copper SFPs from
> > multiple manufacturers (but not all) and is very flexible in how it
> > can be configured.
> > 
> > If we detect a PHY on the SFP module, we check detect whether it is
> > an 88e1111 PHY, and then read out its configured link type.  We don't
> > have a way to deal with the difference between FCLF8520P2BTL and
> > FCLF8521P2BTL, but at least we'll be able to tell whether we should
> > be in 1000Base-X mode for these modules, rather than SGMII.
> 
> It looks like that might provide a solution for modules using the
> Marvell PHY, however some of the modules we are supporting seem to use a
> Broadcom PHY, and I have no idea if there is any documentation for those.
> 
> It would really be rather silly if there were absolutely no way to tell
> what mode the module wants from the EEPROM..

It is something I've spent weeks looking at from many different angles.
There is no way to tell.

You have to bear in mind that 1000BaseX and SGMII are essentially
identical, except for the interpretation of that 16-bit control word
and how it is handled.  Both are 1250Mbaud, both are 8b/10b encoded.
Both identify as supporting 1000BASE-T.

As I've said, the only way I can come up with is a hard-coded table
of vendor name/part number to identify what each one requires.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
