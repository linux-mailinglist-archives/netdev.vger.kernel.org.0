Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E676E8A72
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbjDTGdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjDTGdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBC449C6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681972371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSt4vJ6JebWC94KoDTMIHxTA6Bf2J+lWbCuixu0az/4=;
        b=dZiIlYa2/wIPqUP+8AU3HjO9o8YFE1SQVwEGApiXwL68M3njGy2bL5SSif1VVAnwNP8cEn
        v8aLtaSbeoyVonC6mlDoFM1Z9p2fesw7x3QJk+43wGIWIwPooMs+8E8G3d11TymdPIEPWt
        uN2Jjo3mhiD2Xy+I5TgX98VJtjSW+Es=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-NsNd20w2P66AQFHJ_8pEfw-1; Thu, 20 Apr 2023 02:32:50 -0400
X-MC-Unique: NsNd20w2P66AQFHJ_8pEfw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-38beee4e26cso378513b6e.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681972370; x=1684564370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSt4vJ6JebWC94KoDTMIHxTA6Bf2J+lWbCuixu0az/4=;
        b=kOF0+rRrgZ/5UKMMhjaqbMDM0tGS1Cz7jU9IluubkDOWdi6cEoLCyTXmAxKQDI7XWO
         sKi17ISLuzCSiDE4SA1LyD/X2+tDA5hmKWaQuvTtmDzm6zGb0r+SEkLKjyTelVwmrj4A
         RpkqTuX65TOV0aoEJ/jiKSb8SOIwA/1VW4TdXFIh7yEIEz51AapsQTcIlct20LOhOmP2
         MTtwvZz+Xvw1JXleDtedRddXaqOIK9PWaEzjc7AQ4tg1my9Kfp17JwrV16/m2srhGgra
         TdEFHLTGPaAEx6U6BEs4g69ei/C/JuyA1h4pUVJeiO8Kh53aBZeLajO3/cQLxGwGMMkV
         zNwQ==
X-Gm-Message-State: AAQBX9dSb3rQ/4iZqnRwv7DSawgUvmC41T0AyplG12TxcLHU1VxDVM1O
        2gLOsjdXbKLcBrl4wNK0D94VoMH2TSYobK0sFCt7WulB2aMC2Eb6PgmAx4L17Cf2ECfjCcaKcLd
        QPm1wxntHJ/AE3GDNo6yX5VXDOw0cWa4f
X-Received: by 2002:a05:6808:30a2:b0:38e:67d7:9d0e with SMTP id bl34-20020a05680830a200b0038e67d79d0emr328359oib.31.1681972369458;
        Wed, 19 Apr 2023 23:32:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350aeHvzKzDJfinP2eZ1Sdj3X4Zpydu2RwxzgLVr1a7/071YWVYaLIeuA0ANa6w9WFB2KKl0o7pvkgAkp4OyBTE4=
X-Received: by 2002:a05:6808:30a2:b0:38e:67d7:9d0e with SMTP id
 bl34-20020a05680830a200b0038e67d79d0emr328341oib.31.1681972368876; Wed, 19
 Apr 2023 23:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-14-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-14-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 14:32:37 +0800
Message-ID: <CACGkMEtubJ8ND01J+Arpa4TB5kfdap7t6f9D5qc7-XkeFZYRKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 13/14] virtio_net: small: optimize code
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
> Avoid the problem that some variables(headroom and so on) will repeat
> the calculation when process xdp.

While at it, if we agree to use separate code paths for building skbs.

It would be better to have a helper for building skb for non XDP
cases, then we can hide those calculation there.

Thanks

>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f6f5903face2..5a5636178bd3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1040,11 +1040,10 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>         struct sk_buff *skb;
>         struct bpf_prog *xdp_prog;
>         unsigned int xdp_headroom =3D (unsigned long)ctx;
> -       unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> -       unsigned int headroom =3D vi->hdr_len + header_offset;
> -       unsigned int buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom=
) +
> -                             SKB_DATA_ALIGN(sizeof(struct skb_shared_inf=
o));
>         struct page *page =3D virt_to_head_page(buf);
> +       unsigned int header_offset;
> +       unsigned int headroom;
> +       unsigned int buflen;
>
>         len -=3D vi->hdr_len;
>         stats->bytes +=3D len;
> @@ -1072,6 +1071,11 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
>         rcu_read_unlock();
>
>  skip_xdp:
> +       header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> +       headroom =3D vi->hdr_len + header_offset;
> +       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> +               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
>         skb =3D build_skb(buf, buflen);
>         if (!skb)
>                 goto err;
> --
> 2.32.0.3.g01195cf9f
>

