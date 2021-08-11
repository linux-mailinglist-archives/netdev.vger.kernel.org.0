Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFCC3E9004
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhHKMDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhHKMDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A7D760E93;
        Wed, 11 Aug 2021 12:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628683362;
        bh=XHoR5BqMPxzKlhQzjnPDWel87OITrOE6CsKd1mWHcHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kBMycUB5uB8gsx/uR3qd4MCTSpXUqPaTVF1DVryhH69XBG1S0CDhvpCTt3HjIP70+
         t/gza7u4P1GIGyomnOblxMEz0321w6+5Sp8fR3McPnZf4KtiqyVhm9Ykphqo30xH+s
         1M/evu3lE1719F0TI++92Sx1B86/6Y5xF04w/BP6D7cGq3q/QUuZDqIe3HaDi28mvn
         eQUi8PpcsmIKSodxh38vbDk5P9oPefb9mDaItwGBOL/qo/6wcL2/Ewe5b8af14dONp
         gw2cHlTeWOJoMBIuPg4aZYZnGmAXJoIdSxNVAD1v7HJmF1znvi8D1yVvkpzo0G3qke
         3ifLdeo0qnlIA==
Date:   Wed, 11 Aug 2021 15:02:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, lkp@intel.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: always inline
 ipa_aggr_granularity_val()
Message-ID: <YRO8Xtd9+RRMqw1J@unreal>
References: <20210810160213.2257424-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810160213.2257424-1-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 11:02:13AM -0500, Alex Elder wrote:
> It isn't required, but all callers of ipa_aggr_granularity_val()
> pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
> Two of those callers are in ipa_validate_build(), with the result
> being passed to BUILD_BUG_ON().
> 
> Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
> inline ipa_aggr_granularity_val(), so the result of the function is
> not constant at compile time, and that leads to build errors.
> 
> Define the function with the __always_inline attribute to avoid the
> errors.  And given that the function is inline, we can switch the
> WARN_ON() there to be BUILD_BUG_ON().
> 
> Fixes: 5bc5588466a1f ("net: ipa: use WARN_ON() rather than assertions")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 
> David/Jakub, this fixes a bug in a commit in net-next/master.  -Alex
> 
>  drivers/net/ipa/ipa_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 25bbb456e0078..f90b3521e266b 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -255,9 +255,9 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
>   * less than the number of timer ticks in the requested period.  0 is not
>   * a valid granularity value.
>   */
> -static u32 ipa_aggr_granularity_val(u32 usec)
> +static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
>  {
> -	WARN_ON(!usec);
> +	BUILD_BUG_ON(!usec);

So what exactly are you checking here if all callers pass same value?
It is in-kernel API, declared as static inside one module. There is no
need to protect from itself.

Thanks

>  
>  	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
>  }
> -- 
> 2.27.0
> 
