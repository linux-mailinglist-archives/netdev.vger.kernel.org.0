Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF8E323B6
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 17:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFBPPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 11:15:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35884 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfFBPPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 11:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H0mIk+dUA2ltYWp6JsSiA3DwRjqDNSUVGrttX7PNFOI=; b=1fz2pPXekZyJFOFjbnhBC5maF
        C5P2QVd/+69bcNe0PgkGcQ7tbkCHRyfGNHESouNKs1BEbh8aj0oAFRAnNAppivkbzcX145+2OdNh1
        CiVMOmqq6WRR2ZIDkgreUSw3H+BzPKIaCmthAsPHTX4slnNtjGySLLTo2uSRCkr5Xdt7i7z6tPY9E
        l4+Tano+RTrqhzSslONSuQekXYyF1n5MxPGcQ4grCdrskHZS7MpiCcQq87x7buG4XLgkKk6kpWkvT
        7UnZEk815HP/1KNn4BusCsR34T6xyVanX/sgAv9Mb7oebXDYQaRweVc9tptR4LJ/AVvZdUbN3YwvT
        U2WFfikWw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38460)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hXSCt-0005hQ-Jz; Sun, 02 Jun 2019 16:15:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hXSCs-0008Gz-BL; Sun, 02 Jun 2019 16:15:34 +0100
Date:   Sun, 2 Jun 2019 16:15:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
Message-ID: <20190602151534.nv4b67n5n2iermnr@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
 <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
 <4b7bf6b4-dbc8-d3d0-4b31-789fcdb8e6b7@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b7bf6b4-dbc8-d3d0-4b31-789fcdb8e6b7@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 06:17:51PM -0600, Robert Hancock wrote:
> Our device is mainly intended for fiber modules, which is why 1000BaseX
> is being used. The variant of fiber modules we are using (for example,
> Finisar FCLF8520P2BTL) are set up for 1000BaseX, and seem like they are
> kind of a hack to allow using copper on devices which only support
> 1000BaseX mode (in fact that particular one is extra hacky since you
> have to disable 1000BaseX autonegotiation on the host side). This patch
> is basically intended to allow that particular case to work.

Looking at the data sheet for FCLF8520P2BTL, it explicit states:

PRODUCT SELECTION
Part Number	Link Indicator	1000BASE-X auto-negotiation
		on RX_LOS Pin	enabled by default
FCLF8520P2BTL	Yes		No
FCLF8521P2BTL	No		Yes
FCLF8522P2BTL	Yes		Yes

The idea being, you buy the correct one according to what the host
equipment requires, rather than just picking one and hoping it works.

The data sheet goes on to mention that the module uses a Marvell
88e1111 PHY, which seems to be quite common for copper SFPs from
multiple manufacturers (but not all) and is very flexible in how it
can be configured.

If we detect a PHY on the SFP module, we check detect whether it is
an 88e1111 PHY, and then read out its configured link type.  We don't
have a way to deal with the difference between FCLF8520P2BTL and
FCLF8521P2BTL, but at least we'll be able to tell whether we should
be in 1000Base-X mode for these modules, rather than SGMII.

For a SFP cage meant to support fiber, I would recommend using the
FCLF8521P2BTL or FCLF8522P2BTL since those will behave more like a
802.3z standards-compliant gigabit fiber connection.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
