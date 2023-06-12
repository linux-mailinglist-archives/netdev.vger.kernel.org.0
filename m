Return-Path: <netdev+bounces-10177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DBB72CA9D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4B77281033
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EDF1E505;
	Mon, 12 Jun 2023 15:48:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41BB1C75F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D18C433D2;
	Mon, 12 Jun 2023 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686584919;
	bh=jQ+rL75l22bHoctPRsB9lhnFOSq0+lgJxnLiA9gDptw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fQ9H8ZAYpux1mfoybhZH901qxsE7mB/XDXn0ndFJuOXmEPoV74GmU3UKoR+uPQlP8
	 nR+J2DSTi/Mkpbt8rmJhumMgZj8byT78B9Eu4AVMi4tU0JMZCRzAlcKOuzdpNebDRW
	 hpew3PpVmaG1KhdeUzHJvoFX/xKsilUUSFYRKSnLfLMxP9fezSpFGPLRMmFp7AWeLw
	 gViyfXWuP7LuLNZ9qwy3H5WZ0UMP/tt3iUtw0k9MJLQ7xrzf3CSd6xwqae2D/sFAue
	 iI8vJg1e/iWIg1JwLjGZcV/vpXm50j6QF+i0m0TtLh8OAb5ljCfu06wid4NzJhs8Ok
	 dkM43ncEE68hw==
Date: Mon, 12 Jun 2023 08:48:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
 vladyslavt@nvidia.com, linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <20230612084837.6c5b5ca9@kernel.org>
In-Reply-To: <ZIV6L+pIUvZ1tip4@shredder>
References: <20230609004400.1276734-1-kuba@kernel.org>
	<ZIV6L+pIUvZ1tip4@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Jun 2023 10:39:27 +0300 Ido Schimmel wrote:
> > I was asked if "Linux reports" this information.
> > I'm not very confident on the merits, I'm going by the spec.
> > If it makes sense I'll send a similar patch for CMIS.  
> 
> I have two AOC connected to each other. When both are up:
> 
> # ethtool -m swp13 | grep "Rx loss of signal" -A 4
>         Rx loss of signal                         : None
>         Tx loss of signal                         : None
>         Rx loss of lock                           : None
>         Tx loss of lock                           : None
>         Tx adaptive eq fault                      : None
> 
> When I bring the other side down:
> 
> # ip link set dev swp14 down
> # ethtool -m swp13 | grep "Rx loss of signal" -A 4
>         Rx loss of signal                         : [ Yes, Yes, Yes, Yes ]
>         Tx loss of signal                         : None
>         Rx loss of lock                           : [ Yes, Yes, Yes, Yes ]
>         Tx loss of lock                           : None
>         Tx adaptive eq fault                      : None
> 
> When I bring the interface itself down:
> 
> # ip link set dev swp13 down
> # ethtool -m swp13 | grep "Rx loss of signal" -A 4
>         Rx loss of signal                         : [ Yes, Yes, Yes, Yes ]
>         Tx loss of signal                         : [ Yes, Yes, Yes, Yes ]
>         Rx loss of lock                           : [ Yes, Yes, Yes, Yes ]
>         Tx loss of lock                           : [ Yes, Yes, Yes, Yes ]
>         Tx adaptive eq fault                      : [ Yes, Yes, Yes, Yes ]
> 
> And I don't see these fields on PC:
> 
> # ethtool -m swp3 | grep "Rx loss of signal" -A 4

IOW works as expected, am I interpreting this correctly?

> > diff --git a/qsfp.h b/qsfp.h
> > index aabf09fdc623..b4a0ffe06da1 100644
> > --- a/qsfp.h
> > +++ b/qsfp.h
> > @@ -55,6 +55,8 @@
> >  #define	 SFF8636_TX2_FAULT_AW	(1 << 1)
> >  #define	 SFF8636_TX1_FAULT_AW	(1 << 0)
> >  
> > +#define	SFF8636_LOL_AW_OFFSET	0x05
> > +
> >  /* Module Monitor Interrupt Flags - 6-8 */
> >  #define	SFF8636_TEMP_AW_OFFSET	0x06
> >  #define	 SFF8636_TEMP_HALARM_STATUS		(1 << 7)
> > @@ -525,9 +527,15 @@
> >  /*  56h-5Fh reserved */
> >  
> >  #define	 SFF8636_OPTION_2_OFFSET	0xC1
> > +/* Tx input equalizers auto-adaptive */
> > +#define	  SFF8636_O2_TX_EQ_AUTO		(1 << 3)
> >  /* Rx output amplitude */
> >  #define	  SFF8636_O2_RX_OUTPUT_AMP	(1 << 0)
> >  #define	 SFF8636_OPTION_3_OFFSET	0xC2
> > +/* Rx CDR Loss of Lock */
> > +#define	  SFF8636_O3_RX_LOL		(1 << 5)
> > +/* Tx CDR Loss of Lock */
> > +#define	  SFF8636_O3_TX_LOL		(1 << 4)  
> 
> I'm looking at revision 2.10a and bit 4 is Rx while bit 5 is Tx.

Ugh, you're right, thanks.

