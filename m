Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE53422E24
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhJEQlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhJEQln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B7726152B;
        Tue,  5 Oct 2021 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633451992;
        bh=ts7EteHdxq8C5HyCvv7tWtTnhLphL4XbdSJgeQJjSfY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SdHv5Ka9A5k0GFbt5gLOyv36CoCPyR8NFNlc5wHgrxvUlcpxYUQzPNUV+vWkzJNqn
         +RDZ1Uhf//HaqmkOWuE58SIVzU0nmP9CF1QaPRfljpjt2jwUsIgIO5Q1RP+44PTQbJ
         vOUSBWZpmEMhSfUx2bZngTCrphVYd37jB/SSAbrT1cqKjANGN7HD55yy7/pXVT6xGA
         lFv0V6VSMfXSEO5sga3Wfn7K+4I5coXtHHPV0XEFL+1AK7V6Yj/rP3Xh4KkyYIKVoU
         xjyvBA6OPhuCLzgX8wMweyTpXHXDpxVS/KGA4xUaTKmJPSmv4LmHy3UyJkS8QSnri3
         Uy/w+lMQkymxg==
Received: by mail-ed1-f46.google.com with SMTP id dj4so1170228edb.5;
        Tue, 05 Oct 2021 09:39:52 -0700 (PDT)
X-Gm-Message-State: AOAM530AwIrp0BTLkh5lwKNvH8f9+/8yCUnkDdmL2/5ZNPc+q0rfydUZ
        PRhxrdsOVK39j/mfE9eCq9RMF4Gu99TpbcShDQ==
X-Google-Smtp-Source: ABdhPJwUQ5Jwd09cY5XEfoQtJBd0KhjftcMfY1ZORPOmsPUZ04JWmSJ5oJkOkvsQfYlsCbk1EyDW4H8SirqUZI7TTIY=
X-Received: by 2002:a17:906:e089:: with SMTP id gh9mr25568466ejb.320.1633451990911;
 Tue, 05 Oct 2021 09:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211005155321.2966828-1-kuba@kernel.org> <20211005155321.2966828-2-kuba@kernel.org>
 <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com> <20211005092956.44eb4d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211005092956.44eb4d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 5 Oct 2021 11:39:39 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLGtfQgpVqSGN-HsTmeRQnbZ0vrOv2y6PprPx373-tVfg@mail.gmail.com>
Message-ID: <CAL_JsqLGtfQgpVqSGN-HsTmeRQnbZ0vrOv2y6PprPx373-tVfg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] of: net: add a helper for loading netdev->dev_addr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 11:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 5 Oct 2021 11:15:48 -0500 Rob Herring wrote:
> > On Tue, Oct 5, 2021 at 10:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > > of VLANs...") introduced a rbtree for faster Ethernet address look
> > > up. To maintain netdev->dev_addr in this tree we need to make all
> > > the writes to it got through appropriate helpers.
> > >
> > > There are roughly 40 places where netdev->dev_addr is passed
> > > as the destination to a of_get_mac_address() call. Add a helper
> > > which takes a dev pointer instead, so it can call an appropriate
> > > helper.
> > >
> > > Note that of_get_mac_address() already assumes the address is
> > > 6 bytes long (ETH_ALEN) so use eth_hw_addr_set().
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > >  drivers/of/of_net.c    | 25 +++++++++++++++++++++++++
> >
> > Can we move this file to drivers/net/ given it's always merged via the
> > net tree? It's also the only thing left not part of the driver
> > subsystems.
>
> Hm, our driver core historically lives under net/core, not drivers/net,
> how about drivers/of/of_net.c -> net/core/of_net.c ?

Sure.

Rob
