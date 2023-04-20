Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA66E8A67
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjDTGaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjDTG37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DE94234
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681972153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LgdnNmMXeh29yiOutomiP5kEsD1QGmIJDroopmJnClM=;
        b=La+nyW1Zu9XGgdnTmBmEh/K3Dm+kinibzwJ6uJWpkFai4xSfUX8EWFtEDO1pS5VmC3RnWY
        Ew5fIvQldoN84f6tKBlq7hM75j7oOwcl2Bueuo0ga+g92LIMHUzGr1zf/7PdfwsqqnfRND
        vpDGjW+JkujVHNa4lvcnWSHwrIq8f38=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502--FHOACnxMU-tr7A0Jagdww-1; Thu, 20 Apr 2023 02:29:12 -0400
X-MC-Unique: -FHOACnxMU-tr7A0Jagdww-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-38bf67eabedso191519b6e.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681972151; x=1684564151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LgdnNmMXeh29yiOutomiP5kEsD1QGmIJDroopmJnClM=;
        b=IkmsmGCM0dZ/ALSGlPK0yzWNdJTuuBrOCFHNhZrxDCjWs4nVVCti2D8KLM5q6PCnLV
         tya1/RLskeaB8v4XZL0ABvW6YqZ4lgXzg3ZgbC4C6qj0baZgydyGiylOyRoyJ8ElXpTw
         VMHPlrelk9OS93WR/E4XP30xwFiEunFAIqzWwSSzhoUwHIlVgq/TBD+QL+8SFAGf5K49
         aRgiYDmx7SENoya3QNr7Dqa39NyCGhau4deiuOwFg8xv5NSftGrkMbrL4vQWWYEpS+AS
         xMtkEgUd6wtS605qBc415tDKriCwomvcPFjXEaviO65ifxkrv1M2N7Dyjm0QDFcpXKNg
         dBfw==
X-Gm-Message-State: AAQBX9f2IWKx10jVL0rgP4tzJod1a53pQ84WFayQtq4s1TcI+JQZoY52
        TUKAqe0AvaZci1+9iVv+nN1YG8jdUeX9BANJgGfNYjA5yihzNbue8eY2c8DcnYff1eUxYsjrkp0
        2Peh3mCFSv2YAkgbb5z8W9INa1Axk/ybt
X-Received: by 2002:a05:6808:1991:b0:38b:f2d1:db15 with SMTP id bj17-20020a056808199100b0038bf2d1db15mr344443oib.47.1681972151228;
        Wed, 19 Apr 2023 23:29:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350YT4AHXQXgwTQRHka9aoNLwtjjr5EAkfqPeNamGyXLmUb3WmrSzik+6jAVvfDtUCTnI5MDVMEL5IUPiyqxatyk=
X-Received: by 2002:a05:6808:1991:b0:38b:f2d1:db15 with SMTP id
 bj17-20020a056808199100b0038bf2d1db15mr344442oib.47.1681972151022; Wed, 19
 Apr 2023 23:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-13-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-13-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 14:28:59 +0800
Message-ID: <CACGkMEsSR9uu1n7kFZLDxeje=_JWzadVtqcYizwYRypmnR4Wdw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 12/14] virtio_net: small: optimize code
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> In the case of XDP-PASS, skb_reserve uses the delta to compatible
> non-XDP, now remove this logic.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 34220f5f27d1..f6f5903face2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -959,9 +959,7 @@ static struct sk_buff *receive_small_xdp(struct net_d=
evice *dev,
>         unsigned int buflen;
>         struct xdp_buff xdp;
>         struct sk_buff *skb;
> -       unsigned int delta =3D 0;
>         unsigned int metasize =3D 0;
> -       void *orig_data;
>         u32 act;
>
>         if (unlikely(hdr->hdr.gso_type))
> @@ -994,14 +992,12 @@ static struct sk_buff *receive_small_xdp(struct net=
_device *dev,
>         xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
>         xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
>                          xdp_headroom, len, true);
> -       orig_data =3D xdp.data;
>
>         act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats)=
;
>
>         switch (act) {
>         case VIRTNET_XDP_RES_PASS:
>                 /* Recalculate length in case bpf program changed it */
> -               delta =3D orig_data - xdp.data;
>                 len =3D xdp.data_end - xdp.data;
>                 metasize =3D xdp.data - xdp.data_meta;
>                 break;
> @@ -1017,7 +1013,7 @@ static struct sk_buff *receive_small_xdp(struct net=
_device *dev,
>         if (!skb)
>                 goto err;
>
> -       skb_reserve(skb, headroom - delta);
> +       skb_reserve(skb, xdp.data - buf);
>         skb_put(skb, len);
>         if (metasize)
>                 skb_metadata_set(skb, metasize);
> --
> 2.32.0.3.g01195cf9f
>

