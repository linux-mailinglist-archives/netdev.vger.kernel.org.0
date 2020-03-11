Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B3181592
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgCKKMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgCKKMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 06:12:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989822071B;
        Wed, 11 Mar 2020 10:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583921574;
        bh=NE4BXmUrGZkTZWZLEq+5Vk64hBuIHGYpS8uyjzAZI4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHMg/Eh7Skd2GdhxhF7f3stALbPKzVS3T4/ruJQJY0cZYnu8OeaA4kLiK2FlRKu12
         J71ZjG16k9i0hoVIhiZcO6342QhSo0Hc5my97/NWRUtVVP7ZeEtWr7GQXOYGN97gQy
         8zNECYF9Ooo5mAR7rxSz6pzSJMbC9iwsgBNOZFFs=
Date:   Wed, 11 Mar 2020 12:12:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
Message-ID: <20200311101250.GI4215@unreal>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
 <20200310192111.GC11247@lunn.ch>
 <CA+sq2CeTFZdH60MS1fPhfTJjSJFCn2wY6iPH+VvuLSHzkApB-w@mail.gmail.com>
 <20200311070549.GG4215@unreal>
 <CA+sq2Cdec8orZVbZhH3VVHkkM48yF7-62u4cWas6gtaMgpSbzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2Cdec8orZVbZhH3VVHkkM48yF7-62u4cWas6gtaMgpSbzA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:48:13PM +0530, Sunil Kovvuri wrote:
> On Wed, Mar 11, 2020 at 12:35 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Mar 11, 2020 at 12:09:45PM +0530, Sunil Kovvuri wrote:
> > > On Wed, Mar 11, 2020 at 12:51 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > On Wed, Mar 11, 2020 at 12:17:23AM +0530, sunil.kovvuri@gmail.com wrote:
> > > > > +int __weak otx2vf_open(struct net_device *netdev)
> > > > > +{
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > > +int __weak otx2vf_stop(struct net_device *netdev)
> > > > > +{
> > > > > +     return 0;
> > > > > +}
> > > >
> > > > Hi Sunil
> > > >
> > > > weak symbols are very unusual in a driver. Why are they required?
> > > >
> > > > Thanks
> > > >         Andrew
> > >
> > > For ethtool configs which need interface reinitialization of interface
> > > we need to either call PF or VF open/close fn()s.
> > > If VF driver is not compiled in, then PF driver compilation will fail
> > > without these weak symbols.
> > > They are there just for compilation purpose, no other use.
> >
> > It doesn't make sense, your PF driver should be changed to allow
> > compilation with those empty functions.
> >
> > Thanks
> >
>
> I didn't get, if VF driver is not compiled in then there are no
> otx2vf_open/stop fn()s defined.
> Either i have add weak fn()s or add empty ones based on VF CONFIG
> option, anyother option ?

I have no access to your implementation. But in general case:
If those fn() are accessed through pointer ->fn(), you need add
checks like this "if (..>fn) ..->fn()". If you call directly, add
empty declarations in the .h and enable them in case VF is not compiled.

Thanks

>
> Thanks,
> Sunil.
