Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8F3B704
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390764AbfFJONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:13:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53134 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390716AbfFJONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=croZxHeBlJ+0waZ7bZjLxhr9hjUu2nYBm/IN0Azvj1k=; b=O+VHhANteU07s8YbjQAG5zEOp
        mijDd+pkTzTqX4uMi4sxYLvbuRSRi4IOHVGp2voCEQbeyxE2NBIYPO/+S+hwwFahQKOX4BXdDcfF6
        K6sZXNinv0YqqoH1YQMXfRILwoUFpamuyvC7MX0UxkIuklnD/4kJVtHJfcy3VtCDQHFAdZjao084+
        UFKJmyiyPTCmJWxDosAUryg+hiMbDTp6yWCLoB7lGkpdWs0W3qomvKrDHYY7j0jznVT3xI4/rHivV
        eJZnEQASMl9FnyD+lKr6+4fhYJ1DPZN7jU/RE0eiznXGY8Jd1wW/NQsCnmys05lxMqr9GCUVFz8hb
        NCUzVE8DA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52938)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1haL2p-0007FI-HT; Mon, 10 Jun 2019 15:13:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1haL2n-00072O-Kd; Mon, 10 Jun 2019 15:13:05 +0100
Date:   Mon, 10 Jun 2019 15:13:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190610141305.zqaqk63b4faiilzz@shell.armlinux.org.uk>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
 <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
 <20190606183611.GD28371@lunn.ch>
 <bdb416f7-3f4c-dbcf-3efe-338ab697b4fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdb416f7-3f4c-dbcf-3efe-338ab697b4fe@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 03:40:10PM +0200, Heiner Kallweit wrote:
> On 06.06.2019 20:36, Andrew Lunn wrote:
> > 65;5402;1c> I don't like too much state changes outside control of the state machine,
> >> like in phy_start / phy_stop / phy_error. I think it would be better
> >> if a state change request is sent to the state machine, and the state
> >> machine decides whether the requested transition is allowed.
> > 
> > Hi Heiner
> > 
> > I initially though that phy_error() would be a good way to do what
> > Russell wants. But the locks get in the way. Maybe add an unlocked
> > version which PHY drivers can use to indicate something fatal has
> > happened?
> > 
> phy_error() switches to PHY_HALTED, therefore phy_start() would start
> another attempt to bring up the PHY. Maybe some new state like
> PHY_PERMANENT_FAILURE could be helpful.  Or do we need a temporary
> failure state?
> 
> After a recent patch from Russell the probe callback returns -ENODEV
> if no firmware is loaded. With the patch starting this discussion
> this would have changed to not failing in probe but preventing the
> PHY from coming up. The commit message missed an explanation what we
> gain with this behavior change.

As previously discussed, it is to allow access to the MDIO bus, and
therefore to allow a userspace tool to program the flash via the
MII ioctls.

At least two people have already independently created such a tool.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
