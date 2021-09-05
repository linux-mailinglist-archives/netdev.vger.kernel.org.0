Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB1400FC0
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 15:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbhIENCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 09:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhIENCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 09:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090136069E;
        Sun,  5 Sep 2021 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630846896;
        bh=t8si10xmGr93hrxLkWZvJna7ZbS944x/VXWktrSiYSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fP9vsDvbeOJKYodtbCVgTw5aJzcJq/X8mzE7gtdE5GqALhprKRAFdHd0xRVYYXTLR
         W4baJjHS9LyjS8j+DpFqvwLwIlFaeYepmRSrQlf0MU1Jwom1UZjfiZEORWc/EfRNXh
         gv3YUIzyUBi3x4FdCXXV3ZgNbOz1m2gYQMGetNaTYNQopeb7l+JBmBcfQa2Yeu7dDw
         zR3YQQ6AAGy3XZBtgiDrwv1wM8mCXXQUE1mOSuIqq9ruG5y3iU23rH1iTI+yYPJy4U
         rsLyeGrQsfIM6WQLP7wVQr53shTYmtEUNptE4BHCLSsDVV9g9gpzComPc4olf7Plpo
         iYixjblkboDEA==
Date:   Sun, 5 Sep 2021 16:01:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTS/rK73Qbd3KAtz@unreal>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
 <20210905110735.asgsyjygsrxti6jk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905110735.asgsyjygsrxti6jk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 02:07:35PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 05, 2021 at 01:47:51PM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 05, 2021 at 01:31:25PM +0300, Vladimir Oltean wrote:
> > > On Sun, Sep 05, 2021 at 01:25:03PM +0300, Leon Romanovsky wrote:
> > > > On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> > > > > On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > > > > > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> > 
> > <...>
> > 
> > > > That sentence means that your change is OK and you did it right by not
> > > > changing devlink port to hold not-working ports.
> > > 
> > > You're with me so far.
> > > 
> > > There is a second part. The ports with 'status = "disabled"' in the
> > > device tree still get devlink ports registered, but with the
> > > DEVLINK_PORT_FLAVOUR_UNUSED flavour and no netdev. These devlink ports
> > > still have things like port regions exported.
> > > 
> > > What we do for ports that have failed to probe is to reinit their
> > > devlink ports as DEVLINK_PORT_FLAVOUR_UNUSED, and their port regions, so
> > > they effectively behave as though they were disabled in the device tree.
> > 
> > Yes, and this part require DSA knowledge that I don't have, because you
> > suggest fallback for any error during devlink port register,
> 
> Again, fallback but not during devlink port register. The devlink port
> was registered just fine, but our plans changed midway. If you want to
> create a net device with an associated devlink port, first you need to
> create the devlink port and then the net device, then you need to link
> the two using devlink_port_type_eth_set, at least according to my
> understanding.
> 
> So the failure is during the creation of the **net device**, we now have a
> devlink port which was originally intended to be of the Ethernet type
> and have a physical flavour, but it will not be backed by any net device,
> because the creation of that just failed. So the question is simply what
> to do with that devlink port.

I lost you here, from known to me from the NIC, the **net devices** are
created with devlink_alloc() API call and devlink_port_register comes
later. It means that net device is created (or not) before devlink port
code.

Anyway, it is really not important to me as long as changes won't touch
net/core/devlink.c.

Thanks
