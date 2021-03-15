Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1233BF87
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCOPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhCOPNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 11:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C9264DF0;
        Mon, 15 Mar 2021 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615821219;
        bh=Mha2xu12Pkas5ENCgzQYtQUA3dhOtTp1vOAF9NUcUdc=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=UOx+hLF8Hf325TGinlLYJgQ02UXIGRlYG6awnCEH9VkruBJg3TcEs6XTPMIXwVShY
         nuq1n4OPcxrFUjxCtaxNuFTXj5wQiezm86jah8+5/za5KgpIdg4R/Xkn3SyyqrZUS3
         rYOP5RiRUvLsIoxx4W3MeEWEsMFHYCcvKICk2YTxXOy5X31LwIQefFbqoWefZldkSi
         13otECbsfj8BfSvq8O9WKoLRTM/FBl6I8hu5zQbqNtWEc/JOcepvIbuoJUOrcizEwl
         Wxf0omx6u1KKHE/TfQpkpOI1aPRyCVKSTitSe7Gg+PlKVt70/fQ7wg5FGkzGO2k//U
         ftmS9odeWwTVw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5ae00a7f-2614-cc0f-1e8a-c6d8d19170f9@nvidia.com>
References: <20210312150444.355207-1-atenart@kernel.org> <20210312150444.355207-16-atenart@kernel.org> <c6a4224370e57d31b1f28e27e7a7d4e1ab237ec2.camel@kernel.org> <161579751342.3996.7266999681235546580@kwain.local> <5ae00a7f-2614-cc0f-1e8a-c6d8d19170f9@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, alexander.duyck@gmail.com,
        davem@davemloft.net, kuba@kernel.org
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v3 15/16] net/mlx5e: take the rtnl lock when calling netif_set_xps_queue
Cc:     netdev@vger.kernel.org
Message-ID: <161582121653.3996.16019131946329402786@kwain.local>
Date:   Mon, 15 Mar 2021 16:13:36 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Maxim Mikityanskiy (2021-03-15 15:53:02)
> On 2021-03-15 10:38, Antoine Tenart wrote:
> > Quoting Saeed Mahameed (2021-03-12 21:54:18)
> >> There is a reason why it is conditional:
> >> we had a bug in the past of double locking here:
> >>
> >> [ 4255.283960] echo/644 is trying to acquire lock:
> >>
> >>   [ 4255.285092] ffffffff85101f90 (rtnl_mutex){+..}, at:
> >> mlx5e_attach_netdev0xd4/0=C3=973d0 [mlx5_core]
> >>
> >>   [ 4255.287264]
> >>
> >>   [ 4255.287264] but task is already holding lock:
> >>
> >>   [ 4255.288971] ffffffff85101f90 (rtnl_mutex){+..}, at:
> >> ipoib_vlan_add0=C3=977c/0=C3=972d0 [ib_ipoib]
> >>
> >> ipoib_vlan_add is called under rtnl and will eventually call
> >> mlx5e_attach_netdev, we don't have much control over this in mlx5
> >> driver since the rdma stack provides a per-prepared netdev to attach to
> >> our hw. maybe it is time we had a nested rtnl lock ..
> >=20
> > Thanks for the explanation. So as you said, we can't based the locking
> > decision only on the driver own state / information...
> >=20
> > What about `take_rtnl =3D !rtnl_is_locked();`?
>=20
> It won't work, because the lock may be taken by some other unrelated=20
> thread. By doing `if (!rtnl_is_locked()) rtnl_lock()` we defeat the=20
> purpose of the lock, because we will proceed to the critical section=20
> even if we should wait until some other thread releases the lock.

Ah, that's right...
