Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C449F5BF405
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiIUCyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIUCyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:54:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E3E7E316
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663728851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1V6yBzlgMB32SZRmpYNwicG4mGXms38NVfEObV00gp8=;
        b=HGam/d6UrYOgxt1R5YsAcl7Jhzxx3PT4COg5zzBksDsASTEztJED3PLQIpQhpl5KxrQQtp
        QHUSFCEvw0X9Z7MoUwzWq1MAApV0A6hNb+cT7EAfCr9jtvU657wXJuUU1JkfH7FWbAXC4m
        kOjrG/31klVbwqZGtQFT8mPAu8bW1eM=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-8WyRULWMNjyHeBJJyiz9PA-1; Tue, 20 Sep 2022 22:54:08 -0400
X-MC-Unique: 8WyRULWMNjyHeBJJyiz9PA-1
Received: by mail-oo1-f69.google.com with SMTP id w5-20020a4a3545000000b00475e491ac1eso2111461oog.7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1V6yBzlgMB32SZRmpYNwicG4mGXms38NVfEObV00gp8=;
        b=Pn0Qxujhsi/eUf4B0sbeNsuIJ+4lZzpqw1fKf8LE3TM/MwCE4wXGr1fSDwmfh45ZFk
         fHepkIfNbOgJsgsmc/rqylcd2Sa5jyVuS6duDps7b/YWgZd4/J2vaCIQc3tzojcS1ntw
         hIOSyK817GT708V/Yb1/quTXJzW5kOTqpNeBqSKdN8px4BirBxLOrTZxNTxJT4baftJS
         v88Kct1Vx5Xh3KGLuf9TFi6BDX+WZFGiVjPWb8VyRIpt3IJL06db1HUKXB06gJWZY0mF
         yrY4deNXbIklHkVEzSfipPOoMeLoKZk15UHt38NP+JUTEsjmqL2nMKlXLrHafC09bX6u
         /Tiw==
X-Gm-Message-State: ACrzQf0Yc+EmjgsOcOB3Tu+L8MHEPXwX618SuJ542UbnzzWE95GVVYp1
        7quUajWwMPzTJLTIpelsYm0H1NKBvEIZFPOhvsq0WFfsjCdQ/iD/HzlblRAfrlu3++njVoSHdzN
        9OCrQmiDnxMazxZa/BL1e3QVaqeeD/j7P
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr2904939oib.35.1663728847636;
        Tue, 20 Sep 2022 19:54:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7kcpp5sqUwQs4+ohwoyVXLdxS5rtQfXfzM+vHftyyGyC+qcKbFlsLkUFY9+ZnP3AuMs/ss6dBJWtFwEF9If6o=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr2904934oib.35.1663728847446; Tue, 20
 Sep 2022 19:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220920083621.18219c3d@hermes.local> <20220920194825.31820-1-prohr@google.com>
In-Reply-To: <20220920194825.31820-1-prohr@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Sep 2022 10:53:56 +0800
Message-ID: <CACGkMEvmH5qHHnFXzUUG1CwqDEfQMvsDDzausbAFsX226U0gPg@mail.gmail.com>
Subject: Re: [PATCH v2] tun: support not enabling carrier in TUNSETIFF
To:     Patrick Rohr <prohr@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 3:48 AM Patrick Rohr <prohr@google.com> wrote:
>
> This change adds support for not enabling carrier during TUNSETIFF
> interface creation by specifying the IFF_NO_CARRIER flag.
>
> Our tests make heavy use of tun interfaces. In some scenarios, the test
> process creates the interface but another process brings it up after the
> interface is discovered via netlink notification. In that case, it is
> not possible to create a tun/tap interface with carrier off without it
> racing against the bring up. Immediately setting carrier off via
> TUNSETCARRIER is still too late.
>
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/tun.c           | 9 ++++++---
>  include/uapi/linux/if_tun.h | 2 ++
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..db736b944016 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2828,7 +2828,10 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>                 rcu_assign_pointer(tfile->tun, tun);
>         }
>
> -       netif_carrier_on(tun->dev);
> +       if (ifr->ifr_flags & IFF_NO_CARRIER)
> +               netif_carrier_off(tun->dev);
> +       else
> +               netif_carrier_on(tun->dev);
>
>         /* Make sure persistent devices do not get stuck in
>          * xoff state.
> @@ -3056,8 +3059,8 @@ static long __tun_chr_ioctl(struct file *file, unsi=
gned int cmd,
>                  * This is needed because we never checked for invalid fl=
ags on
>                  * TUNSETIFF.
>                  */
> -               return put_user(IFF_TUN | IFF_TAP | TUN_FEATURES,
> -                               (unsigned int __user*)argp);
> +               return put_user(IFF_TUN | IFF_TAP | IFF_NO_CARRIER |
> +                               TUN_FEATURES, (unsigned int __user*)argp)=
;
>         } else if (cmd =3D=3D TUNSETQUEUE) {
>                 return tun_set_queue(file, &ifr);
>         } else if (cmd =3D=3D SIOCGSKNS) {
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 2ec07de1d73b..b6d7b868f290 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -67,6 +67,8 @@
>  #define IFF_TAP                0x0002
>  #define IFF_NAPI       0x0010
>  #define IFF_NAPI_FRAGS 0x0020
> +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> +#define IFF_NO_CARRIER 0x0040
>  #define IFF_NO_PI      0x1000
>  /* This flag has no real effect */
>  #define IFF_ONE_QUEUE  0x2000
> --
> 2.37.3.968.ga6b4b080e4-goog
>

