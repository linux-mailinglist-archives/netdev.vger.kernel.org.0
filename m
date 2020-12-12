Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719442D8994
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395071AbgLLTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731837AbgLLTH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 14:07:57 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C49EC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 11:07:17 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id e25so11618181wme.0
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 11:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GGQzKyouVvMusOKhxj4HNWH0PP14TPgBb62biha6pw=;
        b=RK6mmKMdoBtnClJD2eSWvR7+yZfEntM55Z0+zpxy+DZs6KI1Ox6q6QLpw+BEYyKO33
         S65/c7ZJ4rAoBR862uODmjmVd9LLXskDSdMJFm05HKm4ZMoFsEBOv3LkolTcv2QRgMJF
         IvxVKFxxs8lsDi1mBrGi/heJL9WR6NJPuCRrwRSFm38xhLGxu9BexFh9d+Rmovq0sdKt
         502ujvdomvL4P3RP/ezjYZgGSycerypE557kqm9m0m/hzi/4LuZO07Tvy8rZ8aGVvFF+
         fNceGDPyFlq4YHCGh0CHyl8broUC82GELlNbwPONN3Dec4S/MyMlSp4lPJBOGZmp1prk
         Ljdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GGQzKyouVvMusOKhxj4HNWH0PP14TPgBb62biha6pw=;
        b=ACWtV2D7WfLX7ngkkV+SNwNh/Bwtdm/qz2oGNohg9twzyeiKn+SKBU5aY7agy2r6if
         F4un3D+6i0CCzwiXEtGP4f7gsQxF2X3VlahPct/OaHljo16ljrEpNjdb4+aWYsF02VbV
         ZSHj2eqwCavhtc/hb3BWCNka6qHgSwVpkTga86a2Sk6vpdr0cicgWY6xTA9RujZjbc6W
         J7ZiNpYxG2e4/daoAQFDXCOsbp+h4ikq0XdcfBYG2uQedUbp+gfY/i+uOF2svZPiZqQY
         ginueGUlFqRrbgLPqcPANclV1jQUVCl/13DjWpfG9TEUDttB1kirE8hI4EWcLJVbhW9G
         fPaw==
X-Gm-Message-State: AOAM531oaKWZ1HaquWYj5Govu2aKfpgu4+1j1FfBP3JbzlFjaDhuyS3s
        ZL0DPPq+b4Q3AFnPoIgkb2r6rLqBhh81yDLqQttRNw==
X-Google-Smtp-Source: ABdhPJzm8GLO2m3P+yFng68b0U7/DaYVYEutlXbyFqxm1dEEFf6xs2JV1+l6Y+IDA1L9GNC3C4hdaHL/2IZhXlKN3ys=
X-Received: by 2002:a1c:9d85:: with SMTP id g127mr19872244wme.118.1607800034774;
 Sat, 12 Dec 2020 11:07:14 -0800 (PST)
MIME-Version: 1.0
References: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
 <CAK6E8=c4LpxcaF3Mr1T9BtkD5SPK1eoK_hGOMNa6C9a4fpFQNg@mail.gmail.com> <CAKgT0UcS2s+gnYz0nvfpia5R+H7hSSVS4GGKOkkfyuz60zJpQQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcS2s+gnYz0nvfpia5R+H7hSSVS4GGKOkkfyuz60zJpQQ@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Sat, 12 Dec 2020 11:06:37 -0800
Message-ID: <CAK6E8=c3c8uK8zGA9QS3cTLh59N6n=e_71a0BbQK7UfaPJqkSA@mail.gmail.com>
Subject: Re: [net-next PATCH] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:01 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Sat, Dec 12, 2020 at 10:34 AM Yuchung Cheng <ycheng@google.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 5:28 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > From: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> > > message in the case of IPv6 or a fragmentation request in the case of
> > > IPv4. This results in the socket stalling for a second or more as it does
> > > not respond to the message by retransmitting the SYN frame.
> > >
> > > Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> > > ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> > > makes use of the entire MSS. In the case of fastopen it does, and an
> > > additional complication is that the retransmit queue doesn't contain the
> > > original frames. As a result when tcp_simple_retransmit is called and
> > > walks the list of frames in the queue it may not mark the frames as lost
> > > because both the SYN and the data packet each individually are smaller than
> > > the MSS size after the adjustment. This results in the socket being stalled
> > > until the retransmit timer kicks in and forces the SYN frame out again
> > > without the data attached.
> > >
> > > In order to resolve this we can generate our best estimate for the original
> > > packet size by detecting the fastopen SYN frame and then adding the
> > > overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
> > > have exceeded the MSS. If so we can mark the frame as lost and retransmit
> > > it.
> > >
> > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > ---
> > >  net/ipv4/tcp_input.c |   30 +++++++++++++++++++++++++++---
> > >  1 file changed, 27 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index 9e8a6c1aa019..79375b58de84 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -2686,11 +2686,35 @@ static void tcp_mtup_probe_success(struct sock *sk)
> > >  void tcp_simple_retransmit(struct sock *sk)
> > >  {
> > >         const struct inet_connection_sock *icsk = inet_csk(sk);
> > > +       struct sk_buff *skb = tcp_rtx_queue_head(sk);
> > >         struct tcp_sock *tp = tcp_sk(sk);
> > > -       struct sk_buff *skb;
> > > -       unsigned int mss = tcp_current_mss(sk);
> > > +       unsigned int mss;
> > > +
> > > +       /* A fastopen SYN request is stored as two separate packets within
> > > +        * the retransmit queue, this is done by tcp_send_syn_data().
> > > +        * As a result simply checking the MSS of the frames in the queue
> > > +        * will not work for the SYN packet. So instead we must make a best
> > > +        * effort attempt by validating the data frame with the mss size
> > > +        * that would be computed now by tcp_send_syn_data and comparing
> > > +        * that against the data frame that would have been included with
> > > +        * the SYN.
> > > +        */
> > > +       if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN && tp->syn_data) {
> > > +               struct sk_buff *syn_data = skb_rb_next(skb);
> > > +
> > > +               mss = tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) +
> > > +                     tp->tcp_header_len - sizeof(struct tcphdr) -
> > > +                     MAX_TCP_OPTION_SPACE;
> > nice comment! The original syn_data mss needs to be inferred which is
> > a hassle to get right. my sense is path-mtu issue is enough to warrant
> > they are lost.
> > I suggest simply mark syn & its data lost if tcp_simple_retransmit is
> > called during TFO handshake, i.e.
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 62f7aabc7920..7f0c4f2947eb 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -2864,7 +2864,8 @@ void tcp_simple_retransmit(struct sock *sk)
> >         unsigned int mss = tcp_current_mss(sk);
> >
> >         skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
> > -               if (tcp_skb_seglen(skb) > mss)
> > +               if (tcp_skb_seglen(skb) > mss ||
> > +                   (tp->syn_data && sk->sk_state == TCP_SYN_SENT))
> >                         tcp_mark_skb_lost(sk, skb);
> >         }
> >
> > We have a TFO packetdrill test that verifies my suggested fix should
> > trigger an immediate retransmit vs 1s wait.
>
> Okay, I will go that route, although I will still probably make one
> minor cleanup. Instead of testing for syn_data and state per packet I
> will probably keep the bit where I overwrite mss since it is only used
> in the loop. What I can do is switch it from unsigned int to int since
> technically tcp_current_mss and tcp_skb_seglen are both a signed int
> anyway. Then I can just set mss to -1 in the syn_data && TCP_SYN_SENT
> case. That way all of the frames in the ring should fail the check
> while only having to add one initial check outside the loop.
sounds good. I thought about that too but decided it's normally just
two skbs and not worth the hassle.

btw I thought about negatively caching this event to disable TFO
completely afterward, but I assume it's not needed as the ICMP error
should correct the route mtu hence future TFO should be fine. If
that's not the case we might want to consider disable TFO to avoid
this future "TFO->ICMP->SYN-retry" repetition.
