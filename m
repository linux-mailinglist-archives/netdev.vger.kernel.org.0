Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFFC6A3A05
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 05:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjB0EN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 23:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjB0ENN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 23:13:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCA9113C6
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 20:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677471137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF6aiagdS4QYKhUwnh5wvwibqsaVZLVPjb91E7IR+3w=;
        b=aqpZw07LQpP7CMvPCj5XN0x3njFB+IhjsYsMq7yXdy0jJKIpSytBURPHM0lIR6SmO2Qryn
        6rMlxvebbTytKlEgUHvFE0r2MINIq8feLa8xl4DC/NKd6kwOdnHOD9xg1XiC4fgWAN8hZ/
        eJ3FPSOBEryg3xUBmv9SQ/O8DA0hobY=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321-ZDTm-SXCM4CW168s9CBEkg-1; Sun, 26 Feb 2023 23:12:15 -0500
X-MC-Unique: ZDTm-SXCM4CW168s9CBEkg-1
Received: by mail-oo1-f69.google.com with SMTP id e137-20020a4a558f000000b0051a14b3d779so878470oob.15
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 20:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bF6aiagdS4QYKhUwnh5wvwibqsaVZLVPjb91E7IR+3w=;
        b=mCOC4O+K0/DURPa5WLCva4Lr98OUFW8LiqYcoM+U7AcYBJIN9dlWPAM8EU0ok6AZ2n
         sNiV4VyuRmJg+Rew6PhBDUQyl233FrM+Wfudjrenhxw7cfPCiuFJMhxEhRiqvFeKLwxZ
         Pt1bDDm3Uf4zECuX/VVnKZoa9DA2TqqVdf36Ug0/FjLPJ3x5qWcAvxxlwEZVs/oPTD7e
         fdmKi2W5qbvzB2e7M4yI4G5yHHlkrPK5Smb6ckrIcX9fr3U2MaDviaWd0BmrpCBtInog
         oxQfk4xO0xD/5CeRFL2DlJipiVNwhIOK2J+E5xnXcurJIJmTuKzPKs2ZjF/3q/iBqGDt
         8y0w==
X-Gm-Message-State: AO0yUKWxeiyIp/wRHqW0MZf6h24ZjzldiPS6tQXSWIJ/V8QQ5XeXFC6U
        l05FSd38SVKXJOoC7RIfdj5CmeoQUHiexOiyaghKxwN187+XiYvjumKB4qO7CsRIu2RqKGpW4JJ
        T+rlm/B80WNlj3hL0SM9bvxyQaE4cY48y
X-Received: by 2002:aca:170c:0:b0:37f:ab56:ff42 with SMTP id j12-20020aca170c000000b0037fab56ff42mr3473926oii.9.1677471135098;
        Sun, 26 Feb 2023 20:12:15 -0800 (PST)
X-Google-Smtp-Source: AK7set/s+nbucOcz9b2Oq/7thNtMbK8QBjD/2uF5c2KiU21IMrI5QTglUfGm3DOphwmfmZOT3QQigLJlfH4Zl+n1WLc=
X-Received: by 2002:aca:170c:0:b0:37f:ab56:ff42 with SMTP id
 j12-20020aca170c000000b0037fab56ff42mr3473919oii.9.1677471134909; Sun, 26 Feb
 2023 20:12:14 -0800 (PST)
MIME-Version: 1.0
References: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com> <20230224031932-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230224031932-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Feb 2023 12:12:03 +0800
Message-ID: <CACGkMEs8f6akn62UKGUC=N=+MMRdLuGrzC7OpOps5_Ug6h933g@mail.gmail.com>
Subject: Re: [PATCH v2] virtio-net: Fix probe of virtio-net on kvmtool
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     rbradford@rivosinc.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Feb 24, 2023 at 4:25=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Feb 23, 2023 at 07:38:25PM +0000, Rob Bradford via B4 Relay wrote=
:
> > From: Rob Bradford <rbradford@rivosinc.com>
> >
> > kvmtool does not support the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature
> > but does advertise the VIRTIO_NET_F_GUEST_TSO{4,6} features. Check that
> > the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is present before setting
> > the NETIF_F_GRO_HW feature bit as otherwise an attempt will be made to
> > program the virtio-net device using the ctrl queue which will fail.
> >
> > This resolves the following error when running on kvmtool:
> >
> > [    1.865992] net eth0: Fail to set guest offload.
> > [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wa=
nted 0x0000000000134829, left 0x0080000000134829
> >
> > Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> > ---
> > Changes in v2:
> > - Use parentheses to group logical OR of features
> > - Link to v1:
> >   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b9d=
7a@rivosinc.com
> > ---
> >  drivers/net/virtio_net.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 61e33e4dd0cd..f8341d1a4ccd 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3780,10 +3780,9 @@ static int virtnet_probe(struct virtio_device *v=
dev)
> >       }
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
> >               dev->features |=3D NETIF_F_RXCSUM;
> > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > -         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > -             dev->features |=3D NETIF_F_GRO_HW;
> > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > +     if ((virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > +         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)) &&
> > +         virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> >               dev->hw_features |=3D NETIF_F_GRO_HW;
>
> This will disable GRO/LRO on kvmtool completely causing a significant
> performance regression.
>
> Jason, isn't this what
>         commit dbcf24d153884439dad30484a0e3f02350692e4c
>         Author: Jason Wang <jasowang@redhat.com>
>         Date:   Tue Aug 17 16:06:59 2021 +0800
>
>             virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
>
> was supposed to address?
>

Yes, I've asked a similar question in another thread.

>
> And apropos this:
>
>     Fix this by using NETIF_F_GRO_HW instead. Though the spec does not
>     guarantee packets to be re-segmented as the original ones,
>     we can add that to the spec, possibly with a flag for devices to
>     differentiate between GRO and LRO.
>
> this never happened. What's the plan exactly?

It's in the backlog, but I'm out of bandwidth for doing that now.

Thanks

>
>
>
>
> >       dev->vlan_features =3D dev->features;
> >
> > ---
> > base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
> > change-id: 20230223-virtio-net-kvmtool-87f37515be22
> >
> > Best regards,
> > --
> > Rob Bradford <rbradford@rivosinc.com>
>

