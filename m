Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF24210128
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgGAAz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGAAz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:55:26 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A1BC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:55:26 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o4so11106401ybp.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LlswxQsiG2dIpOBeHe/xv2kqaJ28yfLFmpwhhxdMgiU=;
        b=pAw6XeHcKhaDSPJ07lipl+rB8sqb08UnOiIXYKfM4PbUl7RGYndgzHUT6kfkkqKw1d
         2jZ41gQV7Am9iMoVj4bvr3VWxtfssgr1EWsfnt22TuAFLTzWTsgMjnKIe10UtRpRiriG
         Qf8YB263XJ89wpctESMZTQF0GSCnid59VIwOJgN68OD7QhMxCew8AGS3xj6/l9nfOgCX
         yqxLrPQVQmnFqE11JwfK3uetGVbEgj5n+kij/+cl25e+tNSYXFnrYTpSyWJFcoiKiniD
         OQWiLlWbi0A2OK8nDkEm0okO0oynppKZvx+T2DqFvuuhv67Y74lowzDGhmitoXi9CN9F
         eNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LlswxQsiG2dIpOBeHe/xv2kqaJ28yfLFmpwhhxdMgiU=;
        b=ilFPRIPi5DynjvAdrk2rf8VHFmNsrPFXeoVPmmT0lzw7bIZeIH/K206zAQ5x3XfYo/
         uJep4o0sXxWgL7PZ3ByIfqeWrc/LNfseP0Ds2MhpbV3TcpJCswRRUzuseM6zRvQPAVsm
         YjkE2feoJmDbgZGayhwpJ7VGYlH9mPKgXwAhHQL4sxbXVGmF3G034KlVrWwFO6BaSu6E
         Cv2ob6VfuZYKkYU+V01T3lqi3Gww9q9HuIM9jWpuZ0T++8m4+WbhoJXJy7d0jgYR3b0I
         fMmnaaYh2iVXqYngkyne+Vy1MMhWNwdez+IYAlA8cpvft1MESsy1rpHJmhMtV6cVgtZz
         oFsA==
X-Gm-Message-State: AOAM533jdAQXw0HLsbJDa68p1FVpc3av/xl03oZ6Db1emh4oSjiQ5Rzh
        yAGqBUritYmbdFJ9QPxczaTKtbhpMkopUJzcnQESWw==
X-Google-Smtp-Source: ABdhPJxYVm8DBVJ+TcX95tudLHfqzL2zalEe6IM/vvwrLuR2o/r/q3DMkC0559PTbT+CinbsR46xXE5npmGqhF4WRBE=
X-Received: by 2002:a25:b8c5:: with SMTP id g5mr458485ybm.395.1593564925322;
 Tue, 30 Jun 2020 17:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200630234101.3259179-1-edumazet@google.com> <CAPA1RqChMXe-o_eqc3VN3vT7wtY3Bz-SKzp6ZU2PQ3SykACgXA@mail.gmail.com>
In-Reply-To: <CAPA1RqChMXe-o_eqc3VN3vT7wtY3Bz-SKzp6ZU2PQ3SykACgXA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 17:55:13 -0700
Message-ID: <CANn89i+_hjeqTyOzQjqPzGVMJRjgYRnQ1bZ6Qyh=gbE6TgRAMg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
To:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 5:53 PM Hideaki Yoshifuji
<hideaki.yoshifuji@miraclelinux.com> wrote:
>
> Hi,
>
> 2020=E5=B9=B47=E6=9C=881=E6=97=A5(=E6=B0=B4) 8:41 Eric Dumazet <edumazet@=
google.com>:
> :
> > We only want to make sure that in the case key->keylen
> > is changed, cpus in tcp_md5_hash_key() wont try to use
> > uninitialized data, or crash because key->keylen was
> > read twice to feed sg_init_one() and ahash_request_set_crypt()
> >
> > Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock=
")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> >  net/ipv4/tcp.c      | 7 +++++--
> >  net/ipv4/tcp_ipv4.c | 3 +++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881=
dd6dc2910a1236263 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> >
> >  int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5s=
ig_key *key)
> >  {
> > +       u8 keylen =3D key->keylen;
> >         struct scatterlist sg;
>
> ACCESS_ONCE here, no?

Not needed, the smp_rmb() barrier is stronger.
