Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F77A402A55
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhIGODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:03:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhIGODy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 10:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OAF6zwj2tMzu/8Vj3/+kijPxUrcu1h4Y9fMBQCW631g=; b=vi5xlwovpGnSmotvOBbdvdeEkS
        7y4uiJ8R45mFeNJhK9fNjHxyrJDe99nq8WHsAlXvKYGqUZQYyREIptSr77HimKedMLAWyawOYQtS7
        9oEjTwmI/VDkT2cfGXtinIGDUumba0mivrUU1QuaPEr9ddGhz+Cc7T1R0JQ0nljk5HVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mNbgS-005eJU-5B; Tue, 07 Sep 2021 16:02:44 +0200
Date:   Tue, 7 Sep 2021 16:02:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>
Subject: Re: [EXTERNAL] Re: [PATCH] net: phy: dp83tc811: modify list of
 interrupts enabled at initialization
Message-ID: <YTdxBMVeqZVyO4Tf@lunn.ch>
References: <20210902190944.4963-1-hnagalla@ti.com>
 <YTFc6pyEtlRO/4r/@lunn.ch>
 <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 08:51:53PM +0000, Modi, Geet wrote:
> Hi Andrew,
> 
> This feature is not used by our mainstream customers as they have additional mechanism to monitor the supply at System level. 
> 
> Hence want to keep it disable by default.

So we are slowly getting closer to a usable commit message. One that
actually makes sense.

Now, this is not really your driver, it is the Linux kernel
driver. Could somebody be using this feature? Not one of your
mainstream customer, but a Linux kernel user?

Lets look at the driver, what interrupts actually get enabled?

                misr_status |= (DP83811_RX_ERR_HF_INT_EN |
                                DP83811_MS_TRAINING_INT_EN |
                                DP83811_ANEG_COMPLETE_INT_EN |
                                DP83811_ESD_EVENT_INT_EN |
                                DP83811_WOL_INT_EN |
                                DP83811_LINK_STAT_INT_EN |
                                DP83811_ENERGY_DET_INT_EN |
                                DP83811_LINK_QUAL_INT_EN);

		misr_status |= (DP83811_JABBER_DET_INT_EN |
                                DP83811_POLARITY_INT_EN |
                                DP83811_SLEEP_MODE_INT_EN |
                                DP83811_OVERTEMP_INT_EN |
                                DP83811_OVERVOLTAGE_INT_EN |
                                DP83811_UNDERVOLTAGE_INT_EN);

Some of these i have no idea what they even do. Why would i be
interested in RX_ERR_HF_INT_EN or MS_TRAINING_INT_EN?
ESD_EVENT_INT_EN? Do we need to wake up the phy driver and update the
status because these interrupts have fired?

ANEG_COMPLETE_INT_EN, ANEG_COMPLETE_INT_EN, LINK_STAT_INT_EN make
sense.

LINK_QUAL_INT_EN and POLARITY_INT_EN could in theory make sense, but
the driver is missing the code to report quality and MDIX/MDX. 

If the driver ever gets HWMON support, OVERTEMP_INT_EN,
OVERVOLTAGE_INT_EN and UNDERVOLTAGE_INT_EN could be interesting. But
there is no HWMON support.

So it looks like there are lots of interrupts which could be removed
because nothing happens when they fire. But then i wonder, why did you
pick just one? Does it cause some sort of problem for one of your
mainstream customers? What sort of problem? Does it affect all other
Linux users, not just your customer?

So please expand your commit message to try to answer some of these
questions.

Thanks
	Andrew
