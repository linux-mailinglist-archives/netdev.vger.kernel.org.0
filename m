Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC55BC321
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 08:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiISGw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 02:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiISGw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 02:52:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3257FDFEA
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 23:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663570374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4SOIpoYOSBm9TsWI3MKoroEbbgZpa1shCQXKtpD3iM=;
        b=UmaQ0v62315rD+xhUhxPzl5HBsaOlWGHhXp9dR844ysLjrEyHvg8OkhkLe6k/J/7FulJA6
        hN9lJZ07IV1YtwVUqDetfcrwhexpjx3txgvayD932TqijFFMgFH0qrbFOjhVhOho/c8Fqa
        Lmsi2R7eOYC60yfKWklOqXWaAB2Vm4s=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-zdzVEPJIPyOpIbKthbqJPA-1; Mon, 19 Sep 2022 02:52:52 -0400
X-MC-Unique: zdzVEPJIPyOpIbKthbqJPA-1
Received: by mail-ua1-f72.google.com with SMTP id n8-20020a9f3148000000b0039f22c5b291so8965111uab.1
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 23:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=b4SOIpoYOSBm9TsWI3MKoroEbbgZpa1shCQXKtpD3iM=;
        b=v9aYMpAIPh1T5oaSb1X+9+32LO10PUj5UgdKyf23Mx5s00+ZkYuIUqgDa2yMz8zUh6
         gki+IygceapmMQ2jV6gymIaW5lh3HYM7mTlthhNPzYfpsYP09PT0GY4MkH4jA2NFoheW
         5j90L1k0/a5DGGPrOGe5v05HiWtI4v/XWv7DVPqIKD0UpGUYbGf5nwdvZAg67M0Wm6Pc
         MIat+m1i0pIq2q+BjrkdSX66JrwoxxNkE+Vd8FItBW+X8JXZbnjQGvVtPuFhj+ehgnOq
         mReEVKs+mjMwWPnmK4SwAOzsFada0wWYzMX1blFDTC+Y+sM88sOEqI1DtHq9yrNryd9F
         hHcg==
X-Gm-Message-State: ACrzQf0UzK24GdWeBFYSWgYjV/dfo43O2DBU4ZlQXZn7wLFxubUZ+Qo8
        /1zEUS9HSw0Onzrcdzb6qTFtvXDRfrnMmgmKCVGHaFzGZ70MvyJAP0y304BKBMcja7ehzU6VEBj
        GyHN6Rs+nBJ/eVNRFrSyICfAFYcnVPl2B
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id f188-20020a1f9cc5000000b003a2bd208fc6mr5399438vke.22.1663570371889;
        Sun, 18 Sep 2022 23:52:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7ee3yJ4drFWySXlqQJuwUBHQrcp4MB8jSJULTSFh/f3l6llFnUPi2FbiiluVep87CqWfMzkBuQAff56dhi2Z8=
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id
 f188-20020a1f9cc5000000b003a2bd208fc6mr5399431vke.22.1663570371709; Sun, 18
 Sep 2022 23:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220916234552.3388360-1-prohr@google.com>
In-Reply-To: <20220916234552.3388360-1-prohr@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 19 Sep 2022 14:52:40 +0800
Message-ID: <CACGkMEv8Y09r1t=F9_Sinb=W=PETii6u+2DT5xnMXFunMhXJ5A@mail.gmail.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
To:     Patrick Rohr <prohr@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>
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

On Sat, Sep 17, 2022 at 7:46 AM Patrick Rohr <prohr@google.com> wrote:
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
> Since ifr_flags is only a short, the value for IFF_DETACH_QUEUE is
> reused for IFF_NO_CARRIER. IFF_DETACH_QUEUE has currently no meaning in
> TUNSETIFF.
>
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/tun.c           | 15 ++++++++++++---
>  include/uapi/linux/if_tun.h |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..502f56095650 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2709,6 +2709,12 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>         struct net_device *dev;
>         int err;
>
> +       /* Do not save the IFF_NO_CARRIER flag as it uses the same value =
as
> +        * IFF_DETACH_QUEUE.
> +        */
> +       bool no_carrier =3D ifr->ifr_flags & IFF_NO_CARRIER;
> +       ifr->ifr_flags &=3D ~IFF_NO_CARRIER;
> +
>         if (tfile->detached)
>                 return -EINVAL;
>
> @@ -2828,7 +2834,10 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>                 rcu_assign_pointer(tfile->tun, tun);
>         }
>
> -       netif_carrier_on(tun->dev);
> +       if (no_carrier)
> +               netif_carrier_off(tun->dev);
> +       else
> +               netif_carrier_on(tun->dev);
>
>         /* Make sure persistent devices do not get stuck in
>          * xoff state.
> @@ -3056,8 +3065,8 @@ static long __tun_chr_ioctl(struct file *file, unsi=
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
> index 2ec07de1d73b..12dde91957a5 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -75,6 +75,8 @@
>  #define IFF_MULTI_QUEUE 0x0100
>  #define IFF_ATTACH_QUEUE 0x0200
>  #define IFF_DETACH_QUEUE 0x0400
> +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> +#define IFF_NO_CARRIER IFF_DETACH_QUEUE
>  /* read-only flag */
>  #define IFF_PERSIST    0x0800
>  #define IFF_NOFILTER   0x1000
> --
> 2.37.3.968.ga6b4b080e4-goog
>

