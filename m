Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6B38B5B4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhETSEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhETSEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1924610A1;
        Thu, 20 May 2021 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621533803;
        bh=CKuDdJ5gmi1tlR8naefjaxfMv8wAYmgoBpdZqGncmhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bR+HBgj/q2AsmNcQ2LRC2eUFYP3zgPWVNKeWW+NzrFa3E+vAj6theoXcqbBYJRiEJ
         D0UjSfQykkJfgXIaOTDe7Co0gFRRnCrFT5QhfYN/ZkiTtn3damBNzufqt3ViZq82ty
         /PztmaECyQGWXiB62rHeKWoNqDAwTDrs4z6eQT0a/ZEKeMJSY8iH05gTmqy3LYG9/Q
         m50hAjuArsXNmKEgqeLpgcf5EtwTOthuCJ7fXF0q9l6wb3jqv9B8E7mtjq07Am4iQs
         A7+Zvhw9t8qEe2wFFOT1MUur1MjIZ5Q0LCxCcl+5STqfu47xe9RfpTtEx4Tcu/ulOH
         7Ba14m2JWx7GA==
Message-ID: <4ba9e15179c5515c91baa6cee470e19bf0ed6bf0.camel@kernel.org>
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Thu, 20 May 2021 11:03:22 -0700
In-Reply-To: <20210520084817.6bd770e5@kicinski-fedora-PC1C0HJN>
References: <20210519171825.600110-1-kuba@kernel.org>
         <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
         <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
         <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
         <20210519135603.585a5169@kicinski-fedora-PC1C0HJN>
         <3ed3fb510ba62f4911f4ffe01a197df3bb8cd969.camel@kernel.org>
         <20210520084817.6bd770e5@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-20 at 08:48 -0700, Jakub Kicinski wrote:
> On Wed, 19 May 2021 22:36:10 -0700 Saeed Mahameed wrote:
> > On Wed, 2021-05-19 at 13:56 -0700, Jakub Kicinski wrote:
> > > On Wed, 19 May 2021 13:18:36 -0700 Saeed Mahameed wrote:  
> > > > then according to the above assumption it is safe to make
> > > > netif_carrier_event() do everything.
> > > > 
> > > > netif_carrier_event(netdev, up) {
> > > >         if (dev->reg_state == NETREG_UNINITIALIZED)
> > > >                 return;
> > > > 
> > > >         if (up == netif_carrier_ok(netdev) {
> > > >                 atomic_inc(&netdev->carrier_up_count);
> > > >                 atomic_inc(&netdev->carrier_down_count);
> > > >                 linkwatch_fire_event(netdev);
> > > >         }
> > > > 
> > > >         if (up) {
> > > >                 netdev_info(netdev, "Link up\n");
> > > >                 netif_carrier_on(netdev);
> > > >         } else {
> > > >                 netdev_info(netdev, "Link down\n");
> > > >                 netif_carrier_off(netdev);
> > > >         }
> > > > }  
> > > 
> > > Two things to consider are:
> > >  - some drivers print more info than just "link up/link down" so
> > > they'd
> > >    have to drop that extra stuff (as much as I'd like the
> > > consistency)  
> > 
> > +1 for the consistency
> > 
> > >  - again with the unnecessary events I was afraid that drivers
> > > reuse 
> > >    the same handler for device events and to read the state in
> > > which
> > >    case we may do something like:
> > > 
> > >         if (from_event && up == netif_carrier_ok(netdev)
> > >   
> > 
> > I don't actually understand your point here .. what kind of
> > scenarios
> > it is wrong to use this function ? 
> > 
> > But anyway, the name of the function makes it very clear this is
> > from
> > event.. also we can document this.
> 
> I don't have any proof of this but drivers may check link state
> periodically from a service job or such.
> 

I see.

> > > Maybe we can revisit when there's more users?  
> > goes both ways :), we can do what fits the requirement for mlx5 now
> > and
> > revisit in the future, if we do believe this should be general
> > behavior
> > for all/most vendors of-course!
> 
> I think it'd be more of a "add this function so the future drivers
> can
> use it". I've scanned the drivers I'm familiar with and none of them
> seemed like they could make use of the "wider" version of the helper.
> Does mlx4 need it?
> 

No, mlx4 relies on the event type.

> The problem seems slightly unusual, I feel like targeted helper would
> lead to a cleaner API, but can change if we really need to..

Sure, I have no strong opinion on the matter.


