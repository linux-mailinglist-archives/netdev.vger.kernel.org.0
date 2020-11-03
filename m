Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9686A2A4FA8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgKCTFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgKCTF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:05:29 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCDFC0613D1;
        Tue,  3 Nov 2020 11:05:29 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o70so15815134ybc.1;
        Tue, 03 Nov 2020 11:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sKLt9YXgDPSIyALmmWTUZKWktUXxvPCs3PqzBJAVioM=;
        b=QjJV/9pBD/jLf94VijrB8uYcxZo/vxq94tTDkgpBsRa9GrtSyfQhE1AMoZ86ZyK4PG
         84zo9TJ+8u0Q9+bnjWxZwowhu6FEDkuA+uBET5LAtU3K+Vjj/zAmQxPa0MhbF7Qda4dY
         joPCQXnTD0YWgk0JB0j/0PPraJ5HmMrqmoNrimwgmK/H7XFXmY6xV/8Hrl2BUELeYGgN
         UFplhqrAskFXquIzeSFv7DcoNiwzRtAzjswspjAC3aebnX2H1qdkyYOzTN5vOBO+bVeP
         bf/nySFT22E/eYejx4ZCtHUPvzYqlnYIQFESnxHDKNr6/497FiBeZ+Y9Jtkd0g3RlAVL
         Mj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sKLt9YXgDPSIyALmmWTUZKWktUXxvPCs3PqzBJAVioM=;
        b=fAKojckQ6eJ6JJ+fnw9GwgqswS3U0w9bAWPQl8dcP19ebo9eQTWRRPLZBXg/yNP0Hh
         i10ivOFAPf312os1CgS+jTUbUMOw5VMBJKia4lrFOsJxkfZdgHZAPlVxlJMmVkZxZYPD
         fY7u6H0mv0/r4sRHPdBlvqbDym1/wvVjlZtIqPBgl1QvseW6eHxyXMCPgX1UlfsJOXtV
         /mFGxfR9ZLZcoDtp5eh1M4yDzG8gvQSoFSi6dIwqhlTRpIU/Q449mFweU8aBLelgU4wI
         AumNfh/XxnZIwv1YXmxsYwlI6ybGLzYLmijkIXMnvG4T20iuDzqliRoIQ9oxFFmJ/ssm
         WnTA==
X-Gm-Message-State: AOAM532Kju9l2dXN2vxhEdnQ05LFFqnIhcVNsh9VvSETqGQDwoH1mdUY
        2UxZHO501CDh2mGCI7tFAXPaEdTok1QAoKjyKCI=
X-Google-Smtp-Source: ABdhPJy9hhLxa5CZ1z7Psy/GqVxdW6WsKPxEBM0KU3JDGpS2tnjUQO+Wc24oKchU8xF0HtI0TWSsxlxC9BNrdzt0KRk=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr31274067ybl.347.1604430328891;
 Tue, 03 Nov 2020 11:05:28 -0800 (PST)
MIME-Version: 1.0
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com> <1604396490-12129-3-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1604396490-12129-3-git-send-email-magnus.karlsson@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 11:05:17 -0800
Message-ID: <CAEf4Bzah-7akFkjUAJR=ovXLAnLd6EvLMMOy+GBbc4R28TY-eg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: fix possible use after free in xsk_socket__delete
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 1:42 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a possible use after free in xsk_socket__delete that will happen
> if xsk_put_ctx() frees the ctx. To fix, save the umem reference taken
> from the context and just use that instead.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 504b7a8..9bc537d 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -892,6 +892,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>  {
>         size_t desc_sz = sizeof(struct xdp_desc);
>         struct xdp_mmap_offsets off;
> +       struct xsk_umem *umem;
>         struct xsk_ctx *ctx;
>         int err;
>
> @@ -899,6 +900,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>                 return;
>
>         ctx = xsk->ctx;
> +       umem = ctx->umem;
>         if (ctx->prog_fd != -1) {
>                 xsk_delete_bpf_maps(xsk);
>                 close(ctx->prog_fd);
> @@ -918,11 +920,11 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>
>         xsk_put_ctx(ctx);
>
> -       ctx->umem->refcount--;
> +       umem->refcount--;

if you moved ctx->umem->refcount--; to before xdk_put_ctx(ctx), would
that also work?

>         /* Do not close an fd that also has an associated umem connected
>          * to it.
>          */
> -       if (xsk->fd != ctx->umem->fd)
> +       if (xsk->fd != umem->fd)
>                 close(xsk->fd);
>         free(xsk);
>  }
> --
> 2.7.4
>
