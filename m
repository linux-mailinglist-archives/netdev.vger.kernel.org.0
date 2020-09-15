Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543DA26B07B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgIOQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:44:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:10809 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgIOQmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:42:14 -0400
IronPort-SDR: KWegu6OuociK4oIxPsIY26z5IqrF2MWT8JlhLv+6SMID37EilqUGfOs/iSPYvmIiVc9Uzfu8+K
 ac31BoeuOpoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="244130883"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="244130883"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:41:36 -0700
IronPort-SDR: X1Z8bwqnLS38s1hSAEgytpQLbi6j4B/9YrhjrX4W475Rl5ZLgkvoZXnWAYIpVQfTQCszaMK3rj
 J8RyfodN2jpQ==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="338733991"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.118.172])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:41:36 -0700
Date:   Tue, 15 Sep 2020 09:41:35 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/10] drivers/net/ethernet: handle one
 warning explicitly
Message-ID: <20200915094135.00005d21@intel.com>
In-Reply-To: <e15b85af416c7257aaa601901b18c7c9bc9586e0.camel@kernel.org>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
        <20200915014455.1232507-7-jesse.brandeburg@intel.com>
        <e15b85af416c7257aaa601901b18c7c9bc9586e0.camel@kernel.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saeed Mahameed wrote:

> On Mon, 2020-09-14 at 18:44 -0700, Jesse Brandeburg wrote:
> > While fixing the W=1 builds, this warning came up because the
> > developers used a very tricky way to get structures initialized
> > to a non-zero value, but this causes GCC to warn about an
> > override. In this case the override was intentional, so just
> > disable the warning for this code with a macro that results
> > in disabling the warning for compiles on GCC versions after 8.
> > 
> > NOTE: the __diag_ignore macro currently only accepts a second
> > argument of 8 (version 80000)
> > 
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> >  drivers/net/ethernet/renesas/sh_eth.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/renesas/sh_eth.c
> > b/drivers/net/ethernet/renesas/sh_eth.c
> > index 586642c33d2b..c63304632935 100644
> > --- a/drivers/net/ethernet/renesas/sh_eth.c
> > +++ b/drivers/net/ethernet/renesas/sh_eth.c
> > @@ -45,6 +45,15 @@
> >  #define SH_ETH_OFFSET_DEFAULTS			\
> >  	[0 ... SH_ETH_MAX_REGISTER_OFFSET - 1] = SH_ETH_OFFSET_INVALID
> >  
> > +/* use some intentionally tricky logic here to initialize the whole
> > struct to
> > + * 0xffff, but then override certain fields, requiring us to
> > indicate that we
> > + * "know" that there are overrides in this structure, and we'll need
> > to disable
> > + * that warning from W=1 builds. GCC has supported this option since
> > 4.2.X, but
> > + * the macros available to do this only define GCC 8.
> > + */
> > +__diag_push();
> > +__diag_ignore(GCC, 8, "-Woverride-init",
> > +	      "logic to initialize all and then override some is OK");
> >  static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] =
> > {
> >  	SH_ETH_OFFSET_DEFAULTS,
> >  
> > @@ -332,6 +341,7 @@ static const u16
> > sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
> >  
> >  	[TSU_ADRH0]	= 0x0100,
> >  };
> > +__diag_pop();
> >  
> 
> I don't have any strong feeling against disabling compiler warnings,
> but maybe the right thing to do here is to initialize the gaps to the
> invalid value instead of pre-initializing the whole thing first and
> then setting up the valid values on the 2nd pass.
> 
> I don't think there are too many gaps to fill, it is doable, so maybe
> add this as a comment to this driver maintainer so they could pickup
> the work from here.


added linux-renesas-soc list. @list, any comments on Saeed's comment
above?

Thanks,
 Jesse
