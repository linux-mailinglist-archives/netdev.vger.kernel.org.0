Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E13435B497
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhDKN2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 09:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhDKN2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 09:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 668AA61042;
        Sun, 11 Apr 2021 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618147715;
        bh=PG4kqQZC0C6teZuojGxYzzZ517iaE42zQVnfJXJE7Lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bb1DYdseG6I8texPAGMIOZRMeYi5JPI/p5TyxnzH6W1k6qERJvJ+BvrO59KkyXG4u
         22yf+oV6a9tlW+qAwz0F+rTK8rtxr9hIEAvG0n74IVQYruThNYh3YtUOK3zF5clbm6
         bqZ9Jh6YtpagCR/FQBQGgu1C9Om6U/ipafbS9XJ5XjyKFywvc3LgswN8JwnkAC0Owk
         E9w02PkInBGMsHN8lC5gavEMt2PWpBbIPBApVUWK9jf+aWGgpfcoLRu5iMaMKJbF1W
         12Kn1TlqYx8Skw6pPfNBwTctgvBMBns9Qe+Vm6OpHUAMuErFGGDxarePbhpvYOs7MU
         sqSPHDA6/gSCw==
Date:   Sun, 11 Apr 2021 16:28:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
Message-ID: <YHL5fwkYyHvQG2Z4@unreal>
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org>
 <YHKYWCkPl5pucFZo@unreal>
 <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:09:55AM -0500, Alex Elder wrote:
> On 4/11/21 1:34 AM, Leon Romanovsky wrote:
> > On Fri, Apr 09, 2021 at 01:07:19PM -0500, Alex Elder wrote:
> >> In ipa_modem_stop(), if the modem netdev pointer is non-null we call
> >> ipa_stop().  We check for an error and if one is returned we handle
> >> it.  But ipa_stop() never returns an error, so this extra handling
> >> is unnecessary.  Simplify the code in ipa_modem_stop() based on the
> >> knowledge no error handling is needed at this spot.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>  drivers/net/ipa/ipa_modem.c | 18 ++++--------------
> >>  1 file changed, 4 insertions(+), 14 deletions(-)
> > 
> > <...>
> > 
> >> +	/* Stop the queue and disable the endpoints if it's open */
> >>  	if (netdev) {
> >> -		/* Stop the queue and disable the endpoints if it's open */
> >> -		ret = ipa_stop(netdev);
> >> -		if (ret)
> >> -			goto out_set_state;
> >> -
> >> +		(void)ipa_stop(netdev);
> > 
> > This void casting is not needed here and in more general case sometimes
> > even be seen as a mistake, for example if the returned attribute declared
> > as __must_check.
> 
> I accept your point but I feel like it's sort of a 50/50 thing.
> 
> I think *not* checking an available return value is questionable
> practice.  I'd really rather have a build option for a
> "__need_not_check" tag and have "must_check" be the default.

__need_not_check == void ???

> 
> The void cast here says "I know this returns a result, but I am
> intentionally not checking it."  If it had been __must_check I
> would certainly have checked it.  
> 
> That being said, I don't really care that much, so I'll plan
> to post version 2, which will drop this cast (I'll probably
> add a comment though).

Thanks

> 
> Thanks.
> 
> 					-Alex
> 
> > 
> > Thanks
> > 
> 
