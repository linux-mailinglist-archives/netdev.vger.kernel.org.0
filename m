Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31F06A7E5C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjCBJqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCBJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:46:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E86412BD4
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 01:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677750305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rbcPl/Xo1gbrdEEEeeBIbRO9JdxpAp6+JEpsGQF+O8=;
        b=fwonGpL4SmBouGV91r4Z5jmQiDIH4Hsd1tyG22r158Sp1Xk1UdiILbhfhk5DGDqOSC0aRG
        qKcmaX2XLP6oVDp9xRffLmZkEjzn4YCMhq6q3Fqy8IvIBbaN+n++k10YlOMv12oG+6u/3U
        YkTycaQYufuyWIMj2AAAC1OFmGo7zH8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-IupacqFjOweqjdFJdW8zrg-1; Thu, 02 Mar 2023 04:45:04 -0500
X-MC-Unique: IupacqFjOweqjdFJdW8zrg-1
Received: by mail-wr1-f69.google.com with SMTP id q7-20020a05600000c700b002cd9188abe5so1818607wrx.3
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 01:45:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3rbcPl/Xo1gbrdEEEeeBIbRO9JdxpAp6+JEpsGQF+O8=;
        b=fBJpab1MC/aqLeuC6SveeuGUhcsJ7qq1vbZ/MUSn+fJzDvoUwkBuiL1VhMLg5MJxHh
         MSEl6lEi6Iw3uOs+prCdbuqQ9xWjUb7qYhzr75rn6B3i74Zvh/fmEiefqKFKqFIXbgTz
         EizyayqbHpOqGxlnQTmqHa9L8ti66UEqKwMI+mGPxPPQwfruuNR2ZJm08VoAImFd8GHz
         UlSnRZGV+NqFF2EO06dVO/4fs0GlOFAbWBAkZSIto8Ec31qji7HEhZDv3HouaPjYfztR
         TWJbmnmmmgAF6Nt66walwt2dHy7UTK2MQJb1ICV9I/a8WfPSiacsg45plBNdc8OijJBb
         IkDA==
X-Gm-Message-State: AO0yUKXVEDO3bh8Y/EWxnSi2UVKr9mqBK+GQLbu8huAr2ZYETFqAF3ro
        XKYBWHtzwtiMxL2zXFWR9uzBkL+b9D0fcHVX4+VwG8sJ46iSgNzZ6b1WhyvnBOtfh1xHMua19+O
        haCxUM867yV/Q3x91
X-Received: by 2002:a05:600c:3d99:b0:3dc:5ae4:c13d with SMTP id bi25-20020a05600c3d9900b003dc5ae4c13dmr7473028wmb.4.1677750303105;
        Thu, 02 Mar 2023 01:45:03 -0800 (PST)
X-Google-Smtp-Source: AK7set9SGMecLsQHbDU+Ep5cCFFYOkidvt2LbJLkJ2KQmGNnd8Vc3XSsNc9dy5AVwYOCPDjAt0XbIA==
X-Received: by 2002:a05:600c:3d99:b0:3dc:5ae4:c13d with SMTP id bi25-20020a05600c3d9900b003dc5ae4c13dmr7473013wmb.4.1677750302818;
        Thu, 02 Mar 2023 01:45:02 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id x16-20020a1c7c10000000b003e70a7c1b73sm2296348wmc.16.2023.03.02.01.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:45:02 -0800 (PST)
Message-ID: <82084397a98d55e17657b32a09c2909912498b41.camel@redhat.com>
Subject: Re: [PATCH v3] virtio-net: Fix probe of virtio-net on kvmtool
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     rbradford@rivosinc.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Mar 2023 10:45:00 +0100
In-Reply-To: <CACGkMEsG10CWigz+S6JgSVK8XfbpT=L=30hZ8LDvohtaanAiZQ@mail.gmail.com>
References: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
         <20230301093054-mutt-send-email-mst@kernel.org>
         <CACGkMEsG10CWigz+S6JgSVK8XfbpT=L=30hZ8LDvohtaanAiZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-02 at 16:10 +0800, Jason Wang wrote:
> On Wed, Mar 1, 2023 at 10:44=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >=20
> > On Wed, Mar 01, 2023 at 01:59:52PM +0000, Rob Bradford via B4 Relay wro=
te:
> > > From: Rob Bradford <rbradford@rivosinc.com>
> > >=20
> > > Since the following commit virtio-net on kvmtool has printed a warnin=
g
> > > during the probe:
> > >=20
> > > commit dbcf24d153884439dad30484a0e3f02350692e4c
> > > Author: Jason Wang <jasowang@redhat.com>
> > > Date:   Tue Aug 17 16:06:59 2021 +0800
> > >=20
> > >     virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
> > >=20
> > > [    1.865992] net eth0: Fail to set guest offload.
> > > [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); =
wanted 0x0000000000134829, left 0x0080000000134829
> > >=20
> > > This is because during the probing the underlying netdev device has
> > > identified that the netdev features on the device has changed and
> > > attempts to update the virtio-net offloads through the virtio-net
> > > control queue. kvmtool however does not have a control queue that sup=
ports
> > > offload changing (VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is not advertised)
> > >=20
> > > The netdev features have changed due to validation checks in
> > > netdev_fix_features():
> > >=20
> > > if (!(features & NETIF_F_RXCSUM)) {
> > >       /* NETIF_F_GRO_HW implies doing RXCSUM since every packet
> > >        * successfully merged by hardware must also have the
> > >        * checksum verified by hardware.  If the user does not
> > >        * want to enable RXCSUM, logically, we should disable GRO_HW.
> > >        */
> > >       if (features & NETIF_F_GRO_HW) {
> > >               netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSU=
M feature.\n");
> > >               features &=3D ~NETIF_F_GRO_HW;
> > >       }
> > > }
> > >=20
> > > Since kvmtool does not advertise the VIRTIO_NET_F_GUEST_CSUM feature =
the
> > > NETIF_F_RXCSUM bit is not present and so the NETIF_F_GRO_HW bit is
> > > cleared. This results in the netdev features changing, which triggers
> > > the attempt to reprogram the virtio-net offloads which then fails.
> > >=20
> > > This commit prevents that set of netdev features from changing by
> > > preemptively applying the same validation and only setting
> > > NETIF_F_GRO_HW if NETIF_F_RXCSUM is set because the device supports b=
oth
> > > VIRTIO_NET_F_GUEST_CSUM and VIRTIO_NET_F_GUEST_TSO{4,6}
> > >=20
> > > Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> > > ---
> > > Changes in v3:
> > > - Identified root-cause of feature bit changing and updated condition=
s
> > >   check
> > > - Link to v2: https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v=
2-1-8ec93511e67f@rivosinc.com
> > >=20
> > > Changes in v2:
> > > - Use parentheses to group logical OR of features
> > > - Link to v1:
> > >   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b=
9d7a@rivosinc.com
> > > ---
> > >  drivers/net/virtio_net.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 61e33e4dd0cd..2e7705142ca5 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3778,11 +3778,13 @@ static int virtnet_probe(struct virtio_device=
 *vdev)
> > >                       dev->features |=3D dev->hw_features & NETIF_F_A=
LL_TSO;
> > >               /* (!csum && gso) case will be fixed by register_netdev=
() */
> > >       }
> > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
> > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM)) {
> > >               dev->features |=3D NETIF_F_RXCSUM;
> > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > -         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > -             dev->features |=3D NETIF_F_GRO_HW;
> > > +             /* This dependency is enforced by netdev_fix_features *=
/
> > > +             if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) |=
|
> > > +                 virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > +                     dev->features |=3D NETIF_F_GRO_HW;
> > > +     }
> > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > >               dev->hw_features |=3D NETIF_F_GRO_HW;
>=20
> Should we move this also under the check of RXCSUM, otherwise we may
> end up the following case:
>=20
> when CSUM is not negotiated but GUEST_OFFLOADS, can still try to
> enable-or-disable guest offloads? Or do we need to fail the probe in
> the case via virtnet_validate_features()?
>=20
> > >=20
> >=20
> > I see. It is annoying that we are duplicating the logic from
> > netdev_fix_features here though :(
> > Maybe we should call netdev_update_features, in the callback check
> > the flags and decide what to set and what to clear?
> > Or export netdev_fix_features to modules?
>=20
> There's a ndo_fix_features() that might be used here.

I agree with Jason: I think a virtio_net specific ndo_fix_features()
should be the right place to implement the above logic.

Cheers,

Paolo

