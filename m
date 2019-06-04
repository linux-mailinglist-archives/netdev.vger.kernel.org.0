Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00614351B0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDVMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:12:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFDVMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 17:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SUzG4EHR7GoUCu4/NmOaeCPfw8sW2i47plyzCSAIqoc=; b=6URlGzZ1aFoDkxdebjwD5KMOTq
        wvQjSilcJDhE09wEXXDZuxb+rUvLEWxcB3rmuwYJcekR2q65uYcudnfgjiOEWv0U4cHYQnfp+1Jsh
        UYzGJ7kVqsYrVKL8zFvsDMv6OAl96ktu5aw/NgfDvaWxhd4/AWqEx9aEdwcV/VKM8jTE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYGjF-0008Gx-48; Tue, 04 Jun 2019 23:12:21 +0200
Date:   Tue, 4 Jun 2019 23:12:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604211221.GW19627@lunn.ch>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But now the second question: between a phy_connect and a phy_start,
> shouldn't the PHY be suspended too? Experimentally it looks like it
> still isn't.

This is not always clear cut. Doing auto-neg is slow. Some systems
want to get networking going as fast as possible. The PHY can be
strapped so that on power up it starts autoneg. That can be finished
by the time linux takes control of the PHY, and it can take over the
results, rather than triggering another auto-neg, which will add
another 3 seconds before the network is up.

If we power the PHY down, between connect and start, we loose all
this.

I don't remember anybody submitting patches because the PHY passed
frames to the MAC too early. So i don't think there is much danger
there.

	Andrew
