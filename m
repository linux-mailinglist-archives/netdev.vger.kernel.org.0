Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB44DE79D
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiCSLgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiCSLgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:36:14 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFAB72E14;
        Sat, 19 Mar 2022 04:34:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id pv16so21561382ejb.0;
        Sat, 19 Mar 2022 04:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GCyaiIyulYiRPJG+U5bAE+q2EiKyg/uq87Et1zSg2oo=;
        b=D+MFHTtd3CLfZT3gaQCA1Ik84PwHfTLjH+DEEh3+LR37AJPFLRePBpxXLIBHMKMzmQ
         fhVzTYWvsiytl+7b69QcI+ybs8X+Gm+IXADVMOa0CS4Y1MKG8+eHSPb8Hvu6kLYIlcqs
         gSHEH7FCeF7DBLgkcp3TjXWyFjiyPqfvBFNWVrJ231+5ss5SWsGxrfWXPTwH8N36KWIT
         yN8TaxgZSo8WfnnAIjhq8OM2ZrHBEd3cQkLKIk60YheBGNkh0WHuxJ/qUP+Exia292VI
         Fxef3OVeIUc0NyAouHmgjrtZ8GyCc4b9Z1blMq2LtgYYiD4MPhL8B3AdcEM/1R61v264
         nXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GCyaiIyulYiRPJG+U5bAE+q2EiKyg/uq87Et1zSg2oo=;
        b=Nt070wBZ1zh/uR5uaHzxla3QcVARjdqw1oKA1KKUrL3I9QV7jGMwoXSD9gz+jngBWR
         TUQoyaFj2c4QO9O5SVVXQVFOq0TWpHmFLw0YPLMAhk3FAnNjyPqnftPvF8yof/X/pNLC
         F5tENLhCrt1hFT3aSwE125quh9vIS8FPdJPBpYAT9wzKQ+HXHqdydtZuTYvwp5Scc8YV
         JSEcp1egR6zI07ER4np38dFdLrYz1M7981RmPaO7JoO6/wIMJssexRoXpCmi5QE/tIF2
         HfW3I58MNi8CGmwmRLaem9tqX5OkcJGArFbhzyhm9rboc0FkamhrcX62o6mJ+AN25Onl
         XS2w==
X-Gm-Message-State: AOAM532bGJ7TWCP35ZeYkCW9vt9z5IqcMsPi/XFfU0bfLu3TxfqoHVTp
        nY2j4DOW4K+Peck7nYQuIuTRkzAtDaiPSI+S0ug=
X-Google-Smtp-Source: ABdhPJzXHFIlROCe94BV4qIIXSdsS6KIF3dG8ckx335jJjq3Cujb0IaJG33CpeVulvbDYSjwn1rvUYDbiz/LmHHwN2s=
X-Received: by 2002:a17:907:3e82:b0:6da:6f15:ff38 with SMTP id
 hs2-20020a1709073e8200b006da6f15ff38mr12827813ejc.324.1647689691792; Sat, 19
 Mar 2022 04:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220319110422.8261-1-zhouzhouyi@gmail.com> <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
In-Reply-To: <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 19 Mar 2022 19:34:40 +0800
Message-ID: <CAABZP2yK2vCJcReJ_VvcqbkuEekvBpBJCyZ2geG=f83fv_RC=Q@mail.gmail.com>
Subject: Re: [PATCH v2] net:ipv4: send an ack when seg.ack > snd.nxt
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wei Xu <xuweihf@ustc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing my patch

On Sat, Mar 19, 2022 at 7:14 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Mar 19, 2022 at 4:04 AM <zhouzhouyi@gmail.com> wrote:
> >
> > From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> >
> > In RFC 793, page 72: "If the ACK acks something not yet sent
> > (SEG.ACK > SND.NXT) then send an ACK, drop the segment,
> > and return."
> >
> > Fix Linux's behavior according to RFC 793.
> >
> > Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
> > Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
> > Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > ---
> > Thank Florian Westphal for pointing out
> > the potential duplicated ack bug in patch version 1.
>
> I am travelling this week, but I think your patch is not necessary and
> might actually be bad.
>
> Please provide more details of why nobody complained of this until today.
>
> Also I doubt you actually fully tested this patch, sending a V2 30
> minutes after V1.
>
> If yes, please provide a packetdrill test.
I am a beginner to TCP, although I have submitted once a patch to
netdev in 2013 (aaa0c23cb90141309f5076ba5e3bfbd39544b985), this is
first time I learned packetdrill test.
I think I should do the packetdrill test in the coming days, and
provide more details of how this (RFC793 related) can happen.

Apologize sincerely in advance if I have made noise.

Thank you for your time

Sincerely
Zhouyi
>
> Thank you.
>
> > --
> >  net/ipv4/tcp_input.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index bfe4112e000c..4bbf85d7ea8c 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3771,11 +3771,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
> >                 goto old_ack;
> >         }
> >
> > -       /* If the ack includes data we haven't sent yet, discard
> > -        * this segment (RFC793 Section 3.9).
> > +       /* If the ack includes data we haven't sent yet, then send
> > +        * an ack, drop this segment, and return (RFC793 Section 3.9 page 72).
> >          */
> > -       if (after(ack, tp->snd_nxt))
> > -               return -1;
> > +       if (after(ack, tp->snd_nxt)) {
> > +               tcp_send_ack(sk);
> > +               return -2;
> > +       }
> >
> >         if (after(ack, prior_snd_una)) {
> >                 flag |= FLAG_SND_UNA_ADVANCED;
> > @@ -6385,6 +6387,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
> >         struct request_sock *req;
> >         int queued = 0;
> >         bool acceptable;
> > +       int ret;
> >
> >         switch (sk->sk_state) {
> >         case TCP_CLOSE:
> > @@ -6451,14 +6454,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
> >                 return 0;
> >
> >         /* step 5: check the ACK field */
> > -       acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
> > -                                     FLAG_UPDATE_TS_RECENT |
> > -                                     FLAG_NO_CHALLENGE_ACK) > 0;
> > +       ret = tcp_ack(sk, skb, FLAG_SLOWPATH |
> > +                               FLAG_UPDATE_TS_RECENT |
> > +                               FLAG_NO_CHALLENGE_ACK);
> > +       acceptable = ret > 0;
> >
> >         if (!acceptable) {
> >                 if (sk->sk_state == TCP_SYN_RECV)
> >                         return 1;       /* send one RST */
> > -               tcp_send_challenge_ack(sk);
> > +               if (ret > -2)
> > +                       tcp_send_challenge_ack(sk);
> >                 goto discard;
> >         }
> >         switch (sk->sk_state) {
> > --
> > 2.25.1
> >
