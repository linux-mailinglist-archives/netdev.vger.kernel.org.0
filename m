Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405451AB334
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371399AbgDOVMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 17:12:42 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:38226 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371387AbgDOVMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 17:12:40 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 498802D1;
        Wed, 15 Apr 2020 23:12:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1586985152;
        bh=6ZsvRs7bRQKm2uUaVr3nSLa1kHFG0xzNrbDdN57gCCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Asq687MHzIHKq43berIYmZ59aeoEo+vMV3L0Kmj60d9CPYdYFrSOTpzamKOx7ty4P
         RovcFHD6tSHE6LH/oKFii6xcTJvMhpSzgSQSO/AwUu9TmSH0HB8/5jwj5kQHQpGG3I
         HaqY0Wr/aUbcwlF7mJE34yCw4xZy4KOu4ykEJTyI=
Date:   Thu, 16 Apr 2020 00:12:20 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
Message-ID: <20200415211220.GQ4758@pendragon.ideasonboard.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
 <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com>
 <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com>
 <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
 <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
 <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
 <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Wed, Apr 15, 2020 at 09:07:14PM +0200, Arnd Bergmann wrote:
> On Wed, Apr 15, 2020 at 5:18 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wed, Apr 15, 2020 at 4:13 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > > > Doesn't "imply" mean it gets selected by default but can be manually
> > > > > disabled ?
> > > >
> > > > That may be what it means now (I still don't understand how it's defined
> > > > as of v5.7-rc1), but traditionally it was more like a 'select if all
> > > > dependencies are met'.
> > >
> > > That's still what it is supposed to mean right now ;-)
> > > Except that now it should correctly handle the modular case, too.
> >
> > Then there is a bug. If I run 'make menuconfig' now on a mainline kernel
> > and enable CONFIG_DRM_RCAR_DU, I can set
> > DRM_RCAR_CMM and DRM_RCAR_LVDS to 'y', 'n' or 'm' regardless
> > of whether CONFIG_DRM_RCAR_DU is 'm' or 'y'. The 'implies'
> > statement seems to be ignored entirely, except as reverse 'default'
> > setting.
> 
> Here is another version that should do what we want and is only
> half-ugly. I can send that as a proper patch if it passes my testing
> and nobody hates it too much.

This may be a stupid question, but doesn't this really call for fixing
Kconfig ? This seems to be such a common pattern that requiring
constructs similar to the ones below will be a never-ending chase of
offenders.

> diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
> index 0919f1f159a4..d2fcec807dfa 100644
> --- a/drivers/gpu/drm/rcar-du/Kconfig
> +++ b/drivers/gpu/drm/rcar-du/Kconfig
> @@ -4,8 +4,6 @@ config DRM_RCAR_DU
>         depends on DRM && OF
>         depends on ARM || ARM64
>         depends on ARCH_RENESAS || COMPILE_TEST
> -       imply DRM_RCAR_CMM
> -       imply DRM_RCAR_LVDS
>         select DRM_KMS_HELPER
>         select DRM_KMS_CMA_HELPER
>         select DRM_GEM_CMA_HELPER
> @@ -14,13 +12,17 @@ config DRM_RCAR_DU
>           Choose this option if you have an R-Car chipset.
>           If M is selected the module will be called rcar-du-drm.
> 
> -config DRM_RCAR_CMM
> -       tristate "R-Car DU Color Management Module (CMM) Support"
> -       depends on DRM && OF
> +config DRM_RCAR_USE_CMM
> +       bool "R-Car DU Color Management Module (CMM) Support"
>         depends on DRM_RCAR_DU
> +       default DRM_RCAR_DU
>         help
>           Enable support for R-Car Color Management Module (CMM).
> 
> +config DRM_RCAR_CMM
> +       def_tristate DRM_RCAR_DU
> +       depends on DRM_RCAR_USE_CMM
> +
>  config DRM_RCAR_DW_HDMI
>         tristate "R-Car DU Gen3 HDMI Encoder Support"
>         depends on DRM && OF
> @@ -28,15 +30,20 @@ config DRM_RCAR_DW_HDMI
>         help
>           Enable support for R-Car Gen3 internal HDMI encoder.
> 
> -config DRM_RCAR_LVDS
> -       tristate "R-Car DU LVDS Encoder Support"
> -       depends on DRM && DRM_BRIDGE && OF
> +config DRM_RCAR_USE_LVDS
> +       bool "R-Car DU LVDS Encoder Support"
> +       depends on DRM_BRIDGE && OF
> +       default DRM_RCAR_DU
>         select DRM_PANEL
>         select OF_FLATTREE
>         select OF_OVERLAY
>         help
>           Enable support for the R-Car Display Unit embedded LVDS encoders.
> 
> +config DRM_RCAR_LVDS
> +       def_tristate DRM_RCAR_DU
> +       depends on DRM_RCAR_USE_LVDS
> +
>  config DRM_RCAR_VSP
>         bool "R-Car DU VSP Compositor Support" if ARM
>         default y if ARM64

-- 
Regards,

Laurent Pinchart
