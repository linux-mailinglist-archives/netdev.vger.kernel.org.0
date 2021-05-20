Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB272389D24
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhETFhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETFhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 01:37:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A526101D;
        Thu, 20 May 2021 05:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621488970;
        bh=twufdja/8Rmw932vlWCOrtJupdXWpCfHEJiWDx4rg2k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a5TuSps/fxDqvITAaSU1srRY1ZVbfuaUdgahWeNNBS/FYpmjZdOeMkuDViQiJsdW1
         ryitywN7DamuMxYlKZh6S6j9TOVlfDwLKY+HDZbxTTTsEBKDrBOsTgW3R8zPNR6nke
         xIe5BD7H7C5LhT5uk80IXz/4p7OkjXS67r/9ftlk1lez4ZhWegDAWw3vpuTxY7FWeN
         vvTxq0zSfW8P3nBE7ZV1KhtWYIl1wEafurAXRrfKAFfUOxJtw71scqFNwR5pLExYRE
         wo3+fVg17IGmws9tN83i/fV7HqxTTiVCwrdIWqdAtM0lHbtLssVJjeQe8TZL1z1dDo
         PnpS6qFkwg5hw==
Message-ID: <3ed3fb510ba62f4911f4ffe01a197df3bb8cd969.camel@kernel.org>
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 19 May 2021 22:36:10 -0700
In-Reply-To: <20210519135603.585a5169@kicinski-fedora-PC1C0HJN>
References: <20210519171825.600110-1-kuba@kernel.org>
         <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
         <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
         <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
         <20210519135603.585a5169@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-19 at 13:56 -0700, Jakub Kicinski wrote:
> On Wed, 19 May 2021 13:18:36 -0700 Saeed Mahameed wrote:
> > On Wed, 2021-05-19 at 12:51 -0700, Jakub Kicinski wrote:
> > > 
> > > 
> > > I assumed netif_carrier_event() would be used specifically in
> > > places
> > > driver is actually servicing a link event from the device, and
> > > therefore is relatively certain that _something_ has happened.  
> > 
> > then according to the above assumption it is safe to make
> > netif_carrier_event() do everything.
> > 
> > netif_carrier_event(netdev, up) {
> >         if (dev->reg_state == NETREG_UNINITIALIZED)
> >                 return;
> > 
> >         if (up == netif_carrier_ok(netdev) {
> >                 atomic_inc(&netdev->carrier_up_count);
> >                 atomic_inc(&netdev->carrier_down_count);
> >                 linkwatch_fire_event(netdev);
> >         }
> > 
> >         if (up) {
> >                 netdev_info(netdev, "Link up\n");
> >                 netif_carrier_on(netdev);
> >         } else {
> >                 netdev_info(netdev, "Link down\n");
> >                 netif_carrier_off(netdev);
> >         }
> > }
> 
> Two things to consider are:
>  - some drivers print more info than just "link up/link down" so
> they'd
>    have to drop that extra stuff (as much as I'd like the
> consistency)

+1 for the consistency

>  - again with the unnecessary events I was afraid that drivers reuse 
>    the same handler for device events and to read the state in which
>    case we may do something like:
> 
>         if (from_event && up == netif_carrier_ok(netdev)
> 

I don't actually understand your point here .. what kind of scenarios
it is wrong to use this function ? 

But anyway, the name of the function makes it very clear this is from
event.. 
also we can document this.

> Maybe we can revisit when there's more users?
goes both ways :), we can do what fits the requirement for mlx5 now and
revisit in the future, if we do believe this should be general behavior
for all/most vendors of-course!




