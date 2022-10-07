Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A965F74CC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJGHo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJGHoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:44:25 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173CBDED00;
        Fri,  7 Oct 2022 00:44:22 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a7dd:f566:73:8aea:58ff] (p200300e9d724a7ddf56600738aea58ff.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a7dd:f566:73:8aea:58ff])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BBE59C04DF;
        Fri,  7 Oct 2022 09:44:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665128661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SIfCLYWhDUFwzue6wEqXVr58o/uqP9e248unx6ieZT4=;
        b=JmG/vBtX1OZfElT3wzDuzuNmQfLyGGprdLOsVWXFyqynGudWlEzHUKinC+IS1MgcNuKAc3
        2CBDSCgN3dkuLpueGPY9KmzZ2VFG7XjcyoWlYLtKeksCoPraL5vSfM7ABEB/lduX4Ky7iM
        eJXPgoAjYSn95Afmrrv/P6GggDVGsEoKE8FNgrXv4ZMjT2d+B26g957iLwOTGxzzUz/oLC
        tqGbKFNIs0f948I+nexYrXnEwkvr5yuZmQjr5xJYLBtt+mMT9X1Av+MrIwx7In/8K1Q3AS
        ya7GmvIAmNfFAjlBy4vHfDk3tSv/5pJq0QScMHwtUYVYaGL9Tv+bKZPHctpbvw==
Message-ID: <75be7065-e9ca-cba0-43e8-e3e0ffae538e@datenfreihafen.org>
Date:   Fri, 7 Oct 2022 09:44:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net OR wpan] net: ieee802154: return -EINVAL for unknown
 addr type
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>, tcs.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221006020237.318511-1-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221006020237.318511-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 06.10.22 04:02, Alexander Aring wrote:
> This patch adds handling to return -EINVAL for an unknown addr type. The
> current behaviour is to return 0 as successful but the size of an
> unknown addr type is not defined and should return an error like -EINVAL.
> 
> Fixes: 94160108a70c ("net/ieee802154: fix uninit value bug in dgram_sendmsg")
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   include/net/ieee802154_netdev.h | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> index a8994f307fc3..03b64bf876a4 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -185,21 +185,27 @@ static inline int
>   ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
>   {
>   	struct ieee802154_addr_sa *sa;
> +	int ret = 0;
>   
>   	sa = &daddr->addr;
>   	if (len < IEEE802154_MIN_NAMELEN)
>   		return -EINVAL;
>   	switch (sa->addr_type) {
> +	case IEEE802154_ADDR_NONE:
> +		break;
>   	case IEEE802154_ADDR_SHORT:
>   		if (len < IEEE802154_NAMELEN_SHORT)
> -			return -EINVAL;
> +			ret = -EINVAL;
>   		break;
>   	case IEEE802154_ADDR_LONG:
>   		if (len < IEEE802154_NAMELEN_LONG)
> -			return -EINVAL;
> +			ret = -EINVAL;
> +		break;
> +	default:
> +		ret = -EINVAL;
>   		break;
>   	}
> -	return 0;
> +	return ret;
>   }
>   
>   static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
