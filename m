Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF1416475
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhIWRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242543AbhIWRbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 13:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E786360F70;
        Thu, 23 Sep 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632418206;
        bh=SUnd6a35HoB2t5EfEqXfbIPuy+KqrErj97lV9b91p8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YnTImCMA0G3P5byS+2JNOvvsg97ZgkeC1ALb6pUqG/GifG5I7rHGWbLlQzGzv/LOZ
         HgD/qFX83eoAJJc7AI8YrgTG9rwcLmdRZOOzp4FMJe1KBAlFd23chg56eC656xu+Kh
         P7hZKoIzW8GpSCA2qTrI1ohKLYqc03DWB5UPiG1g=
Date:   Thu, 23 Sep 2021 19:30:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] fw_devlink bug fixes
Message-ID: <YUy5nDMeWMg0sfGI@kroah.com>
References: <20210915170940.617415-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915170940.617415-1-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:09:36AM -0700, Saravana Kannan wrote:
> Intended for 5.15.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> 
> v1->v2:
> - Added a few Reviewed-by and Tested-by tags
> - Addressed Geert's comments in patches 3 and 5
> - Dropped the fw_devlink.debug patch
> - Added 2 more patches to the series to address other fw_devlink issues
> 
> v2->v3:
> - Split the logging/debug changes into a separate series

I have taken this now into my tree.

It fixes the real problem where drivers were making the wrong assumption
that if they registered a device, it would be instantly bound to a
driver.  Drivers that did this were getting lucky, as this was never a
guarantee of the driver core (think about if you enabled async
probing, and the mess with the bus specific locks that should be
preventing much of this)

With this new flag, we can mark these drivers/busses that have this
assumption and work to solve correctly over time.  The issue with using
a "generic vs. specific" driver is a bit related, I'm amazed that a
subsystem actually implemented it this way, others of us have been
avoiding this for a very long time due to the complexity involved when
things are built as modules.

thanks,

greg k-h
