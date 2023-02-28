Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076426A5E5D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 18:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjB1RmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB1RmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 12:42:16 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D52F795
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 09:42:15 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id y14so4720465ilv.4
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 09:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2RF7Er4Vgm9ZLcT5UKklrdKtECXNpMONQs1zi/hjb0=;
        b=MS+Ipb/ymMD5LE8rqAY4AsDIpa/0BZq4UjSPFaN2xxUxG881aIKLA2ol2M0xw2lCHh
         uibW9IyfOiHEkwiY+pkWjdo/wWIJ5tvG07CdfeHgaoBMfK8bP1w9BYDQKdMUiScHiQKB
         meLxiP8/5uFC7Pkanvs17e0W5U38qjfNG1Wn7zUL/ZWh5Gb9HQcsO3GYhs62GmLDx6sb
         bYbrCMFRs2cJlkPEjyG3GCRRBoJWv048gNhUpmQVJinJqbAte8cGYZ8QMx3bF5qFfIsH
         +Od422lhbyTXuXjKOUC/a7Fncsamopj6F9zmTWUqZoFln5LTsr5wUU1Z2m/DpOEM2DUN
         l6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2RF7Er4Vgm9ZLcT5UKklrdKtECXNpMONQs1zi/hjb0=;
        b=RcXbmD1vmr0uKE/F5yP+ef3pmBbPc9tscPlOj+PG+sK6u5hkYHP/qlSQw7ejZuJUZz
         i95A4o0m6Ob7onY5Kypr0poJ/KOiw6YW172lqnwJB91SD5evidZjNze0retl2ooGYz9p
         Jfb78XnFsTz/+2oNatx2paZUyuGgo1a1iTK0EO/ylca6BMQ7RUVNVBrw5WV/ASUMXeVm
         Mxk5PucB9bWrnLu5bEsWgY0di1+XKXVjRW9AgAMm9hmy1GSsLNPoxbeArqwXIHaULj5y
         LT4MTbdu7m8n9bIIXAHn1qLT0maPYdLVoKnZxkzHuLu9BE45FwYU065IUri/o/0OhZ/x
         c4XA==
X-Gm-Message-State: AO0yUKUMooN+LDiYBGU9Qbv5LWNoLmeBHmJXAWJni0YxJo2Cc0fEe6XF
        mSNWA4PI8qjC0oCOKuVnsd/1hEOaDEaiETJ86kU+PA==
X-Google-Smtp-Source: AK7set8MaTa9WbyFsF3W8clgsL1mIwo01ge9KV8gt4jK/4IfwreajR4GZu/ANOpWvJGQXTmZhWAT8iW9YgvqBNAavZ8=
X-Received: by 2002:a92:300c:0:b0:317:b01:229 with SMTP id x12-20020a92300c000000b003170b010229mr1770244ile.2.1677606135180;
 Tue, 28 Feb 2023 09:42:15 -0800 (PST)
MIME-Version: 1.0
References: <20230224184606.7101-1-fw@strlen.de> <CANn89iJ+7X8kLjR2YrGbT64zGSu_XQfT_T5+WPQfheDmgQrf2A@mail.gmail.com>
In-Reply-To: <CANn89iJ+7X8kLjR2YrGbT64zGSu_XQfT_T5+WPQfheDmgQrf2A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 18:42:03 +0100
Message-ID: <CANn89i+WYy+Q1i1e1vrQmPzH-eDEVHJn29xgmsXJ8uMidP9CqQ@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
To:     Florian Westphal <fw@strlen.de>, Brian Vazquez <brianvv@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shakeelb@google.com, soheil@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 5:44=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Fri, Feb 24, 2023 at 7:49=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > There is a noticeable tcp performance regression (loopback or cross-net=
ns),
> > seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
> >
> > With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
> > memory pressure happen much more often. For TCP indirect calls are
> > used.
> >
> > We can't remove the if-set-return short-circuit check in
> > tcp_enter_memory_pressure because there are callers other than
> > sk_enter_memory_pressure.  Doing a check in the sk wrapper too
> > reduces the indirect calls enough to recover some performance.
> >
> > Before,
> > 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver
> >
> > After:
> > 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver
> >

BTW I was curious why Google was not seeing this, and it appears Brian Vasq=
uez
forgot to upstream this change...

commit 5ea2f21d6c1078d2c563cb455ad5877b4ada94e1
Author: Brian Vazquez <brianvv@google.com>
Date:   Thu Mar 3 19:09:49 2022 -0800

    PRODKERNEL: net-directcall: annotate tcp_leave_memory_pressure and
    tcp_getsockopt

    Switch to upstream infra to make rebase easier

    Tested: built and booted on lab machine

    Upstream-Plan: 150254871
    Effort: net-directcall

diff --git a/net/core/sock.c b/net/core/sock.c
index 05032b399c873984e5297898d647905ca9f21f2e..54cb989dc162f3982380ac12cf5=
a150214e209a2
100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2647,10 +2647,13 @@ static void sk_enter_memory_pressure(struct sock *s=
k)
        sk->sk_prot->enter_memory_pressure(sk);
 }

+INDIRECT_CALLABLE_DECLARE(void tcp_leave_memory_pressure(struct sock *sk))=
;
+
 static void sk_leave_memory_pressure(struct sock *sk)
 {
        if (sk->sk_prot->leave_memory_pressure) {
-               sk->sk_prot->leave_memory_pressure(sk);
+               INDIRECT_CALL_1(sk->sk_prot->leave_memory_pressure,
+                               tcp_leave_memory_pressure, sk);
        } else {
                unsigned long *memory_pressure =3D sk->sk_prot->memory_pres=
sure;

@@ -3439,6 +3442,10 @@ int sock_recv_errqueue(struct sock *sk, struct
msghdr *msg, int len,
 }
 EXPORT_SYMBOL(sock_recv_errqueue);

+INDIRECT_CALLABLE_DECLARE(int tcp_getsockopt(struct sock *sk, int level,
+                                            int optname, char __user *optv=
al,
+                                            int __user *optlen));
+
 /*
  *     Get a socket option on an socket.
  *
@@ -3451,7 +3458,8 @@ int sock_common_getsockopt(struct socket *sock,
int level, int optname,
 {
        struct sock *sk =3D sock->sk;

-       return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+       return INDIRECT_CALL_1(sk->sk_prot->getsockopt, tcp_getsockopt,
+                               sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
