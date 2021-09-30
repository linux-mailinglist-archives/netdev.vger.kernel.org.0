Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8941E24B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344566AbhI3TkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:40:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhI3TkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:40:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=w6t0kKZoMiYbydZxW60i6D+JDdmXM6i9cbCc5bRw9+A=; b=hFq5itmWQqlwT+7Y9DIGp1R+pc
        9ATbmdlcdK4QCzOdhrKvuFSiXMmpZtxHtAaCwhC//v4GxJkgCiJ2cQD8wYqI50oMQdyrRA1EuI2Bp
        +z8/ubzqIHj1PwafUZqWOMrmP6BZxA1ejh8EVfhJg5yofN5TZlwYaofO2lVkQGLiQPIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mW1su-008zyB-2t; Thu, 30 Sep 2021 21:38:24 +0200
Date:   Thu, 30 Sep 2021 21:38:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YVYSMMMkmHQn6n2+@lunn.ch>
References: <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
 <20210930134343.ztq3hgianm34dvqb@skbuf>
 <YVXDAQc6RMvDjjFu@lunn.ch>
 <CAGETcx8emDg1rojU=_rrQJ3ezpx=wTukFdbBV-uXiu1EQ87=wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8emDg1rojU=_rrQJ3ezpx=wTukFdbBV-uXiu1EQ87=wQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Btw, do we have non-DSA networking devices where fw_devlink=on
> delaying PHY probes is causing an issue?

I don't know if issues have been reported, but the realtek driver has
had problems in the past when the generic driver is used. Take a look
at r8169_mdio_register(), it does something similar to DSA.

What is going to make things interesting is that phy_attach_direct()
is called in two different contexts. During the MAC drivers probe, it
is O.K. to return EPROBE_DEFER, and let the MAC driver try again
later, if we know there is a specific PHY driver for it. But when
called during the MAC drivers open() op, -EPROBE_DEFER is not
allowed. What to do then is an interesting question.

     Andrew
