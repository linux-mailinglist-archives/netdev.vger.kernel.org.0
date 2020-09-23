Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2537A276402
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIWWmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgIWWmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:42:19 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25661214F1;
        Wed, 23 Sep 2020 22:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600900938;
        bh=q/SyCKS4vWZifgLcAj3lUplkmU2OZSgulPabk0vf+Yo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WfR52Oeau2WY+H8mcf9hZKzBFLSuufUmtlhCDzFYG2VM+u2CI8NMxTI4WXeG8nmn/
         cLIgZOj317nuScl3RobdZ8ro9cOTBoinmx76s1isxjiOiJ36TUpCZAGcO7FO55Z+Ti
         M/PkWUFQZa7eIOGkCi4OuKicG/3r1MK1Jy4sEd4g=
Message-ID: <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     geert+renesas@glider.be, f.fainelli@gmail.com, andrew@lunn.ch,
        kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Sep 2020 15:42:17 -0700
In-Reply-To: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
References: <3d9176a6-c93e-481c-5877-786f5e6aaef8@gmail.com>
         <28da797abe486e783547c60a25db44be0c030d86.camel@kernel.org>
         <14f41724-ce45-c2c0-a49c-1e379dba0cb5@gmail.com>
         <20200923.131529.637266321442993059.davem@davemloft.net>
         <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-23 at 22:44 +0200, Heiner Kallweit wrote:
> On 23.09.2020 22:15, David Miller wrote:
> > From: Heiner Kallweit <hkallweit1@gmail.com>
> > Date: Wed, 23 Sep 2020 21:58:59 +0200
> > 
> > > On 23.09.2020 20:35, Saeed Mahameed wrote:
> > > > Why would a driver detach the device on ndo_stop() ?
> > > > seems like this is the bug you need to be chasing ..
> > > > which driver is doing this ? 
> > > > 
> > > Some drivers set the device to PCI D3hot at the end of ndo_stop()
> > > to save power (using e.g. Runtime PM). Marking the device as
> > > detached
> > > makes clear to to the net core that the device isn't accessible
> > > any
> > > longer.
> > 
> > That being the case, the problem is that IFF_UP+!present is not a
> > valid netdev state.
> > 
> If this combination is invalid, then netif_device_detach() should
> clear IFF_UP? At a first glance this should be sufficient to avoid
> the issue I was dealing with.
> 

Feels like a work around and would conflict with the assumption that 
netif_device_detach() should only be called when !IFF_UP

Maybe we need to clear IFF_UP before calling ops->ndo_stop(dev),
instead of after on __dev_close_many(). Assuming no driver is checking
IFF_UP state on its own ndo_stop(), other than this, the order
shouldn't really matter, since clearing the flag and calling ndo_stop()
should be considered as one atomic operation.

> > Is it simply the issue that, upon resume, IFF_UP is marked true
> > before
> > the device is brought out from D3hot state and thus marked as
> > present
> > again?
> > 
> I can't really comment on that. The issue I was dealing with at the
> time I submitted this change was about an async linkwatch event
> (caused by powering down the PHY in ndo_stop) trying to access the
> device when it was powered down already.

