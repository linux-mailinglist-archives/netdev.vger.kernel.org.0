Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A301EB634
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgFBHHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBHHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 03:07:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70CC206A2;
        Tue,  2 Jun 2020 07:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591081654;
        bh=AjDDp09H2m0/LzdcmPzwitXY+/pj+EurwKu7YmvdHsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGt3enTeWTtwcBJEjHxnDtuUPaYRQlxKJRIKIgDxZaK8W9I+z7+bUAw/qBmqQmljK
         eSCA25RCBwOU8IrJ0kFcm2juCW7W/avLftkb9ML2p/zrh3xwyjtmtPVUCFTixLGFxp
         cKAh4+hNY/G6VY480wqZ+PGPhH/G1aNEORHPg+Kc=
Date:   Tue, 2 Jun 2020 10:07:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] mlx5: Restore err assignment in mlx5_mdev_init
Message-ID: <20200602070730.GA12686@unreal>
References: <20200530055447.1028004-1-natechancellor@gmail.com>
 <20200531095810.GF66309@unreal>
 <20200602040748.GA1435528@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602040748.GA1435528@ubuntu-n2-xlarge-x86>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 09:07:48PM -0700, Nathan Chancellor wrote:
> On Sun, May 31, 2020 at 12:58:10PM +0300, Leon Romanovsky wrote:
> > On Fri, May 29, 2020 at 10:54:48PM -0700, Nathan Chancellor wrote:
> > > Clang warns:
> > >
> > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
> > > 'err' is used uninitialized whenever 'if' condition is true
> > > [-Wsometimes-uninitialized]
> > >         if (!priv->dbg_root) {
> > >             ^~~~~~~~~~~~~~~
> > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
> > > uninitialized use occurs here
> > >         return err;
> > >                ^~~
> > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
> > > 'if' if its condition is always false
> > >         if (!priv->dbg_root) {
> > >         ^~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
> > > the variable 'err' to silence this warning
> > >         int err;
> > >                ^
> > >                 = 0
> > > 1 warning generated.
> > >
> > > This path previously returned -ENOMEM, restore that error code so that
> > > it is not uninitialized.
> > >
> > > Fixes: 810cbb25549b ("net/mlx5: Add missing mutex destroy")
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > index df46b1fce3a7..ac68445fde2d 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > @@ -1277,6 +1277,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
> > >  					    mlx5_debugfs_root);
> > >  	if (!priv->dbg_root) {
> > >  		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
> > > +		err = -ENOMEM;
> > >  		goto err_dbg_root;
> >                 ^^^^^^^^^^^^^^^^^^ this is wrong.
> > Failure to create debugfs should never fail the driver.
>
> Fair enough, could you guys deal with this then to make sure it gets
> fixed properly? It appears to be introduced in 11f3b84d7068 ("net/mlx5:
> Split mdev init and pci init").

Thanks, I will send it today.

>
> > >  	}
> > >
> > >
> > > base-commit: c0cc73b79123e67b212bd537a7af88e52c9fbeac
> > > --
> > > 2.27.0.rc0
> > >
