Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AB16620E8
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbjAIJFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbjAIJEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:04:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D9615832
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673254610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsuF/hrJH5PRFQt/Oi/KlNkJwLFWZO04nt6xbiKMi14=;
        b=LtRZWr0Is5zXUigTyF13jXq0c/f1qm/Pg/SNth69KvNr+b0CqjuYkqSUkQ9tr/9/XgmubL
        NyFHjkPzg+I6a6wb6lIGQGKSz+dszDAVHzKOS/RAL1VNSiZQD+yUcdoc2/Or9YObTFmWr9
        qHTp5uIt9xEFhzgb+KLzO/vCVQ2Pxx4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-oRuBcQgHNaqOIy2YHm8QAg-1; Mon, 09 Jan 2023 03:56:49 -0500
X-MC-Unique: oRuBcQgHNaqOIy2YHm8QAg-1
Received: by mail-oo1-f69.google.com with SMTP id g26-20020a4a755a000000b004dd8e8ace8bso3009186oof.9
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsuF/hrJH5PRFQt/Oi/KlNkJwLFWZO04nt6xbiKMi14=;
        b=SB8IwlOJlx2oCY/OgNnJVP2j1nSHQdJaODg3mzMe0e6XMHf6i+zrOIzOOI+EzTy9b5
         PghEXcfpTNJfkPKbXn3FeiL3YrYt2+t2ALY18EPuS1a66tBO2sRHAUdwlmzJ995+MqtQ
         ldfrINu1kx+Pgb8jP+bNhDvApC7A471pfnE5ZV0sc1K2F0a6nsRMj2+xpDKCdSn3dpCg
         5dZE0lYWWVqhxyYPydIFngfQkCyHgDWLRNz10x6Cj7FJeAzjnM66la8S1She9hA+HJVG
         218BpiKzqXeSL13p1fcVDyg9ACk6L1QlFlM+NW3vGaBsipfpGIJiCrieIkMa2jlZMmwY
         Y5Rg==
X-Gm-Message-State: AFqh2krxkFotmjGHNcptKB/0wuHoYMVlII5R2xCmRm16TgZirz+CIJ4H
        1gKoOh/5gVBZycoMl5ZpqRr50JXPXeOqQYb+CFBiEyslYLmayVo/YrtaiJJaEanprf+qSh+OIyd
        Y5jLn0vyG7QwzEizu+Z1qxpw/40hIBnso
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id c9-20020a544e89000000b0035c303dfe37mr2719689oiy.35.1673254608715;
        Mon, 09 Jan 2023 00:56:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvbHT4MrqFm9F33/AyLDVtlaiEWYFvCG4dE2fg5riyp/5GEmnQH1wPX2PuqW4SyjlD7y7PCY2iwH9wfkZ3t4YI=
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id
 c9-20020a544e89000000b0035c303dfe37mr2719685oiy.35.1673254608466; Mon, 09 Jan
 2023 00:56:48 -0800 (PST)
MIME-Version: 1.0
References: <20230103064012.108029-1-hengqi@linux.alibaba.com>
 <20230103064012.108029-3-hengqi@linux.alibaba.com> <8ae89098-594f-b28b-4040-b0625b816e14@linux.alibaba.com>
In-Reply-To: <8ae89098-594f-b28b-4040-b0625b816e14@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 Jan 2023 16:56:37 +0800
Message-ID: <CACGkMEsBe=_uNFB_6K_obqcnnaJi6ME22-j7cgXwSCTV85BKQw@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] virtio-net: set up xdp for multi buffer packets
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 10:48 AM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
>
>
> =E5=9C=A8 2023/1/3 =E4=B8=8B=E5=8D=882:40, Heng Qi =E5=86=99=E9=81=93:
> > When the xdp program sets xdp.frags, which means it can process
> > multi-buffer packets over larger MTU, so we continue to support xdp.
> > But for single-buffer xdp, we should keep checking for MTU.
> >
> > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 10 ++++++----
> >   1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 443aa7b8f0ad..60e199811212 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3074,7 +3074,9 @@ static int virtnet_restore_guest_offloads(struct =
virtnet_info *vi)
> >   static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *p=
rog,
> >                          struct netlink_ext_ack *extack)
> >   {
> > -     unsigned long int max_sz =3D PAGE_SIZE - sizeof(struct padded_vne=
t_hdr);
> > +     unsigned int room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> > +                                        sizeof(struct skb_shared_info)=
);
> > +     unsigned int max_sz =3D PAGE_SIZE - room - ETH_HLEN;
>
> Hi Jason, I've updated the calculation of 'max_sz' in this patch instead
> of a separate bugfix, since doing so also seemed clear.

Sure, I will review it with this series no later than the end of this week.

Thanks

>
> Thanks.
>
> >       struct virtnet_info *vi =3D netdev_priv(dev);
> >       struct bpf_prog *old_prog;
> >       u16 xdp_qp =3D 0, curr_qp;
> > @@ -3095,9 +3097,9 @@ static int virtnet_xdp_set(struct net_device *dev=
, struct bpf_prog *prog,
> >               return -EINVAL;
> >       }
> >
> > -     if (dev->mtu > max_sz) {
> > -             NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP")=
;
> > -             netdev_warn(dev, "XDP requires MTU less than %lu\n", max_=
sz);
> > +     if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP w=
ithout frags");
> > +             netdev_warn(dev, "single-buffer XDP requires MTU less tha=
n %u\n", max_sz);
> >               return -EINVAL;
> >       }
> >
>

