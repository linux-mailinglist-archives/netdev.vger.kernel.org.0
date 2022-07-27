Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A519D582083
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiG0Gyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiG0Gyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:54:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D274DC62
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658904868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0RBiYqbTKOmiNtSdg/JY0oqdCuNT1JWvGzLzPojPqE=;
        b=fg14Z1YgC2ldnwGKFWCnXfM29sAqAUDdRBdejLvEIvNvg4SsPTzxLQ3aR2oiKwM4kOyRxz
        6gbMNk6KPy4fP7ZLg3+Nw2hctsq/vliAOSmriHJ5ITkyKQO5SAwsdHXKL/StnMfSmGN080
        /qFYAXrPdx4xkQHEi5cXESxHBtcBDjE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-YJzzVqhMPuq7-mfsiU-OQA-1; Wed, 27 Jul 2022 02:54:26 -0400
X-MC-Unique: YJzzVqhMPuq7-mfsiU-OQA-1
Received: by mail-ed1-f72.google.com with SMTP id y2-20020a056402440200b0043bd6c898deso7775357eda.20
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L0RBiYqbTKOmiNtSdg/JY0oqdCuNT1JWvGzLzPojPqE=;
        b=E8kq/UqLX96N7inKZwc6QzL7DFlEGPH2xrwGdBYtMCCC/ARl6OluIo6+Pr3jf9uE+H
         KMjat5fsw3sO1hWDbgHv4ttbK9TvwiffVGKZOuk3ey+UG4cH+uPhBGKz1CaC7XdcHl6D
         t+zNkDdkwDBntCtYJy/J98xK697gG9DOw/IVjRSJVbBoq9Zxh12NFW2of2B1nZVXABec
         mSMAfWWhmZA3ILLFD88ZdN5wHmMgqGFJHVyu9zisvOcefHz+GpDymlhxEYA6CseQNUfL
         z/9Ulma5Sf38MxQwQLqeoZX59Jd3iUjsn1Acd018z/JnW3fCC2e9gqZSAORFko+QEGD7
         /86w==
X-Gm-Message-State: AJIora+Wh86hXlW0KTxA3+HF8bDclGqrjLbxWRz5T1XFF5LzjywC4zXy
        +ZwKHqoNxD49ajAdCYBCpiAmC4hoaH5v+lWQ3fupxLeON1+5XNcQRs50XaaO6zA+e4NOeIR4vmK
        lrHfqky0BJkn4w1f2a9GQSUFWg3gRd6sS
X-Received: by 2002:a17:907:2e01:b0:72b:764f:ea1a with SMTP id ig1-20020a1709072e0100b0072b764fea1amr16740657ejc.666.1658904865298;
        Tue, 26 Jul 2022 23:54:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ttURj45GmcmCgoN2FKc6GWCz8LkXqzyZdtKzxRJrMdQxqQdaeJO3NTVt7BKYcs5Xma4dyLVruOhUvtrT/gPDo=
X-Received: by 2002:a17:907:2e01:b0:72b:764f:ea1a with SMTP id
 ig1-20020a1709072e0100b0072b764fea1amr16740638ejc.666.1658904864824; Tue, 26
 Jul 2022 23:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com> <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com> <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com> <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com> <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220727015626-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Jul 2022 14:54:13 +0800
Message-ID: <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> >
> > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > Sent: Tuesday, July 26, 2022 10:53 PM
> > >
> > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > > >>
> > > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > >>>>> When the user space which invokes netlink commands, detects tha=
t
> > > >> _MQ
> > > >>>> is not supported, hence it takes max_queue_pair =3D 1 by itself.
> > > >>>> I think the kernel module have all necessary information and it =
is
> > > >>>> the only one which have precise information of a device, so it
> > > >>>> should answer precisely than let the user space guess. The kerne=
l
> > > >>>> module should be reliable than stay silent, leave the question t=
o
> > > >>>> the user space
> > > >> tool.
> > > >>> Kernel is reliable. It doesn=E2=80=99t expose a config space fiel=
d if the
> > > >>> field doesn=E2=80=99t
> > > >> exist regardless of field should have default or no default.
> > > >> so when you know it is one queue pair, you should answer one, not =
try
> > > >> to guess.
> > > >>> User space should not guess either. User space gets to see if _MQ
> > > >> present/not present. If _MQ present than get reliable data from ke=
rnel.
> > > >>> If _MQ not present, it means this device has one VQ pair.
> > > >> it is still a guess, right? And all user space tools implemented t=
his
> > > >> feature need to guess
> > > > No. it is not a guess.
> > > > It is explicitly checking the _MQ feature and deriving the value.
> > > > The code you proposed will be present in the user space.
> > > > It will be uniform for _MQ and 10 other features that are present n=
ow and
> > > in the future.
> > > MQ and other features like RSS are different. If there is no _RSS_XX,=
 there
> > > are no attributes like max_rss_key_size, and there is not a default v=
alue.
> > > But for MQ, we know it has to be 1 wihtout _MQ.
> > "we" =3D user space.
> > To keep the consistency among all the config space fields.
>
> Actually I looked and the code some more and I'm puzzled:
>
>
>         struct virtio_net_config config =3D {};
>         u64 features;
>         u16 val_u16;
>
>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>
>         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac=
),
>                     config.mac))
>                 return -EMSGSIZE;
>
>
> Mac returned even without VIRTIO_NET_F_MAC
>
>
>         val_u16 =3D le16_to_cpu(config.status);
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>                 return -EMSGSIZE;
>
>
> status returned even without VIRTIO_NET_F_STATUS
>
>         val_u16 =3D le16_to_cpu(config.mtu);
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
>
> MTU returned even without VIRTIO_NET_F_MTU
>
>
> What's going on here?

Probably too late to fix, but this should be fine as long as all
parents support STATUS/MTU/MAC.

I wonder if we can add a check in the core and fail the device
registration in this case.

Thanks

>
>
> --
> MST
>

