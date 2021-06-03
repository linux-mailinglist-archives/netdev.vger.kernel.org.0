Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6204F39AAEE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 21:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFCTaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 15:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhFCTaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 15:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10FE26124B;
        Thu,  3 Jun 2021 19:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622748515;
        bh=L1bDZ0alG/5e7gBpSxuoaamS+QVgRnLecZ9WFAr+uTY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=euxD5jCS9J8wMyg0ayyPfIjoTa1VlOWovui5tcMFLxFSbEdsSz68IdFzFlkN3/cXJ
         ZKL2ubCuBh+rjFPC2UPe5fyiMIObcYMoWTtu8lDSGj5YplbIHKw93UpTBw3ybi6VjC
         BmDQdoBu+KxZr3R2r3wXa6Lx5tIg7tbLRdhJWmApEqR9QUX3P7XyK/ZV1JIVP1rt7/
         YZKnaLYwYz3RpEDRDBxphzjPW+ceBe5aj2Wj79Pg0xm84rCEoUpeu6rRbMlZAZKw+t
         5K6kll9JKhqCtkSS6xUCWLXAyAZA3zJL/d1fB8VBwtescCmBNvB2xBCLNE+G1yoUOq
         CfiJyj8JJPzHQ==
Message-ID: <d7d38bb6686df957df2f962451e24800535024e8.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix an error code in
 mlx5e_arfs_create_tables()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Mark Zhang <markzhang@nvidia.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 03 Jun 2021 12:28:34 -0700
In-Reply-To: <7b14006a-4528-bdd9-dd12-0785d8409a5d@nvidia.com>
References: <1622628553-89257-1-git-send-email-yang.lee@linux.alibaba.com>
         <7b14006a-4528-bdd9-dd12-0785d8409a5d@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-02 at 19:49 +0800, Mark Zhang wrote:
> On 6/2/2021 6:09 PM, Yang Li wrote:
> > When the code execute 'if (!priv->fs.arfs->wq)', the value of err
> > is 0.
> > So, we use -ENOMEM to indicate that the function
> > create_singlethread_workqueue() return NULL.
> > 
> > Clean up smatch warning:
> > drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
> > mlx5e_arfs_create_tables() warn: missing error code 'err'.
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Fixes: 'commit f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table
> > for netdev when needed")'

This is not the right format.

Please use the following command to generate the fixes tag:
git log -1 --abbrev=12 --format='Fixes: %h ("%s")' f6755b80d693

> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> > index 5cd466e..2949437 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> > @@ -369,8 +369,10 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv
> > *priv)
> >         spin_lock_init(&priv->fs.arfs->arfs_lock);
> >         INIT_LIST_HEAD(&priv->fs.arfs->rules);
> >         priv->fs.arfs->wq =
> > create_singlethread_workqueue("mlx5e_arfs");
> > -       if (!priv->fs.arfs->wq)
> > +       if (!priv->fs.arfs->wq) {
> > +               err = -ENOMEM;
> >                 goto err;
> > +       }
> >   

you can just initialize err to -ENOMEM; on declaration. 

> >         for (i = 0; i < ARFS_NUM_TYPES; i++) {
> >                 err = arfs_create_table(priv, i);
> 
> Maybe also need to "destroy_workqueue(priv->fs.arfs->wq);" in
> err_des.

yes, it can be in the same patch.

Thanks a lot.  



