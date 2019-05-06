Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE19145B4
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfEFIEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfEFIEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 04:04:38 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD8D205C9;
        Mon,  6 May 2019 08:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557129877;
        bh=aSxwpZyAx91AXfm4TuHmW+RnPTruleH6onxPV1n9D0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iEUUA4REKPaH7Of/eQberc8b0k9clawaABMfvirXepExQ6ELKyesV8htmW6mOXwU/
         6WOLwJWKpynbePUTnqRoOkjDnwkY1A36ipwJFXBt2PoEKKhJhMKheDqLJz/B9CxIbc
         RVE5kQ7zODTxMY3dydYX4x0yN/P9p958RdtUhqFk=
Date:   Mon, 6 May 2019 07:13:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the rdma tree
Message-ID: <20190506041312.GJ6938@mtr-leonro.mtl.com>
References: <20190430135846.0c17df6e@canb.auug.org.au>
 <20190506140147.23d41ac1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20190506140147.23d41ac1@canb.auug.org.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 06, 2019 at 02:01:47PM +1000, Stephen Rothwell wrote:
> Hi all,
>
> On Tue, 30 Apr 2019 13:58:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi Leon,
> >
> > Today's linux-next merge of the mlx5-next tree got a conflict in:
> >
> >   drivers/infiniband/hw/mlx5/main.c
> >
> > between commit:
> >
> >   35b0aa67b298 ("RDMA/mlx5: Refactor netdev affinity code")
> >
> > from the rdma tree and commit:
> >
> >   c42260f19545 ("net/mlx5: Separate and generalize dma device from pci device")
> >
> > from the mlx5-next tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >
> > --
> > Cheers,
> > Stephen Rothwell
> >
> > diff --cc drivers/infiniband/hw/mlx5/main.c
> > index 6135a0b285de,fae6a6a1fbea..000000000000
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@@ -200,12 -172,18 +200,12 @@@ static int mlx5_netdev_event(struct not
> >
> >   	switch (event) {
> >   	case NETDEV_REGISTER:
> >  +		/* Should already be registered during the load */
> >  +		if (ibdev->is_rep)
> >  +			break;
> >   		write_lock(&roce->netdev_lock);
> > - 		if (ndev->dev.parent == &mdev->pdev->dev)
> >  -		if (ibdev->rep) {
> >  -			struct mlx5_eswitch *esw = ibdev->mdev->priv.eswitch;
> >  -			struct net_device *rep_ndev;
> >  -
> >  -			rep_ndev = mlx5_ib_get_rep_netdev(esw,
> >  -							  ibdev->rep->vport);
> >  -			if (rep_ndev == ndev)
> >  -				roce->netdev = ndev;
> >  -		} else if (ndev->dev.parent == mdev->device) {
> > ++		if (ndev->dev.parent == mdev->device)
> >   			roce->netdev = ndev;
> >  -		}
> >   		write_unlock(&roce->netdev_lock);
> >   		break;
> >
>
> This is now a conflict between the net-next tree and the rdma tree.

Thanks Stephen,
Looks good.

>
> --
> Cheers,
> Stephen Rothwell



--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT1m3YD37UfMCUQBNwp8NhrnBAZsQUCXM+0OwAKCRAp8NhrnBAZ
sc9RAQDmnIWke/N+pH96y3NysRRPQo5qL4qm8zgCrYToys2YcgEAqTnEoZ5Y/T4A
E1YB7CSiFyMI3G6S6lzNHE4EgrcehAk=
=ruXy
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
