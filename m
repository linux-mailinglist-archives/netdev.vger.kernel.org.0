Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D455B2DA123
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502964AbgLNUJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:09:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502780AbgLNUJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:09:28 -0500
Message-ID: <565c26195b79ca998280d83aca0a193bd1a8c23e.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607976527;
        bh=NicHyuIicCHrf37JwKMXGmM1HPL8Af3WYSv61ARzkBg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cTWQHttVuj2p1Dn9DrkNhItLHVtxl3RUgMvYdcEl7cgLmrqwZA8Qri0vaphVpx7w4
         UJj0cYPdeZRgIBSpPVooI04S4+r3H1ADXK0Nb9+RXBqwsE+efVDFl2pcyTqA1tb8x9
         R3kKdb1apBEXtodUmQCQvwJig4QC/COVrWfTB0xeXxAbRNipfmxQQSn0MZMSSicZY/
         j06+lzL/VZO515uq2sO0dT3AdRvUYmSE6d77G8/XrBqcexrpok8BmTtx5N90rX8NGG
         s9WEnSGyD6r9sXc3zJ6wchiKQ7mEOztiQWTjEYLeJJQIEngyf243EH/52O9vOgzMwK
         BsaB/dhjq3lgA==
Subject: Re: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit
 platform
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Date:   Mon, 14 Dec 2020 12:08:46 -0800
In-Reply-To: <20201213123620.GC5005@unreal>
References: <20201213120641.216032-1-leon@kernel.org>
         <20201213123620.GC5005@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-12-13 at 14:36 +0200, Leon Romanovsky wrote:
> On Sun, Dec 13, 2020 at 02:06:41PM +0200, Leon Romanovsky wrote:
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
> > 
> > Use 32-bit friendly BIT_ULL macro.
> > 
> > Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits
> > and structures")
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  include/linux/mlx5/mlx5_ifc.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/mlx5/mlx5_ifc.h
> > b/include/linux/mlx5/mlx5_ifc.h
> > index 2006795fd522..8a359b8bee52 100644
> > --- a/include/linux/mlx5/mlx5_ifc.h
> > +++ b/include/linux/mlx5/mlx5_ifc.h
> > @@ -10709,9 +10709,9 @@ struct
> > mlx5_ifc_affiliated_event_header_bits {
> >  };
> > 
> >  enum {
> > -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
> > -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
> > -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> > +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =
> > BIT_ULL(0xc),
> > +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
> > +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
> 
> Or even better is to use "1ULL << 0x20" directly because we are not
> including bits.h in this mlx5_ifc.h file.
> 
> Should I resend?
> 
> Thanks

I will change this and attach this patch to my PR of the SF support.

Thanks,
Saeed.



