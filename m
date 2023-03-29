Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3496CED45
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjC2PsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjC2PsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:48:09 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59343527A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:48:08 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id v5so5743632ilj.4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680104887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGG8hCPldEDckf8vbKJvs41CjDb5Mp+draGOiHbiKCs=;
        b=aJrFgaVTDFsgYXDS9AFsj7cFe9ZX5WnxsQafdk8y8C405aOxDF/toNKUbY3PNboC+m
         /Vr8VSOXl//1Wpm5HkN3JEmLjiEZYZVCM0f7RZJavbAqetu+jfVK2YOvsRg9VrWZYaD0
         aVXzPvR8fjAXOz4ENqbPyfmIi+ZCDAznLp0Ob/mSjqy/2NC3La1ILQVPaawDXP/5TWBH
         Xji5yRiBIfrOImxlZcJobnSnDA4x8feyo38yqn+Hxs2+Z34fV+YUU1fod2foaBwd1t97
         H2WE8BTwY8BrGXCVvL+BH4+F+WuqTL9QTO4T9GoDf5z/CZGXSUkkNzW8QA6t2Dg8VQlo
         gwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680104887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGG8hCPldEDckf8vbKJvs41CjDb5Mp+draGOiHbiKCs=;
        b=LAdViMkZ4G+oynti+cMyW+plK+6kr3Gr304YdaHkBsfj78PottO7senF/7rcndOi08
         XsJHeQzkiIQPIZl+RnZWVqGjJTrPO79FQzOjAIiwVUGFKDK+r2m2N5Kur5V2BFHq8s4E
         uXuB82gSMLcped74JCOMHoCvCKH7o6v3HVe4+IxXLyeGJhr72DT7vombNAhmEvCi9U1S
         M4bv5TfVcg2/SkfvxWFY3lGVzfhsQUU7L8zN+d9SpSbXPDv7WJcujIm6DBAGqxrxCYkG
         9WRYN0s1ymsCl/y6rHGcsGGjsDicTNN/ohNiByf964mN2fWUxnrsxCJIwaSR2ETvoumK
         QwYA==
X-Gm-Message-State: AAQBX9ceEqwGImF6Xy6jYj4y7SmhrKhoX4fMBq78mXVCv+nhsjVuuX1q
        CKsixkcABCiYcda2zoH4Qv6oOf0iXEJEB6m3TPp0uw==
X-Google-Smtp-Source: AKy350YQzofJeW4oxCuHsbA3tJDfb2WeRUr8kwy20ZlR6cM3r0AyvipmTH8cWwijzWIqgWQPX745icLpsTxGa9OGmfg=
X-Received: by 2002:a05:6e02:1bef:b0:322:fe4d:d60 with SMTP id
 y15-20020a056e021bef00b00322fe4d0d60mr10757052ilv.2.1680104887536; Wed, 29
 Mar 2023 08:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230328235021.1048163-5-edumazet@google.com>
 <fa860d02-0310-2666-1043-6909dc68ea01@huawei.com>
In-Reply-To: <fa860d02-0310-2666-1043-6909dc68ea01@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 Mar 2023 17:47:56 +0200
Message-ID: <CANn89iLmugenUSDAQT9ryHTG9tRuKUfYgc8OqPMQwVv-1-ajNg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 2:47=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/3/29 7:50, Eric Dumazet wrote:
> > ____napi_schedule() adds a napi into current cpu softnet_data poll_list=
,
> > then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it=
.
> >
> > Idea of this patch is to not raise NET_RX_SOFTIRQ when being called ind=
irectly
> > from net_rx_action(), because we can process poll_list from this point,
> > without going to full softirq loop.
> >
> > This needs a change in net_rx_action() to make sure we restart
> > its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> > being raised.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/core/dev.c | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb=
05842dab023f65dc3 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct soft=
net_data *sd,
> >       }
> >
> >       list_add_tail(&napi->poll_list, &sd->poll_list);
> > -     __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > +     /* If not called from net_rx_action()
> > +      * we have to raise NET_RX_SOFTIRQ.
> > +      */
> > +     if (!sd->in_net_rx_action)
>
> It seems sd->in_net_rx_action may be read/writen by different CPUs at the=
 same
> time, does it need something like READ_ONCE()/WRITE_ONCE() to access
> sd->in_net_rx_action?

You probably missed the 2nd patch, explaining the in_net_rx_action is
only read and written by the current (owning the percpu var) cpu.

Have you found a caller that is not providing to ____napi_schedule( sd
=3D this_cpu_ptr(&softnet_data)) ?



>
> > +             __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >  }
> >
> >  #ifdef CONFIG_RPS
> > @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >       LIST_HEAD(list);
> >       LIST_HEAD(repoll);
> >
> > +start:
> >       sd->in_net_rx_action =3D true;
> >       local_irq_disable();
> >       list_splice_init(&sd->poll_list, &list);
> > @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struc=
t softirq_action *h)
> >               skb_defer_free_flush(sd);
> >
> >               if (list_empty(&list)) {
> > -                     sd->in_net_rx_action =3D false;
> > -                     if (!sd_has_rps_ipi_waiting(sd) && list_empty(&re=
poll))
> > -                             goto end;
> > +                     if (list_empty(&repoll)) {
> > +                             sd->in_net_rx_action =3D false;
> > +                             barrier();
>
> Do we need a stronger barrier to prevent out-of-order execution
> from cpu?

We do not need more than barrier() to make sure local cpu wont move this
write after the following code.

It should not, even without the barrier(), because of the way
list_empty() is coded,
but a barrier() makes things a bit more explicit.

> Do we need a barrier between list_add_tail() and sd->in_net_rx_action
> checking in ____napi_schedule() to pair with the above barrier?

I do not think so.

While in ____napi_schedule(), sd->in_net_rx_action is stable
because we run with hardware IRQ masked.

Thanks.



>
> > +                             /* We need to check if ____napi_schedule(=
)
> > +                              * had refilled poll_list while
> > +                              * sd->in_net_rx_action was true.
> > +                              */
> > +                             if (!list_empty(&sd->poll_list))
> > +                                     goto start;
> > +                             if (!sd_has_rps_ipi_waiting(sd))
> > +                                     goto end;
> > +                     }
> >                       break;
> >               }
> >
> >
