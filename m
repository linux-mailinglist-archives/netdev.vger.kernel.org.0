Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864CB3D0B43
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 11:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhGUIVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhGUIJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 04:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB3716101E;
        Wed, 21 Jul 2021 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626857378;
        bh=bcbxbbHsQ9pjoa1FEe7JjQkgcYlrPgFnuJKkff5giIk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UBI145vRvDXfYUHg/f12v6/FLXGE1Mkna3ptF/OjspFE9Pl0dF8yp23fOgv9k/GIS
         sogcuooVWZg8cLcnwdnrhBCnLSeakIC6BzZGVA+yLWNmvN3rLJDr0dC510kQAvchnG
         FgKGq6P3kQGh+Tpzs+4hb1W+qMujfva/LcexD3tllz2GsZPcuDEtbIMEVc5GDjtHh4
         yNfa9C2rJvEo5+s5nDx7Y3O9yMF+bxM8DQW22a5yiT3busyyPb9SlyXEuhwyWzac+F
         Naxk9+uXxVMUSff6winepuIUeh+cvRzcl8EWA7j9gQ3bljkEhI4QdV15agsdNHgCFF
         QfRGw1Nsx3kaA==
Received: by mail-wr1-f44.google.com with SMTP id f9so1267712wrq.11;
        Wed, 21 Jul 2021 01:49:38 -0700 (PDT)
X-Gm-Message-State: AOAM53151+HrQkdPfw5CM75k/kBlyThMsHdRSL6iKegVqnUPnchHhaJw
        32Bixb11ctP7UjklNQStx0fFtCvJ1VblImGrfU4=
X-Google-Smtp-Source: ABdhPJxGxblIpkvuc/A470zotEk+ImLn63w5P8jXMhCHNlZ5sVMSsNifNuHYnRozD2q/w9aIWiTuq1IAgMSQKwJTg90=
X-Received: by 2002:a5d:438c:: with SMTP id i12mr41570814wrq.99.1626857377493;
 Wed, 21 Jul 2021 01:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210720144638.2859828-1-arnd@kernel.org> <20210720144638.2859828-17-arnd@kernel.org>
 <ef625966-9ff3-5daf-889b-232e420d9e65@linux.ibm.com>
In-Reply-To: <ef625966-9ff3-5daf-889b-232e420d9e65@linux.ibm.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Jul 2021 10:49:21 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1iOn4pzHXmd+NQnXpmqV9ebF5TdPb7_yUEutkeOgCGtg@mail.gmail.com>
Message-ID: <CAK8P3a1iOn4pzHXmd+NQnXpmqV9ebF5TdPb7_yUEutkeOgCGtg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 16/31] qeth: use ndo_siocdevprivate
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:06 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> On 20.07.21 17:46, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > qeth has both standard MII ioctls and custom SIOCDEVPRIVATE ones,
> > all of which work correctly with compat user space.
> >
> > Move the private ones over to the new ndo_siocdevprivate callback.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
>
> your get_maintainers scripting seems broken, adding the usual suspects.

Right, I ran the wrong script for sending.

> > -int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> > +int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
> >  {
> >       struct qeth_card *card = dev->ml_priv;
> > -     struct mii_ioctl_data *mii_data;
> >       int rc = 0;
> >
> >       switch (cmd) {
> >       case SIOC_QETH_ADP_SET_SNMP_CONTROL:
> > -             rc = qeth_snmp_command(card, rq->ifr_ifru.ifru_data);
> > +             rc = qeth_snmp_command(card, data);
> >               break;
> >       case SIOC_QETH_GET_CARD_TYPE:
> >               if ((IS_OSD(card) || IS_OSM(card) || IS_OSX(card)) &&
> >                   !IS_VM_NIC(card))
> >                       return 1;
> >               return 0;
> > +     case SIOC_QETH_QUERY_OAT:
> > +             rc = qeth_query_oat_command(card, data);
> > +             break;
> > +     default:
> > +             if (card->discipline->do_ioctl)
> > +                     rc = card->discipline->do_ioctl(dev, rq, data, cmd);
> > +             else
> > +                     rc = -EOPNOTSUPP;
> > +     }
> > +     if (rc)
> > +             QETH_CARD_TEXT_(card, 2, "ioce%x", rc);
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(qeth_siocdevprivate);
> > +
>
> Looks like you missed to wire this up in our netdev_ops structs.

Fixed now, thanks! I've gone through the other patches as well
to see if I made the same mistake elsewhere, but it appears this
one was the only time here.

       Arnd
