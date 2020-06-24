Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52212077DC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404486AbgFXPrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404312AbgFXPrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 11:47:18 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E84C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:47:18 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id r18so1257508ybl.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjXRx8PCtFQo2aMIioS6QMYlCZHl2Qx2e56WVj9uL2E=;
        b=cXs3sDO71et7NUSnfJzWdeg534BA80nbeYuUBEB+tjjra6jCHFvSUsRTqXCdO8oIkR
         AA0SOuoQmvO/MSxQ7S9lVl+kpeao03ez3AX3WHY6vK6MATasRex52D4f+nNWLz1LMl4q
         PVgYXCZRzLxV7+IJN4fHklLn5OJVCAODmQNefy6sSxv06p6IqGhmxMPow1Xv6qedo4qu
         Lpo9PaXJ7ouFDkgRjsGLR1IKsX+oFabx4+tw7v/nY3qn6LtDvohrduASH9dS9Ee1/H7g
         zVF2gbXuyijtEcwvpBrLVi8JRV4JO1wZG+mJ9I6Cka+ZOhvcPCSZmhZHUeG5RHZ5tE8p
         KO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjXRx8PCtFQo2aMIioS6QMYlCZHl2Qx2e56WVj9uL2E=;
        b=cdQ3w6NkqNDxNkDJ95D9LNScb89iSy122qULRegtGvkzJQT2qGf+WmoYfIUJ4ETKk1
         Tvu0IF4a8ObFGR4XKz3AyN7jZKVd9nM80diJCvFxYIByfgT5mUxCVigt2y3yj/5VipmX
         gbHrx2SO4l/DZ3EaaEWhTMNORk2x3hB9a9a35TNtklFYylhjOEZgCoaFIbsEGLet+k0Y
         PmnPRFbpNGVKfG7cqFm78tFT296qvrWJvxkohtYVtq0jsezRXH/yEyYpJNL0jtNNmlEj
         9ZHsNUluHIDUcSD5BtUZnf4+QMxmsje2qxfBdknyzcMji5YoOvU4375cf7jYD4jU/1+V
         L0cA==
X-Gm-Message-State: AOAM530Tx14++LPzyxqjoUPTWNl3IymKicJvz3/CdWWeimOuGh/hEldg
        z9OdyEmdrf4kqbW/+iPCYY1wF73jVmrmPHNXF7oyQjHyEJg=
X-Google-Smtp-Source: ABdhPJyIcuHF4lLV6rFklCl+NJxkBGOiRzbo4H+68h20t/Gx99+uhvMYQMnRAbHNasF7AMWY0E0MhFfSRbjxt4GTwnM=
X-Received: by 2002:a05:6902:1005:: with SMTP id w5mr49599061ybt.173.1593013637043;
 Wed, 24 Jun 2020 08:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200624095748.8246-1-denis.kirjanov@suse.com> <CADVnQym6aoueiB-auSxgp5tp0rjjte+MaxRPWd3t44F5VueKdA@mail.gmail.com>
In-Reply-To: <CADVnQym6aoueiB-auSxgp5tp0rjjte+MaxRPWd3t44F5VueKdA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 24 Jun 2020 08:47:05 -0700
Message-ID: <CANn89iK_75H5jwGLaXUfRnLOgrFdP25xAYmyoD3SW6iFGEL96Q@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: don't ignore ECN CWR on pure ACK
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        "Scheffenegger, Richard" <Richard.Scheffenegger@netapp.com>,
        Bob Briscoe <ietf@bobbriscoe.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 6:43 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Jun 24, 2020 at 5:58 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
> >
> > there is a problem with the CWR flag set in an incoming ACK segment
> > and it leads to the situation when the ECE flag is latched forever
> >
> > the following packetdrill script shows what happens:
> >
> > // Stack receives incoming segments with CE set
> > +0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
> > +0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
> > +0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535
> >
> > // Stack repsonds with ECN ECHO
> > +0.0 >[noecn]  . 1001:1001(0) ack 12001
> > +0.0 >[noecn] E. 1001:1001(0) ack 13001
> > +0.0 >[noecn] E. 1001:1001(0) ack 14001
> >
> > // Write a packet
> > +0.1 write(3, ..., 1000) = 1000
> > +0.0 >[ect0] PE. 1001:2001(1000) ack 14001
> >
> > // Pure ACK received
> > +0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535
> >
> > // Since CWR was sent, this packet should NOT have ECE set
> >
> > +0.1 write(3, ..., 1000) = 1000
> > +0.0 >[ect0]  P. 2001:3001(1000) ack 14001
> > // but Linux will still keep ECE latched here, with packetdrill
> > // flagging a missing ECE flag, expecting
> > // >[ect0] PE. 2001:3001(1000) ack 14001
> > // in the script
> >
> > In the situation above we will continue to send ECN ECHO packets
> > and trigger the peer to reduce the congestion window. To avoid that
> > we can check CWR on pure ACKs received.
> >
> > v2:
> > - Adjusted the comment
> > - move CWR check before checking for unacknowledged packets
> >
> > Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> > ---
> >  net/ipv4/tcp_input.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 12fda8f27b08..f1936c0cb684 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3665,6 +3665,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
> >                 tcp_in_ack_event(sk, ack_ev_flags);
> >         }
> >
> > +       /* This is a deviation from RFC3168 since it states that:
> > +        * "When the TCP data sender is ready to set the CWR bit after reducing
> > +        * the congestion window, it SHOULD set the CWR bit only on the first
> > +        * new data packet that it transmits."
> > +        * We accept CWR on pure ACKs to be more robust
> > +        * with widely-deployed TCP implementations that do this.
> > +        */
> > +       tcp_ecn_accept_cwr(sk, skb);
> > +
> >         /* We passed data and got it acked, remove any soft error
> >          * log. Something worked...
> >          */
> > @@ -4800,8 +4809,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
> >         skb_dst_drop(skb);
> >         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
> >
> > -       tcp_ecn_accept_cwr(sk, skb);
> > -
> >         tp->rx_opt.dsack = 0;
> >
> >         /*  Queue data for delivery to the user.
> > --
>
> Thanks for the patch!
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>

Hmm... It would be nice maybe to fix the offenders, because many linux
devices won't get this work around before years.

Do we really want to trigger an ACK if we received a packet with no payload ?

I would think that the following is also needed :

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08bdf5c9f3bad422734f6b1965cef9..023dc90569c89d7d17d72f73641598a03a03b0a9
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -261,7 +261,8 @@ static void tcp_ecn_accept_cwr(struct sock *sk,
const struct sk_buff *skb)
                 * cwnd may be very low (even just 1 packet), so we should ACK
                 * immediately.
                 */
-               inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
+               if (TCP_SKB_CB(skb)->seq != TCP_SKB_CB(skb)->end_seq)
+                       inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
        }
 }
