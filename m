Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C363137657
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAJSqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:46:07 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34375 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgAJSqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:46:07 -0500
Received: by mail-lj1-f193.google.com with SMTP id z22so3183060ljg.1;
        Fri, 10 Jan 2020 10:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pd/iAF0AV9/4gg2SZG7bs3ivDHHCsN5CHjs199AFcsc=;
        b=L5of4Laa/yIOI7ON4xWOoR67Jtq0IvWH1ljWi4h5TxifsJdHyPR6wEGhfzYF4jwgqL
         ogam1Q0EGbfUfIyjsUNLVgvUXQLyYgkUFcGXwKeOthN4bitP0jevT1QX8e1kPFVYcN/n
         w9zVfp6CIsS06S/UndGMBxG08kIn/dAs22bk/HJXomi2lvrxZ79v872BwVE78BeDyIFv
         FF81HWoDUk2X0ERYojuAsFSlxQe7EVjxXWkj5T3/+1Jg2akmT3uJ82cuJzOGG/AG9FBV
         dXV7V5Wg5zZt27x9p63KE/ZHaBVwQvkWTYPyZrh4w41mBLcnvNP4dplx0nblypUp3IzG
         LPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pd/iAF0AV9/4gg2SZG7bs3ivDHHCsN5CHjs199AFcsc=;
        b=XqqvVu+jZ0VNawfcCCRRNVrMFKIKBoPdyK0ZdxS7TvFOKbSpRpmoCrJkLk+izDcxnJ
         010O+YcvHnMk5iZqwaAK3r+wF+zKQv01l/QilhgkL5cOdezOc9jeDu6IgBkczV3Pn67y
         uLNY3f8OzGB8uPoTeYjfCzar2ioP48yG/3xTzbDUsYqyqngO0CPjj0WAMbCDG+fDHZ+P
         4rBT/LV52N4R/pgBATB5f5L3Wm4d23l5MY4yIlZ9XqH1uUo5RaY7sKjom2a6Y2Oe6MvC
         djMApVB/TuT9owZR6x/i1VVkrU9223sf90mGVQ55nzuGIHtteNhjOptuObuQHGbaVVgJ
         gJCg==
X-Gm-Message-State: APjAAAUqyYn8lfOK96NDTgXKXAJM8s5h2WZSgJvZG6ONag2OP5i7rcxM
        YcvaYGg3wCoHnFt/xkbCMYSvsWmuvzJpj/JjCww=
X-Google-Smtp-Source: APXvYqxQKkHJH+BvtDAWm2UalBtTeK1JvursvyMIzoD61WSEnmFlGgSKwKs+6pxBN1DP55ZP9fXTFg0xoUNR67LdepE=
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr3541230ljq.109.1578681964526;
 Fri, 10 Jan 2020 10:46:04 -0800 (PST)
MIME-Version: 1.0
References: <20200109115749.12283-1-lmb@cloudflare.com> <20200110132336.26099-1-lmb@cloudflare.com>
 <20200110164328.aosamgjk5hfw7r7d@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200110164328.aosamgjk5hfw7r7d@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jan 2020 10:45:53 -0800
Message-ID: <CAADnVQ+QhS-qCNQt7Gs2tQo=mxj7cKOk-zwzdTyBLHwy6u7aiw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] net: bpf: don't leak time wait and request sockets
To:     Martin Lau <kafai@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@isovalent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 8:43 AM Martin Lau <kafai@fb.com> wrote:
>
> On Fri, Jan 10, 2020 at 01:23:36PM +0000, Lorenz Bauer wrote:
> > It's possible to leak time wait and request sockets via the following
> > BPF pseudo code:
> >
> >   sk = bpf_skc_lookup_tcp(...)
> >   if (sk)
> >     bpf_sk_release(sk)
> >
> > If sk->sk_state is TCP_NEW_SYN_RECV or TCP_TIME_WAIT the refcount taken
> > by bpf_skc_lookup_tcp is not undone by bpf_sk_release. This is because
> > sk_flags is re-used for other data in both kinds of sockets. The check
> >
> >   !sock_flag(sk, SOCK_RCU_FREE)
> >
> > therefore returns a bogus result. Check that sk_flags is valid by calling
> > sk_fullsock. Skip checking SOCK_RCU_FREE if we already know that sk is
> > not a full socket.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
