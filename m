Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4863DBF25
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhG3Tps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhG3Tpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:45:47 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978B9C06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 12:45:41 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e4so4156609ybn.2
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 12:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MHi0bfcUnIdplvlHsVYWhsn/ghP0aKcrKKMFnR5w1iE=;
        b=gbvt3zlTJPg+IqJEFMnsyReYPPVqpY5fHtZuKi3SS7kb7A9RPtJ4U6XJ4g9D3gHOmE
         YxAaohG1cfUS0ZqefmjViDY0kEO8v/4LX3VT4kVF+k66njDgPOtMo3D+aKCdF7024k/S
         KD7+McxZz5OTNKDfiGij0dgPKpOFr3vvFic5NxfP8TQJepvdGDiyZ7Y4AJCWaBc8Pgie
         NB3VFCxVA+XJQwtCk9yAMwjmlTbnZckaHA6uZLDYykOrMNwTwY42//nG31ULvSRodWO8
         uZFf8G2YopADqoRdXtAjWcTCS/05W8A4S6AZxWKxA7WByQm8gIr1y9RMLqwHJgMUUA5x
         eibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MHi0bfcUnIdplvlHsVYWhsn/ghP0aKcrKKMFnR5w1iE=;
        b=bTO98A71V1hXJCeNnznE5+Bo4v6mQ5Dq0fg+U3LsqQfG4HY5s0mTEi8WHUhvqcRxO0
         /RWVbcSjP5Hhch8brV0TpRcrOAUhAfq8sbJDq0NLGe8h3iIfbk703Z6wdvie6ytrapdJ
         1QYyXRY/e5cI3famR+BvVkNQWU6WkDdRCo4e2f3XX29ZkFCIAN9AjfCZOH5LAIQYjq4t
         IYeI/SMiGkjV9Ai0GUCJ7wcDocF4UjjrxATqb/CGJcpu2pPtf2VnnSIWAo+JDn4eOcx8
         72E1WL0IUXziT7MLn9xw4yjyLQxkqZClvss18RJPw86Mb8PkTdmDOzRYYaKitzfWkVNo
         Dawg==
X-Gm-Message-State: AOAM533WE+4j0nkGxvi3Q1uCl38dfKXX7jGhseBJGm+YElpj+FRtHB2W
        BwGILsUzryvvGdGrPeSVotDI5S2d7r6JlQ29c8M=
X-Google-Smtp-Source: ABdhPJxvg1fXM4MSv/kmQwO8UeaESfNvr929RIWL/wAHTmA6w9wc8l9b/fBih5mziX1Vo+U8fDBPPtOKlg9flwdkusI=
X-Received: by 2002:a25:d691:: with SMTP id n139mr5343845ybg.27.1627674340921;
 Fri, 30 Jul 2021 12:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
 <87h7ge3fya.fsf@cloudflare.com> <6101a77ca9c1_1e1ff620822@john-XPS-13-9370.notmuch>
In-Reply-To: <6101a77ca9c1_1e1ff620822@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 12:45:29 -0700
Message-ID: <CAEf4Bzb-Lwud0L-LKP+xcu47BH-D_BSTnduW1nArirf5yjF-Gw@mail.gmail.com>
Subject: Re: [Patch bpf-next] unix_bpf: fix a potential deadlock in unix_dgram_bpf_recvmsg()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:53 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Jakub Sitnicki wrote:
> > On Fri, Jul 23, 2021 at 08:36 PM CEST, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > As Eric noticed, __unix_dgram_recvmsg() may acquire u->iolock
> > > too, so we have to release it before calling this function.
> > >
> > > Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> > > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/unix/unix_bpf.c | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> > > index db0cda29fb2f..b07cb30e87b1 100644
> > > --- a/net/unix/unix_bpf.c
> > > +++ b/net/unix/unix_bpf.c
> > > @@ -53,8 +53,9 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> > >     mutex_lock(&u->iolock);
> > >     if (!skb_queue_empty(&sk->sk_receive_queue) &&
> > >         sk_psock_queue_empty(psock)) {
> > > -           ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> > > -           goto out;
> > > +           mutex_unlock(&u->iolock);
> > > +           sk_psock_put(sk, psock);
> > > +           return __unix_dgram_recvmsg(sk, msg, len, flags);
> > >     }
> > >
> > >  msg_bytes_ready:
> > > @@ -68,13 +69,13 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> > >             if (data) {
> > >                     if (!sk_psock_queue_empty(psock))
> > >                             goto msg_bytes_ready;
> > > -                   ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> > > -                   goto out;
> > > +                   mutex_unlock(&u->iolock);
> > > +                   sk_psock_put(sk, psock);
> > > +                   return __unix_dgram_recvmsg(sk, msg, len, flags);
> > >             }
> > >             copied = -EAGAIN;
> > >     }
> > >     ret = copied;
> > > -out:
> > >     mutex_unlock(&u->iolock);
> > >     sk_psock_put(sk, psock);
> > >     return ret;
> >
> > Nit: Can be just `return copied`. `ret` became useless.
> >
> > Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
>
> Worth doing the small cleanup pointed out by Jakub but feel free to add
> my ack.
>

I cleaned it up while applying. Applied to bpf-next, thanks.

> Acked-by: John Fastabend <john.fastabend@gmail.com>
