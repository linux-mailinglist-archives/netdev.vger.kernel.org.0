Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60432B9A1E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgKSRyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbgKSRyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:54:05 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB25D246CA;
        Thu, 19 Nov 2020 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605808445;
        bh=yJp7iJem6q+MZlRJm8rjA0vJmp/eehmybbXyVpb5u4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lqPweI55+BPR/em2OjeIPkD1mhSZLXfSouYrd8pSvlpWKqDCoq3h2Bw3Vaef3FzyX
         VXZLOj6GUbHxv3qzcnIafpWawPWvAZeE7r0zvi+n2VnDI9HjItDVorcbIzu1vyCg4b
         dinngTFIbGbaWAFcJykE8tvR7MU8wu8Z3ziFwttY=
Date:   Thu, 19 Nov 2020 09:54:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next resend 1/2] enetc: Fix endianness issues for
 enetc_ethtool
Message-ID: <20201119095403.63325987@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAOJe8K1ccPn8fJc1bfNwt2O7Z2cYmCXiUmytgp-O4RUO5GhC3Q@mail.gmail.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
        <20201119101215.19223-2-claudiu.manoil@nxp.com>
        <CAOJe8K1ccPn8fJc1bfNwt2O7Z2cYmCXiUmytgp-O4RUO5GhC3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 13:37:21 +0300 Denis Kirjanov wrote:
> On 11/19/20, Claudiu Manoil <claudiu.manoil@nxp.com> wrote:
> > These particular fields are specified in the H/W reference
> > manual as having network byte order format, so enforce big
> > endian annotation for them and clear the related sparse
> > warnings in the process.
> >
> > Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/enetc/enetc_hw.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > index 68ef4f959982..04efccd11162 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > @@ -472,10 +472,10 @@ struct enetc_cmd_rfse {
> >  	u8 smac_m[6];
> >  	u8 dmac_h[6];
> >  	u8 dmac_m[6];
> > -	u32 sip_h[4];
> > -	u32 sip_m[4];
> > -	u32 dip_h[4];
> > -	u32 dip_m[4];
> > +	__be32 sip_h[4];
> > +	__be32 sip_m[4];
> > +	__be32 dip_h[4];
> > +	__be32 dip_m[4];
> >  	u16 ethtype_h;
> >  	u16 ethtype_m;
> >  	u16 ethtype4_h;  
> 
> Hi Claudiu,
> 
> Why the struct is declared without packed?
> I'm seeing that the structure is used in dma transfers in the driver

We prefer not to pack structs unnecessarily in netdev, because it
forces compilers to do inefficient loads on some arches. If the
structure is laid out correctly according to normal C data layout rules
it should be left alone. 

You can add compile times assertions on the size of the structures
to make double-sure things don't break.
