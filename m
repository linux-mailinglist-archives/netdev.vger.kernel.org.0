Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D031CF534
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgELNEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:04:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgELNEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 09:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jK4zL75kEjZz1WHIcEzDIz6MmRgpd2lB37qu5hoigyE=; b=tjtqKokOyIfsk0LplqjjgiF8GQ
        XQJaeOnbZX3W0brBh+PAsB2gClQIUJOLSsgbUFCTMBNPDEqPK+ATDHT8xvJEfbaNtKyxGz4PdIErE
        tmjm/JXTaID0uuSczX0FzK0Agi3iyaGawjwixtGjZrowAt17HUotA9IR+R/Jk0tsE+0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYUa2-001zBu-6i; Tue, 12 May 2020 15:04:18 +0200
Date:   Tue, 12 May 2020 15:04:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200512130418.GF409897@lunn.ch>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511145926.GC8503@lion.mk-sys.cz>
 <20200512064858.GA16536@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512064858.GA16536@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > As for getting / setting the threshold, perhaps ETHTOOL_MSG_LINKINFO_GET
> > and ETHTOOL_MSG_LINKINFO_SET. Unless you expect more configurable
> > parameters like this in which case we may want to consider adding new
> > request type (e.g. link params or link management).
> 
> Currently in my short term todo are:
> - SQI


> - PHY undervoltage
> - PHY overtemerature

Do you only have alarms? Or are current values available for voltage
and temperature?

Both of these would fit hwmon. It even has the option to set the alarm
thresholds. The advantage of hwmon is that they are then just more
sensors. You could even include the temperature sensor into a thermal
zone to influence cooling. There are a couple of PHYs which already do
hwmon, so there is code you can copy.

> So far, I have no idea for PHY health diagnostic.
> 
> If we consider at least the  mandatory properties listed in the opensig, then
> we would get following list:
> 
> - DCQ (dynamic channel group)
>   - SQI (Signal Quality Index)
> - HDD (Harness defect detection group)
>   - OS (Open/Short detection) ----------------- implemented, cable test
>     request.
> - LQ (Link Quality)
>   - LTT (Link-training time. The time of the last link training)
>   - LFL (Link Failures and Losses. Number of link losses since the last
>     power cycle)
>   - COM (communication ready) ----------------- implemented?
> - POL (Polarity detection & correction)
>   - DET (Polarity detect)

Voltage and temperature are about the package. These are about the
link. So they better fit ETHTOOL_MSG_LINKINFO_SET or similar.

It sounds like LFL are statistic counters? PHYs can have their own
counters, which ethtool -S will return.

Does POLL somehow map to MDI MDIX? I guess not, since this is a T1.

     Andrew
