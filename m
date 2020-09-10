Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F3263B47
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 05:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgIJDRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 23:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIJDRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 23:17:40 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C646DC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 20:17:39 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id b123so2581707vsd.10
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 20:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pDHtfy4shYzwV45Xe3SoSFRxAZJVvrP7Rz0zyKfkJxk=;
        b=aHzbZSP5wx7e/lHJ0VTKtQrgpqZw1zmc80fZNN01IOiQu6lCaLZtRxOl9Y3KZUjYLK
         GWSEIpUaoylCGTSW8BSJe/TdiSJmQCFehv9s4nY8qE12UPX5NTMz/3o5fN2c8L2kuZiF
         av6ss5DM8k7rO34jLIZR6rnLYbReZ4CDkHPT/SWICfeZUIwCUTawbE+dQi+11PRdRtd3
         iEpMFBzt2+CN0e6kqckS4TliQCkMpKx1UrBIyUMeb9rgbfN5US2JlvUKgQDxdIH4C5BX
         z9EuifTvQjf4ZCoAE/EYdxzcEyWFhDch/FAwVf8ObNPsvSgT5EtfnAehCovPM5LDtz/a
         8atA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pDHtfy4shYzwV45Xe3SoSFRxAZJVvrP7Rz0zyKfkJxk=;
        b=kY6GIMrruexU6292azAQwJQbUOqHV+XvSj/ou3H4m8lzX+XHIPIKV6hTL7nIEwB+AV
         duAZEt3ce0BnX8jhPBeC3ct9nIHZLMegz1P92v8PHMLuE60jjvcJ8NpjVmM7YoLqCWeq
         ben8pxskULgAztnaUOvPzUHOtlL59RIKCKU62L52JwYIt0xYfdcfgo+my+EU1RpaNn5Q
         gDB51+Z7SqgVm3Y6ORIAurYX0IG8pb9HYrh45HIfC8tWWNNEqJAR6j/HpxaWzgQw5IbH
         i08JDRr3JLm24nGDqd2tHs/pQNJYxl6iuCIQUaQ3o31kv9kvZYMeptPaiSBIa6LQiYY8
         kZYw==
X-Gm-Message-State: AOAM531NDTRHDiyxnh6Zq0GVFGQuulgKMmfkvWmXxTETdoIurLrWIhiW
        NA+uXFHIflJnp5pZDydJRLAvHXbRBb1dcgiN2Z5fyw==
X-Google-Smtp-Source: ABdhPJzDrKs0E3ts1bp0N43whI1x7Q1D5U9kqXvpLRuNxLinfASB7OamuDyqGg6ddmM/9yiIufzloxOo8AjytBLXJoo=
X-Received: by 2002:a67:fd48:: with SMTP id g8mr336159vsr.12.1599707858453;
 Wed, 09 Sep 2020 20:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
 <20200909181556.2945496-4-ncardwell@google.com> <20200910002906.v7sl6pfpaphrwntc@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200910002906.v7sl6pfpaphrwntc@kafai-mbp.dhcp.thefacebook.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 9 Sep 2020 23:17:21 -0400
Message-ID: <CADVnQyk6HqZFeLm-Z6zm-UJ_9+ZnO3XoQFzo-ErE080FXQOyWw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] tcp: simplify tcp_set_congestion_control():
 always reinitialize
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Sep 09, 2020 at 02:15:55PM -0400, Neal Cardwell wrote:
> > Now that the previous patches ensure that all call sites for
> > tcp_set_congestion_control() want to initialize congestion control, we
> > can simplify tcp_set_congestion_control() by removing the reinit
> > argument and the code to support it.
> >
> > Signed-off-by: Neal Cardwell <ncardwell@google.com>
> > Acked-by: Yuchung Cheng <ycheng@google.com>
> > Acked-by: Kevin Yang <yyd@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Lawrence Brakmo <brakmo@fb.com>
> > ---
> >  include/net/tcp.h   |  2 +-
> >  net/core/filter.c   |  3 +--
> >  net/ipv4/tcp.c      |  2 +-
> >  net/ipv4/tcp_cong.c | 11 ++---------
> >  4 files changed, 5 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index e85d564446c6..f857146c17a5 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -1104,7 +1104,7 @@ void tcp_get_available_congestion_control(char *buf, size_t len);
> >  void tcp_get_allowed_congestion_control(char *buf, size_t len);
> >  int tcp_set_allowed_congestion_control(char *allowed);
> >  int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
> > -                            bool reinit, bool cap_net_admin);
> > +                            bool cap_net_admin);
> >  u32 tcp_slow_start(struct tcp_sock *tp, u32 acked);
> >  void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked);
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index b26c04924fa3..0bd0a97ee951 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4451,8 +4451,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
> >                       strncpy(name, optval, min_t(long, optlen,
> >                                                   TCP_CA_NAME_MAX-1));
> >                       name[TCP_CA_NAME_MAX-1] = 0;
> > -                     ret = tcp_set_congestion_control(sk, name, false,
> > -                                                      true, true);
> > +                     ret = tcp_set_congestion_control(sk, name, false, true);
> >               } else {
> >                       struct inet_connection_sock *icsk = inet_csk(sk);
> >                       struct tcp_sock *tp = tcp_sk(sk);
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 7360d3db2b61..e58ab9db73ff 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3050,7 +3050,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
> >               name[val] = 0;
> >
> >               lock_sock(sk);
> > -             err = tcp_set_congestion_control(sk, name, true, true,
> > +             err = tcp_set_congestion_control(sk, name, true,
> >                                                ns_capable(sock_net(sk)->user_ns,
> >                                                           CAP_NET_ADMIN));
> >               release_sock(sk);
> > diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> > index d18d7a1ce4ce..a9b0fb52a1ec 100644
> > --- a/net/ipv4/tcp_cong.c
> > +++ b/net/ipv4/tcp_cong.c
> > @@ -341,7 +341,7 @@ int tcp_set_allowed_congestion_control(char *val)
> >   * already initialized.
> >   */
> >  int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
> > -                            bool reinit, bool cap_net_admin)
> > +                            bool cap_net_admin)
> >  {
> >       struct inet_connection_sock *icsk = inet_csk(sk);
> >       const struct tcp_congestion_ops *ca;
> > @@ -365,15 +365,8 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
> >       if (!ca) {
> >               err = -ENOENT;
> >       } else if (!load) {
> nit.
>
> I think this "else if (!load)" case can be completely removed and simply
> allow it to fall through to the last
> "else { tcp_reinit_congestion_control(sk, ca); }" .

Thanks, Martin. That is a very nice observation, and I think you are
right that we can make the additional refactor/simplification/clean-up
that you mention, without changing behavior. For clarity I think that
would be nice to have as a separate follow-on commit. Are you
interested in posting a follow-on patch for that, since it's your nice
idea?

thanks,
neal
