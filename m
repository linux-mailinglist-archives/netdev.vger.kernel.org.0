Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95243F91E2
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbhH0BYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:24:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243862AbhH0BX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UmvqQeRBC3Htg34LwucXA+7+d+VtbtPSDFbdpOgvHz0=; b=XwuOLQcCT/+U9R021tGLTEiB+O
        I0649jMhBb6YJ5tEC5OlvyUNjyQoTx1x2o8NiMeozcwB60PQo2HBpfdvelY9GTvM4H+W5cZ70b9pp
        o8i7+p4KLpRZP2Xq6dmTPmargZcybzwbbE5qP3ID02K5aNynmUUSGq9OhP0Sm3N/DYko=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJQaD-0042Pg-4e; Fri, 27 Aug 2021 03:23:01 +0200
Date:   Fri, 27 Aug 2021 03:23:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSg+dRPSX9/ph6tb@lunn.ch>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch>
 <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Doesn't add much to the discussion. In the example I gave, the driver
> already does synchronous probing. If the device can't probe
> successfully because a supplier isn't ready, it doesn't matter if it's
> a synchronous probe. The probe would still be deferred and we'll hit
> the same issue. Even in the situation the commit [5] describes, if
> parallelized probing is done and the PHY depended on something (say a
> clock), you'd still end up not probing the PHY even if the driver is
> present and the generic PHY would end up force probing it.


genphy is meant to be used when there is no other driver available.
It is a best effort, better than nothing, might work. And quite a few
boards rely on it. However, it should not be used when there is a
specific driver.

So if the PHY device has been probed, and -EPROBE_DEFER was returned,
we also need to return -EPROBE_DEFER here when deciding if genphy
should be used. It should then all unwind and try again later.

I don't know the device core, but it looks like dev->can_match tells
us what we need to know. If true, we know there is a driver for this
device. But i'm hesitant to make use of this outside of driver/base.

	Andrew

