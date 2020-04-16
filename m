Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D011AC910
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504070AbgDPPSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:18:15 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42002 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442384AbgDPPSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:18:07 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 20E5497D;
        Thu, 16 Apr 2020 17:18:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1587050283;
        bh=kRV0TK76jaLsKumnRx9oBxQ+fB9EZ/hBhcVvcCrUN8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KunL1GHnZWE+ve/sOLaoFkAzYPKX6+/n+r78iuYJs7x5e+okkGATOqE6ApGMnuikF
         /2ayUcQFN/Z9UdwuSHJbBCZB/V8aA1w7KUzO09ROtISEFr9rEn/3j6xTfoHtnx7/rk
         eGxptalaFyRgrldUK2vtce1M8FhIp7rddugLnmJg=
Date:   Thu, 16 Apr 2020 18:17:51 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
Message-ID: <20200416151751.GD4796@pendragon.ideasonboard.com>
References: <20200414201739.GJ19819@pendragon.ideasonboard.com>
 <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com>
 <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
 <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
 <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
 <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com>
 <20200415211220.GQ4758@pendragon.ideasonboard.com>
 <CAK8P3a1rDZO4cuL6VAXgu9sOiedcHqOSL7ELhpvULz+YYRaGbA@mail.gmail.com>
 <CAKMK7uEoZ1jC8c25tPVX20kcdC1=+TpUUNyf+-c=sg5iK2cTZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKMK7uEoZ1jC8c25tPVX20kcdC1=+TpUUNyf+-c=sg5iK2cTZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 08:51:14AM +0200, Daniel Vetter wrote:
> On Wed, Apr 15, 2020 at 11:22 PM Arnd Bergmann wrote:
> > On Wed, Apr 15, 2020 at 11:12 PM Laurent Pinchart wrote:
> > > On Wed, Apr 15, 2020 at 09:07:14PM +0200, Arnd Bergmann wrote:
> > > > On Wed, Apr 15, 2020 at 5:18 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > > On Wed, Apr 15, 2020 at 4:13 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > > > On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > > > > On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > > > > > > Doesn't "imply" mean it gets selected by default but can be manually
> > > > > > > > disabled ?
> > > > > > >
> > > > > > > That may be what it means now (I still don't understand how it's defined
> > > > > > > as of v5.7-rc1), but traditionally it was more like a 'select if all
> > > > > > > dependencies are met'.
> > > > > >
> > > > > > That's still what it is supposed to mean right now ;-)
> > > > > > Except that now it should correctly handle the modular case, too.
> > > > >
> > > > > Then there is a bug. If I run 'make menuconfig' now on a mainline kernel
> > > > > and enable CONFIG_DRM_RCAR_DU, I can set
> > > > > DRM_RCAR_CMM and DRM_RCAR_LVDS to 'y', 'n' or 'm' regardless
> > > > > of whether CONFIG_DRM_RCAR_DU is 'm' or 'y'. The 'implies'
> > > > > statement seems to be ignored entirely, except as reverse 'default'
> > > > > setting.
> > > >
> > > > Here is another version that should do what we want and is only
> > > > half-ugly. I can send that as a proper patch if it passes my testing
> > > > and nobody hates it too much.
> > >
> > > This may be a stupid question, but doesn't this really call for fixing
> > > Kconfig ? This seems to be such a common pattern that requiring
> > > constructs similar to the ones below will be a never-ending chase of
> > > offenders.
> >
> > Maybe, I suppose the hardest part here would be to come up with
> > an appropriate name for the keyword ;-)
> >
> > Any suggestions?

Would it make sense to fix the imply semantics ? Or are they use cases
for the current behaviour of imply ? "recommend" could be another
keyword. I think we should try to limit the number of keywords though,
as it would otherwise become quite messy.

> > This specific issue is fairly rare though, in most cases the dependencies
> > are in the right order so a Kconfig symbol 'depends on' a second one
> > when the corresponding loadable module uses symbols from that second
> > module. The problem here is that the two are mixed up.
> >
> > The much more common problem is the one where one needs to
> > wrong
> >
> > config FOO
> >        depends on BAR || !BAR
> >
> > To ensure the dependency is either met or BAR is disabled, but
> > not FOO=y with BAR=m. If you have any suggestions for a keyword
> > for that thing, we can clean up hundreds of such instances.
> 
> Some ideas:
> 
> config FOO
>     can use  BAR
>     maybe BAR
>     optional BAR

Another idea,

	depends optionally on BAR

> We should probably double-check that this is only ever used for when
> both FOO and BAR are tri-state, since without that it doesn't make
> much sense.

-- 
Regards,

Laurent Pinchart
