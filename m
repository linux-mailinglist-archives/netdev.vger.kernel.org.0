Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D4F5EB6E9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiI0Bd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiI0Bd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1E6F3912;
        Mon, 26 Sep 2022 18:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DA2E6150C;
        Tue, 27 Sep 2022 01:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6047FC433C1;
        Tue, 27 Sep 2022 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664242433;
        bh=ZT3oXGhAudvES/gLqMW1J/eJqd1J+wW1rTEmmcqBNtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=shbj8/ezkc9lgD1K0T0SMcluJ1100Nsggnb1Ywgc2dNsqXr8jZB8Cuc3YUjxxxsf3
         zMS14OFt6PVkdEFt6K+d0Lt03/cj5bkXE5F+p34PBsssjOrFaYM8lEErDT2lNzlVct
         ctiyLPkvgD2NL1TsTuUBFOZ46xizx0OrYkC41y6ZlTJL9yXi9UfXm0OaVmUde121wm
         9jRyw9fb87q3+y1fE+ZQyKGlvb9+wPPkQLEZQiEIExKtUsFvl6j2EMmhxy4nqaUGKy
         ojNMxLBPp9y43V+QNxdB+zPtKrWXMT/LaTaSVd8yS6kUu8E9bF/FL5vi+kBujEMoi7
         DZ4ZVbeoGMpxQ==
Date:   Mon, 26 Sep 2022 20:33:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] wifi: nl80211: Split memcpy() of struct
 nl80211_wowlan_tcp_data_token flexible array
Message-ID: <YzJS+wRX0nu3qE4F@work>
References: <20220927003903.1941873-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927003903.1941873-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:39:03PM -0700, Kees Cook wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 2705e3ee8fc4..461897933e92 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -13171,7 +13171,8 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
>  	       wake_mask_size);
>  	if (tok) {
>  		cfg->tokens_size = tokens_size;
> -		memcpy(&cfg->payload_tok, tok, sizeof(*tok) + tokens_size);
> +		cfg->payload_tok = *tok;
> +		memcpy(cfg->payload_tok.token_stream, tok->token_stream, + tokens_size);

There is a spurious '+' here............................................^^^

--
Gustavo

>  	}
>  
>  	trig->tcp = cfg;
> -- 
> 2.34.1
> 
