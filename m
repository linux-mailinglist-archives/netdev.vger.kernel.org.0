Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E91F269C80
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 05:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgIODZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 23:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgIODZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 23:25:11 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742AB20684;
        Tue, 15 Sep 2020 03:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600140310;
        bh=RWrWk57pznwEZaqUARPii65hMfIeSjo9uSwjvFQoDJQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OXFkdtbQ+xjTabPuPDuJUf4RwcBmKNDlWtGAsinMU9l5qBF4U1RI/kv/PoxMrs4GK
         pgZNlniAJhhZ2HdQ/NLtae3LM1dEVl76cABBDts1zyHE6r5+j4trDHnkxI9FSAURWw
         PvNNYesKTwkRZO0Lns0D2R+5tF4Udk6V06FGJUz8=
Message-ID: <e15b85af416c7257aaa601901b18c7c9bc9586e0.camel@kernel.org>
Subject: Re: [PATCH net-next v2 06/10] drivers/net/ethernet: handle one
 warning explicitly
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Date:   Mon, 14 Sep 2020 20:25:09 -0700
In-Reply-To: <20200915014455.1232507-7-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
         <20200915014455.1232507-7-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-14 at 18:44 -0700, Jesse Brandeburg wrote:
> While fixing the W=1 builds, this warning came up because the
> developers used a very tricky way to get structures initialized
> to a non-zero value, but this causes GCC to warn about an
> override. In this case the override was intentional, so just
> disable the warning for this code with a macro that results
> in disabling the warning for compiles on GCC versions after 8.
> 
> NOTE: the __diag_ignore macro currently only accepts a second
> argument of 8 (version 80000)
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c
> b/drivers/net/ethernet/renesas/sh_eth.c
> index 586642c33d2b..c63304632935 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -45,6 +45,15 @@
>  #define SH_ETH_OFFSET_DEFAULTS			\
>  	[0 ... SH_ETH_MAX_REGISTER_OFFSET - 1] = SH_ETH_OFFSET_INVALID
>  
> +/* use some intentionally tricky logic here to initialize the whole
> struct to
> + * 0xffff, but then override certain fields, requiring us to
> indicate that we
> + * "know" that there are overrides in this structure, and we'll need
> to disable
> + * that warning from W=1 builds. GCC has supported this option since
> 4.2.X, but
> + * the macros available to do this only define GCC 8.
> + */
> +__diag_push();
> +__diag_ignore(GCC, 8, "-Woverride-init",
> +	      "logic to initialize all and then override some is OK");
>  static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] =
> {
>  	SH_ETH_OFFSET_DEFAULTS,
>  
> @@ -332,6 +341,7 @@ static const u16
> sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
>  
>  	[TSU_ADRH0]	= 0x0100,
>  };
> +__diag_pop();
>  

I don't have any strong feeling against disabling compiler warnings,
but maybe the right thing to do here is to initialize the gaps to the
invalid value instead of pre-initializing the whole thing first and
then setting up the valid values on the 2nd pass.

I don't think there are too many gaps to fill, it is doable, so maybe
add this as a comment to this driver maintainer so they could pickup
the work from here.


