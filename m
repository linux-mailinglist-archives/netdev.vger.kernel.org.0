Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEE411E58F
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfLMO3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 09:29:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfLMO3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 09:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yu863y6QtmJ6iAw6RNMk9pO3KKo/xaA77rXntghiFao=; b=nHraHUYRHFCo5Xozt3pJYlAmb1
        k8hiSAA1aYSQV/TZnVRFI5F8n6ZKopthMII7YuDYzgsAhd7TWgsYI5AnihoR3ZDxvo/azVJ94lepI
        X8gnnylUYa3MP7TddG9EmR9fX/fgjiCaoDR7TSUPu8P67pjXS//yZA9OWrvdazmmoZXw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iflwE-0001IF-H8; Fri, 13 Dec 2019 15:29:02 +0100
Date:   Fri, 13 Dec 2019 15:29:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool pause mode clarifications
Message-ID: <20191213142902.GB4286@lunn.ch>
References: <20191213114935.GR25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213114935.GR25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 11:49:35AM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> Please can someone explain the ethtool pause mode settings?  The man
> page isn't particularly clear, it says:
> 
>        -A --pause
>               Changes the pause parameters of the specified Ethernet device.
> 
>            autoneg on|off
>                   Specifies whether pause autonegotiation should be enabled.
> 
>            rx on|off
>                   Specifies whether RX pause should be enabled.
> 
>            tx on|off
>                   Specifies whether TX pause should be enabled.
> 
> 
> "autoneg" states whether pause autonegotiation should be enabled, but
> how is this possible, when pause autonegotiation happens as part of the
> rest of the autonegotiation as a matter of course, and the only control
> we have at the PHY is the value of the pause and asym pause bits?

Hi Russell

Yah, this is not clear. How i've interpreted it is:

autoneg on:

The driver should validate rx and tx with its capabilities, and then
tell the PHY what to advertise, kick off an auto-neg, and wait for the
result to program the MAC with the negotiated value.

If autoneg in general is off, return an error.

autoneg off:

Forget about the PHY, program the MAC directly, and potentially shoot
yourself in the foot. But it can be useful it auto-neg in general is
off, or there is no PHY.


> So, would it be possible to clarify what these settings mean in the
> ethtool man page please?

I suspect the first step would be to survey current implementations
and find out what is the most popular interpretation of this
text. Then expand the document, and maybe list some of the alternative
meanings which are currently in use?

Clearly, the more of this we can handle in phylink/phylib, the more
uniform it will be. But there is also a trend at the moment for
firmware to control the PHY, and it seems like a few MAC driver
writers have no idea what their firmware is actually doing with the
PHY for things like this.

    Andrew
