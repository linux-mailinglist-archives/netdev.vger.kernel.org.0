Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D274E5BAFCE
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiIPPCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiIPPCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:02:05 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40CB8A6C4
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:02:02 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u132so21494712pfc.6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=izfqvSHT07bmauJJnncWn7aTa0Y1sFSQsExFZJ1Yduw=;
        b=RkSbXqU77kgF73MzkxiKVVx8b4tthqwirz2R3A9X8MLspDsqIRXK7GT2GWNSe2e1ih
         E+kgT813ZcD5S3q04T29NJghLx/v2lmci1JjMUXOvIhqDECMxYUT+kuR1EjkFpEeBNfP
         /maCJ4zINiSa5FZiFMKBaqyLMxH4zF4819tCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=izfqvSHT07bmauJJnncWn7aTa0Y1sFSQsExFZJ1Yduw=;
        b=VhmmVkz7VmqnaIg4eOwpF4KLsNAvEXRQW90ag0gue9rJ7k95RJUa03zW/LrQ3JKelR
         HFxs6qhTN/UnmbInDwHf66EWZ+KeZDjisDi91h1vqLrZK60UWU/N9kt+ICcrqMyqfW6/
         nb4ubfoY9Qi4BNGDiINAijInWsnQv7X6gbDv8GHsTT4OULJ/njlsb2Aa/PzTb8iMip0O
         cU5ZNMu0yhSfc9Pz1fbpsKlzQTotOrdH5KVBf6UOi7/Ksj6c4nY5ebXMNyP+x7IbqoSh
         qPesqJcsMi+xs7vqOnUVAcHoyESmCEG5WKkenpIq3Yx/Bk/f+GfKL/sdJ/LPZiEx3rjT
         qzQg==
X-Gm-Message-State: ACrzQf1MuaqQh5lghHr/LtzDtTWGRV8IuwYYuiwAF70LZ4acaEit51+a
        3LIY2PIpZUWWisHeAN+GoU7Ltw==
X-Google-Smtp-Source: AMsMyM6Dqkj/fmEvUY9GlAeBcJhGA7ZHq3jh4t+LYjXIvM6e9pllccBvkzgY3UMMnVz++MBaBGfTNQ==
X-Received: by 2002:a05:6a00:84d:b0:542:4254:17ef with SMTP id q13-20020a056a00084d00b00542425417efmr5827589pfk.31.1663340522396;
        Fri, 16 Sep 2022 08:02:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b27-20020aa7951b000000b0053e6eae9665sm15105664pfp.140.2022.09.16.08.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 08:02:01 -0700 (PDT)
Date:   Fri, 16 Sep 2022 08:02:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 3/3] wireguard: netlink: avoid variable-sized memcpy
 on sockaddr
Message-ID: <202209160743.C860E8700@keescook>
References: <20220916143740.831881-1-Jason@zx2c4.com>
 <20220916143740.831881-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916143740.831881-4-Jason@zx2c4.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 03:37:40PM +0100, Jason A. Donenfeld wrote:
> Doing a variable-sized memcpy is slower, and the compiler isn't smart
> enough to turn this into a constant-size assignment.
> 
> Further, Kees' latest fortified memcpy will actually bark, because the
> destination pointer is type sockaddr, not explicitly sockaddr_in or
> sockaddr_in6, so it thinks there's an overflow:
> 
>     memcpy: detected field-spanning write (size 28) of single field
>     "&endpoint.addr" at drivers/net/wireguard/netlink.c:446 (size 16)
> 
> Fix this by just assigning by using explicit casts for each checked
> case.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/net/wireguard/netlink.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
> index d0f3b6d7f408..5c804bcabfe6 100644
> --- a/drivers/net/wireguard/netlink.c
> +++ b/drivers/net/wireguard/netlink.c
> @@ -436,14 +436,13 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
>  	if (attrs[WGPEER_A_ENDPOINT]) {
>  		struct sockaddr *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
>  		size_t len = nla_len(attrs[WGPEER_A_ENDPOINT]);
> +		struct endpoint endpoint = { { { 0 } } };

FWIW, this is equivalent[1] on all our compiler versions now:

+		struct endpoint endpoint = { };

>  
> -		if ((len == sizeof(struct sockaddr_in) &&
> -		     addr->sa_family == AF_INET) ||
> -		    (len == sizeof(struct sockaddr_in6) &&
> -		     addr->sa_family == AF_INET6)) {
> -			struct endpoint endpoint = { { { 0 } } };
> -
> -			memcpy(&endpoint.addr, addr, len);
> +		if (len == sizeof(struct sockaddr_in) && addr->sa_family == AF_INET) {
> +			endpoint.addr4 = *(struct sockaddr_in *)addr;
> +			wg_socket_set_peer_endpoint(peer, &endpoint);
> +		} else if (len == sizeof(struct sockaddr_in6) && addr->sa_family == AF_INET6) {
> +			endpoint.addr6 = *(struct sockaddr_in6 *)addr;
>  			wg_socket_set_peer_endpoint(peer, &endpoint);
>  		}
>  	}

Ah, sneaky! I like it. :)

Reviewed-by: Kees Cook <keescook@chromium.org>


I wonder if we need a "converter" struct to help with this -- this isn't
the only place this code pattern exists.

struct sockaddr_decode {
	union {
		struct sockaddr		addr;
		struct sockaddr_in	addr4;
		struct sockaddr_in6	addr6;
		DECLARE_FLEX_ARRAY(u8,	content);
	};
};

	struct sockaddr_decode *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
	...
	if (len == sizeof(addr->addr4) && addr->addr.sa_family == AF_INET) {
		endpoint.addr4 = addr->addr4;
	...


This looks a lot like these open issues we've had for a while:
https://github.com/KSPP/linux/issues/169
https://github.com/KSPP/linux/issues/140

-Kees

[1] https://lore.kernel.org/lkml/20210910225207.3272766-1-keescook@chromium.org/

-- 
Kees Cook
