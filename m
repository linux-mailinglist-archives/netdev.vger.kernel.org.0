Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC75917AE
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 01:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiHLXzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 19:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLXzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 19:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A63713DF1;
        Fri, 12 Aug 2022 16:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B69B618C1;
        Fri, 12 Aug 2022 23:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D45C433C1;
        Fri, 12 Aug 2022 23:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660348517;
        bh=eE5bZLEzQR5a2dNeobAGUD4KWGam0pl/Wi7lmKqL4QU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K5C/jTGFxzrvsWrOfKdrvW77RgXikx92JNNlT5qHi1wplCZkwApbQFMSrZx79gr8F
         5ooFOnReIlOtVWRE8Xl/tslapLSs+Oty8bz0SiYq4c3/opspNWTa/8GzPYfbsjCIUN
         dkNSeuwS/spqnLkoM4BORXM2t9NEKQO1P74hR/bswplAKJ1AOyZF8AyYk828UWUwax
         fUYM8idffgavCud5q7U3kpMitxtIUi14xu34aFxhV5mBtHQUMj+Fy6KEheFpYWRMN0
         qGlngFuAotIlu7zU3yNlOM4lYSrgA+Kv83aVe3Iu28VV5h7pGY2EE0vpb1kXkQ0Sh9
         geD105P4lqMSw==
Date:   Fri, 12 Aug 2022 16:55:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net v2 3/4] tcp: refactor tcp_read_skb() a bit
Message-ID: <20220812165516.45432ef0@kernel.org>
In-Reply-To: <20220808033106.130263-4-xiyou.wangcong@gmail.com>
References: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
        <20220808033106.130263-4-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Aug 2022 20:31:05 -0700 Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> As tcp_read_skb() only reads one skb at a time, the while loop is
> unnecessary, we can turn it into an if. This also simplifies the
> code logic.

I think Eric is AFK so we should just apply these, they LGTM.
One minor nit below.

> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1761,27 +1761,18 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
>  	if (sk->sk_state == TCP_LISTEN)
>  		return -ENOTCONN;
>  
> -	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> -		int used;
> -
> +	skb = tcp_recv_skb(sk, seq, &offset);
> +	if (skb) {

if (!skb)
	return 0;

?

