Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692251AA994
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636499AbgDOONw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:13:52 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36991 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2636464AbgDOONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:13:40 -0400
Received: by mail-oi1-f193.google.com with SMTP id r25so3688150oij.4;
        Wed, 15 Apr 2020 07:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Gt7M+RuQIzyJOeJqT0MWmg4GB8D71MVJXJNFoJPodE=;
        b=kUd/Xa/FC50VWPa21LftEpFTamN5dQ+OQNYWc7HISdQRVAA5uEdwRCjFIFUZa2Tx22
         Cqi1jCWR+DbzrZJzhv7v2KHFTn1EqZJd+diChuv2WDUJnp5N63L5LsqIPsBmEJEs3r8n
         2G7BJ/byOeoN6mzUaxMGW6zcLVZAWV1yS2/tMrJhHXYP8KJA72z+Ers6dzL7m5EVpSR6
         Z7XsPIOc5OsHNOL0oDqvCNDe9gZIFP9en2yFNUqc9lN4WkSUxo7+dZYwNxE13E+dPcfA
         DscVdL+GtYY1EnnuFKWGiR+Zs7V/iLSzMJoScZ7kTq9ekVNoKc8uJTnGentlszFCAq/I
         Mxbg==
X-Gm-Message-State: AGi0Pub5KogBU3xeumkh9EzDs3LnAhRVnYXuTXpmqHSNMvyFQbeziu82
        BI+UTqKBCDF7gdvspB3UY9Dj58MXQtaElYnNKG4=
X-Google-Smtp-Source: APiQypJKNPStH9WvUHy2DqrB/2o9qQW0DQSnNK10fBvROlIKHk1iOoMOZcjvqUv1TgYjO2VVubUEuQoTiK4tig++zrg=
X-Received: by 2002:aca:f541:: with SMTP id t62mr4667388oih.148.1586960018814;
 Wed, 15 Apr 2020 07:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com> <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com> <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Apr 2020 16:13:27 +0200
Message-ID: <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > On Tue, Apr 14, 2020 at 10:38:27PM +0200, Arnd Bergmann wrote:
> > > On Tue, Apr 14, 2020 at 10:17 PM Laurent Pinchart wrote:
> > > > On Wed, Apr 08, 2020 at 10:27:10PM +0200, Arnd Bergmann wrote:
> > > > > The 'imply' statement does not seem to have an effect, as it's
> > > > > still possible to turn the CMM code into a loadable module
> > > > > in a randconfig build, leading to a link error:
> > > > >
> > > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
> > > > > rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
> > > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
> > > > > rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
> > > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
> > > > > rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
> > > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':
> > > > >
> > > > > Remove the 'imply', and instead use a silent symbol that defaults
> > > > > to the correct setting.
> > > >
> > > > This will result in the CMM always being selected when DU is, increasing
> > > > the kernel size even for devices that don't need it. I believe we need a
> > > > better construct in Kconfig to fix this.
> > >
> > > I had expected this to have the same meaning that we had before the
> > > Kconfig change: whenever the dependencies are available, turn it on,
> > > otherwise leave it disabled.
> > >
> > > Can you describe what behavior you actually want instead?
> >
> > Doesn't "imply" mean it gets selected by default but can be manually
> > disabled ?
>
> That may be what it means now (I still don't understand how it's defined
> as of v5.7-rc1), but traditionally it was more like a 'select if all
> dependencies are met'.

That's still what it is supposed to mean right now ;-)
Except that now it should correctly handle the modular case, too.

> > > > > --- a/drivers/gpu/drm/rcar-du/Kconfig
> > > > > +++ b/drivers/gpu/drm/rcar-du/Kconfig
> > > > > @@ -4,7 +4,6 @@ config DRM_RCAR_DU
> > > > >       depends on DRM && OF
> > > > >       depends on ARM || ARM64
> > > > >       depends on ARCH_RENESAS || COMPILE_TEST
> > > > > -     imply DRM_RCAR_CMM
> > > > >       imply DRM_RCAR_LVDS
> > > > >       select DRM_KMS_HELPER
> > > > >       select DRM_KMS_CMA_HELPER
> > > > > @@ -15,9 +14,8 @@ config DRM_RCAR_DU
> > > > >         If M is selected the module will be called rcar-du-drm.
> > > > >
> > > > >  config DRM_RCAR_CMM
> > > > > -     tristate "R-Car DU Color Management Module (CMM) Support"
> > > > > +     def_tristate DRM_RCAR_DU
> > > > >       depends on DRM && OF
> > > > > -     depends on DRM_RCAR_DU
> > > > >       help
> > >
> > > It would be easy enough to make this a visible 'bool' symbol and
> > > build it into the rcu-du-drm.ko module itself. Would that help you?
> >
> > That could indeed simplify a few things. I wonder if it could introduce
> > a few small issues though (but likely nothing we can't fix). The two
> > that come to mind are the fact that the module would have two
> > MODULE_DESCRIPTION and MODULE_LICENSE entries (I have no idea if that
> > could cause breakages), and that it could make module unloading more
> > difficult as the CMM being used by the DU would increase the refcount on
> > the module. I think the latter could be worked around by manually
> > unbinding the DU device through sysfs before unloading the module (and I
> > can't say for sure that unloading the DU module is not broken today
> > *innocent and naive look* :-)).
>
> In that case, a Makefile trick could also work, doing
>
> ifdef CONFIG_DRM_RCAR_CMM
> obj-$(CONFIG_DRM_RCAR_DU) += rcar-cmm.o
> endif
>
> Thereby making the cmm module have the same state (y or m) as
> the du module whenever the option is enabled.

What about dropping the "imply DRM_RCAR_CMM", but defaulting to
enable CMM if DU is enabled?

    config DRM_RCAR_CMM
            tristate "R-Car DU Color Management Module (CMM) Support"
            depends on DRM_RCAR_DU && OF
            default DRM_RCAR_DU

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
