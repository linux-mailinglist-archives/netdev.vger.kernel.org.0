Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537731B8943
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 22:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgDYUKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 16:10:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgDYUKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 16:10:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mggCA6gKX3pSXAPLFZO0up3AA4RDfAgNgrJtbDnTd9s=; b=azpaor1/4L3hWCDJAuXwGu6KSZ
        apCpuVcXhWt+FciskAINf01gEhnLtELwgB2qoe/J8iJ7PNp6fsSEPNvSKvnxONjK/OWnpvDRm7ltb
        vOfgGCukMJKpuECI+ikckagEEj1pRaE2Ypwjg0XNfD/39M8AmCq4ZB52aRnp402wspio=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSR7u-004o3m-VP; Sat, 25 Apr 2020 22:10:14 +0200
Date:   Sat, 25 Apr 2020 22:10:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v1 2/9] net: phy: Add support for polling cable
 test
Message-ID: <20200425201014.GF1088354@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-3-andrew@lunn.ch>
 <7557316a-fc27-ac05-6f6d-b9bac81afd82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7557316a-fc27-ac05-6f6d-b9bac81afd82@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 12:49:46PM -0700, Florian Fainelli wrote:
> Hi Andrew,
> 
> On 4/25/2020 11:06 AM, Andrew Lunn wrote:
> > Some PHYs are not capable of generating interrupts when a cable test
> > finished. They do however support interrupts for normal operations,
> > like link up/down. As such, the PHY state machine would normally not
> > poll the PHY.
> > 
> > Add support for indicating the PHY state machine must poll the PHY
> > when performing a cable test.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> If you started a cable test and killed the ethtool process before the
> cable diagnostics are available, the state machine gets stuck in that
> state, so we should find a way to propagate the signal all the way to
> the PHY library somehow.

Hi Florian

It should not matter if the user space tool goes away. As you read
later patches you will see why. But:

ETHTOOL_MSG_CABLE_TEST_ACT is an action to trigger cable
test. Assuming the driver supports it etc, the cable test is started,
and user space immediately gets a ETHTOOL_MSG_CABLE_TEST_ACT_REPLY.
The state is changed to PHY_CABLETEST.

Sometime later, the driver indicates the cable test has
completed. This can be an interrupt, or because it is being polled.  A
ETHTOOL_MSG_CABLE_TEST_NTF is multicast to user space with the
results. And the PHY then leaves state PHY_CABLETEST. If there is no
user space listening for the ETHTOOL_MSG_CABLE_TEST_NTF, it does not
matter.

At least with the Marvell PHY, there is no documented way to tell it
to abort a cable test. So knowing the user space has lost interest in
the results does not help us.

    Andrew
    
