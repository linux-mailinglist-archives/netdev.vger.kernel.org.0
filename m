Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9A86EEC90
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 05:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbjDZDJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 23:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbjDZDJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 23:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F591BC9
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 20:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682478546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yC58K9sqZSRjBF39DoGELeoNDDbSNW/7to9J6fPLARI=;
        b=Wze4eUhcqNsFkw0dHnnLBLw19dy1or8wZcR1qJPCHMivaNhUfWZpkb5HJqdCD1PToix87R
        UUUaBo8edbj7UjQYABmpU4qrJRJeuq17Ujt0JJbwaNPXoyWIYXi9M8w/jmDzWicRhdN9zb
        E75mCvOvXcKVqAiCyNjdc6k5/Tto3GA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137--3iDeFV7N3itxqUCuwXjdg-1; Tue, 25 Apr 2023 23:09:05 -0400
X-MC-Unique: -3iDeFV7N3itxqUCuwXjdg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4ecb00906d0so3484672e87.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 20:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682478543; x=1685070543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yC58K9sqZSRjBF39DoGELeoNDDbSNW/7to9J6fPLARI=;
        b=Oio/3QpPYN2Lhw/DoroO13raOgQAI3qhLVFLj4N2JD/TYYSVkhNduqoNu4lU6YeldG
         DxjhUkWuL0Li8jIMA7qwa5lSIPVe7Ixr5iFPqXYiB9CWROI81C4zeO0QsnnsX/aE562t
         /q0txR0pR0qYJrQpEWj1opvpwUEwCOBVeGkjHADheiUk1Dakf1fJPYGZzXdlZBMqAdPM
         bUR4cAzeaTTB7dqimrstgETTGHCnc3mH0NNL7cNgOKDyWsdniXxmEHe5QYXkWfh1qoXu
         q8L3JuSrRNPrrTmGr+aq5Sjou2LK8IQ8wUXy9PCKXtqZRGbtmSaW4/FjtmC0lxXXXqv3
         UY7Q==
X-Gm-Message-State: AAQBX9fWtk49XBWnrol5MCZ5RoXM6Uhp9MKKEqoKZGwUNkXjA6rFnWE7
        zR6GIgevzYNEJUEKCzFrvc9NTsN/1lSWlSloD8Sy45GXnzLO24pLw5AgghvOVTlzGMFtbszMZBb
        K4RjkwbiJOT/e9u6LkZBQQaoWtWHj2KMVu2YObWjvqeFgzJ/p
X-Received: by 2002:ac2:547b:0:b0:4ea:f6d7:2293 with SMTP id e27-20020ac2547b000000b004eaf6d72293mr5058730lfn.55.1682478543473;
        Tue, 25 Apr 2023 20:09:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350YLKXQgMI4TomiMy24A9d3HGABaVrLz6kQAc86xRDvq09NKcWSpfa35XnVK8ze1llkooOmFmnatlEV6y1zF/Y8=
X-Received: by 2002:ac2:547b:0:b0:4ea:f6d7:2293 with SMTP id
 e27-20020ac2547b000000b004eaf6d72293mr5058718lfn.55.1682478543190; Tue, 25
 Apr 2023 20:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com> <20230423105736.56918-13-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230423105736.56918-13-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 26 Apr 2023 11:08:52 +0800
Message-ID: <CACGkMEtC8WECH054KRs-uPeZiCv_PMUX4++9eUNffrB0Pboycw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 12/15] virtio_net: small: optimize code
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
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 6:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Avoid the problem that some variables(headroom and so on) will repeat
> the calculation when process xdp.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Nit: I think we need to tweak the title, it's better to say what is
optimized. (And it would be better to tweak the title of patch 11 as
well)

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/virtio_net.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5bc3dca0f60c..601c0e7fc32b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1031,11 +1031,10 @@ static struct sk_buff *receive_small(struct net_d=
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
> @@ -1063,6 +1062,11 @@ static struct sk_buff *receive_small(struct net_de=
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

