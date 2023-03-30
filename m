Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1126D0032
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjC3Jwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjC3JwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:52:18 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEFD7689
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:51:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so74048222edb.13
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680169864; x=1682761864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wL38bwDRsIa+Wh5mhSJKZr0FsI2MsQTQUe6U4MAKlM=;
        b=M74HwXUmzSDK/m61PBugTHiJIipBttdonQiiQJPUUp9UmVCHT73JylH2FFbgoU1i1+
         QVwDMzHU4M7v3iDslBRxQZgv5yzcJa7eMTyIMp6BagAWiB/z1UwOeNUhisFU51Wc0RK4
         Qfk+BANxIuSX1hLAtCg6fVGvz6zZszOO2/mcuXbu6V3e7tPrJeBX3Q8+Vr2Idq+Bqajm
         pHM3TjmGs16q+BmSFVX6Ah6+rJLk3qvtjK4oNhZROCtlNn7P7FNGUoKNjFG6E55B5ELv
         kzXhp5m2wLRU7+BpsxZoecOAzqtshvEJ+SzKnJG9uqPHiqw3G7/ctkDgor/4++3CdOkf
         dJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680169864; x=1682761864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wL38bwDRsIa+Wh5mhSJKZr0FsI2MsQTQUe6U4MAKlM=;
        b=A6bghW6RK907TKvxl2lqlPWEzuCJ6m4NwFXsGbW+AUXxngx25kTneFCtb9knkvW9Yk
         gm9PlgaaB7bOVEjQC/jD6tQ51a+v8UYRUhQ9zqv98VEWqTjiaEDH+48tD6wWVyCOfXza
         n/a4pRvRkgAZDeIguA/J62n7HHAoLPukJ6S2rPb5Iuuq9P+M2vrj25LvQKpusvHvv6NX
         jklniGN649+3kYijOuZVld8gi/X3Ga4IEXGs/Av9mtCF8WPyY51VkjBLs/WgeXCq5Olp
         VZylms+L8PmT75aFO7b1VlifWgutOGsFPGOZ3AeNAoKanrHu9wmiTk4r1DbWIziNsxFt
         6U9w==
X-Gm-Message-State: AAQBX9f6S9JgM57HoZJVQfLrI3kvwBrL0agqQf8qdZNlNLj4xz//Zmrw
        8yrTHOxKFsllFBXaPmhswzMyLX59l2k4aI7ly4c=
X-Google-Smtp-Source: AKy350Y5zhWEOCB8viPS5q5iKT13NPfaDCtsmiHYv37GsZMUQocwOIGEpY67/sYDarXd9cZwgSREm47+fTbUiby764w=
X-Received: by 2002:a50:8acf:0:b0:502:3a4b:1f1a with SMTP id
 k15-20020a508acf000000b005023a4b1f1amr8542296edk.4.1680169864166; Thu, 30 Mar
 2023 02:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230328235021.1048163-5-edumazet@google.com>
In-Reply-To: <20230328235021.1048163-5-edumazet@google.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 30 Mar 2023 17:50:28 +0800
Message-ID: <CAL+tcoAEZ3nGfk6OVMY3O0W_c37cUMw94ugUNJsRaFuQz8_TbA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Wed, Mar 29, 2023 at 7:53=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> ____napi_schedule() adds a napi into current cpu softnet_data poll_list,
> then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it.
>
> Idea of this patch is to not raise NET_RX_SOFTIRQ when being called indir=
ectly
> from net_rx_action(), because we can process poll_list from this point,
> without going to full softirq loop.
>
> This needs a change in net_rx_action() to make sure we restart
> its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> being raised.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Xing <kernelxing@tencent.com>
> ---
>  net/core/dev.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb05=
842dab023f65dc3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct softne=
t_data *sd,
>         }
>
>         list_add_tail(&napi->poll_list, &sd->poll_list);
> -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> +       /* If not called from net_rx_action()
> +        * we have to raise NET_RX_SOFTIRQ.
> +        */
> +       if (!sd->in_net_rx_action)
> +               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  }
>
>  #ifdef CONFIG_RPS
> @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct s=
oftirq_action *h)
>         LIST_HEAD(list);
>         LIST_HEAD(repoll);
>
> +start:
>         sd->in_net_rx_action =3D true;
>         local_irq_disable();
>         list_splice_init(&sd->poll_list, &list);
> @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struct =
softirq_action *h)
>                 skb_defer_free_flush(sd);
>
>                 if (list_empty(&list)) {
> -                       sd->in_net_rx_action =3D false;
> -                       if (!sd_has_rps_ipi_waiting(sd) && list_empty(&re=
poll))
> -                               goto end;
> +                       if (list_empty(&repoll)) {
> +                               sd->in_net_rx_action =3D false;
> +                               barrier();
> +                               /* We need to check if ____napi_schedule(=
)
> +                                * had refilled poll_list while
> +                                * sd->in_net_rx_action was true.
> +                                */
> +                               if (!list_empty(&sd->poll_list))
> +                                       goto start;

I noticed that since we decide to go back and restart this loop, it
would be better to check the time_limit. More than that,
skb_defer_free_flush() can consume some time which is supposed to take
into account.

Just for your consideration.

> +                               if (!sd_has_rps_ipi_waiting(sd))
> +                                       goto end;
> +                       }
>                         break;
>                 }
>
> --
> 2.40.0.348.gf938b09366-goog
>
