Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623512DA3A0
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441213AbgLNWqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441229AbgLNWqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 17:46:08 -0500
Message-ID: <56038d94aa6bcc8f0b386af5e097c7a914a61c34.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607985927;
        bh=il0OYWkj2ZMQ2UCy0mvrIHy/2EfNZ/89e+LbPE+5lvI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MZCThT+34IpAnxCWtJRYWQSadTFsa4xJ0E+VQheIM7zBJfTJzKQnV1d3NFXz/EW0a
         JXHdxqbDKEk+uNsQYgppH1wVUPB/ZcpWENSCavzn7CV1cHMKE3JaTZBaBv/I7SqBuu
         Zy8D6zSCMEHfS8j9bs0d573/w35K+3fLro29FyuTxfwllSA/SU9UneK1KHJ29ubwVc
         40lUETkc0Q+4Orqx7ur6Sbtcf5rPRY+DunlKb96cutbQLyT0J7Qd2zJLeKTx53U042
         fmMXON45ZaGXTr6dMx6Db9U+LuOThqVclMixjM/boJcz65A3ZxDtM4venVkQqv25h7
         f00x8Q3+61zhg==
Subject: Re: [net-next v4 01/15] net/mlx5: Fix compilation warning for
 32-bit platform
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon, 14 Dec 2020 14:45:25 -0800
In-Reply-To: <CAKgT0UeAaydinMZdfJt_f40eK0xxgEUdTeM7-YJc=pUyqB9-5A@mail.gmail.com>
References: <20201214214352.198172-1-saeed@kernel.org>
         <20201214214352.198172-2-saeed@kernel.org>
         <CAKgT0UeAaydinMZdfJt_f40eK0xxgEUdTeM7-YJc=pUyqB9-5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-14 at 14:31 -0800, Alexander Duyck wrote:
> On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > From: Parav Pandit <parav@nvidia.com>
> > 
> > MLX5_GENERAL_OBJECT_TYPES types bitfield is 64-bit field.
> > 
> > Defining an enum for such bit fields on 32-bit platform results in
> > below
> > warning.
> > 
> > ./include/vdso/bits.h:7:26: warning: left shift count >= width of
> > type [-Wshift-count-overflow]
> >                          ^
> > ./include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of
> > macro ‘BIT’
> >  MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> >                                              ^~~
> > Use 32-bit friendly left shift.
> > 
> > Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits
> > and structures")
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeed@kernel.org>
> > ---
> >  include/linux/mlx5/mlx5_ifc.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/mlx5/mlx5_ifc.h
> > b/include/linux/mlx5/mlx5_ifc.h
> > index 0d6e287d614f..b9f15935dfe5 100644
> > --- a/include/linux/mlx5/mlx5_ifc.h
> > +++ b/include/linux/mlx5/mlx5_ifc.h
> > @@ -10711,9 +10711,9 @@ struct
> > mlx5_ifc_affiliated_event_header_bits {
> >  };
> > 
> >  enum {
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =
> > BIT(0xc),
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 1ULL <<
> > 0xc,
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = 1ULL << 0x13,
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = 1ULL << 0x20,
> >  };
> 
> Why not just use BIT_ULL?

I was following the file convention where we use 1ULL/1UL in all of the
places, I will consider changing the whole file to use BIT macros in
another patch.


