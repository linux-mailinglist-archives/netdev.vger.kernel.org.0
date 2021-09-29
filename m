Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D5F41CB18
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344343AbhI2Rdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244721AbhI2Rdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D609B60EE3;
        Wed, 29 Sep 2021 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632936719;
        bh=Q/fdWVX90LwZ97g+gyXrxHmMmJOch2UTWjX9oo13lUQ=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=YXWuyz7VLMUkzFxIWAQlnUrNNUQiGLWvvTAEZxa2m6Kczm8nS9G6xx/d8RCez3Muj
         BoyOxodNEd6xBFpmDOU3aUHYkPKBkmJopoco772kZgiYwrQ1XLiviocOzwr8O0gxUv
         xv260Q/7nMFswdAsWT95GpTxGQPVTTd0rLFbKJ0KGHZM9QMce1ooaK7dftheyW/4r3
         CcKSGOlQl1mIuRIT+EQ9WA5Fny4tARGOsJ3PQY+I0OUn6Wm8KUfbf0vNqR8OUoCdEt
         LCYD62Im125UGJBE5JzL01tOWEVX+yfzu9kUDFMKU2rf6GSRs8E0kg21kd8nnH3EMN
         A9bH89DfjF5Yw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210928125500.167943-1-atenart@kernel.org> <20210928125500.167943-9-atenart@kernel.org> <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163290399584.3047.8100336131824633098@kwain> <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
Message-ID: <163293671647.3047.7240482794798716272@kwain>
Date:   Wed, 29 Sep 2021 19:31:56 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-09-29 15:31:26)
> On Wed, 29 Sep 2021 10:26:35 +0200 Antoine Tenart wrote:
> > Quoting Jakub Kicinski (2021-09-29 02:02:29)
> > > On Tue, 28 Sep 2021 14:54:59 +0200 Antoine Tenart wrote: =20
> > > > The sysfs removal is done in device_del, and moving it outside of t=
he
> > > > rtnl lock does fix the initial deadlock. With that the trylock/rest=
art
> > > > logic can be removed in a following-up patch. =20
> > >  =20
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index a1eab120bb50..d774fbec5d63 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -10593,6 +10593,8 @@ void netdev_run_todo(void)
> > > >                       continue;
> > > >               }
> > > > =20
> > > > +             device_del(&dev->dev);
> > > > +
> > > >               dev->reg_state =3D NETREG_UNREGISTERED;
> > > > =20
> > > >               netdev_wait_allrefs(dev);
> > > > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > > > index 21c3fdeccf20..e754f00c117b 100644
> > > > --- a/net/core/net-sysfs.c
> > > > +++ b/net/core/net-sysfs.c
> > > > @@ -1955,8 +1955,6 @@ void netdev_unregister_kobject(struct net_dev=
ice *ndev)
> > > >       remove_queue_kobjects(ndev);
> > > > =20
> > > >       pm_runtime_set_memalloc_noio(dev, false);
> > > > -
> > > > -     device_del(dev);
> > > >  }
> > > > =20
> > > >  /* Create sysfs entries for network device. */ =20
> > >=20
> > > Doesn't this mean there may be sysfs files which are accessible=20
> > > for an unregistered netdevice? =20
> >=20
> > It would mean having accessible sysfs files for a device in the
> > NETREG_UNREGISTERING state; NETREG_UNREGISTERED still comes after
> > device_del. It's a small difference but still important, I think.
> >=20
> > You raise a good point. Yes, that would mean accessing attributes of net
> > devices being unregistered, meaning accessing or modifying unused or
> > obsolete parameters and data (it shouldn't be garbage data though).
> > Unlisting those sysfs files without removing them would be better here,
> > to not expose files when the device is being unregistered while still
> > allowing pending operations to complete. I don't know if that is doable
> > in sysfs.
>=20
> I wonder. Do we somehow remove the queue objects without waiting or are
> those also waited on when we remove the device? 'Cause XPS is the part
> that jumps out to me - we reset XPS after netdev_unregister_kobject().
> Does it mean user can re-instate XPS settings after we thought we
> already reset them?

This should be possible yes (and not really wanted).

> Well, it's a little wobbly but I think the direction is sane.
> It wouldn't feel super clean to add
>=20
>         if (dev->state !=3D NETREG_REGISTERED)
>                 goto out;
>=20
> to the sysfs handlers but maybe it's better than leaving potential
> traps for people who are not aware of the intricacies later? Not sure.

Agreed, that doesn't feel super clean, but would be quite nice to have
for users (and e.g. would also help in the XPS case). Having a wrapper
should be possible, to minimize the impact and make it a bit better.

> > (While I did ran stress tests reading/writing attributes while
> > unregistering devices, I think I missed an issue with the
> > netdev_queue_default attributes; which hopefully can be fixed =E2=80=94=
 if the
> > whole idea is deemed acceptable).

I had a quick look about queue attributes, their removal should also be
done in run_todo (that's easy). However the queues can be updated in
flight (while holding the rtnl lock) and the error paths[1][2] do drain
sysfs files (in kobject_put).

We can't release the rtnl lock here. It should be possible to delay this
outside the rtnl lock (in the global workqueue) but as the kobject are
embedded in the queues, we might need to have them live outside to allow
async releases while a net device (and ->_rx/->_tx) is being freed[3].
That adds to the complexity...

[1] https://elixir.bootlin.com/linux/latest/source/net/core/net-sysfs.c#L16=
62
[2] https://elixir.bootlin.com/linux/latest/source/net/core/net-sysfs.c#L10=
67
[3] Or having a dedicated workqueue and draining it.

> > > Isn't the point of having device_del() under rtnl_lock() to make sure
> > > we sysfs handlers can't run on dead devices? =20
> >=20
> > Hard to say what was the initial point, there is a lot of history here
> > :) I'm not sure it was done because of a particular reason; IMHO it just
> > made sense to make this simple without having a good reason not to do
> > so. And it helped with the naming collision detection.
>=20
> FWIW the other two pieces of feedback I have is try to avoid the
> synchronize_net() in patch 7

I wasn't too happy in adding a call to this. However the node name list
is rcu protected and to make sure all CPUs see the removal before
freeing the node name a call to synchronize_net (synchronize_rcu) is
needed. That being said I think we can just call kfree_rcu instead of
netdev_name_node_free (kfree) here.

> add a new helper for the name checking, which would return bool. The
> callers don't have any business getting the struct.

Good idea. Also I think the replacement of __dev_get_by_name by a new
wrapper might be good even outside of this series (in case the series is
delayed / reworked heavily / etc).

Thanks!
Antoine
