Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858CE4CB2DB
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 00:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiCBXpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 18:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCBXpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 18:45:40 -0500
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F233CFC6
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 15:43:30 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2dbfe58670cso37128517b3.3
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 15:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgNhfgXNvyHwhRIZSvG9yNwFcZmNZTVBZvrVHxQyTck=;
        b=owyjROhU/UFdgg6nxsLdMVG+dkHKfTk0mEiDXgu0qJKKEKJdLctZevqTiPFwDovYjV
         UMw4lGfsTkK81cAvS4YTfb9KrrhZSnjOunYC/34pePhthPVVbIxP+cpj+MDXBCFkH7BL
         xUeA3D4orCI4+n0EtzJwsq7/WEhysbZDl/TlqF6ksa39hQ3g9kZB5hJZcJntDZxXk4Wv
         j/kdkY2gRCyiN9zL+bqckg5kpsoCFXJ8KyleCDWaLIS824v0WJC7FMrMo5KiGgtaDjCx
         3CBWL7A62bjWq80CgJ+rzeowqqKl8yXKQFc6NGG7kEKF5G4oCiv6vik6dSkg29Pyb99N
         nHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgNhfgXNvyHwhRIZSvG9yNwFcZmNZTVBZvrVHxQyTck=;
        b=1XVQzJHy5yuDTay0kKGRmUFCA/F+KsIOvxf9o16fiGmjs1VzkBsLFX8anCy13ZAi2L
         Ygqey2ZAUUeuo4twZjytQom4XTcbPApKEoL7qoN9HTN672Ix2Npgzx5FcgcdjhBeA9vF
         L5XoaupUktGrz0fNEmq7pzqpj0z1bzcoIoAFaey7zYxhe6WLEv/Z5+phId+ALE+dcST5
         gbEq7OY0n2UuM0yHPIssuR+4Lnw5FFmjb5mRg6smgbqxRJq5Sk6NqKVN3kp3+aMhIksT
         u7PeetDXH48xE3Mk00bJ9KXhMY4U+iQJ3aJoULf833A4/PyttQctwGgKMV35N1TUeuUR
         ZUgA==
X-Gm-Message-State: AOAM532YiK1TzCnsBqAho5MLI6z7oyy7+TKkXhwFoTech5MGarq4pkrc
        IcV+Cdbq8EvQu3fgLgAwjI6rnMutDJMpH6wPZNG1kA==
X-Google-Smtp-Source: ABdhPJwycDWmZwQXC+GHVdnAAJMiWT0ODpRc0qF6HLXHX5qelrZBF9SJkAASLiAxxM1LqYq5qFLs8avjb2+gvb810Ts=
X-Received: by 2002:a0d:d596:0:b0:2db:fc7f:990e with SMTP id
 x144-20020a0dd596000000b002dbfc7f990emr8569913ywd.47.1646264531012; Wed, 02
 Mar 2022 15:42:11 -0800 (PST)
MIME-Version: 1.0
References: <20220302195519.3479274-1-kafai@fb.com> <20220302195622.3483941-1-kafai@fb.com>
 <CANn89iKN06bKxjrEeZAmcj0x4tYMwRv-YzdZLWKbCcuTYT+SpQ@mail.gmail.com> <20220302223352.txuhu4ielmlxldrg@kafai-mbp>
In-Reply-To: <20220302223352.txuhu4ielmlxldrg@kafai-mbp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Mar 2022 15:41:59 -0800
Message-ID: <CANn89i+ZLB8EK2CUC7dnERvcawSAOhpzHpeKSvL0dVfK-fusXg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 10/13] net: Postpone skb_clear_delivery_time()
 until knowing the skb is delivered locally
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 2, 2022 at 2:34 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Mar 02, 2022 at 12:30:14PM -0800, Eric Dumazet wrote:
> > On Wed, Mar 2, 2022 at 11:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > The previous patches handled the delivery_time in the ingress path
> > > before the routing decision is made.  This patch can postpone clearing
> > > delivery_time in a skb until knowing it is delivered locally and also
> > > set the (rcv) timestamp if needed.  This patch moves the
> > > skb_clear_delivery_time() from dev.c to ip_local_deliver_finish()
> > > and ip6_input_finish().
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  net/core/dev.c       | 8 ++------
> > >  net/ipv4/ip_input.c  | 1 +
> > >  net/ipv6/ip6_input.c | 1 +
> > >  3 files changed, 4 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 0fc02cf32476..3ff686cc8c84 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -5193,10 +5193,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> > >                         goto out;
> > >         }
> > >
> > > -       if (skb_skip_tc_classify(skb)) {
> > > -               skb_clear_delivery_time(skb);
> > > +       if (skb_skip_tc_classify(skb))
> > >                 goto skip_classify;
> > > -       }
> > >
> > >         if (pfmemalloc)
> > >                 goto skip_taps;
> > > @@ -5225,14 +5223,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> > >                         goto another_round;
> > >                 if (!skb)
> > >                         goto out;
> > > -               skb_clear_delivery_time(skb);
> > >
> > >                 nf_skip_egress(skb, false);
> > >                 if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
> > >                         goto out;
> > > -       } else
> > > +       }
> > >  #endif
> > > -               skb_clear_delivery_time(skb);
> > >         skb_reset_redirect(skb);
> > >  skip_classify:
> > >         if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
> > > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > > index d94f9f7e60c3..95f7bb052784 100644
> > > --- a/net/ipv4/ip_input.c
> > > +++ b/net/ipv4/ip_input.c
> > > @@ -226,6 +226,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
> > >
> > >  static int ip_local_deliver_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> > >  {
> > > +       skb_clear_delivery_time(skb);
> > >         __skb_pull(skb, skb_network_header_len(skb));
> > >
> > >         rcu_read_lock();
> > > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > > index d4b1e2c5aa76..5b5ea35635f9 100644
> > > --- a/net/ipv6/ip6_input.c
> > > +++ b/net/ipv6/ip6_input.c
> > > @@ -459,6 +459,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
> > >
> > >  static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> > >  {
> > > +       skb_clear_delivery_time(skb);
> > >         rcu_read_lock();
> > >         ip6_protocol_deliver_rcu(net, skb, 0, false);
> > >         rcu_read_unlock();
> > > --
> > > 2.30.2
> > >
> >
> > It is not clear to me why we need to clear tstamp if packet is locally
> > delivered ?
> It does not clear the rx tstamp in skb->tstamp.
>
> It only clears the EDT in skb->tstamp when the skb
> is transmitted out of a local tcp_sock and then loop back from egress
> to ingress through virtual interface like veth.
>
> >
> > TCP stack is using tstamp for incoming packets (look for
> > TCP_SKB_CB(skb)->has_rxtstamp)
> skb_clear_delivery_time() will put ktime_get_real() back to skb->tstamp
> so that the receiving tcp_sock can use it.


Oh... I had to look at

+static inline void skb_clear_delivery_time(struct sk_buff *skb)
+{
+       if (skb->mono_delivery_time) {
+               skb->mono_delivery_time = 0;
+               if (static_branch_unlikely(&netstamp_needed_key))
+                       skb->tstamp = ktime_get_real();
+               else
+                       skb->tstamp = 0;
+       }
+}

Name was a bit confusing :)

And it seems you have a big opportunity to not call ktime_get_real()
when skb->sk is known at this point (early demux)
because few sockets actually enable timestamping ?
