Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9C83946D5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 20:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhE1SMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 14:12:42 -0400
Received: from phobos.denx.de ([85.214.62.61]:49468 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhE1SMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 14:12:40 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 775EB81FF5;
        Fri, 28 May 2021 20:11:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1622225463;
        bh=n6tFuTd1bckgtO6kRkILOeOeUjK2YzKwiXOZP4uCjNE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=r4LocHsOfDDi304f0ET3nW2WIbvDHXJFgQ/s8tloOJtcSvUaYED5pSthteTsqbxt/
         7Ouj6Yjc88cI/Lzk/egPtNz/R0q9RoOoS7bXdQ7Lu6EiK3fqtrGR/B3d3zUezoCEg5
         FYHNuvxfp8SnVGwZFcuq/1Nro0iJXnIX/4wY4TRW9nQJCCvrcth4SO3nNV2AHbfeyJ
         JWb8E7ePo4I1/DunPgwR3qXGXguwP8Mf6rbkPBbh2yS1DGm9JkTZiFr9zfvJuIOfxI
         TXOcWw8jXiVFWFLowSy8vwLF3r7URh3Qnku4h4ztxGwDlHLwthS4FEBcRSIel7OJku
         ALNMrJyRcLYTw==
Subject: Re: [PATCH] rsi: fix broken AP mode due to unwanted encryption
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Amitkumar Karwar <amitkarwar@gmail.com>
Cc:     stable@vger.kernel.org, Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1622222314-17192-1-git-send-email-martin.fuzzey@flowbird.group>
From:   Marek Vasut <marex@denx.de>
Message-ID: <6f1d3952-c30e-4a6d-9857-5a6d68e962b2@denx.de>
Date:   Fri, 28 May 2021 20:11:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1622222314-17192-1-git-send-email-martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 7:17 PM, Martin Fuzzey wrote:
> In AP mode WPA-PSK connections were not established.
> 
> The reason was that the AP was sending the first message
> of the 4 way handshake encrypted, even though no key had
> (correctly) yet been set.
> 
> Fix this by adding an extra check that we have a key.
> 
> The redpine downstream out of tree driver does it this way too.
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> CC: stable@vger.kernel.org

This likely needs a Fixes: tag ?

> ---
>   drivers/net/wireless/rsi/rsi_91x_hal.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
> index ce98921..ef84262 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_hal.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
> @@ -203,6 +203,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
>   		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
>   
>   	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
> +	    (info->control.hw_key) &&

The () are not needed.

>   	    (common->secinfo.security_enable)) {
>   		if (rsi_is_cipher_wep(common))
>   			ieee80211_size += 4;
> 
Otherwise, looks good, thanks. With those two things above fixed, add:

Reviewed-by: Marek Vasut <marex@denx.de>
