Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DE91B93F4
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZUbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:31:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZUbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 16:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SNbcKS60NeH9y7139zObiaYEOpbMxhLe14nsl2xudWk=; b=UQvqrieSaiW6Bjrye+kSH7TPol
        DGfAU69Ak599VziDw44mcNg2oXI8OrFxL+yEJVxvvFTplZeTRlxcEuwpCDEeifnbc2pJbqJ7Jun5d
        buX0dVnr7JmelJA55X7YEmrarQFG4Z0eeZXrunVRDt1ZwVPuG5VI68a25s0VNN6BE9rk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSnwM-0050qH-Cd; Sun, 26 Apr 2020 22:31:50 +0200
Date:   Sun, 26 Apr 2020 22:31:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 1/9] net: phy: Add cable test support to
 state machine
Message-ID: <20200426203150.GA1183480@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-2-andrew@lunn.ch>
 <20200426194654.GC23225@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426194654.GC23225@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	mutex_lock(&phydev->lock);
> > +	if (phydev->state < PHY_UP ||
> > +	    phydev->state >= PHY_CABLETEST) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "PHY not configured. Try setting interface up");
> > +		err = -EBUSY;
> > +		goto out;
> > +	}
> 
> If I read the code correctly, this check would also catch an attempt to
> start a cable test while the test is already in progress in which case
> the error message would be rather misleading. I'm not sure what would be
> more appropriate in such case: we can return -EBUSY (with more fitting
> error message) but we could also silently ignore the request and let the
> client wait for the notification from the test which is already in
> progress.

Hi Michal

Yes, i will change this to handle phydev->state == PHY_CABLETEST
differently. Probably -EBUSY is the simplest.

Thanks
	Andrew
