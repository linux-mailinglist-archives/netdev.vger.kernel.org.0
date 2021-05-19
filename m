Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C83897B8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhESUT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhESUT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:19:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32538611BD;
        Wed, 19 May 2021 20:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455517;
        bh=zsTUgBWv6cFa8AhdQMGaUxCXLa9qEiOLJjD+8Q5wY2M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jm5NCwnz4mk1kiBcRTbiDS4FURzoWN+81btHCv9mazyFRwqNs7fvongwBR1pJemjD
         yeRFpx2fhEbBayIKw67ZvudDs5w+UYtraEVq5b6yQWSmgG24h6Km+PLofG3X11q4wj
         oycFOfRtahEeghVLB1fSHtIyvVrNU6a9lQvxh8Ip3O2e2meSswoF6be6AmrEhR5Szp
         fH+EBzd8+5SdZBiSE40l58Hc5N2pO19GVbsrRKXOYF4r6bL0VKIlssGaaCdt5LQQW4
         CDf0AJN6tdVjels/DgtEge3cqWzq73p5VjmO+y1TEYYEUiZQzNUfKpInyg2BTX+nur
         D6zlLZhLQV3Qg==
Message-ID: <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 19 May 2021 13:18:36 -0700
In-Reply-To: <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
References: <20210519171825.600110-1-kuba@kernel.org>
         <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
         <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-19 at 12:51 -0700, Jakub Kicinski wrote:
> On Wed, 19 May 2021 14:34:34 -0500 Lijun Pan wrote:
> > Is it possible to integrate netif_carrier_event into
> > netif_carrier_on? like,
> > 
> > 
> > void netif_carrier_on(struct net_device *dev)
> > {
> >         if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state))
> > {
> >                 if (dev->reg_state == NETREG_UNINITIALIZED)
> >                         return;
> >                 atomic_inc(&dev->carrier_up_count);
> >                 linkwatch_fire_event(dev);
> >                 if (netif_running(dev))
> >                         __netdev_watchdog_up(dev);
> >         } else {
> >                 if (dev->reg_state == NETREG_UNINITIALIZED)
> >                         return;
> >                 atomic_inc(&dev->carrier_down_count);
> >                 atomic_inc(&dev->carrier_up_count);
> >         }
> > }
> > EXPORT_SYMBOL(netif_carrier_on);
> 
> Ah, I meant to address that in the commit message, thanks for bringing
> this up. I suspect drivers may depend on the current behavior of
> netif_carrier_on()/off() being idempotent. We have no real reason for
> removing that assumption.
> 
> I assumed netif_carrier_event() would be used specifically in places
> driver is actually servicing a link event from the device, and
> therefore is relatively certain that _something_ has happened.

then according to the above assumption it is safe to make
netif_carrier_event() do everything.

netif_carrier_event(netdev, up) {
	if (dev->reg_state == NETREG_UNINITIALIZED)
		return;

	if (up == netif_carrier_ok(netdev) {
		atomic_inc(&netdev->carrier_up_count);
		atomic_inc(&netdev->carrier_down_count);
		linkwatch_fire_event(netdev);
	}

	if (up) {
		netdev_info(netdev, "Link up\n");
		netif_carrier_on(netdev);
	} else {
		netdev_info(netdev, "Link down\n");
		netif_carrier_off(netdev);
	}
}

