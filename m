Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0498934375A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 04:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVDYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 23:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhCVDXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 23:23:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F7EC061574;
        Sun, 21 Mar 2021 20:23:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ha17so7640165pjb.2;
        Sun, 21 Mar 2021 20:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MM0iX4iVip2FjJIJrcyDJ5FE2gOlZHEuDKpuW9DbD8s=;
        b=ivk/NOwcHksdShEEdS6PNRmtWq7DeyPbu/FwKbkE6TkaLFYfW/bSmFLkKS/VgDMEUl
         Q75i+JQESE3DM8LWuxITtspQ3p21N4+vfWChtntVn4QSKyvQRAcfC3u3thC89rz/dy/1
         M7kQEXKMqO7J7KkPZtIzKUO531YKi+VSH36xvil+pI5ERPEd/ChyCbtUZ7f1WDejFksY
         27koVhMH0HGBuKfFCTy1VXsQDXM5wOVIaWIXAqCstyjs2uDHHzqlwNL4wC/QZEaLNaEW
         SPsxHQx2g/6hKLvxmXgtymfZc7JJqin0J13UZYQPsP7/Nq4ktMPUaBISXEM7dIBSvaCz
         RdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MM0iX4iVip2FjJIJrcyDJ5FE2gOlZHEuDKpuW9DbD8s=;
        b=Zu7HU58D8pevV8c/J7vm9O3IUnGZMX4wt4oH0Sdx6YMYSLJE9si9epnQfT2Y0jfJsi
         Vka1EatPOINl2WBToGn/UFMwmIEyG1zzDOGwa24kfso2KQWmP9zcyd8vZKoISbAxHGR/
         V+VjWlFU66jsqMew6WrpkveARW9tyAXhYyKrhSn7qmA3H4JzgJgxcF+f8WyqV4eZWgSw
         /ygnwvfLffgpl/HdNRfzEtcWwRpKdb8BBMVCzjNbrWGxHrCij515dx9bELIvXqPq/s6k
         aoJjU6q3qMlkli8YoDBIZ84QaSmKQfEcmodWb1VImLYg2Il5OIT81ZcbRSolbQ63XSME
         A03A==
X-Gm-Message-State: AOAM532EnDTGtTA0TTXsm+gPSzH+De+lkpuINolm1C5MFhpZySbWnmGC
        UG6LiD+Gy+7/7LPnT3ShGLWbzUF2qgjULIcc0P0=
X-Google-Smtp-Source: ABdhPJw5jETX8SV7GWCDJ36tErqbJZrIAzVDXc8xuX8mqV/CslmT4/s0mWd6o2daSu+WeB1/CZ3AxGkh0ANNS6hCB2I=
X-Received: by 2002:a17:90a:9f8c:: with SMTP id o12mr10808870pjp.215.1616383420664;
 Sun, 21 Mar 2021 20:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
 <20210317022219.24934-5-xiyou.wangcong@gmail.com> <605561cbb8e08_1ca40208ad@john-XPS-13-9370.notmuch>
In-Reply-To: <605561cbb8e08_1ca40208ad@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 21 Mar 2021 20:23:29 -0700
Message-ID: <CAM_iQpW-t3vd=mYtvpeKsfwNmObhythL9S46o6Ot-dQDQM4F4w@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 04/11] skmsg: avoid lock_sock() in sk_psock_backlog()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 7:45 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > We do not have to lock the sock to avoid losing sk_socket,
> > instead we can purge all the ingress queues when we close
> > the socket. Sending or receiving packets after orphaning
> > socket makes no sense.
> >
> > We do purge these queues when psock refcnt reaches zero but
> > here we want to purge them explicitly in sock_map_close().
> > There are also some nasty race conditions on testing bit
> > SK_PSOCK_TX_ENABLED and queuing/canceling the psock work,
> > we can expand psock->ingress_lock a bit to protect them too.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/skmsg.h |  1 +
> >  net/core/skmsg.c      | 50 +++++++++++++++++++++++++++++++------------
> >  net/core/sock_map.c   |  1 +
> >  3 files changed, 38 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index f2d45a73b2b2..0f5e663f6c7f 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
> >  }
>
> Overall looks good, comment/question below.
>
> >
> >  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> >  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 305dddc51857..d0a227b0f672 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -497,7 +497,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
> >       if (!ingress) {
> >               if (!sock_writeable(psock->sk))
> >                       return -EAGAIN;
> > -             return skb_send_sock_locked(psock->sk, skb, off, len);
> > +             return skb_send_sock(psock->sk, skb, off, len);
> >       }
> >       return sk_psock_skb_ingress(psock, skb);
> >  }
> > @@ -511,8 +511,6 @@ static void sk_psock_backlog(struct work_struct *work)
> >       u32 len, off;
> >       int ret;
> >
> > -     /* Lock sock to avoid losing sk_socket during loop. */
> > -     lock_sock(psock->sk);
> >       if (state->skb) {
> >               skb = state->skb;
> >               len = state->len;
> > @@ -529,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
> >               skb_bpf_redirect_clear(skb);
> >               do {
> >                       ret = -EIO;
> > -                     if (likely(psock->sk->sk_socket))
> > +                     if (!sock_flag(psock->sk, SOCK_DEAD))
> >                               ret = sk_psock_handle_skb(psock, skb, off,
> >                                                         len, ingress);
> >                       if (ret <= 0) {
> > @@ -537,13 +535,13 @@ static void sk_psock_backlog(struct work_struct *work)
> >                                       state->skb = skb;
> >                                       state->len = len;
> >                                       state->off = off;
> > -                                     goto end;
> > +                                     return;
>
> Unrelated to your series I'll add it to my queue of fixes, but I think we
> leak state->skb on teardown.

Ok. Please target all bug fixes to -net.

>
> >                               }
> >                               /* Hard errors break pipe and stop xmit. */
> >                               sk_psock_report_error(psock, ret ? -ret : EPIPE);
> >                               sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> >                               kfree_skb(skb);
> > -                             goto end;
> > +                             return;
> >                       }
> >                       off += ret;
> >                       len -= ret;
> > @@ -552,8 +550,6 @@ static void sk_psock_backlog(struct work_struct *work)
> >               if (!ingress)
> >                       kfree_skb(skb);
> >       }
> > -end:
> > -     release_sock(psock->sk);
> >  }
> >
> >  struct sk_psock *sk_psock_init(struct sock *sk, int node)
> > @@ -631,7 +627,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
> >       }
> >  }
> >
> > -static void sk_psock_zap_ingress(struct sk_psock *psock)
> > +static void __sk_psock_zap_ingress(struct sk_psock *psock)
> >  {
> >       struct sk_buff *skb;
> >
> > @@ -639,8 +635,13 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
> >               skb_bpf_redirect_clear(skb);
> >               kfree_skb(skb);
> >       }
> > -     spin_lock_bh(&psock->ingress_lock);
> >       __sk_psock_purge_ingress_msg(psock);
> > +}
> > +
> > +static void sk_psock_zap_ingress(struct sk_psock *psock)
> > +{
> > +     spin_lock_bh(&psock->ingress_lock);
> > +     __sk_psock_zap_ingress(psock);
> >       spin_unlock_bh(&psock->ingress_lock);
>
> I'm wondering about callers of sk_psock_zap_ingress() and why the lock is
> needed here. We have two callers
>
> sk_psock_destroy_deferred(), is deferred after an RCU grace period and after
> cancel_work_sync() so there should be no users to into the skb queue. If there
> are we  have other problems I think.

Right, I think sk_psock_zap_ingress() can be completely removed here
as it is already called in sk_psock_drop() (as below).

>
> sk_psock_drop() is the other. It is called when the refcnt is zero and does
> a sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED). Should it just wrap
> up the clear_state and sk_psock_zap_ingress similar to other cases so it
> doesn't have to deal with the case where enqueue happens after
> sk_psock_zap_ingress.
>
> Something like this would be clearer?

Yes.

>
> void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
> {
>         sk_psock_stop()
>         write_lock_bh(&sk->sk_callback_lock);
>         sk_psock_restore_proto(sk, psock);
>         rcu_assign_sk_user_data(sk, NULL);
>         if (psock->progs.stream_parser)
>                 sk_psock_stop_strp(sk, psock);
>         else if (psock->progs.stream_verdict)
>                 sk_psock_stop_verdict(sk, psock);
>         write_unlock_bh(&sk->sk_callback_lock);
>         call_rcu(&psock->rcu, sk_psock_destroy);
> }
> EXPORT_SYMBOL_GPL(sk_psock_drop)
>
> Then sk_psock_zap_ingress, as coded above, is not really needed anywhere and
> we just use the lockless variant, __sk_psock_zap_ingress(). WDYT, to I miss
> something.

This makes sense to me too.

Thanks!
