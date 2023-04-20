Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B626E8A2F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjDTGLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjDTGLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FBB4681
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681971031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+2TPu1Dli86e40Ba+uWSkUDT3RNHQ6yyjC59DejTew=;
        b=aVDOUdpOlWoRujqKJrAow0B2gqXjMc1If5Fqwp74/Qf0hgkj6EkL5KFRyQswGBfL90IO0d
        H8RzANZio/JfH1zTE8MGxdn8R0cK+VfjEpkxMyt/okF9u89E7nD0cUg2FjCsXyLo+6q8h1
        o1lEAqXqxQT2ROgfieMorkdFIf5oKf4=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-lXpJ_-rbOGCE9XG_gRvGJQ-1; Thu, 20 Apr 2023 02:10:30 -0400
X-MC-Unique: lXpJ_-rbOGCE9XG_gRvGJQ-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5469ab1632eso412000eaf.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681971029; x=1684563029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i+2TPu1Dli86e40Ba+uWSkUDT3RNHQ6yyjC59DejTew=;
        b=LY+JtWj1gOhk25viDIhI75v0ets4yuTH0EXtVqyEk7bDNl4TQHXfSA2j9hIEkkInRG
         xbe6JLBSx2/kFN71wcCjuQv2qfEw83SJ/TYkOdiFGKmewoeAWoWPfoqVbZ9Z+1EaPMWs
         KR1Sr4j8npXNmPklQ7KcARVTUPlUoVBW7DLfmni+lLsqtOW101RRdhG4cJxXJKdSFRkT
         VtZ9Ek3wrg/081jzE3BW4GPHW2a+KBVX2yXaCMCJaztGYAdkV2KArfv2UP8oA6hvsRoA
         q1/oXSWwsRkAfJ0E317OOiPmrhmx5I3t4QaYnnHiV5t0drFz8G6hcwXNtYzUEBlUkfSb
         nr3g==
X-Gm-Message-State: AAQBX9ecDq0RFFf+jh7DmoGfkLBDT/x20LvPB7eGvLlI+i/2QfSst3gT
        pmQuNabNLj3C28tzzbhTJ+AvZeo26eyLpCoVzrQa40IA+moFSprt0oPlJDQ6IOeM1A8/xrXwz8A
        Fm+BwWmInMZQuebWSTEEMXM0nQYkasYzG
X-Received: by 2002:a05:6808:1307:b0:38e:352:62ac with SMTP id y7-20020a056808130700b0038e035262acmr432128oiv.51.1681971029621;
        Wed, 19 Apr 2023 23:10:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZwwHZJhTnLekIJiCmfK6gCgbWRui/f1zAK1Ry561QhXGh9aTx1YVBYdwmTm4x9sm99V1pd9d3YW5eXefxeacw=
X-Received: by 2002:a05:6808:1307:b0:38e:352:62ac with SMTP id
 y7-20020a056808130700b0038e035262acmr432115oiv.51.1681971029449; Wed, 19 Apr
 2023 23:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-11-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-11-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 14:10:18 +0800
Message-ID: <CACGkMEuQ9dW6SjTJ6R_zDz7e4JTwb9TKrO5YN51=J9b4PWOAfg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 10/14] virtio_net: merge: remove skip_xdp
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
> Now, the logic of merge xdp process is simple, we can remove the
> skip_xdp.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 42e9927e316b..a4bb25f39f12 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1390,7 +1390,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         struct page *page =3D virt_to_head_page(buf);
>         int offset =3D buf - page_address(page);
>         struct sk_buff *head_skb, *curr_skb;
> -       struct bpf_prog *xdp_prog;
>         unsigned int truesize =3D mergeable_ctx_to_truesize(ctx);
>         unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>         unsigned int tailroom =3D headroom ? sizeof(struct skb_shared_inf=
o) : 0;
> @@ -1406,22 +1405,20 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>                 goto err_skb;
>         }
>
> -       if (likely(!vi->xdp_enabled)) {
> -               xdp_prog =3D NULL;
> -               goto skip_xdp;
> -       }
> +       if (unlikely(vi->xdp_enabled)) {
> +               struct bpf_prog *xdp_prog;
>
> -       rcu_read_lock();
> -       xdp_prog =3D rcu_dereference(rq->xdp_prog);
> -       if (xdp_prog) {
> -               head_skb =3D receive_mergeable_xdp(dev, vi, rq, xdp_prog,=
 buf, ctx,
> -                                                len, xdp_xmit, stats);
> +               rcu_read_lock();
> +               xdp_prog =3D rcu_dereference(rq->xdp_prog);
> +               if (xdp_prog) {
> +                       head_skb =3D receive_mergeable_xdp(dev, vi, rq, x=
dp_prog, buf, ctx,
> +                                                        len, xdp_xmit, s=
tats);
> +                       rcu_read_unlock();
> +                       return head_skb;
> +               }
>                 rcu_read_unlock();
> -               return head_skb;
>         }
> -       rcu_read_unlock();
>
> -skip_xdp:
>         head_skb =3D page_to_skb(vi, rq, page, offset, len, truesize, hea=
droom);
>         curr_skb =3D head_skb;
>
> --
> 2.32.0.3.g01195cf9f
>

