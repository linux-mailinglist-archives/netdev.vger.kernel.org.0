Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751721CDDFA
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgEKO7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:59:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:34164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgEKO7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 10:59:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBD3DADC2;
        Mon, 11 May 2020 14:59:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6182A6033E; Mon, 11 May 2020 16:59:26 +0200 (CEST)
Date:   Mon, 11 May 2020 16:59:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200511145926.GC8503@lion.mk-sys.cz>
References: <20200511141310.GA2543@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511141310.GA2543@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 04:13:10PM +0200, Oleksij Rempel wrote:
> 
> I continue to work on TJA11xx PHY and need to export some additional
> cable diagnostic/link stability information: Signal Quality Index (SQI).
> The PHY data sheet describes it as following [1]:
> ================================================================================
>   6.10.3   Link stability
> 
> The signal-to-noise ratio is the parameter used to estimate link
> stability. The PMA Receive function monitors the signal-to-noise ratio
> continuously. Once the signal-to-noise ratio falls below a configurable
> threshold (SQI_FAILLIMIT), the link status is set to FAIL and
> communication is interrupted. The TJA1100 allows for adjusting the
> sensitivity of the PMA Receive function by configuring this threshold.
> The microcontroller can always check the current value of the
> signal-to-noise ratio via the SMI, allowing it to track a possible
> degradation in link stability.
> ================================================================================
> 
> Since this functionality is present at least on TJA11xx PHYs and
> mandatory according to Open Alliance[2], I hope this functionality is
> present on other 100/1000Base-T1 PHYs. So may be some common abstraction
> is possible. What would be the best place to provide it for the user
> space? According to the [2] SQI, is the part of Dynamic Channel Quality
> (DCQ) together with Mean Square Error (MSE) and Peak MSE value (pMSE).

IIUC these would be read-only parameters describing current state of the
link which can be queried at any time. If this is the case, adding them
as attributes to ETHTOOL_MSG_LINKSTATE_GET_REPLY message seems most
fitting.

As for getting / setting the threshold, perhaps ETHTOOL_MSG_LINKINFO_GET
and ETHTOOL_MSG_LINKINFO_SET. Unless you expect more configurable
parameters like this in which case we may want to consider adding new
request type (e.g. link params or link management).

Michal
