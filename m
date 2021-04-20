Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF29365719
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhDTLFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhDTLFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 07:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19EDD6139A;
        Tue, 20 Apr 2021 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618916718;
        bh=T1MBpxb+qMapIOur2MjwDyVFf1uMt6D9ZpaFBYNhquk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nj1hAWCDtYByOjzcxpFnpt/zvvVfCRiSuwpebQTiZZKr4JbkO/0wJa8rkeHd2i/3W
         ifJ8JMheSOmGLH9Jh+GL8vROCfDMsWjcdtw9CyKbBCIy8PYy7/2zsa1U5nqq9GOWCR
         CmBrQ8Nh5It+ftBIDNG4DIXKySNzpsW+mmo7te8SFQqvm+2VQQ696HFD9KWhtCaf0D
         0RUMc2ZM/tuEYLnhIFSFBDMB3MADr2qOk4FPPp24PEm3oW///Bp1WDYWpjJwlnuq8G
         UOIpyYthSHx/EHF1Cpocg2A96TZMiHK+6f7Wj+eDm5q9OR9VLg5pCCqQqrYNDZt9l5
         5CJ45dXkrVMow==
Date:   Tue, 20 Apr 2021 14:05:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        netdev <netdev@vger.kernel.org>, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field
 moder.comps
Message-ID: <YH61aiVsCsjhlrdW@unreal>
References: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
 <CAD=hENfAZZBm3iipTAv6q9u12z8WmT7LUgXSDFEdtSf_k9_Lcw@mail.gmail.com>
 <YH6dCCh5vgWcnzc+@unreal>
 <CAD=hENc45EapYYj1yhyf8wzyUd_9+fbkkJYtN0h0Hefdf+1ykQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=hENc45EapYYj1yhyf8wzyUd_9+fbkkJYtN0h0Hefdf+1ykQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 05:28:43PM +0800, Zhu Yanjun wrote:
> On Tue, Apr 20, 2021 at 5:21 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Apr 20, 2021 at 03:09:03PM +0800, Zhu Yanjun wrote:
> > > On Tue, Apr 20, 2021 at 3:01 PM wangyunjian <wangyunjian@huawei.com> wrote:
> > > >
> > > > From: Yunjian Wang <wangyunjian@huawei.com>
> > > >
> > > > The 'comps' struct field in 'moder' is not being initialized in
> > > > mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
> > > > So initialize 'moder' to zero to avoid the issue.
> >
> > Please state that it is false alarm and this patch doesn't fix anything
> > except broken static analyzer tool.
> >
> > > >
> > > > Addresses-Coverity: ("Uninitialized scalar variable")
> > > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > > ---
> > > > v2: update mlx5e_get_def_tx_moderation() also needs fixing
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > index 5db63b9f3b70..17a817b7e539 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > @@ -4868,7 +4868,7 @@ static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
> > > >
> > > >  static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
> > > >  {
> > > > -       struct dim_cq_moder moder;
> > >
> > > > +       struct dim_cq_moder moder = {};
> > >
> > > If I remember correctly, some gcc compiler will report errors about this "{}".
> >
> > Kernel doesn't support such compilers.
> 
> Are you sure? Why are you so confirmative?

Yes, I'm sure.

Please read this whole discussion, I hope that it will answer your
question on why I'm so sure.
https://lore.kernel.org/linux-rdma/20200730192026.110246-1-yepeilin.cs@gmail.com/

> 
> Zhu Yanjun
> 
> >
> > Thanks
