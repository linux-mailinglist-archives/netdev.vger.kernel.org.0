Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886545A7614
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiHaF7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHaF7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:59:13 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FEDBB6B4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:59:11 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k17so6791162wmr.2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3TCL9t7Bgnyr/InAJ/iHHFQVuuKgoXmlSCQBXRR5O2Y=;
        b=j1EFeSh0vNC/UvInkIyffQav5tcLka44cWQT3tq7W5qszzYbD77jKiycECugn9f7hY
         SJVT2dZ2BknrFdj2OU+lhN7LZw++yjG56DvL4jIX519f1x6JLihwPOVA5Zg5mzHM4PY+
         FfTZF7eJvEej32J/iXWAq19dY6qn+WAhQ/oBVCeE/phG/GyC5k914PJOVp7Z76fNPUgP
         3avA14+XxseA69/WqE60870RRhf4fHl8TVxwYARJqdt3qLe9Jaaj1jiI4b+OWKDWd2wa
         2TtYd9otl/fjd/Xj6ncsMHrWXep/CN54g4gpnaUz2Z52zjDO4GoE+5DFtxj6d8ufiTlX
         UvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3TCL9t7Bgnyr/InAJ/iHHFQVuuKgoXmlSCQBXRR5O2Y=;
        b=nnH+0Yh+HwoKIf/uJWhh4kOIRUO8BfnIZa7f0eB7RKs2CfXvyjYGRvoU6r2t6TkM5o
         KEZTDwOADJ8yHpeos9aG4nkUGCn7M1ZgHuU4vglMs1MmoI9grJI0c6IItnvzuGq9PN2C
         IA69WJM9NKYPScBzcNyM49pvqTkNe+VEocPpafHeeGxBwOGRwXEv6QyNqyZJU2TyfMbo
         N9CRwGxa3+fu+8NARvfOMR5hMnnyr71qyCb4jf+1NWxIltc3ZhOlfmNcS9ptnVCVhU6h
         b91Xdw04EBszpaeWJPp6p1pmWfTnS3c6rGzbA+QBOGO+iuu2q8NWd+kdMjmyRoDGswae
         0T+w==
X-Gm-Message-State: ACgBeo1/Of9v6l0mdgIED5rPqtZlBpTQEkSCvktNC9KAX5Vo3NfX0y+Z
        XhwaXwflKoEKluuQxI2kEzb6JK7WY+tHJTyRmWSdbA==
X-Google-Smtp-Source: AA6agR5GPLu5ti18nyp79BUQIBXdiW3vi1dzE/5mykX/ofxn9OLNQ/KpiBGsT2ERpg+8mgbP47A3r66nwlvk6MYdjfg=
X-Received: by 2002:a05:600c:2c47:b0:3a6:4623:4ccf with SMTP id
 r7-20020a05600c2c4700b003a646234ccfmr857961wmg.85.1661925549986; Tue, 30 Aug
 2022 22:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn> <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
In-Reply-To: <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 30 Aug 2022 22:58:33 -0700
Message-ID: <CAK6E8=eNe8Ce9zKXx1rKBL48XuDVGntAOOtKVi6ywgMjafMWXg@mail.gmail.com>
Subject: Re: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as lost
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 5:23 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Mon, Aug 29, 2022 at 1:21 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
> >
> > if rack is enabled, when skb marked as lost we can remove it from
> > tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
> > in tcp_rack_detect_loss
>
> Did you test the case where an skb is marked lost again after
> retransmission? I can't quite remember the reason I avoided this
> optimization. let me run some test and get back to you.
As I suspected, this patch fails to pass our packet drill tests.

It breaks detecting retransmitted packets that
get lost again, b/c they have already been removed from the tsorted
list when they get lost the first time.



>
>
> >
> > Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> > ---
> >  net/ipv4/tcp_input.c    | 15 +++++++++------
> >  net/ipv4/tcp_recovery.c |  1 -
> >  2 files changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index ab5f0ea..01bd644 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -1082,6 +1082,12 @@ static void tcp_notify_skb_loss_event(struct tcp_sock *tp, const struct sk_buff
> >         tp->lost += tcp_skb_pcount(skb);
> >  }
> >
> > +static bool tcp_is_rack(const struct sock *sk)
> > +{
> > +       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
> > +               TCP_RACK_LOSS_DETECTION;
> > +}
> > +
> >  void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
> >  {
> >         __u8 sacked = TCP_SKB_CB(skb)->sacked;
> > @@ -1105,6 +1111,9 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
> >                 TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
> >                 tcp_notify_skb_loss_event(tp, skb);
> >         }
> > +
> > +       if (tcp_is_rack(sk))
> > +               list_del_init(&skb->tcp_tsorted_anchor);
> >  }
> >
> >  /* Updates the delivered and delivered_ce counts */
> > @@ -2093,12 +2102,6 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
> >         tp->undo_retrans = tp->retrans_out ? : -1;
> >  }
> >
> > -static bool tcp_is_rack(const struct sock *sk)
> > -{
> > -       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
> > -               TCP_RACK_LOSS_DETECTION;
> > -}
> > -
> >  /* If we detect SACK reneging, forget all SACK information
> >   * and reset tags completely, otherwise preserve SACKs. If receiver
> >   * dropped its ofo queue, we will know this due to reneging detection.
> > diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
> > index 50abaa9..ba52ec9e 100644
> > --- a/net/ipv4/tcp_recovery.c
> > +++ b/net/ipv4/tcp_recovery.c
> > @@ -84,7 +84,6 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
> >                 remaining = tcp_rack_skb_timeout(tp, skb, reo_wnd);
> >                 if (remaining <= 0) {
> >                         tcp_mark_skb_lost(sk, skb);
> > -                       list_del_init(&skb->tcp_tsorted_anchor);
> >                 } else {
> >                         /* Record maximum wait time */
> >                         *reo_timeout = max_t(u32, *reo_timeout, remaining);
> > --
> > 1.8.3.1
> >
