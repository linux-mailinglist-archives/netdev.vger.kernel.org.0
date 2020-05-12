Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F81CED3B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgELGtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgELGtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 02:49:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF7CC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 23:49:05 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYOir-00034q-1r; Tue, 12 May 2020 08:49:01 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYOio-00038O-GG; Tue, 12 May 2020 08:48:58 +0200
Date:   Tue, 12 May 2020 08:48:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20200512064858.GA16536@pengutronix.de>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511145926.GC8503@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200511145926.GC8503@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:14:20 up 243 days, 18:02, 450 users,  load average: 0.57, 0.51,
 0.53
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 04:59:26PM +0200, Michal Kubecek wrote:
> On Mon, May 11, 2020 at 04:13:10PM +0200, Oleksij Rempel wrote:
> > 
> > I continue to work on TJA11xx PHY and need to export some additional
> > cable diagnostic/link stability information: Signal Quality Index (SQI).
> > The PHY data sheet describes it as following [1]:
> > ================================================================================
> >   6.10.3   Link stability
> > 
> > The signal-to-noise ratio is the parameter used to estimate link
> > stability. The PMA Receive function monitors the signal-to-noise ratio
> > continuously. Once the signal-to-noise ratio falls below a configurable
> > threshold (SQI_FAILLIMIT), the link status is set to FAIL and
> > communication is interrupted. The TJA1100 allows for adjusting the
> > sensitivity of the PMA Receive function by configuring this threshold.
> > The microcontroller can always check the current value of the
> > signal-to-noise ratio via the SMI, allowing it to track a possible
> > degradation in link stability.
> > ================================================================================
> > 
> > Since this functionality is present at least on TJA11xx PHYs and
> > mandatory according to Open Alliance[2], I hope this functionality is
> > present on other 100/1000Base-T1 PHYs. So may be some common abstraction
> > is possible. What would be the best place to provide it for the user
> > space? According to the [2] SQI, is the part of Dynamic Channel Quality
> > (DCQ) together with Mean Square Error (MSE) and Peak MSE value (pMSE).
> 
> IIUC these would be read-only parameters describing current state of the
> link which can be queried at any time. If this is the case, adding them
> as attributes to ETHTOOL_MSG_LINKSTATE_GET_REPLY message seems most
> fitting.

ok

> As for getting / setting the threshold, perhaps ETHTOOL_MSG_LINKINFO_GET
> and ETHTOOL_MSG_LINKINFO_SET. Unless you expect more configurable
> parameters like this in which case we may want to consider adding new
> request type (e.g. link params or link management).

Currently in my short term todo are:
- SQI
- PHY undervoltage
- PHY overtemerature

So far, I have no idea for PHY health diagnostic.

If we consider at least the  mandatory properties listed in the opensig, then
we would get following list:

- DCQ (dynamic channel group)
  - SQI (Signal Quality Index)
- HDD (Harness defect detection group)
  - OS (Open/Short detection) ----------------- implemented, cable test
    request.
- LQ (Link Quality)
  - LTT (Link-training time. The time of the last link training)
  - LFL (Link Failures and Losses. Number of link losses since the last
    power cycle)
  - COM (communication ready) ----------------- implemented?
- POL (Polarity detection & correction)
  - DET (Polarity detect)

I personally would add RE_ERR counter in this list as well.

Probably some one, soon or later, will try to implement them.

If I see it correctly, some of this properties are already implemented
within other request types. Is it worth to a add a new request type for
the rest of them?

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
