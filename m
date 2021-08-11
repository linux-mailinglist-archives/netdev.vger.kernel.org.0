Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8413E903A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhHKMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237509AbhHKMNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:13:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1738960F56;
        Wed, 11 Aug 2021 12:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628683966;
        bh=4URCwI+To5dzXx4W9xSAGUE66foFtybz8x7Tq5j21xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b0eCa2VNlzrHho/Aa0bnBVVEd1hZKqMFi/Ynn1MaDNzuT3jxIfgeIynU6uBdLeo0g
         bdHJ6dS95I1toqj12ufYyxGntNxxAkPNKx0C2UB63TrYici1Hl4751oZtZbTmtPrhq
         Qv3qp28v2acvPvCM3Y/qM/Ay+ooiCxMIqLut486eXliBDZY2Ydpnyjpw1SiYpRv8Si
         p81o0srOcOxLxKVbtIr7AVf3S1CoCne6hCveJHWzah23bNGjs7zjjxhxS7/fco7Ece
         RKduTGUoHfn3XVFhO4kKDVCSvt24h9Y8dxwXVZ9EqYxut56ES1ncn3eELk3Ouep15M
         ru2ZNWmJP3xgA==
Date:   Wed, 11 Aug 2021 15:12:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, lkp@intel.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: always inline
 ipa_aggr_granularity_val()
Message-ID: <YRO+uhPiS8g73rYk@unreal>
References: <20210810160213.2257424-1-elder@linaro.org>
 <YRO8Xtd9+RRMqw1J@unreal>
 <aed281de-dd9b-c185-66b3-e597548a9649@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed281de-dd9b-c185-66b3-e597548a9649@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 07:06:01AM -0500, Alex Elder wrote:
> On 8/11/21 7:02 AM, Leon Romanovsky wrote:
> > On Tue, Aug 10, 2021 at 11:02:13AM -0500, Alex Elder wrote:
> >> It isn't required, but all callers of ipa_aggr_granularity_val()
> >> pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
> >> Two of those callers are in ipa_validate_build(), with the result
> >> being passed to BUILD_BUG_ON().
> >>
> >> Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
> >> inline ipa_aggr_granularity_val(), so the result of the function is
> >> not constant at compile time, and that leads to build errors.
> >>
> >> Define the function with the __always_inline attribute to avoid the
> >> errors.  And given that the function is inline, we can switch the
> >> WARN_ON() there to be BUILD_BUG_ON().
> >>
> >> Fixes: 5bc5588466a1f ("net: ipa: use WARN_ON() rather than assertions")
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>
> >> David/Jakub, this fixes a bug in a commit in net-next/master.  -Alex
> >>
> >>  drivers/net/ipa/ipa_main.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> >> index 25bbb456e0078..f90b3521e266b 100644
> >> --- a/drivers/net/ipa/ipa_main.c
> >> +++ b/drivers/net/ipa/ipa_main.c
> >> @@ -255,9 +255,9 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
> >>   * less than the number of timer ticks in the requested period.  0 is not
> >>   * a valid granularity value.
> >>   */
> >> -static u32 ipa_aggr_granularity_val(u32 usec)
> >> +static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
> >>  {
> >> -	WARN_ON(!usec);
> >> +	BUILD_BUG_ON(!usec);
> > 
> > So what exactly are you checking here if all callers pass same value?
> > It is in-kernel API, declared as static inside one module. There is no
> > need to protect from itself.
> 
> Yeah that's a good point.  It can just as well be removed.
> I think the check was added before I knew it was only going
> to be used with a single constant value.  That said, the
> point was to check at runtime a required constraint.
> 
> I'll post version 2 that simply removes it.  Thanks.

Thanks
> 
> 					-Alex
> 
> > 
> > Thanks
> > 
> >>  
> >>  	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
> >>  }
> >> -- 
> >> 2.27.0
> >>
> 
