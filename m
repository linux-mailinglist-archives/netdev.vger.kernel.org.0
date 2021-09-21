Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC07E413B01
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 21:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhIUTwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 15:52:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhIUTwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 15:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O9CGNGP4t9JA5zm1++wpSRXbAdCGi6yyb4Rj0rHTtFU=; b=EiwGD6Cn+SsHEE9zYFgNhbdBRd
        tHGS5foxfsqOLuhg2hx6m08wrscsYqJZ2SR+pK/T3dpo+lhGtVldmboqHkRtmMEnGhrTrHFMdpxVB
        Jf8zPGmaPRHV4yozBGlDCYGAuOKJNOJlvaONXow/OvmHt2jDqlwpn8X38zt3GthqGE30=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSlmq-007g8m-VV; Tue, 21 Sep 2021 21:50:40 +0200
Date:   Tue, 21 Sep 2021 21:50:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUo3kD9jgx6eNadX@lunn.ch>
References: <20210915170940.617415-1-saravanak@google.com>
 <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch>
 <YUoFFXtWFAhLvIoH@kroah.com>
 <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch>
 <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It works at a device level, so it doesn't know about resources.  The
> only information it has is of the "this device may depend on that
> other device" type and it uses that information to figure out a usable
> probe ordering for drivers.

And that simplification is the problem. A phandle does not point to a
device, it points to a resource of a device. It should really be doing
what the driver would do, follow the phandle to the resource and see
if it exists yet. If it does not exist then yes it can defer the
probe. If the resource does exist, allow the driver to probe.

> Also if the probe has already started, it may still return
> -EPROBE_DEFER at any time in theory

Sure it can, and does. And any driver which is not broken will
unregister its resources on the error path. And that causes users of
the resources to release them. It all nicely unravels, and then tries
again later. This all works, it is what these drivers do.

> However, making children wait for their parents to complete probing is
> generally artificial, especially in the cases when the children are
> registered by the parent's driver.  So waiting should be an exception
> in these cases, not a rule.

So are you suggesting that fw_devlink core needs to change, recognise
the dependency on a parent, and allow the probe? Works for me. Gets us
back to before fw_devlink.

    Andrew
