Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5E3B13A3
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFWGGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhFWGF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 02:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC2761186;
        Wed, 23 Jun 2021 06:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624428222;
        bh=Ja+ISr0NAdxQoaoVB7TsXbPptUPHLgLampPKJ/ivUd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZdtqaLMcLwNums4Y8j4S/gJQ3NLegOj572Ir5OQkxmcgonjj/A+HbtjIznU08vNxL
         6XKx/6db6BKqFHQcx5NsvKw2b7Uee8R/gznS1QgoFGdFqWF4n+oicc/oDu2l5BtWbO
         6d190iknFRX1hPtHGoBMYGa/kcujRlRkUGnPj7v4cjpUsDFwyuYfkrU/ewuQbtaOXf
         EPBlli8bRjgZVDjFO0N7QqX7U9/GRyYWazQtAHldNVdS6U98Tu77JJWlfrhDyNIvIp
         Bcvvatl7woQ7Ohsk4FCUW5MZeUpOAig3RBNMUCg90zRAl4bpQL6NlJgbWA3lOlIKJB
         3obbxS42HmQhA==
Date:   Wed, 23 Jun 2021 09:03:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Separate DCI QP creation
 logic
Message-ID: <YNLOurv1BXrlpsha@unreal>
References: <cover.1624258894.git.leonro@nvidia.com>
 <b4530bdd999349c59691224f016ff1efb5dc3b92.1624258894.git.leonro@nvidia.com>
 <20210622184556.GA2596427@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622184556.GA2596427@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:45:56PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 21, 2021 at 10:06:15AM +0300, Leon Romanovsky wrote:
> > From: Lior Nahmanson <liorna@nvidia.com>
> > 
> > This patch isolates DCI QP creation logic to separate function, so this
> > change will reduce complexity when adding new features to DCI QP without
> > interfering with other QP types.
> > 
> > The code was copied from create_user_qp() while taking only DCI relevant bits.
> > 
> > Reviewed-by: Meir Lichtinger <meirl@nvidia.com>
> > Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >  drivers/infiniband/hw/mlx5/qp.c | 157 ++++++++++++++++++++++++++++++++
> >  1 file changed, 157 insertions(+)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > index 7a5f1eba60e3..65a380543f5a 100644
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -1974,6 +1974,160 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
> >  	return 0;
> >  }
> >  
> > +static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
> > +		      struct mlx5_ib_qp *qp,
> > +		      struct mlx5_create_qp_params *params)
> > +{
> 
> This is a huge amount of copying just to add 4 lines, why?
> 
> There must be a better way to do this qp stuff.
> 
> Why not put more stuff in _create_user_qp()?

Lior proposed it in original patch, but I didn't like it. It caused to
mix of various QP types and maze of "if () else ()" that are not applicable
one to another.

The huge _create_user_qp() is the reason why create_dci() is not small,
we simply had hard time to understand if specific HW bit is needed or
not in DCI flow.

My goal is to have small per-QP type specific functions that calls
to simple functions for very narrow scope.

Something like that:
static int create_dci(...)
{
  ...
  configure_send_cq(..)
  configure_recv_sq(..)
  configure_srq(...)
  ...
}

static int create_user_qp(...)
{
  ...
  configure_send_cq(..)
  configure_recv_sq(..)
  configure_srq(...)
  ...
}


Thanks

> 
> Jason
