Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C68C41C0A5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244607AbhI2I2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240284AbhI2I2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 04:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 468D3613A5;
        Wed, 29 Sep 2021 08:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632903998;
        bh=zcwTKHO6w9fYFC5HwTtloM/uxPFwyGcKJAj7tHHknJA=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=XDwExBAH0SIGxJ39MoIwBtr9xHW9RfC2HW4/oqUcwGru5VDoWtTtKHFKxV21wdhEZ
         eHPv8oG74TmG6hRGytAxYZRexjTjcvUqBwK3nc3cnndy8Bdbh51oCJHOLUGpO3irls
         ek95H6V2U0nMFJasp/HjE9lyNF8ToqdO0b00iWLaZIanKgQOM0Jgql4buh5CMk0Oex
         KBDDAJApMgUoIPnPiaK7eDQ43EYbMVPTez840AMytYU9jsWXKQvZ+aQC+HyCgXjJZL
         qBD/e/bkOfiZSCPDRz94eWTrimeHIcrDXH2loQSdvNdMm9KZDd3ASgV2IODNmV1uRP
         JkpzMBdNTy2CA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210928125500.167943-1-atenart@kernel.org> <20210928125500.167943-9-atenart@kernel.org> <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
Message-ID: <163290399584.3047.8100336131824633098@kwain>
Date:   Wed, 29 Sep 2021 10:26:35 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-09-29 02:02:29)
> On Tue, 28 Sep 2021 14:54:59 +0200 Antoine Tenart wrote:
> > The sysfs removal is done in device_del, and moving it outside of the
> > rtnl lock does fix the initial deadlock. With that the trylock/restart
> > logic can be removed in a following-up patch.
>=20
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index a1eab120bb50..d774fbec5d63 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -10593,6 +10593,8 @@ void netdev_run_todo(void)
> >                       continue;
> >               }
> > =20
> > +             device_del(&dev->dev);
> > +
> >               dev->reg_state =3D NETREG_UNREGISTERED;
> > =20
> >               netdev_wait_allrefs(dev);
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index 21c3fdeccf20..e754f00c117b 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -1955,8 +1955,6 @@ void netdev_unregister_kobject(struct net_device =
*ndev)
> >       remove_queue_kobjects(ndev);
> > =20
> >       pm_runtime_set_memalloc_noio(dev, false);
> > -
> > -     device_del(dev);
> >  }
> > =20
> >  /* Create sysfs entries for network device. */
>=20
> Doesn't this mean there may be sysfs files which are accessible=20
> for an unregistered netdevice?

It would mean having accessible sysfs files for a device in the
NETREG_UNREGISTERING state; NETREG_UNREGISTERED still comes after
device_del. It's a small difference but still important, I think.

You raise a good point. Yes, that would mean accessing attributes of net
devices being unregistered, meaning accessing or modifying unused or
obsolete parameters and data (it shouldn't be garbage data though).
Unlisting those sysfs files without removing them would be better here,
to not expose files when the device is being unregistered while still
allowing pending operations to complete. I don't know if that is doable
in sysfs.

(While I did ran stress tests reading/writing attributes while
unregistering devices, I think I missed an issue with the
netdev_queue_default attributes; which hopefully can be fixed =E2=80=94 if =
the
whole idea is deemed acceptable).

> Isn't the point of having device_del() under rtnl_lock() to make sure
> we sysfs handlers can't run on dead devices?

Hard to say what was the initial point, there is a lot of history here
:) I'm not sure it was done because of a particular reason; IMHO it just
made sense to make this simple without having a good reason not to do
so. And it helped with the naming collision detection.

Thanks!
Antoine
