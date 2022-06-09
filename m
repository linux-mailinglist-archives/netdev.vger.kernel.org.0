Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79323545469
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345170AbiFISuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344304AbiFISut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:50:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EDA644F6;
        Thu,  9 Jun 2022 11:50:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso144290pjl.3;
        Thu, 09 Jun 2022 11:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQARwMq4bydzOot7fmffdQ50f6I/B00IarAq7BlnCbg=;
        b=TvUMLFVtmHxB4aFQn2UYxsDLbd0w59I5h+hDH7G5uIEJl4xD+mn23T/O7MNj5YBXiF
         ydDGgyPPxuiZpgBjndpbxFMaU8zTkF1wA/4YWzyOjeSdSTMhbDTJGvSoKGm/nljNBXvs
         ae7X8MGoxFC99rTR7N/3XGZ2uRJ6diXNEbiINJJw+bW3B1doRjvTxBlIpHFMA/iC6a/w
         tSdhpIrhI8CHhUrPsSwaQNNNCbBfXvEaSZsUH/q6qdUfFJgztijGepIIHWFTQHVTcO5p
         v5x8vKLRRMa/oHh4vg/WXZy6Re0sTBocMI9lOd+iWpY9zw7o8UH8NDJjc9qpi3wrUz0r
         bY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQARwMq4bydzOot7fmffdQ50f6I/B00IarAq7BlnCbg=;
        b=lYybgz4cqA94vQKuN7323EjwNwoRRVwwlVVj+d2H+YbbzSvxHkRZuNHq3acUjTN4QP
         2Pc2a5dmXV5b61XxDiVtWC1IVP6+4Q6yNWwPCkZEtnt3EpX9yAZ6EruVVPco0nu6qf+H
         vLttTBK3+x2RRaGusMHBWOR87znWRa7FwCXtsjeU8+9ei6c3+ddTdnmQ/Rxlo+GApuCd
         0qen+cl9zX0Gkh9SOX9wcY/DOA33C0d+26AjAFGNZiCtOdKkQzxyEx6NNJPkLd4hkY5C
         ENZwLd/3Iurclu64mAM9FcIw/Sj8cHu1OMy8HJBUGaQYpp0rjUpekooGA/SlaqUZ6tqR
         JCrQ==
X-Gm-Message-State: AOAM532HrNQ/CaE00qWYEX6Zmv7RNe+GV+el7DadmS10WU6rM3lEEfU3
        yby3CzBGozAVjA+ONarcUSrSW00vL7ERTSdmU+I=
X-Google-Smtp-Source: ABdhPJzd1wu1Ub9bDy4dEqmWJfnlS5l8Se7kN7M+yXrSvfO4HL3PRMYuTzpQpzWkB5KhkVaG2SQK3LBgQHDRccqbCT0=
X-Received: by 2002:a17:903:1c2:b0:163:ef7b:e10f with SMTP id
 e2-20020a17090301c200b00163ef7be10fmr40494627plh.158.1654800646597; Thu, 09
 Jun 2022 11:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
 <20220602012105.58853-2-xiyou.wangcong@gmail.com> <62a20ceaba3d4_b28ac2082c@john.notmuch>
In-Reply-To: <62a20ceaba3d4_b28ac2082c@john.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jun 2022 11:50:34 -0700
Message-ID: <CAM_iQpWN-PidFerX+2jdKNaNpx4wTVRbp+gGDow=1qKx12i4qA@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
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

On Thu, Jun 9, 2022 at 8:08 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > a preparation for the next patch which actually introduces
> > a new sock ops.
> >
> > TCP is special here, because it has tcp_read_sock() which is
> > mainly used by splice(). tcp_read_sock() supports partial read
> > and arbitrary offset, neither of them is needed for sockmap.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/tcp.h |  2 ++
> >  net/ipv4/tcp.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 1e99f5c61f84..878544d0f8f9 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -669,6 +669,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
> >  /* Read 'sendfile()'-style from a TCP socket */
> >  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >                 sk_read_actor_t recv_actor);
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +              sk_read_actor_t recv_actor);
> >
> >  void tcp_initialize_rcv_mss(struct sock *sk);
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 9984d23a7f3e..a18e9ababf54 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1709,6 +1709,53 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >  }
> >  EXPORT_SYMBOL(tcp_read_sock);
> >
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +              sk_read_actor_t recv_actor)
> > +{
> > +     struct tcp_sock *tp = tcp_sk(sk);
> > +     u32 seq = tp->copied_seq;
> > +     struct sk_buff *skb;
> > +     int copied = 0;
> > +     u32 offset;
> > +
> > +     if (sk->sk_state == TCP_LISTEN)
> > +             return -ENOTCONN;
> > +
> > +     while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> > +             int used;
> > +
> > +             __skb_unlink(skb, &sk->sk_receive_queue);
> > +             used = recv_actor(desc, skb, 0, skb->len);
> > +             if (used <= 0) {
> > +                     if (!copied)
> > +                             copied = used;
> > +                     break;
> > +             }
> > +             seq += used;
> > +             copied += used;
> > +
> > +             if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > +                     kfree_skb(skb);
>
> Hi Cong, can you elaborate here from v2 comment.
>
> "Hm, it is tricky here, we use the skb refcount after this patchset, so
> it could be a real drop from another kfree_skb() in net/core/skmsg.c
> which initiates the drop."

Sure.

This is the source code of consume_skb():

 911 void consume_skb(struct sk_buff *skb)
 912 {
 913         if (!skb_unref(skb))
 914                 return;
 915
 916         trace_consume_skb(skb);
 917         __kfree_skb(skb);
 918 }

and this is kfree_skb (or kfree_skb_reason()):

 770 void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 771 {
 772         if (!skb_unref(skb))
 773                 return;
 774
 775         DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >=
SKB_DROP_REASON_MAX);
 776
 777         trace_kfree_skb(skb, __builtin_return_address(0), reason);
 778         __kfree_skb(skb);
 779 }

So, both do refcnt before tracing, very clearly.

Now, let's do a simple case:

tcp_read_skb():
 -> tcp_recv_skb() // Let's assume skb refcnt == 1 here
  -> recv_actor()
   -> skb_get() // refcnt == 2
   -> kfree_skb() // Let's assume users drop it intentionally
 ->kfree_skb() // refcnt == 0 here, if we had consume_skb() it would
not be counted as a drop

Of course you can give another example where consume_skb() is
correct, but the point here is it is very tricky when refcnt, I even doubt
we can do anything here, maybe moving trace before refcnt.

>
> The tcp_read_sock() hook is using tcp_eat_recv_skb(). Are we going
> to kick tracing infra even on good cases with kfree_skb()? In
> sk_psock_verdict_recv() we do an skb_clone() there.

I don't get your point here, are you suggesting we should sacrifice
performance just to make the drop tracing more accurate??

Thanks.
