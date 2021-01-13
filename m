Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996472F52A7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbhAMSrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:47:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbhAMSrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 13:47:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6164020780;
        Wed, 13 Jan 2021 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610563612;
        bh=gwuYpLs5Vgf+1/V2RmSxKOGhuBtTBe0qi9fl/KQcIn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8kzMt4vX9yakIpygLAApekVS80LNwbOFx0kJnraqNfRutzXea+vznGOHnBxHnvbv
         sCU7EOzdd/Y+EeqtO4/mexVdOtD0RrOA4ZZ4nn3pZQ82esOJK+DzcACtlbZqgGGqOO
         BLDz6227NtkMOF5rUCesiNgmkDS7d2qdLnfunxNUIEl6Je/2+06xdFHs5zC4P3ciqe
         LodrrxTPQHUCz+wLOAkXb+sf+ubWAZO+XKVX+su/rFSwigQ1bOEUO7qqOETY9eQ7id
         /NIwhXTNhJTh8mpVFWLDQDTrLifUfLfnUtbXGw4v5ICdIQZjBMQD4dejL4U2IzAm5f
         eGpdG0IJLX08Q==
Date:   Wed, 13 Jan 2021 10:46:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: Register physical ports as a
 devlink resource
Message-ID: <20210113104650.0cd37598@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113142656.GA1853106@shredder.lan>
References: <20210112083931.1662874-1-idosch@idosch.org>
        <20210112083931.1662874-2-idosch@idosch.org>
        <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210113083241.GA1757975@shredder.lan>
        <20210113133902.GH3565223@nanopsycho.orion>
        <20210113142656.GA1853106@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 16:26:56 +0200 Ido Schimmel wrote:
> On Wed, Jan 13, 2021 at 02:39:02PM +0100, Jiri Pirko wrote:
> > Wed, Jan 13, 2021 at 09:32:41AM CET, idosch@idosch.org wrote:  
> > >On Tue, Jan 12, 2021 at 08:21:22PM -0800, Jakub Kicinski wrote:  
> > >> On Tue, 12 Jan 2021 10:39:30 +0200 Ido Schimmel wrote:  
> > >> > From: Danielle Ratson <danieller@nvidia.com>
> > >> > 
> > >> > The switch ASIC has a limited capacity of physical ('flavour physical'
> > >> > in devlink terminology) ports that it can support. While each system is
> > >> > brought up with a different number of ports, this number can be
> > >> > increased via splitting up to the ASIC's limit.
> > >> > 
> > >> > Expose physical ports as a devlink resource so that user space will have
> > >> > visibility to the maximum number of ports that can be supported and the
> > >> > current occupancy.  
> > >> 
> > >> Any thoughts on making this a "generic" resource?  
> > >
> > >It might be possible to allow drivers to pass the maximum number of
> > >physical ports to devlink during their initialization. Devlink can then
> > >use it as an indication to register the resource itself instead of the
> > >driver. It can report the current occupancy without driver intervention
> > >since the list of ports is maintained in devlink.
> > >
> > >There might be an issue with the resource identifier which is a 64-bit
> > >number passed from drivers. I think we can partition this to identifiers
> > >allocated by devlink / drivers.
> > >
> > >Danielle / Jiri?  
> > 
> > There is no concept of "generic resource". And I think it is a good
> > reason for it, as the resource is something which is always quite
> > hw-specific. Port number migth be one exception. Can you think of
> > anything else? If not, I would vote for not having "generic resource"
> > just for this one case.  
> 
> I think Jakub's point is that he does not want drivers to expose the
> same resource to user space under different names.

Exactly.

> Question is how to
> try to guarantee it. One option is what I suggested above, but it might
> be an overkill. Another option is better documentation. To add a section
> of "generic" resources in devlink-resource documentation [1] and modify
> the kernel-doc comment above devlink_resource_register() to point to it.
> 
> [1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-resource.html

Yup, an entry in documentation and a common define in net/devlink.h
is fine by me. We can always move around the kernel internals, like 
what registers the resource, later.
