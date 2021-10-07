Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C25B425E36
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhJGUzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhJGUzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:55:31 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9A9C061570;
        Thu,  7 Oct 2021 13:53:37 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z5so16356495ybj.2;
        Thu, 07 Oct 2021 13:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pyQNWwdkJWAkLBnPQDQe8VN/G7b/r2IR8mf10D5CLlw=;
        b=gl0StOvQsQ3O1nPZovu0/Uun5e4fxMajXQIi6Jx1/qnDGMRgd5xMvxkJkF1o+BS4R+
         8CDp/99piYQV1ZmnBy8YJGwH+l1L48CqZ+z9kga0xQfHIDJ0D9SCECBfOJDIFg3UnuwI
         S3cLZSKHpNs8pZm2uI/jtOGuUKX5PzeM/emORkmDQjSvj1cMqWdu++HP3ob7xOJwy46E
         oHqUVyBw+oFtLuC/KCXzbkIRaW9zcP/NjW9wl0Y9ucpi65GQd3xk0Lz1FC/OPinnTz1A
         RfJmXVy4/Q3li/AhkIbn+kIqDpDPf1KEgjMqxOcZ6pdJ2nfhjK9YW5UyaW7ks4Z7ohJB
         lqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pyQNWwdkJWAkLBnPQDQe8VN/G7b/r2IR8mf10D5CLlw=;
        b=SlW1LWwypQEykgajfnj/r+3/mk2wIV+YZmdOGH8SDpTF6G+1zWmRysIesjerpVZDs4
         o7f7cahNIJcoNxEzBkqnrJt/Ewd3IdQHOUJOR2kQOgY/jPj0OvoEzwgxfigPcTjZPb07
         WYZJ/UHiQakmg+1sjN6ieg2Wt06DWvqTCN3HohAbDkuksZDRpRWSc2B5ZW93pu0YUq0B
         BHQJtsGE882efxveOsnQT+DMhDTvYDJDIItA9Ca4tSpjxuUAcojZsjXwJsD4QHEBYIDl
         x6Lrfybz7Sjo7+UzIlJmCPglW9pdUyMMxzluDvGZD7FDdNI2stQn5qdBt5iYVDo1oSb3
         8c7w==
X-Gm-Message-State: AOAM532NSZbZysdlsgmM6hQEUt/1fPu6e49e+sSGwhY/2Zid4s6Qujab
        +iqvNwOGRRztC3cDixhgzq2QR/y8uRmv2MDXjjl0zxgd
X-Google-Smtp-Source: ABdhPJw0wUV8PYiDNZhfGIw/WkBRT7ozC+3Sy3N62q4x50v4dDMEjp7LCygJQALD3/3k1USlyuAw4snpc8dk0he80JI=
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr7223193ybg.108.1633640016419;
 Thu, 07 Oct 2021 13:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
 <20211002003706.11237-4-xiyou.wangcong@gmail.com> <582ff8e9-c7b7-88c1-6cf0-e143da92836f@iogearbox.net>
In-Reply-To: <582ff8e9-c7b7-88c1-6cf0-e143da92836f@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 7 Oct 2021 13:53:25 -0700
Message-ID: <CAM_iQpXy5HOHOU=T_FVVydBniL=tOW9sYTAMsc_nRWcZsqo8Yg@mail.gmail.com>
Subject: Re: [Patch bpf v3 3/4] net: implement ->sock_is_readable() for UDP
 and AF_UNIX
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 1:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/2/21 2:37 AM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Yucong noticed we can't poll() sockets in sockmap even
> > when they are the destination sockets of redirections.
> > This is because we never poll any psock queues in ->poll(),
> > except for TCP. With ->sock_is_readable() now we can
> > overwrite >sock_is_readable(), invoke and implement it for
> > both UDP and AF_UNIX sockets.
> >
> > Reported-by: Yucong Sun <sunyucong@gmail.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >   net/ipv4/udp.c      | 2 ++
> >   net/ipv4/udp_bpf.c  | 1 +
> >   net/unix/af_unix.c  | 4 ++++
> >   net/unix/unix_bpf.c | 2 ++
> >   4 files changed, 9 insertions(+)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 2a7825a5b842..4a7e15a43a68 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -2866,6 +2866,8 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
> >           !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
> >               mask &= ~(EPOLLIN | EPOLLRDNORM);
> >
> > +     if (sk_is_readable(sk))
> > +             mask |= EPOLLIN | EPOLLRDNORM;
>
> udp_poll() has this extra logic around first_packet_length() which drops all bad csum'ed
> skbs. How does this stand in relation to sk_msg_is_readable()? Is this a concern as well
> there? Maybe makes sense to elaborate a bit more in the commit message for context / future
> reference.

We don't validate UDP checksums on sockmap RX path, so
it is okay to leave it as it is, but it is worth a comment like
you suggest. I will add a comment in this code.

If we really need to validate the checksum, it should be addressed
in a separate patch(set), not in this one.

Thanks.
