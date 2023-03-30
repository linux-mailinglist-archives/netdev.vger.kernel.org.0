Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC29F6D0391
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjC3LlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 07:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjC3LlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 07:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC79EF3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36ZIwlsw+5Y90FEr8sGK1zWjPDSJdgJGtnjKeI+utqQ=;
        b=HAZJQhGNrvItrnBJAeRS6TCHrsxsCdDYrKighPMRAQ/JOAnOePIz6gSDMEdAtQ4klxwxJO
        ZrCvuSB4WSMwIMFXOIt3XZEGdXDMN1LmP33KkBexWX+i/gcC7Hy0BIjem8pqqf3JsYFqSi
        bZUFv4VDnP5qeqMrUW8j8A5P0ZUoCiY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-6N3YCZ-GOH6vvdfKfUmk_Q-1; Thu, 30 Mar 2023 07:39:30 -0400
X-MC-Unique: 6N3YCZ-GOH6vvdfKfUmk_Q-1
Received: by mail-qt1-f197.google.com with SMTP id x5-20020a05622a000500b003e259c363f9so12211890qtw.22
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680176370; x=1682768370;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36ZIwlsw+5Y90FEr8sGK1zWjPDSJdgJGtnjKeI+utqQ=;
        b=2sPPgYXUkZA3qv2GE2PyC0UAtiPmPQO7J2rj4PmTnvpNT7SIBJK+7mehM+XwSrUfn+
         iMplX8rOMIrI7RiM7xadtr8gM1VAqfNH5M3wZIJOrq75lBrxd4m7djnO/1ZQHIKYdTlr
         Y/0u55ZsMrAAa9p+FkGZPOqQr7HIFIl0t2YBQibm0Cyk4hLIVE12YFe/8OpA5D6fnHIw
         X2SKbk+UxXkCWD4r0hv5+a65bCdtFQWO3JOC64o7oIIK734hJssxL6Ip6nSAmEzJfVBc
         dHZqnu/duPSoiHhRdFskqXAP+Agua8ARZd+UwT6NoyGX+h1sM15iT6scdATbGgO/ZACn
         pg6w==
X-Gm-Message-State: AAQBX9foPI2GfQ71tji5/PffSP9i9+H7eY1Kihjq6kGZxSofnRcd71TQ
        nlL7yFwLH2n7XE2nULghN15oMGFgvkQnkZUVnKPNO7fO5pVa7cgWAjEYaVf4WhxIvcLjaJq3P3b
        QUUVcP9GaCsW5ePsSekGXpHh4
X-Received: by 2002:a05:6214:300f:b0:5da:b965:1efd with SMTP id ke15-20020a056214300f00b005dab9651efdmr35477090qvb.2.1680176370283;
        Thu, 30 Mar 2023 04:39:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZmGptOkp30WhTcOwF33kTdyjqpRsFpu1dOLOzU8EfdghEEs2kEt0UNqlm2OoForlFGxiNEcA==
X-Received: by 2002:a05:6214:300f:b0:5da:b965:1efd with SMTP id ke15-20020a056214300f00b005dab9651efdmr35477074qvb.2.1680176370025;
        Thu, 30 Mar 2023 04:39:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id w16-20020a0cef90000000b005dd8b9345cfsm5328762qvr.103.2023.03.30.04.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 04:39:29 -0700 (PDT)
Message-ID: <bbda81c4ca4d9d3ee458f4f2e1d58b2c3326732f.camel@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jason Xing <kerneljasonxing@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Date:   Thu, 30 Mar 2023 13:39:27 +0200
In-Reply-To: <CAL+tcoAEZ3nGfk6OVMY3O0W_c37cUMw94ugUNJsRaFuQz8_TbA@mail.gmail.com>
References: <20230328235021.1048163-1-edumazet@google.com>
         <20230328235021.1048163-5-edumazet@google.com>
         <CAL+tcoAEZ3nGfk6OVMY3O0W_c37cUMw94ugUNJsRaFuQz8_TbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-30 at 17:50 +0800, Jason Xing wrote:
> On Wed, Mar 29, 2023 at 7:53=E2=80=AFAM Eric Dumazet <edumazet@google.com=
> wrote:
> >=20
> > ____napi_schedule() adds a napi into current cpu softnet_data poll_list=
,
> > then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it=
.
> >=20
> > Idea of this patch is to not raise NET_RX_SOFTIRQ when being called ind=
irectly
> > from net_rx_action(), because we can process poll_list from this point,
> > without going to full softirq loop.
> >=20
> > This needs a change in net_rx_action() to make sure we restart
> > its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> > being raised.
> >=20
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/core/dev.c | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb=
05842dab023f65dc3 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct soft=
net_data *sd,
> >         }
> >=20
> >         list_add_tail(&napi->poll_list, &sd->poll_list);
> > -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > +       /* If not called from net_rx_action()
> > +        * we have to raise NET_RX_SOFTIRQ.
> > +        */
> > +       if (!sd->in_net_rx_action)
> > +               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >  }
> >=20
> >  #ifdef CONFIG_RPS
> > @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >         LIST_HEAD(list);
> >         LIST_HEAD(repoll);
> >=20
> > +start:
> >         sd->in_net_rx_action =3D true;
> >         local_irq_disable();
> >         list_splice_init(&sd->poll_list, &list);
> > @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struc=
t softirq_action *h)
> >                 skb_defer_free_flush(sd);
> >=20
> >                 if (list_empty(&list)) {
> > -                       sd->in_net_rx_action =3D false;
> > -                       if (!sd_has_rps_ipi_waiting(sd) && list_empty(&=
repoll))
> > -                               goto end;
> > +                       if (list_empty(&repoll)) {
> > +                               sd->in_net_rx_action =3D false;
> > +                               barrier();
> > +                               /* We need to check if ____napi_schedul=
e()
> > +                                * had refilled poll_list while
> > +                                * sd->in_net_rx_action was true.
> > +                                */
> > +                               if (!list_empty(&sd->poll_list))
> > +                                       goto start;
>=20
> I noticed that since we decide to go back and restart this loop, it
> would be better to check the time_limit. More than that,
> skb_defer_free_flush() can consume some time which is supposed to take
> into account.

Note that we can have a __napi_schedule() invocation with sd-
>in_net_rx_action only after executing the napi_poll() call below and
thus after the related time check (that is - after performing at least
one full iteration of the main for(;;) loop).

I don't think another check right here is needed.

Thanks,

Paolo

