Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86124B3D5A
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfIPPNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:13:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfIPPNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 11:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qslw6kOw2Be8j7nCTauCKrs1ny5oQCdTuGpIO3utnSA=; b=XzPSsFA56UbCxXztwk8Nd0e199
        xiuwFcr0XHc6gjj4SBp3xoX3CFlM364jhcnHL0E0YqDwNBQiuZQGb5eYvXiD6RLl9+Zeo5cR2K6v/
        FBB9RwtRdt3Y3vSTbNtcq7gVU2CxN9RSsCNvgh8brm6RMBbB6JB++xO0jpHRDaBRWQI8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i9sgm-00032O-O4; Mon, 16 Sep 2019 17:13:16 +0200
Date:   Mon, 16 Sep 2019 17:13:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Thomas <pthomas8589@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: net: phy: micrel KSZ9031 ifdown ifup issue
Message-ID: <20190916151316.GA8144@lunn.ch>
References: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
 <20190914145443.GE27922@lunn.ch>
 <CAD56B7dF9Dqf1wwu=w60z0q+hkE5-noZRS4uuUfF4PhyNSa4Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD56B7dF9Dqf1wwu=w60z0q+hkE5-noZRS4uuUfF4PhyNSa4Kw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When it is in the good state I see that reg 0x01 is 0x796d where bit
> 1.2 reports 'Link is up' and bit 1.5 reports 'Auto-negotiation process
> complete'. However, once I get to the bad state (it may take several
> tries of ifdown, ifup to get there) then reg 0x01 is 0x7649 reporting
> 'Link is down' and 'Auto-negotiation process not completed'. This can
> be fixed by resetting the phy './phytool write eth0/3/0 0x9140'
> 
> So, I guess that means the driver is doing what it is supposed to?
> Could we add quirk or something to reset the phy again from the driver
> if auto-negotiation doesn't complete with x seconds?

Hi Paul

Adding a timeout would make sense. But please try to hide all this
inside the PHY driver. Since it is being polled, the read_status()
should be called once per second, so you should be able to handle all
this inside that driver callback.

     Andrew
