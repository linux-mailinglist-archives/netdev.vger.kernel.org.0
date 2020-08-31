Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76B6257C46
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHaP1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgHaP1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 11:27:51 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 128BB2083E;
        Mon, 31 Aug 2020 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887670;
        bh=jT9yB63HJHApfihOIb1xEYGO+FSjOKTpNRpjd3xo4pw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GiDRqZwFHz8aWKhaEOHWvljJ3SIMOvASR0Xo/1jiLslulQm3q/SDofqpdF9H+t+Fl
         HZU5vKzFMeNP4ZToUobaoLQo1/5BfqwOXoCbuacyxvAoksjz+aOkFA7V+dOmJJbBi8
         fz0TaciA7YC69ehMJYgLiQQmWNflQe+qRTiJeBN8=
Received: by mail-ot1-f46.google.com with SMTP id k20so5674382otr.1;
        Mon, 31 Aug 2020 08:27:50 -0700 (PDT)
X-Gm-Message-State: AOAM531MJiEKVnA4nfVNjWNpM2fAHfes3itKXju/UqYSv7URW3OE7fIj
        6pJnCVJkroD9hKlnmjtHJYtn1EwD7cCzth6l1do=
X-Google-Smtp-Source: ABdhPJzSZCnHUjLvLj3F0SS3tRSyrcLvGbgnuoLruxdYIUZTR/7Zj5gXWQcbit96CV6Taz8PPrl3+Uae/oE6q3PCOb8=
X-Received: by 2002:a9d:69c9:: with SMTP id v9mr1238535oto.90.1598887669390;
 Mon, 31 Aug 2020 08:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200827080252.26396-1-dinghao.liu@zju.edu.cn> <20200829153648.GB20499@fieldses.org>
In-Reply-To: <20200829153648.GB20499@fieldses.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 31 Aug 2020 18:27:38 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFUhqz8HPcssWXKCZ92c-pZvgYKk4aX6xmq2qocmiTKsA@mail.gmail.com>
Message-ID: <CAMj1kXFUhqz8HPcssWXKCZ92c-pZvgYKk4aX6xmq2qocmiTKsA@mail.gmail.com>
Subject: Re: [PATCH] gss_krb5: Fix memleak in krb5_make_rc4_seq_num
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, Kangjie Lu <kjlu@umn.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Scott Mayhew <smayhew@redhat.com>, linux-nfs@vger.kernel.org,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Aug 2020 at 18:43, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> This code is rarely if ever used, and there are pending patches to
> remove it completely, so I don't think it's worth trying to fix a rare
> memory leak at this point.
>
> --b.
>

FYI I just submitted v3 of my series removing this code to the
linux-crypto list, and so hopefully it will disappear in v5.10


> On Thu, Aug 27, 2020 at 04:02:50PM +0800, Dinghao Liu wrote:
> > When kmalloc() fails, cipher should be freed
> > just like when krb5_rc4_setup_seq_key() fails.
> >
> > Fixes: e7afe6c1d486b ("sunrpc: fix 4 more call sites that were using stack memory with a scatterlist")
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> > ---
> >  net/sunrpc/auth_gss/gss_krb5_seqnum.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sunrpc/auth_gss/gss_krb5_seqnum.c b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
> > index 507105127095..88ca58d11082 100644
> > --- a/net/sunrpc/auth_gss/gss_krb5_seqnum.c
> > +++ b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
> > @@ -53,8 +53,10 @@ krb5_make_rc4_seq_num(struct krb5_ctx *kctx, int direction, s32 seqnum,
> >               return PTR_ERR(cipher);
> >
> >       plain = kmalloc(8, GFP_NOFS);
> > -     if (!plain)
> > -             return -ENOMEM;
> > +     if (!plain) {
> > +             code = -ENOMEM;
> > +             goto out;
> > +     }
> >
> >       plain[0] = (unsigned char) ((seqnum >> 24) & 0xff);
> >       plain[1] = (unsigned char) ((seqnum >> 16) & 0xff);
> > --
> > 2.17.1
