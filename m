Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5648D2B72C8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgKRABO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgKRABM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:01:12 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADBA02463B;
        Wed, 18 Nov 2020 00:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605657672;
        bh=SIKFOUxnp0Xed19GuOkTwfNhvyz5d0s7TDMJaJchRls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qr9LSLzazLgi6xxfVukZj5L/J57aQopXjhMHLl2R9NsWr7x3Xx4SM1RWAvl2lzcd9
         wWJingJwUiszmEK8z3FBF1ag1G4PlfIcG239Xg73wzfAer1tvNehlO7frrBnwLhrcm
         /6jFfgk69PBfm/vTCv64Xk++G+55EbxAGARH8k2k=
Date:   Tue, 17 Nov 2020 16:01:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Klink <flokli@flokli.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
Message-ID: <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201115224509.2020651-1-flokli@flokli.de>
References: <20201115224509.2020651-1-flokli@flokli.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 23:45:09 +0100 Florian Klink wrote:
> Checking for ifdef CONFIG_x fails if CONFIG_x=m.
> 
> Use IS_ENABLED instead, which is true for both built-ins and modules.
> 
> Otherwise, a
> > ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1  
> fails with the message "Error: IPv6 support not enabled in kernel." if
> CONFIG_IPV6 is `m`.
> 
> In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.
> 
> Cc: Kim Phillips <kim.phillips@arm.com>
> Signed-off-by: Florian Klink <flokli@flokli.de>

LGTM, this is the fixes tag right?

Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")

CCing David to give him a chance to ack.

> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 86a23e4a6a50..b87140a1fa28 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -696,7 +696,7 @@ int fib_gw_from_via(struct fib_config *cfg, struct nlattr *nla,
>  		cfg->fc_gw4 = *((__be32 *)via->rtvia_addr);
>  		break;
>  	case AF_INET6:
> -#ifdef CONFIG_IPV6
> +#if IS_ENABLED(CONFIG_IPV6)
>  		if (alen != sizeof(struct in6_addr)) {
>  			NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_VIA");
>  			return -EINVAL;

