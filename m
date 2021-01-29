Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED915308481
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 05:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhA2EQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 23:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2EQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 23:16:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2F764DFF;
        Fri, 29 Jan 2021 04:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611893746;
        bh=UBJNq5dCwXJzELkBErL86XwpABwEOrWSOp1iXnIisJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ev3EoplPPS+VEftOvGp+euxZMHlL1sZ2FJN0mbGfhaOuf9QybT/2SHaAIuOcjPTUQ
         tFQU2lAgGderFiMHmquEY6NpChFESNlxyTXHDPZ+sppc0vtD9U+SQxHSRUzzWQGbBj
         VTRxA/N9etSmWw2fx8xV3uvbWDDdT7kAyQbWy91NViN4zcIcptwIMY7cx7m2XOS0dX
         4d8BHp57omyQsSbGWkYe/XYyqosLKTq+oM38qFPgVy1OWvCkbd5DrD5AVDk5VW0g04
         Ji4M8Knk/7Kdt4r+2FZTLKAF3nFjpbZ/hI+FaeYHdZtnk0MHoVJXko6DHynjeK4Cld
         tsaHyFnouMhhA==
Date:   Thu, 28 Jan 2021 20:15:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, amcohen@nvidia.com, roopa@nvidia.com,
        sharpd@nvidia.com, bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Message-ID: <20210128201545.07e95057@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
        <20210126132311.3061388-6-idosch@idosch.org>
        <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 20:33:22 -0700 David Ahern wrote:
> On 1/28/21 8:04 PM, Jakub Kicinski wrote:
> > On Tue, 26 Jan 2021 15:23:06 +0200 Ido Schimmel wrote:  
> >> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> >> are changed. The aim is to provide an indication to user-space
> >> (e.g., routing daemons) about the state of the route in hardware.  
> > 
> > What does the daemon in the user space do with it?  
> 
> You don't want FRR for example to advertise a route to a peer until it
> is really programmed in h/w. This notification gives routing daemons
> that information.

I see. Hm.

> > The notification will only be generated for the _first_ ASIC which
> > offloaded the object. Which may be fine for you today but as an uAPI 
> > it feels slightly lacking.
> > 
> > If the user space just wants to make sure the devices are synced to
> > notifications from certain stage, wouldn't it be more idiomatic to
> > provide some "fence" operation?
> > 
> > WDYT? David?
> 
> This feature was first discussed I think about 2 years ago - when I was
> still with Cumulus, so I already knew the intent and end goal.
> 
> I think support for multiple ASICs / NICs doing this kind of offload
> will have a whole lot of challenges. I don't think this particular user
> notification is going to be a big problem - e.g., you could always delay
> the emit until all have indicated the offload.

My impression from working on this problem in TC is that the definition
of "all" becomes problematic especially if one takes into account
drivers getting reloaded. But I think routing offload has stronger
semantics than TC, so no objections.

We need a respin for the somewhat embarrassing loop in patch 1, tho.
