Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940592D898C
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439801AbgLLTCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439791AbgLLTCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 14:02:08 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5D3C0613CF;
        Sat, 12 Dec 2020 11:01:27 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id b8so11969860ila.13;
        Sat, 12 Dec 2020 11:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CoIhVw1fwt+v9IAvlcT9DDHqpk/SQNAokniuhYTX/iI=;
        b=I7ZTjyamwskfL5E3eh0wAr0DK0d5VYI/XaNciyTF8fRt+QT0bUgMhuhyJyEqfjFi0h
         IDeKqBXvnttz4y/7oEd/4jzqI/HZASgYmHKiinbw2+4pKnQtUas3gwqpRo14UxAIo9he
         931pH8/cjrw8WDBl+g8eAl/FNFL7PeHFNaOj00yoz3QAOOKeRBYqvYR0am0u9+OOXK+M
         S5VW5i/GBxOantHvJyeTlfo3RnggI/BJpSpA+aD7CvZPZOqoaq4c742RbbWmlGdnG39j
         3DN5wHbBpOgCI9vPI5i/vBf8L/0YQwCb+3u8JxN0p9EPoSpig+RVcsdU6lD2EDt57y89
         r5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CoIhVw1fwt+v9IAvlcT9DDHqpk/SQNAokniuhYTX/iI=;
        b=f5BsTHb6wbTz135s9L4jMySPP+BUYJ+CvQLSpwUauK6BKkeCnSWyv/dPIYuHXMC9ba
         94usJanRTwnbTCUicBAg+j8EJkv/T6yjtYjsjTsgZW2En8kuIOt2Qk7wyVF2Xn9StgEX
         Ih5tsyRZUgzPGMhal7HV77BUQRyzYnkb5vl/J/HZKlEHObXv4GS4NFut0cmsfDcJ/yOe
         3njMO5SejLXqgjuYEKnTiml+BSk4++fGGwOeVmEOJlv7MtDGfCkIQkeNVB2JGRHAyTa0
         2Ff6vTwSlPcZvckQyaoyfXlGeM1FAYxQs3T3pkwvfwZlaRBlBv93jYLZnKepRfw3Fe5x
         PXqA==
X-Gm-Message-State: AOAM531jp2sDtVscFLI7e9Wn5fXN1S+PaGdYjBe5pFhGDKYRkznqpTKu
        1lnuwhOhb29gUpwwRmEiyWeXoie56rbEBMqvM4c=
X-Google-Smtp-Source: ABdhPJzy9MG2poqiwf4iSOy2GXTQ016znhrfgGgvDLAtutEdVOstEeBwoFDVr0T7JVIbIXptQKMeuy1dkXWcJ5Yp0wY=
X-Received: by 2002:a92:c682:: with SMTP id o2mr23827445ilg.97.1607799685946;
 Sat, 12 Dec 2020 11:01:25 -0800 (PST)
MIME-Version: 1.0
References: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
 <CAK6E8=c4LpxcaF3Mr1T9BtkD5SPK1eoK_hGOMNa6C9a4fpFQNg@mail.gmail.com>
In-Reply-To: <CAK6E8=c4LpxcaF3Mr1T9BtkD5SPK1eoK_hGOMNa6C9a4fpFQNg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 12 Dec 2020 11:01:15 -0800
Message-ID: <CAKgT0UcS2s+gnYz0nvfpia5R+H7hSSVS4GGKOkkfyuz60zJpQQ@mail.gmail.com>
Subject: Re: [net-next PATCH] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
To:     Yuchung Cheng <ycheng@google.com>
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

On Sat, Dec 12, 2020 at 10:34 AM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Fri, Dec 11, 2020 at 5:28 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> > message in the case of IPv6 or a fragmentation request in the case of
> > IPv4. This results in the socket stalling for a second or more as it does
> > not respond to the message by retransmitting the SYN frame.
> >
> > Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> > ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> > makes use of the entire MSS. In the case of fastopen it does, and an
> > additional complication is that the retransmit queue doesn't contain the
> > original frames. As a result when tcp_simple_retransmit is called and
> > walks the list of frames in the queue it may not mark the frames as lost
> > because both the SYN and the data packet each individually are smaller than
> > the MSS size after the adjustment. This results in the socket being stalled
> > until the retransmit timer kicks in and forces the SYN frame out again
> > without the data attached.
> >
> > In order to resolve this we can generate our best estimate for the original
> > packet size by detecting the fastopen SYN frame and then adding the
> > overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
> > have exceeded the MSS. If so we can mark the frame as lost and retransmit
> > it.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  net/ipv4/tcp_input.c |   30 +++++++++++++++++++++++++++---
> >  1 file changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 9e8a6c1aa019..79375b58de84 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -2686,11 +2686,35 @@ static void tcp_mtup_probe_success(struct sock *sk)
> >  void tcp_simple_retransmit(struct sock *sk)
> >  {
> >         const struct inet_connection_sock *icsk = inet_csk(sk);
> > +       struct sk_buff *skb = tcp_rtx_queue_head(sk);
> >         struct tcp_sock *tp = tcp_sk(sk);
> > -       struct sk_buff *skb;
> > -       unsigned int mss = tcp_current_mss(sk);
> > +       unsigned int mss;
> > +
> > +       /* A fastopen SYN request is stored as two separate packets within
> > +        * the retransmit queue, this is done by tcp_send_syn_data().
> > +        * As a result simply checking the MSS of the frames in the queue
> > +        * will not work for the SYN packet. So instead we must make a best
> > +        * effort attempt by validating the data frame with the mss size
> > +        * that would be computed now by tcp_send_syn_data and comparing
> > +        * that against the data frame that would have been included with
> > +        * the SYN.
> > +        */
> > +       if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN && tp->syn_data) {
> > +               struct sk_buff *syn_data = skb_rb_next(skb);
> > +
> > +               mss = tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) +
> > +                     tp->tcp_header_len - sizeof(struct tcphdr) -
> > +                     MAX_TCP_OPTION_SPACE;
> nice comment! The original syn_data mss needs to be inferred which is
> a hassle to get right. my sense is path-mtu issue is enough to warrant
> they are lost.
> I suggest simply mark syn & its data lost if tcp_simple_retransmit is
> called during TFO handshake, i.e.
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 62f7aabc7920..7f0c4f2947eb 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2864,7 +2864,8 @@ void tcp_simple_retransmit(struct sock *sk)
>         unsigned int mss = tcp_current_mss(sk);
>
>         skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
> -               if (tcp_skb_seglen(skb) > mss)
> +               if (tcp_skb_seglen(skb) > mss ||
> +                   (tp->syn_data && sk->sk_state == TCP_SYN_SENT))
>                         tcp_mark_skb_lost(sk, skb);
>         }
>
> We have a TFO packetdrill test that verifies my suggested fix should
> trigger an immediate retransmit vs 1s wait.

Okay, I will go that route, although I will still probably make one
minor cleanup. Instead of testing for syn_data and state per packet I
will probably keep the bit where I overwrite mss since it is only used
in the loop. What I can do is switch it from unsigned int to int since
technically tcp_current_mss and tcp_skb_seglen are both a signed int
anyway. Then I can just set mss to -1 in the syn_data && TCP_SYN_SENT
case. That way all of the frames in the ring should fail the check
while only having to add one initial check outside the loop.
