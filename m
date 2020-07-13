Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF30A21E17F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGMUem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgGMUem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 16:34:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2D12075D;
        Mon, 13 Jul 2020 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594672481;
        bh=ujMdJStWE/Aqlx3h8vDbXoXMI1rOguZrHYmqv2ZkoUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hfocZOoquOBYqFfQvCJx8PLR4nTRVFDQQE6yN7oKuLh3xn2IP96mft9jP9baGC5kt
         a8/AERbI9yAEEvfdPyiT/BkNAQxYL9uPSsb76FndMHGzCzwaSwApu1o0633vjOYblF
         xrc/GzjZj2eU9z59fdF0UgynE/PCP/llp5VAF/2w=
Date:   Mon, 13 Jul 2020 13:34:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        mkubecek@suse.cz, davem@davemloft.net
Subject: Re: [PATCH net-next 3/3] net: treewide: Convert to
 netdev_ops_equal()
Message-ID: <20200713133440.1cf65acc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712221625.287763-4-f.fainelli@gmail.com>
References: <20200712221625.287763-1-f.fainelli@gmail.com>
        <20200712221625.287763-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 15:16:25 -0700 Florian Fainelli wrote:
> In order to support overloading of netdev_ops which can be done by
> specific subsystems such as DSA, utilize netdev_ops_equal() which allows
> a network driver implementing a ndo_equal operation to still qualify
> whether a net_device::netdev_ops is equal or not to its own.
>=20
> Mechanical conversion done by spatch with the following SmPL patch:
>=20
>     @@
>     struct net_device *n;
>     const struct net_device_ops o;
>     identifier netdev_ops;
>     @@
>=20
>     - n->netdev_ops !=3D &o
>     + !netdev_ops_equal(n, &o)
>=20
>     @@
>     struct net_device *n;
>     const struct net_device_ops o;
>     identifier netdev_ops;
>     @@
>=20
>     - n->netdev_ops =3D=3D &o
>     + netdev_ops_equal(n, &o)
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

I think these may be new:

drivers/net/ethernet/ti/cpsw_new.c:1467:30: warning: incorrect type in argu=
ment 1 (different modifiers)
drivers/net/ethernet/ti/cpsw_new.c:1467:30:    expected struct net_device *=
dev
drivers/net/ethernet/ti/cpsw_new.c:1467:30:    got struct net_device const =
*ndev
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:6185: warning: Function param=
eter or member 'txqueue' not described in 'ixgbe_tx_timeout'
drivers/net/ethernet/ti/cpsw_new.c: In function =E2=80=98cpsw_port_dev_chec=
k=E2=80=99:
drivers/net/ethernet/ti/cpsw_new.c:1467:23: warning: passing argument 1 of =
=E2=80=98netdev_ops_equal=E2=80=99 discards =E2=80=98const=E2=80=99 qualifi=
er from pointer target type [-Wdiscarded-qualifiers]
  1467 |  if (netdev_ops_equal(ndev, &cpsw_netdev_ops)) {
       |                       ^~~~
