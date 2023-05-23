Return-Path: <netdev+bounces-4722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1510470E04D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43C21C20D7A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326681F947;
	Tue, 23 May 2023 15:21:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4441F922
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952D5C4339B;
	Tue, 23 May 2023 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684855303;
	bh=z4Tb9HwQR3qu2omMR1+2EyzzwcS65O49EGKOPEOuCM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XsThTIi8BWp8lNdnvT18YqAX/fGTxOCWVb8v3c86j5cKKoWj5a/wP47vngNKqufLn
	 dFZpTM1bcNipiqo2qyFTGJMCqeFH4ZQX9JQQrUcwYop3FILkDgULwSmX1YZ8Yxn5h/
	 9ttEEadjLSHkwAVbo8T3tiBpqO3RaqU3smuf2uzoSSAhIAMJFm+CN0drF6UiOaMVSb
	 Tor1w7YCo7PVCB6d+Hz1nMK84IRi399puEeKt7EVmG4YVAgk8pG86t6QIOu3AqvsMP
	 qq3/7wQdyetbhtQcByRIee07RvsDTXuoR0XEdl6TkrT5gCUCY65qhQw4Y63aQ2B6uA
	 c1RGeSpMst60A==
Message-ID: <36eea968-d3e8-fc1e-6d88-0f19fce130d8@kernel.org>
Date: Tue, 23 May 2023 09:21:41 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
Content-Language: en-US
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
 "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/23/23 2:29 AM, Gavrilov Ilia wrote:
> optlen is fetched without checking whether there is more than one byte to parse.
> It can lead to out-of-bounds access.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 3c73a0368e99 ("ipv6: Update ipv6 static library with newly needed functions")

That is not the right Fixes tag; that commit only moved the code.

Fixes: c61a40432509 ("[IPV6]: Find option offset by type.")

> Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
> ---
>  net/ipv6/exthdrs_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
> index da46c4284676..49e31e4ae7b7 100644
> --- a/net/ipv6/exthdrs_core.c
> +++ b/net/ipv6/exthdrs_core.c
> @@ -143,6 +143,8 @@ int ipv6_find_tlv(const struct sk_buff *skb, int offset, int type)
>  			optlen = 1;
>  			break;
>  		default:
> +			if (len < 2)
> +				goto bad;
>  			optlen = nh[offset + 1] + 2;
>  			if (optlen > len)
>  				goto bad;

Reviewed-by: David Ahern <dsahern@kernel.org>


