Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D0308350
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhA2BiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhA2BiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:38:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A777664DF1;
        Fri, 29 Jan 2021 01:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611884257;
        bh=FLt5urrjA/P8SjuE6AcGKYP4Hty43h30mab4ApTYugE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FB4DhP5MjD4xfmV2iMUZF8n71y6mEROZtQyb4GK8pYIPju/yzZw51804GGxH8caBr
         TJtnOF/gzbB603i0xYFpxoo9aewHV7eVV0fYC+1BfGd+cZW0F6wDJvdf/7zrGE3r4C
         u7KhqPXUoG+/TfwHGO8gq02HBiwngdK/NA3ozx6/kPrYz9w125lmtJVj1hNn08Gt+C
         wLUE7SGCAUgDDjFqkzWkNqeDlwvotDs7xydzcs8ecHJTBjsnS6INLgrg31dcn79KM+
         exVHPtT/trrMHOQYZWKA6N925tkkLqnOQyPwvUQqFlEv5VpGuzrRjHHobpBAlrsdx1
         1eKwfKuwtgJSw==
Date:   Thu, 28 Jan 2021 17:37:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roid@nvidia.com,
        maord@nvidia.com
Subject: Re: [net 01/12] net/mlx5: Fix memory leak on flow table creation
 error flow
Message-ID: <20210128173736.625461b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1fd6aa2c643b50b534476da142555a229ed1b534.camel@kernel.org>
References: <20210126234345.202096-2-saeedm@nvidia.com>
        <161180461255.10551.14683896693302400823.git-patchwork-notify@kernel.org>
        <1fd6aa2c643b50b534476da142555a229ed1b534.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 00:33:20 -0800 Saeed Mahameed wrote:
> On Thu, 2021-01-28 at 03:30 +0000, patchwork-bot+netdevbpf@kernel.org
> wrote:
> > Hello:
> >=20
> > This series was applied to netdev/net.git (refs/heads/master):
> >=20
> >  =20
> ...
>=20
> > =C2=A0=C2=A0=C2=A0 https://git.kernel.org/netdev/net/c/89e394675818
> > =C2=A0 - [net,09/12] net/mlx5e: Correctly handle changing the number of
> > queues when the interface is down =20
>=20
>=20
>=20
> Hi Jakub,=20
>=20
> I just noticed that this patch will conflict with HTB offlaod feature
> in net-next, I couldn't foresee it before in my queues since HTB wasn't
> submitted through my trees.
>=20
> anyway to solve the conflict just use this hunk:
>=20
>  +      /* Don't allow changing the number of channels if HTB offload
> is active,
>  +       * because the numeration of the QoS SQs will change, while
> per-queue
>  +       * qdiscs are attached.
>  +       */
>  +      if (priv->htb.maj_id) {
>  +              err =3D -EINVAL;
>  +              netdev_err(priv->netdev, "%s: HTB offload is active,
> cannot change the number of channels\n",
>  +                         __func__);
>  +              goto out;
>  +      }
>  +
> -       new_channels.params =3D priv->channels.params;
> -       new_channels.params.num_channels =3D count;
> +       new_channels.params =3D *cur_params;
>=20

Done, thanks!
