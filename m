Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787FD1C7781
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgEFRMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgEFRMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:12:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D802080D;
        Wed,  6 May 2020 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588785159;
        bh=Ku4krUxbTherJ1BmYQGERwCK85kJqmidRIcKAfQ+LUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bl45Xx9kN8e0nI9GisLHFuEbadb0UmmV/OXVRIFerYwtfJVsE3S16UNt3cKepxZhh
         tvvGIeKyNDcMwKISdVoioIUzWXNYKID7abt59NSW0pBsVWd0xkOofIu2LboxsTI6F0
         WYE7TUQyrQj6ZMojfQt96oGAkpCCCRZXKrVj1tXM=
Date:   Wed, 6 May 2020 10:12:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
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
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
Message-ID: <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-6-brgl@bgdev.pl>
        <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 08:39:47 +0200 Bartosz Golaszewski wrote:
> wt., 5 maj 2020 o 19:31 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
> >
> > On Tue,  5 May 2020 16:02:25 +0200 Bartosz Golaszewski wrote: =20
> > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > >
> > > Provide devm_register_netdev() - a device resource managed variant
> > > of register_netdev(). This new helper will only work for net_device
> > > structs that have a parent device assigned and are devres managed too.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com> =20
> > =20
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 522288177bbd..99db537c9468 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *dev)
> > >  }
> > >  EXPORT_SYMBOL(register_netdev);
> > >
> > > +struct netdevice_devres {
> > > +     struct net_device *ndev;
> > > +}; =20
> >
> > Is there really a need to define a structure if we only need a pointer?
> > =20
>=20
> There is no need for that, but it really is more readable this way.
> Also: using a pointer directly doesn't save us any memory nor code
> here.

I don't care either way but devm_alloc_etherdev_mqs() and co. are using
the double pointer directly. Please make things consistent. Either do
the same, or define the structure in some header and convert other
helpers to also make use of it.
