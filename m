Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F58371EA3
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbfGWSEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfGWSEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 14:04:45 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417F6218A6;
        Tue, 23 Jul 2019 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563905084;
        bh=ltY0X7AhyIkc9DC3sJ8HWbcfutSdGHSj0qiUfSlF6wY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=motm2ZdJDBDETTD+iMvCjb7n9MiX4nT1cvT7qLx29y4fpuXsRo4hocFFASK11lerO
         05lIBg7O/wjoO3bBj0pcZgM4VaxBuroqr25qrZRjwDbwgHrAngAWNngltbsH2UtZEV
         GCGcpmbVTJJ8uAZ4o9WE6CUeLqnFqIcZcs2gl4s0=
Date:   Tue, 23 Jul 2019 21:04:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] linux/dim: Fix overflow in dim calculation
Message-ID: <20190723180436.GT5125@mtr-leonro.mtl.com>
References: <20190723072248.6844-1-leon@kernel.org>
 <20190723072248.6844-2-leon@kernel.org>
 <4f4bc2958dc1512087f19db64e8e43f1247cf2dd.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f4bc2958dc1512087f19db64e8e43f1247cf2dd.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 05:22:43PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-07-23 at 10:22 +0300, Leon Romanovsky wrote:
> > From: Yamin Friedman <yaminf@mellanox.com>
> >
> > While using net_dim, a dim_sample was used without ever initializing
> > the
> > comps value. Added use of DIV_ROUND_DOWN_ULL() to prevent potential
> > overflow, it should not be a problem to save the final result in an
> > int
> > because after the division by epms the value should not be larger
> > than a
> > few thousand.
> >
> > [ 1040.127124] UBSAN: Undefined behaviour in lib/dim/dim.c:78:23
> > [ 1040.130118] signed integer overflow:
> > [ 1040.131643] 134718714 * 100 cannot be represented in type 'int'
> >
> > Fixes: 398c2b05bbee ("linux/dim: Add completions count to
> > dim_sample")
> > Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/net/ethernet/broadcom/bcmsysport.c        | 2 +-
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 +-
> >  drivers/net/ethernet/broadcom/genet/bcmgenet.c    | 2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 4 ++--
> >  lib/dim/dim.c                                     | 4 ++--
> >  5 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c
> > b/drivers/net/ethernet/broadcom/bcmsysport.c
> > index b9c5cea8db16..9483553ce444 100644
> > --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> > +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> > @@ -992,7 +992,7 @@ static int bcm_sysport_poll(struct napi_struct
> > *napi, int budget)
> >  {
> >  	struct bcm_sysport_priv *priv =
> >  		container_of(napi, struct bcm_sysport_priv, napi);
> > -	struct dim_sample dim_sample;
> > +	struct dim_sample dim_sample = {};
>
> net_dim implementation doesn't care about sample->comp_ctr, so this is
> unnecessary for the sake of fixing the rdma overflow issue, but it
> doens't hurt anyone to have this change in this patch.

Yes, this is why we decided to change all drivers and not mlx5 only.

Thanks
