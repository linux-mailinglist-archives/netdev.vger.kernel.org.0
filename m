Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9727054F3B4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381168AbiFQI5J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jun 2022 04:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380594AbiFQI5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:57:08 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0477F45059;
        Fri, 17 Jun 2022 01:57:05 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id F219F60003;
        Fri, 17 Jun 2022 08:56:56 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 17 Jun 2022 10:56:56 +0200
Message-Id: <CKSA92SUUX9U.33CY0D74VSKCS@enhorning>
Subject: Re: [PATCH net] ipv4: ping: fix bind address validity check
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     "Carlos Llamas" <cmllamas@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
X-Mailer: aerc 0.9.0
References: <20220617020213.1881452-1-cmllamas@google.com>
In-Reply-To: <20220617020213.1881452-1-cmllamas@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jun 17, 2022 at 4:02 AM CEST, Carlos Llamas wrote:
> Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> introduced a helper function to fold duplicated validity checks of bind
> addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> unintended regression in ping_check_bind_addr(), which previously would
> reject binding to multicast and broadcast addresses, but now these are
> both incorrectly allowed as reported in [1].
>
> This patch restores the original check. A simple reordering is done to
> improve readability and make it evident that multicast and broadcast
> addresses should not be allowed. Also, add an early exit for INADDR_ANY
> which replaces lost behavior added by commit 0ce779a9f501 ("net: Avoid
> unnecessary inet_addr_type() call when addr is INADDR_ANY").

Like I mentioned in one of my follow-ups to [1], I think a proper patch
for this not only restores the original behaviour, but also includes
regression tests (if we had it we wouldn't be needing this patch in the
first place; as one would expect, the regression escaped multiple human
reviews :)

I'm following up this email with a v2 to have that.

Riccardo P. Bestetti


>
> [1] https://lore.kernel.org/netdev/CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com/
>
> Fixes: 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Riccardo Paolo Bestetti <pbl@bestov.io>
> Reported-by: Maciej Żenczykowski <maze@google.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---
>  net/ipv4/ping.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 1a43ca73f94d..3c6101def7d6 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -319,12 +319,16 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
>  		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
>  			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
>  
> +		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
> +			return 0;
> +
>  		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
>  		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
>  
> -		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
> -					         addr->sin_addr.s_addr,
> -	                                         chk_addr_ret))
> +		if (chk_addr_ret == RTN_MULTICAST ||
> +		    chk_addr_ret == RTN_BROADCAST ||
> +		    (chk_addr_ret != RTN_LOCAL &&
> +		     !inet_can_nonlocal_bind(net, isk)))
>  			return -EADDRNOTAVAIL;
>  
>  #if IS_ENABLED(CONFIG_IPV6)
> -- 
> 2.36.1.476.g0c4daa206d-goog

