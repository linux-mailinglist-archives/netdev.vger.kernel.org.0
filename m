Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1635863A9
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbiHAEvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbiHAEu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:50:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02A5FB863
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659329457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Ryt5J3yzqqdOrexOVDqNu+Le5htlDEXM2+NHWY7KGo=;
        b=CFPUULNgtUYLoejQeV90wqCUfbpGinFrGAnnFV+9GIX4g+pZDQNp1o/j+uM1wH5sMfQID7
        hg2UexSYzGJhNb1V5UUcnio4i8dCR1NChDfbSrgjuWL81hnNZ3FrSZxnM16HjHBuUWF575
        cGG+ejHFT9Vvww89vowiNGeYjqUkQSo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-FWUtNOcIPaaKeTaJwo4ZgQ-1; Mon, 01 Aug 2022 00:50:55 -0400
X-MC-Unique: FWUtNOcIPaaKeTaJwo4ZgQ-1
Received: by mail-ed1-f71.google.com with SMTP id z14-20020a05640240ce00b0043c25c21e94so6419034edb.14
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4Ryt5J3yzqqdOrexOVDqNu+Le5htlDEXM2+NHWY7KGo=;
        b=nvCXrwGRG03MJOlX9/4u7nhpRpwDiUEKB+OuJFX+qLd20MH1vDqflHgeqEatBv2btJ
         wvIhpJ04SfQADx2O7FqIM9nBh1gDi3I3fRfbyu/26DQDfCWM7M9qydqyWBXaEvNLFSgJ
         mFoqOYONjqZJ+bUL1PA6aP5fakNyyVS1nMkE6LMNDbDsxcI0k74HfXwrKHKEcqgiNFYx
         ULRTkcGnMnSDLYoocrR9SGREo5GIH5nYZqi3PbT0mcbEfODfcf39m8iGK7/83ZEJw1PP
         fpEPdl9rTJdpQUiyaM+gPdUY3c58mvmqS5+k8BvtHzw+bKUiTcDHdL3FfqFYE6hIl/yj
         tW4g==
X-Gm-Message-State: AJIora+q7sq7+pDfdm2syZqgAI+KXWWh1i+++WIQsqaw1gdIfIx5oxaY
        vGQleuxWuWLwyenzdXcJ8EvM5KwBteXBrI63JLdJY0GyXSZ0zBUk1PfJNNqCTCjqmAuZ2FU8z4o
        ednLDBzuEDklE42ISMpO/luvNCmxZPGC8
X-Received: by 2002:a17:907:2d23:b0:72b:7c6a:24c with SMTP id gs35-20020a1709072d2300b0072b7c6a024cmr10844657ejc.44.1659329454289;
        Sun, 31 Jul 2022 21:50:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sH+lIhZOpB9lCfREfJb6x/jvL61IYF2r9RdXMJRwFw2D9Yw+ehqNVuBnTCBa3NE3A2B6EQoIiHm09d++CQhbQ=
X-Received: by 2002:a17:907:2d23:b0:72b:7c6a:24c with SMTP id
 gs35-20020a1709072d2300b0072b7c6a024cmr10844644ejc.44.1659329454070; Sun, 31
 Jul 2022 21:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org> <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org> <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
 <20220727114419-mutt-send-email-mst@kernel.org> <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
 <459524bc-0e21-422b-31c1-39745fd25fac@intel.com> <CACGkMEu76TtzXRkv_daoHCY9gZ0ikbFBHD+gRz8KNMdeKiGArg@mail.gmail.com>
 <20220728024111-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220728024111-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 1 Aug 2022 12:50:42 +0800
Message-ID: <CACGkMEvO4cHE-_0nvT6oe6GmXukcpT=yZGM9SGpVGhjuxnTvTQ@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
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

On Thu, Jul 28, 2022 at 2:41 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jul 28, 2022 at 01:53:51PM +0800, Jason Wang wrote:
> > On Thu, Jul 28, 2022 at 11:47 AM Zhu, Lingshan <lingshan.zhu@intel.com>=
 wrote:
> > >
> > >
> > >
> > > On 7/28/2022 9:21 AM, Jason Wang wrote:
> > > > On Wed, Jul 27, 2022 at 11:45 PM Michael S. Tsirkin <mst@redhat.com=
> wrote:
> > > >> On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
> > > >>> On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> > > >>>> On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> > > >>>>> On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > > >>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > >>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > >>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
> > > >>>>>>>>
> > > >>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > >>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > >>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
> > > >>>>>>>>>>
> > > >>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > >>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > >>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > >>>>>>>>>>>>> When the user space which invokes netlink commands, det=
ects that
> > > >>>>>>>>>> _MQ
> > > >>>>>>>>>>>> is not supported, hence it takes max_queue_pair =3D 1 by=
 itself.
> > > >>>>>>>>>>>> I think the kernel module have all necessary information=
 and it is
> > > >>>>>>>>>>>> the only one which have precise information of a device,=
 so it
> > > >>>>>>>>>>>> should answer precisely than let the user space guess. T=
he kernel
> > > >>>>>>>>>>>> module should be reliable than stay silent, leave the qu=
estion to
> > > >>>>>>>>>>>> the user space
> > > >>>>>>>>>> tool.
> > > >>>>>>>>>>> Kernel is reliable. It doesn=E2=80=99t expose a config sp=
ace field if the
> > > >>>>>>>>>>> field doesn=E2=80=99t
> > > >>>>>>>>>> exist regardless of field should have default or no defaul=
t.
> > > >>>>>>>>>> so when you know it is one queue pair, you should answer o=
ne, not try
> > > >>>>>>>>>> to guess.
> > > >>>>>>>>>>> User space should not guess either. User space gets to se=
e if _MQ
> > > >>>>>>>>>> present/not present. If _MQ present than get reliable data=
 from kernel.
> > > >>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
> > > >>>>>>>>>> it is still a guess, right? And all user space tools imple=
mented this
> > > >>>>>>>>>> feature need to guess
> > > >>>>>>>>> No. it is not a guess.
> > > >>>>>>>>> It is explicitly checking the _MQ feature and deriving the =
value.
> > > >>>>>>>>> The code you proposed will be present in the user space.
> > > >>>>>>>>> It will be uniform for _MQ and 10 other features that are p=
resent now and
> > > >>>>>>>> in the future.
> > > >>>>>>>> MQ and other features like RSS are different. If there is no=
 _RSS_XX, there
> > > >>>>>>>> are no attributes like max_rss_key_size, and there is not a =
default value.
> > > >>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
> > > >>>>>>> "we" =3D user space.
> > > >>>>>>> To keep the consistency among all the config space fields.
> > > >>>>>> Actually I looked and the code some more and I'm puzzled:
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>          struct virtio_net_config config =3D {};
> > > >>>>>>          u64 features;
> > > >>>>>>          u16 val_u16;
> > > >>>>>>
> > > >>>>>>          vdpa_get_config_unlocked(vdev, 0, &config, sizeof(con=
fig));
> > > >>>>>>
> > > >>>>>>          if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeo=
f(config.mac),
> > > >>>>>>                      config.mac))
> > > >>>>>>                  return -EMSGSIZE;
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> Mac returned even without VIRTIO_NET_F_MAC
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>          val_u16 =3D le16_to_cpu(config.status);
> > > >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u1=
6))
> > > >>>>>>                  return -EMSGSIZE;
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> status returned even without VIRTIO_NET_F_STATUS
> > > >>>>>>
> > > >>>>>>          val_u16 =3D le16_to_cpu(config.mtu);
> > > >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u=
16))
> > > >>>>>>                  return -EMSGSIZE;
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> MTU returned even without VIRTIO_NET_F_MTU
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> What's going on here?
> > > >>>>> Probably too late to fix, but this should be fine as long as al=
l
> > > >>>>> parents support STATUS/MTU/MAC.
> > > >>>> Why is this too late to fix.
> > > >>> If we make this conditional on the features. This may break the
> > > >>> userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
> > > >>>
> > > >>> Thanks
> > > >> Well only on devices without MTU. I'm saying said userspace
> > > >> was reading trash on such devices anyway.
> > > > It depends on the parent actually. For example, mlx5 query the lowe=
r
> > > > mtu unconditionally:
> > > >
> > > >          err =3D query_mtu(mdev, &mtu);
> > > >          if (err)
> > > >                  goto err_alloc;
> > > >
> > > >          ndev->config.mtu =3D cpu_to_mlx5vdpa16(mvdev, mtu);
> > > >
> > > > Supporting MTU features seems to be a must for real hardware.
> > > > Otherwise the driver may not work correctly.
> > > >
> > > >> We don't generally maintain bug for bug compatiblity on a whim,
> > > >> only if userspace is actually known to break if we fix a bug.
> > > >   So I think it should be fine to make this conditional then we sho=
uld
> > > > have a consistent handling of other fields like MQ.
> > > For some fields that have a default value, like MQ =3D1, we can retur=
n the
> > > default value.
> > > For other fields without a default value, like MAC, we return nothing=
.
> > >
> > > Does this sounds good? So, for MTU, if without _F_MTU, I think we can
> > > return 1500 by default.
> >
> > Or we can just read MTU from the device.
> >
> > But It looks to me Michael wants it conditional.
> >
> > Thanks
>
> I'm fine either way but let's keep it consistent. And I think
> Parav wants it conditional.

Parav, what's your opinion here?

Michale spots some in-consistent stuffs, so I think we should either

1) make all conditional, so we should change both MTU and MAC

or

2) make them unconditional, so we should only change MQ

Thanks

>
> > >
> > > Thanks,
> > > Zhu Lingshan
> > > >
> > > > Thanks
> > > >
> > > >>
> > > >>>>> I wonder if we can add a check in the core and fail the device
> > > >>>>> registration in this case.
> > > >>>>>
> > > >>>>> Thanks
> > > >>>>>
> > > >>>>>>
> > > >>>>>> --
> > > >>>>>> MST
> > > >>>>>>
> > >
>

