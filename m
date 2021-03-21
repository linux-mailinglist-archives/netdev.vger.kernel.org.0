Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2C3431B9
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 09:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCUIVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 04:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhCUIV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 04:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E84C6192A;
        Sun, 21 Mar 2021 08:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616314885;
        bh=sZeAvrNbCmudskU91ZW5ZXk9U+2kiJMsNtDifgyLJ1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Euo7aVpZ1qEOrnS+3SY71PLxJCX2RTOPwaOrtkHZm/RWnO6f0Dt0gK08Tz+RC6it7
         VPQTFup43bUvDX5oR1w8TGNmrjZYceiaiSICdqyIQdB1DOweQRAc0OCaciA0WNo1M1
         RX6kNHwpnltohDyHJadWiBXkaSrSVisjzII1coLL+kZlGIi4VpmmEy3YtoOei6z3Fd
         P338xAx3O683vDfL9LeNsUKAxnGp6n6SX+spbKXCYfLOZsetvLF1Rnqns8Lz6HGyvw
         KvtzFQO+0YaHQnlXtJYeFcDA7OaoQuUTPJ1bgREo95JuN6f9GGKThDnFXipI5uFUVE
         r8L9T6Zpl625w==
Date:   Sun, 21 Mar 2021 10:21:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Message-ID: <YFcCAr19ZXJ9vFQ5@unreal>
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320141729.1956732-3-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 09:17:29AM -0500, Alex Elder wrote:
> There are blocks of IPA code that sanity-check various values, at
> compile time where possible.  Most of these checks can be done once
> during development but skipped for normal operation.  These checks
> permit the driver to make certain assumptions, thereby avoiding the
> need for runtime error checking.
> 
> The checks are defined conditionally, but not consistently.  In
> some cases IPA_VALIDATION enables the optional checks, while in
> others IPA_VALIDATE is used.
> 
> Fix this by using IPA_VALIDATION consistently.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/Makefile       | 2 +-
>  drivers/net/ipa/gsi_trans.c    | 8 ++++----
>  drivers/net/ipa/ipa_cmd.c      | 4 ++--
>  drivers/net/ipa/ipa_cmd.h      | 6 +++---
>  drivers/net/ipa/ipa_endpoint.c | 6 +++---
>  drivers/net/ipa/ipa_main.c     | 6 +++---
>  drivers/net/ipa/ipa_mem.c      | 6 +++---
>  drivers/net/ipa/ipa_table.c    | 6 +++---
>  drivers/net/ipa/ipa_table.h    | 6 +++---
>  9 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> index afe5df1e6eeee..014ae36ac6004 100644
> --- a/drivers/net/ipa/Makefile
> +++ b/drivers/net/ipa/Makefile
> @@ -1,5 +1,5 @@
>  # Un-comment the next line if you want to validate configuration data
> -#ccflags-y		+=	-DIPA_VALIDATE
> +# ccflags-y		+=	-DIPA_VALIDATION

Maybe netdev folks think differently here, but general rule that dead
code and closed code is such, is not acceptable to in Linux kernel.

<...>

>  
> -#ifdef IPA_VALIDATE
> +#ifdef IPA_VALIDATION
>  	if (!size || size % 8)
>  		return -EINVAL;
>  	if (count < max_alloc)
>  		return -EINVAL;
>  	if (!max_alloc)
>  		return -EINVAL;
> -#endif /* IPA_VALIDATE */
> +#endif /* IPA_VALIDATION */

If it is possible to supply those values, the check should be always and
not only under some closed config option.

>  
>  	/* By allocating a few extra entries in our pool (one less
>  	 * than the maximum number that will be requested in a
> @@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>  	dma_addr_t addr;
>  	void *virt;
>  
> -#ifdef IPA_VALIDATE
> +#ifdef IPA_VALIDATION
>  	if (!size || size % 8)
>  		return -EINVAL;
>  	if (count < max_alloc)
>  		return -EINVAL;
>  	if (!max_alloc)
>  		return -EINVAL;
> -#endif /* IPA_VALIDATE */
> +#endif /* IPA_VALIDATION */

Same

<...>

>  {
> -#ifdef IPA_VALIDATE
> +#ifdef IPA_VALIDATION
>  	/* At one time we assumed a 64-bit build, allowing some do_div()
>  	 * calls to be replaced by simple division or modulo operations.
>  	 * We currently only perform divide and modulo operations on u32,
> @@ -768,7 +768,7 @@ static void ipa_validate_build(void)
>  	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
>  	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
>  			field_max(AGGR_GRANULARITY_FMASK));
> -#endif /* IPA_VALIDATE */
> +#endif /* IPA_VALIDATION */

BUILD_BUG_ON()s are checked during compilation and not during runtime
like IPA_VALIDATION promised.

IMHO, the issue here is that this IPA code isn't release quality but
some debug drop variant and it is far from expected from submitted code.

Thanks
