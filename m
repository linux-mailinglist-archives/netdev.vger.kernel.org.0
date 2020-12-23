Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681612E2070
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgLWS2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbgLWS2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 13:28:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D2A222287;
        Wed, 23 Dec 2020 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608748050;
        bh=Z5xODn+IvbDBsPmKFYmrF505ldukXJ1K5bdX4rxgeGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BnumjNjPSVrrfXxNOCnui2niY6YSa67I5SxqqAQPIhJacNQsWOzNk+fggCtOaHU1D
         5P1uccWMbuKYrjCC7HqgsBeFtTijFWoYyI+QRo0h53k9Fdn6KHIng83cUo8GePYBHM
         DAItaxaoz2YtHwY1ZaUQgnd6vk/CpZsu2fcozUHg+yMby4MsFyzVjxMZn8xCr6ZfGG
         gDryZAymkAX3BX7W2gI0tBgBY/5H4Cmymyi89SuPPR+3J178+88IMu72WjtIt+ctGP
         CMTRIw1tRP6h1hbEQTPqgQuxMz+BlLFMQFMPOpfr+Ea4jSq3Ulz9im9D7mUxHxR+gr
         2wo3sKc9KOfVg==
Date:   Wed, 23 Dec 2020 10:27:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Antoine Tenart <atenart@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking
 the maps and dev->tc_num
Message-ID: <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
References: <20201221193644.1296933-1-atenart@kernel.org>
        <20201221193644.1296933-2-atenart@kernel.org>
        <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
        <160862887909.1246462.8442420561350999328@kwain.local>
        <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 08:12:28 -0800 Alexander Duyck wrote:
> On Tue, Dec 22, 2020 at 1:21 AM Antoine Tenart <atenart@kernel.org> wrote:
> > Quoting Alexander Duyck (2020-12-22 00:21:57)  
> > >
> > > Looking over this patch it seems kind of obvious that extending the
> > > xps_map_mutex is making things far more complex then they need to be.
> > >
> > > Applying the rtnl_mutex would probably be much simpler. Although as I
> > > think you have already discovered we need to apply it to the store,
> > > and show for this interface. In addition we probably need to perform
> > > similar locking around traffic_class_show in order to prevent it from
> > > generating a similar error.  
> >
> > I don't think we have the same kind of issues with traffic_class_show:
> > dev->num_tc is used, but not for navigating through the map. Protecting
> > only a single read wouldn't change much. We can still think about what
> > could go wrong here without the lock, but that is not related to this
> > series of fixes.  
> 
> The problem is we are actually reading the netdev, tx queue, and
> tc_to_txq mapping. Basically we have several different items that we
> are accessing at the same time. If any one is updated while we are
> doing it then it will throw things off.
> 
> > If I understood correctly, as things are a bit too complex now, you
> > would prefer that we go for the solution proposed in v1?  
> 
> Yeah, that is what I am thinking. Basically we just need to make sure
> the num_tc cannot be updated while we are reading the other values.

Yeah, okay, as much as I dislike this approach 300 lines may be a little
too large for stable.

> > I can still do the code factoring for the 2 sysfs show operations, but
> > that would then target net-next and would be in a different series. So I
> > believe we'll use the patches of v1, unmodified.  

Are you saying just patch 3 for net-next? We need to do something about
the fact that with sysfs taking rtnl_lock xps_map_mutex is now entirely
pointless. I guess its value eroded over the years since Tom's initial
design so we can just get rid of it.
