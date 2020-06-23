Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E063F205DC8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389442AbgFWUQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389427AbgFWUQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB322064B;
        Tue, 23 Jun 2020 20:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943390;
        bh=gDGnvZfZxG08b9wvGhCaBJiEgiArLyhOEhwuqh+/4Xg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9UwVHOwGJuOhYMiSxOJo8XDSMmeGgWKrc0Uz3JBUaLR4LA6LbHi7+Oi+JfJLfcaq
         pKB2NjOEMM3KUgJf9UswWdLF53hl6JjKFdIhEfegfP+IvdJWnRd/j9XnlTSz2f0k02
         fsulvyWw9rlpOsS0WvtokvCV2JlEajVWPOdNF6KA=
Date:   Tue, 23 Jun 2020 13:16:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-doc <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 03/11] net: devres: relax devm_register_netdev()
Message-ID: <20200623131628.232ec75e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMRc=MfF1RbQCJ62QhscFLu1HKYRc9M-2SMep1_vTJ2xhKjLAA@mail.gmail.com>
References: <20200622100056.10151-1-brgl@bgdev.pl>
        <20200622100056.10151-4-brgl@bgdev.pl>
        <20200622154943.02782b5a@kicinski-fedora-PC1C0HJN>
        <CAMRc=MfF1RbQCJ62QhscFLu1HKYRc9M-2SMep1_vTJ2xhKjLAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 11:12:24 +0200 Bartosz Golaszewski wrote:
> wt., 23 cze 2020 o 00:49 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
> > On Mon, 22 Jun 2020 12:00:48 +0200 Bartosz Golaszewski wrote: =20
> > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > >
> > > This devres helper registers a release callback that only unregisters
> > > the net_device. It works perfectly fine with netdev structs that are
> > > not managed on their own. There's no reason to check this - drop the
> > > warning.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com> =20
> >
> > I think the reasoning for this suggestion was to catch possible UAF
> > errors. The netdev doesn't necessarily has to be from devm_alloc_*
> > but it has to be part of devm-ed memory or memory which is freed
> > after driver's remove callback.
> > =20
>=20
> Yes I understand that UAF was the concern here, but this limitation is
> unnecessary. In its current form devm_register_netdev() only works for
> struct net_device allocated with devm_alloc_etherdev(). Meanwhile
> calling alloc_netdev() (which doesn't have its devm counterpart yet -
> I may look into it shortly),

If resource managed alloc_netdev() is needed devm_alloc_netdev() can
be created, and even reuse devm_free_netdev() so no changes to the
warning are even necessary for such extension.

> then registering a devm action with devm_add_action_or_reset() which
> would free this memory is a perfectly fine use case. This patch would
> make it possible.

alloc_netdev() + devm_add_action makes no sense in the upstream kernel,
just add the appropriate helper, we care little about out of tree code.

> > Are there cases in practice where you've seen the netdev not being
> > devm allocated? =20
>=20
> As I said above - alloc_netdev() used by wireless, can, usb etc.
> drivers doesn't have a devres variant.


