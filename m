Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F040033ADB9
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCOIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhCOIig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 04:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA3E564E86;
        Mon, 15 Mar 2021 08:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615797516;
        bh=oXyI1wF7x6f1VyPNtDlPiOIgBC6+/eiKO9MKRB1VICk=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=RNMJSl9dyB7DIXOucn+6Y9Fv6bGzoJp4jg6v99zU2WsgZlNQRfR+p4nGfyb4+ZPIu
         KMIoc9rZdLF9oXQ6QoQMVIrZfD6QSo/eeHdZaLFpjgSduxZROqd5iAQPu9zaoaVAmm
         zOptQKQqwvrXPeD3ENhBxhGPBTvT9pjSamT9qnbaWtaPEcy+I8CiVThuigvp8hQmGW
         xUO5g63tG/9aXZd5L3hgxxn2bqbsNUH1lHfR0gHY18ahTQhheUuipOGSzsaWYzKzns
         9EEZVYRDRbPgnVtqPuoXmBDJCRWK1vTjW+3tkcoKzZ5XnNIXq+BDnrZjEREzGuWOcu
         iTk4Dei661yvA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c6a4224370e57d31b1f28e27e7a7d4e1ab237ec2.camel@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org> <20210312150444.355207-16-atenart@kernel.org> <c6a4224370e57d31b1f28e27e7a7d4e1ab237ec2.camel@kernel.org>
To:     Maxim Mykytianskyi <maximmi@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, alexander.duyck@gmail.com,
        davem@davemloft.net, kuba@kernel.org
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v3 15/16] net/mlx5e: take the rtnl lock when calling netif_set_xps_queue
Cc:     netdev@vger.kernel.org
Message-ID: <161579751342.3996.7266999681235546580@kwain.local>
Date:   Mon, 15 Mar 2021 09:38:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Saeed Mahameed (2021-03-12 21:54:18)
> On Fri, 2021-03-12 at 16:04 +0100, Antoine Tenart wrote:
> > netif_set_xps_queue must be called with the rtnl lock taken, and this
> > is
> > now enforced using ASSERT_RTNL(). mlx5e_attach_netdev was taking the
> > lock conditionally, fix this by taking the rtnl lock all the time.
> >=20
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > ---
> > =C2=A0drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++--------
> > =C2=A01 file changed, 3 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index ec2fcb2a2977..96cba86b9f0d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -5557,7 +5557,6 @@ static void mlx5e_update_features(struct
> > net_device *netdev)
> > =C2=A0
> > =C2=A0int mlx5e_attach_netdev(struct mlx5e_priv *priv)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const bool take_rtnl =3D pri=
v->netdev->reg_state =3D=3D
> > NETREG_REGISTERED;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct mlx5e_prof=
ile *profile =3D priv->profile;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int max_nch;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int err;
> > @@ -5578,15 +5577,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv
> > *priv)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 2. Set our default X=
PS cpumask.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 3. Build the RQT.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * rtnl_lock is required by =
netif_set_real_num_*_queues in case
> > the
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * netdev has been registere=
d by this point (if this function
> > was called
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * in the reload or resume f=
low).
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * rtnl_lock is required by =
netif_set_xps_queue.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
> There is a reason why it is conditional:
> we had a bug in the past of double locking here:
>=20
> [ 4255.283960] echo/644 is trying to acquire lock:
>=20
>  [ 4255.285092] ffffffff85101f90 (rtnl_mutex){+..}, at:
> mlx5e_attach_netdev0xd4/0=C3=973d0 [mlx5_core]
>=20
>  [ 4255.287264]=20
>=20
>  [ 4255.287264] but task is already holding lock:
>=20
>  [ 4255.288971] ffffffff85101f90 (rtnl_mutex){+..}, at:
> ipoib_vlan_add0=C3=977c/0=C3=972d0 [ib_ipoib]
>=20
> ipoib_vlan_add is called under rtnl and will eventually call=20
> mlx5e_attach_netdev, we don't have much control over this in mlx5
> driver since the rdma stack provides a per-prepared netdev to attach to
> our hw. maybe it is time we had a nested rtnl lock ..=20

Thanks for the explanation. So as you said, we can't based the locking
decision only on the driver own state / information...

What about `take_rtnl =3D !rtnl_is_locked();`?

Thanks!
Antoine
