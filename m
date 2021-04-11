Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20435B204
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 08:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhDKGeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 02:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhDKGeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 02:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74EC260233;
        Sun, 11 Apr 2021 06:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618122845;
        bh=E+zS1GucVpnc1S/WzIUFUGJ2q+K67CMTTp3C6hulqv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8RQAuwj5jHnTDT/528vkL3tjTlpBIvloX1advafNyyN09rChNrdvNJjjRTCaVo3x
         Q58J6YJegcxTLAEUtFKnk2baVmEJMbZElJluFGfOTwYSkJjxMfh39Wk7qQACl0bYtU
         Kjz3UlKFC1m6cPdN8qWyX+nv55dZ01x2fJkLJv0rZnaN1L1OULabwIjAUNGaJiZA6o
         taQl9YtNZpX3OtOFWf6Ud4AY7NSMAp3pB6xn6GZg9Lk7RqCcscg3j5YCCZDtVECSHZ
         9SphWFWR24DN9d07YXq2pgmr9QVQQNXn1MsyecyWg89DOa2USwTUSzBindVsmCejEu
         utx64jWsghCVA==
Date:   Sun, 11 Apr 2021 09:34:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
Message-ID: <YHKYWCkPl5pucFZo@unreal>
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409180722.1176868-5-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 01:07:19PM -0500, Alex Elder wrote:
> In ipa_modem_stop(), if the modem netdev pointer is non-null we call
> ipa_stop().  We check for an error and if one is returned we handle
> it.  But ipa_stop() never returns an error, so this extra handling
> is unnecessary.  Simplify the code in ipa_modem_stop() based on the
> knowledge no error handling is needed at this spot.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_modem.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)

<...>

> +	/* Stop the queue and disable the endpoints if it's open */
>  	if (netdev) {
> -		/* Stop the queue and disable the endpoints if it's open */
> -		ret = ipa_stop(netdev);
> -		if (ret)
> -			goto out_set_state;
> -
> +		(void)ipa_stop(netdev);

This void casting is not needed here and in more general case sometimes
even be seen as a mistake, for example if the returned attribute declared
as __must_check.

Thanks
