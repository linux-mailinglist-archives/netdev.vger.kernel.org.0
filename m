Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3591D3172
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgENNi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:38:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgENNi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 09:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Chzc04hjWx7MrXIFsLf5UKR6asBM998MbQnbt6P/vIE=; b=qhlK1D3iTSHrJ7Y/ALUI6YgRUz
        sL691Oyos9LaaMsjd+dQDFnJyah+sjqSTXcJhauRpZg8wyvsjLE4JCffkZmGBf0ut2byZD4QcuTo2
        6dN+BoX+bAJTHnpkYsiNrBwy1o4rMG5AH5MFKVaYb394AfvJJD4B1TYJ9Zum83AKeUI4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZE47-002Hzp-NK; Thu, 14 May 2020 15:38:23 +0200
Date:   Thu, 14 May 2020 15:38:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200514133823.GO527401@lunn.ch>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
 <20200513180140.GK499265@lunn.ch>
 <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:09:59PM +0200, Oleksij Rempel wrote:
> On Wed, May 13, 2020 at 08:01:40PM +0200, Andrew Lunn wrote:
> > > What would be the best place to do a test before the link is getting up?
> > > Can it be done in the phy core, or it should be done in the PHY driver?
> > > 
> > > So far, no action except of logging these errors is needed. 
> > 
> > You could do it in the config_aneg callback.
> 
> In this case I get two test cycles if the test was requested from user
> space: from .cable_test_get_status and from .config_aneg

Oh yes. Forgot about the restore after the test completes.

When do you want to run the test? When the interface is
administratively configured up, or when the link actually goes up?
You could do it in read_status(), when the link changes status.

> > A kernel log entry is not very easy to use. You might want to see how
> > easy it is to send a cable test result to userspace. Anything which is
> > interested in this information can then listen for it. All the needed
> > code is there, you will just need to rearrange it a bit.
> 
> Indeed. I discovered" ethtool --monitor" for me. And the code is some
> thing like this:
> 	ethnl_cable_test_alloc(phydev);
> 	phydev->drv->cable_test_start(phydev);
> 	usleep_range(100, 200);
> 	phydev->drv->cable_test_get_status(phydev, &finished);
> 	if (finished)
> 		ethnl_cable_test_finished(phydev);

Yes, something like that.

> Beside, what do you think about new result codes:
>   ETHTOOL_A_CABLE_RESULT_CODE_POLARITY - if cable polarity is wrong (-
>   connected to +)

Polarity should be a whole new nested pair property, not a status
extension. I think most PHYs are happy to work with the polarity
swapped. So we don't want it to sounds like an error. So status should
be OK and then the polarity property should then indicate it i
swapped. And you can only detected swapped polarity when the link is
up. So in most cases, you would not even include the properties, since
cable tests is normally performed on a down'ed link.

>   ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER - the link partner is active.

>      The TJA1102 is able to detect it if partner link is master.

master is not a cable diagnostics issue. This is a configuration
issue.

	Andrew
