Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9851236552B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhDTJVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhDTJVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 05:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA6761057;
        Tue, 20 Apr 2021 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618910476;
        bh=axc1HLJpE/r4UU/G5LasNjzeNzaxwU5fcJIvZN8/ueM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAPKGh4TgZ1nvI0X2dT2Z+Lc+/M0HHKEz6LMK6plEos1Mb3Ok6pyeM55+i91CGqXQ
         NtvWo1ZqvaTttjD2JgzRYA6MUSmV5PGRV8ozB69sK18e9YPbXocyAjFTT7onenqjsV
         R29cpK18u07oo+7wIFgi2LUC/SonbjQDkBRwqjL7D6SEja3fpCs0TXByHApXDkElS9
         7PcQB3ljlCoTrYeZd6r5LTNSM5b7IN04QDM88Y1ujruteCk8N0Jr0jRdxjjZpo29Sd
         dr518CczBULWdjcvJaiIKG1TlBSZp3VdWRKhzF9/Heweikbs8KGOtk+BAebSXs4vOX
         h32sZ1dcKTwiw==
Date:   Tue, 20 Apr 2021 12:21:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>,
        wangyunjian <wangyunjian@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        netdev <netdev@vger.kernel.org>, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field
 moder.comps
Message-ID: <YH6dCCh5vgWcnzc+@unreal>
References: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
 <CAD=hENfAZZBm3iipTAv6q9u12z8WmT7LUgXSDFEdtSf_k9_Lcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=hENfAZZBm3iipTAv6q9u12z8WmT7LUgXSDFEdtSf_k9_Lcw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:09:03PM +0800, Zhu Yanjun wrote:
> On Tue, Apr 20, 2021 at 3:01 PM wangyunjian <wangyunjian@huawei.com> wrote:
> >
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > The 'comps' struct field in 'moder' is not being initialized in
> > mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
> > So initialize 'moder' to zero to avoid the issue.

Please state that it is false alarm and this patch doesn't fix anything
except broken static analyzer tool.

> >
> > Addresses-Coverity: ("Uninitialized scalar variable")
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > ---
> > v2: update mlx5e_get_def_tx_moderation() also needs fixing
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 5db63b9f3b70..17a817b7e539 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -4868,7 +4868,7 @@ static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
> >
> >  static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
> >  {
> > -       struct dim_cq_moder moder;
> 
> > +       struct dim_cq_moder moder = {};
> 
> If I remember correctly, some gcc compiler will report errors about this "{}".

Kernel doesn't support such compilers.

Thanks
