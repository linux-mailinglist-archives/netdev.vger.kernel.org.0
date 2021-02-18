Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E515031EF98
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhBRTTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhBRTJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D631F64EC2;
        Thu, 18 Feb 2021 19:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613675302;
        bh=bOMk0gYMu1GEmqDLUAiJGxXsJ7LzwqllbKAUmOo75dI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hNklM0OG0BQ4OSb2j6Y/GhXpOloLDO/J5ctL7fSIt00tXH+GlzK1vqe/Ia2/oXdJu
         qSeRcLbJ0XRelGu5tHxBi2hM078XkZ9dSS9WnW/YarT/tHt8XZlPfiLpUVzudMaSkp
         cGD0+m7MSRzj6gk/jLczzPdHH7hAyzPJnvuK1DdFM1lnoEdLJhvtCTwZXXZHSVYAB2
         0prDSYTImUqrn4AWfMNzpc0u4RYWxSIdqDplROTnHNKS/iaqZafGXK32rtfBRrHbTw
         /k6jS/Lv0uXia9fKxF1YrCyArsXUD2yJG+A+Kohxicr+e4bCTek5rZ8XOf+RAt0UyS
         v3YUdqOKWlsJg==
Date:   Thu, 18 Feb 2021 11:08:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before
 sending
Message-ID: <20210218110820.18f29ee5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218123053.2239986-1-Jason@zx2c4.com>
References: <20210218123053.2239986-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 13:30:53 +0100 Jason A. Donenfeld wrote:
> The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming
> the skb to have come directly from the inet layer. But when the packet
> comes from the ndo layer, especially when forwarded, there's no telling
> what might be in skb->cb at that point. So, icmp{,v6}_ndo_send must zero
> out its skb->cb before passing the packet off to icmp{,v6}_send.
> Otherwise the icmp sending code risks reading bogus memory contents,
> which can result in nasty stack overflows such as this one reported by a
> user:
> 
>     panic+0x108/0x2ea
>     __stack_chk_fail+0x14/0x20
>     __icmp_send+0x5bd/0x5c0
>     icmp_ndo_send+0x148/0x160
> 
> This is easy to simulate by doing a `memset(skb->cb, 0x41,
> sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
> good fortune and the rarity of icmp sending from that context that we've
> avoided reports like this until now. For example, in KASAN:
> 
>     BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
>     Write of size 38 at addr ffff888006f1f80e by task ping/89
>     CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
>     Call Trace:
>      dump_stack+0x9a/0xcc
>      print_address_description.constprop.0+0x1a/0x160
>      __kasan_report.cold+0x20/0x38
>      kasan_report+0x32/0x40
>      check_memory_region+0x145/0x1a0
>      memcpy+0x39/0x60
>      __ip_options_echo+0xa0e/0x12b0
>      __icmp_send+0x744/0x1700
> 
> Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
> the v4 case, while the rest did not. So this commit actually removes the
> gtp-specific zeroing, while putting the code where it belongs in the
> shared infrastructure of icmp{,v6}_ndo_send.
> 
> Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")

nit: please make sure you CC the authors of the commits you're blaming.
