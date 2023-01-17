Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7866DBD4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbjAQLGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbjAQLFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:05:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB8D33452;
        Tue, 17 Jan 2023 03:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D2661259;
        Tue, 17 Jan 2023 11:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDEC433F0;
        Tue, 17 Jan 2023 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673953532;
        bh=Ws6bYjktfAa3ykUB/mBwXFuiIGGLxks20tludXizU5M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QzlVWCb6Kmn/hKx29anWubOoL56OGBUDszmyH7SNrupgL1fkYrwLi7kL1gYpVS2Yi
         HwhFa0juD82m7f1LzKRFF693iFYGFvecRXVJwPdQpYjSxJpcanyPDxkllToSk7wED4
         68bJlGzZjKN7n9+E4FtVbH5t4j1QXJ62PrRSmbh5sCioxcIf6eGFHkcd3E9e/GT7Cy
         kiqsYatPwBI52MH8BQLp7bAmzb+6B/TWY0k6iHslUz+90bHfyfMB5MRiBsQ3iyWTvp
         46qKiIHGvxsTkqnQ1IPTiN3ZoH50i8FYMEWbzM8ONqK/REL7SnUxJx9WOAWT340gl7
         sDXzOWFxDvLRw==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix allocation size
In-Reply-To: <20230117104508.GB12547@altlinux.org> (Alexey V. Vissarionov's
        message of "Tue, 17 Jan 2023 13:45:08 +0300")
References: <20230117104508.GB12547@altlinux.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 17 Jan 2023 13:05:24 +0200
Message-ID: <87o7qxxvyj.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Alexey V. Vissarionov" <gremlin@altlinux.org> writes:

> The "pkt" is a pointer to struct sk_buff, so it's just 4 or 8
> bytes, while the structure itself is much bigger.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: bbd1f932e7c45ef1 ("brcmfmac: cleanup ampdu-rx host reorder code")
> Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
>
> diff --git
> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> index 36af81975855c525..0d283456da331464 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> @@ -1711,7 +1711,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp,
> struct sk_buff *pkt)
>  		buf_size = sizeof(*rfi);
>  		max_idx = reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
>  
> -		buf_size += (max_idx + 1) * sizeof(pkt);
> +		buf_size += (max_idx + 1) * sizeof(struct sk_buff);

Wouldn't sizeof(*pkt) be better? Just like with sizeof(*rfi) few lines
above.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
