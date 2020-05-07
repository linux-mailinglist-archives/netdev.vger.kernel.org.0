Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D321D1C96E6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEGQxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgEGQxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 12:53:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA13720870;
        Thu,  7 May 2020 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588870398;
        bh=NujDvlsKX4AJIFdjy/ZhQD238Qri2e97mGwjx7CIqAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JlpUvKEn0HsL1QzZ6h0GinpcwY43KR9GznAQ+FL4QesMiCkMJw93GU5TwBvOCIFlz
         oDiB+OAbY87TeFnWWySAZIX6SU7tU2T9wJTNWj2i7/rl5S7c6osUw7TFtna6K9D1mG
         wfTQmnKlhMMMYAIGnBkzPrnxLqDRRPiR4meHNTtg=
Date:   Thu, 7 May 2020 09:53:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
Message-ID: <20200507095315.1154a1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-6-brgl@bgdev.pl>
        <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
        <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 11:25:01 +0200 Bartosz Golaszewski wrote:
> =C5=9Br., 6 maj 2020 o 19:12 Jakub Kicinski <kuba@kernel.org> napisa=C5=
=82(a):
> >
> > On Wed, 6 May 2020 08:39:47 +0200 Bartosz Golaszewski wrote: =20
> > > wt., 5 maj 2020 o 19:31 Jakub Kicinski <kuba@kernel.org> napisa=C5=82=
(a): =20
> > > >
> > > > On Tue,  5 May 2020 16:02:25 +0200 Bartosz Golaszewski wrote: =20
> > > > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > > >
> > > > > Provide devm_register_netdev() - a device resource managed variant
> > > > > of register_netdev(). This new helper will only work for net_devi=
ce
> > > > > structs that have a parent device assigned and are devres managed=
 too.
> > > > >
> > > > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com> =20
> > > > =20
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index 522288177bbd..99db537c9468 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *dev)
> > > > >  }
> > > > >  EXPORT_SYMBOL(register_netdev);
> > > > >
> > > > > +struct netdevice_devres {
> > > > > +     struct net_device *ndev;
> > > > > +}; =20
> > > >
> > > > Is there really a need to define a structure if we only need a poin=
ter?
> > > > =20
> > >
> > > There is no need for that, but it really is more readable this way.
> > > Also: using a pointer directly doesn't save us any memory nor code
> > > here. =20
> >
> > I don't care either way but devm_alloc_etherdev_mqs() and co. are using
> > the double pointer directly. Please make things consistent. Either do
> > the same, or define the structure in some header and convert other
> > helpers to also make use of it. =20
>=20
> In order to use devres_find() to check if struct net_device is managed
> in devm_register_netdev() I need to know the address of the release
> function used by devm_alloc_etherdev_mqs(). Do you mind if I move all
> networking devres routines (currently only devm_alloc_etherdev_mqs())
> into a separate .c file (e.g. under net/devres.c)?

To implement Edwin's suggestion? Makes sense, but I'm no expert, let's
also CC Heiner since he was asking about it last time.
