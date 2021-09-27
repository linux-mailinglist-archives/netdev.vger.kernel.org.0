Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70461419F29
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbhI0Taw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhI0Tav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:30:51 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A255DC061575;
        Mon, 27 Sep 2021 12:29:13 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s18so11880442ybc.0;
        Mon, 27 Sep 2021 12:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4msJ1HHIBlUcoGgpNIkATRMbk+sBV85v1+nbCjy8JvU=;
        b=Pdouc4j1vhNSSTfsaB1K7eTGbCtK4b3bn3/3rX3l6QkxKcEhcvW2lAWJ7fJlVc4dqT
         7aMd/RHNlusCgCvr9ld9pIkjm0nNH+0DtTKoqq53aWet0mP/fx1TWmVjiuqXC2ISubpF
         Z1NZRFhMsdRwS4yRR0/7sUqSZkiyV230WKB5BPmqsh/Vn1Q+bgCmGRKn6dj47xrUMK17
         WGXVK5ozVgSZ/FKnGcWjgHawG/TbgD0BBAQVvoxg+yC9B6Lf0TEZFkFIUaf25to3eyOv
         1+VIhKEGGMB+mVgoW8qcCjhIQ9zCkZnLYyugAG9M+dCvjRxs8MaCbdMTqUstNjijBBOi
         OeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4msJ1HHIBlUcoGgpNIkATRMbk+sBV85v1+nbCjy8JvU=;
        b=TV0odwaG0L2alEBZVY+727XPfwaR6mttJhBbissehsGyLSvQyqNMsLZneBRwMH7MZI
         PjjhetBvrtHvDbQlf7H7ZyHmtt+XymFBCz1YLoqMx1mYDxB8LN4AW3jLyttm8idmmViD
         VGbixsGM04SR024HfEVFiefeOU/+lgJdARTs4bUKR5pvFhgR0O6kmDIMAfUAR9jUhJIm
         4++28N2TkPvVWx7wOPcAUfD4gisHTseWpaOPVRQ1d+ThFKzIoKd06fpr2fgLZd6FmIVW
         y9Un9If0wmM3rF7tjgZX//1VU9b7+vGHr7gmArB8RZwxT0XSS2XdMv+LO0+XKSHTL6dS
         q2fg==
X-Gm-Message-State: AOAM532u3GGH3UKsWfpgKiku6HiOPIuM1olkb62eliYcvN9ssHdt6fNo
        8JSDpP+BduokBDixPJH8knKyBAbG66I4fCpECpk=
X-Google-Smtp-Source: ABdhPJw7rtRFOV+Xuo5K1eRtWrK5rQe4usXVzfoVH4rh9L+xclm/WeUI6FX3ZVHSUs5MUpXrkRSVPBJXj5D9zrTrjNE=
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr2101099ybg.108.1632770952882;
 Mon, 27 Sep 2021 12:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
 <20210924220507.24543-3-xiyou.wangcong@gmail.com> <6152085486e84_397f208e8@john-XPS-13-9370.notmuch>
In-Reply-To: <6152085486e84_397f208e8@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Sep 2021 12:29:01 -0700
Message-ID: <CAM_iQpXtSYUKy3JRtFG3uuL9jwBiQzjoZt2ab-VOvEaygZh-VA@mail.gmail.com>
Subject: Re: [Patch bpf 2/3] net: poll psock queues too for sockmap sockets
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 11:07 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Yucong noticed we can't poll() sockets in sockmap even
> > when they are the destination sockets of redirections.
> > This is because we never poll any psock queues in ->poll().
> > We can not overwrite ->poll() as it is in struct proto_ops,
> > not in struct proto.
> >
> > So introduce sk_msg_poll() to poll psock ingress_msg queue
> > and let sockets which support sockmap invoke it directly.
> >
> > Reported-by: Yucong Sun <sunyucong@gmail.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/skmsg.h |  6 ++++++
> >  net/core/skmsg.c      | 15 +++++++++++++++
> >  net/ipv4/tcp.c        |  2 ++
> >  net/ipv4/udp.c        |  2 ++
> >  net/unix/af_unix.c    |  5 +++++
> >  5 files changed, 30 insertions(+)
> >
>
> [...]
>                                                   struct sk_buff *skb)
> >  {
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e8b48df73c85..2eb1a87ba056 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -280,6 +280,7 @@
> >  #include <linux/uaccess.h>
> >  #include <asm/ioctls.h>
> >  #include <net/busy_poll.h>
> > +#include <linux/skmsg.h>
> >
> >  /* Track pending CMSGs. */
> >  enum {
> > @@ -563,6 +564,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
> >
> >               if (tcp_stream_is_readable(sk, target))
> >                       mask |= EPOLLIN | EPOLLRDNORM;
> > +             mask |= sk_msg_poll(sk);
> >
> >               if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
> >                       if (__sk_stream_is_writeable(sk, 1)) {
>
>
> For TCP we implement the stream_memory_read() hook which we implement in
> tcp_bpf.c with tcp_bpf_stream_read. This just checks psock->ingress_msg
> list which should cover any redirect from skmsg into the ingress side
> of another socket.
>
> And the tcp_poll logic is using tcp_stream_is_readable() which is
> checking for sk->sk_prot->stream_memory_read() and then calling it.

Ah, I missed it. It is better to have such a hook in struct proto,
since we just can overwrite it with bpf hooks. Let me rename it
for non-TCP and implement it for UDP and AF_UNIX too.

>
> The straight receive path, e.g. not redirected from a sender should
> be covered by the normal tcp_epollin_ready() checks because this
> would be after TCP does the normal updates to rcv_nxt, copied_seq,
> etc.

Yes.

>
> So above is not in the TCP case by my reading. Did I miss a
> case? We also have done tests with Envoy which I thought were polling
> so I'll check on that as well.

Right, all of these selftests in patch 3/3 are non-TCP.

Thanks.
