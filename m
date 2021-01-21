Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A033D2FDF25
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390544AbhAUB6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392622AbhAUBrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 20:47:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F368823787;
        Thu, 21 Jan 2021 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611193617;
        bh=W5/3AC2yfn2lCVsrQNd2AD2k8/PUywVCig9YUj8JQ2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cx1ARenUGXcl6f18n/kFsvHLLK2Xm814LWXInoskTW8xbMbs0+Cg7PVaxHwcoIOCp
         X4MDY+8PUDr1sJsyzv950iyLLKOF6rXt2K9nnpUucB8bF37X9XCWDlkwZ/WOuj2GKg
         YdoJ05E10KrXQz703nlsiqCyA7pO+0LF/uV1c0eFAENofzHntiOOJ/GWz2d/t+YFtz
         iSPkslw1EAHYo9iPlg81bHnbNANfwSUJ1qFZdGmGGnl4Cai3LW3paZR5H3H4Y7feKg
         7CJExF4/eXFNTq/TJ1ZBYg+Mx2Ecig7TJkEFyRdOKlKca1oyaw1PGvqgWzFBR0bP3L
         Xj58noUuL5++Q==
Date:   Wed, 20 Jan 2021 17:46:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: set link down before enslave
Message-ID: <20210120174644.083de7fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120194328.GA2628348@shredder.lan>
References: <20210120102947.2887543-1-liuhangbin@gmail.com>
        <20210120104210.GA2602142@shredder.lan>
        <20210120143847.GI1421720@Leo-laptop-t470s>
        <20210120194328.GA2628348@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 21:43:28 +0200 Ido Schimmel wrote:
> On Wed, Jan 20, 2021 at 10:38:47PM +0800, Hangbin Liu wrote:
> > Hi Ido,
> > 
> > On Wed, Jan 20, 2021 at 12:42:10PM +0200, Ido Schimmel wrote:  
> > > > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > > > index c9ce3dfa42ee..a26fddc63992 100755
> > > > --- a/tools/testing/selftests/net/rtnetlink.sh
> > > > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > > > @@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
> > > >  	dev20=`ls ${sysfsnet}20/net/`
> > > >  
> > > >  	ip link add name test-bond0 type bond mode 802.3ad
> > > > +	ip link set dev $dev10 down
> > > > +	ip link set dev $dev20 down  
> > > 
> > > But these netdevs are created with their administrative state set to
> > > 'DOWN'. Who is setting them to up?  
> > 
> > Would you please point me where we set the state to 'DOWN'? Cause on my
> > host it is init as UP:
> > 
> > ++ ls /sys/bus/netdevsim/devices/netdevsim10/net/
> > + dev10=eth3
> > ++ ls /sys/bus/netdevsim/devices/netdevsim20/net/
> > + dev20=eth4
> > + ip link add name test-bond0 type bond mode 802.3ad
> > + ip link show eth3
> > 66: eth3: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
> >     link/ether 1e:52:27:5f:a5:3c brd ff:ff:ff:ff:ff:ff  
> 
> I didn't have time to look into this today, but I suspect the problem is
> either:
> 
> 1. Some interface manager on your end that is setting these interfaces
> up after they are created

This must be the case, the kernel doesn't open/up devices by itself.

> 2. A bug in netdevsim that does not initialize the carrier to off.
> Maybe try with this patch (didn't test):

Yeah, but that's fine, SW devices don't have to manage carrier state.
