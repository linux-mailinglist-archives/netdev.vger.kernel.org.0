Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FCB456ABE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhKSHQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhKSHQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:16:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4544D601FF;
        Fri, 19 Nov 2021 07:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637306037;
        bh=oXquU0vYIQI79u0XR5EKWK0pqpE8CqaQRwwcry35rEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FS2GsfFqtWKg9jqfFnPLzR+PJwLja2YLxE6MpEVJpXfeItZeqejPQ209hcvntD0K+
         gKu9dJXCf4qr+kPzOXk7r0ReELrP7WJ7h6LF6vyk6FZ9STFwm4yqSgDO0MEanitie7
         wUbpDbLaxG99eEtprcdJAcTYWiBVqBjmxBYxU5j93mi4bTCjv/BgCxRynwG/IoOgDE
         yOWAaPF920hhrGyycgppGuQ9TXf9msr53YHSIg7oBQPVdLA9+8vG3nVl1MXLfJgBLQ
         g6haxjq5EwgmKvNVN6tNW1etHFqUZLEOrcfbIk7bmDf6BPr7lX4Aulf0DXz5NatYlA
         vkxb7pUgHUKjA==
Date:   Thu, 18 Nov 2021 23:13:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] skbuff: Switch structure bounds to struct_group()
Message-ID: <20211118231355.7a39d22f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211118183615.1281978-1-keescook@chromium.org>
References: <20211118183615.1281978-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 10:36:15 -0800 Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Replace the existing empty member position markers "headers_start" and
> "headers_end" with a struct_group(). This will allow memcpy() and sizeof()
> to more easily reason about sizes, and improve readability.
> 
> "pahole" shows no size nor member offset changes to struct sk_buff.
> "objdump -d" shows no object code changes (outside of WARNs affected by
> source line number changes).

This adds ~27k of these warnings to W=1 gcc builds:

include/linux/skbuff.h:851:1: warning: directive in macro's argument list
