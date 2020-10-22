Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549B22956F9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895562AbgJVDxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895556AbgJVDxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 23:53:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E39B22267;
        Thu, 22 Oct 2020 03:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603338802;
        bh=GPT2/GZ/J+HR5we8znpAw81+fQ+mU97UyByrrC0QDCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k3VU+hBuQS7ewgI/RMbVgbiYsmnvP30mgOFOrb2mIketsLcv1lJplGwdkmpWoDkLs
         aaQKjQTvLpy0yI8n9gHsEx6tLA3VyMJj/i6DbZiG2TO16op0y9cm+RNSJesGea6q+M
         lRDsRR0A9S15mp9fCWfO5GqjS6aJygE432E50878=
Date:   Wed, 21 Oct 2020 20:53:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ke Li <keli@akamai.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kli@udel.edu>, Ji Li <jli@akamai.com>
Subject: Re: [PATCH net] net: Properly typecast int values to set
 sk_max_pacing_rate
Message-ID: <20201021205320.57cb4c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020003149.215357-1-keli@akamai.com>
References: <20201020003149.215357-1-keli@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 20:31:49 -0400 Ke Li wrote:
> In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_rate,
> after extended from 'u32' to 'unsigned long', takes unintentionally
> hiked value whenever assigned from an 'int' value with MSB=1, due to
> binary sign extension in promoting s32 to u64, e.g. 0x80000000 becomes
> 0xFFFFFFFF80000000.
> 
> Thus inflated sk_max_pacing_rate causes subsequent getsockopt to return
> ~0U unexpectedly. It may also result in increased pacing rate.
> 
> Fix by explicitly casting the 'int' value to 'unsigned int' before
> assigning it to sk_max_pacing_rate, for zero extension to happen.
> 
> Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
> Signed-off-by: Ji Li <jli@akamai.com>
> Signed-off-by: Ke Li <keli@akamai.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/filter.c | 2 +-
>  net/core/sock.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c5e2a1c5fd8d..43f20c14864c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4693,7 +4693,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  				cmpxchg(&sk->sk_pacing_status,
>  					SK_PACING_NONE,
>  					SK_PACING_NEEDED);
> -			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : val;
> +			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : (unsigned int)val;

Looks good, but please wrap this to 80 chars.

>  			sk->sk_pacing_rate = min(sk->sk_pacing_rate,
>  						 sk->sk_max_pacing_rate);
>  			break;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 4e8729357122..727ea1cc633c 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1163,7 +1163,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>  
>  	case SO_MAX_PACING_RATE:
>  		{
> -		unsigned long ulval = (val == ~0U) ? ~0UL : val;
> +		unsigned long ulval = (val == ~0U) ? ~0UL : (unsigned int)val;
>  
>  		if (sizeof(ulval) != sizeof(val) &&
>  		    optlen >= sizeof(ulval) &&
> 
> base-commit: 0e8b8d6a2d85344d80dda5beadd98f5f86e8d3d3

