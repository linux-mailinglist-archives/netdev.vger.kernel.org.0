Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D026E89F3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjDTF7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjDTF7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:59:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860DC40E2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681970295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KF057K4EPoEi7HYYfZLwh+5zZUpwuxGtMZEQhcs8a28=;
        b=SCJ5bW3t/YpjuHeMljZ5zyEdxUiUFMqA2j4GGzPrj2Mc1GnyUts2DumuRmLzlSj5FmGGg8
        2rrjNkYecrlcjBu44o6kRWh7A673k31dheqjN8FBwdZWr1eI391jvCoVh2gT3Q0KBN4h7H
        He4h0oeX1lMKzKAqV6t97OnkybkrCCM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-0SbomGbSPD-pEshMnPb-Kw-1; Thu, 20 Apr 2023 01:58:13 -0400
X-MC-Unique: 0SbomGbSPD-pEshMnPb-Kw-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5459b578d1aso168164eaf.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681970293; x=1684562293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KF057K4EPoEi7HYYfZLwh+5zZUpwuxGtMZEQhcs8a28=;
        b=h4B7OlAA2BmIa+4h9SgjRJJK+EpI9/xJRjIk0/QeUKSYpXZIHBUxfA9n6LZw3A43g+
         t4ivwkZoRcImnhSHZhAQ6RUzRKTFN84QsTgU5b8bAFTNnN/TZOU+/SzDyOilYBkxflG+
         ApKS9eYs+rYYacqYwqlrePSq2j2LERcwVQUig/HAx3cnllCKEPwDPjeA9KCO9Kc8/SSb
         eP9T13wDxMl+6ZHeggLpA4s/N50jsKjwybi6JHU6mbqoAcm3PzbupMXnC4/zET5wuTIP
         a5N0khx4crVUpLu5bJo/Fm32ajMJGC4diqVocPmB7ksV82lzFg28WQNBo2w+koNvHWZ/
         uA3Q==
X-Gm-Message-State: AAQBX9eloeXll+IV/IVI7AtnCaI81oMPlBB+KnpL7+gibvADyIBOyt6y
        5O8U1YAgsij/v7dhmzKLkYJBZgnrd12ATxvIYtdL2aVbtrpuZ5CLE2ZNJCASBOf/uXt3ihnXbHe
        mWzXUSEUYa62F3oGAU0xyGRJR37r0HVQ/
X-Received: by 2002:a05:6870:6490:b0:17a:a59a:e931 with SMTP id cz16-20020a056870649000b0017aa59ae931mr442656oab.11.1681970292958;
        Wed, 19 Apr 2023 22:58:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350aVtat0i5n6ON9ylDd4Y/gR2oczno6DFTBOtnGidKe3fSEPldtrEE9PXjuS68IAkvnrT0r72lkQGvdaZmGEdy4=
X-Received: by 2002:a05:6870:6490:b0:17a:a59a:e931 with SMTP id
 cz16-20020a056870649000b0017aa59ae931mr442643oab.11.1681970292689; Wed, 19
 Apr 2023 22:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 13:58:01 +0800
Message-ID: <CACGkMEv9KjfQzXKX27jmNeedn03HXob5p0E5Z2LT9GMut8VemA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/14] virtio_net: mergeable xdp: put old page immediately
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> In the xdp implementation of virtio-net mergeable, it always checks
> whether two page is used and a page is selected to release. This is
> complicated for the processing of action, and be careful.
>
> In the entire process, we have such principles:
> * If xdp_page is used (PASS, TX, Redirect), then we release the old
>   page.
> * If it is a drop case, we will release two. The old page obtained from
>   buf is release inside err_xdp, and xdp_page needs be relased by us.
>
> But in fact, when we allocate a new page, we can release the old page
> immediately. Then just one is using, we just need to release the new
> page for drop case. On the drop path, err_xdp will release the variable
> "page", so we only need to let "page" point to the new xdp_page in
> advance.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>  drivers/net/virtio_net.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e2560b6f7980..42435e762d72 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1245,6 +1245,9 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         if (!xdp_page)
>                                 goto err_xdp;
>                         offset =3D VIRTIO_XDP_HEADROOM;
> +
> +                       put_page(page);
> +                       page =3D xdp_page;
>                 } else if (unlikely(headroom < virtnet_get_headroom(vi)))=
 {
>                         xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
>                                                   sizeof(struct skb_share=
d_info));
> @@ -1259,11 +1262,12 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>                                page_address(page) + offset, len);
>                         frame_sz =3D PAGE_SIZE;
>                         offset =3D VIRTIO_XDP_HEADROOM;
> -               } else {
> -                       xdp_page =3D page;
> +
> +                       put_page(page);
> +                       page =3D xdp_page;
>                 }
>
> -               data =3D page_address(xdp_page) + offset;
> +               data =3D page_address(page) + offset;
>                 err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, dat=
a, len, frame_sz,
>                                                  &num_buf, &xdp_frags_tru=
esz, stats);
>                 if (unlikely(err))
> @@ -1278,8 +1282,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         if (unlikely(!head_skb))
>                                 goto err_xdp_frags;
>
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         return head_skb;
>                 case XDP_TX:
> @@ -1297,8 +1299,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                                 goto err_xdp_frags;
>                         }
>                         *xdp_xmit |=3D VIRTIO_XDP_TX;
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 case XDP_REDIRECT:
> @@ -1307,8 +1307,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         if (err)
>                                 goto err_xdp_frags;
>                         *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 default:
> @@ -1321,9 +1319,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         goto err_xdp_frags;
>                 }
>  err_xdp_frags:
> -               if (unlikely(xdp_page !=3D page))
> -                       __free_pages(xdp_page, 0);
> -
>                 if (xdp_buff_has_frags(&xdp)) {
>                         shinfo =3D xdp_get_shared_info_from_buff(&xdp);
>                         for (i =3D 0; i < shinfo->nr_frags; i++) {
> --
> 2.32.0.3.g01195cf9f
>

