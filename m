Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9951CF5D1A
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 03:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKICwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 21:52:00 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35910 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfKICv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 21:51:59 -0500
Received: by mail-il1-f196.google.com with SMTP id s75so6895358ilc.3
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 18:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9Pm1A88p06AUxA+q62MVcruzAQFMayciiO1u1hTOUY=;
        b=kYZRyYalXGmKd2IdrWTXyA20/lBHRdARI1cv9BtXPmbRmqnVadPD2HcFVim7g8R/qS
         0w9tk74zn2OHUI04aoN9lXHHPITkp7zwb2greou7TY7GKC8mlY8bihR/bq4swdiROKWe
         O6mOPopfcXWSKm/wmRd3lHxgo+quDMcsDX0obtD3+hUbUNtHZw7wh5aEIAbgiYqOamyz
         UVte9iDcgd1yLj0eLFyyhPZbR2fNSkklqp4WVlqqb7ROyPBd86/qtnN1CvQ+SVwty1+7
         74uCbncGxP/wGs6+OlWhFMLTlBeLOfqLMeiMjaHVZT/MX31t0/dVykade+42rFKYpaeo
         c63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9Pm1A88p06AUxA+q62MVcruzAQFMayciiO1u1hTOUY=;
        b=F9OFus/VRAC7+2ZrrTjSfq1AyUvKC8B7XDceyqSlPX43vBYi1DxJPyf/DYj2nSotSd
         IX8w9uW9Vg7ATtipDSXKD+k04LLruIwEFhSuyOHFVfG/f10ql3U0MbbxsIJSNPJn8V5q
         TcYNALJhcBK13XDrY6brbPiIzoyOfj+8FmuP2ElkczV/TvYlTKmzKaxBiVZkOoY3a0eK
         pZ6hPB9WRQakhDyvmbqRt/Fr2IhTsq4mqKFDX3g/R1i2IiUvWCCeOxVYYthcY2bg9PoU
         0AdzOHAXnWp+bj+K5OcTpxxuCOMjZaGoeDB4XL+mvA388rShmo6a3qDuAA8qFzPA2AW6
         S3QQ==
X-Gm-Message-State: APjAAAVfZE+mBFiSxlP74kRDbsaRQOKXFJtWhF4dgp2XRGifziV2B010
        RNRbU1/dBvDPVtbHFERVv0lRhDg0SUbC7/06r/ELqw==
X-Google-Smtp-Source: APXvYqzwwA3TltroQmqHfxip74LV/V8FQqcvDFL6GR25rHWYg/eJaftC21mbdFMyL21YDfFKGKtsHfkKL3x7f4D1f6M=
X-Received: by 2002:a92:99cb:: with SMTP id t72mr14904655ilk.218.1573267918020;
 Fri, 08 Nov 2019 18:51:58 -0800 (PST)
MIME-Version: 1.0
References: <20191108034701.77736-1-edumazet@google.com> <20191109013342.d7notm6wmllgydsf@gondor.apana.org.au>
In-Reply-To: <20191109013342.d7notm6wmllgydsf@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Nov 2019 18:51:46 -0800
Message-ID: <CANn89iKjMD9r0+8CGdAOFpm3jPYtUsymXaDeG2US2WRzFicueg@mail.gmail.com>
Subject: Re: [PATCH net-next] xfrm: add missing rcu verbs to fix data-race
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 5:33 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Nov 07, 2019 at 07:47:01PM -0800, Eric Dumazet wrote:
> > KCSAN reported a data-race in xfrm_lookup_with_ifid() and
> > xfrm_sk_free_policy() [1]
>
> I'm very uncomfortable with these warnings being enabled in KASAN
> unless there is a way to opt out of them without adding unnecessary
> READ_ONCE/WRITE_ONCE tags.
>
> All they do is create patches such as this one that simply adds
> these tags without resolving the underlying issues (if there are
> any).
>
> > diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> > index aa08a7a5f6ac5836524dd34115cd57e2675e574d..8884575ae2135b739a2c316bf8a92b56d6cc807c 100644
> > --- a/include/net/xfrm.h
> > +++ b/include/net/xfrm.h
> > @@ -1093,7 +1093,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
> >       struct net *net = dev_net(skb->dev);
> >       int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
> >
> > -     if (sk && sk->sk_policy[XFRM_POLICY_IN])
> > +     if (sk && rcu_access_pointer(sk->sk_policy[XFRM_POLICY_IN]))
> >               return __xfrm_policy_check(sk, ndir, skb, family);
>
> This is simply an optimisation and we don't care if we get it
> wrong due to the lack of READ_ONCE/WRITE_ONCE.  Even with the
> READ_ONCE tag, there is nothing stopping a policy from being
> added after the test returns false, or all policies from being
> deleted after the test returns true.
>
> IOW this is simply unnecessary.

How do you suggest to silence the KCSAN warnings then ?

>
> > @@ -1171,7 +1171,8 @@ static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
> >  {
> >       sk->sk_policy[0] = NULL;
> >       sk->sk_policy[1] = NULL;
> > -     if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
> > +     if (unlikely(rcu_access_pointer(osk->sk_policy[0]) ||
> > +                  rcu_access_pointer(osk->sk_policy[1])))
> >               return __xfrm_sk_clone_policy(sk, osk);
> >       return 0;
>
> These on the other hand are done under socket lock.  IOW they
> are completely synchronised with respect to the write side which
> is also under socket lock so no tagging is necessary.
>
> Incidentally rcu_access_pointer is now practically the same as
> rcu_dereference because the smp_read_barrier_depends has been
> moved over to READ_ONCE.  In fact there is no performance difference
> between rcu_dereference and rcu_dereference_raw either.
>
> I think we should either remove the smp_barrier_depends from
> rcu_access_pointer, or just get rid of rcu_access_pointer completely.
>
> > @@ -1185,12 +1186,12 @@ static inline void xfrm_sk_free_policy(struct sock *sk)
> >       pol = rcu_dereference_protected(sk->sk_policy[0], 1);
> >       if (unlikely(pol != NULL)) {
> >               xfrm_policy_delete(pol, XFRM_POLICY_MAX);
> > -             sk->sk_policy[0] = NULL;
> > +             rcu_assign_pointer(sk->sk_policy[0], NULL);
> >       }
> >       pol = rcu_dereference_protected(sk->sk_policy[1], 1);
> >       if (unlikely(pol != NULL)) {
> >               xfrm_policy_delete(pol, XFRM_POLICY_MAX+1);
> > -             sk->sk_policy[1] = NULL;
> > +             rcu_assign_pointer(sk->sk_policy[1], NULL);
>
> These should use RCU_INIT_POINTER.

This does not matter anymore.
Please double check rcu_assign_pointer(), it handles the NULL case.

commit 3a37f7275cda5ad25c1fe9be8f20c76c60d175fa
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Sun May 1 18:46:54 2016 -0700

    rcu: No ordering for rcu_assign_pointer() of NULL

    This commit does a compile-time check for rcu_assign_pointer() of NULL,
    and uses WRITE_ONCE() rather than smp_store_release() in that case.

    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


>
> > diff --git a/net/smc/smc.h b/net/smc/smc.h
> > index be11ba41190fb58be3ce9e8ab1a9ea4f8aa6a05b..4324dd39de99ba5967e1325746a2f5eff4baf2e7 100644
> > --- a/net/smc/smc.h
> > +++ b/net/smc/smc.h
> > @@ -253,8 +253,8 @@ static inline u32 ntoh24(u8 *net)
> >  #ifdef CONFIG_XFRM
> >  static inline bool using_ipsec(struct smc_sock *smc)
> >  {
> > -     return (smc->clcsock->sk->sk_policy[0] ||
> > -             smc->clcsock->sk->sk_policy[1]) ? true : false;
> > +     return (rcu_access_pointer(smc->clcsock->sk->sk_policy[0]) ||
> > +             rcu_access_pointer(smc->clcsock->sk->sk_policy[1])) ? true : false;
> >  }
> >  #else
> >  static inline bool using_ipsec(struct smc_sock *smc)
>
> Now this could actually be a real bug because it doesn't appear
> to be an optimisation and it doesn't seem to be holding the socket
> lock either.
>
> Again this shows that we shouldn't just add READ_ONCE/WRITE_ONCE
> tags because they might be papering over real bugs and help them
> hide better because people will automatically assume that using
> READ_ONCE/WRITE_ONCE means that the code is *safe*.
>

Hmm, I will leave to you the resolution of this bug.

Thanks.
