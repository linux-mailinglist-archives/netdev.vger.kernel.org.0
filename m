Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31296E2870
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437184AbfJXCti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:49:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406591AbfJXCth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 22:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j1oTEO4LjeSonVh47BRmlQx8GAfR3ju2Y3NV2AQEKf0=; b=gcl4hxFZ3Ipl1WnVicJHuoJ1AT
        XtRw+9S595xYTOrahJXldEJI1nhJ10SicVbALZD8d4VGTdrTZl4fVZKh5vYxXzDIRs7t0g/GemvAP
        W4YO7pl708w0G3uQZUfxz0c8+Zv42uBLlCZZcJFbIAoyZLO3mo4o7SQr000VRXLXpVL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNTBv-0001I5-5B; Thu, 24 Oct 2019 04:49:35 +0200
Date:   Thu, 24 Oct 2019 04:49:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
Message-ID: <20191024024935.GM5707@lunn.ch>
References: <20191022011817.29183-1-andrew@lunn.ch>
 <20191023.191320.2221170454789484606.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023.191320.2221170454789484606.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 07:13:20PM -0700, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 22 Oct 2019 03:18:17 +0200
> 
> > Before this change of_get_phy_mode() returned an enum,
> > phy_interface_t. On error, -ENODEV etc, is returned. If the result of
> > the function is stored in a variable of type phy_interface_t, and the
> > compiler has decided to represent this as an unsigned int, comparision
> > with -ENODEV etc, is a signed vs unsigned comparision.
> > 
> > Fix this problem by changing the API. Make the function return an
> > error, or 0 on success, and pass a pointer, of type phy_interface_t,
> > where the phy mode should be stored.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> So now we have code that uses the 'interface' value without checking
> the error return value which means it's potentially uninitialized.

Hi David

If it did not check before, it was passing -ENODEV to something. So it
was already broken. But an uninitialized value is worse. I can see
about adding error checking where there are none.

> There are also a bunch of reverse christmas tree violations created
> by this patch as well :-) :-) :-)

I tried to avoid that, but a lot of drivers are not reverse christmas
to start with. In which case i tried to not break it any more. But i
can review my changes.

    Andrew
