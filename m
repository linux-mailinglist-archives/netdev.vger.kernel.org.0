Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC29333EBE3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhCQI4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCQIzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 04:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 019BB64F26;
        Wed, 17 Mar 2021 08:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615971346;
        bh=VvjNBZC+L597ZRdG9lvP6qiBN+pBZLsbkM79U1R6WIE=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=eJYepiB7jzJzq0nJEiKna7pvgtEaY/JtiDPu+wpeDfrbY6PoA7krvNZLPvO5XLfRT
         XG/spJD198vxAVhu/mG4OzzX3jtnzKEq44RIS72MrCsHrWS4ELCw0QjKLgBYSu7Vtd
         tv/H2JDH7KWi2poqXY357DZo8GkNlSObMI6u1k18Geyuc/qDOoUEiVUfgitqwRcVNC
         mREGv2TK+YDrC0//dOLcRyGoMephQFhghiIsAzGc9fmgNH2EeWrKXDqjkJ0IfQxhv1
         buvkPk2D2mE70VFWpK4Hc0SDGc6tQtch9zTiW105ly4l1pQJqs5w0lnsZbOzHnh4Z/
         ZgcfZn2piGLJQ==
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
Message-ID: <161597134352.3996.436408610278743110@kwain.local>
Date:   Wed, 17 Mar 2021 09:55:43 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Saeed Mahameed (2021-03-12 21:54:18)
> On Fri, 2021-03-12 at 16:04 +0100, Antoine Tenart wrote:
> > netif_set_xps_queue must be called with the rtnl lock taken, and this
> > is
> > now enforced using ASSERT_RTNL(). mlx5e_attach_netdev was taking the
> > lock conditionally, fix this by taking the rtnl lock all the time.
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

Not sure we want to add a nested rtnl lock because of xps. I'd like to
see other options first. Could be having a locking mechanism for xps not
relying on rtnl; if that's possible.

As for this series, patches 6, 15 (this one) and 16 are not linked to
and do not rely on the other patches. They're improvement or fixes for
already existing behaviours. The series already gained enough new
patches since v1 and I don't want to maintain it out-of-tree for too
long, so I'll resend it without patches 6, 15 and 16; and then we'll be
able to focus on the xps locking relationship with rtnl.

Antoine
