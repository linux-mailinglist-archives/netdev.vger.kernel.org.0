Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8DD41E2A7
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347867AbhI3UYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:24:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhI3UYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 16:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YmcyVghdJHtC/wool3HxKieEO9gZnFRYp8XV9FD2I/E=; b=tGTRsTo7JNRXFpm9YWcxcsHrlb
        lZKYTQ0oH4zwS8eWytNikCNTFeIZyAdDOz8jIUuvpoBhUuJ+nbuNEwzvU/CcOEVO1j9Ampqc1HxX7
        C882PphgctxEbcrOVeMm8l8lkeC0IhhfidAHDXIiv82eCxzfUW9pKsxK9RFRQPTF0L2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mW2Zk-0090EA-Vi; Thu, 30 Sep 2021 22:22:40 +0200
Date:   Thu, 30 Sep 2021 22:22:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YVYckPBihi1ukwvE@lunn.ch>
References: <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
 <20210930134343.ztq3hgianm34dvqb@skbuf>
 <YVXDAQc6RMvDjjFu@lunn.ch>
 <CAGETcx8emDg1rojU=_rrQJ3ezpx=wTukFdbBV-uXiu1EQ87=wQ@mail.gmail.com>
 <YVYSMMMkmHQn6n2+@lunn.ch>
 <CAGETcx-L7zhfd72+aRmapb=nAbbFGR5NX0aFK-V9K1WT4ubohA@mail.gmail.com>
 <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't think this is going to scale, we have dozens and dozens of
> drivers that connect to the PHY during ndo_open(). It is not realistic
> to audit them all, just like the opposite case where the drivers do
> probe MDIO/PHY during their .probe() call is not realistic either.

I was wondering if Coccinelle could help use here. But a quick scan of
the documents don't suggest it can follow call stacks. Ideally we
would what something to goes and finds the struct net_device_ops, and
gets the function used for .ndo_open. Then look into that function,
and all functions it calls within the driver, and see if any of them
connect the PHY to the MAC. We could then add an additional parameter
to indicate we are in ndo_open context.

But it looks like that is wishful thinking.

    Andrew
