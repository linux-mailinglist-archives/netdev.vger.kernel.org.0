Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942142F5752
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 03:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbhAMVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 16:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbhAMVWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:22:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36A6C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:21:33 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id y17so3610858wrr.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ba13zS/5BmLfosyFnrfPCCq9Y7pVaB7VwGsd4lLySYc=;
        b=uACgDp8Xqrq7HRZmhdGjo7eqo2yY6VzFeCp2TI2kvgM9DLfpNIWHLlaLH7zsO+ilik
         T0jqhUWJb/syBsCaCx42vHroqV5qbM0iNcCvSz58Y3O0DlWKt+qKEQMUw2A8McLglQBs
         2v/Hg4qp5d7zHEHZqSFASykiYZbmji9VfudWN59TkBCnmjK7pv/TwwPgnFC1TAQk479q
         0Y62S7+hPLEmwPm5mDR2CLDK0e2Gv0ykMNql6OVXMy1cCn9WTyOBUNhO5EFWmlmpVNHx
         S6UPp/cIbTQN/y+ouzat/sEeLuWGhCL8xtlaNWtwHAcVRhrPJU4847E0okNRlS3ZvFqf
         yNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ba13zS/5BmLfosyFnrfPCCq9Y7pVaB7VwGsd4lLySYc=;
        b=thy/ipAT0pVjJwlrFRHVC/PCMQbxJT7c21Dx6bA4IW/7Tk6/dcFjJTwZet4mmYAxa/
         HrQr+CGH1BEyXO6+LxJYxLz/fWwS82YH0c13t4xE9/Yh0fVcMn8azvHpcIf2bbgLPHay
         sbR/XFTSi2SAtzUO1FtIclu781gclw/BdtsxREu46EvTM0E2pLY+chUY9rktBQ/Sw6q7
         PnHq3aSVympb4QdwAzauFaqKYtntFEU1J/G9NdnaFUM51bLZqwB4/jtcAqoiIEyqYFc2
         1Fa38c3Rx+q/IBd5YkWIsCpdcO+EfZlWZys+aV4XGUYy+BuBROUB9glT2qPdZNtw7dB6
         THVA==
X-Gm-Message-State: AOAM533dKjv7LLuaAYv6pMFwBs8YucXAx742dK0RhH8jrPeCIOIIjdlA
        82irXQhvcwRyoLa+i2srmKceLf8D3WljFIl32fJsBStAl+w=
X-Google-Smtp-Source: ABdhPJxsJLzpd9Z/Kg9wRhljmpHCgKSDrOPR64ZQEJwRh/ftdQHF/0gEz72ZO05FZ/5eZGFZ1S3mYHJhO0hxURPJPTc=
X-Received: by 2002:adf:dc8b:: with SMTP id r11mr4584912wrj.131.1610572892263;
 Wed, 13 Jan 2021 13:21:32 -0800 (PST)
MIME-Version: 1.0
References: <20210113201201.GC2274@localhost.localdomain> <CANn89iJh1_fCm93B0w2VAzCLPUTSow85JMBQT3sy=0sALbXhrQ@mail.gmail.com>
In-Reply-To: <CANn89iJh1_fCm93B0w2VAzCLPUTSow85JMBQT3sy=0sALbXhrQ@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 13 Jan 2021 13:20:55 -0800
Message-ID: <CAK6E8=d=ct4J-tUOXxE+1og5CfPwaJ=Wd=Bj9pqaVdrOdnAR_g@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP_USER_TIMEOUT with zero window
To:     Eric Dumazet <edumazet@google.com>
Cc:     Enke Chen <enkechen2020@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jan 13, 2021 at 9:12 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > From: Enke Chen <enchen@paloaltonetworks.com>
> >
> > The TCP session does not terminate with TCP_USER_TIMEOUT when data
> > remain untransmitted due to zero window.
> >
> > The number of unanswered zero-window probes (tcp_probes_out) is
> > reset to zero with incoming acks irrespective of the window size,
> > as described in tcp_probe_timer():
> >
> >     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
> >     as long as the receiver continues to respond probes. We support
> >     this by default and reset icsk_probes_out with incoming ACKs.
> >
> > This counter, however, is the wrong one to be used in calculating the
> > duration that the window remains closed and data remain untransmitted.
> > Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> > actual issue.
> >
> > In this patch a separate counter is introduced to track the number of
> > zero-window probes that are not answered with any non-zero window ack.
> > This new counter is used in determining when to abort the session with
> > TCP_USER_TIMEOUT.
> >
>
> I think one possible issue would be that local congestion (full qdisc)
> would abort early,
> because tcp_model_timeout() assumes linear backoff.
Yes exactly. if ZWPs are dropped due to local congestion, the
model_timeout computes incorrectly. Therefore having a starting
timestamp is the surest way b/c it does not assume any specific
backoff behavior.

>
> Neal or Yuchung can further comment on that, it is late for me in France.
>
> packetdrill test would be :
>
>    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
>
>
>    +0 < S 0:0(0) win 0 <mss 1460>
>    +0 > S. 0:0(0) ack 1 <mss 1460>
>
>   +.1 < . 1:1(0) ack 1 win 65530
>    +0 accept(3, ..., ...) = 4
>
>    +0 setsockopt(4, SOL_TCP, TCP_USER_TIMEOUT, [3000], 4) = 0
>    +0 write(4, ..., 24) = 24
>    +0 > P. 1:25(24) ack 1
>    +.1 < . 1:1(0) ack 25 win 65530
>    +0 %{ assert tcpi_probes == 0, tcpi_probes; \
>          assert tcpi_backoff == 0, tcpi_backoff }%
>
> // install a qdisc dropping all packets
>    +0 `tc qdisc delete dev tun0 root 2>/dev/null ; tc qdisc add dev
> tun0 root pfifo limit 0`
>    +0 write(4, ..., 24) = 24
>    // When qdisc is congested we retry every 500ms therefore in theory
>    // we'd retry 6 times before hitting 3s timeout. However, since we
>    // estimate the elapsed time based on exp backoff of actual RTO (300ms),
>    // we'd bail earlier with only 3 probes.
>    +2.1 write(4, ..., 24) = -1
>    +0 %{ assert tcpi_probes == 3, tcpi_probes; \
>          assert tcpi_backoff == 0, tcpi_backoff }%
>    +0 close(4) = 0
>
> > Cc: stable@vger.kernel.org
> > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > Reported-by: William McCall <william.mccall@gmail.com>
> > Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> > ---
> >  include/linux/tcp.h   | 5 +++++
> >  net/ipv4/tcp.c        | 1 +
> >  net/ipv4/tcp_input.c  | 3 ++-
> >  net/ipv4/tcp_output.c | 2 ++
> >  net/ipv4/tcp_timer.c  | 5 +++--
> >  5 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index 2f87377e9af7..c9415b30fa67 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -352,6 +352,11 @@ struct tcp_sock {
> >
> >         int                     linger2;
> >
> > +       /* While icsk_probes_out is for unanswered 0 window probes, this
> > +        * counter is for 0-window probes that are not answered with any
> > +        * non-zero window (nzw) acks.
> > +        */
> > +       u8      probes_nzw;
> >
> >  /* Sock_ops bpf program related variables */
> >  #ifdef CONFIG_BPF
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index ed42d2193c5c..af6a41a5a5ac 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2940,6 +2940,7 @@ int tcp_disconnect(struct sock *sk, int flags)
> >         icsk->icsk_rto = TCP_TIMEOUT_INIT;
> >         icsk->icsk_rto_min = TCP_RTO_MIN;
> >         icsk->icsk_delack_max = TCP_DELACK_MAX;
> > +       tp->probes_nzw = 0;
> >         tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
> >         tp->snd_cwnd = TCP_INIT_CWND;
> >         tp->snd_cwnd_cnt = 0;
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index c7e16b0ed791..4812a969c18a 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3377,13 +3377,14 @@ static void tcp_ack_probe(struct sock *sk)
> >  {
> >         struct inet_connection_sock *icsk = inet_csk(sk);
> >         struct sk_buff *head = tcp_send_head(sk);
> > -       const struct tcp_sock *tp = tcp_sk(sk);
> > +       struct tcp_sock *tp = tcp_sk(sk);
> >
> >         /* Was it a usable window open? */
> >         if (!head)
> >                 return;
> >         if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
> >                 icsk->icsk_backoff = 0;
> > +               tp->probes_nzw = 0;
> >                 inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
> >                 /* Socket must be waked up by subsequent tcp_data_snd_check().
> >                  * This function is not for random using!
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index f322e798a351..1b64cdabc299 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -4084,10 +4084,12 @@ void tcp_send_probe0(struct sock *sk)
> >                 /* Cancel probe timer, if it is not required. */
> >                 icsk->icsk_probes_out = 0;
> >                 icsk->icsk_backoff = 0;
> > +               tp->probes_nzw = 0;
> >                 return;
> >         }
> >
> >         icsk->icsk_probes_out++;
> > +       tp->probes_nzw++;
> >         if (err <= 0) {
> >                 if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
> >                         icsk->icsk_backoff++;
> > diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> > index 6c62b9ea1320..87e9f5998b8e 100644
> > --- a/net/ipv4/tcp_timer.c
> > +++ b/net/ipv4/tcp_timer.c
> > @@ -349,6 +349,7 @@ static void tcp_probe_timer(struct sock *sk)
> >
> >         if (tp->packets_out || !skb) {
> >                 icsk->icsk_probes_out = 0;
> > +               tp->probes_nzw = 0;
> >                 return;
> >         }
> >
> > @@ -360,8 +361,8 @@ static void tcp_probe_timer(struct sock *sk)
> >          * corresponding system limit. We also implement similar policy when
> >          * we use RTO to probe window in tcp_retransmit_timer().
> >          */
> > -       if (icsk->icsk_user_timeout) {
> > -               u32 elapsed = tcp_model_timeout(sk, icsk->icsk_probes_out,
> > +       if (icsk->icsk_user_timeout && tp->probes_nzw) {
> > +               u32 elapsed = tcp_model_timeout(sk, tp->probes_nzw,
> >                                                 tcp_probe0_base(sk));
> >
> >                 if (elapsed >= icsk->icsk_user_timeout)
> > --
> > 2.29.2
> >
