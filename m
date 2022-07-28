Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6135838EE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiG1GmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiG1Gll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DD675073E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658990499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0nLqK3EsWc2TxymPgSpCGcvke66TRrVDQKW7puuQXU=;
        b=bHC3W8wdU5lyODw9S6HGcnEG3RqF0OTHmR0L5p0MP+attOouvZ/y3/tb/G+JTYsB6LOFc7
        BaaUCHlZPBaucxsaUMuzvSM7Ei531JPaOyup33EOEyVg3cPKVOZDXKFzqUlM8brVT1Yr4Z
        fr1inbiNwwGfajKwt/qd5mYQuZqILXE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-NqZwv_wVN9C1B-02KULjzw-1; Thu, 28 Jul 2022 02:41:37 -0400
X-MC-Unique: NqZwv_wVN9C1B-02KULjzw-1
Received: by mail-wr1-f70.google.com with SMTP id h9-20020adfa4c9000000b0021ee4a48ea7so103320wrb.10
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=g0nLqK3EsWc2TxymPgSpCGcvke66TRrVDQKW7puuQXU=;
        b=vyBdBAqUlR3B2EFqtGgX/gtExzsD5EB8UPKW3Z+aOsT+dAEm0qC2yqf6WvBpv9CFLD
         ckzQTO0VfwhsM9ehNlkXvwk979Q4Obvxvgl6voMBRNN3ufjCYGBv5H6Knzero94RNMJL
         PURaFpKTrhhShvcoEqd54I7kT2G06c4OxGQgygj+g2+i0m42NRwp/Eb0fkawZEkdNakg
         3xBOR7M8gbEAYGNj4C8Y6kp7mrHmyi+bZZhImWuMyhqxAq1RG3JONLo6dfBimCbP/z3U
         5oejhuteXCYqb1ykKH+oKdg4VrmohH4fTGS977zv1zVXVmCyiw/ovdTY4fseJDfvrIzn
         xAKQ==
X-Gm-Message-State: AJIora9zSF5O5ebvR3XWzRNcKP1RKv2ckqSAuQNIJx3V7SMfHiLh9bYL
        fV9O/zsVybsh5xSQ5DADJo1i1AQgaw6HOhRaNvjJ4Tvdw84jbYkC9knQnGvRPnXmgWtlEvtcMdi
        Ta0HbHSPxaAeM+FcZ
X-Received: by 2002:a05:6000:70d:b0:21e:62f1:532c with SMTP id bs13-20020a056000070d00b0021e62f1532cmr15838246wrb.689.1658990496306;
        Wed, 27 Jul 2022 23:41:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t4ZbFr2xW+ouVOofJzRf07pj1wmzyAkg2f5rRKfrlNv7o0ME9aFNF8AdV0+fJKAI3EmoE38Q==
X-Received: by 2002:a05:6000:70d:b0:21e:62f1:532c with SMTP id bs13-20020a056000070d00b0021e62f1532cmr15838233wrb.689.1658990496036;
        Wed, 27 Jul 2022 23:41:36 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id d10-20020adffbca000000b0021e4f446d43sm18212wrs.58.2022.07.27.23.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 23:41:35 -0700 (PDT)
Date:   Thu, 28 Jul 2022 02:41:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220728024111-mutt-send-email-mst@kernel.org>
References: <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org>
 <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
 <20220727114419-mutt-send-email-mst@kernel.org>
 <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
 <459524bc-0e21-422b-31c1-39745fd25fac@intel.com>
 <CACGkMEu76TtzXRkv_daoHCY9gZ0ikbFBHD+gRz8KNMdeKiGArg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu76TtzXRkv_daoHCY9gZ0ikbFBHD+gRz8KNMdeKiGArg@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 01:53:51PM +0800, Jason Wang wrote:
> On Thu, Jul 28, 2022 at 11:47 AM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >
> >
> >
> > On 7/28/2022 9:21 AM, Jason Wang wrote:
> > > On Wed, Jul 27, 2022 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >> On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
> > >>> On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >>>> On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> > >>>>> On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > >>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
> > >>>>>>>>
> > >>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > >>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
> > >>>>>>>>>>
> > >>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > >>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > >>>>>>>>>>>>> When the user space which invokes netlink commands, detects that
> > >>>>>>>>>> _MQ
> > >>>>>>>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
> > >>>>>>>>>>>> I think the kernel module have all necessary information and it is
> > >>>>>>>>>>>> the only one which have precise information of a device, so it
> > >>>>>>>>>>>> should answer precisely than let the user space guess. The kernel
> > >>>>>>>>>>>> module should be reliable than stay silent, leave the question to
> > >>>>>>>>>>>> the user space
> > >>>>>>>>>> tool.
> > >>>>>>>>>>> Kernel is reliable. It doesn’t expose a config space field if the
> > >>>>>>>>>>> field doesn’t
> > >>>>>>>>>> exist regardless of field should have default or no default.
> > >>>>>>>>>> so when you know it is one queue pair, you should answer one, not try
> > >>>>>>>>>> to guess.
> > >>>>>>>>>>> User space should not guess either. User space gets to see if _MQ
> > >>>>>>>>>> present/not present. If _MQ present than get reliable data from kernel.
> > >>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
> > >>>>>>>>>> it is still a guess, right? And all user space tools implemented this
> > >>>>>>>>>> feature need to guess
> > >>>>>>>>> No. it is not a guess.
> > >>>>>>>>> It is explicitly checking the _MQ feature and deriving the value.
> > >>>>>>>>> The code you proposed will be present in the user space.
> > >>>>>>>>> It will be uniform for _MQ and 10 other features that are present now and
> > >>>>>>>> in the future.
> > >>>>>>>> MQ and other features like RSS are different. If there is no _RSS_XX, there
> > >>>>>>>> are no attributes like max_rss_key_size, and there is not a default value.
> > >>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
> > >>>>>>> "we" = user space.
> > >>>>>>> To keep the consistency among all the config space fields.
> > >>>>>> Actually I looked and the code some more and I'm puzzled:
> > >>>>>>
> > >>>>>>
> > >>>>>>          struct virtio_net_config config = {};
> > >>>>>>          u64 features;
> > >>>>>>          u16 val_u16;
> > >>>>>>
> > >>>>>>          vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > >>>>>>
> > >>>>>>          if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> > >>>>>>                      config.mac))
> > >>>>>>                  return -EMSGSIZE;
> > >>>>>>
> > >>>>>>
> > >>>>>> Mac returned even without VIRTIO_NET_F_MAC
> > >>>>>>
> > >>>>>>
> > >>>>>>          val_u16 = le16_to_cpu(config.status);
> > >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > >>>>>>                  return -EMSGSIZE;
> > >>>>>>
> > >>>>>>
> > >>>>>> status returned even without VIRTIO_NET_F_STATUS
> > >>>>>>
> > >>>>>>          val_u16 = le16_to_cpu(config.mtu);
> > >>>>>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > >>>>>>                  return -EMSGSIZE;
> > >>>>>>
> > >>>>>>
> > >>>>>> MTU returned even without VIRTIO_NET_F_MTU
> > >>>>>>
> > >>>>>>
> > >>>>>> What's going on here?
> > >>>>> Probably too late to fix, but this should be fine as long as all
> > >>>>> parents support STATUS/MTU/MAC.
> > >>>> Why is this too late to fix.
> > >>> If we make this conditional on the features. This may break the
> > >>> userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
> > >>>
> > >>> Thanks
> > >> Well only on devices without MTU. I'm saying said userspace
> > >> was reading trash on such devices anyway.
> > > It depends on the parent actually. For example, mlx5 query the lower
> > > mtu unconditionally:
> > >
> > >          err = query_mtu(mdev, &mtu);
> > >          if (err)
> > >                  goto err_alloc;
> > >
> > >          ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, mtu);
> > >
> > > Supporting MTU features seems to be a must for real hardware.
> > > Otherwise the driver may not work correctly.
> > >
> > >> We don't generally maintain bug for bug compatiblity on a whim,
> > >> only if userspace is actually known to break if we fix a bug.
> > >   So I think it should be fine to make this conditional then we should
> > > have a consistent handling of other fields like MQ.
> > For some fields that have a default value, like MQ =1, we can return the
> > default value.
> > For other fields without a default value, like MAC, we return nothing.
> >
> > Does this sounds good? So, for MTU, if without _F_MTU, I think we can
> > return 1500 by default.
> 
> Or we can just read MTU from the device.
> 
> But It looks to me Michael wants it conditional.
> 
> Thanks

I'm fine either way but let's keep it consistent. And I think
Parav wants it conditional.

> >
> > Thanks,
> > Zhu Lingshan
> > >
> > > Thanks
> > >
> > >>
> > >>>>> I wonder if we can add a check in the core and fail the device
> > >>>>> registration in this case.
> > >>>>>
> > >>>>> Thanks
> > >>>>>
> > >>>>>>
> > >>>>>> --
> > >>>>>> MST
> > >>>>>>
> >

