Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361BC582379
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiG0JvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiG0JvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C90407673
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658915473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MmcnU9bKKlvtZ450kEDTGR935/iCiWC+HuQGNyiPCw0=;
        b=cO8uE1IYvIehgAbGBkVb+ANDA/rgB1plb7HlwSamyJ9ZCXlIQCsItnXjxh5FFSJw3JdwFB
        vqzedV7ZdTJ/g3hXU7er8rMP6Sy+2czZEnU5VnnjaBI6zB39o9ZYUt2zOKAHT2e5L3yECf
        AWgkxXfZ7RHAd6FlGHR5ULLPLwCygJQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-RY9-DN6HP4aSmk0JpSSavw-1; Wed, 27 Jul 2022 05:51:12 -0400
X-MC-Unique: RY9-DN6HP4aSmk0JpSSavw-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a056402270a00b0043c0fed89b9so4757379edd.15
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MmcnU9bKKlvtZ450kEDTGR935/iCiWC+HuQGNyiPCw0=;
        b=epVOlbpaYyqj9TTHx41IHTAKi1Of8lCx2LbKiqI2+qn6zyE0QMpxDE/U7QQ+SHpPUT
         I2tKEMM6mfqWwcsQabnwRny2O470huO05FBAt2ZV2rMnW44snxAOZoYSyYLZhWkPLtZb
         CHm23DwMHfU9S33t30yAmYHtqLAdoHiEPTxMNuNrWT+gLYPwHLZ+DfZT0nyIzM7uwjxW
         JIGSt/a0KPJbS7SxsE+4jt4iZrPSM9G0QBg6CjMrNt0+hvvHjRh+OEd4wqF/UQg4XUCn
         iNB2+/7laS6cx3ENVJoKhDHEmMYQ/cooXCdJ1fbB2exLKcxXPkIZlDJptAgmM3j9vZ2u
         7Kjw==
X-Gm-Message-State: AJIora8iNs8ObjIiwNp2zOBHtanvmR9i6EUjZWZRkNmPJbPOyhiIhr5E
        I/ztTqmyqNxFpCMLzzYuzANABF3v7Q12li/3U09l+gAQjcvgYJka/Hn2Okxoe+YKwvtBzaSibr2
        hGSmEAQzo8lhalbtS1DwcC1yiMVXxVEC/
X-Received: by 2002:a17:907:724c:b0:72e:e6fe:5ea4 with SMTP id ds12-20020a170907724c00b0072ee6fe5ea4mr17467462ejc.421.1658915471385;
        Wed, 27 Jul 2022 02:51:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNjQ/GrSbdNE6rF0h84DLE6uO7Ifs9fq1rTj001hSuJ5EvwewWjIs0wj69vzy25IAVNvHQApWd62YST1MulVk=
X-Received: by 2002:a17:907:724c:b0:72e:e6fe:5ea4 with SMTP id
 ds12-20020a170907724c00b0072ee6fe5ea4mr17467434ejc.421.1658915470909; Wed, 27
 Jul 2022 02:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com> <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com> <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com> <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org> <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220727050222-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Jul 2022 17:50:59 +0800
Message-ID: <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> > On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > > >
> > > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > > > > >>
> > > > > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > > > >>>>> When the user space which invokes netlink commands, detects=
 that
> > > > > >> _MQ
> > > > > >>>> is not supported, hence it takes max_queue_pair =3D 1 by its=
elf.
> > > > > >>>> I think the kernel module have all necessary information and=
 it is
> > > > > >>>> the only one which have precise information of a device, so =
it
> > > > > >>>> should answer precisely than let the user space guess. The k=
ernel
> > > > > >>>> module should be reliable than stay silent, leave the questi=
on to
> > > > > >>>> the user space
> > > > > >> tool.
> > > > > >>> Kernel is reliable. It doesn=E2=80=99t expose a config space =
field if the
> > > > > >>> field doesn=E2=80=99t
> > > > > >> exist regardless of field should have default or no default.
> > > > > >> so when you know it is one queue pair, you should answer one, =
not try
> > > > > >> to guess.
> > > > > >>> User space should not guess either. User space gets to see if=
 _MQ
> > > > > >> present/not present. If _MQ present than get reliable data fro=
m kernel.
> > > > > >>> If _MQ not present, it means this device has one VQ pair.
> > > > > >> it is still a guess, right? And all user space tools implement=
ed this
> > > > > >> feature need to guess
> > > > > > No. it is not a guess.
> > > > > > It is explicitly checking the _MQ feature and deriving the valu=
e.
> > > > > > The code you proposed will be present in the user space.
> > > > > > It will be uniform for _MQ and 10 other features that are prese=
nt now and
> > > > > in the future.
> > > > > MQ and other features like RSS are different. If there is no _RSS=
_XX, there
> > > > > are no attributes like max_rss_key_size, and there is not a defau=
lt value.
> > > > > But for MQ, we know it has to be 1 wihtout _MQ.
> > > > "we" =3D user space.
> > > > To keep the consistency among all the config space fields.
> > >
> > > Actually I looked and the code some more and I'm puzzled:
> > >
> > >
> > >         struct virtio_net_config config =3D {};
> > >         u64 features;
> > >         u16 val_u16;
> > >
> > >         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > >
> > >         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config=
.mac),
> > >                     config.mac))
> > >                 return -EMSGSIZE;
> > >
> > >
> > > Mac returned even without VIRTIO_NET_F_MAC
> > >
> > >
> > >         val_u16 =3D le16_to_cpu(config.status);
> > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > >                 return -EMSGSIZE;
> > >
> > >
> > > status returned even without VIRTIO_NET_F_STATUS
> > >
> > >         val_u16 =3D le16_to_cpu(config.mtu);
> > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > >                 return -EMSGSIZE;
> > >
> > >
> > > MTU returned even without VIRTIO_NET_F_MTU
> > >
> > >
> > > What's going on here?
> >
> > Probably too late to fix, but this should be fine as long as all
> > parents support STATUS/MTU/MAC.
>
> Why is this too late to fix.

If we make this conditional on the features. This may break the
userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?

Thanks

>
> > I wonder if we can add a check in the core and fail the device
> > registration in this case.
> >
> > Thanks
> >
> > >
> > >
> > > --
> > > MST
> > >
>

