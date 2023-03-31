Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EA6D1B39
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCaJEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjCaJEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:04:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE8A1EFDE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680253327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKiZjiu+vyUAzLFC4ReUwOUR5bMI5bhQM5JmbRM0Kuw=;
        b=fWzrUECQoCWRsX44JR6WifZmotz8j0dgxZEtGIQMGM5wLFIb6xDxh05MHWLfeeOUDL5BEC
        kUo7gJOwUb7EZt0RZ51WsaNgdBIa2Twxa9C0JUd5FfhoGegnXG9gnUe/vXrb1jz8563SHK
        XGt3x3oXs9ux2hNr0tI1JZiMYtjleFk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-oW0mMTNBMzCp_KCvfKXi8g-1; Fri, 31 Mar 2023 05:02:06 -0400
X-MC-Unique: oW0mMTNBMzCp_KCvfKXi8g-1
Received: by mail-oo1-f69.google.com with SMTP id z133-20020a4a498b000000b0053b5c4e33c5so5878091ooa.6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680253325; x=1682845325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKiZjiu+vyUAzLFC4ReUwOUR5bMI5bhQM5JmbRM0Kuw=;
        b=pIDxCMtRg+RNmUrf+YNpYFf3ZtzFLKy4RTSqAWEt5C6g/UVF0FNdv3lgp1f7IiiGD3
         MTk/f0AxkU0eg0RgKgqhwj5+yfZWpcLgxfeZ9aSOaQVBf3D3IXkThaH9dlNG/OzHR4ce
         blxJEckxo10HsGijxQdqoT9cz35ZGboO2qBAlcbeFW4BnMllj9I/BeVF1SLvAo4foNpu
         m9c4ZytrCPRlSvkrm6cA4rgVAbBDB/FMq0vQlHCtb+x+uXyky5q0d1J/rt77vouMCiEl
         6K1p/gkibIzeGjy8S11qdrEScuqjPgN/Eoxu2ulP546654yF5k8eah54f+lnCmPXHRYb
         OEBQ==
X-Gm-Message-State: AAQBX9fHThFYD1Qh7054vXK3EnPQzhmaFR/7uBBGqVpYMDZSoqgr/cE4
        W2ANOpU1mDrP15IpCXwcAC1kMgIVqnV73MUall/6zvDBqk2IMamKY7onwcYymAJECvfk70eH5Ez
        Fh3942gLVog+mHVtAzw0oN8/dTnT4xg5p0sNavtbg47vTmdPV
X-Received: by 2002:a05:6870:10d4:b0:17e:255e:b1 with SMTP id 20-20020a05687010d400b0017e255e00b1mr8464662oar.9.1680253325522;
        Fri, 31 Mar 2023 02:02:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Ts2kOcVrDednbiGdLc79/pd1q0SEl6uWTDudORrDUOW2+ftuM4XiSkihLIYlW4BcE3xwOOHJ03vcj8ux1Qxo=
X-Received: by 2002:a05:6870:10d4:b0:17e:255e:b1 with SMTP id
 20-20020a05687010d400b0017e255e00b1mr8464651oar.9.1680253325267; Fri, 31 Mar
 2023 02:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com> <20230328120412.110114-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230328120412.110114-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 31 Mar 2023 17:01:54 +0800
Message-ID: <CACGkMEseX1+oi+unZspnGzPduQc-tFkxpVg+9KfEhPSWWqCTrg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] virtio_net: mergeable xdp: put old page immediately
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 8:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
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
> ---
>  drivers/net/virtio_net.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e2560b6f7980..4d2bf1ce0730 100644
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
> @@ -1259,6 +1262,9 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                                page_address(page) + offset, len);
>                         frame_sz =3D PAGE_SIZE;
>                         offset =3D VIRTIO_XDP_HEADROOM;
> +
> +                       put_page(page);
> +                       page =3D xdp_page;
>                 } else {
>                         xdp_page =3D page;
>                 }

While at this I would go a little further, just remove the above
assignment then we can use:

                data =3D page_address(page) + offset;

Which seems cleaner?

Thanks

> @@ -1278,8 +1284,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         if (unlikely(!head_skb))
>                                 goto err_xdp_frags;
>
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         return head_skb;
>                 case XDP_TX:
> @@ -1297,8 +1301,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                                 goto err_xdp_frags;
>                         }
>                         *xdp_xmit |=3D VIRTIO_XDP_TX;
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 case XDP_REDIRECT:
> @@ -1307,8 +1309,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         if (err)
>                                 goto err_xdp_frags;
>                         *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> -                       if (unlikely(xdp_page !=3D page))
> -                               put_page(page);
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 default:
> @@ -1321,9 +1321,6 @@ static struct sk_buff *receive_mergeable(struct net=
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

