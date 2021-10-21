Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552EC436D52
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhJUWSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhJUWSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 18:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0E061251;
        Thu, 21 Oct 2021 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634854564;
        bh=AHHfA+Mapc3N8XsvtfbXQ5SCsv7H+/Q6AeR8MG9rOn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N2nTIJtvobaJb4LOO1fbkzbbS0CFmAJC6TGAghBYUrJbmfxvSWkoxY5xhgyQRez59
         Pnf7dyEYzN07V2vL2B2tjl1+Jqcdw8StqztUDNT2vxKV0apgGlfx6+DOTM4ASu5nf9
         Ic+fSalfzstOxvL4X72lV5eKNBBuP8J1XJQ6vw8uwAA8AFwOV6ibzYlQaDRIVOvJs6
         bEZpCKgPApa3JuA4IdvLJ2LRVjiDBfvcXoHfDyNnS58pLwt/9hgZZg5LpkwDj2iSBI
         1ZE0o6TK434FXZF8xthp6pTc7Lf4pKiNEl0/nfF94ZkohVuDX7MI3JtHkoJyJ9WmY+
         qMEPG/C1uw9UQ==
Date:   Thu, 21 Oct 2021 15:16:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Vakul Garg <vakul.garg@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix flipped sign in tls_err_abort() calls
Message-ID: <20211021151603.215ab29e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021183043.837139-1-daniel.m.jordan@oracle.com>
References: <20211021183043.837139-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 14:30:43 -0400 Daniel Jordan wrote:
> sk->sk_err appears to expect a positive value, a convention that ktls
> doesn't always follow and that leads to memory corruption in other code.
> For instance,
> 
>     [task1]
>     tls_encrypt_done(..., err=<negative error from crypto request>)
>       tls_err_abort(.., err)
>         sk->sk_err = err;
> 
>     [task2]
>     splice_from_pipe_feed
>       ...
>         tls_sw_do_sendpage
>           if (sk->sk_err) {
>             ret = -sk->sk_err;  // ret is positive
> 
>     splice_from_pipe_feed (continued)
>       ret = actor(...)  // ret is still positive and interpreted as bytes
>                         // written, resulting in underflow of buf->len and
>                         // sd->len, leading to huge buf->offset and bogus
>                         // addresses computed in later calls to actor()
> 
> Fix all tls_err_abort() callers to pass a negative error code
> consistently and centralize the error-prone sign flip there, throwing in
> a warning to catch future misuse.
> 
> Cc: stable@vger.kernel.org
> Fixes: c46234ebb4d1e ("tls: RX path for ktls")
> Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> I could be wrong about sk->sk_err expecting a positive value, but at
> least the sign of the error code is inconsistent.  Open to suggestions.

Looks good to me, the WARN_ON_ONCE() may be a little heavy and fire
multiple times, but hopefully compiler will do a good enough job on
removing it from places where the argument can't be positive.

We should probably also fix this assignment:

			ctx->async_wait.err = sk->sk_err;

I think async_wait.err is expected to have a negative errno.

But that can be a separate patch.
