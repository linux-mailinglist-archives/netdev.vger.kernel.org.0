Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7372ADAFC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgKJP4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbgKJP4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:56:25 -0500
Received: from localhost (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F184B20678;
        Tue, 10 Nov 2020 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605023784;
        bh=YzrdSMgXqb68IqjHW1+iLa5LE8WfDX029Sv0b6jZatE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gkpoV8QjEMkLeIhB17M3RpqA6YYuDo5tG1pQ+6jM/5SQM6/+748gXsUlO8eKGWcMZ
         +Tv2zMPpHhMakAbVl+kloKvQCdTulhYWGjh5PAjWAWiZFcag6IRabDmJqS25JFgSKH
         HdFXYUHXbEd2EKdYugVwyNGXplqBzNnfmSZf3KDY=
Date:   Tue, 10 Nov 2020 16:56:19 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, lorenzo.bianconi@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 net-nex 0/5] xdp: introduce bulking for page_pool tx
 return path
Message-ID: <20201110155619.GA10317@lore-desk>
References: <cover.1605020963.git.lorenzo@kernel.org>
 <20201110165052.4476c52b@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20201110165052.4476c52b@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 10 Nov 2020 16:37:55 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > XDP bulk APIs introduce a defer/flush mechanism to return
> > pages belonging to the same xdp_mem_allocator object
> > (identified via the mem.id field) in bulk to optimize
> > I-cache and D-cache since xdp_return_frame is usually run
> > inside the driver NAPI tx completion loop.
> > Convert mvneta, mvpp2 and mlx5 drivers to xdp_return_frame_bulk APIs.
>=20
> Series
>=20
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>=20
> > Changes since v4:
> > - fix comments
> > - introduce xdp_frame_bulk_init utility routine
> > - compiler annotations for I-cache code layout
> > - move rcu_read_lock outside fast-path
> > - mlx5 xdp bulking code optimization
>=20
> I've done a lot of these changes, and benchmarked them on mlx5, details i=
n[1].
>=20
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/xdp_=
bulk_return01.org

ops sorry, I forgot to add it to the cover-letter.

Regards,
Lorenzo

>=20
> > Changes since v3:
> > - align DEV_MAP_BULK_SIZE to XDP_BULK_QUEUE_SIZE
> > - refactor page_pool_put_page_bulk to avoid code duplication
> >=20
> > Changes since v2:
> > - move mvneta changes in a dedicated patch
> >=20
> > Changes since v1:
> > - improve comments
> > - rework xdp_return_frame_bulk routine logic
> > - move count and xa fields at the beginning of xdp_frame_bulk struct
> > - invert logic in page_pool_put_page_bulk for loop
> >=20
> > Lorenzo Bianconi (5):
> >   net: xdp: introduce bulking for xdp tx return path
> >   net: page_pool: add bulk support for ptr_ring
> >   net: mvneta: add xdp tx return bulking support
> >   net: mvpp2: add xdp tx return bulking support
> >   net: mlx5: add xdp tx return bulking support
> >=20
> >  drivers/net/ethernet/marvell/mvneta.c         | 10 ++-
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 10 ++-
> >  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 22 ++++--
> >  include/net/page_pool.h                       | 26 +++++++
> >  include/net/xdp.h                             | 17 ++++-
> >  net/core/page_pool.c                          | 69 ++++++++++++++++---
> >  net/core/xdp.c                                | 54 +++++++++++++++
> >  7 files changed, 191 insertions(+), 17 deletions(-)
> >=20
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX6q4IQAKCRA6cBh0uS2t
rE9mAP90nkOdsV4hCwlD0zcXgTmRuXfjqZ1JqHFeaCIr+KmP0gEAhMj9XlnsbN0W
oEmsQu0S464lR55ijx1PhTxE1V6A+gA=
=5e9D
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
