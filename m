Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE3421A0E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhJDWcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235700AbhJDWcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 18:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41C161058;
        Mon,  4 Oct 2021 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633386622;
        bh=GnU+ACh3ikWReIYS292sllZht7HNrIJBFVq0DlI76i8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ceFHS0ufrxP6kmB3Q74ahWQgaxqoocRjgkRNpfygBq643i8CuZk/OrOi8YPBSsxkH
         93R7dm8zvPNHlpQNPRLEv4dZyrb7XqJ3ClqAZG6caSwEAtB+Go1t9+9vn/slDmBowq
         Hjx+IBqvISfJkPQ63IF+y6OSqCg8y0uGQA+aPOFIv6Zp/XSgEqjjRVWgY73s3mfC2Z
         +uWiogaiNS2/DhrZa6zkh78gxBJj7CbtLxD0lWzIt8bMsNYNl3YcDRbBKoO6SHyZY4
         cA7dTGZy3U4xThX0BnnWpDfPSHoAVIeoYovfNUQ8KpmbYZTJ50UxwjhL+iGFD3Dnf7
         s8JVrANYxS0iA==
Message-ID: <b335852ecaba3c86d1745b5021bb500798fc843b.camel@kernel.org>
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Date:   Mon, 04 Oct 2021 15:30:21 -0700
In-Reply-To: <YVsWyO3Fa5RC0hRh@lunn.ch>
References: <20210929155334.12454-1-shenjian15@huawei.com>
         <20211001151710.20451-1-alexandr.lobakin@intel.com>
         <YVsWyO3Fa5RC0hRh@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-10-04 at 16:59 +0200, Andrew Lunn wrote:
> On Fri, Oct 01, 2021 at 05:17:10PM +0200, Alexander Lobakin wrote:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Wed, 29 Sep 2021 23:50:47 +0800
> > 
> > Hi,
> > 
> > > For the prototype of netdev_features_t is u64, and the number
> > > of netdevice feature bits is 64 now. So there is no space to
> > > introduce new feature bit.
> > > 
> > > This patchset try to solve it by change the prototype of
> > > netdev_features_t from u64 to bitmap. With this change,
> > > it's necessary to introduce a set of bitmap operation helpers
> > > for netdev features. Meanwhile, the functions which use
> > > netdev_features_t as return value are also need to be changed,
> > > return the result as an output parameter.
> > > 
> > > With above changes, it will affect hundreds of files, and all the
> > > nic drivers. To make it easy to be reviewed, split the changes
> > > to 167 patches to 5 parts.
> > 
> > If you leave the current feature field set (features, hw_features
> > etc.) as is and just add new ones as bitmaps -- I mean, to place
> > only newly added features there -- you won't have to change this in
> > hundreds of drivers.
> 
> That makes things messy for the future. Two different ways to express
> the same thing. And it is a trap waiting for developers to fall
> into. Is this a new feature or an old feature bit? Should i add it to
> the old or new bitmap? Will the compiler error out if i get it wrong,
> or silently accept it?
> 
> > Another option is to introduce new fields as bitmaps and mirror all
> > features there, but also keep the current ones. This implies some
> > code duplication -- to keep both sets in sync -- but it will also
> > allow to avoid such diffstats. Developers could switch their
> > drivers
> > one-by-one then, and once they finish converting,
> 
> Which will never happen. Most developers will say, why bother, it
> works as it is, i'm too lazy. And many drivers don't have an active
> developer, and so won't get converted.
> 
> Yes it is a big patchset, but at the end, we get a uniform API which
> is future proof, and no traps waiting for developers to fall into.
> 

I agree, i had to visit this topic a year ago or so, and the only
conclusion was is to solve this the hard way, introduce a totally new
mechanism, the safest way is to remove old netdev_features_t fields
from netdev and add new ones (both names and types), so compiler will
catch you if you missed to convert a place.

maybe hide the implementation details and abstract it away from drivers
using getters and manipulation APIs, it is not that bad since drivers
are already not supposed to modify netdev_features directly.


>    Andrew


