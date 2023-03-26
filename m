Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED146C924F
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 06:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjCZEEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 00:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCZEEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 00:04:47 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7ECB753;
        Sat, 25 Mar 2023 21:04:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y4so23141953edo.2;
        Sat, 25 Mar 2023 21:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679803484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrdZ1ENXUKsXYUhHxuCniJKJgXSUIk7kPQqo1dyQuWs=;
        b=KNDd7RM/hDhy33mGV1uyS5zhoCuORpXGzSE/1oCf/10gCPYitIN2q27foOYWquYZKR
         QtBuTMxU+XAedfYXNS23h/78kxBvH0p9y0296L2XDzzV24aCtNq9hDTiKVuWO6xVIutX
         V59GGavPWV6engQmsOZBuNlsgsQ93qoqIIxyPoerNq3tXv+s3fo0HSE7IcvBoD3SRjQA
         ahdyVMZr+zj1j5hp3MjqQxSIIDty+eiPIPl4WhZMpcmeHKSRm5kdWhvxWHAQaVVg8DAx
         OtFCzjddiJYJbWdeSy7aox9J03FvjzHQXFtEsJUsywNZrsWaP6Bc/1iQ+EnTnYB4P5nM
         X86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679803484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vrdZ1ENXUKsXYUhHxuCniJKJgXSUIk7kPQqo1dyQuWs=;
        b=k55pctr5dyfsfqUbN3R7n94HpGRVeHGfPYHyALWPBmMV4Hdd1Ix6Or4iccRctnCA71
         Fo7P7WH0FND7TaUhq9+XJlUae0bUeDxYfGJ4Yb7rezED4VNB5Zw1veeKgYi4WXq0ZE68
         gat8HfMgajwFd3D8ThjmKd4K4HmU7Lxcy7TxwMdTkgWTdIJh6DypisdXtAi9NGZBfXp7
         Dp8rJedIGF4xvsh/znZYRMIrWQMAD65/n7kXRsjVPS0N0VDAujuJ1cCpL+j4fCaT7JZD
         UTK+l3PziarQxH9Uieg8v2PWkhE4gxeYRE26dHhqX348+5CCzyEWI1l6+Rqj+YXmWFlw
         6qVQ==
X-Gm-Message-State: AAQBX9elKmEHgWRhTaNiArNpByPc908qdD3A3fjEWwVd63hjAtFc8vPl
        qp3J/edrdPFB4Kle0PyjOYEeWrFtpMl+ge8KrSPpNTrExj1P7g==
X-Google-Smtp-Source: AKy350YIdykA7MmjNqh28CTHMCWFT0k0YpmYp6eHxB6PuluUMssedg3N+rY0ihwLxHsFPqP/His+2HA75oQComKzSTI=
X-Received: by 2002:a17:906:891:b0:8b1:7569:b526 with SMTP id
 n17-20020a170906089100b008b17569b526mr3338697eje.11.1679803483782; Sat, 25
 Mar 2023 21:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com> <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
In-Reply-To: <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 26 Mar 2023 12:04:07 +0800
Message-ID: <CAL+tcoDVCywXXt0Whnx+o0PcULmdms0osJf0qUb0HKvVwuE6oQ@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:57=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Since we decide to put the skb into a backlog queue of another
> > cpu, we should not raise the softirq for the current cpu. When
> > to raise a softirq is based on whether we have more data left to
> > process later. As to the current cpu, there is no indication of
> > more data enqueued, so we do not need this action. After enqueuing
> > to another cpu, net_rx_action() function will call ipi and then
> > another cpu will raise the softirq as expected.
> >
> > Also, raising more softirqs which set the corresponding bit field
> > can make the IRQ mechanism think we probably need to start ksoftirqd
> > on the current cpu. Actually it shouldn't happen.
> >
> > Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/core/dev.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1518a366783b..bfaaa652f50c 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_data =
*sd)
> >         if (sd !=3D mysd) {
> >                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
> >                 mysd->rps_ipi_list =3D sd;
> > -
> > -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >                 return 1;
> >         }
> >  #endif /* CONFIG_RPS */
> > --
> > 2.37.3
> >
>
> This is not going to work in some cases. Please take a deeper look.
>
> I have to run, if you (or others) do not find the reason, I will give
> more details when I am done traveling.

I'm wondering whether we could use @mysd instead of @sd like this:

if (!__test_and_set_bit(NAPI_STATE_SCHED, &mysd->backlog.state))
    __raise_softirq_irqoff(NET_RX_SOFTIRQ);

I traced back to some historical changes and saw some relations with
this commit ("net: solve a NAPI race"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D39e6c8208d7b6fb9d2047850fb3327db567b564b

Thanks,
Jason
