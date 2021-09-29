Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EAB41C5AE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344211AbhI2NdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344140AbhI2NdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F025361353;
        Wed, 29 Sep 2021 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632922287;
        bh=4kqcE1aNtIBzl/VT1ZDAblog8iS58Q0lddZNm7GgSCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SZ8dB8LzwxAdqXC1m2OXAEMZzMhv3h5pCU9yzZGJSY03eiBtRFTdyQPv8zwBkQw7d
         UQZ6imjJuGz/d0EuNtTGG18qvWsl5tes5WByD9Rgd+Oef4IUV1EXrf20/l41kfjhsC
         aBcMvZOBUb5xWkBmsly4qtNoJDTfErITYYjFl4a6eJ6Cv4VQ9NGSVvnoK0PtnrGmkN
         XXWqr/FoFjTtk7LAqC2LoziwRLp1Bev15ReOmR3ESoYGwwM3aSieTYBpg0e3Zav41j
         MfyfiNDFS0Fry1r4jTI3RDvjc6PqFHvfpYcfINJstT1Gp/K6JTniJ6UyHuxBj7Z87y
         XE05g6+3Qvv4w==
Date:   Wed, 29 Sep 2021 06:31:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
Message-ID: <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163290399584.3047.8100336131824633098@kwain>
References: <20210928125500.167943-1-atenart@kernel.org>
        <20210928125500.167943-9-atenart@kernel.org>
        <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <163290399584.3047.8100336131824633098@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 10:26:35 +0200 Antoine Tenart wrote:
> Quoting Jakub Kicinski (2021-09-29 02:02:29)
> > On Tue, 28 Sep 2021 14:54:59 +0200 Antoine Tenart wrote: =20
> > > The sysfs removal is done in device_del, and moving it outside of the
> > > rtnl lock does fix the initial deadlock. With that the trylock/restart
> > > logic can be removed in a following-up patch. =20
> >  =20
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index a1eab120bb50..d774fbec5d63 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -10593,6 +10593,8 @@ void netdev_run_todo(void)
> > >                       continue;
> > >               }
> > > =20
> > > +             device_del(&dev->dev);
> > > +
> > >               dev->reg_state =3D NETREG_UNREGISTERED;
> > > =20
> > >               netdev_wait_allrefs(dev);
> > > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > > index 21c3fdeccf20..e754f00c117b 100644
> > > --- a/net/core/net-sysfs.c
> > > +++ b/net/core/net-sysfs.c
> > > @@ -1955,8 +1955,6 @@ void netdev_unregister_kobject(struct net_devic=
e *ndev)
> > >       remove_queue_kobjects(ndev);
> > > =20
> > >       pm_runtime_set_memalloc_noio(dev, false);
> > > -
> > > -     device_del(dev);
> > >  }
> > > =20
> > >  /* Create sysfs entries for network device. */ =20
> >=20
> > Doesn't this mean there may be sysfs files which are accessible=20
> > for an unregistered netdevice? =20
>=20
> It would mean having accessible sysfs files for a device in the
> NETREG_UNREGISTERING state; NETREG_UNREGISTERED still comes after
> device_del. It's a small difference but still important, I think.
>=20
> You raise a good point. Yes, that would mean accessing attributes of net
> devices being unregistered, meaning accessing or modifying unused or
> obsolete parameters and data (it shouldn't be garbage data though).
> Unlisting those sysfs files without removing them would be better here,
> to not expose files when the device is being unregistered while still
> allowing pending operations to complete. I don't know if that is doable
> in sysfs.

I wonder. Do we somehow remove the queue objects without waiting or are
those also waited on when we remove the device? 'Cause XPS is the part
that jumps out to me - we reset XPS after netdev_unregister_kobject().
Does it mean user can re-instate XPS settings after we thought we
already reset them?

> (While I did ran stress tests reading/writing attributes while
> unregistering devices, I think I missed an issue with the
> netdev_queue_default attributes; which hopefully can be fixed =E2=80=94 i=
f the
> whole idea is deemed acceptable).

Well, it's a little wobbly but I think the direction is sane.
It wouldn't feel super clean to add

	if (dev->state !=3D NETREG_REGISTERED)
		goto out;

to the sysfs handlers but maybe it's better than leaving potential
traps for people who are not aware of the intricacies later? Not sure.

> > Isn't the point of having device_del() under rtnl_lock() to make sure
> > we sysfs handlers can't run on dead devices? =20
>=20
> Hard to say what was the initial point, there is a lot of history here
> :) I'm not sure it was done because of a particular reason; IMHO it just
> made sense to make this simple without having a good reason not to do
> so. And it helped with the naming collision detection.

FWIW the other two pieces of feedback I have is try to avoid the
synchronize_net() in patch 7 and add a new helper for the name
checking, which would return bool. The callers don't have any=20
business getting the struct.
