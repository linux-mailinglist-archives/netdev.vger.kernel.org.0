Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA61B14E6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgDTSmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgDTSmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:42:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4802074F;
        Mon, 20 Apr 2020 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587408140;
        bh=J1Pz4saX9jEjbkW/1+ZB7lzOWI+VGAU8j2Mv8AfiHU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JsAB6+t1dHV6pvoNwy2P8v+KHnBGozzcYEBAsOqCqaQK7HENSdA/Epo8cuYKfdaeH
         UQmrYop56C28Q6adcFqTx4BaxJjZ9m7iZ1VJO4KIbv7oJr7VzX8Xfj1938D62gu5ay
         CxfzWhjJbvIpNgzF6SClWGl8oh09kyNCstcquWOI=
Date:   Mon, 20 Apr 2020 11:42:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        jonas@kwiboo.se, David Airlie <airlied@linux.ie>,
        jernej.skrabec@siol.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Message-ID: <20200420114218.30b373d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v9lu1ra6.fsf@intel.com>
References: <20200417011146.83973-1-saeedm@mellanox.com>
        <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
        <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr>
        <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
        <87v9lu1ra6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 11:43:13 +0300 Jani Nikula wrote:
> On Sun, 19 Apr 2020, Masahiro Yamada <masahiroy@kernel.org> wrote:
> > On Sun, Apr 19, 2020 at 4:11 AM Nicolas Pitre <nico@fluxnic.net> wrote:  
> >>
> >> On Sun, 19 Apr 2020, Masahiro Yamada wrote:
> >>  
> >> > (FOO || !FOO) is difficult to understand, but
> >> > the behavior of "uses FOO" is as difficult to grasp.  
> >>
> >> Can't this be expressed as the following instead:
> >>
> >>         depends on FOO if FOO
> >>
> >> That would be a little clearer.
> >>
> >>
> >> Nicolas  
> >
> > 'depends on' does not take the 'if <expr>'
> >
> > 'depends on A if B' is the syntax sugar of
> > 'depends on (A || !B), right ?
> >
> > I do not know how clearer it would make things.
> >
> > depends on (m || FOO != m)
> > is another equivalent, but we are always
> > talking about a matter of expression.
> >
> >
> > How important is it to stick to
> > depends on (FOO || !FOO)
> > or its equivalents?
> >
> >
> > If a driver wants to use the feature FOO
> > in most usecases, 'depends on FOO' is sensible.
> >
> > If FOO is just optional, you can get rid of the dependency,
> > and IS_REACHABLE() will do logically correct things.  
> 
> If by logically correct you mean the kernel builds, you're
> right. However the proliferation of IS_REACHABLE() is making the kernel
> config *harder* to understand. User enables FOO=m and expects BAR to use
> it, however if BAR=y it silently gets ignored. I have and I will oppose
> adding IS_REACHABLE() usage to i915 because it's just silently accepting
> configurations that should be flagged and forbidden at kconfig stage.

+1

I wholeheartedly agree. In case of Ethernet drivers having higher
layers of the stack not able to communicate with drivers is just 
broken IMHO.
