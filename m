Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049A7839D1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfHFTrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFTru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 15:47:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D3020880;
        Tue,  6 Aug 2019 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565120869;
        bh=Gubx2H4nSvBwez1y6mGwVdCfP/meJGOK0HIHf+R1CS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ButNMwsaMPK4jbRQwUn4Uzrqfbg8AWGhqvY7vFGtzA64liwU1zTF5xHr2TLGVU3du
         WwMsoumJ19RjnVqGi58O7vtutx9DGdBG0lAZSJ/1FhgjN6eKlVW7a/k5eZxYBvpDXB
         Ihium5G61DDdY5ezMyI0GvxTb5Mx+mLNl3p5ppeQ=
Date:   Tue, 6 Aug 2019 21:47:47 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 03/17] mlx5: no need to check return value of
 debugfs_create functions
Message-ID: <20190806194747.GA12000@kroah.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
 <20190806161128.31232-4-gregkh@linuxfoundation.org>
 <d681be03ea2c1997004c8144c3a6062f895817a4.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d681be03ea2c1997004c8144c3a6062f895817a4.camel@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 07:41:57PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-08-06 at 18:11 +0200, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic
> > should
> > never do something different based on this.
> > 
> > This cleans up a lot of unneeded code and logic around the debugfs
> > files, making all of this much simpler and easier to understand as we
> > don't need to keep the dentries saved anymore.
> > 
> 
> Hi Greg, 
> 
> Basically i am ok with this patch and i like it very much.., but i am
> concerned about some of the driver internal flows that are dependent on
> these debug fs entries being valid.

That's never good, that's a bug in the driver :)

> for example mlx5_debug_eq_add if failed, it will fail the whole flow. I
> know it is wrong even before your patch.. but maybe we should deal with
> it now ? or let me know if you want me to follow up with my own patch. 

Your own patch would be good as I do not know this part of the codebase
at all, thanks.

> All we need to improve in this patch is to void out add_res_tree()
> implemented in 
> drivers/net/ethernet/mellanox/mlx5/core/debugfs.c 
> as i will comment below.
> 
> 
> > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  51 ++-------
> >  .../net/ethernet/mellanox/mlx5/core/debugfs.c | 102 ++------------
> > ----
> >  drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  11 +-
> >  .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   2 +-
> >  .../net/ethernet/mellanox/mlx5/core/main.c    |   7 +-
> >  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
> >  include/linux/mlx5/driver.h                   |  12 +--
> >  7 files changed, 24 insertions(+), 163 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > index 8cdd7e66f8df..973f90888b1f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > @@ -1368,49 +1368,19 @@ static void clean_debug_files(struct
> > mlx5_core_dev *dev)
> >  	debugfs_remove_recursive(dbg->dbg_root);
> >  }
> >  
> 
> [...]
> 
> >  void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
> >  {
> > -	if (!mlx5_debugfs_root)
> > -		return;
> > -
> >  	debugfs_remove_recursive(dev->priv.cq_debugfs);
> >  }
> >  
> > @@ -484,7 +418,6 @@ static int add_res_tree(struct mlx5_core_dev 
> 
> Basically this function is a debugfs wrapper that should behave the
> same as debug_fs_*, we should fix it to return void as well, and
> improve all the its callers to ignore the return value.

But mlx5_cq_debugfs_cleanup() is a void function.

> callers are:
> mlx5_debug_qp_add()
> mlx5_debug_eq_add()
> mlx5_debug_cq_add()

Ah, you mean add_res_tree().  Yes, make that void as well.

thanks,

greg k-h
