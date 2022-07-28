Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF758384B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 07:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiG1FyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 01:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiG1FyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 01:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2EE65C957
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 22:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658987654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgQE2wM2FNpAW3eLmrmpqpr9v/ElGZjhWnf6p3EUXkg=;
        b=S9nn3dRqa9PZye5FwQrAv9w9BtBJFbBdHjU1SE0RJoJRxxIKh3UbUfW3n3MzzHdu3vhPSa
        jbVYMQ+ksMFLXrlEAJ+iPRdmBOIXGjojvP6A0UxdRmx02oznnLhGzeOp5to9KqxJcbgbJr
        L3/oOt/EpnVtmPmYLPCo3/fwQXi/jMU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-I3KmqXUeNQeGTYqIJJC5kA-1; Thu, 28 Jul 2022 01:54:05 -0400
X-MC-Unique: I3KmqXUeNQeGTYqIJJC5kA-1
Received: by mail-lj1-f198.google.com with SMTP id x7-20020a05651c104700b0025e2f0ded1fso70240ljm.23
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 22:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qgQE2wM2FNpAW3eLmrmpqpr9v/ElGZjhWnf6p3EUXkg=;
        b=ZmkhBIAdzbmHSYaJK3JVt7VvZ7PkE26acLi7uMtpDKjPmb33aqUl/BzLTBhaRkcWeQ
         100w7mYCDUaq8tUdjIYGV0KxpkumpOH3RYtq8LEGOcZRixpo07hL4ickP2srNoTaXtOE
         GJu9T+hQ9EP95JXawv8wAfQUfNGo3+vxLxH4WMbMa64O7hs/yr/8BUBVE5QnmTYpMUBv
         WegYv9xW7vlNHlp9pkoGGgVc4p7cIH7cGFou7zLGG2IDmzMmYFLlMlmuJO+9Lh0eLbXR
         ckt/Iqu7DvVNW9C47eoWlyFaz0UkQEyob3U+wrFUyVEuVPALFx7Ll7psl0z8aWViqxeV
         gF9Q==
X-Gm-Message-State: AJIora81C291a3YPtGEUKKanOivb8keQuKvTbB6slxc2i9Sa/fCuX2pF
        IAOZZnySw1et6tEMTlakdY+kONJvf7AFtzCqrbXY8XdSqsI11c2+DbaJsMNhlFU8CzMo8J2/v9x
        wXHOG3zR1qVxUOu6JcTe+fYKV4H+sum/0
X-Received: by 2002:ac2:4205:0:b0:48a:95e6:395c with SMTP id y5-20020ac24205000000b0048a95e6395cmr6100308lfh.238.1658987642848;
        Wed, 27 Jul 2022 22:54:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vXULqUEcG2w64dv5lL3Eo8TCtb9NC34nQdWZaMo4wsxGOGb29yK9YhpV+MyRyYkjtF18VkuSCV/NG7fMIGM3k=
X-Received: by 2002:ac2:4205:0:b0:48a:95e6:395c with SMTP id
 y5-20020ac24205000000b0048a95e6395cmr6100299lfh.238.1658987642385; Wed, 27
 Jul 2022 22:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com> <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com> <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org> <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org> <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
 <20220727114419-mutt-send-email-mst@kernel.org> <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
 <459524bc-0e21-422b-31c1-39745fd25fac@intel.com>
In-Reply-To: <459524bc-0e21-422b-31c1-39745fd25fac@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Jul 2022 13:53:51 +0800
Message-ID: <CACGkMEu76TtzXRkv_daoHCY9gZ0ikbFBHD+gRz8KNMdeKiGArg@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
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

On Thu, Jul 28, 2022 at 11:47 AM Zhu, Lingshan <lingshan.zhu@intel.com> wro=
te:
>
>
>
> On 7/28/2022 9:21 AM, Jason Wang wrote:
> > On Wed, Jul 27, 2022 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wr=
ote:
> >> On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
> >>> On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> >>>> On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> >>>>> On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> >>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> >>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
> >>>>>>>>
> >>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
> >>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
> >>>>>>>>>>
> >>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> >>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
> >>>>>>>>>>>>> When the user space which invokes netlink commands, detects=
 that
> >>>>>>>>>> _MQ
> >>>>>>>>>>>> is not supported, hence it takes max_queue_pair =3D 1 by its=
elf.
> >>>>>>>>>>>> I think the kernel module have all necessary information and=
 it is
> >>>>>>>>>>>> the only one which have precise information of a device, so =
it
> >>>>>>>>>>>> should answer precisely than let the user space guess. The k=
ernel
> >>>>>>>>>>>> module should be reliable than stay silent, leave the questi=
on to
> >>>>>>>>>>>> the user space
> >>>>>>>>>> tool.
> >>>>>>>>>>> Kernel is reliable. It doesn=E2=80=99t expose a config space =
field if the
> >>>>>>>>>>> field doesn=E2=80=99t
> >>>>>>>>>> exist regardless of field should have default or no default.
> >>>>>>>>>> so when you know it is one queue pair, you should answer one, =
not try
> >>>>>>>>>> to guess.
> >>>>>>>>>>> User space should not guess either. User space gets to see if=
 _MQ
> >>>>>>>>>> present/not present. If _MQ present than get reliable data fro=
m kernel.
> >>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
> >>>>>>>>>> it is still a guess, right? And all user space tools implement=
ed this
> >>>>>>>>>> feature need to guess
> >>>>>>>>> No. it is not a guess.
> >>>>>>>>> It is explicitly checking the _MQ feature and deriving the valu=
e.
> >>>>>>>>> The code you proposed will be present in the user space.
> >>>>>>>>> It will be uniform for _MQ and 10 other features that are prese=
nt now and
> >>>>>>>> in the future.
> >>>>>>>> MQ and other features like RSS are different. If there is no _RS=
S_XX, there
> >>>>>>>> are no attributes like max_rss_key_size, and there is not a defa=
ult value.
> >>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
> >>>>>>> "we" =3D user space.
> >>>>>>> To keep the consistency among all the config space fields.
> >>>>>> Actually I looked and the code some more and I'm puzzled:
> >>>>>>
> >>>>>>
> >>>>>>          struct virtio_net_config config =3D {};
> >>>>>>          u64 features;
> >>>>>>          u16 val_u16;
> >>>>>>
> >>>>>>          vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)=
);
> >>>>>>
> >>>>>>          if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(co=
nfig.mac),
> >>>>>>                      config.mac))
> >>>>>>                  return -EMSGSIZE;
> >>>>>>
> >>>>>>
> >>>>>> Mac returned even without VIRTIO_NET_F_MAC
> >>>>>>
> >>>>>>
> >>>>>>          val_u16 =3D le16_to_cpu(config.status);
> >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> >>>>>>                  return -EMSGSIZE;
> >>>>>>
> >>>>>>
> >>>>>> status returned even without VIRTIO_NET_F_STATUS
> >>>>>>
> >>>>>>          val_u16 =3D le16_to_cpu(config.mtu);
> >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>>>>>                  return -EMSGSIZE;
> >>>>>>
> >>>>>>
> >>>>>> MTU returned even without VIRTIO_NET_F_MTU
> >>>>>>
> >>>>>>
> >>>>>> What's going on here?
> >>>>> Probably too late to fix, but this should be fine as long as all
> >>>>> parents support STATUS/MTU/MAC.
> >>>> Why is this too late to fix.
> >>> If we make this conditional on the features. This may break the
> >>> userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
> >>>
> >>> Thanks
> >> Well only on devices without MTU. I'm saying said userspace
> >> was reading trash on such devices anyway.
> > It depends on the parent actually. For example, mlx5 query the lower
> > mtu unconditionally:
> >
> >          err =3D query_mtu(mdev, &mtu);
> >          if (err)
> >                  goto err_alloc;
> >
> >          ndev->config.mtu =3D cpu_to_mlx5vdpa16(mvdev, mtu);
> >
> > Supporting MTU features seems to be a must for real hardware.
> > Otherwise the driver may not work correctly.
> >
> >> We don't generally maintain bug for bug compatiblity on a whim,
> >> only if userspace is actually known to break if we fix a bug.
> >   So I think it should be fine to make this conditional then we should
> > have a consistent handling of other fields like MQ.
> For some fields that have a default value, like MQ =3D1, we can return th=
e
> default value.
> For other fields without a default value, like MAC, we return nothing.
>
> Does this sounds good? So, for MTU, if without _F_MTU, I think we can
> return 1500 by default.

Or we can just read MTU from the device.

But It looks to me Michael wants it conditional.

Thanks

>
> Thanks,
> Zhu Lingshan
> >
> > Thanks
> >
> >>
> >>>>> I wonder if we can add a check in the core and fail the device
> >>>>> registration in this case.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>>
> >>>>>> --
> >>>>>> MST
> >>>>>>
>

